import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoesly_flutter/core/models/review_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Widget buildReviewItem(Review review) {
  // user profile picture
  Future<String?> loadImageUrl() async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(review.profilePictureUrl);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Shimmer loadingReview() {
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<String?>>(
          future: Future.wait([
            loadImageUrl(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(child: loadingReview()),
                ],
              );
            } else if (snapshot.hasError || snapshot.data![0] == null) {
              return CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.redColor500,
              );
            } else {
              return CircleAvatar(
                child: Image.network(
                  snapshot.data![0]!,
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),
              );
            }
          },
        ),
        AppSpaces.horizontalSpace20,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(review.timestamp),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: Sizes.fontSize12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.xs),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      review.rating,
                      (index) => Image.asset(
                        'assets/icons/star.png',
                        height: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      (5 - review.rating),
                      (index) => Image.asset(
                        'assets/icons/star.png',
                        height: 20,
                        color: AppColors.primaryNeutral200,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace10,
              Text(
                review.comment,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
