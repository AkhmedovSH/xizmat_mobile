import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';

import 'step_1.dart';
import 'step_2.dart';
import 'step_3.dart';
import 'step_4.dart';
import 'step_5.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  changeIndex() {
    if (currentIndex == 0) {
      Get.back();
    } else {
      setState(() {
        currentIndex = currentIndex - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Step ${currentIndex + 1}',
            style: TextStyle(
              color: black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                changeIndex();
              },
              icon: Icon(
                Icons.arrow_back,
                color: black,
              ))),
      body: IndexedStack(
        index: currentIndex,
        children: [
          currentIndex == 0 ? const Step1() : Container(),
          currentIndex == 1 ? const Step2() : Container(),
          currentIndex == 2 ? const Step3() : Container(),
          currentIndex == 3 ? const Step4() : Container(),
          currentIndex == 4 ? const Step5() : Container(),
        ],
      ),
    );
  }
}
