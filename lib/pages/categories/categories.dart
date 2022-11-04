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
    final response = await guestGet('/services/mobile/api/category-list');
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
                    child: GestureDetector(
                      onTap: () {
                        if (categories[i]['activated']) {
                          Get.toNamed('/categories-childs', arguments: categories[i]);
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 200,
                        margin: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              height: 116,
                              child: categories[i]['mainImageUrl'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        mainUrl + categories[i]['mainImageUrl'],
                                        height: 105,
                                        width: MediaQuery.of(context).size.width,
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
                                '${categories[i]['name'] ?? ''}',
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
