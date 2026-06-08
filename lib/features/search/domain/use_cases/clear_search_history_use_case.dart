import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearSearchHistoryUseCase {
  final SearchRepo _repo;

  ClearSearchHistoryUseCase(this._repo);

  Future<void> call() {
    return _repo.clearSearchHistory();
  }
}
