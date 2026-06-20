import 'package:flutter/material.dart';

import '../../../../config/services/auth_service.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_one_animation.dart';
import '../widgets/page_four_animation.dart';
import '../widgets/page_three_animation.dart';
import '../widgets/page_two_animation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await AuthService.setOnboardingCompleted();
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.white50, AppColors.lightPink],
          ),
        ),
        child: Stack(
          children: [
            // PageView
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              physics: const BouncingScrollPhysics(),
              children: [
                OnboardingPage(
                  animationWidget: PageOneAnimation(
                    isActive: _currentPage == 0,
                  ),
                  title: "Discover Beautiful Flowers",
                  description:
                      "Browse hundreds of fresh arrangements curated just for you",
                ),
                OnboardingPage(
                  animationWidget: PageTwoAnimation(
                    isActive: _currentPage == 1,
                  ),
                  title: "Order in a Tap",
                  description:
                      "Add to cart, choose your address, and checkout in seconds",
                ),
                OnboardingPage(
                  animationWidget: PageThreeAnimation(
                    isActive: _currentPage == 2,
                  ),
                  title: "Crafted With Care",
                  description:
                      "Every arrangement is prepared fresh with love, just for you",
                ),
                OnboardingPage(
                  animationWidget: PageFourAnimation(
                    isActive: _currentPage == 3,
                  ),
                  title: "Never Miss a Moment",
                  description:
                      "Get instant updates the moment your flowers are on their way",
                ),
              ],
            ),

            // Skip Button
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text("Skip", style: AppTextStyles.gray16500Poppins),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  OnboardingDots(currentIndex: _currentPage),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == 3 ? "Get Started 🌸" : "Next",
                      style: AppTextStyles.white16700Poppins,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
