import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/models/shoe_color.dart';
import 'package:shoesly_flutter/core/providers/selected_shoe_provider.dart';

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
  }

  Future<void> _fetchShoeColors() async {
    SelectedShoeProvider selectedShoeProvider =
        Provider.of<SelectedShoeProvider>(context, listen: false);
    final selectedShoe = selectedShoeProvider.selectedShoe;
    final colors = await selectedShoe.getShoeColors();
    setState(() {
      _shoeColors = colors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
