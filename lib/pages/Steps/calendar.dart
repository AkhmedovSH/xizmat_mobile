import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

import 'package:xizmat/helpers/api.dart';
import 'package:xizmat/helpers/globals.dart';

import '../../components/simple_app_bar.dart';
import '../../components/widgets.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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

  createOrder() async {
    setState(() {
      Get.arguments['stepOrder']['executionDate'] = DateFormat('yyyy-MM-dd').format(_selectedDay);
      Get.arguments['stepOrder']['orderAmount'] = 1000;
      Get.arguments['stepOrder']['note'] = "pulini kelishamiz";
    });
    print(Get.arguments['stepOrder']);
    final responseOrder = await post('/services/mobile/api/order', Get.arguments['stepOrder']);
    if (responseOrder != null) {
      Get.offAllNamed('/success');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        appBar: AppBar(),
        title: 'Выберите день',
        bg: Colors.transparent,
        style: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
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
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  defaultTextStyle: TextStyle(color: black),
                  weekendTextStyle: TextStyle(color: black),
                  disabledTextStyle: TextStyle(color: Color.fromARGB(255, 215, 215, 215)),
                  outsideTextStyle: TextStyle(color: black),
                  holidayTextStyle: TextStyle(color: danger),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                ),
                onDaySelected: (selectedDay, focusedDay) async {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  // final result = await showTimePicker(
                  //   context: context,
                  //   initialTime: TimeOfDay.now(),
                  //   builder: (context, child) {
                  //     return MediaQuery(
                  //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  //       child: child ?? Container(),
                  //     );
                  //   },
                  // );
                  // if (result != null) {
                  //   Get.arguments['stepOrder']['executionTime'] = result.format(context);
                  // }

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
            Container(
              margin: EdgeInsets.only(top: 15),
              child: TimePickerSpinner(
                is24HourMode: true,
                normalTextStyle: TextStyle(fontSize: 24, color: black),
                highlightedTextStyle: TextStyle(fontSize: 24, color: red),
                spacing: 50,
                itemHeight: 45,
                isForce2Digits: true,
                onTimeChange: (time) {
                  setState(() {
                    Get.arguments['stepOrder']['executionTime'] = DateFormat('HH:mm').format(time);
                    // _dateTime = time;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 32),
        child: Button(
          text: 'Продолжить',
          onClick: () {
            createOrder();
          },
        ),
      ),
    );
  }
}
