import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/helpers/api.dart';

import '../helpers/globals.dart';
import '../components/widgets.dart' as widgets;

import '../components/simple_app_bar.dart';

class SpecialistInside extends StatefulWidget {
  const SpecialistInside({Key? key}) : super(key: key);

  @override
  _SpecialistInsideState createState() => _SpecialistInsideState();
}

class _SpecialistInsideState extends State<SpecialistInside> {
  dynamic user = {};
  dynamic passImageUrlList = [];
  dynamic certUrlList = [];
  dynamic galleryUrlList = [];
  dynamic educationList = [];
  dynamic note = '';

  orderAccept() async {
    dynamic sendData = {
      "id": Get.arguments['orderId'],
      "executorId": Get.arguments['userId'],
      "note": note,
    };
    if (Get.arguments['value'] == 2) {
      final interested = await post('/services/mobile/api/order-interested', sendData);
      if (interested != null) {
        Get.offAllNamed('/', arguments: 1);
      }
      return;
    }
    final response = await post('/services/mobile/api/order-accept', sendData);
    if (response != null) {
      Get.offAllNamed('/', arguments: 1);
    }
  }

  getOrder() async {
    final response = await get('/services/mobile/api/executor/${Get.arguments['userId']}');
    setState(() {
      user = response;
      passImageUrlList = user['passImageUrlList'];
      certUrlList = user['certUrlList'];
      galleryUrlList = user['galleryUrlList'];
      educationList = user['educationList'];
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
        title: 'about_the_executor'.tr,
        appBar: AppBar(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: user['imageUrl'] != null
                                ? Image.network(
                                    mainUrl + user['imageUrl'],
                                    height: 64,
                                    width: 64,
                                    fit: BoxFit.fill,
                                  )
                                : Container(),
                          ),
                          Padding(padding: EdgeInsets.only(right: 10)),
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Text(
                                  '${user['name']}',
                                  style: TextStyle(fontSize: 17, color: black, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xFFF3A919),
                                              size: 18,
                                            ),
                                            Padding(padding: EdgeInsets.only(right: 5)),
                                            Text(
                                              '${user['rating']}',
                                              style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.feedback_outlined,
                                            color: lightGrey,
                                          ),
                                          Padding(padding: EdgeInsets.only(right: 5)),
                                          Text(
                                            '${user['countComments']}',
                                            style: TextStyle(
                                              color: lightGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'about_myself'.tr,
                            style: TextStyle(
                              color: black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'certificates_and_documents'.tr,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < passImageUrlList.length; i++)
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: InteractiveViewer(
                              clipBehavior: Clip.none,
                              child: Image.network(
                                mainUrl + user['passImageUrlList'][i]['fileUrl'],
                                height: 100,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        for (var i = 0; i < certUrlList.length; i++)
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: InteractiveViewer(
                              clipBehavior: Clip.none,
                              child: Image.network(
                                mainUrl + user['certUrlList'][i]['fileUrl'],
                                height: 100,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 15),
                    child: Text(
                      'services'.tr,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Column(
                    children: [
                      for (var i = 0; i < educationList.length; i++)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: Color(0xFFDADADA), width: 1.0),
                          )),
                          child: Text(
                            '${educationList[i]['title']}',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 15),
                    child: Text(
                      'portfolio'.tr,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < galleryUrlList.length; i++)
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Image.network(
                              mainUrl + user['galleryUrlList'][i]['fileUrl'],
                              height: 120,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                          )
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 25, bottom: 15),
                  //   child: Text(
                  //     'Отзывы об исполнителе',
                  //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  //   ),
                  // ),
                  // Column(
                  //   children: [
                  //     for (var i = 0; i < 5; i++)
                  //       Container(
                  //         margin: EdgeInsets.only(bottom: 15),
                  //         padding: EdgeInsets.all(15),
                  //         decoration: BoxDecoration(color: inputColor, borderRadius: BorderRadius.circular(10)),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: const [
                  //                 Text(
                  //                   'Гульмирова Гульноза',
                  //                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  //                 ),
                  //                 Text(
                  //                   '02.05.2021',
                  //                   style: TextStyle(color: Color(0xFF707070), fontWeight: FontWeight.w500),
                  //                 )
                  //               ],
                  //             ),
                  //             Container(
                  //               margin: EdgeInsets.only(top: 5, bottom: 10),
                  //               child: Row(
                  //                 children: [
                  //                   for (var i = 0; i < 5; i++)
                  //                     Container(
                  //                       margin: EdgeInsets.only(right: 5),
                  //                       child: Icon(
                  //                         Icons.star,
                  //                         color: yellow,
                  //                         size: 16,
                  //                       ),
                  //                     )
                  //                 ],
                  //               ),
                  //             ),
                  //             Text('Обучает моего сына уже три года. Уровень английского просто на высоте. Настоящий практик и знаток своего дела.',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 15,
                  //                 )),
                  //           ],
                  //         ),
                  //       ),
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: widgets.OutlinedButton(
                      text: 'show_more_reviews'.tr,
                      onClick: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Get.arguments['interested']
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                            onPressed: () {
                              orderAccept();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'offer_an_order'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              elevation: 0,
                              backgroundColor: white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: black),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: Text(
                              'write'.tr,
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: black),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
