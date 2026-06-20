import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../config/services/auth_service.dart';
import '../widgets/petals_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _petalsController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _subtitleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _subtitleFadeAnimation;

  final List<PetalData> _petals = [];

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    _setupPetals();
    _setupAnimations();
    _startAnimations();
    _navigateToNext();
  }

  void _setupPetals() {
    final random = math.Random();
    final List<Color> petalColors = [
      AppColors.pink20, // soft pink
      AppColors.pink30, // rose
      AppColors.pink10, // white-ish pink
    ];

    for (int i = 0; i < 18; i++) {
      _petals.add(
        PetalData(
          size: 8.0 + random.nextDouble() * 10.0,
          speed: 1.0 + random.nextDouble() * 1.5,
          drift: 20.0 + random.nextDouble() * 40.0,
          rotation: random.nextDouble() * math.pi * 2,
          startDelay: random.nextDouble(),
          color: petalColors[random.nextInt(petalColors.length)],
          horizontalOffset: random.nextDouble(),
        ),
      );
    }
  }

  void _setupAnimations() {
    // Petals continuous animation
    _petalsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Logo animation: ScaleTransition from 0.0 to 1.0 with elasticOut
    // Starts at 300ms delay, duration 1200ms
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoScaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // Text animation: Fade + Slide up
    // Starts at 800ms delay, duration 800ms
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_textController);
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Subtitle animation: FadeTransition
    // Starts at 1200ms delay, duration 600ms
    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_subtitleController);
  }

  void _startAnimations() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _subtitleController.forward();
    });
  }

  void _navigateToNext() async {
    final onboardingDone = await AuthService.isOnboardingCompleted();
    final isLoggedIn = await AuthService.isLoggedIn();
    await Future.delayed(const Duration(milliseconds: 3200));
    if (mounted) {
      if (!onboardingDone) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      } else {
        Navigator.pushReplacementNamed(
          context,
          isLoggedIn ? AppRoutes.mainLayout : AppRoutes.login,
        );
      }
    }
  }

  @override
  void dispose() {
    _petalsController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white50, // warm cream replacement
              AppColors.lightPink, // soft rose replacement
            ],
          ),
        ),
        child: Stack(
          children: [
            // Layer 1: Falling Petals
            CustomPaint(
              painter: PetalsPainter(
                animation: _petalsController,
                petals: _petals,
              ),
              size: Size.infinite,
            ),

            // Layer 2 & 3: Logo and Text
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: const Text('🌸', style: TextStyle(fontSize: 90)),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _textFadeAnimation,
                    child: SlideTransition(
                      position: _textSlideAnimation,
                      child: Text(
                        'Flowers',
                        style: AppTextStyles.primary38700Playfair,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _subtitleFadeAnimation,
                    child: Text(
                      'Fresh blooms, delivered',
                      style: AppTextStyles.gray14400PoppinsSpacing,
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
