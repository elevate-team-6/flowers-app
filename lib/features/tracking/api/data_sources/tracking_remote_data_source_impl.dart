import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/tracking/data/data_sources/tracking_remote_data_source_contract.dart';
import 'package:flowers_app/features/tracking/data/models/tracking_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackingRemoteDataSourceContract)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSourceContract {
  final FirebaseFirestore _firestore;

  const TrackingRemoteDataSourceImpl(this._firestore);

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
                sink.add(
                  SuccessBaseResponse(
                    TrackingModel.fromJson(snapshot.data()!),
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
  Future<BaseResponse<void>> confirmDelivered(String orderId) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
            AppConstants.isUserConfirmedDeliverdField: true,
          });
      return const SuccessBaseResponse<void>(null);
    } catch (_) {
      return ErrorBaseResponse<void>(AppStrings.unknownError.tr());
    }
  }
}
