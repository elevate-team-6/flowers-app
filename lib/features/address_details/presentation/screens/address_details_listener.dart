import 'package:easy_localization/easy_localization.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_cubit.dart';
import 'package:flowers_app/features/address_details/presentation/view_model/address_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressDetailsListener extends StatelessWidget {
  final Widget child;

  const AddressDetailsListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressDetailsCubit, AddressDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AddressDetailsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.defaultAddressState.errorMessage ??
                    AppStrings.someThingWentWrong.tr(),
              ),
            ),
          );
        }
      },
      child: child,
    );
  }
}
