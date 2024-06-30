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
  // int? numberOfNames;


  @override
  _ParentsViewState createState() => _ParentsViewState();
  }




class _ParentsViewState extends State<ParentsView> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  // List<QueryDocumentSnapshot> data = [];
  List<DropdownCheckboxItem> selectedItems = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedValueAccept;
  String? selectedValueDecline;
  String? selectedValueWaiting;





  getDataForDeclinedFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 2).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      _documents = parentData.docs;
      isFiltered = true;
    });
  }

  getDataForWaitingFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 0).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      _documents = parentData.docs;
      isFiltered = true;
    });
  }

  getDataForAcceptFilter()async{
    CollectionReference parent = FirebaseFirestore.instance.collection('parent');
    QuerySnapshot parentData = await parent.where('state' , isEqualTo: 1 ).get();
    // parentData.docs.forEach((element) {
    //   data.add(element);
    // }
    // );
    setState(() {
      _documents = parentData.docs;
      isFiltered = true;
    });
  }

  String? currentFilter;
  bool isAcceptFiltered = false;
  bool isDeclineFiltered = false;
  bool isWaitingFiltered = false;
  bool isFiltered  = false;

  void _deleteSupervisorDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('parent')
        .doc(documentId)
        .delete()
        .then((_) {
      setState(() {
        // Update UI by removing the deleted document from the data list
        _documents.removeWhere((document) => document.id == documentId);
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


  String getJoinText(Timestamp joinDate) {
    final now = DateTime.now();
    final joinDateTime = joinDate.toDate();
    final difference = now.difference(joinDateTime).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference} days ago';
    } else {
      return '${joinDateTime.day}/${joinDateTime.month}/${joinDateTime.year}';
    }
  }


  bool _isLoading = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  int _limit = 8;
  String searchQuery = "";

  List<DocumentSnapshot> _documents = [];
  List<Map<String, dynamic>> childrenData = [];
  List<bool> checkin = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _scrollController.addListener(_scrollListener);
      _searchController.addListener(_onSearchChanged);
      _fetchMoreData();
    });

  }

  Future<void> _fetchMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    print('Fetching data...');
    String? supervisorId = sharedpref!.getString('id');
    if (supervisorId == null) {
      print('Supervisor ID is null');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Query query = _firestore.collection('parent')
        .where('supervisor', isEqualTo: supervisorId)
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
        List<Map<String, dynamic>> allChildren = [];
        for (var parentDoc in querySnapshot.docs) {
          List<dynamic> children = parentDoc['children'];
          allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
        }
        setState(() {
          _documents.addAll(querySnapshot.docs);
          childrenData.addAll(allChildren);
          checkin = List.filled(_documents.length, false);
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

  Future<void> getData({String query = ""}) async {
    try {
      String? supervisorId = sharedpref!.getString('id');
      if (supervisorId == null) {
        print('Supervisor ID is null');
        return;
      }

      print('Supervisor ID: $supervisorId');
      QuerySnapshot querySnapshot;

      if (query.isEmpty) {
        print('Query is empty, searching by supervisorId only');
        querySnapshot = await FirebaseFirestore.instance.collection('parent')
            .where('supervisor', isEqualTo: supervisorId)
            .get();
      } else {
        print('Searching by supervisorId and name');
        querySnapshot = await FirebaseFirestore.instance
            .collection('parent')
            .where('supervisor', isEqualTo: supervisorId)
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get();
      }

      setState(() {
        _documents = querySnapshot.docs;
      });

      print('Fetched ${querySnapshot.docs.length} documents');
      for (var doc in querySnapshot.docs) {
        print(doc.data());
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        // errorMessage = e.toString();
      });
    }
  }

  Future<void> _fetchData({String query = ""}) async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    String? supervisorId = sharedpref!.getString('id');
    if (supervisorId == null) {
      print('Supervisor ID is null');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Query baseQuery = _firestore.collection('parent')
        .where('supervisor', isEqualTo: supervisorId)
        .limit(_limit);

    if (_lastDocument != null) {
      baseQuery = baseQuery.startAfterDocument(_lastDocument!);
    }

    QuerySnapshot snapshot;
    if (query.isNotEmpty) {
      // Filter the data based on the search query
      snapshot = await baseQuery.where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
    } else {
      // Fetch all the data
      snapshot = await baseQuery.get();
    }

    if (snapshot.docs.isEmpty) {
      setState(() {
        _hasMoreData = false;
      });
    } else {
      List<Map<String, dynamic>> allChildren = [];
      for (var parentDoc in snapshot.docs) {
        List<dynamic> children = parentDoc['children'];
        allChildren.addAll(children.map((child) => child as Map<String, dynamic>).toList());
      }

      // Filter the childrenData list based on the search query
      List<Map<String, dynamic>> filteredChildrenData = allChildren.where((child) {
        return child['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        _lastDocument = snapshot.docs.last;
        _documents.addAll(snapshot.docs);
        childrenData.clear(); // Clear the existing childrenData
        childrenData.addAll(filteredChildrenData);
        checkin = List.filled(_documents.length, false);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }


  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.trim();
      print('Search query changed: $searchQuery');
    });
    getData(query: searchQuery);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoading) {
      _fetchMoreData();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SupervisorDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 35,
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
                SizedBox(height: 20,),
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
                          onChanged: (value) {
                            _onSearchChanged();
                          },
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
                                        DropdownCheckboxItem(label: 'Declined'),
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
                                          } else if (items.first.label == 'Declined') {
                                            selectedValueAccept = null;
                                            selectedValueDecline = 'Declined';
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
                                                print('0');
                                              }else  if (selectedValueDecline != null) {
                                                currentFilter = 'Declined';
                                                getDataForDeclinedFilter();
                                                Navigator.pop(context);
                                                print('1');
                                              }else  if (selectedValueWaiting != null) {
                                                currentFilter = 'Waiting';
                                                getDataForWaitingFilter();
                                                Navigator.pop(context);
                                                print('2');
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
                // Add your AppBar and other UI elements here
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                     child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _documents.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _documents.length) {
                            return _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : _hasMoreData
                                ? SizedBox.shrink()
                                : Center(child: Text('No more data'));
                          }
                          final DocumentSnapshot doc = _documents[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final int state = data['state'] ?? 0;
                          final joinDateText = getJoinText(data['joinDate'] ?? DateTime.now());
                          String statusText;

                          switch (state) {
                            case 0:
                              statusText = 'waiting $joinDateText';
                              break;
                            case 1:
                              statusText = 'Joined $joinDateText';
                              break;
                            case 2:
                              statusText = 'declined $joinDateText';
                              break;
                            default:
                              statusText = 'Unknown status';
                              break;
                          }

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12.0),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Color(0xff442B72),
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage('assets/images/Group 237679 (2).png'),
                                            radius: 25,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data['name'] ?? ''}',
                                            style: TextStyle(
                                              color: Color(0xFF442B72),
                                              fontSize: 17,
                                              fontFamily: 'Poppins-SemiBold',
                                              fontWeight: FontWeight.w600,
                                              height: 1.07,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Padding(
                                            padding: (sharedpref?.getString('lang') == 'ar')
                                                ? EdgeInsets.only(right: 3.0)
                                                : EdgeInsets.all(0.0),
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                color: Color(0xFF0E8113).withOpacity(0.7),
                                                fontSize: 13,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w400,
                                                height: 1.23,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    constraints: BoxConstraints.tightFor(width: 111, height: 100),
                                    color: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    offset: Offset(0, 30),
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'item1',
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              (sharedpref?.getString('lang') == 'ar')
                                                  ? 'assets/images/edittt_white_translate.png'
                                                  : 'assets/images/edittt_white.png',
                                              width: 12.81,
                                              height: 12.76,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Edit'.tr,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                                color: Color(0xFF432B72),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'item2',
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/delete.png',
                                              width: 12.77,
                                              height: 13.81,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Delete'.tr,
                                              style: TextStyle(
                                                fontFamily: 'Poppins-Light',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Color(0xFF432B72),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (String value) {
                                      if (value == 'item1') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditAddParents(
                                              docid: _documents[index].id,
                                              oldNumber: _documents[index].get('phoneNumber'),
                                              oldName: _documents[index].get('name'),
                                              oldNumberOfChildren: _documents[index].get('numberOfChildren').toString(),
                                              oldType: _documents[index].get('typeOfParent'),
                                              childrenData: _documents[index]['children'].map<Map<String, dynamic>>((child) => Map<String, dynamic>.from(child)).toList(),
                                              oldNameOfChild: _documents[index]['children'].isNotEmpty ? _documents[index]['children'][0]['name'] : 'No Name',
                                              oldGradeOfChild: _documents[index]['children'].isNotEmpty && _documents[index]['children'][0]['grade'] != null
                                                  ? _documents[index]['children'][0]['grade']
                                                  : '0',
                                            ),
                                          ),
                                        ).then((result) async {
                                          await _fetchData();
                                        });
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
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              behavior: SnackBarBehavior.floating,
                                              content: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/saved.png',
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                  SizedBox(width: 15),
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
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
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
                                                        const SizedBox(width: 8),
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
                                                              const SizedBox(height: 25),
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
                                                        'Are You Sure you want to \ndelete this parent ?'.tr,
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
                                                    const SizedBox(height: 15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          child: ElevatedSimpleButton(
                                                            txt: 'Delete'.tr,
                                                            width: 107,
                                                            hight: 38,
                                                            onPress: () async {
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
                                                        SizedBox(width: 15),
                                                        SizedBox(
                                                          width: 107,
                                                          height: 38,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.white,
                                                              surfaceTintColor: Colors.transparent,
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                  color: Color(0xFF442B72),
                                                                ),
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Cancel'.tr,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                color: Color(0xFF442B72),
                                                                fontFamily: 'Poppins-Regular',
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/images/more.png',
                                      width: 20.8,
                                      height: 20.8,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                            ],
                          );
                        },
                      ),
                    // child: ListView.builder(
                    //   controller: _scrollController,
                    //   itemCount: _documents.length + 1,
                    //   itemBuilder: (context, index) {
                    //     if (index == _documents.length) {
                    //       return _isLoading
                    //           ? Center(child: CircularProgressIndicator())
                    //           : _hasMoreData
                    //           ? SizedBox.shrink()
                    //           : Center(child: Text('No more data'));
                    //     }
                    //     final DocumentSnapshot doc = _documents[index];
                    //     final data = doc.data() as Map<String, dynamic>;
                    //     // var child = childrenData[index];
                    //
                    //     return    Column(
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment
                    //               .spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Padding(
                    //                   padding:
                    //                   const EdgeInsets.only(top: 12.0),
                    //                   child:
                    //                   CircleAvatar(
                    //                     radius: 25,
                    //                     backgroundColor: Color(
                    //                         0xff442B72),
                    //                     child: CircleAvatar(
                    //                       backgroundImage: AssetImage('assets/images/Group 237679 (2).png'),
                    //                       // Replace with your default image path
                    //                       radius: 25,
                    //                     ),
                    //                   ),
                    //                   // FutureBuilder(future: _firestore.collection(
                    //                   //       'supervisor').doc(sharedpref!.getString('id')).get(),
                    //                   //   builder: (BuildContext context,
                    //                   //       AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    //                   //     if (snapshot.hasError) {
                    //                   //       return Text('Something went wrong');
                    //                   //     }
                    //                   //
                    //                   //     if (snapshot.connectionState == ConnectionState.done) {
                    //                   //       if (!snapshot.hasData || snapshot.data == null ||
                    //                   //           snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] ==
                    //                   //           null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
                    //                   //         return CircleAvatar(
                    //                   //           radius: 25,
                    //                   //           backgroundColor: Color(
                    //                   //               0xff442B72),
                    //                   //           child: CircleAvatar(
                    //                   //             backgroundImage: AssetImage('assets/images/Group 237679 (2).png'),
                    //                   //             // Replace with your default image path
                    //                   //             radius: 25,
                    //                   //           ),
                    //                   //         );
                    //                   //       }
                    //                   //
                    //                   //       Map<String, dynamic>? data = snapshot.data?.data();
                    //                   //       if (data != null && data['busphoto'] != null) {
                    //                   //         return CircleAvatar(radius: 25,
                    //                   //           backgroundColor: Color(
                    //                   //               0xff442B72),
                    //                   //           child: CircleAvatar(
                    //                   //             backgroundImage: NetworkImage('${data['busphoto']}'),
                    //                   //             radius: 25,
                    //                   //           ),
                    //                   //         );
                    //                   //       }
                    //                   //     }
                    //                   //
                    //                   //     return Container();
                    //                   //   },
                    //                   // ),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 Column(
                    //                   mainAxisAlignment: MainAxisAlignment
                    //                       .start,
                    //                   crossAxisAlignment: CrossAxisAlignment
                    //                       .start,
                    //
                    //                   children: [
                    //                     Text('${_documents[index]['name'] ??
                    //                         '' }',
                    //                       style: TextStyle(
                    //                         color: Color(0xFF442B72),
                    //                         fontSize: 17,
                    //                         fontFamily: 'Poppins-SemiBold',
                    //                         fontWeight: FontWeight
                    //                             .w600,
                    //                         height: 1.07,
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       height: 5,
                    //                     ),
                    //                     Padding(
                    //                       padding: (sharedpref
                    //                           ?.getString('lang') ==
                    //                           'ar')
                    //                           ? EdgeInsets.only(
                    //                           right: 3.0)
                    //                           : EdgeInsets.all(0.0),
                    //                       child:
                    //                       Text(
                    //                         // state == 'waiting'
                    //                         // ? 'Waiting'
                    //                         //     :
                    //                         'Joined ${getJoinText(
                    //                             _documents[index]['joinDate'] ??
                    //                                 DateTime.now())}',
                    //                         style: TextStyle(
                    //                           color: Color(0xFF0E8113).withOpacity(0.7),
                    //                           fontSize: 13,
                    //                           fontFamily: 'Poppins-Regular',
                    //                           fontWeight: FontWeight
                    //                               .w400,
                    //                           height: 1.23,
                    //                         ),),
                    //                       // Text(
                    //                       //   'Joined ${getJoinText(data[index]['joinDate'] ?? DateTime.now())}',
                    //                       //  // '${data[index]['joinDate']}',
                    //                       //
                    //                       //   style: TextStyle(
                    //                       //     color: Color(0xFF0E8113),
                    //                       //     fontSize: 13,
                    //                       //     fontFamily: 'Poppins-Regular',
                    //                       //     fontWeight: FontWeight.w400,
                    //                       //     height: 1.23,),),
                    //                     ),
                    //                   ],),
                    //                 // SizedBox(width: 103,),
                    //               ],),
                    //             PopupMenuButton<String>(
                    //               padding: EdgeInsets.zero,
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.all(
                    //                     Radius.circular(6)),
                    //               ),
                    //               constraints: BoxConstraints
                    //                   .tightFor(
                    //                   width: 111, height: 100),
                    //               color: Colors.white,
                    //               surfaceTintColor: Colors
                    //                   .transparent,
                    //               offset: Offset(0, 30),
                    //               itemBuilder: (
                    //                   BuildContext context) =>
                    //               <PopupMenuEntry<String>>[
                    //                 PopupMenuItem<String>(
                    //                   value: 'item1',
                    //                   child: Row(
                    //                     children: [
                    //                       Image.asset(
                    //                         (sharedpref?.getString(
                    //                             'lang') == 'ar')
                    //                             ? 'assets/images/edittt_white_translate.png'
                    //                             : 'assets/images/edittt_white.png',
                    //                         width: 12.81,
                    //                         height: 12.76,),
                    //                       SizedBox(width: 7,),
                    //                       Text('Edit'.tr,
                    //                         style: TextStyle(
                    //                           fontFamily: 'Poppins-Light',
                    //                           fontWeight: FontWeight
                    //                               .w400,
                    //                           fontSize: 17,
                    //                           color: Color(
                    //                               0xFF432B72),),),
                    //                     ],),),
                    //                 PopupMenuItem<String>(
                    //                     value: 'item2', child: Row(
                    //                   children: [
                    //                     Image.asset(
                    //                       'assets/images/delete.png',
                    //                       width: 12.77,
                    //                       height: 13.81,),
                    //                     SizedBox(width: 7,),
                    //                     Text('Delete'.tr,
                    //                         style: TextStyle(
                    //                           fontFamily: 'Poppins-Light',
                    //                           fontWeight: FontWeight
                    //                               .w400,
                    //                           fontSize: 15,
                    //                           color: Color(
                    //                               0xFF432B72),)),
                    //                   ],)),
                    //               ],
                    //               onSelected: (String value) {
                    //                 if (value == 'item1') {
                    //
                    //
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => EditAddParents(
                    //                         docid: _documents[index].id,
                    //                         oldNumber: _documents[index].get('phoneNumber'),
                    //                         oldName: _documents[index].get('name'),
                    //                         oldNumberOfChildren: _documents[index].get('numberOfChildren').toString(),
                    //                         oldType: _documents[index].get('typeOfParent'),
                    //                         childrenData: _documents[index]['children'].map<Map<String, dynamic>>((child) => Map<String, dynamic>.from(child)).toList(),
                    //                         oldNameOfChild: _documents[index]['children'].isNotEmpty ? _documents[index]['children'][0]['name'] : 'No Name',
                    //                         oldGradeOfChild: _documents[index]['children'].isNotEmpty && _documents[index]['children'][0]['grade'] != null
                    //                             ? _documents[index]['children'][0]['grade']
                    //                             : '0',
                    //                       ),
                    //                     ),
                    //                   ).then((result) async {
                    //                     // if (result != null && result is bool && result) {
                    //                       // Refresh data on PaginatedListtt if needed
                    //                       await _fetchData(); // Example: Call a function to fetch updated data
                    //                     // }
                    //                   });
                    //                 } else if (value == 'item2') {
                    //                   void DeleteParentSnackBar(
                    //                       context, String message,
                    //                       {Duration? duration}) {
                    //                     ScaffoldMessenger.of(context)
                    //                         .showSnackBar(
                    //                       SnackBar(
                    //                         dismissDirection: DismissDirection
                    //                             .up,
                    //                         duration: duration ??
                    //                             const Duration(
                    //                                 milliseconds: 1000),
                    //                         backgroundColor: Colors
                    //                             .white,
                    //                         margin: EdgeInsets.only(
                    //                           bottom: MediaQuery
                    //                               .of(context)
                    //                               .size
                    //                               .height - 150,
                    //                         ),
                    //                         shape: RoundedRectangleBorder(
                    //                           borderRadius: BorderRadius
                    //                               .circular(10),),
                    //                         behavior: SnackBarBehavior
                    //                             .floating,
                    //                         content: Row(
                    //                           mainAxisAlignment: MainAxisAlignment
                    //                               .center,
                    //                           crossAxisAlignment: CrossAxisAlignment
                    //                               .center,
                    //                           children: [
                    //                             Image.asset(
                    //                               'assets/images/saved.png',
                    //                               width: 30,
                    //                               height: 30,),
                    //                             SizedBox(width: 15,),
                    //                             Text(
                    //                               'Parent deleted successfully'
                    //                                   .tr,
                    //                               style: const TextStyle(
                    //                                 color: Color(
                    //                                     0xFF4CAF50),
                    //                                 fontSize: 16,
                    //                                 fontFamily: 'Poppins-Bold',
                    //                                 fontWeight: FontWeight
                    //                                     .w700,
                    //                                 height: 1.23,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     );
                    //                   }
                    //                   showDialog(
                    //                     context: context,
                    //                     barrierDismissible: false,
                    //                     builder: (ctx) =>
                    //                         Dialog(
                    //                             backgroundColor: Colors
                    //                                 .white,
                    //                             surfaceTintColor: Colors
                    //                                 .transparent,
                    //                             // contentPadding: const EdgeInsets.all(20),
                    //                             shape: RoundedRectangleBorder(
                    //                               borderRadius: BorderRadius
                    //                                   .circular(
                    //                                 30,
                    //                               ),
                    //                             ),
                    //                             child: SizedBox(
                    //                               width: 304,
                    //                               height: 182,
                    //                               child: Padding(
                    //                                 padding: const EdgeInsets
                    //                                     .symmetric(
                    //                                     vertical: 10,
                    //                                     horizontal: 15),
                    //                                 child: Column(
                    //                                   crossAxisAlignment: CrossAxisAlignment
                    //                                       .center,
                    //                                   mainAxisAlignment: MainAxisAlignment
                    //                                       .center,
                    //                                   children: [
                    //                                     Row(
                    //                                       mainAxisAlignment: MainAxisAlignment
                    //                                           .start,
                    //                                       children: [
                    //                                         const SizedBox(
                    //                                           width: 8,
                    //                                         ),
                    //                                         Flexible(
                    //                                           child: Column(
                    //                                             children: [
                    //                                               GestureDetector(
                    //                                                 onTap: () =>
                    //                                                     Navigator
                    //                                                         .pop(
                    //                                                         context),
                    //                                                 child: Image
                    //                                                     .asset(
                    //                                                   'assets/images/Vertical container.png',
                    //                                                   width: 27,
                    //                                                   height: 27,
                    //                                                 ),
                    //                                               ),
                    //                                               const SizedBox(
                    //                                                 height: 25,
                    //                                               )
                    //                                             ],
                    //                                           ),
                    //                                         ),
                    //                                         Expanded(
                    //                                           flex: 3,
                    //                                           child: Text(
                    //                                             'Delete'
                    //                                                 .tr,
                    //                                             textAlign: TextAlign
                    //                                                 .center,
                    //                                             style: TextStyle(
                    //                                               color: Color(
                    //                                                   0xFF442B72),
                    //                                               fontSize: 18,
                    //                                               fontFamily: 'Poppins-SemiBold',
                    //                                               fontWeight: FontWeight
                    //                                                   .w600,
                    //                                               height: 1.23,
                    //                                             ),
                    //                                           ),
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                     Center(
                    //                                       child: Text(
                    //                                         'Are You Sure you want to \n'
                    //                                             'delete this parent ?'
                    //                                             .tr,
                    //                                         textAlign: TextAlign
                    //                                             .center,
                    //                                         style: TextStyle(
                    //                                           color: Color(
                    //                                               0xFF442B72),
                    //                                           fontSize: 16,
                    //                                           fontFamily: 'Poppins-Light',
                    //                                           fontWeight: FontWeight
                    //                                               .w400,
                    //                                           height: 1.23,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                     const SizedBox(
                    //                                       height: 15,
                    //                                     ),
                    //                                     Row(
                    //                                       mainAxisAlignment: MainAxisAlignment
                    //                                           .center,
                    //                                       children: [
                    //                                         SizedBox(
                    //                                           child: ElevatedSimpleButton(
                    //                                             txt: 'Delete'
                    //                                                 .tr,
                    //                                             width: 107,
                    //                                             hight: 38,
                    //                                             onPress: () async {
                    //                                               setState(() {
                    //                                                 _deleteSupervisorDocument(
                    //                                                     data[index]
                    //                                                         .id);
                    //                                               });
                    //                                               DeleteParentSnackBar(
                    //                                                   context,
                    //                                                   'message');
                    //                                               Navigator
                    //                                                   .pop(
                    //                                                   context);
                    //                                             },
                    //                                             color: const Color(
                    //                                                 0xFF442B72),
                    //                                             fontSize: 16,
                    //                                             fontFamily: 'Poppins-Regular',
                    //                                           ),
                    //                                         ),
                    //                                         // const Spacer(),
                    //                                         SizedBox(
                    //                                           width: 15,),
                    //                                         SizedBox(
                    //                                           width: 107,
                    //                                           height: 38,
                    //                                           child: ElevatedButton(
                    //                                             style: ElevatedButton
                    //                                                 .styleFrom(
                    //                                               backgroundColor: Colors
                    //                                                   .white,
                    //                                               surfaceTintColor: Colors
                    //                                                   .transparent,
                    //                                               shape: RoundedRectangleBorder(
                    //                                                   side: BorderSide(
                    //                                                     color: Color(
                    //                                                         0xFF442B72),
                    //                                                   ),
                    //                                                   borderRadius: BorderRadius
                    //                                                       .circular(
                    //                                                       10)
                    //                                               ),
                    //                                             ),
                    //                                             child: Text(
                    //                                                 'Cancel'
                    //                                                     .tr,
                    //                                                 textAlign: TextAlign
                    //                                                     .center,
                    //                                                 style: TextStyle(
                    //                                                     color: Color(
                    //                                                         0xFF442B72),
                    //                                                     fontFamily: 'Poppins-Regular',
                    //                                                     fontWeight: FontWeight
                    //                                                         .w500,
                    //                                                     fontSize: 16)
                    //                                             ),
                    //                                             onPressed: () {
                    //                                               Navigator
                    //                                                   .pop(
                    //                                                   context);
                    //                                             },
                    //                                           ),
                    //                                         ),
                    //
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                             )),
                    //                   );
                    //                 }
                    //               },
                    //               child: Image.asset(
                    //                 'assets/images/more.png',
                    //                 width: 20.8, height: 20.8,),),
                    //           ],
                    //         ),
                    //         SizedBox(height: 25,)],);
                    //   },
                    // ),
                  ),
                ),
              ],
            ),

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
                onPressed: ()
                async {
                  String busID = '';
                  DocumentSnapshot documentSnapshot = await _firestore
                      .collection('supervisor')
                      .doc(sharedpref!.getString('id'))
                      .get();
                  if (documentSnapshot.exists) {
                    busID = documentSnapshot.data().toString().contains('bus_id') ? documentSnapshot.get('bus_id') : '';
                  }
                  if (busID == '') {
                    // CantAddNewSupervisor(context) {
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
                            height: 210,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Alert'.tr,
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
                                      textAlign: TextAlign.center,
                                      'This supervisor hasn\'t been added to a bus yet.',
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
                                    height: 20,
                                  ),
                                  // ElevatedSimpleButton(
                                  //   txt: 'Go to parents'.tr,
                                  //   width: 157,
                                  //   hight: 38,
                                  //   onPress: () async {
                                  //     // await sharedpref!.setInt('invit', 0);
                                  //
                                  //     // await sharedpref!.setString('id', '');
                                  //     Navigator.of(context).pushAndRemoveUntil(
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>  ParentsView()),
                                  //             (Route<dynamic> route) => false);
                                  //   } ,
                                  //   color: const Color(0xFF442B72),
                                  //   fontSize: 16,
                                  //   fontFamily: 'Poppins-Regular',
                                  // ),
                                ],
                              ),
                            ),
                          )),
                    );
                  }
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('This supervisor hasn\'t been added to a bus yet.'),
                  // ));
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddParents()),
                    );
                  }
                },
                // {
                //   setState(() {
                //
                //   });
                //   print('object');
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => AddParents()));
                // },
                backgroundColor: Color(0xFF442B72),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),

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
                        )))))

    );
  }

}



