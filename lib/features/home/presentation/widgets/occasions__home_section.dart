import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_header_section.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasion_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasions_home_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_empty_state_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionsHomeSection extends StatelessWidget {
  final HomeStates state;

  const OccasionsHomeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // final occasionsState = state.occasionsState;
    final occasionsState = (state as dynamic).occasionsState;

    if (occasionsState.isLoading) {
      return const OccasionsHomeShimmer();
    }

    if (occasionsState.errorMessage != null) {
      return SizedBox(
        height: 230.h,
        child: Center(child: Text(occasionsState.errorMessage!)),
      );
    }

    final occasions = occasionsState.data ?? [];

    if (occasions.isEmpty) {
      return SizedBox(
        height: 230.h,
        child: CustomEmptyStateView(
          message: AppStrings.noOccasionsAvailable.tr(),
          subtitle: AppStrings.noOccasionsAvailableSubtitle.tr(),
          imageSize: 100.w,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonHeaderSection(
          title: AppStrings.occasion.tr(),
          onViewAll: () {
            Navigator.of(context).pushNamed(AppRoutes.occasions);
          },
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const BouncingScrollPhysics(),
            itemCount: occasions.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final occasion = occasions[index];
              return OccasionCard(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.occasions, arguments: occasion.id);
                },
                imageUrl: occasion.image,
                label: occasion.name,
              );
            },
          ),
        ),
      ],
    );
  }
}
