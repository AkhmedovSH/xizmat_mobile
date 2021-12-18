import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart' as globals;

import '../components/bottom_bar.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTabController(
                length: 3,
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  labelColor: globals.black,
                  indicatorColor: globals.orange,
                  indicatorWeight: 2,
                  labelStyle: TextStyle(
                      fontSize: 14.0,
                      color: globals.black,
                      fontWeight: FontWeight.w500),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14.0, color: Color(0xFF9B9B9B)),
                  // controller: ,
                  tabs: const [
                    Tab(
                      text: 'Новые',
                    ),
                    Tab(
                      text: 'Текущие',
                    ),
                    Tab(
                      text: 'Завершенные',
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/tutor');
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: EdgeInsets.symmetric(vertical: 21),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xFFF2F2F2)))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Репетитор',
                            style:
                                TextStyle(color: globals.black, fontSize: 18),
                          ),
                          Icon(Icons.arrow_forward, color: globals.black)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.symmetric(vertical: 21),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xFFF2F2F2)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Врач',
                          style: TextStyle(color: globals.black, fontSize: 18),
                        ),
                        Icon(Icons.arrow_forward, color: globals.black)
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    padding: EdgeInsets.symmetric(vertical: 21),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Color(0xFFF2F2F2)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Муж на час',
                          style: TextStyle(color: globals.black, fontSize: 18),
                        ),
                        Icon(Icons.arrow_forward, color: globals.black)
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
