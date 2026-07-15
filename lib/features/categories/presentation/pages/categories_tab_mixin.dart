import 'dart:async';

import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/services/category_navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/categories_cubit.dart';
import '../view_model/categories_event.dart';

mixin CategoriesTabMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  TabController? tabController;
  bool isInitialIndexSet = false;
  bool _isProgrammaticChange = false;
  List<dynamic> lastCategories = [];
  StreamSubscription<String?>? _categorySubscription;

  @override
  void initState() {
    super.initState();
    _categorySubscription = getIt<CategoryNavigationService>().categoryStream
        .listen((id) {
          if (lastCategories.isNotEmpty) {
            syncTabWithId(id, lastCategories);
          }
        });
  }

  void handleTabSelection() {
    if (tabController != null && !tabController!.indexIsChanging) {
      if (_isProgrammaticChange) {
        _isProgrammaticChange = false;
        return;
      }

      final index = tabController!.index;
      final categoryId = (index == 0 || lastCategories.isEmpty)
          ? null
          : lastCategories[index - 1].id;

      context.read<CategoriesCubit>().doEvent(CategoryChangedEvent(categoryId));

      // Update service so Home and other parts know about the change
      getIt<CategoryNavigationService>().selectCategory(categoryId);
    }
  }

  int findCategoryIndex(String? id, List<dynamic> categories) {
    if (id == null) return -1;
    return categories.indexWhere(
      (c) =>
          c.id == id || c.name?.toLowerCase().trim() == id.toLowerCase().trim(),
    );
  }

  void syncTabWithId(String? id, List<dynamic> categories) {
    int targetIndex = 0; // "All" is at index 0
    String? finalCategoryId;

    if (id != null) {
      final index = findCategoryIndex(id, categories);
      if (index != -1) {
        targetIndex = index + 1;
        finalCategoryId = categories[index].id;
      }
    }

    if (tabController != null && tabController!.index != targetIndex) {
      _isProgrammaticChange = true;
      tabController!.animateTo(targetIndex);
      context.read<CategoriesCubit>().doEvent(
        CategoryChangedEvent(finalCategoryId),
      );
    }
  }

  void updateTabController(int length, List<dynamic> categories) {
    if (tabController?.length == length) return;

    tabController?.removeListener(handleTabSelection);
    tabController?.dispose();

    int initialIndex = 0;

    if (!isInitialIndexSet) {
      isInitialIndexSet = true;
      final pendingId = getIt<CategoryNavigationService>().currentCategoryId;
      final index = findCategoryIndex(pendingId, categories);

      if (index != -1) {
        initialIndex = index + 1;
        context.read<CategoriesCubit>().doEvent(
          CategoryChangedEvent(categories[index].id),
        );
      } else {
        context.read<CategoriesCubit>().doEvent(
          const GetProductsRequestedEvent(),
        );
      }
    }

    tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: initialIndex,
    )..addListener(handleTabSelection);
  }

  @override
  void dispose() {
    _categorySubscription?.cancel();
    tabController?.removeListener(handleTabSelection);
    tabController?.dispose();
    super.dispose();
  }
}
