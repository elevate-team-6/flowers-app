import 'package:flowers_app/config/validations/app_validations.dart';
import 'package:flowers_app/core/utils/app_colors.dart';
import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flowers_app/core/utils/app_strings.dart';
import 'package:flowers_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => AppRoutes.navigatorKey.currentState!
              .pushReplacementNamed(AppRoutes.login),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
          ),
        ),
        title: Text(AppStrings.password, style: AppTextStyles.black20500),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 24),
            Text(
              AppStrings.forgetPasswordTitle,
              style: AppTextStyles.black18500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44),
              child: Text(
                AppStrings.forgetPasswordSubtitle,
                style: AppTextStyles.black13400,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32),
            Form(
              key: emailFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: AppStrings.enterYourEmail,
                      label: Text(
                        AppStrings.email,
                        style: AppTextStyles.black13400,
                      ),
                      floatingLabelStyle: AppTextStyles.black13400, //
                      filled: false, //
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => AppValidations.validateEmail(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction, // =>>
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onChanged: (_) {},
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      if (emailFormKey.currentState!.validate()) {
                        AppRoutes.navigatorKey.currentState!.pushNamed(
                          AppRoutes.verifyResetCode,
                          arguments: emailController.text.trim(),
                        );
                      }
                    },
                    child: Text("confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
