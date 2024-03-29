import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/helpers/api.dart';

import './order_inside_feedback.dart';
import './order_inside_all_specialists.dart';

import '../../helpers/globals.dart';

import '../../components/simple_app_bar.dart';

class OrderInside extends StatefulWidget {
  const OrderInside({Key? key}) : super(key: key);

  @override
  _OrderInsideState createState() => _OrderInsideState();
}

class _OrderInsideState extends State<OrderInside> {
  int currentIndex = 0;
  dynamic order = {};

  orderCancel() async {
    final response = await post('/services/mobile/api/order-cancel', {
      'id': Get.arguments['id'],
    });
    if (response != null) {
      if (response['success']) {
        Get.back();
      }
    }
  }

  getOrder() async {
    final response = await get('/services/mobile/api/order/${Get.arguments['id']}');
    setState(() {
      order = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: '№ ${order['orderNumber']}',
        appBar: AppBar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 13, bottom: 20),
                    child: Text(
                      '${order['categoryChildName']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(color: inputColor, borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = 0;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: currentIndex == 0 ? white : Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(4))),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'responses'.tr,
                                    style: TextStyle(fontSize: 16, color: currentIndex == 0 ? black : lightGrey, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = 1;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                color: currentIndex == 1 ? white : Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(4))),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'all_specialists'.tr,
                                    style: TextStyle(fontSize: 16, color: currentIndex == 1 ? black : lightGrey, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      currentIndex == 0 ? OrderInsideFeedback() : OrderInsideAllSpecialists(),
                    ],
                  )
                ],
              ),
            ),
          ),
          order['orderStatus'] == 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, spreadRadius: -3, blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 45,
                          // margin: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              final category = await get(
                                '/services/mobile/api/category-child-list/${order['categoryId']}',
                              );
                              Get.toNamed('/step-layout', arguments: {
                                'category': category[0],
                                'value': 1,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              elevation: 0,
                              primary: white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: red),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: Text(
                              'edit_order'.tr,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: red),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              orderCancel();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              elevation: 0,
                              primary: white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: Text(
                              'delete_order'.tr,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
      // floatingActionButton: order['orderStatus'] == 0
      //     ? Container(
      //         width: MediaQuery.of(context).size.width,
      //         margin: EdgeInsets.only(left: 32),
      //         height: 45,
      //         child: ElevatedButton(
      //           onPressed: () {
      //             orderCancel();
      //           },
      //           style: ElevatedButton.styleFrom(
      //             padding: EdgeInsets.symmetric(vertical: 8),
      //             elevation: 0,
      //             primary: danger,
      //             shape: RoundedRectangleBorder(
      //               side: BorderSide(color: danger),
      //               borderRadius: BorderRadius.circular(7),
      //             ),
      //           ),
      //           child: Text(
      //             'Удалить заказ',
      //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: white),
      //           ),
      //         ),
      //       )
      //     : Container(),
    );
  }
}
