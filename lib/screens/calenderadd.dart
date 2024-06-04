// class SchoolHoliday {
//   String name;
//   DateTime fromDate;
//   DateTime toDate;
//
//   SchoolHoliday({
//     required this.name,
//     required this.fromDate,
//     required this.toDate,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'nameholiday': name,
//     'fromdate': fromDate,
//     'todate': toDate,
//   };
// }


// to save list of all dates
import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolHoliday {
  final String name;
  final List<Timestamp> dates;

  SchoolHoliday({required this.name, required this.dates});

  factory SchoolHoliday.fromJson(Map<String, dynamic> json) {
    return SchoolHoliday(
      name: json['name'],
      dates: (json['dates'] as List<dynamic>).map((e) => e as Timestamp).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dates': dates,
    };
  }
}
