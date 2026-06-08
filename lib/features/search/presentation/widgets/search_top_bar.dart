import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/widgets/custom_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTopBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchTopBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          ),
          Expanded(
            child: CustomSearchField(
              controller: controller,
              autoFocus: true,
              onChanged: onChanged,
              onSuffixTap: onClear,
            ),
          ),
        ],
      ),
    );
  }
}
