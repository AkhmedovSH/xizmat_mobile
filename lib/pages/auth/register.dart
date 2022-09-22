import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/api.dart';
import '../../helpers/globals.dart';
import '../../components/widgets.dart';

import '../../components/simple_app_bar.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '+998 ## ### ## ##', filter: {'#': RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  AnimationController? animationController;
  dynamic sendData = {
    'phone': '',
  };
  dynamic data = {
    'phone': TextEditingController(text: '+998 '),
  };

  bool showPasswordFields = false;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool loading = false;

  register() async {
    setState(() {
      loading = true;
    });
    final checkLogin = await guestGet('/services/executor/api/check-login?login=${'998' + maskFormatter.getUnmaskedText()}');
    if (checkLogin == null) {
      setState(() {
        loading = false;
      });
      return;
    }
    setState(() {
      sendData['phone'] = '998' + maskFormatter.getUnmaskedText();
    });
    final response = await guestPost('/services/mobile/api/register-client', sendData);
    setState(() {
      loading = false;
    });
    if (response != null) {
      Get.toNamed('/confirmation', arguments: sendData);
      // setState(() {
      //   sendData['phone'] = maskFormatter.getMaskedText();
      // });
    }
  }

  checkLogin() async {
    setState(() {
      loading = true;
    });
    final checkLogin = await guestGet('/services/executor/api/check-login?login=${'998' + maskFormatter.getUnmaskedText()}');
    if (checkLogin != null) {
      if (checkLogin['success']) {
        setState(() {
          showPasswordFields = !checkLogin['password'];
          loading = false;
        });
        return;
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppBar(
            title: 'Регистрация',
            appBar: AppBar(),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              inputFormatters: [maskFormatter],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'required_field'.tr;
                                }
                                return null;
                              },
                              controller: data['phone'],
                              onChanged: (value) {
                                if (value == '') {
                                  setState(() {
                                    data['phone'].text = '+998 ';
                                    data['phone'].selection = TextSelection.fromPosition(TextPosition(offset: data['phone'].text.length));
                                  });
                                }
                                setState(() {
                                  sendData['phone'] = value;
                                });
                                if (value.length < 17) {
                                  showPasswordFields = false;
                                }
                                if (value.length == 17) {
                                  checkLogin();
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.phone_iphone,
                                    )),
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
                        showPasswordFields
                            ? Container(
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
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.lock,
                                          )),
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
                                      hintText: 'password'.tr,
                                      hintStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                                    ),
                                    style: const TextStyle(color: Color(0xFF9C9C9C)),
                                  ),
                                ),
                              )
                            : Container(),
                        showPasswordFields
                            ? Container(
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
                                      if (value != sendData['password']) {
                                        return 'passwords_must_match'.tr;
                                      }
                                      return null;
                                    },
                                    initialValue: sendData['confirmPassword'],
                                    onChanged: (value) {
                                      setState(() {
                                        sendData['confirmPassword'] = value;
                                      });
                                    },
                                    scrollPadding: const EdgeInsets.all(50),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.lock,
                                          )),
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
                                      hintText: 'confirm_password'.tr,
                                      hintStyle: const TextStyle(color: Color(0xFF9C9C9C)),
                                    ),
                                    style: const TextStyle(color: Color(0xFF9C9C9C)),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 11),
                      child: Text(
                        'Есть аккаунт?',
                        style: TextStyle(color: lightGrey, fontSize: 17),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/login');
                      },
                      child: Text(
                        'Войти',
                        style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 32),
            child: Button(
              text: 'Продолжить',
              onClick: () {
                if (_formKey.currentState!.validate()) {
                  register();
                }
              },
            ),
          ),
        ),
        loading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.4),
                child: SpinKitThreeBounce(
                  color: red,
                  size: 35.0,
                  controller: animationController,
                ),
              )
            : Container()
      ],
    );
  }
}
