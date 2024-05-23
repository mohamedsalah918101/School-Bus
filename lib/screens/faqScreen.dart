import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_app_bar.dart';
import '../components/home_drawer.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List quotes = [
    {
      "answer":
      "The School Bus App is a mobile application designed to provide parents, students, and schools with real-time information about school bus routes, schedules, and safety updates.",
      "question": "What is the School Bus App?",
      "expanded": false,
    },
    {
      "answer":
      "You can download the School Bus App from the Apple App Store or Google Play Store. Simply search for \"School Bus App\" and look for our official logo.",
      "question": "How can I download the School Bus App?",
      "expanded": false,
    },
    {
      "answer":
      "The app provides real-time updates on school bus locations, estimated arrival times, route changes, delays, and safety notifications. It helps parents and students stay informed about bus movements.",
      "question": "What information does the app provide?",
      "expanded": false,
    },
    {
      "answer":
      "The app uses GPS technology to track the location of school buses. When parents or students log in, they can see the real-time location of their bus, its route, and any delays.",
      "question": "How does the app work?",
      "expanded": false,
    },
    {
      "answer":
      "The app is generally free to download and use, but some advanced features may require a subscription or in-app purchase.",
      "question": "Is the app free to use?",
      "expanded": false,
    },
    {
      "answer":
      "You can typically select your child's school within the app and add your child to the system using their student ID. This will allow you to receive accurate information about their bus route and schedule.",
      "question": "How do I set up the app for my child's school?",
      "expanded": false,
    },
    {
      "answer":
      "The estimated arrival times are based on real-time GPS data and traffic conditions. They are generally accurate, but factors like traffic jams or weather conditions might occasionally cause deviations.",
      "question": "How accurate are the estimated arrival times?",
      "expanded": false,
    },
    {
      "answer":
      "Yes, the app can send push notifications to alert you about delays, route changes, or other important updates related to your child's school bus.",
      "question": "Can I receive notifications for delays or changes?",
      "expanded": false,
    },
    {
      "answer":
      "We prioritize the security of your child's information. The app typically uses secure login methods, and personal data is encrypted to protect privacy.",
      "question": "Is the app secure? How is my child's information protected?",
      "expanded": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          endDrawer: HomeDrawer(),
          key: _scaffoldKey,
          appBar:PreferredSize(
      child: Container(
      decoration: BoxDecoration(
          boxShadow: [
          BoxShadow(
          color:  Color(0x3F000000),
      blurRadius: 12,
      offset: Offset(-1, 4),
      spreadRadius: 0,
      )
      ]),
      child: AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(16.49),
      ),
      ),
      elevation: 0.0,
      leading: InkWell(
      onTap: (){
      Navigator.of(context).pop();
      },
      child: const Icon(
      Icons.arrow_back_ios_new_rounded,
      size: 23,
      color: Color(0xff442B72),
      ),

      ),
      actions: [
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child:
      InkWell(
      onTap: (){
      _scaffoldKey.currentState!.openEndDrawer();
      },
      child: const Icon(
      Icons.menu_rounded,
      color: Color(0xff442B72),
      size: 35,
      ),
      ),
      ),
      ],
      title: Text('FAQ'.tr ,
      style: const TextStyle(
      color: Color(0xFF993D9A),
      fontSize: 17,
      fontFamily: 'Poppins-Bold',
      fontWeight: FontWeight.w700,
      height: 1,
      ),),
      backgroundColor:  Color(0xffF8F8F8),
      surfaceTintColor: Colors.transparent,
      ),
      ),
      preferredSize: Size.fromHeight(70),
      ),
          //Custom().customAppBar(context, 'FAQ'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: quotes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildExpandableTile(quotes[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                ),
                const SizedBox(
                  height: 85,
                )
              ],
            ),
          )),
    );
  }

  Widget _buildExpandableTile(Map item) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          item['question'],
          style: const TextStyle(
            color: Color(0xBF091C3F),
            fontSize: 16,
            overflow: TextOverflow.visible,
            fontFamily: 'Cairo-Regular',
            fontWeight: FontWeight.w400,
            height: 1.33,
            letterSpacing: -0.24,
          ),
        ),
        trailing: Icon(
          item['expanded']
              ? Icons.keyboard_arrow_down
              : Icons.keyboard_arrow_right,
          color: const Color(0xff091C3F),
          size: 18,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() => item['expanded'] = expanded);
        },
        children: [
          ListTile(
            title: Text(
              item['answer'],
              style: const TextStyle(
                color: Color(0xBF091C3F),
                fontSize: 16,
                fontFamily: 'Cairo-Regular',
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: -0.24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
