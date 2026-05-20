import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/categories_shimmer.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/category_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_header_section.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:flowers_app/features/main_layout/presentation/cubit/main_layout_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesHomeSection extends StatelessWidget {
  final HomeStates state;

  const CategoriesHomeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    // final categoriesState = state.categoryState;
    final categoriesState = (state as dynamic).categoryState;

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
      return SizedBox(
        height: 90,
        child: Center(child: Text(AppStrings.noCategoriesAvailable)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonHeaderSection(
          title: AppStrings.categories,
          onViewAll: () {
            context.read<MainLayoutCubit>().doEvent(ChangeIndexEvent(1));
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
                  context.read<MainLayoutCubit>().doEvent(
                    ChangeIndexEvent(1, categoryId: category.id),
                  );
                },
                imageUrl: category.image, // Customize based on your entity
                label: category.name!,
              );
            },
          ),
        ),
      ],
    );
  }
}
