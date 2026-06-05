import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/checkout/presentation/widgets/custom_radio_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentCard extends StatelessWidget {
  final String paymentMethodName;
  final bool isSelected;
  final VoidCallback onTap;
  const PaymentCard({
    super.key,
    required this.isSelected,
    required this.paymentMethodName, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF535353).withValues(alpha: 0.12),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(paymentMethodName, style: AppTextStyles.black16400),
            ),
            CustomRadioButton(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}
