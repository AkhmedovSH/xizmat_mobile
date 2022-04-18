import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';
import '../../helpers/widgets.dart' as widgets;

import '../../components/simple_app_bar.dart';

class OrderByManager extends StatefulWidget {
  const OrderByManager({Key? key}) : super(key: key);

  @override
  _OrderByManagerState createState() => _OrderByManagerState();
}

class _OrderByManagerState extends State<OrderByManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Регистрация',
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
                margin: EdgeInsets.only(bottom: 15, top: 25),
                child: Text(
                  'Отправьте ваши контакты',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Ваше имя',
                  style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(18.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color(0xFFECECEC), width: 0.0),
                    ),
                    filled: true,
                    fillColor: inputColor,
                    hintText: 'Введите имя',
                    hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
                  ),
                  style: TextStyle(color: lightGrey),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Номер телефона',
                  style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 96),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(18.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Color(0xFFECECEC), width: 0.0),
                    ),
                    filled: true,
                    fillColor: inputColor,
                    hintText: '+998',
                    hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
                  ),
                  style: TextStyle(color: lightGrey),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: widgets.Button(
          text: 'Отправить',
          onClick: () {
            Get.toNamed('/order-by-manager-success');
          },
        ),
      ),
    );
  }
}
