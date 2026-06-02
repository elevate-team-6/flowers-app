import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_cubit.dart';
import 'package:flowers_app/features/search/presentation/view_model/search_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> history;
  final Function(String) onHistoryItemTap;

  const SearchHistorySection({
    super.key,
    required this.history,
    required this.onHistoryItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Text(
          AppStrings.searchForAnyProduct.tr(),
          style: AppTextStyles.gray14400,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: AppTextStyles.black16600),
              TextButton(
                onPressed: () => context.read<SearchCubit>().doEvent(
                  const ClearSearchHistoryEvent(),
                ),
                child: Text(
                  AppStrings.clearAll.tr(),
                  style: AppTextStyles.primary12600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: history
                .map(
                  (query) => _HistoryChip(
                    query: query,
                    onTap: () => onHistoryItemTap(query),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String query;
  final VoidCallback onTap;

  const _HistoryChip({required this.query, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.white60),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(query, style: AppTextStyles.black14400),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => context.read<SearchCubit>().doEvent(
                RemoveSearchQueryEvent(query),
              ),
              child: Icon(Icons.close, size: 16.w, color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}
