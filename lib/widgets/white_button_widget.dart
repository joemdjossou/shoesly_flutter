import 'package:flutter/material.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';

Widget whiteButton(String title) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.primaryBackgroundColor,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: AppColors.primaryNeutral200),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.xl,
        vertical: Sizes.md,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.blackAccentColor500,
            fontWeight: FontWeight.w700,
            fontSize: Sizes.fontSize14,
          ),
        ),
      ),
    ),
  );
}
