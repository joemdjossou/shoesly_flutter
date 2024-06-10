import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String comment;
  final String profilePictureUrl;
  final int rating;
  final DateTime timestamp;
  final String userName;

  Review({
    required this.comment,
    required this.profilePictureUrl,
    required this.rating,
    required this.timestamp,
    required this.userName,
  });

  //serializing the review json
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      comment: map['comment'],
      profilePictureUrl: map['profilePictureUrl'],
      rating: map['rating'],
      timestamp: (map['timeStamp'] as Timestamp).toDate(),
      userName: map['userName'],
    );
  }
}
