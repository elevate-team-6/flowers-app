import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  String? _selectedLanguage;

  late AnimationController _logoController;
  late AnimationController _fadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _welcomeFadeAnimation;
  late Animation<double> _chooseFadeAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _welcomeFadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
    );

    _chooseFadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(String langCode) async {
    setState(() {
      _selectedLanguage = langCode;
    });

    if (langCode == 'ar') {
      await context.setLocale(const Locale('ar'));
      getIt<FirebaseService>().updateUserLanguage('ar');
    } else {
      await context.setLocale(const Locale('en'));
      getIt<FirebaseService>().updateUserLanguage('en');
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
        child: SafeArea(
          child: Column(
            children: [
              // TOP SECTION
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: const Text('🌸', style: TextStyle(fontSize: 64)),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _fadeController,
                      child: Text(
                        "Flowers",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeTransition(
                      opacity: _welcomeFadeAnimation,
                      child: Text(
                        AppStrings.welcomeTitle.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: AppColors.black50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FadeTransition(
                      opacity: _chooseFadeAnimation,
                      child: Text(
                        AppStrings.chooseLanguage.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // MIDDLE SECTION
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LanguageCard(
                      label: AppStrings.english.tr(),
                      flag: '🇬🇧',
                      isSelected: _selectedLanguage == 'en',
                      onTap: () => _selectLanguage('en'),
                    ),
                    const SizedBox(width: 16),
                    _LanguageCard(
                      label: AppStrings.arabic.tr(),
                      flag: '🇪🇬',
                      isSelected: _selectedLanguage == 'ar',
                      onTap: () => _selectLanguage('ar'),
                    ),
                  ],
                ),
              ),

              // BOTTOM SECTION
              Expanded(
                flex: 1,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _selectedLanguage == null ? 0 : 1,
                    duration: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      onPressed: _selectedLanguage == null
                          ? null
                          : () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                'locale',
                                _selectedLanguage!,
                              );
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.onboarding,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(200, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        AppStrings.continueBtn.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

class _LanguageCard extends StatefulWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 140,
          height: 110,
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.pink10 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? AppColors.primary : AppColors.pink20,
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink10.withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: widget.isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: AppColors.black50,
                ),
              ),
              if (widget.isSelected)
                const AnimatedOpacity(
                  opacity: 1,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    '✓',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
