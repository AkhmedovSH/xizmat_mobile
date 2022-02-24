import 'package:get/get.dart';

class StepController extends GetxController {
  dynamic steps = {
    'categoryId': 0,
    'optionList': [],
  };

  void storeByKey(key, value) {
    steps['key'] = value;
    update();
  }

  void storeOption(option) {
    //
    update();
  }
}
