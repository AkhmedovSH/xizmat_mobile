import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/index.dart';
import 'pages/categories.dart';
import 'pages/fast_search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      popGesture: true,
      defaultTransition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 250),
      theme: ThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        brightness: Brightness.light,
        primaryColor: Color(0xFFFF5453),
        platform: TargetPlatform.android,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF48A8FF),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => Index()),
        GetPage(name: '/categories', page: () => Categories()),
        GetPage(name: '/fast-search', page: () => FastSearch()),
      ],
      // home: Index(),
    );
  }
}
