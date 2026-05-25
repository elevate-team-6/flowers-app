import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/auth/signup/presentation/widgets/terms_section_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static final List<String> _titles = [
    AppStrings.termsSection1Title.tr(),
    AppStrings.termsSection2Title.tr(),
    AppStrings.termsSection3Title.tr(),
    AppStrings.termsSection4Title.tr(),
  ];

  static final List<String> _bodies = [
    AppStrings.termsSection1Body.tr(),
    AppStrings.termsSection2Body.tr(),
    AppStrings.termsSection3Body.tr(),
    AppStrings.termsSection4Body.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.termsAndConditions.tr()),
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

                  ...List.generate(_titles.length, (index) {
                    return Column(
                      children: [
                        TermsSectionItem(
                          number: index + 1,
                          title: _titles[index],
                          body: _bodies[index],
                        ),
                        if (index < _titles.length - 1)
                          Divider(
                            height: 32.h,
                            thickness: 0.5,
                            color: Colors.black12,
                          ),
                      ],
                    );
                  }),

                  SizedBox(height: 24.h),

                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      AppStrings.termsFooterNote.tr(),
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
              child: Text(AppStrings.iAgree.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
