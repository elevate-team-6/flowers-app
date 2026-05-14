import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

class HomeDeliveryAddressSection extends StatelessWidget {
  const HomeDeliveryAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, color: AppColors.black50, size: 16),
          SizedBox(width: 4),
          Text(
            AppStrings.deliverTo,
            style: TextStyle(fontSize: 13, color: AppColors.black50),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: AppColors.black50, size: 16),
        ],
      ),
    );
  }
}
