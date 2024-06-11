import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoesly_flutter/core/models/brand_model.dart';

class BrandsProvider extends ChangeNotifier {
  List<Brand> _brand = [];

  List<Brand> get brand => _brand;

  List<String> brandsName = [];

  Future<List<Brand>?> fetchDocuments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("brands").get();

      List<String> allBrands = [];
      List<Brand> fetchedbrands = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String rawBrand = doc['name'];

        allBrands.add(rawBrand.toString());
        // print(rawBrand);

        fetchedbrands.add(
          Brand(
            itemCount: doc['itemCount'],
            logoGreyUrl: doc['logoGreyUrl'],
            logoUrl: doc['logoUrl'],
            name: doc['name'],
          ),
        );
      }

      brandsName = allBrands;
      _brand = fetchedbrands;
      notifyListeners();
      return brand;
    } catch (e) {
      Exception("Error fetching data: $e");
      return brand;
    }
  }
}
