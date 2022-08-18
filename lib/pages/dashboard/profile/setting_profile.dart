import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:xizmat/components/simple_app_bar.dart';

import '../../../helpers/globals.dart';
import '../../../components/widgets.dart' as widgets;

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  dynamic sendData = {
    'name': '', // Alisher
    'username': '', // 998 998325455
    'password': '', // 112233
  };
  dynamic data = {
    'birthDateController': TextEditingController(),
    'genderController': TextEditingController(),
  };
  bool showPassword = true;
  DateTime selectedDate = DateTime.now();

  selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final year = DateFormat('yyyy').format(date);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(int.parse(year) + 1),
      // locale: const Locale("fr", "FR"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: red,
            colorScheme: ColorScheme.light(primary: red),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        data['birthDateController'].text = DateFormat('yyyy-MM-dd').format(picked);
        sendData['birthDate'] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SimpleAppBar(
        appBar: AppBar(),
        title: 'Настройка',
        leading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    'Настройте свой профиль в Xizmat'.tr,
                    style: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: red,
                                ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required_field'.tr;
                              }
                              return null;
                            },
                            initialValue: sendData['name'],
                            onChanged: (value) {
                              setState(() {
                                sendData['name'] = value;
                              });
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.person),
                              ),
                              contentPadding: const EdgeInsets.all(18.0),
                              focusColor: red,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: red),
                              ),
                              labelText: 'Имя'.tr,
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                            style: const TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: red,
                                ),
                          ),
                          child: TextFormField(
                            inputFormatters: [maskFormatter],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required_field'.tr;
                              }
                              return null;
                            },
                            initialValue: sendData['username'],
                            onChanged: (value) {
                              setState(() {
                                sendData['username'] = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.phone_iphone,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(18.0),
                              focusColor: red,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: red),
                              ),
                              labelText: 'telephone_number'.tr + '(9* *** ** **)',
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                            style: const TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: red,
                                ),
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required_field'.tr;
                              }
                              return null;
                            },
                            initialValue: sendData['password'],
                            onChanged: (value) {
                              setState(() {
                                sendData['password'] = value;
                              });
                            },
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.lock,
                                ),
                              ),
                              suffixIcon: showPassword
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility_off,
                                        // color: red,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPassword = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.visibility,
                                        // color: red,
                                      ),
                                    ),
                              contentPadding: const EdgeInsets.all(18.0),
                              focusColor: red,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: red),
                              ),
                              labelText: 'password'.tr,
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                            style: const TextStyle(color: Color(0xFF9C9C9C)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        // height: 45,
                        child: GestureDetector(
                          onTap: () {
                            selectDate(context);
                          },
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ThemeData().colorScheme.copyWith(
                                    primary: red,
                                  ),
                            ),
                            child: TextFormField(
                              controller: data['birthDateController'],
                              validator: (_) {
                                if (data['birthDateController'].text == '') {
                                  return 'required_field'.tr;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabled: false,
                                prefixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.calendar_month,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(18.0),
                                focusColor: red,
                                filled: true,
                                fillColor: Colors.transparent,
                                disabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: red),
                                ),
                                labelText: 'Дата рождения'.tr,
                                labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 40),
                        // height: 45,
                        child: GestureDetector(
                          onTap: () {
                            showSelectGenger();
                          },
                          child: TextFormField(
                            controller: data['genderController'],
                            validator: (_) {
                              if (data['genderController'].text == '') {
                                return 'required_field'.tr;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              enabled: false,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.female),
                              ),
                              contentPadding: const EdgeInsets.all(18.0),
                              focusColor: red,
                              filled: true,
                              fillColor: Colors.transparent,
                              disabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF9C9C9C)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: red),
                              ),
                              labelText: 'Пол'.tr,
                              labelStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: widgets.Button(
                text: 'Сохранить',
                onClick: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic selectedButton = '0';

  showSelectGenger() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: ((context, genderSetState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   child: Row(
                //     children: [
                //       Radio(
                //         value: sendData['gender'] == '0',
                //         groupValue: SingingCharacter.lafayette,
                //         onChanged: (value) {},
                //       )
                //     ],
                //   ),
                // ),
                ListTile(
                  leading: Radio(
                    value: '0',
                    groupValue: selectedButton,
                    onChanged: (value) {
                      genderSetState(() {
                        selectedButton = '0';
                        sendData['gender'] = '0';
                      });
                      Get.back();
                    },
                    activeColor: red,
                  ),
                  title: Text('male'.tr),
                  onTap: () => genderSetState(() {
                    selectedButton = '0';
                    sendData['gender'] = '0';
                    data['genderController'].text = 'male'.tr;
                    Get.back();
                  }),
                ),
                ListTile(
                  leading: Radio(
                    value: '1',
                    groupValue: selectedButton,
                    onChanged: (value) {
                      genderSetState(() {
                        selectedButton = '1';
                        sendData['gender'] = '1';
                      });
                      Get.back();
                    },
                    activeColor: red,
                  ),
                  title: Text('female'.tr),
                  onTap: () => genderSetState(() {
                    selectedButton = '1';
                    sendData['gender'] = '1';
                    data['genderController'].text = 'female'.tr;
                    Get.back();
                  }),
                ),
              ],
            )),
      ),
    );
  }
}
