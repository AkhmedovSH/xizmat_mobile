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
      'name': 'notifications'.tr,
      'icon': Icon(Icons.notifications),
      'function': () {},
    },
    {
      'name': 'settings'.tr,
      'icon': Icon(Icons.settings),
      'function': () {},
    },
    {
      'name': 'language'.tr,
      'icon': Icon(Icons.settings),
      'function': () {},
    },
    {
      'name': 'go_out'.tr,
      'icon': Icon(Icons.logout),
    },
  ];
  dynamic sendData = {'imageUrl': ''};
  dynamic user = {'imageUrl': null};

  Future pickImage() async {
    final source = await showImageSource(context);
    if (source == null) return;
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final response = await uploadImage('/services/mobile/api/upload/image', File(img.path));
      String jsonsDataString = response.toString();
      final jsonData = jsonDecode(jsonsDataString);
      final user = await get('/services/mobile/api/get-info');
      setState(() {
        user['regionId'] = 0;
        user['regionName'] = '';
        user['cityId'] = 0;
        user['cityName'] = '';
        user['imageUrl'] = jsonData['url'];
      });
      await put('/services/mobile/api/update-client', user);
      getUser();
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

  getUser() async {
    final response = await get('/services/mobile/api/get-info');
    if (response != null) {
      print(response);
      setState(() {
        user = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'support'.tr,
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
                    child: user == null || user['imageUrl'] == null || user['imageUrl'] == ''
                        ? Container(
                            width: 86,
                            height: 86,
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: lightGrey,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            width: 86,
                            height: 86,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                mainUrl + user['imageUrl'],
                                fit: BoxFit.fill,
                              ),
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
                  '${user['name'] ?? 'not_set'.tr}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Center(
                child: Text(
                  // '${user['phone'] != null ? formatPhone(user['phone']) : ''}',
                  '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration:
                  BoxDecoration(color: inputColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  for (var i = 0; i < profile.length; i++)
                    GestureDetector(
                      onTap: () async {
                        if (i == 1) {
                          await Get.toNamed('/profile-setting');
                          getUser();
                        }
                        if (i == 2) {
                          openLanguageDialog();
                        }
                        if (i == 3) {
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

  openLanguageDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
              child: Row(
            children: [],
          )),
          // actions: <Widget>[
          //   TextButton(
          //     child: const Text('Approve'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'add_from_gallery'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: black,
                      ),
                    ),
                    Icon(
                      Icons.camera_alt,
                      color: lightGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'take_photo'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: black,
                      ),
                    ),
                    Icon(
                      Icons.image,
                      color: lightGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'cancel'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: black,
                      ),
                    ),
                    Icon(
                      Icons.close,
                      color: lightGrey,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
