import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/features/home/presentation/view_model/cubit/home_view_model.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_delivery_address_section.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/best_sellers_home_section.dart';
import '../widgets/occasions__home_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            HomeTopBar(),

            // Delivery Address
            HomeDeliveryAddressSection(),

            const SizedBox(height: 8),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    //categories
                    // BlocBuilder<HomeViewModel, HomeStates>(
                    //   buildWhen: (previous, current) =>
                    //       previous.categoryState != current.categoryState,
                    //   builder: (context, state) {
                    //     return CategoriesHomeSection(state: state);
                    //   },
                    // ),
                    const SizedBox(height: 24),
                    //best seller
                    BlocBuilder<HomeViewModel, HomeStates>(
                      buildWhen: (previous, current) =>
                          previous.bestSellerState != current.bestSellerState,
                      builder: (context, state) {
                        return BestSellersHomeSection(state: state);
                      },
                    ),

                    const SizedBox(height: 24),

                    //occasions
                    BlocBuilder<HomeViewModel, HomeStates>(
                      buildWhen: (previous, current) =>
                          previous.occasionsState != current.occasionsState,
                      builder: (context, state) {
                        return OccasionsHomeSection(state: state);
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
