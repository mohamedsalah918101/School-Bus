import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  String messageContent, time, type;

  NotificationItem(
      {super.key,
        required this.messageContent,
        required this.time,
        required this.type});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 95,
          minWidth: double.infinity,
        ),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Image.asset(
                    //   type == 'Taken From School'
                    //       ? 'assets/imgs/school/house2.png'
                    //       : type == 'Arrival Reminder'
                    //       ? 'assets/imgs/school/locationtick.png'
                    //       : 'assets/imgs/school/alarm.png',
                    //
                    //   width: 16,
                    //   height: 16,
                    // ),
                    Image.asset(
                      {
                        'Taken From School': 'assets/imgs/school/house2.png',
                        'Arrival Reminder': 'assets/imgs/school/locationtick.png',
                        'Invitation Accepted': 'assets/imgs/school/Vector (4).png',
                        'Invitation Declined': 'assets/imgs/school/image (3).png',
                      }[type]?? 'assets/imgs/school/alarm.png', // default image
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      type,
                      style: TextStyle(
                        color: {
                          'Taken From School': Color(0xFFFFC53D),
                          'Arrival Reminder': Color(0xFF771F98),
                          'Invitation Accepted': Color(0xff0E8113),
                          'Invitation Declined': Color(0xFFDA1622),
                        }[type] ?? Color(0xFFDA1622), // default color
                        fontSize: 15,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w500,
                        height: 1.07,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF442B72),
                        fontSize: 12,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  messageContent,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
