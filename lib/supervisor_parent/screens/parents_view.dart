import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:school_account/classes/dropdownRadiobutton.dart';
import 'package:school_account/classes/dropdowncheckboxitem.dart';
import 'package:school_account/supervisor_parent/components/elevated_simple_button.dart';
import 'package:school_account/supervisor_parent/components/supervisor_drawer.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/screens/add_parents.dart';
import 'package:school_account/supervisor_parent/screens/attendence_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/edit_add_parent.dart';
import 'package:school_account/supervisor_parent/screens/home_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/notification_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/profile_supervisor.dart';
import 'package:school_account/supervisor_parent/screens/track_supervisor.dart';
class ParentsView extends StatefulWidget {


  @override
  _ParentsViewState createState() => _ParentsViewState();
}

class _ParentsViewState extends State<ParentsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool Accepted = false;
  bool Declined = false;
  bool Waiting = false;
  String? selectedValueAccept;
  String? selectedValueDecline;
  String? selectedValueWaiting;
  List<DropdownCheckboxItem> selectedItems = [];
  int get dataLength => data.length;
  List<QueryDocumentSnapshot> data = [];
  bool isAcceptFiltered = false;
  bool isDeclineFiltered = false;
  bool isWaitingFiltered = false;
  bool isFiltered  = false;
  String? currentFilter;
  TextEditingController _searchController = TextEditingController();
  String SearchQuery = '';

  void _deleteSupervisorDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('parent')
        .doc(documentId)
        .delete()
        .then((_) {
      setState(() {
        // Update UI by removing the deleted document from the data list
        data.removeWhere((document) => document.id == documentId);
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   showSnackBarFun(context),
      //   // SnackBar(content: Text('Document deleted successfully')),
      // );
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete document: $error')),
      );
    });
  }

  getDataForDeclinedFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 0).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = parentData.docs;
      isFiltered = true;
    });
  }

  getDataForWaitingFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 1).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = parentData.docs;
      isFiltered = true;
    });
  }

  getDataForAcceptFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 2 ).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      data = parentData.docs;
      isFiltered = true;
    });
  }

  // getData()async{
  //   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('parent').get();
  //   // data.addAll(querySnapshot.docs);
  //   setState(() {
  //     data = querySnapshot.docs;
  //
  //   });
  // }

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    getData();
    // getDataForAcceptFilter();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    setState(() {
      SearchQuery = _searchController.text.trim();
    });
    getData(query: SearchQuery);
  }

  Future<void> getData({String query = ""}) async {
    QuerySnapshot querySnapshot;
    if (query.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance.collection('parent').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('parent')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
    }
    setState(() {
      data = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SupervisorDrawer(),
        body: Stack(
          children: [
            (sharedpref?.getString('lang') == 'ar')
                ? Positioned(
                    bottom: 20,
                    left: 25,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        print('object');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddParents()));
                      },
                      backgroundColor: Color(0xFF442B72),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 20,
                    right: 25,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        print('object');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddParents()));
                      },
                      backgroundColor: Color(0xFF442B72),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 17.0),
                          child: Image.asset(
                            (sharedpref?.getString('lang') == 'ar')
                                ? 'assets/images/Layer 1.png'
                                : 'assets/images/fi-rr-angle-left.png',
                            width: 20,
                            height: 22,
                          ),
                        ),
                      ),
                      Text(
                        'Parents'.tr,
                        style: TextStyle(
                          color: Color(0xFF993D9A),
                          fontSize: 16,
                          fontFamily: 'Poppins-Bold',
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 271,
                                height: 42,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(21),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: "Search Name".tr,
                                    hintStyle: TextStyle(
                                      color: const Color(0xffC2C2C2),
                                      fontSize: 12,
                                      fontFamily: 'Poppins-Bold',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    prefixIcon: Padding(
                                      padding: (sharedpref?.getString('lang') ==
                                              'ar')
                                          ? EdgeInsets.only(
                                              right: 6, top: 14.0, bottom: 9)
                                          : EdgeInsets.only(
                                              left: 3, top: 14.0, bottom: 9),
                                      child: Image.asset(
                                        'assets/images/Vector (12)search.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 20
                              // ),
                              PopupMenuButton<String>(
                                child: Image(
                                  image: AssetImage("assets/imgs/school/icons8_slider 2.png"),
                                  width: 29,
                                  height: 29,
                                  color: Color(0xFF442B72), // Optionally, you can set the color of the image
                                ),

                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'custom',
                                      child:
                                      Column(
                                        children: [
                                          Container(
                                            child:  DropdownRadiobutton(
                                              items: [
                                                DropdownCheckboxItem(label: 'Accepted'),
                                                DropdownCheckboxItem(label: 'Rejected'),
                                                DropdownCheckboxItem(label: 'Waiting'),
                                              ],
                                              selectedItems: selectedItems,
                                              onSelectionChanged: (items) {
                                                setState(() {
                                                  selectedItems = items;
                                                  if (items.first.label == 'Accepted') {
                                                    selectedValueAccept = 'Accepted';
                                                    selectedValueDecline = null;
                                                    selectedValueWaiting = null;
                                                  } else if (items.first.label == 'Rejected') {
                                                    selectedValueAccept = null;
                                                    selectedValueDecline = 'Rejected';
                                                    selectedValueWaiting = null;
                                                  } else if (items.first.label == 'Waiting') {
                                                    selectedValueAccept = null;
                                                    selectedValueDecline = null;
                                                    selectedValueWaiting = 'Waiting';
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width:100,
                                                child: ElevatedButton(

                                                  onPressed: () {
                                                    // Handle cancel action
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF442B72)),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                                      ),
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                      child: Text('Apply',style: TextStyle(fontSize:18),),
                                                  onTap: (){
                                                    if (selectedValueAccept != null) {
                                                      currentFilter = 'Accepted';
                                                      getDataForAcceptFilter();
                                                      Navigator.pop(context);
                                                      print('2');
                                                    }else  if (selectedValueDecline != null) {
                                                      currentFilter = 'Rejected';
                                                      getDataForDeclinedFilter();
                                                      Navigator.pop(context);
                                                      print('0');
                                                    }else  if (selectedValueWaiting != null) {
                                                      currentFilter = 'Waiting';
                                                      getDataForWaitingFilter();
                                                      Navigator.pop(context);
                                                      print('1');
                                                    }
                                                  },),
                                                ),
                                              ),
                                              SizedBox(width: 3,),
                                              GestureDetector(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text("Reset",style: TextStyle(color: Color(0xFF442B72),fontSize: 20),),
                                                ), onTap: (){
                                              Navigator.pop(context);
                                              },
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },

                              ),
                            ],
                          ),
                        ),
                        //ListView.builder(
                        //               itemCount: searchResults.length,
                        //               itemBuilder: (context, index) {
                        //                 return ListTile(
                        //                   title: Text(searchResults[index]),
                        //                 );
                        //               },
                        //             ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child:
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            // itemCount: data.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 12.0),
                                            child: Image.asset(
                                              'assets/images/Ellipse 6.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Text('${data[index]['name'] }',
                                                style: TextStyle(
                                                  color: Color(0xFF442B72),
                                                  fontSize: 17,
                                                  fontFamily: 'Poppins-SemiBold',
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.07,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: (sharedpref?.getString('lang') == 'ar')
                                                    ? EdgeInsets.only(right: 3.0)
                                                    : EdgeInsets.all(0.0),
                                                child: Text(
                                                  'Joined yesterday'.tr,
                                                  style: TextStyle(
                                                    color: Color(0xFF0E8113),
                                                    fontSize: 13,
                                                    fontFamily: 'Poppins-Regular',
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.23,),),),],),
                                          // SizedBox(width: 103,),
                                          ],),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            width: 111, height: 100),
                                        color: Colors.white,
                                        surfaceTintColor: Colors.transparent,
                                        offset: Offset(0, 30),
                                        itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'item1',
                                            child: Row(
                                              children: [Image.asset((sharedpref?.getString('lang') == 'ar')
                                                  ? 'assets/images/edittt_white_translate.png'
                                                  : 'assets/images/edittt_white.png', width: 12.81,
                                                height: 12.76,),
                                                SizedBox(width: 7,),
                                                Text('Edit'.tr, style: TextStyle(fontFamily: 'Poppins-Light', fontWeight: FontWeight.w400,
                                                  fontSize: 17, color: Color(0xFF432B72),),),],),),
                                          PopupMenuItem<String>(
                                              value: 'item2', child: Row(
                                            children: [Image.asset('assets/images/delete.png',
                                              width: 12.77, height: 13.81,),
                                              SizedBox(width: 7,),
                                              Text('Delete'.tr, style: TextStyle(fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400, fontSize: 15, color: Color(0xFF432B72),)),],)),],
                                        onSelected: (String value) {
                                          if (value == 'item1') {Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                              EditAddParents(docid: data[index].id,
                                                oldNumber: data[index].get('phoneNumber'),
                                                oldName: data[index].get('name'),
                                                oldNumberOfChildren: data[index].get('numberOfChildren'),
                                                oldType: data[index].get('typeOfParent'),
                                                // oldNameController: data[index].childrenData[index]['grade'],
                                                // oldGradeOfChild: ['l;']
                                                // oldGradeOfChild: data[index]['childern'].get('grade'),
                                              )),);
                                          } else if (value == 'item2') {
                                            void DeleteParentSnackBar(context, String message, {Duration? duration}) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  dismissDirection: DismissDirection.up,
                                                  duration: duration ?? const Duration(milliseconds: 1000),
                                                  backgroundColor: Colors.white,
                                                  margin: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context).size.height - 150,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),),
                                                  behavior: SnackBarBehavior.floating,
                                                  content: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset('assets/images/saved.png',
                                                        width: 30,
                                                        height: 30,),
                                                      SizedBox(width: 15,),
                                                      Text(
                                                        'Parent deleted successfully'.tr,
                                                        style: const TextStyle(
                                                          color: Color(0xFF4CAF50),
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins-Bold',
                                                          fontWeight: FontWeight.w700,
                                                          height: 1.23,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (ctx) => Dialog(
                                                  backgroundColor: Colors.white,
                                                  surfaceTintColor: Colors.transparent,
                                                  // contentPadding: const EdgeInsets.all(20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                      30,
                                                    ),
                                                  ),
                                                  child: SizedBox(
                                                    width: 304,
                                                    height: 182,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Flexible(
                                                                child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => Navigator.pop(context),
                                                                      child: Image.asset(
                                                                        'assets/images/Vertical container.png',
                                                                        width: 27,
                                                                        height: 27,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 25,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Delete'.tr,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    color: Color(0xFF442B72),
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins-SemiBold',
                                                                    fontWeight: FontWeight.w600,
                                                                    height: 1.23,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Center(
                                                            child: Text(
                                                              'Are You Sure you want to \n'
                                                                  'delete this parent ?'.tr,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF442B72),
                                                                fontSize: 16,
                                                                fontFamily: 'Poppins-Light',
                                                                fontWeight: FontWeight.w400,
                                                                height: 1.23,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                child: ElevatedSimpleButton(
                                                                  txt: 'Delete'.tr,
                                                                  width:  107,
                                                                  hight: 38,
                                                                  onPress: () async{
                                                                    setState(() {
                                                                      _deleteSupervisorDocument(data[index].id);
                                                                    });
                                                                    DeleteParentSnackBar(context, 'message');
                                                                    Navigator.pop(context);
                                                                  },
                                                                  color: const Color(0xFF442B72),
                                                                  fontSize: 16,
                                                                  fontFamily: 'Poppins-Regular',
                                                                ),
                                                              ),
                                                              // const Spacer(),
                                                              SizedBox(width: 15,),
                                                              SizedBox(
                                                                width: 107,
                                                                height: 38,
                                                                child:ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.white,
                                                                    surfaceTintColor: Colors.transparent,
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                          color: Color(0xFF442B72),
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                      'Cancel'.tr,
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          color: Color(0xFF442B72),
                                                                          fontFamily: 'Poppins-Regular',
                                                                          fontWeight: FontWeight.w500 ,
                                                                          fontSize: 16)
                                                                  ), onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            );
                                          }
                                        },
                                        child: Image.asset('assets/images/more.png', width: 20.8, height: 20.8,),),                                    ],
                                  ),
                                  SizedBox(height: 25,)],);},),
                        ),
                        SizedBox(height: 44,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Color(0xff442B72),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileSupervisorScreen(
                      // onTapMenu: onTapMenu
                      )));
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
                                              NotificationsSupervisor()),
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
                                          builder: (context) =>
                                              TrackSupervisor()),
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
                        ))))));
  }
}
