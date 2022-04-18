import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../helpers/globals.dart';

class TransperentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar? appBar;
  final bool? leading;
  final Brightness? brightness;
  final Color? statusBarColor;
  const TransperentAppBar({
    Key? key,
    @required this.appBar,
    this.leading = true,
    this.brightness = Brightness.dark,
    this.statusBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarColor: statusBarColor,
      ),
      backgroundColor: Colors.white,
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
