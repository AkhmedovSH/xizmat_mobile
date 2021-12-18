import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart' as globals;

class FastSearch extends StatefulWidget {
  const FastSearch({Key? key}) : super(key: key);

  @override
  _FastSearchState createState() => _FastSearchState();
}

class _FastSearchState extends State<FastSearch> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back)),
                  suffixIcon: Icon(
                    Icons.close,
                    color: globals.red,
                  ),
                  contentPadding: EdgeInsets.all(18.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide:
                        BorderSide(color: Color(0xFFECECEC), width: 0.0),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF3F7FA),
                  hintText: 'Специалист или услуга',
                  hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
                ),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                labelColor: globals.black,
                indicatorColor: globals.orange,
                indicatorWeight: 3,
                labelStyle: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF272727),
                    fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 16.0, color: Color(0xFF9B9B9B)),
                // controller: ,
                tabs: const [
                  Tab(
                    text: 'Категории услуг',
                  ),
                  Tab(
                    text: 'История',
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Репетитор',
                        style: TextStyle(color: globals.black, fontSize: 18),
                      ),
                      Icon(Icons.arrow_forward, color: globals.black)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Врач',
                        style: TextStyle(color: globals.black, fontSize: 18),
                      ),
                      Icon(Icons.arrow_forward, color: globals.black)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Муж на час',
                        style: TextStyle(color: globals.black, fontSize: 18),
                      ),
                      Icon(Icons.arrow_forward, color: globals.black)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
