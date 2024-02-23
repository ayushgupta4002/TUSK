import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? dataset;
  final String startDate;
  const MyHeatMap({super.key, required this.dataset, required this.startDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: HeatMap(
        startDate: createDateTimeObj(startDate),
        endDate: DateTime.now().add(const Duration(days: 29)),
        datasets: dataset,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey.shade400,
        textColor: Colors.black,
        showColorTip: false,
        showText: true,
        scrollable: true,
        size: 30,
        colorsets: {
          1: Colors.green.shade700,
        },
      ),
    );
  }
}

DateTime createDateTimeObj(String date) {
  DateFormat inputFormat = DateFormat('MMMM d, yyyy', 'en_US');

  // Parse the string into a DateTime object
  DateTime dateTime = inputFormat.parse(date);

  // Extract year, month, and date
  int year = dateTime.year;
  int month = dateTime.month;
  int day = dateTime.day;

  DateTime dateTimeObj = DateTime(year, month, day);

  return dateTimeObj;
}
