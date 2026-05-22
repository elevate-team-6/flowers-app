import 'package:flowers_app/config/di/di.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/screens/edit_profile_screen.dart';
import 'package:flowers_app/features/profile/edit_profile/presentation/view_model/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileCubit>(),
      child: const EditProfileScreen(),
    );
    
  }
}
