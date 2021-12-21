import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/pages/Steps/step_4.dart';
import 'package:xizmat/pages/Steps/step_5.dart';

import './globals.dart' as globals;

import 'pages/index.dart';
import 'pages/categories.dart';
import 'pages/fast_search.dart';
import 'pages/tutor.dart';
import 'pages/register.dart';
import 'pages/orders.dart';
import 'pages/support.dart';

import 'pages/Steps/step_1.dart';
import 'pages/Steps/step_2.dart';
import 'pages/Steps/step_3.dart';
import 'pages/Steps/google_map.dart';
import 'pages/Steps/search_result.dart';

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
            primary: globals.red,
          ),
        ),
      ),
      initialRoute: '/', 
      getPages: [
        GetPage(name: '/', page: () => Index()),
        GetPage(name: '/categories', page: () => Categories()),
        GetPage(name: '/fast-search', page: () => FastSearch()),
        GetPage(name: '/tutor', page: () => Tutor()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/orders', page: () => Orders()),
        GetPage(name: '/support', page: () => Support()),

        GetPage(name: '/step-1', page: () => Step1()),
        GetPage(name: '/step-2', page: () => Step2()),
        GetPage(name: '/step-3', page: () => Step3()),
        GetPage(name: '/step-4', page: () => Step4()),
        GetPage(name: '/step-5', page: () => Step5()),
        GetPage(name: '/google-map', page: () => Map()),
        GetPage(name: '/search-result', page: () => SearchResult(), transition: Transition.downToUp),
      ],
      // home: Index(),
    );
  }
}