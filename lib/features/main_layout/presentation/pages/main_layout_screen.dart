import 'package:flowers_app/config/services/exit_app_dialog.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flowers_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/di/di.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../categories/presentation/pages/categories_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../cubit/main_layout_cubit.dart';
import '../cubit/main_layout_event.dart';
import '../cubit/main_layout_state.dart';
import '../widgets/main_nav_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';

class MainLayoutScreen extends StatelessWidget {
  final int? initialIndex;
  final String? categoryId;

  const MainLayoutScreen({super.key, this.initialIndex, this.categoryId});

  static final List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<MainLayoutCubit>();
        if (initialIndex != null) {
          cubit.doEvent(
            ChangeIndexEvent(initialIndex!, categoryId: categoryId),
          );
        }
        return cubit;
      },
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (state.currentIndex != 0) {
                context.read<MainLayoutCubit>().doEvent(ChangeIndexEvent(0));
                return;
              }

              final shouldExit = await ExitAppDialog.show(context);
              if (shouldExit == true) {
                SystemNavigator.pop();
              }
            },
            child: Scaffold(
              body: IndexedStack(index: state.currentIndex, children: _screens),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.black10.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: state.currentIndex,
                  onTap: (index) {
                    context.read<MainLayoutCubit>().doEvent(
                      ChangeIndexEvent(index),
                    );
                    if (index == 2) {
                      context.read<CartBloc>().add(const GetCartEvent());
                    }
                  },
                  items: [
                    MainNavBarItem(
                      iconPath: AppIcons.home,
                      label: AppStrings.home.tr(),
                    ),
                    MainNavBarItem(
                      iconPath: AppIcons.categories,
                      label: AppStrings.categories.tr(),
                    ),
                    MainNavBarItem(
                      iconPath: AppIcons.cart,
                      label: AppStrings.cart.tr(),
                    ),
                    MainNavBarItem(
                      iconPath: AppIcons.profile,
                      label: AppStrings.profile.tr(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
