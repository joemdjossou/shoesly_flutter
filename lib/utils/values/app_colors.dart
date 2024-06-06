part of '../values.dart';

class AppColors {
  static final Color primaryBackgroundColor = HexColor.fromHex("E5E5E5");
  static final Color secondaryBackgroundColor = HexColor.fromHex("");
  static final Color primaryNeutral200 = HexColor.fromHex("E7E7E7");
  static final Color primaryNeutral100 = HexColor.fromHex("F3F3F3");
  static final Color secondaryAccentColor = HexColor.fromHex("C5EFF3");
  static final Color blackAccentColor500 = HexColor.fromHex("101010");
  static final Color shadeGreyAccentColor400 = HexColor.fromHex("6F6F6F");
  static final Color shadeGreyAccentColor300 = HexColor.fromHex("B7B7B7");
  static final Color greenTaleColor = HexColor.fromHex("648B8B");
  static final Color blueColor500 = HexColor.fromHex("2952CC");
  static final Color redColor500 = HexColor.fromHex("FF4C5E");

  static final List<Color> gradientColor = <Color>[
    // gradient the colors
    // 1st
    AppColors.secondaryAccentColor,
    // 2nd
    AppColors.primaryBackgroundColor,
  ];
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
