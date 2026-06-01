import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    required this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.labelText,
        hintStyle: AppTextStyles.gray12400,
        labelStyle: AppTextStyles.black14400,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20.sp,
            color: AppColors.black30,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: widget.textInputAction,
      validator: widget.validator,
    );
  }
}
