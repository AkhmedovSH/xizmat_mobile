import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helpers/api.dart';
import '../../helpers/globals.dart';
import '../../components/widgets.dart' as widgets;

import '../../components/simple_app_bar.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({Key? key}) : super(key: key);

  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(mask: '# # # # # #', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  AnimationController? animationController;
  dynamic sendData = {
    'phone': '',
  };
  bool loading = false;

  checkCode() async {
    setState(() {
      loading = true;
      sendData['activationCode'] = maskFormatter.getUnmaskedText();
    });
    final response = await guestPost('/services/mobile/api/activate-client', sendData);
    if (response != null) {
      if (response != null) {
        if (response['message'] == 'error.activation.code') {
          showErrorToast('wrong_code_entered'.tr);
        }
        if (response['message'] == 'error.already.registered') {
          showErrorToast('phone_already_in_use'.tr);
        }
        if (response['success']) {
          Get.offAllNamed('/login');
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  sendAgain() async {
    final response = await guestPost('/services/mobile/api/register-client', Get.arguments);
    if (response != null) {
      showSuccessToast('code_resubmitted'.tr);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      sendData = Get.arguments;
      sendData['activationCode'] = '';
      animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    });
  }

  @override
  dispose() {
    animationController!.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: SimpleAppBar(
            title: 'confirmation'.tr,
            appBar: AppBar(),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 25),
                      child: Text(
                        'enter_code_from_sms_to_confirm'.tr,
                        style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'code_from_sms'.tr + '*',
                      style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        inputFormatters: [maskFormatter],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required_field'.tr;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            sendData['activationCode'] = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFECECEC), width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFECECEC), width: 0.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Color(0xFFECECEC), width: 0.0),
                          ),
                          filled: true,
                          fillColor: inputColor,
                          hintText: '_ _ _ _ _ _',
                          hintStyle: TextStyle(color: Color(0xFF9C9C9C)),
                        ),
                        style: TextStyle(color: lightGrey),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          sendAgain();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: black, width: 1)),
                          ),
                          child: Text(
                            'send_again'.tr,
                            style: TextStyle(color: black, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 32),
            child: widgets.Button(
              text: 'confirm'.tr,
              onClick: () {
                if (_formKey.currentState!.validate()) {
                  checkCode();
                }
              },
              disabled: sendData['activationCode'].length >= 10,
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
