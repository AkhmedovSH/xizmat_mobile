import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:xizmat/helpers/api.dart';

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

  changeTab(index) {
    setState(() {
      currentIndex = index;
      orders = [];
    });
    if (index == 0) {
      connect();
    }
    if (index == 1) {
      socket!.disconnect();
      getOtklick();
    }
    if (index == 2) {
      socket!.disconnect();
      getCompleted();
    }
  }

  getOtklick() async {
    final response = await get('/services/mobile/api/order-list/1');
    print(response);
    setState(() {
      orders = response;
    });
  }

  getCompleted() async {
    final response = await get('/services/mobile/api/order-list/2');
    setState(() {
      orders = response;
    });
  }

  setComplete(item) async {
    print(item);
    final response = await post('/services/mobile/api/order-completed', {
      "id": item['id'],
      "executorId": item['executorId'],
      "rating": 4.5,
      "rating_text": "buladi",
    });
    print(response);
    getCompleted();
  }

  void connect() async {
    // socket = IO.io('https://xizmat24.uz:9193/user-orders-1?apiKey=f72206f2-f2f7-11ec-9a5f-0242ac12000b', {
    //   "transports": ["websocket"],
    //   "autoConnect": false,
    //   "query": { "token": '/mobile' }
    // });
    final user = await get('/services/mobile/api/get-info');
    socket = IO.io(
        "http://mb.xizmat24.uz:9193/user-orders-1",
        IO.OptionBuilder()
            .enableForceNew() // <--- this method
            .setTransports(['websocket'])
            .setQuery({
              "apiKey": user['apiKey'],
            })
            .disableAutoConnect()
            .build());
    socket!.connect();
    socket!.onConnect((data) {
      // print(data);
      // print('connect');
    });
    socket!.on('user-orders-1', (data) {
      if (mounted) {
        setState(() => {orders = data});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    socket!.disconnect();
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
                      changeTab(index);
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
                        if (currentIndex == 1 || currentIndex == 2) {
                          Get.toNamed('/order-detail', arguments: {
                            'id': orders[i]['id'],
                            'value': currentIndex,
                          });
                          return;
                        }
                        if (currentIndex == 0) {
                          Get.toNamed('/order-inside', arguments: {
                            'id': orders[i]['id'],
                            'value': currentIndex,
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(12, 0, 12, 15),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          color: orders[i]['orderStatus'] == 2 ? inputColor : warning,
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
    );
  }
}
