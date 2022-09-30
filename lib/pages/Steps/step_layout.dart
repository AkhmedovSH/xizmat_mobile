import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:collection';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:image_picker/image_picker.dart';

import 'package:xizmat/components/shimmer_loading.dart';

import 'package:xizmat/helpers/api.dart';
import '../../helpers/globals.dart';
// import 'package:xizmat/helpers/widgets.dart';

// radio(i)
// radioWithText(i)
// checkBox(i)
// checkBoxWithText(i)
// map(i)

class StepLayout extends StatefulWidget {
  const StepLayout({Key? key}) : super(key: key);

  @override
  State<StepLayout> createState() => _StepLayoutState();
}

class _StepLayoutState extends State<StepLayout> {
  final formKey = GlobalKey<FormState>();
  dynamic category = {};
  int currentStep = 0;
  dynamic items = [];
  dynamic item = {};
  bool loading = false;
  bool shimmerLoading = false;

  dynamic stepHistory = [];

  dynamic stepOrder = {
    'categoryId': '0',
    'stepList': [],
  };

  decrementStep() async {
    if (currentStep == 0) {
      Get.back();
      return true;
    } else {
      dynamic stepInfo = stepHistory[stepHistory.length - 1];
      setState(() {
        currentStep = currentStep - 1;
        radioId = stepInfo['radioId'] ?? '';
        checkBoxList = stepInfo['checkBoxList'] ?? [];
        position = stepInfo['position'] ?? {};
        inputValues = stepInfo['inputValues'] ?? [];
        days = stepInfo['days'] ?? [];
        items = stepInfo['items'];
        item = stepInfo['item'];
        stepHistory.removeAt(stepHistory.length - 1);
      });
      return false;
    }
  }

  getStep() async {
    final response = await get('/services/mobile/api/step-category/${category['id']}');
    //await getOptions();
    setState(() {
      stepOrder['categoryId'] = category['id'].toString();
      item = response;
      items = response['optionList'] ?? [];
      shimmerLoading = false;
    });
  }

  getOptions() async {
    await get('/services/admin/api/option-type-helper');
  }

  checkOption(i) {
    if (items[i]['optionType'] == 1) {
      return radio(i);
    }
    if (items[i]['optionType'] == 2) {
      return radioWithText(i);
    }
    if (items[i]['optionType'] == 3) {
      setState(() {
        items[i]['isChecked'] = items[i]['isChecked'] ?? false;
        checkBoxList = List.from(items);
      });
      return checkBox(i);
    }
    if (items[i]['optionType'] == 4) {
      setState(() {
        items[i]['isChecked'] = items[i]['isChecked'] ?? false;
        checkBoxList = List.from(items);
      });
      return checkBoxWithtext(i);
    }
    if (items[i]['optionType'] == 5) {
      return map(i);
    }
    if (items[i]['optionType'] == 6) {
      return calendar(i);
    }
    if (items[i]['optionType'] == 7) {}
    if (items[i]['optionType'] == 8) {
      return range(i);
    }
    if (items[i]['optionType'] == 9) {
      return inputs(i, keyboardtype: TextInputType.number);
    }
    if (items[i]['optionType'] == 10) {
      return inputs(i);
    }
    if (items[i]['optionType'] == 11) {
      return inputs(i, textfiled: true);
    }
    if (items[i]['optionType'] == 12) {
      return file(i);
    }
    return Container();
  }

  clearAllVariables() {
    setState(() {
      items = [];
      item = {};
      loading = false;
      radioId = '0';
      checkBoxList = [];
      position = {};
      inputValues = [];
      rangeData = {
        'fromTextEditingController': TextEditingController(text: 'от  сум'),
        'toTextEditingController': TextEditingController(text: 'до  сум')
      };
      fromTextEditingController = TextEditingController(text: 'от  сум');
      toTextEditingController = TextEditingController(text: 'до  сум');
    });
  }

  checkNextStepId(index) async {
    setState(() {
      loading = true;
    });
    print(items[index]);
    if (items[index]['nextStepId'] == 0) {
      setState(() {
        currentStep = currentStep - 1;
        stepOrder['cityId'] = 10;
      });
      final result = await Get.toNamed('/select-region', arguments: {'stepOrder': stepOrder});
      if (result == null) {
        setState(() {
          loading = false;
        });
        return true;
      }
      // final responseOrder = await post('/services/mobile/api/order', stepOrder);
    }
    return false;
  }

