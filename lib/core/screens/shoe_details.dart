import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoesly_flutter/core/models/brand_model.dart';
import 'package:shoesly_flutter/core/models/review_model.dart';
import 'package:shoesly_flutter/core/models/shoe_color.dart';
import 'package:shoesly_flutter/core/providers/cart_provider.dart';
import 'package:shoesly_flutter/core/providers/selected_shoe_provider.dart';
import 'package:shoesly_flutter/core/screens/all_reviews_page.dart';
import 'package:shoesly_flutter/core/screens/cart_page.dart';
import 'package:shoesly_flutter/core/screens/discover_page.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:shoesly_flutter/widgets/black_button_widget.dart';
import 'package:shoesly_flutter/widgets/review_widget.dart';
import 'package:shoesly_flutter/widgets/white_button_widget.dart';

class ShoeDetails extends StatefulWidget {
  const ShoeDetails({super.key});

  static const String id = '/shoe_details';

  @override
  State<ShoeDetails> createState() => _ShoeDetailsState();
}

class _ShoeDetailsState extends State<ShoeDetails> {
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedSizeIndex = -1;
  List<ShoeColor> _shoeColors = [];
  String? _selectedColorName;
  String? _brandName;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchShoeColors();
    _fetchBrandName();
  }

  Future<void> _fetchShoeColors() async {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final colors = await selectedShoe.getShoeColors();
    setState(() {
      _shoeColors = colors;
      print(_shoeColors);
    });
  }

  Future<void> _fetchBrandName() async {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final brandRef = selectedShoe.brandRef;
    final brandDocumentSnapshot = await brandRef.get();
    final brandData = brandDocumentSnapshot.data() as Map<String, dynamic>;
    final brand = Brand.fromJson(brandData);
    setState(() {
      _brandName = brand.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final selectedImageUrl = selectedShoeProvider.selectedImageUrl;
    final selectedName = selectedShoe.name;
    final selectedTotalReviews = selectedShoe.totalReviews;
    final selectedPrice = selectedShoe.price;
    final selectedSizes = selectedShoe.sizes;
    final selectedDescription = selectedShoe.description;

    return Scaffold(
      //appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: IconButton(
            icon: SvgPicture.asset("assets/icons/arrow-left.svg"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartPage.id);
              },
              icon: SvgPicture.asset("assets/icons/cart_empty.svg"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
        child: Stack(
          children: [
            //the body without the price and add to cart section
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpaces.verticalSpace10,
                  //Shoe tile with color and page navigator indicator
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      // the image tile
                      Container(
                        height: MediaQuery.sizeOf(context).height / 2.8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryNeutral200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.xl,
                            vertical: 67,
                          ),
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return _buildCarouselItem(selectedImageUrl);
                            },
                          ),
                        ),
                      ),

                      // the dot indicator buttons
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: Sizes.lg,
                            bottom: Sizes.lg,
                          ),
                          child: Row(
                            children: List<Widget>.generate(3, (int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: Sizes.xs,
                                ),
                                height: MediaQuery.sizeOf(context).height / 100,
                                width: MediaQuery.sizeOf(context).height / 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? AppColors.blackAccentColor500
                                      : AppColors.shadeGreyAccentColor300,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                      // the color selectors
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: const EdgeInsets.only(
                          right: Sizes.sm,
                          bottom: Sizes.sm,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(Sizes.xl),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.sm,
                              vertical: Sizes.sm,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              // list generation through the shoeColor instances
                              children:
                                  List.generate(_shoeColors.length, (index) {
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
                                      // testing the color
                                      print(shoeColor.hexCode);
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(right: Sizes.sm),
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
                                    // for the selector icon
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
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpaces.verticalSpace30,

                  // The text title
                  Text(
                    selectedName,
                    style: Constants.headingStyle.copyWith(
                      fontSize: 24,
                    ),
                  ),

                  AppSpaces.verticalSpace5,

                  // total number of reviews display
                  Text(
                    '($selectedTotalReviews Reviews)',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Sizes.fontSize14,
                      color: AppColors.shadeGreyAccentColor300,
                    ),
                  ),

                  AppSpaces.verticalSpace30,

                  // Shoe sizes
                  Text(
                    'Size',
                    style: Constants.subHeadingStyle
                        .copyWith(fontWeight: FontWeight.w500),
                  ),

                  AppSpaces.verticalSpace10,

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(selectedSizes.length, (index) {
                        final size = selectedSizes[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSizeIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedSizeIndex == index
                                  ? AppColors.blackAccentColor500
                                  : AppColors.primaryBackgroundColor,
                              border: Border.all(
                                  color: AppColors.primaryNeutral200),
                            ),
                            child: Center(
                              child: Text(
                                size.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: _selectedSizeIndex == index
                                      ? Colors.white
                                      : AppColors.shadeGreyAccentColor400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  AppSpaces.verticalSpace30,

                  // shoe description
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpaces.verticalSpace10,
                  Text(
                    selectedDescription,
                    style: TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w400,
                      height: 2,
                      color: AppColors.shadeGreyAccentColor400,
                    ),
                  ),
                  AppSpaces.verticalSpace30,

                  //Reviews section
                  Text(
                    "Review ($selectedTotalReviews)",
                    style: const TextStyle(
                      fontSize: Sizes.fontSize16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpaces.verticalSpace10,

                  //fetching the reviews
                  FutureBuilder<List<Review>>(
                    future: selectedShoe.fetchReviews(limit: 3),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return loadingReview();
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final reviews = snapshot.data ?? [];
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviews[index];
                                return buildReviewItem(review);
                              },
                            ),
                            if (selectedTotalReviews > 3)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReviewsPage(
                                        selectedShoeProvider:
                                            selectedShoeProvider,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 13.0,
                                      vertical: Sizes.lg,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SEE ALL REVIEW",
                                        style: TextStyle(
                                          fontSize: Sizes.fontSize14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                  AppSpaces.verticalSpace100,
                  AppSpaces.verticalSpace50,
                ],
              ),
            ),

            // the positioned widget for the add to cart
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(Sizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.shadeGreyAccentColor400,
                          ),
                        ),
                        const SizedBox(
                          height: Sizes.xs,
                        ),
                        Text(
                          '\$$selectedPrice',
                          style: const TextStyle(
                            fontSize: Sizes.fontSize16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_selectedSizeIndex != -1) {
                          _showAddToCartBottomSheet(context, selectedPrice);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Please select a shoe size',
                                    overflow: TextOverflow.visible,
                                    style: Constants.subHeadingStyle,
                                  ),
                                  AppSpaces.verticalSpace20,
                                  IconButton(
                                    onPressed: () {
                                      //pop once to remove the dialog box
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: AppColors.redColor500,
                                      size: 40.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: blackButton("ADD TO CART"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Shimmer loadingReview() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 15,
                            width: MediaQuery.sizeOf(context).width / 3,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          Container(
                            height: 15,
                            width: MediaQuery.sizeOf(context).width / 6,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ],
                      ),
                      AppSpaces.verticalSpace10,
                      Container(
                        height: 23,
                        width: MediaQuery.sizeOf(context).width / 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      AppSpaces.verticalSpace10,
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpaces.verticalSpace20,
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String? imageUrl) {
    return Image.network(
      imageUrl ?? "",
      fit: BoxFit.contain,
    );
  }

  //Add to Cart modal sheet bar
  void _showAddToCartBottomSheet(BuildContext context, double selectedPrice) {
    int quantity = 1;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(Sizes.md),

              //decoration of the modal bottom sheet
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(Sizes.lg),
                  topRight: Radius.circular(Sizes.lg),
                ),
                color: AppColors.primaryBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.lg,
                  vertical: Sizes.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.shadeGreyAccentColor300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Sizes.xl,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: Sizes.fontSize20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.md),
                    const Text(
                      'Quantity',
                      style: TextStyle(
                        fontSize: Sizes.fontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Sizes.xl),
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                    text: quantity.toString()),
                                onChanged: (newValue) {
                                  if (int.tryParse(newValue) != null) {
                                    setState(() {
                                      quantity = int.parse(newValue);
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantity > 1) quantity--;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Sizes.md,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Price",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryNeutral300,
                              ),
                            ),
                            const SizedBox(
                              height: Sizes.xs,
                            ),
                            Text(
                              '\$$selectedPrice',
                              style: const TextStyle(
                                fontSize: Sizes.fontSize16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _addToCart(context, selectedPrice, quantity);
                          },
                          child: blackButton("ADD TO CART"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // add to cart function
  void _addToCart(BuildContext context, double price, int quantity) {
    final selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final selectedColor = _selectedColorName ?? 'Unknown';
    final selectedSize = selectedShoe.sizes[_selectedSizeIndex];
    final selectedImageUrl = selectedShoeProvider.selectedImageUrl;

    cartProvider.addItem(
      name: selectedShoe.name,
      price: price,
      color: selectedColor,
      shoeSize: selectedSize,
      quantity: quantity,
      imageUrl: selectedImageUrl ?? '',
      brand: _brandName ?? '',
    );

    // pops the first modal to leave the second one
    Navigator.pop(context);

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(Sizes.md),

                //decoration of the modal bottom sheet
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Sizes.lg),
                    topRight: Radius.circular(Sizes.lg),
                  ),
                  color: AppColors.primaryBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.lg,
                    vertical: Sizes.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSpaces.verticalSpace10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                                'assets/icons/tick-circle.svg'),
                          ),
                        ],
                      ),
                      AppSpaces.verticalSpace30,
                      Center(
                        child: Text(
                          'Added to cart',
                          style: Constants.textStyle.copyWith(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AppSpaces.verticalSpace10,
                      Center(
                        child: Text(
                          '$quantity item Total',
                          style: Constants.textStyle.copyWith(fontSize: 17),
                        ),
                      ),
                      AppSpaces.verticalSpace30,
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${selectedShoe.name} added to cart!',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      style: Constants.textStyle.copyWith(
                                        color: AppColors.primaryNeutral100,
                                        fontSize: 20,
                                      ),
                                    ),
                                    backgroundColor: AppColors.greenSuccess,
                                  ),
                                );
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  DiscoverPage.id,
                                  (route) => false,
                                );
                              },
                              child: whiteButton("BACK EXPLORE"),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: AppSpaces.verticalSpace5,
                          ),
                          Expanded(
                            flex: 8,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${selectedShoe.name} added to cart!',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      style: Constants.textStyle.copyWith(
                                        color: AppColors.primaryNeutral100,
                                        fontSize: 20,
                                      ),
                                    ),
                                    backgroundColor: AppColors.greenSuccess,
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  CartPage.id,
                                );
                              },
                              child: blackButton("TO CART"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       '${selectedShoe.name} added to cart!',
    //       textAlign: TextAlign.center,
    //       overflow: TextOverflow.clip,
    //       style: Constants.textStyle.copyWith(
    //         color: AppColors.primaryNeutral100,
    //         fontSize: 20,
    //       ),
    //     ),
    //     backgroundColor: AppColors.greenSuccess,
    //   ),
    // );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
