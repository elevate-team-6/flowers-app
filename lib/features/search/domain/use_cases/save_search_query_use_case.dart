import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveSearchHistoryUseCase {
  final SearchRepo _repo;

  SaveSearchHistoryUseCase(this._repo);

  Future<void> call(List<String> history) {
    return _repo.saveSearchHistory(history);
  }
}
