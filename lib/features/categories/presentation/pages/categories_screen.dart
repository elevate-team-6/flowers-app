import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_categories_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_tab_bar.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_cubit.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_floating_button.dart';
import 'package:flowers_app/features/categories/presentation/widgets/search_and_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatelessWidget {
  final String? initialCategoryId;

  const CategoriesScreen({super.key, this.initialCategoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CategoriesCubit>()
            ..doEvent(const GetCategoriesRequestedEvent()),
      child: _CategoriesScreenBody(initialCategory: initialCategoryId),
    );
  }
}

class _CategoriesScreenBody extends StatefulWidget {
  final String? initialCategory;

  const _CategoriesScreenBody({this.initialCategory});

  @override
  State<_CategoriesScreenBody> createState() => _CategoriesScreenBodyState();
}

class _CategoriesScreenBodyState extends State<_CategoriesScreenBody>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _isInitialIndexSet = false;
  List<dynamic> _lastCategories = [];

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      final index = _tabController!.index;
      final categoryId = (index == 0 || _lastCategories.isEmpty)
          ? null
          : _lastCategories[index - 1].id;

      context.read<CategoriesCubit>().doEvent(CategoryChangedEvent(categoryId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<CategoriesCubit, CategoriesStates>(
          builder: (context, state) {
            final categories = state.categoriesState.data?.categories ?? [];
            _lastCategories = categories; // تحديث المرجع دائماً

            return Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SearchAndFilterBar(
                    onFilterTap: () => _showFilterBottomSheet(context),
                    onSearchChanged: (value) {
                      context.read<CategoriesCubit>().doEvent(
                        SearchChangedEvent(value),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                if (state.categoriesState.isLoading)
                  const CustomCategoriesShimmer()
                else if (categories.isNotEmpty)
                  _buildTabBar(categories),
                SizedBox(height: 12.h),
                Expanded(child: _buildProductsSection(state)),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilterFloatingButton(
        onPressed: () => _showFilterBottomSheet(context),
      ),
    );
  }

  Widget _buildTabBar(List<dynamic> categories) {
    final List<String> allTabTitles = [
      AppStrings.all,
      ...categories.map((e) => e.name?.toString() ?? ''),
    ];
    _updateTabController(allTabTitles.length, categories);

    return CustomTabBar(tabs: allTabTitles, controller: _tabController!);
  }

  Widget _buildProductsSection(CategoriesStates state) {
    if (state.productsState.isLoading) {
      return const CustomProductsShimmer();
    } else if (state.productsState.data != null &&
        state.productsState.data!.isNotEmpty) {
      return CustomProductsGrid(
        products: state.productsState.data!,
        onTap: (product) {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: product.id,
          );
        },
        onAddToCart: (product) {
          // TODO: Implement add to cart logic
          // TODO: and this massage is temporary
          SnackBarServices.showSuccessMessage(
            '${product.title} added to cart! (Functionality coming soon)',
          );
        },
      );
    } else {
      return Center(child: Text(AppStrings.noProductsFound));
    }
  }

  void _updateTabController(int length, List<dynamic> categories) {
    if (_tabController?.length != length) {
      _tabController?.removeListener(_handleTabSelection);
      _tabController?.dispose();

      int initialIndex = 0;
      String? initialId;

      if (widget.initialCategory != null && !_isInitialIndexSet) {
        final index = categories.indexWhere(
          (c) =>
              c.id == widget.initialCategory ||
              c.name?.toLowerCase().trim() ==
                  widget.initialCategory?.toLowerCase().trim(),
        );
        if (index != -1) {
          initialIndex = index + 1;
          initialId = categories[index].id;
        }
        _isInitialIndexSet = true;
        context.read<CategoriesCubit>().doEvent(
          CategoryChangedEvent(initialId),
        );
      } else if (!_isInitialIndexSet) {
        _isInitialIndexSet = true;
        context.read<CategoriesCubit>().doEvent(
          const GetProductsRequestedEvent(),
        );
      }

      _tabController = TabController(
        length: length,
        vsync: this,
        initialIndex: initialIndex,
      );

      _tabController!.addListener(_handleTabSelection);
    }
  }

  void _showFilterBottomSheet(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final sortResult = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(initialSort: cubit.state.sort),
    );

    if (sortResult != null && mounted) {
      cubit.doEvent(FilterChangedEvent(sortResult));
    }
  }
}
