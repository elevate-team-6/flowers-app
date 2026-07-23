import 'package:flowers_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLauncherService {
  ExternalLauncherService._();

  static Future<void> openWhatsApp({
    required BuildContext context,
    required String phone,
  }) async {
    final uri = Uri.parse('https://wa.me/$phone');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (context.mounted) {
          CustomSnackBar.showErrorMessage('Unable to open WhatsApp.');
        }
      }
    } catch (_) {
      if (context.mounted) {
        CustomSnackBar.showErrorMessage('Unable to open WhatsApp.');
      }
    }
  }

  static Future<void> makePhoneCall({
    required BuildContext context,
    required String phone,
  }) async {
    final uri = Uri(scheme: 'tel', path: phone);

    try {
      final launched = await launchUrl(uri);

      if (!launched) {
        if (context.mounted) {
          CustomSnackBar.showErrorMessage('Unable to open the phone dialer.');
        }
      }
    } catch (_) {
      if (context.mounted) {
        CustomSnackBar.showErrorMessage('Unable to open the phone dialer.');
      }
    }
  }
}
