import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_cubit.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_event.dart';
import 'package:flowers_app/features/address_details/presentation/screens/address_details_listener.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_event.dart';
import 'package:flowers_app/features/home/presentation/view_model/cubit/home_view_model.dart';
import 'package:flowers_app/features/home/presentation/view_model/states/home_states.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_delivery_address_section.dart';
import 'package:flowers_app/features/home/presentation/widgets/home_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/best_sellers_home_section.dart';
import '../widgets/categories_home_section.dart';
import '../widgets/occasions__home_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AddressCubit>().doEvent(GetAddressesEvent());
    context.read<AddressDetailsCubit>().doEvent(
      InitializeAddressDetailsEvent(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AddressDetailsListener(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              HomeTopBar(),

              // Delivery Address
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 0),
                child: HomeDeliveryAddressSection(),
              ),

              SizedBox(height: 8.h),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),

                      // categories
                      BlocBuilder<HomeViewModel, HomeStates>(
                        buildWhen: (previous, current) =>
                            previous.categoryState != current.categoryState,
                        builder: (context, state) {
                          return CategoriesHomeSection(state: state);
                        },
                      ),
                      SizedBox(height: 24.h),
                      //best seller
                      BlocBuilder<HomeViewModel, HomeStates>(
                        buildWhen: (previous, current) =>
                            previous.bestSellerState != current.bestSellerState,
                        builder: (context, state) {
                          return BestSellersHomeSection(state: state);
                        },
                      ),

                      SizedBox(height: 24.h),

                      //occasions
                      BlocBuilder<HomeViewModel, HomeStates>(
                        buildWhen: (previous, current) =>
                            previous.occasionsState != current.occasionsState,
                        builder: (context, state) {
                          return OccasionsHomeSection(state: state);
                        },
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
