import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesly_flutter/core/models/shoe_model.dart';

class ShoeProvider extends ChangeNotifier {
  List<Shoe> _shoes = [];

  List<Shoe> get shoes => _shoes;

  Future<void> fetchDocuments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("shoes").get();

      List<Shoe> fetchedShoes = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        List<DocumentReference> colorRefs =
            List<DocumentReference>.from(doc['colors']);
        // List<DocumentReference> reviewRefs =
        // List<DocumentReference>.from(doc['reviews']);

        List<double> sizes = [];
        List<dynamic> rawSizes = doc['sizes'];

        for (var size in rawSizes) {
          sizes.add(size.toDouble());
          print(sizes);
        }

        fetchedShoes.add(
          Shoe(
            id: doc.id,
            description: doc['description'],
            name: doc['name'],
            price: doc['price'],
            sizes: sizes,
            imageUrl: doc['imageUrl'],
            totalReviews: doc['total_reviews'],
            colorRefs: colorRefs,
          ),
        );
      }

      _shoes = fetchedShoes;
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
