import 'package:flowers_app/core/utils/app_routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.changePassword),
          child: const Text('Test Change Password'),
        ),
      ),
    );
  }
}
