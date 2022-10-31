import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:xizmat/helpers/api.dart';

import '../../helpers/globals.dart';

import '../../components/simple_app_bar.dart';
import '../../components/widgets.dart';

class SelectCity extends StatefulWidget {
  const SelectCity({Key? key}) : super(key: key);

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  dynamic cities = [];
  dynamic selectedButton = '0';

  setcities() async {
    Get.arguments['stepOrder']['cityId'] = selectedButton;
    Get.toNamed('/google-map', arguments: {
      'stepOrder': Get.arguments['stepOrder'],
    });
    return false;
  }

  getCities() async {
    final response = await guestGet('/services/mobile/api/city-helper/${Get.arguments['id']}');
    if (response != null) {
      setState(() {
        cities = response;
        selectedButton = response[0]['id'];
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') != null) {
        getUser();
      }
    }
  }

  getUser() async {
    final response = await get('/services/mobile/api/get-info');
    if (response != null) {
      setState(() {
        if (response['cityId'] != null && response['cityId'] != '0' && response['cityId'] != '') {
          selectedButton = response['cityId'];
          Get.arguments['stepOrder']['cityId'] = selectedButton;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        appBar: AppBar(),
        title: 'choose_city'.tr,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < cities.length; i++)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedButton = cities[i]['id'];
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cities[i]['name']),
                      Radio<dynamic>(
                        value: cities[i]['id'],
                        groupValue: selectedButton,
                        onChanged: (value) {
                          setState(() {
                            selectedButton = value;
                          });
                        },
                        activeColor: red,
                      ),
                      // Checkbox(
                      //   value: cities[i]['isChecked'],
                      //   activeColor: red,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       cities[i]['isChecked'] = !cities[i]['isChecked'];
                      //     });
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: Button(
          onClick: () {
            setcities();
          },
          text: 'proceed'.tr,
        ),
      ),
    );
  }
}
