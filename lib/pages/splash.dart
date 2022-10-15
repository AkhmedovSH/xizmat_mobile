import 'dart:io' show Platform;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:xizmat/helpers/api.dart';
import 'package:xizmat/helpers/globals.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic systemOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light);
  dynamic vesrion = '';
  dynamic url = '';
  bool isRequired = false;
  bool ios = false;

  @override
  void initState() {
    super.initState();
    // login();
    checkVersion();
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      setState(() {
        ios = true;
      });
    }
    // startTimer();
  }

  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    var playMarketVersion = await guestGet('/services/admin/api/get-version?name=uz.xizmat24.client');
    print(playMarketVersion);
    if (playMarketVersion == null) {
      startTimer();
      return;
    }
    print(localVersion);

    if (playMarketVersion['version'] != localVersion) {
      if (playMarketVersion['required']) {
        print('req');
        print(playMarketVersion);
        setState(() {
          isRequired = true;
        });
      }
      await showUpdateDialog();
      if (isRequired) {
        SystemNavigator.pop();
      } else {
        startTimer();
      }
    } else {
      startTimer();
    }
  }

  startTimer() {
    var _duration = const Duration(milliseconds: 2000);
    return Timer(_duration, navigate);
  }

  void navigate() async {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // bool lightMode =
    //     MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: red,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: systemOverlayStyle,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            'images/splash_logo.png',
            height: 200,
            width: MediaQuery.of(context).size.width * 0.6,
          )),
        ],
      ),
    );
  }

  showUpdateDialog() async {
    await showDialog(
        context: context,
        // barrierDismissible: !isRequired,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              title: Text(
                'update_app'.tr + ' "xizmat"',
                style: const TextStyle(color: Colors.black),
                // textAlign: TextAlign.center,
              ),
              scrollable: true,
              content: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      isRequired
                          ? 'you_need_to_install_the_latest_version_to_continue_using_the_app'.tr + '"xizmat".'
                          : 'we_recommend_installing_the_latest_version_of_the_application'.tr +
                              '"xizmat".' +
                              'while_downloading_updates_you_can_still_use_it'.tr +
                              '.',
                      style: const TextStyle(color: Colors.black, height: 1.2),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isRequired
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: TextButton.styleFrom(backgroundColor: const Color(0xFF00865F)),
                                    child: Text(
                                      'no_thanks'.tr,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                          ElevatedButton(
                            onPressed: () {
                              if (ios) {
                              final uri = Uri.parse(
                                  'https://apps.apple.com/app/id6443604263');
                              launchUrl(uri);
                            } else {
                              final uri = Uri.parse(
                                  'https://play.google.com/store/apps/details?id=uz.redeem.client');
                              launchUrl(uri);
                              // StoreRedirect.redirect(
                              //   androidAppId: "uz.redeem.client",
                              //   iOSAppId: "6443604263",
                              // );
                            }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00865F),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                            ),
                            child: Text('update'.tr),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        'images/google_play.png',
                        height: 25,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
