import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_categories_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_tab_bar.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_cubit.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_event.dart';
import 'package:flowers_app/features/categories/presentation/view_model/categories_state.dart';
import 'package:flowers_app/features/categories/presentation/widgets/categories_products_section.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flowers_app/features/categories/presentation/widgets/filter_floating_button.dart';
import 'package:flowers_app/features/categories/presentation/widgets/search_and_filter_bar.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main_layout/presentation/cubit/main_layout_state.dart';
import 'categories_tab_mixin.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CategoriesCubit>()
            ..doEvent(const GetCategoriesRequestedEvent()),
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
    with TickerProviderStateMixin, CategoriesTabMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainLayoutCubit, MainLayoutState>(
      listenWhen: (previous, current) =>
          current.currentIndex == 1 &&
          (previous.currentIndex != 1 ||
              previous.categoryId != current.categoryId),
      listener: (context, state) {
        syncTabWithId(state.categoryId, lastCategories);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: BlocBuilder<CategoriesCubit, CategoriesStates>(
            builder: (context, state) {
              final categories = state.categoriesState.data ?? [];
              lastCategories = categories;

              return Column(
                children: [
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SearchAndFilterBar(
                      onFilterTap: () => _showFilterBottomSheet(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (state.categoriesState.isLoading)
                    const CustomCategoriesShimmer()
                  else if (categories.isNotEmpty)
                    _buildTabBar(categories),
                  SizedBox(height: 12.h),
                  Expanded(child: CategoriesProductsSection(state: state)),
                ],
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FilterFloatingButton(
          onPressed: () => _showFilterBottomSheet(context),
        ),
      ),
    );
  }

  Widget _buildTabBar(List<dynamic> categories) {
    final List<String> allTabTitles = [
      AppStrings.all.tr(),
      ...categories.map((e) => e.name?.toString() ?? ''),
    ];
    updateTabController(allTabTitles.length, categories);

    return CustomTabBar(tabs: allTabTitles, controller: tabController!);
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
