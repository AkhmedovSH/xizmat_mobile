import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/globals.dart';

import 'helpers/translations.dart';

import 'pages/splash.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/fast_search.dart';
import 'pages/tutor.dart';
import 'pages/dashboard/support.dart';
import 'pages/Steps/success.dart';
import 'pages/specialist_inside.dart';
import 'pages/dashboard/profile/profile.dart';
import 'pages/dashboard/profile/setting_profile.dart';

import 'pages/categories/categories.dart';
import 'pages/categories/categories_childs.dart';

import 'pages/auth/register.dart';
import 'pages/auth/confirmation.dart';
import 'pages/auth/login.dart';

import 'pages/dashboard/orders.dart';
import 'pages/Order/order_inside.dart';
import 'pages/Order/order_by_manager.dart';
import 'pages/Order/order_by_manager_success.dart';

import 'pages/Steps/step_layout.dart';
import 'pages/Steps/google_map.dart';
import 'pages/Steps/search_result.dart';
import 'pages/Steps/select_city_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.transparent,
  ));
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('ru', 'RU'),
      fallbackLocale: const Locale('uz', 'UZ'),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('ru'), // English
      //   Locale('uz'), // Hebrew
      // ],

      debugShowCheckedModeBanner: false,
      popGesture: true,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 250),
      theme: ThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFF5453),
        platform: TargetPlatform.android,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: black,
              displayColor: black,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: red,
          ),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const Splash()),
        GetPage(name: '/', page: () => const Dashboard()),
        GetPage(name: '/categories', page: () => const Categories()),
        GetPage(name: '/categories-childs', page: () => const CategoriesChilds()),
        GetPage(name: '/fast-search', page: () => const FastSearch()),
        GetPage(name: '/tutor', page: () => const Tutor()),
        GetPage(name: '/support', page: () => const Support()),
        GetPage(name: '/success', page: () => const Success()),
        GetPage(name: '/confirmation', page: () => const Confirmation()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/profile-setting', page: () => const ProfileSetting()),
        // Register
        GetPage(name: '/registration', page: () => const Register()),
        GetPage(name: '/confirmation', page: () => const Confirmation()),
        GetPage(name: '/login', page: () => const Login()),
        // Order
        GetPage(name: '/specialist-inside', page: () => const SpecialistInside()),
        GetPage(name: '/orders', page: () => const Orders()),
        GetPage(name: '/order-inside', page: () => const OrderInside()),
        GetPage(name: '/order-by-manager', page: () => const OrderByManager()),
        GetPage(name: '/order-by-manager-success', page: () => const OrderByManagerSuccess()),
        // Steps
        GetPage(name: '/step-layout', page: () => StepLayout()),
        GetPage(name: '/google-map', page: () => const Map()),
        GetPage(name: '/search-result', page: () => const SearchResult(), transition: Transition.downToUp),
        GetPage(name: '/select-city', page: () => const SelectCityId()),
      ],
      // home: Index(),
    );
  }
}
