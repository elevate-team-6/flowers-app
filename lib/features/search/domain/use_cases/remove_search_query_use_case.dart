import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveSearchQueryUseCase {
  final SearchRepo _repo;

  RemoveSearchQueryUseCase(this._repo);

  Future<void> call(List<String> history, String query) async {
    final updatedHistory = List<String>.from(history)..remove(query);
    return _repo.saveSearchHistory(updatedHistory);
  }
}
