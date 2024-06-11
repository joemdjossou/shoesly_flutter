import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/providers/brands_provider.dart';
import 'package:shoesly_flutter/core/providers/cart_provider.dart';
import 'package:shoesly_flutter/core/providers/selected_shoe_provider.dart';
import 'package:shoesly_flutter/core/providers/shoe_provider.dart';
import 'package:shoesly_flutter/core/providers/theme_provider.dart';
import 'package:shoesly_flutter/core/routes/app_routes.dart';
import 'package:shoesly_flutter/core/screens/discover_page.dart';
import 'package:shoesly_flutter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Firebase to the current platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the device orientation to be portrait
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then(
    (value) => runApp(
      // DevicePreview(
      //   builder: (context) =>
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => ShoeProvider()),
          ChangeNotifierProvider(create: (context) => SelectedShoeProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (_) => BrandsProvider()),
        ],
        child: const MyApp(),
      ),
      // ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // setting the dimension to be equal to the dimensions of the device screen
    var mainProvider = Provider.of<ThemeProvider>(context, listen: true);
    mainProvider.height = MediaQuery.sizeOf(context).height;
    mainProvider.width = MediaQuery.sizeOf(context).width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoesfly',
      theme: mainProvider.themeData,
      themeAnimationCurve: Curves.decelerate,
      themeAnimationDuration: const Duration(milliseconds: 500),
      navigatorKey: AppRouter.navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      home: const DiscoverPage(),
    );
  }
}
