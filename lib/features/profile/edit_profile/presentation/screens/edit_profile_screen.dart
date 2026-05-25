import 'package:flowers_app/config/helpers/phone_extension.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/core/widgets/custom_gender_selector.dart';
import 'package:flowers_app/features/auth/login/data/models/login_response/user_dto.dart';
import 'package:flowers_app/features/profile/edit_profile/data/models/edit_profile_request/edit_profile_request.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_event.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_state.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/widgets/edit_profile_form.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/widgets/edit_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDto user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<EditProfileCubit>();

    cubit.initialize(widget.user);

    firstNameController.text =
        widget.user.firstName ?? '';

    lastNameController.text =
        widget.user.lastName ?? '';

    emailController.text =
        widget.user.email ?? '';

    phoneController.text =
        widget.user.phone ?? '';

    firstNameController.addListener(_onChanged);
    lastNameController.addListener(_onChanged);
    phoneController.addListener(_onChanged);
  }

  void _onChanged() {
    context.read<EditProfileCubit>().checkIfDataChanged(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phone: phoneController.text,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();

    return BlocListener<EditProfileCubit,
        EditProfileState>(
      listenWhen: (previous, current) {
        return previous.editProfileState !=
                current.editProfileState ||
            previous.uploadPhotoState !=
                current.uploadPhotoState;
      },
      listener: (context, state) {
        final isLoading =
            state.editProfileState.isLoading ||
                state.uploadPhotoState.isLoading;

        if (isLoading) {
          LoadingDialog.show(context: context);
        } else {
          LoadingDialog.hide(context: context);
        }

        if (state.uploadPhotoState.errorMessage !=
            null) {
          SnackBarServices.showErrorMessage(
            state.uploadPhotoState.errorMessage!,
          );
        }

        if (state.editProfileState.errorMessage !=
            null) {
          SnackBarServices.showErrorMessage(
            state.editProfileState.errorMessage!,
          );
        }

        if (state.uploadPhotoState.data != null &&
            !state.editProfileState.isLoading) {
          cubit.clearUploadPhotoState();

          cubit.doEvent(
            UpdateProfileEvent(
              request: EditProfileRequest(
                firstName:
                    firstNameController.text.trim(),
                lastName:
                    lastNameController.text.trim(),
                phone: phoneController.text
                    .toEgyptianPhone(),
              ),
            ),
          );
        }

        if (state.editProfileState.data != null) {
          SnackBarServices.showSuccessMessage(
            AppStrings.editProfileSuccessfly,
          );

          cubit.clearEditProfileState();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.editProfile),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: BlocBuilder<EditProfileCubit,
              EditProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    EditProfileImage(
                      image: state.user?.photo ?? '',
                      selectedImage:
                          state.selectedImage,
                      onImageSelected: (image) {
                        cubit.changeImage(image);
                      },
                    ),

                    SizedBox(height: 50.h),

                    Form(
                      key: formKey,
                      child: EditProfileForm(
                        firstNameController:
                            firstNameController,
                        lastNameController:
                            lastNameController,
                        emailController:
                            emailController,
                        phoneController:
                            phoneController,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    CustomGenderSelector(
                      selectedGender:
                          state.user?.gender,
                    ),

                    SizedBox(height: 30.h),

                    ElevatedButton(
                      onPressed:
                          state.isDataChanged
                              ? () {
                                  if (formKey
                                      .currentState!
                                      .validate()) {
                                    if (state
                                            .selectedImage !=
                                        null) {
                                      cubit.doEvent(
                                        UploadPhotoEvent(
                                          file: state
                                              .selectedImage!,
                                        ),
                                      );
                                    } else {
                                      cubit.doEvent(
                                        UpdateProfileEvent(
                                          request:
                                              EditProfileRequest(
                                            firstName:
                                                firstNameController
                                                    .text
                                                    .trim(),
                                            lastName:
                                                lastNameController
                                                    .text
                                                    .trim(),
                                            phone:
                                                phoneController
                                                    .text
                                                    .toEgyptianPhone(),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                      child:
                          Text(AppStrings.update),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}