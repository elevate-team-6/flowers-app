import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProductImageSlider extends StatefulWidget {
  final List<String> productImageSlider;

  const ProductImageSlider({super.key, required this.productImageSlider});

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  late final PageController _pageController;

  late final ValueNotifier<int> currentIndexNotifier;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    currentIndexNotifier = ValueNotifier(0);

    startAutoSlider();
  }

  void startAutoSlider() {
    timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;

      int nextIndex = currentIndexNotifier.value + 1;

      if (nextIndex >= widget.productImageSlider.length) {
        nextIndex = 0;
      }

      currentIndexNotifier.value = nextIndex;

      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    _pageController.dispose();

    currentIndexNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.productImageSlider.length,
            onPageChanged: (index) {
              currentIndexNotifier.value = index;
            },
            itemBuilder: (_, index) {
              return CachedNetworkImage(
                imageUrl: widget.productImageSlider[index],

                fit: BoxFit.cover,

                width: double.infinity,

                fadeInDuration: const Duration(milliseconds: 250),

                placeholder: (_, _) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,

                    highlightColor: Colors.grey.shade100,

                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  );
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
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),

          Positioned(
            bottom: 20.h,
            left: 150.w,
            child: ValueListenableBuilder<int>(
              valueListenable: currentIndexNotifier,
              builder: (_, currentIndex, _) {
                return Row(
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
                        color: isSelected
                            ? AppColors.white90
                            : AppColors.white70,

                        borderRadius: BorderRadius.circular(100),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
