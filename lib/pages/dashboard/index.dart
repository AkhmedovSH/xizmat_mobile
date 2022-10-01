import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
    final response = await get('/services/mobile/api/category-top-list', payload: filter);
    if (response != null) {
      print(response);
      setState(() {
        topCategories = response;
      });
    }
  }

  getCategories() async {
    final response = await get('/services/mobile/api/category-list', payload: filter);
    if (response != null) {
      print(response);
      setState(() {
        categories = response;
      });
    }
  }

  getData() async {
    getUser();
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
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                          prefixIcon: Icon(
                            Icons.search,
                            color: lightGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.sort,
                            color: lightGrey,
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
                              Get.toNamed('/categories-childs', arguments: topCategories[i]);
                            },
                            child: Container(
                              width: 130,
                              height: 125,
                              margin: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FA),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: topCategories[i]['imageUrl'] != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.network(
                                              mainUrl + topCategories[i]['imageUrl'],
                                              height: 125,
                                              width: 130,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : SizedBox(
                                            height: 125,
                                            width: 130,
                                          ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: SizedBox(
                                      // margin: const EdgeInsets.all(8),
                                      width: 130,
                                      child: Text(
                                        '${topCategories[i]['name']}',
                                        style: TextStyle(fontWeight: FontWeight.w700, color: black),
                                      ),
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top: 10)),
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
                    childAspectRatio: 0.82,
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
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      child: categories[i]['imageUrl'] != null
                                          ? Image.network(
                                              mainUrl + categories[i]['imageUrl'],
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
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(top: 23, bottom: 10, right: 11, left: 11),
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
                                Positioned(
                                  top: 80,
                                  left: MediaQuery.of(context).size.width * 0.18,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                                    child: const Icon(
                                      Icons.check,
                                      color: Color(0xFF9C9C9C),
                                    ),
                                  ),
                                ),
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
    );
  }
}