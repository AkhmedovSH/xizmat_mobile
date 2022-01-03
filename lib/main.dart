import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './globals.dart' as globals;

import 'pages/index.dart';
import 'pages/categories.dart';
import 'pages/fast_search.dart';
import 'pages/tutor.dart';
import 'pages/support.dart';
import 'pages/Steps/success.dart';
import 'pages/specialist_inside.dart';
import 'package:xizmat/pages/profile.dart';

import 'pages/register.dart';
import 'pages/confirmation.dart';
import 'pages/login.dart';

import 'pages/Order/orders.dart';
import 'pages/Order/order_inside.dart';
import 'pages/Order/order_by_manager.dart';
import 'pages/Order/order_by_manager_success.dart';

import 'pages/Steps/step_1.dart';
import 'pages/Steps/step_2.dart';
import 'pages/Steps/step_3.dart';
import 'pages/Steps/step_4.dart';
import 'pages/Steps/step_5.dart';
import 'pages/Steps/google_map.dart';
import 'pages/Steps/search_result.dart';


 void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: globals.black,
              displayColor: globals.black,
            ),
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
        GetPage(name: '/support', page: () => Support()),
        GetPage(name: '/success', page: () => Success()),
        GetPage(name: '/confirmation', page: () => Confirmation()),
        GetPage(name: '/profile', page: () => Profile()),
        // Register
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/confirmation', page: () => Confirmation()),
        GetPage(name: '/login', page: () => Login()),
        // Order
        GetPage(name: '/specialist-inside', page: () => SpecialistInside()),
        GetPage(name: '/orders', page: () => Orders()),
        GetPage(name: '/order-inside', page: () => OrderInside()),
        GetPage(name: '/order-by-manager', page: () => OrderByManager()),
        GetPage(
            name: '/order-by-manager-success',
            page: () => OrderByManagerSuccess()),
        // Steps
        GetPage(name: '/step-1', page: () => Step1()),
        GetPage(name: '/step-2', page: () => Step2()),
        GetPage(name: '/step-3', page: () => Step3()),
        GetPage(name: '/step-4', page: () => Step4()),
        GetPage(name: '/step-5', page: () => Step5()),
        GetPage(name: '/google-map', page: () => Map()),
        GetPage(
            name: '/search-result',
            page: () => SearchResult(),
            transition: Transition.downToUp),
      ],
      // home: Index(),
    );
  }
}
