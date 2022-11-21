import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/globals.dart';

import 'helpers/translations.dart';

import 'pages/splash.dart';
import 'pages/dashboard/dashboard.dart';
import 'pages/fast_search.dart';
import 'pages/tutor.dart';
import 'pages/dashboard/support.dart';
import 'pages/order/success.dart';
import 'pages/specialist_inside.dart';
import 'pages/dashboard/profile/profile.dart';
import 'pages/dashboard/profile/setting_profile.dart';

import 'pages/categories/categories.dart';
import 'pages/categories/categories_childs.dart';

import 'pages/auth/register.dart';
import 'pages/auth/confirmation.dart';
import 'pages/auth/login.dart';
import 'pages/auth/reset_password/reset_password_init.dart';
import 'pages/auth/reset_password/reset_password_finish.dart';

import 'pages/dashboard/orders.dart';
import 'pages/order/order_inside.dart';
import 'pages/order/order_detail.dart';
import 'pages/order/order_by_manager.dart';
import 'pages/order/order_by_manager_success.dart';
import 'pages/order/order_review.dart';

import 'pages/steps/step_layout.dart';
import 'pages/steps/google_map.dart';
import 'pages/steps/select_region.dart';
import 'pages/steps/select_city.dart';
import 'pages/steps/calendar.dart';

import './helpers/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic locale = const Locale('uz', 'UZ');

  getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getInt('locale') != null) {
        Get.updateLocale(Locale('${prefs.getInt('locale')}'));
        setState(() {
          locale = Locale('${prefs.getInt('locale')}');
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLocale();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('ru', ''),
      fallbackLocale: const Locale('uz-Latn-UZ', ''),
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
            backgroundColor: red,
          ),
        ),
        timePickerTheme: TimePickerThemeData(
          hourMinuteTextColor: red,
          dialHandColor: Colors.transparent,
          dayPeriodColor: red,
          entryModeIconColor: red,
          dialTextColor: red,
          dayPeriodTextColor: red,
          hourMinuteColor: Colors.transparent,
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const Splash()),
        GetPage(name: '/', page: () => const Dashboard()),
        GetPage(name: '/categories', page: () => const Categories()),
        GetPage(
            name: '/categories-childs', page: () => const CategoriesChilds()),
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
        GetPage(
            name: '/reset-password-init',
            page: () => const ResetPasswordInit()),
        GetPage(
            name: '/reset-password-finish',
            page: () => const ResetPasswordFinish()),
        // Order
        GetPage(
            name: '/specialist-inside', page: () => const SpecialistInside()),
        GetPage(name: '/orders', page: () => const Orders()),
        GetPage(name: '/order-inside', page: () => const OrderInside()),
        GetPage(name: '/order-detail', page: () => const OrderDetail()),
        GetPage(name: '/order-by-manager', page: () => const OrderByManager()),
        GetPage(
            name: '/order-by-manager-success',
            page: () => const OrderByManagerSuccess()),
        GetPage(name: '/order-review', page: () => const OrderReview()),
        // Steps
        GetPage(name: '/step-layout', page: () => StepLayout()),
        GetPage(name: '/google-map', page: () => const Map()),
        GetPage(name: '/select-region', page: () => const SelectRegion()),
        GetPage(name: '/select-city', page: () => const SelectCity()),
        GetPage(name: '/calendar', page: () => const Calendar()),
      ],
      // home: Index(),
    );
  }
}
