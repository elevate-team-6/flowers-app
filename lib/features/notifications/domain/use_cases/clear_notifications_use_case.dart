import 'package:flowers_app/config/base_response/base_response.dart';
import 'package:flowers_app/features/notifications/domain/repos/notifications_repo_contract.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ClearNotificationsUseCase {
  final NotificationsRepoContract _repo;

  const ClearNotificationsUseCase(this._repo);

  Future<BaseResponse<void>> call() async {
    return await _repo.clearNotifications();
  }
}
