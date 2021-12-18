import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: 0,
        backgroundColor: globals.white,
        selectedItemColor: globals.black,
        selectedIconTheme: IconThemeData(color: globals.black),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
              icon:
                  Icon(Icons.shopping_cart_outlined, color: Color(0xFF828282)),
              label: 'Мои заказы'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color(0xFF828282)),
              label: 'Профиль'),
          BottomNavigationBarItem(
              icon: Icon(Icons.headset_mic, color: Color(0xFF828282)),
              label: 'Поддержка'),
        ]);
  }
}
