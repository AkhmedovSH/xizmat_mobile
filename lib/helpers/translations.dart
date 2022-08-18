import 'package:get/get.dart';

import '../locales/ru.dart';
import '../locales/uz.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ru_RU': ru,
        'uz_UZ': uz,
      };
}
