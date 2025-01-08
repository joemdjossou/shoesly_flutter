import 'package:flutter_test/flutter_test.dart';
import 'package:shoesly_flutter/core/models/shoe_model.dart';
import 'package:shoesly_flutter/core/providers/shoe_provider.dart';

void main() {
  test('fetched shoes test', () {
    //setup
    ShoeProvider().shoes == [];

    //do
    ShoeProvider().fetchDocuments();

    //test
    expect(ShoeProvider().shoes[0], ShoeProvider().shoeFiltered);
  });
}
