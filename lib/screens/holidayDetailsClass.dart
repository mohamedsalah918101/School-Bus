import 'package:flutter/material.dart';

class HolidayDetails extends StatelessWidget {
  final String name;
  final DateTime fromDate;
  final DateTime toDate;

  HolidayDetails({required this.name, required this.fromDate, required this.toDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 55,
          color: const Color(0xFF442B72),
        ),
        const SizedBox(
          width: 18,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '${fromDate.day} ${_getMonthName(fromDate.month)}. ${fromDate.year}',
              style: TextStyle(
                color: Color(0xFF4F4F4F),
                fontSize: 25,
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w500,
                height: 1.53,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                color: Color(0xFF442B72),
                fontSize: 14,
                fontFamily: 'Poppins-Light',
                fontWeight: FontWeight.w400,
                height: 2.38,
              ),
            ),
            Text(
              'To: ${toDate.day} ${_getMonthName(toDate.month)}. ${toDate.year}',
              style: TextStyle(
                color: Color(0xFF442B72),
                fontSize: 14,
                fontFamily: 'Poppins-Light',
                fontWeight: FontWeight.w400,
                height: 2.38,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}
