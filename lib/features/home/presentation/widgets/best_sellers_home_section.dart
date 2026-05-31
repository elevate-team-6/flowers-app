import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/best_seller_card.dart';
import 'package:flowers_app/features/home/presentation/widgets/best_seller_home_shimmer.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_common_header_section.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BestSellersHomeSection extends StatelessWidget {
  final HomeStates state;

  const BestSellersHomeSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bestSellerState = state.bestSellerState;

    if (bestSellerState.isLoading) {
      return const BestSellerHomeShimmer();
    }

    if (bestSellerState.errorMessage != null) {
      return SizedBox(
        height: 230,
        child: Center(child: Text(bestSellerState.errorMessage!)),
      );
    }

    final bestSellers = bestSellerState.data ?? [];

    if (bestSellers.isEmpty) {
      return SizedBox(
        height: 230,
        child: Center(child: Text(AppStrings.noBestSellersAvailable.tr())),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeCommonHeaderSection(
          title: AppStrings.bestSeller.tr(),
          onViewAll: () {
            Navigator.pushNamed(context, AppRoutes.bestSeller);
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: bestSellers.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = bestSellers[index];
              return BestSellerCard(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.productDetails, arguments: product.id);
                },
                imageUrl: product.imgCover,
                title: product.title,
                price: "${product.price} ${AppStrings.egp.tr()}",
              );
            },
          ),
        ),
      ],
    );
  }
}
