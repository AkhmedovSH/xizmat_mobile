import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';

class Success extends StatefulWidget {
  const Success({Key? key}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: Text(
              'your_order_has_been_placed'.tr + '!',
              style: TextStyle(color: Color(0xFF363F4D), fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(bottom: 22),
          //   child: Text(
          //     'ID заказа: 098 000!',
          //     style: TextStyle(color: Color(0xFF363F4D), fontSize: 16, fontWeight: FontWeight.w500),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(bottom: 22, left: 29, right: 29),
            child: Text(
              'you_can_track_order_responses_in_your_profile_under_my_orders'.tr + '!',
              style: TextStyle(color: lightGrey, fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed('/', arguments: 1);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'my_orders'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed('/');
                },
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    'choose_another_service'.tr,
                    style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: black,
              )
            ],
          )
        ],
      ),
    );
  }
}
