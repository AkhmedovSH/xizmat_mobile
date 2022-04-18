import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../helpers/globals.dart';
import '../../helpers/widgets.dart' as widgets;

import '../../components/simple_app_bar.dart';

class Step1 extends StatefulWidget {
  const Step1({Key? key}) : super(key: key);

  @override
  _Step1State createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  dynamic character = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Место оказания услуги',
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 50,
                animation: true,
                lineHeight: 6.0,
                animationDuration: 500,
                percent: 0.2,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: red,
                backgroundColor: const Color(0xFFF8F8F8),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                child: const Text(
                  'Шаг 1 /5',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'У меня',
                    style: TextStyle(color: black, fontSize: 18),
                  ),
                  Transform.scale(
                    scale: 1,
                    child: Radio(
                      onChanged: (value) {
                        setState(() {
                          character = value;
                        });
                      },
                      value: 1,
                      groupValue: character,
                      activeColor: black,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'У специалиста',
                    style: TextStyle(color: black, fontSize: 18),
                  ),
                  Transform.scale(
                    scale: 1,
                    child: Radio(
                      onChanged: (value) {
                        setState(() {
                          character = value;
                        });
                      },
                      value: 2,
                      groupValue: character,
                      activeColor: black,
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //     margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.all(Radius.circular(5)),
            //       child: LinearProgressIndicator(
            //         value: 0.25,
            //         color: red,
            //         backgroundColor: Color(0xFFF8F8F8),
            //         minHeight: 4.0,
            //       ),
            //     ))
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 32),
        child: widgets.Button(
          text: 'Продолжить',
          onClick: () => {Get.toNamed('/step-2')},
        ),
      ),
    );
  }
}
