import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:flowers_app/features/notifications/domain/repos/notifications_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationsRepoContract _repo;

  const GetNotificationsUseCase(this._repo);

  Future<BaseResponse<List<NotificationEntity>>> call() =>
      _repo.getNotifications();
}
