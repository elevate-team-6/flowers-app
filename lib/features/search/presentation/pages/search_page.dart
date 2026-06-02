import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_cubit.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_state.dart';
import 'package:flowers_app/features/search/presentation/widgets/search_empty_state.dart';
import 'package:flowers_app/features/search/presentation/widgets/search_history_section.dart';
import 'package:flowers_app/features/search/presentation/widgets/search_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            SearchTopBar(
              controller: _searchController,
              onChanged: (value) {
                context.read<SearchCubit>().doEvent(
                  SearchQueryChangedEvent(value),
                );
              },
              onClear: () {
                context.read<SearchCubit>().doEvent(
                  const SearchQueryChangedEvent(''),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchStates>(
                builder: (context, state) {
                  if (state.searchQuery.isEmpty) {
                    return SearchHistorySection(
                      history: state.searchHistory,
                      onHistoryItemTap: (query) {
                        _searchController.text = query;
                        context.read<SearchCubit>().doEvent(
                          SearchQueryChangedEvent(query),
                        );
                      },
                    );
                  }

                  if (state.searchProductsState.isLoading) {
                    return const CustomProductsShimmer();
                  }

                  if (state.searchProductsState.data != null &&
                      state.searchProductsState.data!.isNotEmpty) {
                    return CustomProductsGrid(
                      products: state.searchProductsState.data!,
                      onTap: (product) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.productDetails,
                          arguments: product.id,
                        );
                      },
                    );
                  }

                  if (state.searchProductsState.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.w,
                            color: AppColors.gray,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.searchProductsState.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.gray),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<SearchCubit>().doEvent(
                                SearchQueryChangedEvent(_searchController.text),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(AppStrings.retry.tr()),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SearchEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
