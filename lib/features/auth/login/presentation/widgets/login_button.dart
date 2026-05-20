import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(AppStrings.login));
  }
}
