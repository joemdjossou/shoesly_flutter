import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/models/brand_model.dart';
import 'package:shoesly_flutter/core/models/shoe_color.dart';
import 'package:shoesly_flutter/core/models/shoe_model.dart';
import 'package:shoesly_flutter/core/providers/brands_provider.dart';
import 'package:shoesly_flutter/core/providers/shoe_provider.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:shoesly_flutter/widgets/black_button_widget.dart';
import 'package:shoesly_flutter/widgets/range_slider_widget.dart';
import 'package:shoesly_flutter/widgets/white_button_widget.dart';

class FilterPage extends StatefulWidget {
  static const id = '/filter_page';
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late Shoe _shoeFiltered =
      Provider.of<ShoeProvider>(context, listen: false).shoeFiltered;
  List<Brand>? _brands = [];
  int _selectedSortByIndex = -1;
  int _selectedGenderIndex = -1;
  int _selectedColorIndex = -1;
  int _selectedBrandIndex = -1;
  List<ShoeColor> _shoeColors = [];
  String? _selectedColorName;
  List<String>? _brandNames;

  @override
  void initState() {
    _fetchShoeColors();
    _fetchBrandName();
    print(_shoeFiltered);
    print(_brandNames);
    super.initState();
  }

  Future<void> _fetchShoeColors() async {
    Shoe shoes = Provider.of<ShoeProvider>(context, listen: false).shoeFiltered;
    _shoeFiltered = shoes;
    final selectedShoe = _shoeFiltered;
    final colors = await selectedShoe.getShoeColors();
    setState(() {
      _shoeColors = colors;
    });
  }

  Future<void> _fetchBrandName() async {
    List<Brand>? brands =
        await Provider.of<BrandsProvider>(context, listen: false)
            .fetchDocuments();
    List<String> brandsName =
        Provider.of<BrandsProvider>(context, listen: false).brandsName;
    _brandNames = brandsName;
    setState(() {
      _brands = brands;
    });
    print(_brands);
  }

