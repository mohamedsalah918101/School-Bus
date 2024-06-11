// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Holiday {
//   final String name;
//   final Timestamp fromDate;
//   final Timestamp toDate;
//   final bool isWeekend;
//
//   Holiday({required this.name, required this.fromDate, required this.toDate, this.isWeekend = false});
//
//   factory Holiday.fromJson(Map<String, dynamic> json) {
//     return Holiday(
//       name: json['name'],
//       fromDate: json['fromDate'],
//       toDate: json['toDate'],
//       isWeekend: json['isWeekend']?? false,
//     );
//   }
//   DateTime get fromDateAsDateTime => fromDate.toDate();
//   DateTime get toDateAsDateTime => toDate.toDate();
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Holiday {
  final String name;
  // final Timestamp fromDate;
  final String fromDate;
  final String toDate;
  //final Timestamp toDate;
  //final List<Timestamp> selectedDates;
  final List<String> selectedDates;
  final String schoolid;

  Holiday(
      {required this.name,
      required this.fromDate,
      required this.toDate,
      required this.selectedDates,
      required this.schoolid
      });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      selectedDates:
          List<String>.from(json['selectedDates'])
        , schoolid: json['SchoolId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fromDate': fromDate,
      'toDate': toDate,
      'selectedDates': selectedDates,
      'schoolid': schoolid,
    };
  }
}
