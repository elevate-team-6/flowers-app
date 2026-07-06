import 'dart:async';

// نخفي GeoPoint بتاع Firestore عشان مايتعارضش مع GeoPoint بتاع الـ domain.
import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/api/api_client/tracking_api_client.dart';
import 'package:flowers_app/features/tracking/data/data_sources/tracking_remote_data_source_contract.dart';
import 'package:flowers_app/features/tracking/data/models/route_response.dart';
import 'package:flowers_app/features/tracking/data/models/tracking_model.dart';
import 'package:flowers_app/features/tracking/domain/entities/tracking_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackingRemoteDataSourceContract)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSourceContract {
  final FirebaseFirestore _firestore;
  final TrackingApiClient _apiClient;

  const TrackingRemoteDataSourceImpl(this._firestore, this._apiClient);

  @override
  Stream<BaseResponse<TrackingModel>> getTracking(String orderId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .transform(
          StreamTransformer<
            DocumentSnapshot<Map<String, dynamic>>,
            BaseResponse<TrackingModel>
          >.fromHandlers(
            handleData: (snapshot, sink) {
              if (!snapshot.exists || snapshot.data() == null) {
                sink.add(
                  ErrorBaseResponse<TrackingModel>(
                    AppStrings.notFound.tr(),
                  ),
                );
                return;
              }

              try {
                final data = snapshot.data()!;
                // ⚠️ لوج مؤقت للديباج — نشيله بعد ما نتأكد من شكل الداتا.
                // ignore: avoid_print
                print(
                  '🛵 TRACKING RAW → status=${data[AppConstants.statusField]} '
                  'riderLocation=${data[AppConstants.riderLocationField]} '
                  '(type: ${data[AppConstants.riderLocationField].runtimeType})',
                );
                sink.add(
                  SuccessBaseResponse(
                    TrackingModel.fromJson(data),
                  ),
                );
              } catch (_) {
                sink.add(
                  ErrorBaseResponse<TrackingModel>(
                    AppStrings.unknownError.tr(),
                  ),
                );
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.add(
                ErrorBaseResponse<TrackingModel>(
                  AppStrings.unknownError.tr(),
                ),
              );
            },
          ),
        );
  }

  @override
  Future<BaseResponse<RouteResponse>> getRoute({
    required GeoPoint from,
    required GeoPoint to,
  }) {
    // OSRM بياخد الإحداثيات في الـ path بترتيب lon,lat لكل نقطة، مفصولين بـ ';'.
    final coordinates = '${from.long},${from.lat};${to.long},${to.lat}';

    return ErrorHandler.handleApiCall(() => _apiClient.getRoute(coordinates));
  }
}