  @override
  Widget build(BuildContext context) {
    final selectedBrands = _brands;
    final selectedSortBy = <String>[
      'Most Recent',
      'Lowest Price',
      'Highest Reviews',
    ];

    final selectedGender = <String>[
      'Man',
      'Woman',
      'Unisex',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Filter",
          style: TextStyle(
            color: Colors.black,
            fontSize: Sizes.fontSize20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/arrow-left.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // body without the footer
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.fontSize30,
                  vertical: Sizes.fontSize30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brands
                    Text(
                      'Brands',
                      style: Constants.subHeadingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.fontSize18,
                      ),
                    ),

                    AppSpaces.verticalSpace30,

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            List.generate(selectedBrands!.length, (index) {
                          final brand = selectedBrands[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedBrandIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.sm,
                              ),
                              child: Column(
                                // the brands
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _selectedBrandIndex == index
                                          ? AppColors.blackAccentColor500
                                          : AppColors.primaryBackgroundColor,
                                      border: Border.all(
                                          color: AppColors.primaryNeutral200),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/${brand.name}Logo_black.svg',
                                        color: _selectedBrandIndex == index
                                            ? Colors.white
                                            : AppColors.blackAccentColor500,
                                      ),
                                    ),
                                  ),
                                  AppSpaces.verticalSpace10,
                                  Text(
                                    brand.name[0].toUpperCase() +
                                        brand.name.substring(1),
                                    style: Constants.subHeadingStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Sizes.fontSize18,
                                    ),
                                  ),
                                  AppSpaces.verticalSpace5,
                                  Text(
                                    '${brand.itemCount.toString()} Items',
                                    style: Constants.textStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.shadeGreyAccentColor300,
                                      fontSize: Sizes.fontSize12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSpaces.verticalSpace50,

                    // Slider
                    const PriceRangeSlider(),
                    AppSpaces.verticalSpace30,

                    // Sort By
                    Text(
                      'Sort By',
                      style: Constants.subHeadingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.fontSize18,
                      ),
                    ),

                    AppSpaces.verticalSpace30,

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(selectedSortBy.length, (index) {
                          final sortBy = selectedSortBy[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSortByIndex = index;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.sizeOf(context).width / 3.5,
                              height: MediaQuery.sizeOf(context).height / 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: _selectedSortByIndex == index
                                    ? AppColors.blackAccentColor500
                                    : AppColors.primaryBackgroundColor,
                                border: Border.all(
                                    color: AppColors.primaryNeutral200),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  sortBy.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: _selectedSortByIndex == index
                                        ? AppColors.primaryBackgroundColor
                                        : AppColors.blackAccentColor500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSpaces.verticalSpace30,

                    // Gender
                    Text(
                      'Gender',
                      style: Constants.subHeadingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.fontSize18,
                      ),
                    ),

                    AppSpaces.verticalSpace30,

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(selectedGender.length, (index) {
                          final gender = selectedGender[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGenderIndex = index;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.sizeOf(context).width / 3.5,
                              height: MediaQuery.sizeOf(context).height / 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: _selectedGenderIndex == index
                                    ? AppColors.blackAccentColor500
                                    : AppColors.primaryBackgroundColor,
                                border: Border.all(
                                    color: AppColors.primaryNeutral200),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  gender.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: _selectedGenderIndex == index
                                        ? AppColors.primaryBackgroundColor
                                        : AppColors.blackAccentColor500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSpaces.verticalSpace30,

                    // Color
                    Text(
                      'Color',
                      style: Constants.subHeadingStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.fontSize18,
                      ),
                    ),

                    AppSpaces.verticalSpace30,

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        // list generation through the shoeColor instances
                        children: List.generate(_shoeColors.length, (index) {
                          final shoeColor = _shoeColors[index];
                          final hexCode = shoeColor.hexCode;

                          // uses the HexColor class extension from Color for better accuracy
                          final colorValue = HexColor.fromHex(hexCode);
                          final isSelectedColor =
                              _selectedColorName == shoeColor.name;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColorName = shoeColor.name;
                                _selectedColorIndex = index;
                              });
                            },

                            //selection tile for the color
                            child: Container(
                              // defines the container with border that changes according to the index
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.sizeOf(context).width / 3.5,
                              height: MediaQuery.sizeOf(context).height / 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: AppColors.primaryBackgroundColor,
                                border: Border.all(
                                  color: _selectedColorIndex == index
                                      ? AppColors.blackAccentColor500
                                      : AppColors.primaryNeutral200,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),

                              // the color circle and the text
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.sm,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // color container
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: Sizes.sm),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: colorValue,
                                        shape: BoxShape.circle,
                                        border: colorValue ==
                                                AppColors.primaryBackgroundColor
                                            ? Border.all(
                                                color:
                                                    AppColors.primaryNeutral200,
                                              )
                                            : null,
                                      ),
                                      // the selector icon according to index and color value
                                      child: Center(
                                        child: isSelectedColor
                                            ? colorValue ==
                                                    AppColors
                                                        .primaryBackgroundColor
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.black,
                                                    size: 12,
                                                  )
                                                : const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 12,
                                                  )
                                            : Container(),
                                      ),
                                    ),

                                    //text container
                                    Center(
                                      child: Text(
                                        // capitalizes the first letter of the string
                                        _shoeColors[index]
                                                .name[0]
                                                .toUpperCase() +
                                            _shoeColors[index]
                                                .name
                                                .substring(1),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.blackAccentColor500,
                                        ),
                                      ),
                                    ),
                                    AppSpaces.horizontalSpace20,
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    AppSpaces.verticalSpace30,
                  ],
                ),
              ),
            ],
          ),

          //footer
          // the positioned widget for the apply and reset
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(Sizes.md),
              decoration: BoxDecoration(
                color: AppColors.primaryBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: const Offset(4.0, 4.0),
                    color: AppColors.primaryNeutral300,
                  ),
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: const Offset(-4.0, -4.0),
                    color: AppColors.primaryBackgroundColor,
                  )
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.sizeOf(context).height / 80,
                  left: MediaQuery.sizeOf(context).height / 60,
                  right: MediaQuery.sizeOf(context).height / 60,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: whiteButton("RESET"),
                    ),
                    AppSpaces.horizontalSpace40,
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: blackButton("APPLY"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