// class _ParentsViewState extends State<ParentsView> {
//
//   _ParentsViewState();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   // int numberOfNames = 0; // declare the variable here
//   bool Accepted = false;
//   bool Declined = false;
//   bool Waiting = false;
//   String? selectedValueAccept;
//   String? selectedValueDecline;
//   String? selectedValueWaiting;
//   List<DropdownCheckboxItem> selectedItems = [];
//   int get dataLength => data.length;
//   List<QueryDocumentSnapshot> data = [];
//   bool isAcceptFiltered = false;
//   bool isDeclineFiltered = false;
//   bool isWaitingFiltered = false;
//   bool isFiltered  = false;
//   final _firestore = FirebaseFirestore.instance;
//   String? currentFilter;
//   TextEditingController _searchController = TextEditingController();
//   String SearchQuery = '';
//
//   String getJoinText(Timestamp joinDate) {
//     final now = DateTime.now();
//     final joinDateTime = joinDate.toDate();
//     final difference = now.difference(joinDateTime).inDays;
//
//     if (difference == 0) {
//       return 'Today';
//     } else if (difference == 1) {
//       return 'Yesterday';
//     } else if (difference < 7) {
//       return '${difference} days ago';
//     } else {
//       return '${joinDateTime.day}/${joinDateTime.month}/${joinDateTime.year}';
//     }
//   }
//
//
//    // DateTime? joinDate;
//
//   // String getJoinText(DateTime? joinDate) {
//   //   if (joinDate == null) {
//   //     return 'join date is not available';
//   //   }
//   //
//   //   final now = DateTime.now();
//   //   final difference = now.difference(joinDate).inDays;
//   //
//   //   if (difference == 0) {
//   //     return 'joined today';
//   //   } else if (difference == 1) {
//   //     return 'joined yesterday';
//   //   } else {
//   //     return 'joined $difference days ago';
//   //   }
//   // }
//
//
//
//
//   void _deleteSupervisorDocument(String documentId) {
//     FirebaseFirestore.instance
//         .collection('parent')
//         .doc(documentId)
//         .delete()
//         .then((_) {
//       setState(() {
//         // Update UI by removing the deleted document from the data list
//         data.removeWhere((document) => document.id == documentId);
//       });
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   showSnackBarFun(context),
//       //   // SnackBar(content: Text('Document deleted successfully')),
//       // );
//     })
//         .catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete document: $error')),
//       );
//     });
//   }
//
//   getDataForDeclinedFilter()async{
//     CollectionReference parent = FirebaseFirestore.instance.collection('parent');
//     QuerySnapshot parentData = await parent.where('state' , isEqualTo: 1).get();
//     // parentData.docs.forEach((element) {
//     //   data.add(element);
//     // }
//     // );
//     setState(() {
//       data = parentData.docs;
//       isFiltered = true;
//     });
//   }
//
//   getDataForWaitingFilter()async{
//     CollectionReference parent = FirebaseFirestore.instance.collection('parent');
//     QuerySnapshot parentData = await parent.where('state' , isEqualTo: 2).get();
//     // parentData.docs.forEach((element) {
//     //   data.add(element);
//     // }
//     // );
//     setState(() {
//       data = parentData.docs;
//       isFiltered = true;
//     });
//   }
//
//   getDataForAcceptFilter()async{
//     CollectionReference parent = FirebaseFirestore.instance.collection('parent');
//     QuerySnapshot parentData = await parent.where('state' , isEqualTo: 0 ).get();
//     // parentData.docs.forEach((element) {
//     //   data.add(element);
//     // }
//     // );
//     setState(() {
//       data = parentData.docs;
//       isFiltered = true;
//     });
//   }
//
//   // getData()async{
//   //   QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection('parent').get();
//   //   // data.addAll(querySnapshot.docs);
//   //   setState(() {
//   //     data = querySnapshot.docs;
//   //
//   //   });
//   // }
//
//   @override
//   void initState() {
//     _searchController.addListener(_onSearchChanged);
//     getData();
//     // getDataForAcceptFilter();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // _onSearchChanged() {
//   //   setState(() {
//   //     SearchQuery = _searchController.text.trim();
//   //   });
//   //   getData(query: SearchQuery);
//   // }
//
//   _onSearchChanged() {
//     setState(() {
//       SearchQuery = _searchController.text.trim();
//     });
//     getData(query: SearchQuery);
//   }
//
//
//   Future<void> getData({String query = ""}) async {
//     try {
//       String? supervisorId = sharedpref!.getString('id');
//       if (supervisorId == null) {
//         print('jessysupervisorId is null');
//         return;
//       }
//
//       print('jessysupervisorId: $supervisorId');
//       QuerySnapshot querySnapshot;
//
//       if (query.isEmpty) {
//         print('jessyQuery is empty, searching by supervisorId only');
//         querySnapshot = await FirebaseFirestore.instance.collection('parent')
//             .where('supervisor', isEqualTo: supervisorId)
//             .get();
//       } else {
//         print('jessySearching by supervisorId and name');
//         querySnapshot = await FirebaseFirestore.instance
//             .collection('parent')
//             .where('supervisor', isEqualTo: supervisorId)
//             .where('name', isGreaterThanOrEqualTo: query)
//             .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//             .get();
//       }
//
//       setState(() {
//         data = querySnapshot.docs;
//       });
//
//       print('jessyFetched ${querySnapshot.docs.length} documents');
//       for (var doc in querySnapshot.docs) {
//         print(doc.data());
//       }
//     } catch (e) {
//       print('jessyErrorl: $e');
//       setState(() {
//         // errorMessage = e.toString();
//       });
//     }
//   }
//   // Future<void> getData({String query = ""}) async {
//   //   try {
//   //     String? supervisorId = sharedpref!.getString('id');
//   //     QuerySnapshot querySnapshot;
//   //
//   //     if (query.isEmpty) {
//   //       print('ifdone');
//   //       querySnapshot = await FirebaseFirestore.instance.collection('parent')
//   //           .where('supervisor', isEqualTo: supervisorId)
//   //           .get();
//   //     } else {
//   //       print('elsedone');
//   //       querySnapshot = await FirebaseFirestore.instance
//   //           .collection('parent')
//   //           .where('name', isGreaterThanOrEqualTo: query)
//   //           .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//   //           .get();
//   //     }
//   //
//   //     setState(() {
//   //       data = querySnapshot.docs;
//   //     });
//   //
//   //     print('Fetched ${querySnapshot.docs.length} documents');
//   //   } catch (e) {
//   //     print('Errorggg: $e');
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // String getJoinText(dynamic joinDate) {
//     //   final now = DateTime.now();
//     //   late final DateTime joinDateTime;
//     //   if (joinDate is Timestamp) {
//     //     joinDateTime = joinDate.toDate();
//     //   } else if (joinDate is DateTime) {
//     //     joinDateTime = joinDate;
//     //   } else {
//     //     return 'Invalid date';
//     //   }
//     //
//     //   final difference = now.difference(joinDateTime).inDays;
//     //
//     //   if (difference == 0) {
//     //     return 'Today';
//     //   } else if (difference == 1) {
//     //     return 'Yesterday';
//     //   } else if (difference < 7) {
//     //     return '${difference} days ago';
//     //   } else {
//     //     return '${joinDateTime.day}/${joinDateTime.month}/${joinDateTime.year}';
//     //   }
//     // }
//
//     return Scaffold(
//         key: _scaffoldKey,
//         endDrawer: SupervisorDrawer(),
//         body: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Stack(
//             children: [
//
//               Column(
//                 children: [
//                   SizedBox(
//                     height: 35,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 17.0),
//                             child: Image.asset(
//                               (sharedpref?.getString('lang') == 'ar')
//                                   ? 'assets/images/Layer 1.png'
//                                   : 'assets/images/fi-rr-angle-left.png',
//                               width: 20,
//                               height: 22,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           'Parents'.tr,
//                           style: TextStyle(
//                             color: Color(0xFF993D9A),
//                             fontSize: 16,
//                             fontFamily: 'Poppins-Bold',
//                             fontWeight: FontWeight.w700,
//                             height: 1,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             _scaffoldKey.currentState!.openEndDrawer();
//                           },
//                           icon: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                             child: const Icon(
//                               Icons.menu_rounded,
//                               color: Color(0xff442B72),
//                               size: 35,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: 271,
//                                   height: 42,
//                                   child: TextField(
//                                     controller: _searchController,
//                                     onChanged: (value) {
//                                       _onSearchChanged();
//                                     },
//                                     decoration: InputDecoration(
//                                       filled: true,
//                                       fillColor: Color(0xffF1F1F1),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(21),
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       hintText: "Search Name".tr,
//                                       hintStyle: TextStyle(
//                                         color: const Color(0xffC2C2C2),
//                                         fontSize: 12,
//                                         fontFamily: 'Poppins-Bold',
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                       prefixIcon: Padding(
//                                         padding: (sharedpref?.getString('lang') ==
//                                             'ar')
//                                             ? EdgeInsets.only(
//                                             right: 6, top: 14.0, bottom: 9)
//                                             : EdgeInsets.only(
//                                             left: 3, top: 14.0, bottom: 9),
//                                         child: Image.asset(
//                                           'assets/images/Vector (12)search.png',
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // SizedBox(
//                                 //   width: 20
//                                 // ),
//                                 PopupMenuButton<String>(
//                                   child: Image(
//                                     image: AssetImage("assets/imgs/school/icons8_slider 2.png"),
//                                     width: 29,
//                                     height: 29,
//                                     color: Color(0xFF442B72), // Optionally, you can set the color of the image
//                                   ),
//
//                                   itemBuilder: (BuildContext context) {
//                                     return [
//                                       PopupMenuItem<String>(
//                                         value: 'custom',
//                                         child:
//                                         Column(
//                                           children: [
//                                             Container(
//                                               child:  DropdownRadiobutton(
//                                                 items: [
//                                                   DropdownCheckboxItem(label: 'Accepted'),
//                                                   DropdownCheckboxItem(label: 'Declined'),
//                                                   DropdownCheckboxItem(label: 'Waiting'),
//                                                 ],
//                                                 selectedItems: selectedItems,
//                                                 onSelectionChanged: (items) {
//                                                   setState(() {
//                                                     selectedItems = items;
//                                                     if (items.first.label == 'Accepted') {
//                                                       selectedValueAccept = 'Accepted';
//                                                       selectedValueDecline = null;
//                                                       selectedValueWaiting = null;
//                                                     } else if (items.first.label == 'Declined') {
//                                                       selectedValueAccept = null;
//                                                       selectedValueDecline = 'Declined';
//                                                       selectedValueWaiting = null;
//                                                     } else if (items.first.label == 'Waiting') {
//                                                       selectedValueAccept = null;
//                                                       selectedValueDecline = null;
//                                                       selectedValueWaiting = 'Waiting';
//                                                     }
//                                                   });
//                                                 },
//                                               ),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 SizedBox(
//                                                   width:100,
//                                                   child: ElevatedButton(
//
//                                                     onPressed: () {
//                                                       // Handle cancel action
//                                                       Navigator.pop(context);
//                                                     },
//                                                     style: ButtonStyle(
//                                                       backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF442B72)),
//                                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                         RoundedRectangleBorder(
//                                                           borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     child: GestureDetector(
//                                                       child: Text('Apply',style: TextStyle(fontSize:18),),
//                                                       onTap: (){
//                                                         if (selectedValueAccept != null) {
//                                                           currentFilter = 'Accepted';
//                                                           getDataForAcceptFilter();
//                                                           Navigator.pop(context);
//                                                           print('0');
//                                                         }else  if (selectedValueDecline != null) {
//                                                           currentFilter = 'Declined';
//                                                           getDataForDeclinedFilter();
//                                                           Navigator.pop(context);
//                                                           print('1');
//                                                         }else  if (selectedValueWaiting != null) {
//                                                           currentFilter = 'Waiting';
//                                                           getDataForWaitingFilter();
//                                                           Navigator.pop(context);
//                                                           print('2');
//                                                         }
//                                                       },),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 3,),
//                                                 GestureDetector(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.all(5.0),
//                                                     child: Text("Reset",style: TextStyle(color: Color(0xFF442B72),fontSize: 20),),
//                                                   ), onTap: (){
//                                                   Navigator.pop(context);
//                                                 },
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ];
//                                   },
//
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 28.0),
//                             child:
//                             ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: data.length,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 final joinDate = DateTime.now();
//                                 // String state = 'waiting';
//
//                                 // if (data[index]['supervisor'] == sharedpref!.getString('id').toString())
//                                   // numberOfNames = data.where((element) => element['supervisor'] == sharedpref!.getString('id').toString()).length;
//                                     {
//                                       print('objectjj');
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                 const EdgeInsets.only(
//                                                     top: 12.0),
//                                                 child: FutureBuilder(
//                                                   future: _firestore.collection(
//                                                       'supervisor').doc(
//                                                       sharedpref!.getString(
//                                                           'id')).get(),
//                                                   builder: (
//                                                       BuildContext context,
//                                                       AsyncSnapshot<
//                                                           DocumentSnapshot<Map<
//                                                               String,
//                                                               dynamic>>> snapshot) {
//                                                     if (snapshot.hasError) {
//                                                       return Text(
//                                                           'Something went wrong');
//                                                     }
//
//                                                     if (snapshot
//                                                         .connectionState ==
//                                                         ConnectionState.done) {
//                                                       if (!snapshot.hasData ||
//                                                           snapshot.data ==
//                                                               null ||
//                                                           snapshot.data!
//                                                               .data() == null ||
//                                                           snapshot.data!
//                                                               .data()!['busphoto'] ==
//                                                               null || snapshot
//                                                           .data!
//                                                           .data()!['busphoto']
//                                                           .toString()
//                                                           .trim()
//                                                           .isEmpty) {
//                                                         return CircleAvatar(
//                                                           radius: 25,
//                                                           backgroundColor: Color(
//                                                               0xff442B72),
//                                                           child: CircleAvatar(
//                                                             backgroundImage: AssetImage(
//                                                                 'assets/images/Group 237679 (2).png'),
//                                                             // Replace with your default image path
//                                                             radius: 25,
//                                                           ),
//                                                         );
//                                                       }
//
//                                                       Map<String,
//                                                           dynamic>? data = snapshot
//                                                           .data?.data();
//                                                       if (data != null &&
//                                                           data['busphoto'] !=
//                                                               null) {
//                                                         return CircleAvatar(
//                                                           radius: 25,
//                                                           backgroundColor: Color(
//                                                               0xff442B72),
//                                                           child: CircleAvatar(
//                                                             backgroundImage: NetworkImage(
//                                                                 '${data['busphoto']}'),
//                                                             radius: 25,
//                                                           ),
//                                                         );
//                                                       }
//                                                     }
//
//                                                     return Container();
//                                                   },
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 5,
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment: MainAxisAlignment
//                                                     .start,
//                                                 crossAxisAlignment: CrossAxisAlignment
//                                                     .start,
//
//                                                 children: [
//                                                   Text('${data[index]['name'] ??
//                                                       '' }',
//                                                     style: TextStyle(
//                                                       color: Color(0xFF442B72),
//                                                       fontSize: 17,
//                                                       fontFamily: 'Poppins-SemiBold',
//                                                       fontWeight: FontWeight
//                                                           .w600,
//                                                       height: 1.07,
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Padding(
//                                                     padding: (sharedpref
//                                                         ?.getString('lang') ==
//                                                         'ar')
//                                                         ? EdgeInsets.only(
//                                                         right: 3.0)
//                                                         : EdgeInsets.all(0.0),
//                                                     child:
//                                                     Text(
//                                                       // state == 'waiting'
//                                                       // ? 'Waiting'
//                                                       //     :
//                                                       'Joined ${getJoinText(
//                                                           data[index]['joinDate'] ??
//                                                               DateTime.now())}',
//                                                       style: TextStyle(
//                                                         color: Color(0xFF0E8113).withOpacity(0.7),
//                                                         fontSize: 13,
//                                                         fontFamily: 'Poppins-Regular',
//                                                         fontWeight: FontWeight
//                                                             .w400,
//                                                         height: 1.23,
//                                                       ),),
//                                                     // Text(
//                                                     //   'Joined ${getJoinText(data[index]['joinDate'] ?? DateTime.now())}',
//                                                     //  // '${data[index]['joinDate']}',
//                                                     //
//                                                     //   style: TextStyle(
//                                                     //     color: Color(0xFF0E8113),
//                                                     //     fontSize: 13,
//                                                     //     fontFamily: 'Poppins-Regular',
//                                                     //     fontWeight: FontWeight.w400,
//                                                     //     height: 1.23,),),
//                                                   ),
//                                                 ],),
//                                               // SizedBox(width: 103,),
//                                             ],),
//                                           PopupMenuButton<String>(
//                                             padding: EdgeInsets.zero,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(6)),
//                                             ),
//                                             constraints: BoxConstraints
//                                                 .tightFor(
//                                                 width: 111, height: 100),
//                                             color: Colors.white,
//                                             surfaceTintColor: Colors
//                                                 .transparent,
//                                             offset: Offset(0, 30),
//                                             itemBuilder: (
//                                                 BuildContext context) =>
//                                             <PopupMenuEntry<String>>[
//                                               PopupMenuItem<String>(
//                                                 value: 'item1',
//                                                 child: Row(
//                                                   children: [
//                                                     Image.asset(
//                                                       (sharedpref?.getString(
//                                                           'lang') == 'ar')
//                                                           ? 'assets/images/edittt_white_translate.png'
//                                                           : 'assets/images/edittt_white.png',
//                                                       width: 12.81,
//                                                       height: 12.76,),
//                                                     SizedBox(width: 7,),
//                                                     Text('Edit'.tr,
//                                                       style: TextStyle(
//                                                         fontFamily: 'Poppins-Light',
//                                                         fontWeight: FontWeight
//                                                             .w400,
//                                                         fontSize: 17,
//                                                         color: Color(
//                                                             0xFF432B72),),),
//                                                   ],),),
//                                               PopupMenuItem<String>(
//                                                   value: 'item2', child: Row(
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/delete.png',
//                                                     width: 12.77,
//                                                     height: 13.81,),
//                                                   SizedBox(width: 7,),
//                                                   Text('Delete'.tr,
//                                                       style: TextStyle(
//                                                         fontFamily: 'Poppins-Light',
//                                                         fontWeight: FontWeight
//                                                             .w400,
//                                                         fontSize: 15,
//                                                         color: Color(
//                                                             0xFF432B72),)),
//                                                 ],)),
//                                             ],
//                                             onSelected: (String value) {
//                                               if (value == 'item1') {
//                                                 Navigator.push(context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           EditAddParents(
//                                                             docid: data[index]
//                                                                 .id,
//                                                             oldNumber: data[index]
//                                                                 .get(
//                                                                 'phoneNumber'),
//                                                             oldName: data[index]
//                                                                 .get('name'),
//                                                             oldNumberOfChildren: data[index]
//                                                                 .get(
//                                                                 'numberOfChildren')
//                                                                 .toString(),
//                                                             oldType: data[index]
//                                                                 .get(
//                                                                 'typeOfParent'),
//                                                             oldNameOfChild: 'test',
//                                                             oldGradeOfChild: 'test',
//                                                             // oldNameOfChild: data[index].childrenData[index]['grade'],
//                                                             // oldGradeOfChild: ['l;']
//                                                             // oldGradeOfChild: data[index]['childern'].get('grade'),
//                                                           )),);
//                                               } else if (value == 'item2') {
//                                                 void DeleteParentSnackBar(
//                                                     context, String message,
//                                                     {Duration? duration}) {
//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(
//                                                     SnackBar(
//                                                       dismissDirection: DismissDirection
//                                                           .up,
//                                                       duration: duration ??
//                                                           const Duration(
//                                                               milliseconds: 1000),
//                                                       backgroundColor: Colors
//                                                           .white,
//                                                       margin: EdgeInsets.only(
//                                                         bottom: MediaQuery
//                                                             .of(context)
//                                                             .size
//                                                             .height - 150,
//                                                       ),
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius: BorderRadius
//                                                             .circular(10),),
//                                                       behavior: SnackBarBehavior
//                                                           .floating,
//                                                       content: Row(
//                                                         mainAxisAlignment: MainAxisAlignment
//                                                             .center,
//                                                         crossAxisAlignment: CrossAxisAlignment
//                                                             .center,
//                                                         children: [
//                                                           Image.asset(
//                                                             'assets/images/saved.png',
//                                                             width: 30,
//                                                             height: 30,),
//                                                           SizedBox(width: 15,),
//                                                           Text(
//                                                             'Parent deleted successfully'
//                                                                 .tr,
//                                                             style: const TextStyle(
//                                                               color: Color(
//                                                                   0xFF4CAF50),
//                                                               fontSize: 16,
//                                                               fontFamily: 'Poppins-Bold',
//                                                               fontWeight: FontWeight
//                                                                   .w700,
//                                                               height: 1.23,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }
//                                                 showDialog(
//                                                   context: context,
//                                                   barrierDismissible: false,
//                                                   builder: (ctx) =>
//                                                       Dialog(
//                                                           backgroundColor: Colors
//                                                               .white,
//                                                           surfaceTintColor: Colors
//                                                               .transparent,
//                                                           // contentPadding: const EdgeInsets.all(20),
//                                                           shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius
//                                                                 .circular(
//                                                               30,
//                                                             ),
//                                                           ),
//                                                           child: SizedBox(
//                                                             width: 304,
//                                                             height: 182,
//                                                             child: Padding(
//                                                               padding: const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 10,
//                                                                   horizontal: 15),
//                                                               child: Column(
//                                                                 crossAxisAlignment: CrossAxisAlignment
//                                                                     .center,
//                                                                 mainAxisAlignment: MainAxisAlignment
//                                                                     .center,
//                                                                 children: [
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment
//                                                                         .start,
//                                                                     children: [
//                                                                       const SizedBox(
//                                                                         width: 8,
//                                                                       ),
//                                                                       Flexible(
//                                                                         child: Column(
//                                                                           children: [
//                                                                             GestureDetector(
//                                                                               onTap: () =>
//                                                                                   Navigator
//                                                                                       .pop(
//                                                                                       context),
//                                                                               child: Image
//                                                                                   .asset(
//                                                                                 'assets/images/Vertical container.png',
//                                                                                 width: 27,
//                                                                                 height: 27,
//                                                                               ),
//                                                                             ),
//                                                                             const SizedBox(
//                                                                               height: 25,
//                                                                             )
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       Expanded(
//                                                                         flex: 3,
//                                                                         child: Text(
//                                                                           'Delete'
//                                                                               .tr,
//                                                                           textAlign: TextAlign
//                                                                               .center,
//                                                                           style: TextStyle(
//                                                                             color: Color(
//                                                                                 0xFF442B72),
//                                                                             fontSize: 18,
//                                                                             fontFamily: 'Poppins-SemiBold',
//                                                                             fontWeight: FontWeight
//                                                                                 .w600,
//                                                                             height: 1.23,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   Center(
//                                                                     child: Text(
//                                                                       'Are You Sure you want to \n'
//                                                                           'delete this parent ?'
//                                                                           .tr,
//                                                                       textAlign: TextAlign
//                                                                           .center,
//                                                                       style: TextStyle(
//                                                                         color: Color(
//                                                                             0xFF442B72),
//                                                                         fontSize: 16,
//                                                                         fontFamily: 'Poppins-Light',
//                                                                         fontWeight: FontWeight
//                                                                             .w400,
//                                                                         height: 1.23,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   const SizedBox(
//                                                                     height: 15,
//                                                                   ),
//                                                                   Row(
//                                                                     mainAxisAlignment: MainAxisAlignment
//                                                                         .center,
//                                                                     children: [
//                                                                       SizedBox(
//                                                                         child: ElevatedSimpleButton(
//                                                                           txt: 'Delete'
//                                                                               .tr,
//                                                                           width: 107,
//                                                                           hight: 38,
//                                                                           onPress: () async {
//                                                                             setState(() {
//                                                                               _deleteSupervisorDocument(
//                                                                                   data[index]
//                                                                                       .id);
//                                                                             });
//                                                                             DeleteParentSnackBar(
//                                                                                 context,
//                                                                                 'message');
//                                                                             Navigator
//                                                                                 .pop(
//                                                                                 context);
//                                                                           },
//                                                                           color: const Color(
//                                                                               0xFF442B72),
//                                                                           fontSize: 16,
//                                                                           fontFamily: 'Poppins-Regular',
//                                                                         ),
//                                                                       ),
//                                                                       // const Spacer(),
//                                                                       SizedBox(
//                                                                         width: 15,),
//                                                                       SizedBox(
//                                                                         width: 107,
//                                                                         height: 38,
//                                                                         child: ElevatedButton(
//                                                                           style: ElevatedButton
//                                                                               .styleFrom(
//                                                                             backgroundColor: Colors
//                                                                                 .white,
//                                                                             surfaceTintColor: Colors
//                                                                                 .transparent,
//                                                                             shape: RoundedRectangleBorder(
//                                                                                 side: BorderSide(
//                                                                                   color: Color(
//                                                                                       0xFF442B72),
//                                                                                 ),
//                                                                                 borderRadius: BorderRadius
//                                                                                     .circular(
//                                                                                     10)
//                                                                             ),
//                                                                           ),
//                                                                           child: Text(
//                                                                               'Cancel'
//                                                                                   .tr,
//                                                                               textAlign: TextAlign
//                                                                                   .center,
//                                                                               style: TextStyle(
//                                                                                   color: Color(
//                                                                                       0xFF442B72),
//                                                                                   fontFamily: 'Poppins-Regular',
//                                                                                   fontWeight: FontWeight
//                                                                                       .w500,
//                                                                                   fontSize: 16)
//                                                                           ),
//                                                                           onPressed: () {
//                                                                             Navigator
//                                                                                 .pop(
//                                                                                 context);
//                                                                           },
//                                                                         ),
//                                                                       ),
//
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           )),
//                                                 );
//                                               }
//                                             },
//                                             child: Image.asset(
//                                               'assets/images/more.png',
//                                               width: 20.8, height: 20.8,),),
//                                         ],
//                                       ),
//                                       SizedBox(height: 25,)],);
//                                 }
//
//                                 },),
//                           ),
//                           SizedBox(height: 44,)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               (sharedpref?.getString('lang') == 'ar')
//                   ? Positioned(
//                 bottom: 20,
//                 left: 25,
//                 child: FloatingActionButton(
//                   shape: const CircleBorder(),
//                   onPressed: () {
//                     print('object');
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AddParents()));
//                   },
//                   backgroundColor: Color(0xFF442B72),
//                   child: Icon(
//                     Icons.add,
//                     color: Colors.white,
//                     size: 35,
//                   ),
//                 ),
//               )
//                   : Positioned(
//                 bottom: 20,
//                 right: 25,
//                 child: FloatingActionButton(
//                   shape: const CircleBorder(),
//                   onPressed: () {
//                     setState(() {
//
//                     });
//                     print('object');
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => AddParents()));
//                   },
//                   backgroundColor: Color(0xFF442B72),
//                   child: Icon(
//                     Icons.add,
//                     color: Colors.white,
//                     size: 35,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // extendBody: true,
//         resizeToAvoidBottomInset: false,
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         floatingActionButton: FloatingActionButton(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100)),
//             backgroundColor: Color(0xff442B72),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => ProfileSupervisorScreen(
//                     // onTapMenu: onTapMenu
//                   )));
//             },
//             child: Image.asset(
//               'assets/images/174237 1.png',
//               height: 33,
//               width: 33,
//               fit: BoxFit.cover,
//             )),
//         bottomNavigationBar: Directionality(
//             textDirection: Get.locale == Locale('ar')
//                 ? TextDirection.rtl
//                 : TextDirection.ltr,
//             child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(25),
//                   topRight: Radius.circular(25),
//                 ),
//                 child: BottomAppBar(
//                     padding: EdgeInsets.symmetric(vertical: 3),
//                     height: 60,
//                     color: const Color(0xFF442B72),
//                     clipBehavior: Clip.antiAlias,
//                     shape: const AutomaticNotchedShape(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(38.5),
//                                 topRight: Radius.circular(38.5))),
//                         RoundedRectangleBorder(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(50)))),
//                     notchMargin: 7,
//                     child: SizedBox(
//                         height: 10,
//                         child: SingleChildScrollView(
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               HomeForSupervisor( )),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(top: 7, right: 15)
//                                       : EdgeInsets.only(left: 15),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (7).png',
//                                           height: 20,
//                                           width: 20),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Home".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AttendanceSupervisorScreen()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(top: 9, left: 50)
//                                       : EdgeInsets.only(right: 50, top: 2),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/icons8_checklist_1 1.png',
//                                           height: 19,
//                                           width: 19),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Attendance".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               NotificationsSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(
//                                       top: 12, bottom: 4, right: 10)
//                                       : EdgeInsets.only(
//                                       top: 8, bottom: 4, left: 20),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (2).png',
//                                           height: 17,
//                                           width: 16.2),
//                                       Image.asset(
//                                           'assets/images/Vector (5).png',
//                                           height: 4,
//                                           width: 6),
//                                       SizedBox(height: 2),
//                                       Text(
//                                         "Notifications".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               TrackSupervisor()),
//                                     );
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   (sharedpref?.getString('lang') == 'ar')
//                                       ? EdgeInsets.only(
//                                       top: 10,
//                                       bottom: 2,
//                                       right: 10,
//                                       left: 0)
//                                       : EdgeInsets.only(
//                                       top: 8,
//                                       bottom: 2,
//                                       left: 0,
//                                       right: 10),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                           'assets/images/Vector (4).png',
//                                           height: 18.36,
//                                           width: 23.5),
//                                       SizedBox(height: 3),
//                                       Text(
//                                         "Buses".tr,
//                                         style: TextStyle(
//                                           fontFamily: 'Poppins-Regular',
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: 8,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ))))));
//   }
// }