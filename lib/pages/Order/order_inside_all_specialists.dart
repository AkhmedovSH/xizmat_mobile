import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/helpers/api.dart';
import '../../helpers/globals.dart';

class OrderInsideAllSpecialists extends StatefulWidget {
  const OrderInsideAllSpecialists({Key? key}) : super(key: key);

  @override
  _OrderInsideAllSpecialistsState createState() => _OrderInsideAllSpecialistsState();
}

class _OrderInsideAllSpecialistsState extends State<OrderInsideAllSpecialists> {
  dynamic users = [];

  getOrder() async {
    final response = await get('/services/mobile/api/order-executor-list/2/${Get.arguments['id']}');
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
    return Column(
      children: [
        for (var i = 0; i < users.length; i++)
          GestureDetector(
            onTap: () {
              Get.toNamed('/specialist-inside', arguments: {'userId': users[i]['id'], 'orderId': Get.arguments['id'], 'value': 2});
            },
            child: Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 15),
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
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                '${users[i]['infoText']}',
                                style: TextStyle(fontSize: 16, color: black, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Text(
                        //     'Еще',
                        //     style: TextStyle(fontSize: 14, color: red, fontWeight: FontWeight.bold),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
