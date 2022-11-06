import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/globals.dart';
import '../../helpers/api.dart';

// import '../../components/drawer_app_bar.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic topCategories = [];
  dynamic categories = [];
  dynamic user = {};

  dynamic teamService = [
    {
      'name': 'Лучшее',
      'select': false,
    },
    {
      'name': 'Персональные услуги',
      'select': false,
    },
    {
      'name': 'Персональные услуги',
      'select': false,
    },
  ];

  dynamic filter = {
    'search': '',
  };

  final focusNode = FocusNode();

  search(value) async {
    if (value.isNotEmpty) {
      if (value.length >= 3) {
        setState(() {
          filter['search'] = value;
        });
        getCategories();
        getTopCategories();
      } else {
        setState(() {
          filter['search'] = '';
        });
        getCategories();
        getTopCategories();
      }
    }
  }

  getUser() async {
    final response = await get('/services/mobile/api/get-info');
    if (response != null) {
      setState(() {
        user = response;
      });
    }
  }

  getTopCategories() async {
    final response = await guestGet('/services/mobile/api/category-top-list', payload: filter);
    if (response != null) {
      setState(() {
        topCategories = response;
      });
    }
  }

  getCategories() async {
    final response = await guestGet('/services/mobile/api/category-list', payload: filter);
    if (response != null) {
      setState(() {
        categories = response;
      });
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      getUser();
    }
    getTopCategories();
    getCategories();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'images/appBar.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: 250,
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.35,
                    bottom: 150,
                    child: SafeArea(
                      child: Image.asset(
                        'images/logo.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    child: user['name'] != null
                        ? Text(
                            'hello'.tr + ', ${user['name'] ?? ''}',
                            style: TextStyle(color: grey, fontWeight: FontWeight.w500),
                          )
                        : Text(''),
                  ),
                  Positioned(
                      bottom: 80,
                      child: Text(
                        'what_service_are_you_looking_for'.tr + '?',
                        style: TextStyle(color: grey, fontWeight: FontWeight.bold, fontSize: 24),
                      )),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: 330,
                        child: TextField(
                          onTap: () async {
                            // focusNode.unfocus();
                            // Future.delayed(Duration(milliseconds: 500), () {

                            // });
                            // final selected = await showSearch(
                            //   context: context,
                            //   delegate: delegate,
                            // );
                            // if (selected != null) {
                            //   if (selected != 0 && selected != _lastIntegerSelected) {
                            //     setState(() {
                            //       _lastIntegerSelected = selected;
                            //     });
                            //   }
                            // }
                          },
                          scrollPadding: EdgeInsets.only(bottom: 100),
                          focusNode: focusNode,
                          onChanged: (value) {
                            search(value);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              margin: EdgeInsets.only(left: 12),
                              width: 19,
                              height: 19,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'images/icons/search.svg',
                                    width: 19,
                                    height: 19,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            ),
                            suffixIcon: Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 19,
                              height: 19,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'images/icons/filter.svg',
                                    width: 19,
                                    height: 19,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(18.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Color(0xFFECECEC), width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Color(0xFFECECEC), width: 0.0),
                            ),
                            filled: true,
                            fillColor: inputColor,
                            hintText: 'specialist_or_service'.tr,
                            hintStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                          style: TextStyle(color: lightGrey),
                        ),
                      ))
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              'popular'.tr,
                              style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed('/categories');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'all_categories'.tr,
                                    style: TextStyle(color: red, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: red,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < topCategories.length; i++)
                            GestureDetector(
                              onTap: () {
                                if (topCategories[i]['activated']) {
                                  Get.toNamed('/categories-childs', arguments: topCategories[i]);
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                height: 200,
                                margin: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F7FA),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      height: 105,
                                      child: topCategories[i]['mainImageUrl'] != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                mainUrl + topCategories[i]['mainImageUrl'],
                                                height: 105,
                                                width: MediaQuery.of(context).size.width * 0.42,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : SizedBox(
                                              height: 105,
                                              width: MediaQuery.of(context).size.width * 0.42,
                                            ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 12),
                                      child: Text(
                                        '${topCategories[i]['name'] ?? ''}',
                                        style: TextStyle(
                                          color: Color(0xFF40484E),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      child: Text(
                        'services'.tr,
                        style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.count(
                      childAspectRatio: 0.80,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(right: 16),
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 2,
                      children: [
                        for (int i = 0; i < categories.length; i++)
                          GestureDetector(
                            onTap: () {
                              if (categories[i]['activated']) {
                                Get.toNamed('/categories-childs', arguments: categories[i]);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: inputColor,
                                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(0),
                                            child: categories[i]['mainImageUrl'] != null
                                                ? Image.network(
                                                    mainUrl + categories[i]['mainImageUrl'],
                                                    height: 105,
                                                    width: double.infinity,
                                                    fit: BoxFit.fill,
                                                  )
                                                : SizedBox(
                                                    height: 105,
                                                    width: double.infinity,
                                                  ),
                                            // child: Image.asset('images/p$i.png', height: 105, width: double.infinity, fit: BoxFit.fill),
                                          ),
                                          !categories[i]['activated']
                                              ? Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      color: lightGrey.withOpacity(0.5),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          !categories[i]['activated']
                                              ? Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: white.withOpacity(0.5),
                                                        border: Border.all(
                                                          color: white.withOpacity(0.5),
                                                        ),
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: Text(
                                                        'soon'.tr,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          // Positioned.fill(
                                          //   right: 0,
                                          //   top: 0,
                                          //   child: RotationTransition(
                                          //     turns: AlwaysStoppedAnimation(10 / 360),
                                          //     child: Align(
                                          //       alignment: Alignment.topRight,
                                          //       child: Container(
                                          //         padding: EdgeInsets.all(6),
                                          //         color: red,
                                          //         child: Text('data',),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(top: 30, bottom: 10, right: 11, left: 11),
                                        padding: const EdgeInsets.symmetric(horizontal: 11),
                                        child: Text(
                                          '${categories[i]['name'] ?? ''}',
                                          style: TextStyle(
                                            fontFamily: 'ProDisplay',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: double.infinity,
                                      //   child: Text(
                                      //     '123 44 +',
                                      //     style: TextStyle(
                                      //       color: Color(0xFF9C9C9C),
                                      //       fontFamily: 'ProDisplay',
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold,
                                      //     ),
                                      //     textAlign: TextAlign.center,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  categories[i]['iconCode'] != null && categories[i]['iconCode'] != ''
                                      ? Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: white,
                                                borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                                              child: Container(
                                                child: Image.network(
                                                  mainUrl + categories[i]['iconCode'],
                                                  width: 24,
                                                  height: 24,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              // child: IconTheme(
                                              //   data: IconThemeData(
                                              //     color: Color(0xFF9C9C9C),
                                              //   ),
                                              //   child: Icon(
                                              //     IconData(
                                              //       int.parse(categories[i]['iconCode'] ?? 0xe156),
                                              //       fontFamily: 'MaterialIcons',
                                              //     ),
                                              //   ),
                                              // ),

                                              // child: const Icon(
                                              //   Icons.check,
                                              //   color: Color(0xFF9C9C9C),
                                              // ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  categories[i]['newIcon'] != null && categories[i]['newIcon']
                                      ? Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              // width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                bottom: 15,
                                                right: 11,
                                                left: 11,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: red,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                'new_2'.tr,
                                                style: TextStyle(
                                                  fontFamily: 'ProDisplay',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      height: 30,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
