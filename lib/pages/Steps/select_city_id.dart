import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xizmat/helpers/api.dart';
import 'package:xizmat/helpers/globals.dart';
import '../../components/widgets.dart';

class SelectCityId extends StatefulWidget {
  const SelectCityId({Key? key}) : super(key: key);

  @override
  State<SelectCityId> createState() => _SelectCityIdState();
}

class _SelectCityIdState extends State<SelectCityId> {
  List cities = [
    {'name': '', 'id': '1'}
  ];
  List regions = [
    {'name': '', 'id': '1'}
  ];
  dynamic cityId = '1';
  dynamic regionId = '1';
  dynamic stepOrder = {};

  getCities(id) async {
    final response = await get('/services/mobile/api/city-helper/$id');
    setState(() {
      cities = response;
      cityId = response[0]['id'];
    });
  }

  getRegions() async {
    final response = await get('/services/mobile/api/region-helper');
    setState(() {
      regions = response;
      regionId = response[0]['id'];
    });
    getCities(response[0]['id']);
  }

  createOrder() async {
    setState(() {
      stepOrder['cityId'] = cityId;
    });
    final responseOrder = await post('/services/mobile/api/order', stepOrder);
    if (responseOrder != null) {
      Get.offAllNamed('/success');
    }
  }

  @override
  void initState() {
    super.initState();
    stepOrder = Get.arguments;
    getRegions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Выберите город',
          style: TextStyle(
            color: black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 60,
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: regionId.toString(),
                  isExpanded: true,
                  hint: Text('${regions[0]['name']}'),
                  icon: const Icon(Icons.chevron_right),
                  iconSize: 24,
                  iconEnabledColor: red,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.44,
                    color: red,
                  ),
                  style: const TextStyle(color: Color(0xFF313131)),
                  onChanged: (newValue) {
                    setState(() {
                      regionId = newValue;
                    });
                    getCities(newValue);
                  },
                  items: regions.map((item) {
                    return DropdownMenuItem(
                      value: '${item['id']}',
                      child: Text(item['name']),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: cityId.toString(),
                  isExpanded: true,
                  hint: Text('${cities[0]['name']}'),
                  icon: const Icon(Icons.chevron_right),
                  iconSize: 24,
                  iconEnabledColor: red,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.44,
                    color: red,
                  ),
                  style: const TextStyle(color: Color(0xFF313131)),
                  onChanged: (newValue) {
                    setState(() {
                      cityId = newValue;
                    });
                  },
                  items: cities.map((item) {
                    return DropdownMenuItem(
                      value: '${item['id']}',
                      child: Text(item['name']),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: Button(
          text: 'Подтвердить',
          onClick: () {
            createOrder();
          },
        ),
      ),
    );
  }
}
