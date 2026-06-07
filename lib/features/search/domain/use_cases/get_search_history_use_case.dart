import 'package:flowers_app/features/search/domain/repos/search_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSearchHistoryUseCase {
  final SearchRepo _repo;

  GetSearchHistoryUseCase(this._repo);

  Future<List<String>> call() {
    return _repo.getSearchHistory();
  }
}
