import 'package:flowers_app/features/auth/signup/presentation/widgets/terms_section_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.termsAndConditions),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  SectionItem(
                    number: 1,
                    title: AppStrings.termsSection1Title,
                    body: AppStrings.termsSection1Body,
                  ),
                  Divider(height: 32.h, thickness: 0.5, color: Colors.black12),

                  SectionItem(
                    number: 2,
                    title: AppStrings.termsSection2Title,
                    body: AppStrings.termsSection2Body,
                  ),
                  Divider(height: 32.h, thickness: 0.5, color: Colors.black12),

                  SectionItem(
                    number: 3,
                    title: AppStrings.termsSection3Title,
                    body: AppStrings.termsSection3Body,
                  ),
                  Divider(height: 32.h, thickness: 0.5, color: Colors.black12),

                  SectionItem(
                    number: 4,
                    title: AppStrings.termsSection4Title,
                    body: AppStrings.termsSection4Body,
                  ),

                  SizedBox(height: 24.h),

                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      AppStrings.termsFooterNote,
                      style: AppTextStyles.gray12400.copyWith(
                        color: AppColors.pink70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.iAgree),
            ),
          ),
        ],
      ),
    );
  }
}
