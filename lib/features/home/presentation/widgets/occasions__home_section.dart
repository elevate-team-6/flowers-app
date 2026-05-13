import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_section_header.dart';
import 'package:flowers_app/features/home/presentation/widgets/occasion_card.dart';
import 'package:flutter/material.dart';

class OccasionsHomeSecion extends StatelessWidget {
  final HomeStates state;

  const OccasionsHomeSecion({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final occasionsState = state.occasionsState;

    if (occasionsState.isLoading) {
      return const SizedBox(
        height: 230,
        child: Center(child: CircularProgressIndicator()),
      );
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
        child: Center(child: Text("No recommendations available")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonSectionHeader(
          title: "occasions", // Or "Occasions"
          onViewAll: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: occasions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final occasion = occasions[index];
              return OccasionCard(
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
