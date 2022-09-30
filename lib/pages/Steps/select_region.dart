import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xizmat/helpers/api.dart';

import '../../helpers/globals.dart';

import '../../components/simple_app_bar.dart';
import '../../components/widgets.dart';

class SelectRegion extends StatefulWidget {
  const SelectRegion({Key? key}) : super(key: key);

  @override
  State<SelectRegion> createState() => _SelectRegionState();
}

class _SelectRegionState extends State<SelectRegion> {
  dynamic regions = [];
  dynamic selectedButton = '0';

  setRegions() async {
    Get.arguments['stepOrder']['regionId'] = selectedButton;
    Get.toNamed('/select-city', arguments: {
      'stepOrder': Get.arguments['stepOrder'],
      'id': selectedButton,
    });
    return false;
  }

  getRegions() async {
    final response = await get('/services/mobile/api/region-helper');
    setState(() {
      regions = response;
      selectedButton = regions[0]['id'];
    });
    getUser();
  }

  getUser() async {
    final response = await get('/services/mobile/api/get-info');
    if (response != null) {
      setState(() {
        if (response['regionId'] != null && response['regionId'] != '0' && response['regionId'] != '') {
          selectedButton = response['regionId'];
          selectedButton = Get.arguments['stepOrder']['regionId'];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
          appBar: AppBar(),
          title: 'Выберите районы',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var i = 0; i < regions.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedButton = regions[i]['id'];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(regions[i]['name']),
                        Radio<dynamic>(
                          value: regions[i]['id'],
                          groupValue: selectedButton,
                          onChanged: (value) {
                            setState(() {
                              selectedButton = value;
                            });
                          },
                          activeColor: red,
                        ),
                        // Checkbox(
                        //   value: regions[i]['isChecked'],
                        //   activeColor: red,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       regions[i]['isChecked'] = !regions[i]['isChecked'];
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
              setRegions();
            },
            text: 'Продолжить',
          ),
        ));
  }
}
