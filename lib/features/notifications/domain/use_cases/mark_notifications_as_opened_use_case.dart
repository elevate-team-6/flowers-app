import 'package:flowers_app/features/notifications/domain/repos/notifications_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class MarkNotificationsAsOpenedUseCase {
  final NotificationsRepoContract _repo;

  const MarkNotificationsAsOpenedUseCase(this._repo);

  Future<void> call() => _repo.markNotificationsAsOpened();
}
