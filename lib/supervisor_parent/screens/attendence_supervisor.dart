import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loadmore/loadmore.dart';

import 'package:flutter/material.dart';
import 'package:school_account/supervisor_parent/components/added_child_card.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/chat_screen.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_parent.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_parent.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../main.dart';

class AttendanceSupervisorScreen extends StatefulWidget {
  @override
  _AttendanceSupervisorScreenState createState() => _AttendanceSupervisorScreenState();
}

class _AttendanceSupervisorScreenState extends State<AttendanceSupervisorScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _limit = 5; // Number of documents to fetch per page
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMoreData = true;
  List<DocumentSnapshot> _documents = [];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<bool> checkin = [];
  bool isStarting = false;



  List<Map<String, dynamic>> childrenData = [];


  void makePhoneCall(String phoneNumber) async {
    var mobileCall = 'tel:$phoneNumber';
    if (await canLaunchUrlString(mobileCall)) {
      await launchUrlString(mobileCall);
    } else {
      throw 'Could not launch $mobileCall';
    }

  }


  String getJoinText(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown date';
    }

    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 1) {
      return 'Added ${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return 'Added yesterday';
    } else if (difference.inHours >= 1) {
      return 'Added ${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return 'Added ${difference.inMinutes} minutes ago';
    } else {
      return 'Added just now';
    }
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    print('Fetching data...');
    Query query = _firestore.collection('your_collection')
        .orderBy('your_field')
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
      print('Starting after document: ${_lastDocument!.id}');
    }

    try {
      QuerySnapshot querySnapshot = await query.get();
      print('Fetched ${querySnapshot.docs.length} documents');
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
        setState(() {
          _documents.addAll(querySnapshot.docs);
          print('Total documents: ${_documents.length}');
          if (querySnapshot.docs.length < _limit) {
            _hasMoreData = false;
            print('No more data to fetch');
          }
        });
      } else {
        setState(() {
          _hasMoreData = false;
          print('No more data to fetch');
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _fetchMoreData();
        }
      });

    _searchController.addListener(_onSearchChanged);
    // _scrollController.addListener(_scrollListener);
    _fetchData();
  }

  Future<void> _fetchData({String query = ""}) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    Query query = _firestore.collection('parent').limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final QuerySnapshot snapshot = await query.get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        _hasMoreData = false;
      });
    } else {

      // List<Map<String, dynamic>> filteredChildrenData = childrenData.where((child) {
      //   return child['name'].toLowerCase().contains(searchQuery.toLowerCase());
      // }).toList();
      List<Map<String, dynamic>> allChildren = [];
      for (var parentDoc in snapshot.docs) {
        List<dynamic> children = parentDoc['children'];
        allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
      }

      setState(() {
        _lastDocument = snapshot.docs.last;
        _documents.addAll(snapshot.docs);
        childrenData.addAll(allChildren);
        checkin = List.filled(_documents.length, false);

      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> _fetchData({String query = ""}) async {
  //   if (_isLoading || !_hasMoreData) return;
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Query query = _firestore.collection('parent').limit(_limit);
  //   if (_lastDocument != null) {
  //     query = query.startAfterDocument(_lastDocument!);
  //   }
  //   final QuerySnapshot snapshot = await query.get();
  //   if (snapshot.docs.isEmpty) {
  //     setState(() {
  //       _hasMoreData = false;
  //     });
  //   } else {
  //     setState(() {
  //       _lastDocument = snapshot.docs.last;
  //       _documents.addAll(snapshot.docs);
  //     });
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.trim();
      print('Search query changed: $searchQuery');
    });
    _fetchData(query: searchQuery);
  }


  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _fetchData();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Paginated List'),
      // ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17.0),
                        child: Image.asset(
                          (sharedpref?.getString('lang') == 'ar')?
                          'assets/images/Layer 1.png':
                          'assets/images/fi-rr-angle-left.png',
                          width: 20,
                          height: 22,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),//28
                      child: Text(
                        'Attendance'.tr,
                        style: TextStyle(
                          color: Color(0xFF993D9A),
                          fontSize: 16,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17.0),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Color(0xff442B72),
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child:

                                FutureBuilder(
                                  future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['photo'] == null || snapshot.data!.data()!['photo'].toString().trim().isEmpty) {
                                        return CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Color(0xff442B72),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                            radius: 30,
                                          ),
                                        );
                                      }

                                      Map<String, dynamic>? data = snapshot.data?.data();
                                      if (data != null && data['photo'] != null) {
                                        return CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Color(0xff442B72),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage('${data['photo']}'),
                                            radius:30,
                                          ),
                                        );
                                      }
                                    }

                                    return Container();
                                  },
                                ),
                              ),
                              SizedBox(width: 10,),
                              FutureBuilder(
                                future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.data?.data() == null) {
                                      return Text(
                                        'No data available',
                                        style: TextStyle(
                                          color: Color(0xff442B72),
                                          fontSize: 12,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      );
                                    }

                                    Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                                    String schoolName = data['schoolname']?.toString() ?? 'no school';
                                    List<String> words = schoolName.split(' ');

                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          for (String word in words) ...[
                                            TextSpan(
                                              text: '$word\n',
                                              style: TextStyle(
                                                color: Color(0xFF993D9A),
                                                fontSize: 20,
                                                fontFamily: 'Poppins-Bold',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }

                                  return CircularProgressIndicator();
                                },
                              )


                              // SizedBox(width: 25,),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: SizedBox(
                              width: 119,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding:  EdgeInsets.all(0),
                                    backgroundColor: Color(0xFF442B72),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                ),
                                onPressed: () async {
                                  isStarting =! isStarting;
                                  setState(() {
                                  });
                                },
                                child: Text(
                                  // 'test2',
                                  isStarting? 'End Your trip'.tr:'Start your trip'.tr,
                                  style: TextStyle(
                                      fontFamily: 'Poppins-SemiBold',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 13
                                  ),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text('Attendances'.tr,
                        style: TextStyle(
                          color: Color(0xFF771F98),
                          fontSize: 19,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                        ),),
                    ),
                    SizedBox(height: 15,),

                    sharedpref!.getInt('invit') == 1 ?

                    Container(
                      height: 700,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics:  NeverScrollableScrollPhysics(),
                          controller: _scrollController,
                          itemCount: _documents.length + 1,
                          itemBuilder: (context, index) {

                            if (index == _documents.length) {
                              return _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Center(child: Container()
                                // Text('No more data')
                              );
                            }
                            final DocumentSnapshot doc = _documents[index];
                            final data = doc.data() as Map<String, dynamic>;
                            var child = childrenData[index];
                            String supervisorPhoneNumber = _documents[index]['phoneNumber']?? 0;

                            return Column(
                              children: [
                                // for (var child in children)
                                if (child['supervisor'] == sharedpref!.getString('id').toString())
                                  SizedBox(
                                    width: double.infinity,
                                    height:122,
                                    child: Card(
                                      elevation: 10,
                                      color: Colors.white,
                                      surfaceTintColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14.0),
                                      ),
                                      child: Padding(
                                          padding: (sharedpref?.getString('lang') == 'ar')?
                                          EdgeInsets.only(right: 10.0 , left: 10) :
                                          EdgeInsets.only(left: 14.0 , right: 14 , bottom: 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 20.0),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        FutureBuilder(
                                                          future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                                                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                            if (snapshot.hasError) {
                                                              return Text('Something went wrong');
                                                            }

                                                            if (snapshot.connectionState == ConnectionState.done) {
                                                              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
                                                                return CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Color(0xff442B72),
                                                                  child: CircleAvatar(
                                                                    backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                                                                    radius: 25,
                                                                  ),
                                                                );
                                                              }

                                                              Map<String, dynamic>? data = snapshot.data?.data();
                                                              if (data != null && data['busphoto'] != null) {
                                                                return CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Color(0xff442B72),
                                                                  child: CircleAvatar(
                                                                    backgroundImage: NetworkImage('${data['busphoto']}'),
                                                                    radius:25,
                                                                  ),
                                                                );
                                                              }
                                                            }

                                                            return Container();
                                                          },
                                                        ),

                                                        const SizedBox(
                                                          width: 7,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                '${child['name']}',
                                                                style: TextStyle(
                                                                  color: Color(0xff442B72),
                                                                  fontSize: 17,
                                                                  fontFamily: 'Poppins-SemiBold',
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0.94,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'Grade: '.tr,
                                                                      style: TextStyle(
                                                                        color: Color(0xFF919191),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Poppins-Light',
                                                                        fontWeight: FontWeight.w400,
                                                                        // height: 1.33,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: '${child['grade']}',
                                                                      // '${data[index]['children']?[0]['grade'] }',
                                                                      style: TextStyle(
                                                                        color: Color(0xFF442B72),
                                                                        fontSize: 12,
                                                                        fontFamily: 'Poppins-Light',
                                                                        fontWeight: FontWeight.w400,
                                                                        // height: 1.33,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 20),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            width: 80,
                                                            child: ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  padding:  EdgeInsets.all(0),
                                                                  backgroundColor: Color(0xFF442B72),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(5)
                                                                  )
                                                              ),
                                                              onPressed: (){
                                                                // checkinStates[children.indexOf(child)] =!checkinStates[children.indexOf(child)];


                                                                setState(() {
                                                                  checkin[index] = !checkin[index];
                                                                });
                                                              },
                                                              child: Text(
                                                                // 'test1',
                                                                checkin[index] ? 'Check out'.tr : 'Check in'.tr,
                                                                style: TextStyle(
                                                                    fontFamily: 'Poppins-SemiBold',
                                                                    fontWeight: FontWeight.w600,
                                                                    color: Colors.white,
                                                                    fontSize: 13
                                                                ),),
                                                            ),
                                                          ),
                                                          SizedBox(height: 15,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              GestureDetector(
                                                                onTap:(){
                                                                  makePhoneCall(supervisorPhoneNumber);

                                                                },
                                                                child: Image.asset('assets/images/icons8_phone 1 (1).png' ,
                                                                  color: Color(0xff442B72),
                                                                  width: 28,
                                                                  height: 28,),
                                                              ),
                                                              SizedBox(width: 9),
                                                              GestureDetector(
                                                                child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
                                                                  color: Color(0xff442B72),
                                                                  width: 26,
                                                                  height: 26,),
                                                                onTap: () {
                                                                  print('object');
                                                                  Navigator.of(context).push(
                                                                      MaterialPageRoute(builder: (context) =>
                                                                          ChatScreen(
                                                                            receiverName: data[index]['name'],
                                                                            receiverPhone: data[index]['phoneNumber'],
                                                                            receiverId : data[index].id,
                                                                          )));
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                SizedBox(height: 5,)
                              ],
                            );
                          },
                        ),
                      ),
                    ) :
                    Column(
                      children: [
                        SizedBox(height: 50,),
                        Image.asset('assets/images/Group 237684.png',
                        ),
                        Text('No Data Found'.tr,
                          style: TextStyle(
                            color: Color(0xff442B72),
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                        Text('You haven’t added any \n '
                            'dates yet'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xffBE7FBF),
                            fontFamily: 'Poppins-Light',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),)
                      ],
                    ),
                  ],
                ),
              ))
            ],
          )
        ),

        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Color(0xff442B72),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileSupervisorScreen()));
            },
            child: Image.asset(
              'assets/images/174237 1.png',
              height: 33,
              width: 33,
              fit: BoxFit.cover,
            )),
        bottomNavigationBar: Directionality(
            textDirection: Get.locale == Locale('ar')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: BottomAppBar(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    height: 60,
                    color: const Color(0xFF442B72),
                    clipBehavior: Clip.antiAlias,
                    shape: const AutomaticNotchedShape(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38.5),
                                topRight: Radius.circular(38.5))),
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)))),
                    notchMargin: 7,
                    child: SizedBox(
                        height: 10,
                        child: SingleChildScrollView(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeForSupervisor()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 7, right: 15)
                                      : EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (7).png',
                                          height: 20,
                                          width: 20),
                                      SizedBox(height: 3),
                                      Text(
                                        "Home".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AttendanceSupervisorScreen()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(top: 9, left: 50)
                                      : EdgeInsets.only(right: 50, top: 2),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/icons8_checklist_1 1.png',
                                          height: 19,
                                          width: 19),
                                      SizedBox(height: 3),
                                      Text(
                                        "Attendance".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationsParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(
                                      top: 12, bottom: 4, right: 10)
                                      : EdgeInsets.only(
                                      top: 8, bottom: 4, left: 20),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (2).png',
                                          height: 17,
                                          width: 16.2),
                                      Image.asset(
                                          'assets/images/Vector (5).png',
                                          height: 4,
                                          width: 6),
                                      SizedBox(height: 2),
                                      Text(
                                        "Notifications".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TrackParent()),
                                    );
                                  });
                                },
                                child: Padding(
                                  padding:
                                  (sharedpref?.getString('lang') == 'ar')
                                      ? EdgeInsets.only(
                                      top: 10,
                                      bottom: 2,
                                      right: 10,
                                      left: 0)
                                      : EdgeInsets.only(
                                      top: 8,
                                      bottom: 2,
                                      left: 0,
                                      right: 10),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/images/Vector (4).png',
                                          height: 18.36,
                                          width: 23.5),
                                      SizedBox(height: 3),
                                      Text(
                                        "Buses".tr,
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))))
    );
  }
}





