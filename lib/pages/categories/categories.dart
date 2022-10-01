import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';
import 'package:xizmat/helpers/api.dart';

import '../../components/simple_app_bar.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  dynamic categories = [];

  getCategories() async {
    final response = await get('/services/mobile/api/category-list');
    if (response != null) {
      print(response);
      setState(() {
        categories = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'service_categories'.tr,
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (var i = 0; i < categories.length; i++)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 140,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/categories-childs', arguments: categories[i]);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF4F7FA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: categories[i]['imageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        mainUrl + categories[i]['imageUrl'],
                                        height: 130,
                                        width: MediaQuery.of(context).size.width * 0.46,
                                        fit: BoxFit.fill,
                                        // fit: BoxFit.fill,
                                      ),
                                    )
                                  : Container(
                                      // child: Image.asset(
                                      //   'images/build-logo.png',
                                      //   height: 80,
                                      //   width: 100,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  '${categories[i]['name'] ?? ''} ',
                                  style: TextStyle(fontWeight: FontWeight.w700, color: black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
