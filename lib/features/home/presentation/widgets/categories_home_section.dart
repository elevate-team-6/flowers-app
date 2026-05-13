import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/category_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_section_header.dart';
import 'package:flutter/material.dart';

class CategoriesHomeSection extends StatelessWidget {
  final HomeStates state;

  const CategoriesHomeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final categoriesState = state.categoreyState;

    if (categoriesState.isLoading) {
      return const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (categoriesState.errorMessage != null) {
      return SizedBox(
        height: 90,
        child: Center(
          child: Text(
            categoriesState.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final categories = categoriesState.data ?? [];

    if (categories.isEmpty) {
      return const SizedBox(
        height: 90,
        child: Center(child: Text("No categories available")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonSectionHeader(
          title: "Categories", // Or use AppStrings.categories
          onViewAll: () {},
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                icon: Icons.local_florist, // Customize based on your entity
                label: category.name ?? 'Category',
              );
            },
          ),
        ),
      ],
    );
  }
}
