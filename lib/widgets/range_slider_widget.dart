import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PriceRangeSlider extends StatefulWidget {
  const PriceRangeSlider({super.key});

  @override
  PriceRangeSliderState createState() => PriceRangeSliderState();
}

class PriceRangeSliderState extends State<PriceRangeSlider> {
  SfRangeValues _values = const SfRangeValues(539.0, 1130.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Price Range',
          style: Constants.subHeadingStyle.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.fontSize18,
          ),
        ),
        AppSpaces.verticalSpace40,
        SfRangeSlider(
          min: 0.0,
          max: 1750.0,
          values: _values,
          interval: 350,
          showTicks: false,
          showLabels: false,
          enableTooltip: false,
          minorTicksPerInterval: 1,
          inactiveColor: AppColors.shadeGreyAccentColor300,
          activeColor: AppColors.blackAccentColor500,
          startThumbIcon: SvgPicture.asset('assets/icons/slide_icon.svg'),
          onChanged: (SfRangeValues newValues) {
            setState(() {
              _values = newValues;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '\$0',
              style: Constants.subHeadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.fontSize16,
                color: AppColors.shadeGreyAccentColor300,
              ),
            ),
            Text(
              '\$${_values.start.toInt()}',
              style: Constants.subHeadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.fontSize18,
                color: AppColors.blackAccentColor500,
              ),
            ),
            Text(
              '\$${_values.end.toInt()}',
              style: Constants.subHeadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.fontSize18,
                color: AppColors.blackAccentColor500,
              ),
            ),
            Text(
              '\$1750',
              style: Constants.subHeadingStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Sizes.fontSize16,
                color: AppColors.shadeGreyAccentColor300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
