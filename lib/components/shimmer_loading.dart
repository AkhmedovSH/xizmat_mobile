import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/globals.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  final bool? loading;
  const ShimmerLoading({Key? key, this.loading}) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  dynamic data = {
    'firstWidth': 10.0,
    'secondWidth': 0.0,
    'thirdWidth': 0.0,
    'fourthWidth': 0.0,
    'secondOpacity': 0.0,
    'thirdOpacity': 0.0,
    'fourthOpacity': 0.0,
  };
  Timer? timer;

  startLoading() async {
    timer = Timer.periodic(Duration(milliseconds: 2), (timer) {
      if (timer.tick > 200 && timer.tick < 620) {
        setState(() {
          data['secondWidth'] = data['secondWidth'] + 1.0;
          if (data['secondOpacity'].round() < 1) {
            data['secondOpacity'] = data['secondOpacity'] + 0.008;
          }
        });
      }
      if (timer.tick > 300 && timer.tick < 590) {
        setState(() {
          data['thirdWidth'] = data['thirdWidth'] + 1.0;
          if (data['thirdOpacity'].round() < 1) {
            data['thirdOpacity'] = data['thirdOpacity'] + 0.008;
          }
        });
      }
      if (timer.tick > 400 && timer.tick < 790) {
        setState(() {
          data['fourthWidth'] = data['fourthWidth'] + 1.0;
          if (data['fourthOpacity'].round() < 1) {
            data['fourthOpacity'] = data['fourthOpacity'] + 0.008;
          }
        });
      }
      if (timer.tick < 670) {
        setState(() {
          data['firstWidth'] = data['firstWidth'] + 1.0;
        });
      }
      if (!widget.loading!) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          curve: Curves.fastOutSlowIn,
          margin: EdgeInsets.only(top: 30),
          width: data['firstWidth'],
          decoration: BoxDecoration(
            color: Color(0xFFF2F1F1),
            borderRadius: BorderRadius.circular(12),
          ),
          height: 40,
        ),
        Opacity(
          opacity: data['secondOpacity'],
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  margin: EdgeInsets.only(right: 20),
                  width: 25,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  width: data['secondWidth'],
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: data['thirdOpacity'],
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  margin: EdgeInsets.only(right: 20),
                  width: 25,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  width: data['thirdWidth'],
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: data['fourthOpacity'],
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  margin: EdgeInsets.only(right: 20),
                  width: 25,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  width: data['fourthWidth'],
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 230, 228, 228),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
