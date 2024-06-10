import 'package:flutter/material.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';

Widget blackButton(String title) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.xl,
        vertical: Sizes.md,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: Sizes.fontSize14,
          ),
        ),
      ),
    ),
  );
}
