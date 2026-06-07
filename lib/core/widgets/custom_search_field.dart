import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchField extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final bool autoFocus;
  final String heroTag;

  const CustomSearchField({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSuffixTap,
    this.controller,
    this.autoFocus = false,
    this.heroTag = 'search_field_hero',
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: 48.h,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            autofocus: autoFocus,
            onChanged: onChanged,
            style: AppTextStyles.black14400,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: AppStrings.search.tr(),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  AppIcons.search,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: _buildSuffixIcon(),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    final currentController = controller;
    if (readOnly || currentController == null) return null;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: currentController,
      builder: (context, value, child) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            currentController.clear();
            if (onSuffixTap != null) onSuffixTap!();
          },
          child: Icon(Icons.cancel, color: AppColors.gray, size: 20.w),
        );
      },
    );
  }
}
