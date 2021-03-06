import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/api.dart';
import '../../../helpers/globals.dart';

import '../../../../components/simple_app_bar.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic profile = [
    {
      'name': 'Уведомления',
      'icon': Icon(Icons.notifications),
      'function': () {},
    },
    {
      'name': 'Настройки',
      'icon': Icon(Icons.settings),
      'function': () {},
    },
    {
      'name': 'Выйти',
      'icon': Icon(Icons.logout),
    },
  ];

  dynamic sendData = {'imageUrl': null};

  Future pickImage() async {
    final source = await showImageSource(context);
    if (source == null) return;
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final response = await uploadImage('/services/gocashmobile/api/account-image-upload', File(img.path));
      String jsonsDataString = response.toString();
      final jsonData = jsonDecode(jsonsDataString);
      setState(() {
        sendData['imageUrl'] = jsonData['url'];
      });
    } on PlatformException catch (e) {
      print('ERROR: $e');
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('user');
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Поддержка',
        appBar: AppBar(),
        leading: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                      width: 86,
                      height: 86,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Color(0xFFF8F8F8), borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: lightGrey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      icon: Icon(
                        Icons.edit,
                        color: red,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  'Бахтиёр',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Center(
                child: Text(
                  '+998 (90) 123 45 67',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration:
                  BoxDecoration(color: inputColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  for (var i = 0; i < profile.length; i++)
                    GestureDetector(
                      onTap: () {
                        if (i == 2) {
                          logout();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 21),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE8E8E8)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              profile[i]['name'],
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: black),
                            ),
                            profile[i]['icon']
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.camera), child: Text('kamera'.tr)),
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.gallery), child: Text('galereya'.tr))
          ],
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('kamera'.tr),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text('galereya'.tr),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    }
  }
}
