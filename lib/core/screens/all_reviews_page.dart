import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoesly_flutter/core/providers/selected_shoe_provider.dart';
import 'package:shoesly_flutter/core/models/review_model.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:shoesly_flutter/widgets/review_widget.dart';

class ReviewsPage extends StatefulWidget {
  static const String id = '/reviews_page';

  final SelectedShoeProvider? selectedShoeProvider;
  const ReviewsPage({
    super.key,
    this.selectedShoeProvider,
  });

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  String selectedReviewOption = "All";
  final List<String> reviewOptions = [
    "All",
    "5 Stars",
    "4 Stars",
    "3 Stars",
    "2 Stars",
    "1 Star"
  ];

  final ScrollController _scrollController = ScrollController();
  final List<Review> _allReviews = [];
  List<Review> _filteredReviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreReviews();
    }
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final selectedShoe = widget.selectedShoeProvider!.selectedShoe;
    final newReviews = await selectedShoe.fetchReviews(limit: 10);
    setState(() {
      _allReviews.addAll(newReviews);
      _filterReviews();
      _isLoading = false;
    });
  }

  void _filterReviews() {
    _filteredReviews = _allReviews;
    if (selectedReviewOption != "All") {
      int rating = int.parse(selectedReviewOption.split(" ")[0]);
      _filteredReviews =
          _allReviews.where((review) => review.rating == rating).toList();
    }
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

  @override
  Widget build(BuildContext context) {
    final selectedShoe = widget.selectedShoeProvider!.selectedShoe;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review (${selectedShoe.totalReviews})",
          style: const TextStyle(
            color: Colors.black,
            fontSize: Sizes.fontSize16,
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
        actions: const [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.orange,
                size: Sizes.md,
              ),
              SizedBox(
                width: Sizes.sm,
              ),
              Text(
                "4.5",
                style: TextStyle(
                  fontSize: Sizes.fontSize14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: Sizes.sm,
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String brandName in reviewOptions)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedReviewOption = brandName;
                          _filterReviews();
                        });
                      },
                      child: Text(
                        brandName,
                        style: TextStyle(
                          fontSize: Sizes.fontSize20,
                          color: brandName == selectedReviewOption
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: Sizes.sm,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredReviews.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _filteredReviews.length) {
                    final review = _filteredReviews[index];
                    return buildReviewItem(review);
                  } else {
                    return Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Center(
                            child: loadingReview(),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
