import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flowers_app/features/address/presentation/view_model/address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressSelectionDropdowns extends StatelessWidget {
  final AddressStates state;
  final bool isAr;
  final Function(String?) onGovernorateChanged;
  final Function(String?) onCityChanged;

  const AddressSelectionDropdowns({
    super.key,
    required this.state,
    required this.isAr,
    required this.onGovernorateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey('gov_${state.selectedGovernorateId}'),
                initialValue: state.selectedGovernorateId,
                isExpanded: true,
                hint: Text(
                  AppStrings.selectCity.tr(),
                  style: AppTextStyles.gray12400,
                ),
                decoration: InputDecoration(labelText: AppStrings.city.tr()),
                items: state.governoratesState.data
                    ?.map(
                      (gov) => DropdownMenuItem(
                        value: gov.id,
                        child: Text(
                          isAr ? gov.nameAr : gov.nameEn,
                          style: AppTextStyles.black14400,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onGovernorateChanged,
                validator: (val) =>
                    AppValidations.required(val, AppStrings.city.tr()),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                key: ValueKey('area_${state.selectedCityId}'),
                initialValue: state.selectedCityId,
                isExpanded: true,
                hint: Text(
                  AppStrings.selectArea.tr(),
                  style: AppTextStyles.gray12400,
                ),
                decoration: InputDecoration(labelText: AppStrings.area.tr()),
                items: state.citiesState.data
                    ?.map(
                      (city) => DropdownMenuItem(
                        value: city.id,
                        child: Text(
                          isAr ? city.nameAr : city.nameEn,
                          style: AppTextStyles.black14400,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onCityChanged,
                validator: (val) =>
                    AppValidations.required(val, AppStrings.area.tr()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
