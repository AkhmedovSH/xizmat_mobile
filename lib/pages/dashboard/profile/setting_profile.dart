import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/globals.dart';
import '../../../helpers/api.dart';
import '../../../helpers/widgets.dart' as widgets;

import 'package:xizmat/components/transperent_app_bar.dart';
import 'package:xizmat/helpers/location_notification_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  dynamic sendData = {
    'username': '', // 998 998325455
    'password': '', // 112233
  };
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransperentAppBar(
        appBar: AppBar(),
        leading: false,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Добро пожаловать в xizmat'.tr,
                  style: TextStyle(color: black, fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Войдите в систему чтобы продолжить'.tr,
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
                          initialValue: sendData['username'],
                          onChanged: (value) {
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
                          initialValue: sendData['password'],
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
                  ],
                ),
              ),
            ],
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
                text: 'Войти',
                onClick: () {},
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Нет аккаунта'.tr + '?',
                  style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/registration');
                  },
                  child: Text(
                    'Регистрация'.tr,
                    style: TextStyle(color: red, fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
