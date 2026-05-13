import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> productImageSlider;
  const ProductImageSlider({super.key, required this.productImageSlider});

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late final PageController _pageController;
  int currentIndex = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    startAutoSlider();
  }

  void startAutoSlider() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      currentIndex++;
      if (currentIndex >= widget.productImageSlider.length) {
        currentIndex = 0;
      }
      _pageController.animateToPage(
        currentIndex,
        duration: Duration(microseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.productImageSlider.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return CachedNetworkImage(
                imageUrl: widget.productImageSlider[index],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, _) {
                  return const Center(child: CircularProgressIndicator());
                },
                errorWidget: (_, _, _) {
                  return const Icon(
                    Icons.error_outline_outlined,
                    size: 55,
                    color: AppColors.error,
                  );
                },
              );
            },
          ),
          Positioned(
            top: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          Positioned(
            bottom: 20.h,
            left: 150.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.productImageSlider.length, (
                index,
              ) {
                final isSelected = currentIndex == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white90 : AppColors.white70,
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
