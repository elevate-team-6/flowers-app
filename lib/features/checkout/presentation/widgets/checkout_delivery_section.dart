import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/services/remote_config_service.dart';
import 'package:flowers_app/core/utils/app_assets.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutDeliverySection extends StatelessWidget {
  const CheckoutDeliverySection({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryDate = DateTime.now().add(
      Duration(days: RemoteConfigService.deliveryDays),
    );

    final formattedDate = DateFormat(
      'dd MMM',
      context.locale.languageCode,
    ).format(deliveryDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.deliveryTime.tr(), style: AppTextStyles.black18500),
        SizedBox(height: 20.h),
        Row(
          children: [
            SvgPicture.asset(AppIcons.time),
            SizedBox(width: 6.w),
            Text(AppStrings.instant.tr(), style: AppTextStyles.black14600),
            Text(formattedDate, style: AppTextStyles.success14500),
          ],
        ),
      ],
    );
  }
}
