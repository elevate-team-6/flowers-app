import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/categories/data/models/request/get_products_params.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_tab_bar.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_cubit.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_floating_button.dart';
import 'package:flowers_app/features/categories/presentation/widgets/search_and_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoriesCubit>()
        ..doEvent(const GetCategoriesRequestedEvent())
        ..doEvent(const GetProductsRequestedEvent(params: GetProductsParams())),
      child: const _CategoriesScreenBody(),
    );
  }
}

class _CategoriesScreenBody extends StatefulWidget {
  const _CategoriesScreenBody();

  @override
  State<_CategoriesScreenBody> createState() => _CategoriesScreenBodyState();
}

class _CategoriesScreenBodyState extends State<_CategoriesScreenBody>
    with TickerProviderStateMixin {
  TabController? _tabController;
  String? _currentSort;
  String? _currentCategoryId;
  String? _searchQuery;

  void _initTabController(int length) {
    if (_tabController?.length != length) {
      _tabController?.dispose();
      _tabController = TabController(length: length, vsync: this);
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          setState(() {});
          // Finalized: Categories fetch products logic implemented below
          final categories = context
              .read<CategoriesCubit>()
              .state
              .categoriesState
              .data
              ?.categories;
          if (categories != null) {
            final index = _tabController!.index;
            if (index == 0) {
              context.read<CategoriesCubit>().doEvent(
                const GetProductsRequestedEvent(params: GetProductsParams()),
              );
            } else {
              final categoryId = categories[index - 1].id;
              context.read<CategoriesCubit>().doEvent(
                GetProductsRequestedEvent(
                  params: GetProductsParams(category: categoryId),
                ),
              );
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<CategoriesCubit, CategoriesStates>(
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SearchAndFilterBar(
                    onFilterTap: () => _showFilterBottomSheet(context),
                    onSearchChanged: (value) {
                      context.read<CategoriesCubit>().doEvent(
                        GetProductsRequestedEvent(
                          params: GetProductsParams(search: value),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
                if (state.categoriesState.isLoading)
                  SizedBox(
                    height: 40.h,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (state.categoriesState.data?.categories != null) ...[
                  Builder(
                    builder: (context) {
                      final categories =
                          state.categoriesState.data!.categories!;
                      final allTabs = [
                        AppStrings.all,
                        ...categories.map((e) => e.name ?? ''),
                      ];
                      _initTabController(allTabs.length);

                      return CustomTabBar(
                        tabs: allTabs,
                        controller: _tabController!,
                      );
                    },
                  ),
                ],
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

  Widget _buildProductsSection(CategoriesStates state) {
    if (state.productsState.isLoading) {
      return const CustomProductsShimmer();
    } else if (state.productsState.errorMessage != null) {
      return Center(
        child: Text(
          state.productsState.errorMessage!,
          style: AppTextStyles.primary12400,
        ),
      );
    } else if (state.productsState.data != null &&
        state.productsState.data!.isNotEmpty) {
      return CustomProductsGrid(
        products: state.productsState.data!,
        onAddToCart: (product) {
          // Handle add to cart
        },
      );
    } else {
      return Center(
        child: Text(AppStrings.noProductsFound, style: AppTextStyles.black16400),
      );
    }
  }

  void _showFilterBottomSheet(BuildContext context) async {
    final sortResult = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(initialSort: _currentSort),
    );

    if (sortResult != null && context.mounted) {
      setState(() {
        _currentSort = sortResult;
      });
      _fetchProducts();
    }
  }

  void _fetchProducts() {
    context.read<CategoriesCubit>().doEvent(
          GetProductsRequestedEvent(
            params: GetProductsParams(
              category: _currentCategoryId,
              sort: _currentSort,
              search: _searchQuery,
            ),
          ),
        );
  }
}
