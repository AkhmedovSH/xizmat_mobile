import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart' as globals;

import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBar? appBar;
  final bool? leading;
  const SimpleAppBar(
      {Key? key, this.title, @required this.appBar, this.leading = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title!,
        style: TextStyle(
          color: globals.black,
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
                color: globals.black,
              ))
          : Container(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar!.preferredSize.height);
}
