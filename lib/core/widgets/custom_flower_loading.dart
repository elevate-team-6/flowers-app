import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatefulWidget {
  final double speed;
  const LoadingDialog({super.key, this.speed = 1.5});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();

  static void show({BuildContext? context, double speed = 3}) {
    final ctx = context ?? AppRoutes.navigatorKey.currentContext;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      barrierColor: AppColors.black.withValues(alpha: 0.5),
      builder: (context) => LoadingDialog(speed: speed),
    );
  }

  static void hide({BuildContext? context}) {
    final ctx = context ?? AppRoutes.navigatorKey.currentContext;
    if (ctx != null && Navigator.canPop(ctx)) {
      Navigator.pop(ctx);
    }
  }
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          type: MaterialType.transparency, // يحل مشكلة الخط الأصفر تحت التكست
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Lottie.asset(
                    AppLottie.flowerLoading,
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = Duration(
                        milliseconds:
                            (composition.duration.inMilliseconds / widget.speed)
                                .round(),
                      );
                      _controller.repeat();
                    },
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
