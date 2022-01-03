import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../widgets.dart' as widgets;

import '../components/simple_app_bar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  dynamic character = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Войти',
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 20),
                child: Text(
                  'Номер телефона',
                  style: TextStyle(
                      color: globals.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 136),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(18.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Color(0xFFECECEC), width: 0.0),
                    ),
                    filled: true,
                    fillColor: globals.inputColor,
                    hintText: '+998',
                    hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
                  ),
                  style: TextStyle(color: globals.lightGrey),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 11),
                  child: Text(
                    'Нет аккаунта?',
                    style: TextStyle(color: globals.lightGrey, fontSize: 17),
                  ),
                ),
              ),
              Center(
                  child: GestureDetector(
                onTap: () {
                  Get.toNamed('/register');
                },
                child: Text(
                  'Зарегистрируйтесь',
                  style: TextStyle(
                      color: globals.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: widgets.Button(
          text: 'Продолжить',
          onClick: () {
            Get.toNamed('/confirmation');
          },
        ),
      ),
    );
  }
}
