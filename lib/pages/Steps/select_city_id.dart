import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

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
  dynamic position = {
    'gpsPointX': '',
    'gpsPointY': '',
  };
  List<Marker> marker = [];
  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(41.311081, 69.240562), zoom: 13.0);

  handleTab(LatLng tappedPoint) {
    setState(() {
      position['gpsPointX'] = tappedPoint.latitude.toString();
      position['gpsPointY'] = tappedPoint.longitude.toString();
      marker = [];
      marker.add(
        Marker(markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
    });
  }

  final kToday = DateTime.now();
  final kFirstDay = DateTime.now().subtract(Duration());
  final kLastDay = DateTime(2100);
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  dynamic days = [];
  dynamic _selectedDay = {DateTime.now()};

  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   setState(() {
  //     _focusedDay = focusedDay;
  //     if (selectedDays.contains(selectedDay)) {
  //       selectedDays.remove(selectedDay);
  //       days.remove(selectedDay);
  //     } else {
  //       selectedDays.add(selectedDay);
  //       days.add(selectedDay);
  //     }
  //   });
  // }

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
      stepOrder['gpsPointX'] = position['gpsPointX'];
      stepOrder['gpsPointY'] = position['gpsPointY'];
      stepOrder['executionDate'] = DateFormat('yyyy-MM-dd').format(_selectedDay);
      stepOrder['orderAmount'] = 1000;
      stepOrder['note'] = "pulini kelishamiz";
    });
    print(stepOrder);
    final responseOrder = await post('/services/mobile/api/order', stepOrder);
    if (responseOrder != null) {
      Get.offAllNamed('/success');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      stepOrder = Get.arguments;
      _selectedDay = DateTime.now();
    });
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
      body: SingleChildScrollView(
        child: Container(
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
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  compassEnabled: false,
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.complete(controller);
                  },
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  markers: Set.from(marker),
                  onTap: handleTab,
                ),
              ),
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                // height: 250,
                child: TableCalendar(
                  locale: locale,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false,
                    selectedDecoration: BoxDecoration(
                      color: red,
                      // shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                  ),
                  // selectedDayPredicate: (day) {
                  //   return selectedDays.contains(day);
                  // },
                  // onDaySelected: _onDaySelected,
                  onDaySelected: (selectedDay, focusedDay) async {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    final result = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child ?? Container(),
                        );
                      },
                    );
                    if (result != null) {
                      stepOrder['executionTime'] = result.format(context);
                    }

                    // DatePicker.showTimePicker(context, showTitleActions: true, showSecondsColumn: false, onChanged: (date) {
                    //   print('confirm $date');
                    // }, onConfirm: (date) {
                    //   setState(() {
                    //     stepOrder['executionTime'] = DateFormat('HH:mm').format(date);
                    //   });
                    // }, currentTime: DateTime.now(), locale: LocaleType.ru);
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                ),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
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
