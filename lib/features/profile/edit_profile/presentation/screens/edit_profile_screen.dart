import 'dart:convert';
import 'dart:io';
import 'package:flowers_app/config/cache/secure_cache_helper.dart';
import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/config/services/snack_bar_services.dart';
import 'package:flowers_app/core/utils/app_keys.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/widgets/custom_flower_loading.dart';
import 'package:flowers_app/core/widgets/custom_select_gender_row.dart';
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
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  UserDto? currentUser;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final SecureCacheHelper cacheHelper = getIt<SecureCacheHelper>();

  String? selectedGender;
  File? selectedImage;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    firstNameController.addListener(_onChanged);
    lastNameController.addListener(_onChanged);
    phoneController.addListener(_onChanged);

    loadUserData();
  }

  void _onChanged() {
    setState(() {});
  }

  bool get isDataChanged {
    return firstNameController.text != currentUser?.firstName ||
        lastNameController.text != currentUser?.lastName ||
        phoneController.text != currentUser?.phone ||
        selectedGender != currentUser?.gender ||
        selectedImage != null;
  }

  Future<void> loadUserData() async {
    final userData = await cacheHelper.readData(key: AppKeys.userKey);

    if (userData != null) {
      currentUser = UserDto.fromJson(jsonDecode(userData));

      firstNameController.text = currentUser?.firstName ?? '';
      lastNameController.text = currentUser?.lastName ?? '';
      emailController.text = currentUser?.email ?? '';
      phoneController.text = currentUser?.phone ?? '';
      selectedGender = currentUser?.gender;
      setState(() {});
    }
  }

  @override
  void dispose() {
    firstNameController.removeListener(_onChanged);
    lastNameController.removeListener(_onChanged);
    phoneController.removeListener(_onChanged);
    emailController.dispose();
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileCubit, EditProfileState>(
      listenWhen: (previous, current) =>
          previous.editProfileState != current.editProfileState ||
          previous.uploadPhotoState != current.uploadPhotoState,
      listener: (context, state) async {
        if (state.uploadPhotoState.errorMessage != null) {
          SnackBarServices.showErrorMessage(
            state.uploadPhotoState.errorMessage!,
          );
        }
        if (state.uploadPhotoState.data != null) {
          final updatedDto = UserDto(
            firstName: currentUser?.firstName,
            lastName: currentUser?.lastName,
            email: currentUser?.email,
            gender: currentUser?.gender,
            phone: currentUser?.phone,
            photo: state.uploadPhotoState.data!,
          );

          await cacheHelper.writeData(
            key: AppKeys.userKey,
            value: jsonEncode(updatedDto.toJson()),
          );

          setState(() {
            currentUser = updatedDto;
          });

          SnackBarServices.showSuccessMessage('Photo updated successfully');
        }

        if (state.editProfileState.isLoading) {
          LoadingDialog.show(context: context);
        } else {
          LoadingDialog.hide(context: context);
        }

        if (state.editProfileState.errorMessage != null) {
          SnackBarServices.showErrorMessage(
            state.editProfileState.errorMessage!,
          );
        }

        if (state.editProfileState.data != null) {
          final updatedUser = state.editProfileState.data!;
          final updatedDto = UserDto(
            firstName: updatedUser.firstName,
            lastName: updatedUser.lastName,
            email: currentUser?.email,
            gender: updatedUser.gender,
            phone: updatedUser.phone,
            photo: updatedUser.image ?? currentUser?.photo,
          );

          await cacheHelper.writeData(
            key: AppKeys.userKey,
            value: jsonEncode(updatedDto.toJson()),
          );

          setState(() {
            currentUser = updatedDto;
            firstNameController.text = updatedUser.firstName ?? '';
            lastNameController.text = updatedUser.lastName ?? '';
            phoneController.text = updatedUser.phone ?? '';
            selectedGender = updatedUser.gender;
            selectedImage = null;
          });
          SnackBarServices.showSuccessMessage(AppStrings.editProfileSuccessfly);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.editProfile),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              if (currentUser == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    EditProfileImage(
                      image: currentUser?.photo ?? '',
                      selectedImage: selectedImage,
                      onImageSelected: (image) {
                        setState(() {
                          selectedImage = image;
                        });

                        context.read<EditProfileCubit>().doEvent(
                          UploadPhotoEvent(file: image),
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    Form(
                      key: formKey,
                      child: EditProfileForm(
                        firstNameController: firstNameController,
                        lastNameController: lastNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                      ),
                    ),

                    SizedBox(height: 20.w),

                    CustomSelectGenderRow(
                      selectedGender: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),

                    SizedBox(height: 30.h),

                    ElevatedButton(
                      onPressed: isDataChanged
                          ? () {
                              if (formKey.currentState!.validate()) {
                                context.read<EditProfileCubit>().doEvent(
                                  UpdateProfileEvent(
                                    request: EditProfileRequest(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      phone: phoneController.text,
                                      gender: selectedGender,
                                    ),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Text(AppStrings.update),
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
