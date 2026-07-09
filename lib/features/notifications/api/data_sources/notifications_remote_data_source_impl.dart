import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/config/error_handler/error_handler.dart';
import 'package:flowers_app/core/utils/app_constants.dart';
import 'package:flowers_app/features/notifications/data/data_sources/notifications_remote_data_source_contract.dart';
import 'package:flowers_app/features/notifications/data/models/notification_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationsRemoteDataSourceContract)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSourceContract {
  final FirebaseFirestore _firestore;

  const NotificationsRemoteDataSourceImpl(this._firestore);

  DocumentReference<Map<String, dynamic>> _getUserDoc(String userId) {
    return _firestore.collection(AppConstants.usersCollection).doc(userId);
  }

  @override
  Future<BaseResponse<List<NotificationModel>>> getNotifications(
    String userId,
  ) {
    return ErrorHandler.handleApiCall(() async {
      final doc = await _getUserDoc(userId).get();

      if (!doc.exists || doc.data() == null) {
        return <NotificationModel>[];
      }

      final notifications =
          doc.data()![AppConstants.notificationsField] as List<dynamic>?;

      if (notifications == null || notifications.isEmpty) {
        return <NotificationModel>[];
      }

      return notifications
          .map(
            (item) => NotificationModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    });
  }
}
