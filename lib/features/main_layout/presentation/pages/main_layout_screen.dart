import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/di/di.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../cart/presentation/pages/cart_screen.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../cubit/main_layout_cubit.dart';
import '../cubit/main_layout_intent.dart';
import '../cubit/main_layout_state.dart';
import '../widgets/main_nav_bar_item.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MainLayoutCubit>(),
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return Scaffold(
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
                onTap: (index) => context.read<MainLayoutCubit>().doIntent(
                  ChangeIndexIntent(index),
                ),
                items: [
                  MainNavBarItem(
                    iconPath: AppIcons.home,
                    label: AppStrings.home,
                  ),
                  MainNavBarItem(
                    iconPath: AppIcons.categories,
                    label: AppStrings.categories,
                  ),
                  MainNavBarItem(
                    iconPath: AppIcons.cart,
                    label: AppStrings.cart,
                  ),
                  MainNavBarItem(
                    iconPath: AppIcons.profile,
                    label: AppStrings.profile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
