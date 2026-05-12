import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/core/utils/app_custom_tab_bar.dart';
import 'package:flowers_app/core/utils/app_product_card.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_events.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_state.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_cubit.dart';
import 'package:flowers_app/features/occasions/presentation/widgets/occasions_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionsScreen extends StatefulWidget {
  const OccasionsScreen({super.key});

  @override
  State<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends State<OccasionsScreen>
    with TickerProviderStateMixin {
  late final OccasionsCubit _cubit;
  late TabController _tabController;
  List<OccasionEntity> _occasions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _cubit = context.read<OccasionsCubit>()..doEvent(const GetOccasionsEvent());
  }

  void _onOccasionsLoaded(List<OccasionEntity> occasions) {
    if (_occasions.length == occasions.length) return;
    _occasions = occasions;
    _tabController.dispose();
    _tabController = TabController(length: occasions.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      _cubit.doEvent(GetProductsEvent(_occasions[_tabController.index].name));
    });

    if (occasions.isNotEmpty) {
      _cubit.doEvent(GetProductsEvent(occasions.first.name));
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppStrings.occasion),
              Text(
                AppStrings.occasionSubtitle,
                style: AppTextStyles.black12400.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<OccasionsCubit, OccasionsState>(
          buildWhen: (prev, curr) => prev.occasionsState != curr.occasionsState,
          builder: (context, state) {
            final occasions = state.occasionsState.data ?? [];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onOccasionsLoaded(occasions);
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle
                SizedBox(height: 14.h),

                // TabBar
                if (_tabController.length == occasions.length &&
                    occasions.isNotEmpty)
                  AppCustomTabBar(
                    tabs: occasions.map((o) => o.name).toList(),
                    controller: _tabController,
                  ),
                SizedBox(height: 14.h),

                // Products
                Expanded(
                  child: BlocBuilder<OccasionsCubit, OccasionsState>(
                    buildWhen: (prev, curr) =>
                        prev.productsState != curr.productsState,
                    builder: (context, state) {
                      if (state.productsState.isLoading) {
                        return const OccasionsShimmer();
                      }

                      if (state.productsState.errorMessage != null) {
                        return Center(
                          child: Text(
                            state.productsState.errorMessage!,
                            style: AppTextStyles.black16400,
                          ),
                        );
                      }

                      final products = state.productsState.data ?? [];

                      if (products.isEmpty &&
                          state.occasionsState.data != null) {
                        return Center(
                          child: Text(
                            AppStrings.noProductsFound,
                            style: AppTextStyles.black16400,
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return AppProductCard(
                            imgCover: product.imgCover,
                            title: product.title,
                            price: product.price,
                            priceAfterDiscount: product.priceAfterDiscount,
                            discount: product.discount,
                            onAddToCart: () {},
                            onTap: () {},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
