import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../helpers/globals.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int currentIndex = 0;
  IO.Socket? socket;
  dynamic orders = [];

  void connect() async {
    // socket = IO.io('https://xizmat24.uz:9193/user-orders-1?apiKey=f72206f2-f2f7-11ec-9a5f-0242ac12000b', {
    //   "transports": ["websocket"],
    //   "autoConnect": false,
    //   "query": { "token": '/mobile' }
    // });
    socket = IO.io(
        "http://mb.xizmat24.uz:9193/user-orders-1",
        IO.OptionBuilder()
            .enableForceNew() // <--- this method
            .setTransports(['websocket'])
            .setQuery({
              "apiKey": "f72206f2-f2f7-11ec-9a5f-0242ac12000b",
            })
            .disableAutoConnect()
            .build());

    socket!.connect();
    socket!.onConnect((data) {
      print(data);
      print('connect');
    });
    socket!.on('user-orders-1', (data) {
      print(data);
      if (mounted) {
        setState(() {
          orders = data;
        });
      }
    });
    print(socket!.connected);
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 25),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    labelColor: black,
                    indicatorColor: orange,
                    indicatorWeight: 2,
                    labelStyle: TextStyle(fontSize: 14.0, color: black, fontWeight: FontWeight.w500),
                    unselectedLabelStyle: TextStyle(fontSize: 14.0, color: Color(0xFF9B9B9B)),
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
              ),
              Column(
                children: [
                  for (var i = 0; i < orders.length; i++)
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/order-inside');
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: inputColor,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 11),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '№ ${orders[i]['orderNumber']}',
                                    style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  currentIndex == 0
                                      ? Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: 4,
                                              width: 4,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFE32F45),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text('${orders[i]['countExecutors']} откликов',
                                                style: TextStyle(color: Color(0xFFE32F45), fontWeight: FontWeight.w500)),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${orders[i]['categoryChildName']}',
                                  style: TextStyle(color: black, fontSize: 18),
                                ),
                                Icon(Icons.arrow_forward, color: black)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF5353),
                      Color(0xFFF99247),
                    ],
                    begin: FractionalOffset(0.0, 1.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 26,
                ),
              ))
          : Container(),
    );
  }
}
