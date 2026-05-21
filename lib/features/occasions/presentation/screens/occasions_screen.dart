import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/core/widgets/custom_products_grid.dart';
import 'package:flowers_app/core/widgets/custom_products_shimmer.dart';
import 'package:flowers_app/core/widgets/custom_tab_bar.dart';
import 'package:flowers_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_cubit.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_events.dart';
import 'package:flowers_app/features/occasions/presentation/view_model/occasions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OccasionsScreen extends StatefulWidget {
  final String? initialOccasionId;
  const OccasionsScreen({super.key, this.initialOccasionId});

  @override
  State<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends State<OccasionsScreen>
    with TickerProviderStateMixin {
  late OccasionsCubit _cubit;
  late TabController _tabController;
  List<OccasionEntity> _occasions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _cubit = context.read<OccasionsCubit>()..doEvent(const GetOccasionsEvent());
  }

  void _onOccasionsLoaded(List<OccasionEntity> occasions) {
    if (occasions.isEmpty) return;
    if (_occasions.length == occasions.length) return;
    _occasions = occasions;
    _tabController.dispose();
    _tabController = TabController(length: occasions.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      _cubit.doEvent(GetProductsEvent(_occasions[_tabController.index].name));
    });

    int initialIndex = 0;
    if (widget.initialOccasionId != null) {
      final index = occasions.indexWhere(
        (o) => o.id == widget.initialOccasionId,
      );
      if (index >= 0) initialIndex = index;
    }

    _tabController.animateTo(initialIndex);
    _cubit.doEvent(GetProductsEvent(occasions[initialIndex].name));
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
          buildWhen: (prev, curr) =>
              prev.occasionsState.data != curr.occasionsState.data,
          builder: (context, state) {
            final occasions = state.occasionsState.data ?? [];

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onOccasionsLoaded(occasions);
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14.h),

                if (_tabController.length == occasions.length &&
                    occasions.isNotEmpty)
                  CustomTabBar(
                    tabs: occasions.map((o) => o.name).toList(),
                    controller: _tabController,
                  ),

                SizedBox(height: 14.h),

                Expanded(
                  child: BlocBuilder<OccasionsCubit, OccasionsState>(
                    buildWhen: (prev, curr) =>
                        prev.productsState != curr.productsState,
                    builder: (context, state) {
                      if (state.productsState.isLoading) {
                        return const CustomProductsShimmer();
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

                      return CustomProductsGrid(products: products);
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