  nextStep() async {
    if (items[0]['optionType'] == 1 || items[0]['optionType'] == 2) {
      nextStepRadio(int.parse(radioId));
    }
    if (items[0]['optionType'] == 3 || items[0]['optionType'] == 4) {
      nextStepCheckBox();
    }
    if (items[0]['optionType'] == 5) {
      nextStepMap();
    }
    if (items[0]['optionType'] == 6) {
      nextStepCalendar();
    }
    if (items[0]['optionType'] == 7) {
      // nextStepTime();
    }
    if (items[0]['optionType'] == 8) {
      nextStepRange();
    }
    if (items[0]['optionType'] == 9) {
      nextStepInput();
    }
    if (items[0]['optionType'] == 10) {
      nextStepInput();
    }
    if (items[0]['optionType'] == 11) {
      nextStepInput();
    }
    if (items[0]['optionType'] == 12) {
      nextStepFile();
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      shimmerLoading = true;
      category = Get.arguments;
    });
    getStep();
  }

  @override
  void dispose() {
    super.dispose();
    checkBoxFieldFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return decrementStep();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            '${category['name']}',
            style: TextStyle(
              color: black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              decrementStep();
            },
            icon: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: black,
                size: 28,
              ),
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: shimmerLoading
                  ? ShimmerLoading(
                      loading: shimmerLoading,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                          child: Text(
                            item['title'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: lightGrey),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            item['description'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: black),
                          ),
                        ),
                        for (var i = 0; i < items.length; i++) checkOption(i),
                        SizedBox(
                          height: 80,
                        )
                      ],
                    ),
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(left: 32),
          width: MediaQuery.of(context).size.width,
          // height: 50,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Продолжить',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                loading
                    ? Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: white,
                          strokeWidth: 3,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 25,
                        width: 25,
                        child: Icon(
                          Icons.arrow_right_alt_outlined,
                          size: 28,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dynamic radioId = '0';

  nextStepRadio(index) async {
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': [
          {'optionId': items[int.parse(radioId)]['id'], 'optionType': items[int.parse(radioId)]['optionType']},
        ],
      });
    });
    final result = await checkNextStepId(index);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[index]['nextStepId'].toString());
    if (response != null) {
      setState(() {
        stepHistory.add({
          'radioId': radioId,
          'items': items,
          'item': item,
          'id': item['id'],
        });
      });
      clearAllVariables();
      setState(() {
        currentStep = currentStep + 1;
        item = response;
        items = response['optionList'] ?? [];
      });
    }
  }

  radio(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          radioId = i.toString();
        });
      },
      child: Container(
        margin: mx12,
        padding: py10,
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: mr20,
              child: Transform.scale(
                scale: 1,
                child: Radio(
                  onChanged: (value) {
                    setState(() {
                      radioId = value;
                    });
                  },
                  value: i.toString(),
                  groupValue: radioId,
                  activeColor: black,
                ),
              ),
            ),
            Flexible(
              child: Text(
                items[i]['optionName'],
                style: TextStyle(color: black, fontSize: 18),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FocusNode radioFieldFocusNode = FocusNode();

  radioWithText(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          radioId = i.toString();
        });
      },
      child: Container(
        margin: mx12,
        padding: py10,
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: mr20,
              child: Transform.scale(
                scale: 1,
                child: Radio(
                  onChanged: (value) {
                    setState(() {
                      radioId = value;
                    });
                  },
                  value: i.toString(),
                  groupValue: radioId,
                  activeColor: black,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: TextFormField(
                onTap: () {
                  setState(() {
                    radioId = i.toString();
                  });
                },
                decoration: inputDecoration(),
                style: TextStyle(color: lightGrey),
              ),
            )
          ],
        ),
      ),
    );
  }

  dynamic checkBoxList = [];

  nextStepCheckBox() async {
    dynamic optionList = [];
    for (var i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i]['isChecked']) {
        optionList.add({
          'optionId': checkBoxList[i]['id'],
          'optionType': checkBoxList[i]['optionType'],
        });
      }
    }
    if (optionList.length == 0) {
      showWarningToast('Выберите один вариант');
      return;
    }
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': optionList,
      });
    });
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + checkBoxList[0]['nextStepId'].toString());
    setState(() {
      stepHistory.add({
        'checkBoxList': checkBoxList,
        'items': items,
        'item': item,
        'id': item['id'],
      });
    });
    clearAllVariables();
    setState(() {
      currentStep = currentStep + 1;
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  checkBox(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checkBoxList[i]['isChecked'] = !checkBoxList[i]['isChecked'];
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: black,
                value: checkBoxList[i]['isChecked'],
                onChanged: (value) {
                  setState(() {
                    checkBoxList[i]['isChecked'] = !checkBoxList[i]['isChecked'];
                  });
                },
              ),
            ),
            Flexible(
              child: Text(
                items[i]['optionName'],
                style: TextStyle(color: black, fontSize: 18),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FocusNode checkBoxFieldFocusNode = FocusNode();

  checkBoxWithtext(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          checkBoxList[i]['isChecked'] = !checkBoxList[i]['isChecked'];
        });
      },
      child: Container(
        margin: mx12,
        padding: py10,
        decoration: borderBottom,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor: black,
                value: checkBoxList[i]['isChecked'],
                onChanged: (value) {
                  setState(() {
                    checkBoxList[i]['isChecked'] = !checkBoxList[i]['isChecked'];
                    if (checkBoxList[i]['isChecked']) {
                      checkBoxFieldFocusNode.requestFocus();
                    } else {
                      checkBoxFieldFocusNode.unfocus();
                    }
                  });
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: TextFormField(
                onTap: () {
                  setState(() {
                    checkBoxList[i]['isChecked'] = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    setState(() {
                      checkBoxList[i]['optionValue1'] = value;
                    });
                  });
                },
                focusNode: checkBoxFieldFocusNode,
                decoration: inputDecoration(),
                style: TextStyle(color: lightGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic position = {
    'gpsPointX': '',
    'gpsPointY': '',
  };

  List<Marker> marker = [
    // Marker(
    //   markerId: MarkerId(LatLng(41.311081, 69.240562).toString()),
    //   position: LatLng(41.311081, 69.240562),
    // ),
  ];
  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(41.311081, 69.240562), zoom: 13.0);

  nextStepMap() async {
    if (position['gpsPointX'] == null || position['gpsPointX'] == '') {
      showWarningToast('Выберите место назначения');
      return;
    }
    // setState(() {
    //   stepOrder['stepList'].add({
    //     'main': item['main'],
    //     'stepId': item['id'],
    //     'optionList': {
    //       'optionId': items[0]['id'],
    //       'optionValue1': position['gpsPointX'],
    //       'optionValue2': position['gpsPointY'],
    //       'optionType': 1,
    //     },
    //   });
    // });
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[0]['nextStepId'].toString());
    setState(() {
      stepHistory.add({
        'position': position,
        'items': items,
        'item': item,
        'id': item['id'],
      });
    });
    clearAllVariables();
    setState(() {
      currentStep = currentStep + 1;
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  handleTab(LatLng tappedPoint) {
    setState(() {
      position['gpsPointX'] = tappedPoint.latitude;
      position['gpsPointY'] = tappedPoint.longitude;
      marker = [];
      marker.add(
        Marker(markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
    });
  }

  map(i) {
    return Container(
      padding: EdgeInsets.all(0),
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
    );
  }

  final kToday = DateTime.now();
  final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  dynamic days = [];

  nextStepCalendar() async {
    if (days.length == 0) {
      showWarningToast('Выберите дату');
      return;
    }
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': {
          'optionId': items[0]['id'],
          'optionType': items[0]['optionType'],
        },
        'optionType': 6,
      });
    });
    print(days.toString().replaceAll('[', '').replaceAll(']', ''));
    dynamic optionList = [];
    for (var i = 0; i < optionList.length; i++) {
      print(DateFormat('yyyy-MM-dd').format(optionList[i]));
    }
    // return;
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[0]['nextStepId'].toString());
    setState(() {
      stepHistory.add({
        'days': days,
        'items': items,
        'item': item,
        'id': item['id'],
      });
    });
    clearAllVariables();
    setState(() {
      currentStep = currentStep + 1;
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (selectedDays.contains(selectedDay)) {
        selectedDays.remove(selectedDay);
        days.remove(selectedDay);
      } else {
        selectedDays.add(selectedDay);
        days.add(selectedDay);
      }
    });
  }

  calendar(i) {
    return Container(
      padding: EdgeInsets.all(0),
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
            shape: BoxShape.rectangle,
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
        selectedDayPredicate: (day) {
          return selectedDays.contains(day);
        },
        onDaySelected: _onDaySelected,
      ),
    );
  }

  time(i) {
    return Container();
  }

  var maskFormatter = MaskTextInputFormatter(
    mask: 'от ############ Som',
    filter: {"#": RegExp(r'[0-9]')},
  );

  dynamic rangeData = {
    'fromTextEditingController': TextEditingController(text: 'от  сум'),
    'toTextEditingController': TextEditingController(text: 'до  сум')
  };

  TextEditingController fromTextEditingController = TextEditingController(text: 'от  сум');
  TextEditingController toTextEditingController = TextEditingController(text: 'до  сум');

  nextStepRange() async {
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': {
          'optionId': items[0]['id'],
          'optionType': items[0]['optionType'],
        },
      });
    });
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[0]['nextStepId'].toString());
    if (response != null) {
      setState(() {
        stepHistory.add({
          'position': position,
          'items': items,
          'item': item,
          'id': item['id'],
        });
      });
      clearAllVariables();
      setState(() {
        currentStep = currentStep + 1;
        item = response;
        items = response['optionList'] ?? [];
      });
    }
  }

  range(i) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            child: TextFormField(
              controller: rangeData['fromTextEditingController'],
              onChanged: (value) {
                if (value.replaceAll(RegExp(r'[^0-9]'), '') != '0') {
                  setState(() {
                    rangeData['fromTextEditingController'].text = 'от ' + value.replaceAll(RegExp(r'[^0-9]'), '').toString() + ' сум';
                    rangeData['fromTextEditingController'].selection = TextSelection.fromPosition(
                      TextPosition(offset: rangeData['fromTextEditingController'].text.length - 4),
                    );
                  });
                } else {
                  setState(() {
                    rangeData['fromTextEditingController'].text = 'от  сум';
                    rangeData['fromTextEditingController'].selection = TextSelection.fromPosition(
                      TextPosition(offset: rangeData['fromTextEditingController'].text.length - 4),
                    );
                  });
                }
              },
              keyboardType: TextInputType.number,
              decoration: inputDecoration(hintText: 'от 0 сум'),
              style: TextStyle(color: lightGrey),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.44,
            child: TextFormField(
              controller: rangeData['toTextEditingController'],
              onChanged: (value) {
                if (value.replaceAll(RegExp(r'[^0-9]'), '') != '0') {
                  setState(() {
                    rangeData['toTextEditingController'].text = 'до ' + value.replaceAll(RegExp(r'[^0-9]'), '').toString() + ' сум';
                    rangeData['toTextEditingController'].selection = TextSelection.fromPosition(
                      TextPosition(offset: rangeData['toTextEditingController'].text.length - 4),
                    );
                  });
                } else {
                  setState(() {
                    rangeData['toTextEditingController'].text = 'от  сум';
                    rangeData['toTextEditingController'].selection = TextSelection.fromPosition(
                      TextPosition(offset: rangeData['toTextEditingController'].text.length - 4),
                    );
                  });
                }
              },
              keyboardType: TextInputType.number,
              decoration: inputDecoration(hintText: 'до 0 сум'),
              style: TextStyle(color: lightGrey),
            ),
          ),
        ],
      ),
    );
  }

  dynamic inputValues = [];

  nextStepInput() async {
    dynamic optionList = [];
    for (var i = 0; i < inputValues.length; i++) {
      if (inputValues[i]['optionValue1'] != null) {
        optionList.add({
          'optionId': inputValues[i]['id'],
          'optionValue1': inputValues[i]['optionValue1'],
          'optionType': inputValues[i]['optionType'],
        });
      }
    }
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': optionList,
      });
    });
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + inputValues[0]['nextStepId'].toString());
    setState(() {
      stepHistory.add({
        'inputValues': inputValues,
        'items': items,
        'item': item,
        'id': item['id'],
      });
    });
    for (var i = 0; i < inputValues.length; i++) {
      setState(() {
        inputValues[i]['focus'].unfocus();
        inputValues[i]['focus'] = FocusNode();
      });
    }
    clearAllVariables();
    setState(() {
      currentStep = currentStep + 1;
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  inputs(i, {textfiled = false, keyboardtype = TextInputType.text}) {
    setState(() {
      items[i]['controller'] = items[i]['controller'] ?? TextEditingController();
      items[i]['focus'] = items[i]['focus'] ?? FocusNode();
      inputValues = items;
    });
    return Container(
      margin: mx12,
      padding: py10,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: inputValues[i]['controller'],
        onChanged: (value) {
          setState(() {
            inputValues[i]['optionValue1'] = value;
          });
        },
        validator: (value) {
          if (value == null || value == '') {
            return 'required_field'.tr;
          }
          return null;
        },
        focusNode: inputValues[i]['focus'],
        scrollPadding: EdgeInsets.only(bottom: 100),
        keyboardType: keyboardtype,
        decoration: inputDecoration(hintText: inputValues[i]['optionName']),
        maxLines: textfiled ? 8 : 1,
        style: TextStyle(color: lightGrey),
      ),
    );
  }

  dynamic imageUrlList = [];

  Future pickImage() async {
    final source = await showImageSource(context);
    if (source == null) return;
    try {
      XFile? img = await ImagePicker().pickImage(source: source);
      if (img == null) return;
      final response = await uploadImage('/services/executor/api/upload/image', File(img.path));
      if (response != null) {
        String jsonsDataString = response.toString();
        final jsonData = jsonDecode(jsonsDataString);
        setState(() {
          imageUrlList.add(jsonData['url']);
        });
      }
    } on PlatformException catch (e) {
      print('ERROR: $e');
    }
  }

  deleteImage(i) async {
    setState(() {
      imageUrlList.removeAt(i);
    });
  }

  nextStepFile() async {
    setState(() {
      stepOrder['stepList'].add({
        'main': item['main'],
        'stepId': item['id'],
        'optionList': [
          {
            'optionValue1': imageUrlList,
            'optionId': items[0]['id'],
            'optionType': items[0]['optionType'],
          }
        ],
      });
    });
    final result = await checkNextStepId(0);
    if (result) {
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[0]['nextStepId'].toString());
    setState(() {
      stepHistory.add({
        'files': imageUrlList,
        'items': items,
        'item': item,
        'id': item['id'],
      });
    });
    clearAllVariables();
    setState(() {
      currentStep = currentStep + 1;
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  file(i) {
    return imageUrlList.length > 0
        ? Container(
            decoration: BoxDecoration(),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                for (var i = 0; i < imageUrlList.length; i++)
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Color(0xFF999999)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            mainUrl + imageUrlList[i],
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 15,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              deleteImage(i);
                            },
                            icon: Icon(
                              Icons.close,
                              color: white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: DottedDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF717171),
                      strokeWidth: 0.7,
                      shape: Shape.box,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: lightGrey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () {
              pickImage();
            },
            child: Container(
              decoration: DottedDecoration(
                borderRadius: BorderRadius.circular(15),
                color: black,
                strokeWidth: 0.7,
                shape: Shape.box,
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Добавить фото или файл',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    size: 28,
                  ),
                ],
              ),
            ),
          );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.camera), child: Text('kamera'.tr)),
            CupertinoActionSheetAction(onPressed: () => Navigator.of(context).pop(ImageSource.gallery), child: Text('galereya'.tr))
          ],
        ),
      );
    } else {
      return showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          builder: (context) => Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        decoration: borderBottom,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Добавить из галереи'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                            Icon(
                              Icons.camera_alt,
                              color: lightGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        decoration: borderBottom,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Сделать снимок'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                            Icon(
                              Icons.image,
                              color: lightGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Отмена'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: black,
                              ),
                            ),
                            Icon(
                              Icons.close,
                              color: lightGrey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
    }
  }

  EdgeInsets mr20 = EdgeInsets.only(right: 20);
  EdgeInsets mx12 = EdgeInsets.symmetric(horizontal: 12);
  EdgeInsets py10 = EdgeInsets.symmetric(vertical: 10);
  BoxDecoration borderBottom = const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 1,
        color: Color(0xFFF2F2F2),
      ),
    ),
  );

  inputDecoration({hintText = 'Другое'}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF3F7FA), width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF3F7FA), width: 0.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 230, 0, 0), width: 0.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF3F7FA), width: 0.0),
      ),
      filled: true,
      fillColor: Color(0xFFF8F8F8),
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
    );
  }

  // InputDecoration inputDecoration = InputDecoration(
  //   contentPadding: EdgeInsets.all(12.0),
  //   enabledBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(12.0),
  //     borderSide: BorderSide(color: Color(0xFFF3F7FA), width: 0.0),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(12.0),
  //     borderSide: BorderSide(color: Color(0xFFF3F7FA), width: 0.0),
  //   ),
  //   filled: true,
  //   fillColor: Color(0xFFF8F8F8),
  //   hintText: 'Другое',
  //   hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
  // );
}
