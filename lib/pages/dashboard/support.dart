import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import '../../helpers/globals.dart';
import '../../../components/simple_app_bar.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'support'.tr,
        appBar: AppBar(),
        leading: false,
        style: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 25),
            child: Text(
              'telephone'.tr + ': +998 55 500 00 89',
              style: TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: ElevatedButton(
              onPressed: () async {
                final Uri launchUri = Uri(
                  scheme: 'tel',
                  path: '+998555000089',
                );
                await launchUrl(launchUri);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'call'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.symmetric(vertical: 16),
          //       elevation: 0,
          //       primary: white,
          //       shape: RoundedRectangleBorder(
          //         side: BorderSide(color: black),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(
          //           Icons.textsms_outlined,
          //           color: black,
          //         ),
          //         SizedBox(
          //           width: 10,
          //         ),
          //         Text(
          //           'Онлайн чат',
          //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: black),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
