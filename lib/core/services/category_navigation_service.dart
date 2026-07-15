import 'dart:async';
import 'package:injectable/injectable.dart';

@lazySingleton
class CategoryNavigationService {
  String? _currentCategoryId;
  String? get currentCategoryId => _currentCategoryId;

  final _controller = StreamController<String?>.broadcast();
  Stream<String?> get categoryStream => _controller.stream;

  void selectCategory(String? categoryId) {
    if (_currentCategoryId == categoryId) return;
    _currentCategoryId = categoryId;
    _controller.add(categoryId);
  }

  void reset() {
    selectCategory(null);
  }

  void dispose() {
    _controller.close();
  }
}
