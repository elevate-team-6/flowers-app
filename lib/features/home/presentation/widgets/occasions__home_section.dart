import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_header_section.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasion_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasions_home_shimmer.dart';
import 'package:flutter/material.dart';

class OccasionsHomeSecion extends StatelessWidget {
  final HomeStates state;

  const OccasionsHomeSecion({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final occasionsState = state.occasionsState;

    if (occasionsState.isLoading) {
      return const OccasionsHomeShimmer();
    }

    if (occasionsState.errorMessage != null) {
      return SizedBox(
        height: 230,
        child: Center(child: Text(occasionsState.errorMessage!)),
      );
    }

    final occasions = occasionsState.data ?? [];

    if (occasions.isEmpty) {
      return const SizedBox(
        height: 230,
        child: Center(child: Text(AppStrings.noOcassionsAvailable)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonHeaderSection(
          title: AppStrings.occasion,
          onViewAll: () {
            Navigator.of(context).pushNamed(AppRoutes.occasions);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: occasions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
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
