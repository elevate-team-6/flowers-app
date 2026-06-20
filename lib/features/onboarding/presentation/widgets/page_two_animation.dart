import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class PageTwoAnimation extends StatefulWidget {
  final bool isActive;
  const PageTwoAnimation({super.key, required this.isActive});

  @override
  State<PageTwoAnimation> createState() => _PageTwoAnimationState();
}

class _PageTwoAnimationState extends State<PageTwoAnimation>
    with TickerProviderStateMixin {
  late AnimationController _flowerController;
  late AnimationController _cartController;
  late Animation<Offset> _flowerSlide;
  late Animation<double> _cartScale;

  @override
  void initState() {
    super.initState();
    _flowerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _cartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _flowerSlide =
        Tween<Offset>(
          begin: const Offset(-1.5, -1.0),
          end: const Offset(0, 0.4),
        ).animate(
          CurvedAnimation(parent: _flowerController, curve: Curves.easeInOut),
        );

    _cartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(_cartController);

    _flowerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          _cartController.forward();
        }
      }
    });

    _cartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted && widget.isActive) {
            _flowerController.reset();
            _cartController.reset();
            _flowerController.forward();
          }
        });
      }
    });

    if (widget.isActive) {
      _flowerController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PageTwoAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _flowerController.reset();
      _cartController.reset();
      _flowerController.forward();
    }
  }

  @override
  void dispose() {
    _flowerController.dispose();
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cart Icon
            Positioned(
              bottom: 40,
              child: ScaleTransition(
                scale: _cartScale,
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 100,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Flower Emoji
            SlideTransition(
              position: _flowerSlide,
              child: FadeTransition(
                opacity: _flowerController,
                child: const Text("🌸", style: TextStyle(fontSize: 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
