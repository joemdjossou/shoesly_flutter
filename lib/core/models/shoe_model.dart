import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shoesly_flutter/core/models/shoe_color.dart';
// import 'package:priority_soft_test/models/review.dart';
// import 'package:priority_soft_test/models/shoe_color.dart';

class Shoe {
  final String id; // Document ID
  final String description;
  final String name;
  final String price;
  final String imageUrl;
  final List<double> sizes; // Available sizes
  final int totalReviews;
  final List<DocumentReference> colorRefs; // References to color documents

  Shoe({
    required this.id,
    required this.description,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.totalReviews,
    required this.colorRefs,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      price: json['price'],
      sizes: (json['sizes'] as List)
          .map<double>((size) => size.toDouble())
          .toList(),
      imageUrl: json['imageUrl'],
      totalReviews: json['total_reviews'],
      colorRefs: (json['colors'] as List)
          .map((color) => color as DocumentReference)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'price': price,
      'sizes': sizes,
      'imageUrl': imageUrl,
      'total_reviews': totalReviews,
      'colors': colorRefs,
    };
  }

  Future<String?> loadImageUrl() async {
    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(imageUrl);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  // Future<String?> loadBrandLogoUrl(DocumentReference brandRef) async {
  //   try {
  //     DocumentSnapshot snapshot = await brandRef.get();
  //     String logoUrl = snapshot['logo_grey_url'];
  //     firebase_storage.Reference ref =
  //         firebase_storage.FirebaseStorage.instance.refFromURL(logoUrl);
  //     String url = await ref.getDownloadURL();
  //     return url;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<double> calculateAverageRating() async {
  //   if (reviewRefs.isEmpty) {
  //     return 0;
  //   }
  //
  //   double totalRating = 0;
  //
  //   for (DocumentReference reference in reviewRefs) {
  //     DocumentSnapshot snapshot = await reference.get();
  //     if (snapshot.exists) {
  //       totalRating += snapshot['rating'];
  //     }
  //   }
  //
  //   return totalRating / reviewRefs.length;
  // }

  // Future<List<Review>> fetchReviews({int? limit}) async {
  //   List<Review> reviews = [];
  //   try {
  //     int numberOfReviewsToFetch = limit ?? reviewRefs.length;
  //     for (int i = 0;
  //         i < numberOfReviewsToFetch && i < reviewRefs.length;
  //         i++) {
  //       DocumentSnapshot snapshot = await reviewRefs[i].get();
  //       if (snapshot.exists) {
  //         reviews.add(Review.fromMap(snapshot.data() as Map<String, dynamic>));
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching reviews: $e');
  //   }
  //   return reviews;
  // }

  Future<List<ShoeColor>> getShoeColors() async {
    List<ShoeColor> shoeColors = [];
    try {
      for (DocumentReference colorRef in colorRefs) {
        final snapshot = await colorRef.get();
        if (snapshot.exists) {
          final colorData = snapshot.data() as Map<String, dynamic>;
          final shoeColor = ShoeColor.fromMap(colorData);
          shoeColors.add(shoeColor);
        }
      }
    } catch (e) {
      print('Error getting shoe colors: $e');
    }
    return shoeColors;
  }
}
