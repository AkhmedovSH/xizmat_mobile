import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:xizmat/helpers/api.dart';
import '../../helpers/globals.dart';
import 'package:xizmat/helpers/widgets.dart';

// import 'step_1.dart';
// import 'step_2.dart';
// import 'step_3.dart';
// import 'step_4.dart';
// import 'step_5.dart';

class StepLayout extends StatefulWidget {
  const StepLayout({Key? key}) : super(key: key);

  @override
  State<StepLayout> createState() => _StepLayoutState();
}

class _StepLayoutState extends State<StepLayout> {
  int currentStep = 0;
  dynamic items = [];
  dynamic item = {};
  dynamic radioId = '';
  bool loading = false;
  dynamic stepHistory = [];

  dynamic stepOrder = {
    'categoryId': '0',
    'stepList': [],
    'index': 0,
  };

  changeIndex() async {
    if (currentStep == 0) {
      Get.back();
      return true;
    } else {
      print(currentStep);
      final response = await get('/services/mobile/api/step/' + stepOrder['stepList'][currentStep - 1]['id'].toString());
      print(stepOrder['stepList']);
      setState(() {
        item = response;
        items = response['optionList'] ?? [];
        radioId = stepHistory[currentStep - 1]['id'].toString();
        stepHistory.removeAt(stepHistory.length - 1);
        stepOrder['stepList'].removeAt(currentStep - 1);
        currentStep = currentStep - 1;
      });
      return false;
    }
  }

  nextStep(index) async {
    setState(() {
      loading = true;
    });
    if (items[index]['nextStepId'] == 0) {
      final responseOrder = await post('/services/mobile/api/step-order', stepOrder);
      print(responseOrder);
      Get.offAllNamed('/success');
      return;
    }
    final response = await get('/services/mobile/api/step/' + items[index]['nextStepId'].toString());
    print(index);
    setState(() {
      stepOrder['stepList'].add(
        {
          'main': item['main'],
          'optionType': items[index]['optionType'],
          'optionList': [
            {
              "optionId": items[index]['id'],
            }
          ],
          'id': item['id'],
        },
      );
      stepHistory.add({'id': index});
      item = response;
      items = response['optionList'] ?? [];
      currentStep = currentStep + 1;
      loading = false;
      radioId = '';
    });
  }

  nextStepMap() async {}

  getStep() async {
    final response = await get('/services/mobile/api/step-category/${Get.arguments}');
    setState(() {
      stepOrder['categoryId'] = Get.arguments.toString();
      item = response;
      items = response['optionList'] ?? [];
    });
  }

  getOptions() async {
    final response = await get('/services/admin/api/option-type-helper');
  }

  @override
  void initState() {
    super.initState();
    getStep();
    getOptions();
  }

  checkOption(i) {
    if (items[i]['optionType'] == 1) {
      return radio(i);
    }
    if (items[i]['optionType'] == 2) {
      return radioWithText(i);
    }
    if (items[i]['optionType'] == 3) {
      return checkBox(i);
    }
    if (items[i]['optionType'] == 4) {
      return radio(i);
    }
    if (items[i]['optionType'] == 5) {
      return map(i);
    }
    if (items[i]['optionType'] == 6) {
      return radio(i);
    }
    if (items[i]['optionType'] == 7) {
      return radio(i);
    }
    if (items[i]['optionType'] == 8) {
      return radio(i);
    }
    if (items[i]['optionType'] == 9) {
      return radio(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return changeIndex();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Step $currentStep',
            style: TextStyle(
              color: black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              changeIndex();
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
            child: Column(
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
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(left: 32),
          width: MediaQuery.of(context).size.width,
          // height: 50,
          child: ElevatedButton(
            onPressed: () {
              print(radioId);
              nextStep(int.parse(radioId != '' ? radioId : '0'));
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

  radio(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          radioId = i.toString();
        });
        // nextStep(i);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                items[i]['optionName'],
                style: TextStyle(color: black, fontSize: 18),
                overflow: TextOverflow.clip,
              ),
            ),
            Transform.scale(
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
            )
          ],
        ),
      ),
    );
  }

  radioWithText(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          radioId = i.toString();
        });
        // nextStep(i);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(),
            Transform.scale(
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
            )
          ],
        ),
      ),
    );
  }

  checkBox(i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          radioId = i.toString();
        });
        nextStep(i);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F2)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                items[i]['optionName'],
                style: TextStyle(color: black, fontSize: 18),
                overflow: TextOverflow.clip,
              ),
            ),
            Checkbox(
              checkColor: Colors.white,
              value: i,
              onChanged: (value) {
                setState(() {
                  i = value!;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> marker = [Marker(markerId: MarkerId(LatLng(41.311081, 69.240562).toString()), position: LatLng(41.311081, 69.240562))];
  static final CameraPosition _kGooglePlex = CameraPosition(target: LatLng(41.311081, 69.240562), zoom: 13.0);

  map(i) {
    return Container(
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: GoogleMap(
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          // _controller.complete(controller);
        },
        markers: Set.from(marker),
        // onTap: handleTab,
      ),
    );
  }
}
