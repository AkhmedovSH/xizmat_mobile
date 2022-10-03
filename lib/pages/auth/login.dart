import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/globals.dart';
import '../../helpers/api.dart';
import '../../components/widgets.dart' as widgets;

import 'package:xizmat/components/transperent_app_bar.dart';
import 'package:xizmat/helpers/location_notification_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '+998 ## ### ## ##', filter: {'#': RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  AnimationController? animationController;
  dynamic sendData = {
    'username': '', // 998 998325455
    'password': '', // 112233
    'isRemember': false,
  };
  dynamic data = {
    'username': TextEditingController(text: '+998 '), // 998 998325455
    'password': TextEditingController(), // 112233
    'isRemember': false,
  };
  bool showPassword = true;
  bool loading = false;

  login() async {
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();

    final response = await guestPost('/auth/login', sendData);
    if (response != null) {
      prefs.setString('access_token', response['access_token'].toString());
      var account = await get('/services/uaa/api/account');
      var checkAccess = false;
      if (account != null) {
        for (var i = 0; i < account['authorities'].length; i++) {
          if (account['authorities'][i] == 'ROLE_CLIENT') {
            checkAccess = true;
          }
        }
      } else {
        setState(() {
          loading = false;
        });
      }
      if (checkAccess) {
        prefs.setString('user', jsonEncode(sendData));
        LocalNotificationService.initialize(context);
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            Get.offAllNamed('/notifications');
          }
        });
        FirebaseMessaging.onMessage.listen((message) {
          if (message.notification != null) {
            //Get.toNamed('/');
          }
          LocalNotificationService.display(message);
        });

        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          Get.offAllNamed('/notifications');
        });

        // var firebaseToken = await FirebaseMessaging.instance.getToken();
        // await put('/services/gocashmobile/api/firebase-token', {'token': firebaseToken});

        Get.offAllNamed('/');
      } else {
        setState(() {
          loading = false;
        });
        showErrorToast('Нет доступа');
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  checkIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      final user = jsonDecode(prefs.getString('user')!);
      if (user['isRemember'] != null) {
        if (user['isRemember']) {
          setState(() {
            sendData['isRemember'] = user['isRemember'];
            sendData['username'] = user['username'];
            sendData['password'] = user['password'];
            data['username'].text = maskFormatter.maskText(user['username'].substring(3, user['username'].length));
            data['password'].text = user['password'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIsRemember();
    setState(() {
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: TransperentAppBar(
            appBar: AppBar(),
            leading: false,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'welcome_to_xizmat'.tr,
                        style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'sign_in_to_continue'.tr,
                        style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ThemeData().colorScheme.copyWith(
                                      primary: red,
                                    ),
                              ),
                              child: TextFormField(
                                inputFormatters: [maskFormatter],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'required_field'.tr;
                                  }
                                  return null;
                                },
                                controller: data['username'],
                                onChanged: (value) {
                                  if (value == '') {
                                    setState(() {
                                      data['username'].text = '+998 ';
                                      data['username'].selection = TextSelection.fromPosition(
                                        TextPosition(
                                          offset: data['username'].text.length,
                                        ),
                                      );
                                    });
                                  }
                                  setState(() {
                                    sendData['username'] = value;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.phone_iphone,
                                      )),
                                  contentPadding: const EdgeInsets.all(18.0),
                                  focusColor: red,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: red),
                                  ),
                                  labelText: 'telephone_number'.tr + '(9* *** ** **)',
                                  labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                                ),
                                style: const TextStyle(color: Color(0xFF9C9C9C)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ThemeData().colorScheme.copyWith(
                                      primary: red,
                                    ),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'required_field'.tr;
                                  }
                                  return null;
                                },
                                controller: data['password'],
                                onChanged: (value) {
                                  setState(() {
                                    sendData['password'] = value;
                                  });
                                },
                                obscureText: showPassword,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.lock,
                                    ),
                                  ),
                                  suffixIcon: showPassword
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showPassword = false;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.visibility_off,
                                            // color: red,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              showPassword = true;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.visibility,
                                            // color: red,
                                          ),
                                        ),
                                  contentPadding: const EdgeInsets.all(18.0),
                                  focusColor: red,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: red),
                                  ),
                                  labelText: 'password'.tr,
                                  labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                                ),
                                style: const TextStyle(color: Color(0xFF9C9C9C)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: red,
                                    value: sendData['isRemember'],
                                    onChanged: (value) {
                                      setState(() {
                                        sendData['isRemember'] = !sendData['isRemember'];
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        sendData['isRemember'] = !sendData['isRemember'];
                                      });
                                    },
                                    child: Text(
                                      'remember'.tr,
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/reset-password-init');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: red,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'forgot_your_password'.tr + '?',
                                    style: TextStyle(
                                      color: red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 120,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: widgets.Button(
                    text: 'login'.tr,
                    onClick: () {
                      if (maskFormatter.getUnmaskedText().length > 3) {
                        setState(() {
                          sendData['username'] = '998' + maskFormatter.getUnmaskedText();
                        });
                      }
                      if (sendData['username'].length == 12) {
                        if (_formKey.currentState!.validate()) {
                          login();
                        }
                      }
                    },
                    disabled: sendData['username'].length == 12 || sendData['username'].length == 17 && sendData['password'].length > 3,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/registration');
                      },
                      child: Text(
                        'registration'.tr,
                        style: TextStyle(color: red, fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        loading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.4),
                child: SpinKitThreeBounce(
                  color: red,
                  size: 35.0,
                  controller: animationController,
                ),
              )
            : Container()
      ],
    );
  }
}
