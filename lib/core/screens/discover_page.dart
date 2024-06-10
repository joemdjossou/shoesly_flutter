import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoesly_flutter/core/models/shoe_model.dart';
import 'package:shoesly_flutter/core/providers/selected_shoe_provider.dart';
import 'package:shoesly_flutter/core/providers/shoe_provider.dart';
import 'package:shoesly_flutter/core/screens/cart_page.dart';
import 'package:shoesly_flutter/core/screens/filter_page.dart';
import 'package:shoesly_flutter/core/screens/shoe_details.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  static const String id = '/discover_page';

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool? isLoaded;
  bool? dbIsNotEmpty;
  String selectedBrand = "All";
  final List<String> filterBrandNames = [
    "All",
    "Nike",
    "Jordan",
    "Adidas",
    "Reebok",
    "Vans"
  ];

  //initializing the shoes to be empty
  List<Shoe> allShoes = [];
  List<Shoe> _filteredShoes = [];

  // function to filterShoes
  void _filterShoes() {
    _filteredShoes = allShoes;
    if (selectedBrand != 'All') {
      _filteredShoes = allShoes
          .where((shoe) => selectedBrand.toLowerCase() == shoe.brandRef.id)
          .toList();
    }
  }

  //shimmer effect on the cards
  Shimmer loadingCardWidgets() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.145,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          AppSpaces.verticalSpace10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 18,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(4)),
              ),
              AppSpaces.verticalSpace10,
              Container(
                width: MediaQuery.sizeOf(context).width / 3,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AppSpaces.verticalSpace5,
              Container(
                width: MediaQuery.sizeOf(context).width / 6,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Shimmer loadingAverage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15,
                width: MediaQuery.sizeOf(context).width / 3,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
    print(isLoaded);
  }

  getData() async {
    //fetches the shoes document from the database
    List<Shoe>? shoes = await Provider.of<ShoeProvider>(context, listen: false)
        .fetchDocuments();

    setState(() {
      allShoes = shoes!;
      _filteredShoes = allShoes;
    });

    print(_filteredShoes);

    //condition checking
    if (shoes!.isNotEmpty) {
      //shoe instances loaded successfully
      setState(() {
        isLoaded = true;
      });
    } else if (shoes.isEmpty) {
      // shoe instance is empty
      // anything else is an error so the db has an issue
      setState(() {
        // stops the loader
        isLoaded = false;
        dbIsNotEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height / 10,
            left: Sizes.xl,
            right: Sizes.xl,
          ),
          child: Column(
            children: [
              //Header of the discover page
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Discover",
                    style: Constants.headingStyle,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.id);
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/cart.svg",
                      height: Sizes.iconMd,
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,

              //Brand selection Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (String brandName in filterBrandNames)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedBrand = brandName;
                            _filterShoes();
                            print(_filteredShoes.length);
                            print(isLoaded);
                            print(dbIsNotEmpty);
                          });
                        },
                        child: Text(
                          brandName,
                          style: Constants.subHeadingStyle.copyWith(
                            fontSize: 23,
                            color: brandName == selectedBrand
                                ? AppColors.blackAccentColor500
                                : AppColors.shadeGreyAccentColor300,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              (isLoaded == true)
                  ? Expanded(
                      child: GridView.builder(
                        // HAS A VALUE (TRUE)
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              MediaQuery.sizeOf(context).height / 1400,
                        ),
                        itemCount: _filteredShoes.length,
                        itemBuilder: (BuildContext context, int index) {
                          final shoe = _filteredShoes[index];
                          return _shoeCard(context, shoe);
                        },
                      ),
                    )
                  : ((isLoaded == null && dbIsNotEmpty == null) ||
                          (isLoaded == false && dbIsNotEmpty == false))
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // IS EMPTY OR HAS AN ISSUE (FALSE)
                            Column(
                              children: [
                                Lottie.asset(
                                  'assets/icons/database_error_lottie.json',
                                ),
                                AppSpaces.verticalSpace20,
                                Center(
                                  child: TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 20.0),
                                      duration: const Duration(seconds: 2),
                                      builder: (BuildContext context,
                                          double value, Widget? child) {
                                        return Text(
                                          'The database is having an error ${TextSpacing.nextLine} or is empty'
                                          '${TextSpacing.nextLine + TextSpacing.nextLine}Check your network too',
                                          textAlign: TextAlign.center,
                                          style: Constants.textStyle.copyWith(
                                            fontSize: value,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        );
                                      } // TextStyle, Text
                                      ),
                                ), // TweenAnimationBuilder
                              ],
                            )
                          ],
                        )
                      : Expanded(
                          child: GridView.builder(
                            // HAS A VALUE (TRUE)
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              childAspectRatio:
                                  MediaQuery.sizeOf(context).height / 1400,
                            ),
                            itemCount: 12,
                            itemBuilder: (BuildContext context, int index) {
                              return loadingCardWidgets();
                            },
                          ),
                        ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            "FILTER",
            style: Constants.floatingStyle,
          ),
          icon: SvgPicture.asset("assets/icons/setting.svg"),
          backgroundColor: Colors.black,
          onPressed: () {
            // FILTER PAGE HERE
            Navigator.pushNamed(context, FilterPage.id);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Widget _shoeCard(BuildContext context, Shoe shoe) {
  Shimmer loadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.145,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Shimmer loadingAverage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15,
                width: MediaQuery.sizeOf(context).width / 14,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? imageUrl;

  return GestureDetector(
    onTap: () async {
      final selectedShoeProvider =
          Provider.of<SelectedShoeProvider>(context, listen: false);

      final imageUrls = await Future.wait([
        // shoe.loadBrandLogoUrl(shoe.brandRef),
        shoe.loadImageUrl(),
      ]);

      imageUrl = imageUrls[0];

      selectedShoeProvider.setSelectedShoe(shoe, imageUrl);

      Navigator.pushNamed(context, ShoeDetails.id);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primaryNeutral100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<String?>>(
                future: Future.wait([
                  // shoe.loadBrandLogoUrl(shoe.brandRef),
                  shoe.loadImageUrl(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(child: loadingCard()),
                      ],
                    );
                  } else if (snapshot.hasError || snapshot.data![0] == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppSpaces.verticalSpace50,
                        Text(
                          'Error loading data',
                          style: Constants.subHeadingStyle,
                        ),
                        AppSpaces.verticalSpace50,
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/${shoe.brand}.svg',
                                height:
                                    MediaQuery.sizeOf(context).height * 0.03,
                                width: MediaQuery.sizeOf(context).height * 0.03,
                              ),
                            ],
                          ),
                        ),
                        AppSpaces.verticalSpace10,
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                            left: 15,
                            right: 15,
                            bottom: 22,
                          ),
                          child: Center(
                            child: Image.network(
                              snapshot.data![0]!,
                              height: MediaQuery.sizeOf(context).height * 0.1,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Text(
            shoe.name,
            textAlign: TextAlign.center,
            style: Constants.textStyle.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            Image.asset(
              "assets/icons/star.png",
              height: MediaQuery.sizeOf(context).height * 0.015,
            ),
            AppSpaces.horizontalSpace5,

            //fetch average rating
            FutureBuilder<List<double?>>(
              future: Future.wait([
                shoe.calculateAverageRating(),
              ]),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(child: loadingAverage()),
                    ],
                  );
                } else if (snapshot.hasError || snapshot.data![0] == null) {
                  return Text(
                    'error',
                    style: Constants.textStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data![0]!.toStringAsFixed(2),
                    style: Constants.textStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  );
                }
              },
            ),
            AppSpaces.horizontalSpace5,
            Text(
              "(${shoe.totalReviews} reviews)",
              style: Constants.textStyle.copyWith(
                color: AppColors.primaryNeutral300,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ],
        ),
        AppSpaces.verticalSpace5,
        Text(
          "\$${shoe.price}",
          style: Constants.subHeadingStyle.copyWith(
            fontSize: 16,
          ),
        )
      ],
    ),
  );
}