//Column(
//             children: [
//               SizedBox(
//                 height: 35,
//               ),
//               Container(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: (){
//                         Navigator.of(context).pop();
//                       },
//                       child:  Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 17.0),
//                         child: Image.asset(
//                           (sharedpref?.getString('lang') == 'ar')?
//                           'assets/images/Layer 1.png':
//                           'assets/images/fi-rr-angle-left.png',
//                           width: 20,
//                           height: 22,),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 0.0),//28
//                       child: Text(
//                         'Attendance'.tr,
//                         style: TextStyle(
//                           color: Color(0xFF993D9A),
//                           fontSize: 16,
//                           fontFamily: 'Poppins-Bold',
//                           fontWeight: FontWeight.w700,
//                           height: 1,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         _scaffoldKey.currentState!.openEndDrawer();
//                       },
//                       icon: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 17.0),
//                         child: const Icon(
//                           Icons.menu_rounded,
//                           color: Color(0xff442B72),
//                           size: 35,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Column(
//                 children: [
//                   Expanded(
//                     flex: 0,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: 20,),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(bottom: 20.0),
//                                       child:
//
//                                       FutureBuilder(
//                                         future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
//                                         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//                                           if (snapshot.hasError) {
//                                             return Text('Something went wrong');
//                                           }
//                                           if (snapshot.connectionState == ConnectionState.done) {
//                                             if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['photo'] == null || snapshot.data!.data()!['photo'].toString().trim().isEmpty) {
//                                               return CircleAvatar(
//                                                 radius: 30,
//                                                 backgroundColor: Color(0xff442B72),
//                                                 child: CircleAvatar(
//                                                   backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                   radius: 30,
//                                                 ),
//                                               );
//                                             }
//
//                                             Map<String, dynamic>? data = snapshot.data?.data();
//                                             if (data != null && data['photo'] != null) {
//                                               return CircleAvatar(
//                                                 radius: 30,
//                                                 backgroundColor: Color(0xff442B72),
//                                                 child: CircleAvatar(
//                                                   backgroundImage: NetworkImage('${data['photo']}'),
//                                                   radius:30,
//                                                 ),
//                                               );
//                                             }
//                                           }
//
//                                           return Container();
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(width: 10,),
//                                     FutureBuilder(
//                                       future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
//                                       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                                         if (snapshot.hasError) {
//                                           return Text('Something went wrong');
//                                         }
//
//                                         if (snapshot.connectionState == ConnectionState.done) {
//                                           if (snapshot.data?.data() == null) {
//                                             return Text(
//                                               'No data available',
//                                               style: TextStyle(
//                                                 color: Color(0xff442B72),
//                                                 fontSize: 12,
//                                                 fontFamily: 'Poppins-Regular',
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             );
//                                           }
//
//                                           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//
//                                           String schoolName = data['schoolname']?.toString() ?? 'no school';
//                                           List<String> words = schoolName.split(' ');
//
//                                           return Text.rich(
//                                             TextSpan(
//                                               children: [
//                                                 for (String word in words) ...[
//                                                   TextSpan(
//                                                     text: '$word\n',
//                                                     style: TextStyle(
//                                                       color: Color(0xFF993D9A),
//                                                       fontSize: 20,
//                                                       fontFamily: 'Poppins-Bold',
//                                                       fontWeight: FontWeight.w700,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ],
//                                             ),
//                                           );
//                                         }
//
//                                         return CircularProgressIndicator();
//                                       },
//                                     )
//
//
//                                     // SizedBox(width: 25,),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 25.0),
//                                   child: SizedBox(
//                                     width: 119,
//                                     height: 40,
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           padding:  EdgeInsets.all(0),
//                                           backgroundColor: Color(0xFF442B72),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(5)
//                                           )
//                                       ),
//                                       onPressed: () async {
//                                         isStarting =! isStarting;
//                                         setState(() {
//                                         });
//                                       },
//                                       child: Text(
//                                         // 'test2',
//                                         isStarting? 'End Your trip'.tr:'Start your trip'.tr,
//                                         style: TextStyle(
//                                             fontFamily: 'Poppins-SemiBold',
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white,
//                                             fontSize: 13
//                                         ),),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 15,),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 28.0),
//                             child: Text('Attendances'.tr,
//                               style: TextStyle(
//                                 color: Color(0xFF771F98),
//                                 fontSize: 19,
//                                 fontFamily: 'Poppins-Bold',
//                                 fontWeight: FontWeight.w700,
//                               ),),
//                           ),
//                           SizedBox(height: 15,)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               Expanded(
//
//                 child:
//                 sharedpref!.getInt('invit') == 1 ?
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     // physics:  NeverScrollableScrollPhysics(),
//                     controller: _scrollController,
//                     itemCount: _documents.length + 1,
//                     itemBuilder: (context, index) {
//
//                       if (index == _documents.length) {
//                         return _isLoading
//                             ? Center(child: CircularProgressIndicator())
//                             : Center(child: Container()
//                           // Text('No more data')
//                         );
//                       }
//                       final DocumentSnapshot doc = _documents[index];
//                       final data = doc.data() as Map<String, dynamic>;
//                       var child = childrenData[index];
//                       String supervisorPhoneNumber = _documents[index]['phoneNumber']?? 0;
//
//                       return Column(
//                         children: [
//                           // for (var child in children)
//                           if (child['supervisor'] == sharedpref!.getString('id').toString())
//                             SizedBox(
//                               width: double.infinity,
//                               height:122,
//                               child: Card(
//                                 elevation: 10,
//                                 color: Colors.white,
//                                 surfaceTintColor: Colors.transparent,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14.0),
//                                 ),
//                                 child: Padding(
//                                     padding: (sharedpref?.getString('lang') == 'ar')?
//                                     EdgeInsets.only(right: 10.0 , left: 10) :
//                                     EdgeInsets.only(left: 14.0 , right: 14 , bottom: 0),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.only(bottom: 20.0),
//                                               child: Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 children: [
//                                                   FutureBuilder(
//                                                     future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
//                                                     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
//                                                       if (snapshot.hasError) {
//                                                         return Text('Something went wrong');
//                                                       }
//
//                                                       if (snapshot.connectionState == ConnectionState.done) {
//                                                         if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
//                                                           return CircleAvatar(
//                                                             radius: 25,
//                                                             backgroundColor: Color(0xff442B72),
//                                                             child: CircleAvatar(
//                                                               backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
//                                                               radius: 25,
//                                                             ),
//                                                           );
//                                                         }
//
//                                                         Map<String, dynamic>? data = snapshot.data?.data();
//                                                         if (data != null && data['busphoto'] != null) {
//                                                           return CircleAvatar(
//                                                             radius: 25,
//                                                             backgroundColor: Color(0xff442B72),
//                                                             child: CircleAvatar(
//                                                               backgroundImage: NetworkImage('${data['busphoto']}'),
//                                                               radius:25,
//                                                             ),
//                                                           );
//                                                         }
//                                                       }
//
//                                                       return Container();
//                                                     },
//                                                   ),
//
//                                                   const SizedBox(
//                                                     width: 7,
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(top: 10.0),
//                                                     child: Column(
//                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(
//                                                           '${child['name']}',
//                                                           style: TextStyle(
//                                                             color: Color(0xff442B72),
//                                                             fontSize: 17,
//                                                             fontFamily: 'Poppins-SemiBold',
//                                                             fontWeight: FontWeight.w600,
//                                                             height: 0.94,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 4,
//                                                         ),
//                                                         Text.rich(
//                                                           TextSpan(
//                                                             children: [
//                                                               TextSpan(
//                                                                 text: 'Grade: '.tr,
//                                                                 style: TextStyle(
//                                                                   color: Color(0xFF919191),
//                                                                   fontSize: 12,
//                                                                   fontFamily: 'Poppins-Light',
//                                                                   fontWeight: FontWeight.w400,
//                                                                   // height: 1.33,
//                                                                 ),
//                                                               ),
//                                                               TextSpan(
//                                                                 text: '${child['grade']}',
//                                                                 // '${data[index]['children']?[0]['grade'] }',
//                                                                 style: TextStyle(
//                                                                   color: Color(0xFF442B72),
//                                                                   fontSize: 12,
//                                                                   fontFamily: 'Poppins-Light',
//                                                                   fontWeight: FontWeight.w400,
//                                                                   // height: 1.33,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Column(
//                                               children: [
//                                                 SizedBox(height: 20),
//                                                 Column(
//                                                   children: [
//                                                     SizedBox(
//                                                       height: 40,
//                                                       width: 80,
//                                                       child: ElevatedButton(
//                                                         style: ElevatedButton.styleFrom(
//                                                             padding:  EdgeInsets.all(0),
//                                                             backgroundColor: Color(0xFF442B72),
//                                                             shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.circular(5)
//                                                             )
//                                                         ),
//                                                         onPressed: (){
//                                                           // checkinStates[children.indexOf(child)] =!checkinStates[children.indexOf(child)];
//
//
//                                                           setState(() {
//                                                             checkin[index] = !checkin[index];
//                                                           });
//                                                         },
//                                                         child: Text(
//                                                           // 'test1',
//                                                           checkin[index] ? 'Check out'.tr : 'Check in'.tr,
//                                                           style: TextStyle(
//                                                               fontFamily: 'Poppins-SemiBold',
//                                                               fontWeight: FontWeight.w600,
//                                                               color: Colors.white,
//                                                               fontSize: 13
//                                                           ),),
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: 15,),
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         GestureDetector(
//                                                           onTap:(){
//                                                             makePhoneCall(supervisorPhoneNumber);
//
//                                                           },
//                                                           child: Image.asset('assets/images/icons8_phone 1 (1).png' ,
//                                                             color: Color(0xff442B72),
//                                                             width: 28,
//                                                             height: 28,),
//                                                         ),
//                                                         SizedBox(width: 9),
//                                                         GestureDetector(
//                                                           child: Image.asset('assets/images/icons8_chat 1 (1).png' ,
//                                                             color: Color(0xff442B72),
//                                                             width: 26,
//                                                             height: 26,),
//                                                           onTap: () {
//                                                             print('object');
//                                                             Navigator.of(context).push(
//                                                                 MaterialPageRoute(builder: (context) =>
//                                                                     ChatScreen(
//                                                                       receiverName: data[index]['name'],
//                                                                       receiverPhone: data[index]['phoneNumber'],
//                                                                       receiverId : data[index].id,
//                                                                     )));
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     )),
//                               ),
//                             ),
//                           SizedBox(height: 5,)
//                         ],
//                       );
//                     },
//                   ),
//                 ) :
//                 Column(
//                   children: [
//                     SizedBox(height: 50,),
//                     Image.asset('assets/images/Group 237684.png',
//                     ),
//                     Text('No Data Found'.tr,
//                       style: TextStyle(
//                         color: Color(0xff442B72),
//                         fontFamily: 'Poppins-Regular',
//                         fontWeight: FontWeight.w500,
//                         fontSize: 19,
//                       ),
//                     ),
//                     Text('You haven’t added any \n '
//                         'dates yet'.tr,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Color(0xffBE7FBF),
//                         fontFamily: 'Poppins-Light',
//                         fontWeight: FontWeight.w400,
//                         fontSize: 12,
//                       ),)
//                   ],
//                 ),
//
//               ),
//             ],
//           ),





