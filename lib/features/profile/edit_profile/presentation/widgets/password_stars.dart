import 'package:flutter/material.dart';

class PasswordStars extends StatelessWidget {
  final int length;

  const PasswordStars({super.key, this.length = 6});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          length,
          (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: Icon(Icons.star, size: 20),
          ),
        ),
      ),
    );
  }
}
