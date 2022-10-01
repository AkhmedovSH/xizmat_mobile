import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:xizmat/helpers/api.dart';
import 'package:xizmat/helpers/globals.dart';

import 'package:xizmat/components/simple_app_bar.dart';
import 'package:xizmat/components/widgets.dart';

class OrderReview extends StatefulWidget {
  const OrderReview({Key? key}) : super(key: key);

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  dynamic sendData = {
    'id': Get.arguments,
    'rating': '4',
    'rating_text': '',
  };

  orderCompleted() async {
    final response = await post('/services/mobile/api/order-completed', sendData);
    if (response != null) {
      Get.back(result: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppBar(
            appBar: AppBar(),
            leading: true,
            title: '',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25, top: 25),
                  child: Center(
                    child: Text(
                      'service_completed'.tr + '?',
                      style: TextStyle(
                        color: Color(0xFF40484E),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: RatingBar.builder(
                    initialRating: 4,
                    minRating: 1,
                    direction: Axis.horizontal,
                    glowColor: Color(0xFFF3A919),
                    itemCount: 5,
                    unratedColor: Color(0XFFC4C4C4),
                    itemPadding: EdgeInsets.symmetric(horizontal: 15.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Color(0xFFF3A919),
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        sendData['rating'] = rating.round();
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required_field'.tr;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        sendData['username'] = value;
                      });
                    },
                    maxLines: 5, //or null
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      focusColor: red,
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      hintText: 'your_comment'.tr + '...',
                      hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 32),
            child: Button(
              text: 'confirm'.tr,
              onClick: () {
                orderCompleted();
              },
            ),
          ),
        ),
      ],
    );
  }
}
