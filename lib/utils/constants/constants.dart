part of '../values.dart';

class Constants {
  static TextStyle headingStyle = TextStyle(
    color: AppColors.blackAccentColor500,
    fontSize: Sizes.fontSize30,
    fontWeight: FontWeight.w700,
    textBaseline: TextBaseline.ideographic,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle subHeadingStyle = TextStyle(
    fontSize: Sizes.fontSize20,
    color: AppColors.blackAccentColor500,
    fontWeight: FontWeight.w700,
    textBaseline: TextBaseline.ideographic,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle textStyle = TextStyle(
    fontSize: Sizes.fontSize14,
    color: AppColors.blackAccentColor500,
    fontWeight: FontWeight.w300,
    textBaseline: TextBaseline.ideographic,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle floatingStyle = TextStyle(
    fontSize: Sizes.fontSize16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryNeutral100,
    textBaseline: TextBaseline.ideographic,
    overflow: TextOverflow.ellipsis,
  );
}
