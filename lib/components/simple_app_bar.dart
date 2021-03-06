import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/globals.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBar? appBar;
  final bool? leading;
  const SimpleAppBar({Key? key, this.title, @required this.appBar, this.leading = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: TextStyle(
          color: black,
        ),
      ),
      centerTitle: true,
      leading: leading!
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: black,
              ))
          : Container(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar!.preferredSize.height);
}
