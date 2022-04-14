import 'package:flutter/material.dart';

import '../../globals.dart';

import 'profile.dart';
import 'support.dart';
import 'index.dart';
import 'orders.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          currentIndex == 0 ? const Index() : Container(),
          currentIndex == 1 ? const Orders() : Container(),
          currentIndex == 2 ? const Profile() : Container(),
          currentIndex == 3 ? const Support() : Container(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          // color: globals.white,
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
              selectedItemColor: black,
              selectedIconTheme: IconThemeData(color: black),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Главная'),
                BottomNavigationBarItem(icon: Icon(Icons.list_alt, color: Color(0xFF828282)), label: 'Мои заказы'),
                BottomNavigationBarItem(icon: Icon(Icons.person, color: Color(0xFF828282)), label: 'Профиль'),
                BottomNavigationBarItem(icon: Icon(Icons.headset_mic, color: Color(0xFF828282)), label: 'Поддержка'),
              ]),
        ),
      ),
    );
  }
}
