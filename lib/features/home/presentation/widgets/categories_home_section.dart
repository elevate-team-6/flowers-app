import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/categories_shimmer.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/category_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_header_section.dart';
import 'package:flutter/material.dart';

class CategoriesHomeSection extends StatelessWidget {
  final HomeStates state;

  const CategoriesHomeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final categoriesState = state.categoreyState;

    if (categoriesState.isLoading) {
      return CategoriesShimmer();
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

    final categories = categoriesState.data!.categories;

    if (categories!.isEmpty) {
      return const SizedBox(
        height: 90,
        child: Center(child: Text(AppStrings.noCategoriesAvailable)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonHeaderSection(
          title: AppStrings.categories, // Or use AppStrings.categories
          onViewAll: () {
            Navigator.of(context).pushNamed(AppRoutes.category);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.category, arguments: category.id);
                },
                icon: Icons.local_florist, // Customize based on your entity
                label: category.name!,
              );
            },
          ),
        ),
      ],
    );
  }
}
