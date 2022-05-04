import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/api.dart';
import '../../helpers/globals.dart';

class CategoriesChilds extends StatefulWidget {
  const CategoriesChilds({Key? key}) : super(key: key);

  @override
  _CategoriesChildsState createState() => _CategoriesChildsState();
}

class _CategoriesChildsState extends State<CategoriesChilds> {
  dynamic categories = [];

  searchCategories(value) async {
    final response = await get('/services/mobile/api/category-child-search-list', payload: {'search': value});
    setState(() {
      categories = response;
    });
  }

  getChildCategories() async {
    dynamic category = Get.arguments;
    final response = await get('/services/mobile/api/category-child-list/${category['id']}');
    print(response);
    setState(() {
      categories = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getChildCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back)),
                      suffixIcon: Icon(
                        Icons.cancel_sharp,
                        color: red,
                        size: 20,
                      ),
                      contentPadding: EdgeInsets.all(12.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF7F7F7),
                      hintText: 'Введите услугу',
                      hintStyle: TextStyle(color: lightGrey),
                    ),
                  ),
                ),
                Column(
                  children: [
                    for (var i = 0; i < categories.length; i++)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/step-layout', arguments: categories[i]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 21),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                categories[i]['name'],
                                style: TextStyle(color: black, fontSize: 18),
                              ),
                              Icon(Icons.arrow_forward, color: black)
                            ],
                          ),
                        ),
                      ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 21),
                    //   decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Врач',
                    //         style: TextStyle(color: black, fontSize: 18),
                    //       ),
                    //       Icon(Icons.arrow_forward, color: black)
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 21),
                    //   decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Муж на час',
                    //         style: TextStyle(color: black, fontSize: 18),
                    //       ),
                    //       Icon(Icons.arrow_forward, color: black)
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
