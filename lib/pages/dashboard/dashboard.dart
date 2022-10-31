import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../helpers/globals.dart';

import 'profile/profile.dart';
import 'support.dart';
import 'index.dart';
import 'orders.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      currentIndex = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: IndexedStack(
        index: currentIndex,
        children: [
          currentIndex == 0 ? Index() : Container(),
          currentIndex == 1 ? const Orders() : Container(),
          currentIndex == 2 ? const Profile() : Container(),
          currentIndex == 3 ? const Support() : Container(),
        ],
      ),
      // drawer: currentIndex == 0
      //     ? Container(
      //         padding: const EdgeInsets.all(0),
      //         width: MediaQuery.of(context).size.width * 0.75,
      //         child: Drawer(
      //           child: SafeArea(
      //             child: Container(
      //               color: Colors.white,
      //               child: Column(
      //                 //mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   SizedBox(
      //                     height: 20,
      //                   ),
      //                   buildListTile(
      //                     context,
      //                     'Быстрый поиск',
      //                     Icons.search,
      //                     '/fast-search',
      //                   ),
      //                   buildListTile(
      //                     context,
      //                     'Категории услуг',
      //                     Icons.category,
      //                     '/categories',
      //                   ),
      //                   buildListTile(
      //                     context,
      //                     'Мои заказы',
      //                     Icons.list_alt,
      //                     '/orders',
      //                   ),
      //                   buildListTile(
      //                     context,
      //                     'Заказать через менеджера',
      //                     Icons.support_agent,
      //                     '/order-by-manager',
      //                   ),
      //                   buildListTile(
      //                     context,
      //                     'Поддержка',
      //                     Icons.settings_suggest,
      //                     '/support',
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : Container(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          // color: white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: -3, blurRadius: 5),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            onTap: changeIndex,
            currentIndex: currentIndex,
            backgroundColor: white,
            selectedItemColor: red,
            selectedIconTheme: IconThemeData(color: red),
            selectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: currentIndex != 0
                    ? SvgPicture.asset(
                        'images/icons/home.svg',
                      )
                    : SvgPicture.asset(
                        'images/icons/home_active.svg',
                      ),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: currentIndex != 1
                    ? SvgPicture.asset(
                        'images/icons/list.svg',
                      )
                    : SvgPicture.asset(
                        'images/icons/list_active.svg',
                      ),
                label: 'my_orders'.tr,
              ),
              BottomNavigationBarItem(
                icon: currentIndex != 2
                    ? SvgPicture.asset(
                        'images/icons/profile.svg',
                      )
                    : SvgPicture.asset(
                        'images/icons/profile_active.svg',
                      ),
                label: 'profile'.tr,
              ),
              BottomNavigationBarItem(
                icon: currentIndex != 3
                    ? SvgPicture.asset(
                        'images/icons/support.svg',
                      )
                    : SvgPicture.asset(
                        'images/icons/support_active.svg',
                      ),
                label: 'support'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          // Navigator.pop(context),
          if (routeName == '/orders') {
            Navigator.pop(context);
            changeIndex(1);
            return;
          }
          Get.offAllNamed(routeName);
        },
      ),
    );
  }
}
