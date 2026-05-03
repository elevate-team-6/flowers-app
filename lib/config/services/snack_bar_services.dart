import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SnackBarServices {
  // ── Success ──────────────────────────────────────────────────────────────
  static void showSuccessMessage(String msg) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 3),
      toastBuilder: (VoidCallback cancelFunc) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: msg.length > 80 ? 100 : 75,
            padding: const EdgeInsets.only(right: 8),
            margin: const EdgeInsets.only(left: 24, right: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Green left bar ─────────────────────────────────────────
                Container(
                  height: double.infinity,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF46C234),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),

                // ── Icon ───────────────────────────────────────────────────
                const SizedBox(width: 8),
                Lottie.asset(
                  'assets/images/Verified.json',
                  repeat: false,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),

                // ── Text ───────────────────────────────────────────────────
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Success',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        msg,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Divider ────────────────────────────────────────────────
                const VerticalDivider(thickness: 1, color: Colors.black12),

                // ── Close button ───────────────────────────────────────────
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black38,
                    size: 20,
                  ),
                  onPressed: cancelFunc,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Error ────────────────────────────────────────────────────────────────
  static void showErrorMessage(String msg) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 3),
      toastBuilder: (VoidCallback cancelFunc) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.maxFinite,
            height: msg.length > 80 ? 100 : 75,
            padding: const EdgeInsets.only(right: 8),
            margin: const EdgeInsets.only(left: 24, right: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // ── Red left bar ───────────────────────────────────────────
                Container(
                  height: double.infinity,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),

                // ── Icon ───────────────────────────────────────────────────
                const SizedBox(width: 8),
                Lottie.asset(
                  'assets/images/Error.json',
                  repeat: false,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),

                // ── Text ───────────────────────────────────────────────────
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        msg,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Divider ────────────────────────────────────────────────
                const VerticalDivider(thickness: 1, color: Colors.black12),

                // ── Close button ───────────────────────────────────────────
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black38,
                    size: 20,
                  ),
                  onPressed: cancelFunc,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
