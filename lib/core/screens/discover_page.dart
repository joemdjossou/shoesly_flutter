import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/providers/theme_provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  static const String id = '/discover_page';

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    var mainProvider = Provider.of<ThemeProvider>(context, listen: true);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(),
    );
  }
}
