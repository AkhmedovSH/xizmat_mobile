import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/helpers/api.dart';

import '../../helpers/globals.dart';

class OrderInsideFeedback extends StatefulWidget {
  const OrderInsideFeedback({Key? key}) : super(key: key);

  @override
  _OrderInsideFeedbackState createState() => _OrderInsideFeedbackState();
}

class _OrderInsideFeedbackState extends State<OrderInsideFeedback> {
  dynamic users = [];

  getOrder() async {
    final response = await get('/services/mobile/api/order-executor-list/1/${Get.arguments['id']}');
    setState(() {
      users = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < users.length; i++)
            GestureDetector(
              onTap: () {
                Get.toNamed('/specialist-inside', arguments: {'userId': users[i]['id'], 'orderId': Get.arguments['id']});
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: inputColor, borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 54,
                          height: 54,
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(50),
                              child: Image.network(
                                mainUrl + users[i]['imageUrl'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(50),
                          //   child: Image.network(mainUrl + users[i]['imageUrl']),
                          // ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Специалист окликнулся',
                              style: TextStyle(fontSize: 14, color: lightGrey, fontWeight: FontWeight.w600),
                            ),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              '${users[i]['name']}',
                              style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w600),
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
                                        Text('${users[i]['rating']}', style: TextStyle(color: black, fontWeight: FontWeight.w500))
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
                                      Text('${users[i]['countComments']}', style: TextStyle(color: lightGrey, fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(
                            '${users[i]['infoText']}',
                            style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: 8),
                        //   padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(50)),
                        //     gradient: LinearGradient(
                        //         colors: const [
                        //           Color(0xFFFF5353),
                        //           Color(0xFFF99247),
                        //         ],
                        //         begin: const FractionalOffset(0.0, 1.0),
                        //         end: const FractionalOffset(1.0, 0.0),
                        //         stops: const [0.0, 1.0],
                        //         tileMode: TileMode.clamp),
                        //   ),
                        //   child: Text(
                        //     '2',
                        //     style: TextStyle(fontSize: 14, color: white, fontWeight: FontWeight.bold),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
