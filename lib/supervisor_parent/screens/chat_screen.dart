import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
//import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:school_account/Functions/functions.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/components/reciver_message_item.dart';
import 'package:school_account/supervisor_parent/components/sender_message_item.dart';
import 'package:school_account/supervisor_parent/components/user_online.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';




class ChatScreen extends StatefulWidget {
  final String receiverName;
  final String receiverPhone;
  final String receiverId;

  ChatScreen({
    required this.receiverPhone,
    required this.receiverName,
    required this.receiverId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  // File? _selectedImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController msgText = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String? currentUserID = sharedpref?.getString('id'); // replace with actual user email
  String previousSender = '';
  final _firestore = FirebaseFirestore.instance;
  UserStatusService _userStatusService = UserStatusService();
  bool sending = true;
  final ScrollController _scrollController = ScrollController();
 // late StreamSubscription<InternetConnectionStatus> _internetConnectionSubscription;
  String _connectionStatus = ' ';

  FlutterSoundRecorder? _recorder;
  // FlutterSoundPlayer _player = FlutterSoundPlayer();

  // final String? currentUserEmail = sharedpref?.getString('id'); // replace with actual user email
  File? _selectedImage;
  String? imageUrl;
  File? file;
  List<Widget> allMessages = [];
  // bool _isRecording = false;
  // String? _recordingPath;
  // late Record audioRecord;
  // final recorder = FlutterSoundRecorder();
  final record = AudioRecorder();
  String path = '';
  String url = '';
  bool is_record = false;
  bool isPlayerInitialized = false;
  late FlutterSoundPlayer _player;
  bool _isOnline = false;

  // Start_Record()async{
  //   final location = await getApplicationDocumentsDirectory(); //path for recored to storge in it
  //   String name= Uuid().v1();
  //   if(await record.hasPermission() ){
  //     await record.start(RecordConfig(), path: location.path+name+'m4a');
  //     setState(() {
  //       is_record = true;
  //     });
  //   }
  //   print('startRecord');
  // }
  Start_Record() async {
    final location = await getApplicationDocumentsDirectory(); //path for record to store in it
    String name = Uuid().v1();
    if (await record.hasPermission()) {
      await record.start(RecordConfig(), path: '${location.path}/$name.m4a');
      setState(() {
        is_record = true;
      });
      print('startRecord');
    }
  }
  Stop_Record() async {
    String? final_path = await record.stop();
    setState(() {
      path = final_path!;
      is_record = false;
    });
    print('stopRecord');
    print('Recorded file path: $path');
    String recordedFilePath = '/data/user/0/com.example.school_account/app_flutter/db71a3a0-2594-11ef-85a8-53d54d066252.m4a';

    // استدعاء دالة رفع الملف
    await upload(path);
  }
  Future<void> upload(String path) async {
    print('Upload started');

    if (path.isEmpty) {
      print('Error: Path is empty');
      return;
    }

    File file = File(path);
    if (!await file.exists()) {
      print('Error: File does not exist at path: $path');
      return;
    }

    try {
      final ref = FirebaseStorage.instance.ref('voice/${basename(path)}');
      final uploadTask = ref.putFile(file);

      // Monitor the upload status
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, onError: (e) {
        print('Error during upload: $e');
      });

      // Await the upload completion
      await uploadTask.whenComplete(() => null);
      final downloadUrl = await ref.getDownloadURL();
      print('Uploaded successfully. File URL: $downloadUrl');

      // Store the download URL in Firestore
      String formattedTime =DateFormat(' HH:mm:ss').format(DateTime.now());
      _fireStore.collection("msg").add({
        "sender": currentUserID,
        "receiver": widget.receiverId,
        "txt": msgText.text.toString(), // يمكن استخدام نص فارغ أو رسالة تشير إلى وجود ملف صوتي
        "voiceUrl": downloadUrl,
        "time": formattedTime,
      });

    } catch (e) {
      print('Error uploading file: $e');
    }
  }
  // Future<void> upload(String path) async {
  //   print('Upload started');
  //
  //   if (path.isEmpty) {
  //     print('Error: Path is empty');
  //     return;
  //   }
  //
  //   File file = File(path);
  //   if (!await file.exists()) {
  //     print('Error: File does not exist at path: $path');
  //     return;
  //   }
  //
  //   try {
  //     final ref = FirebaseStorage.instance.ref('voice/${basename(path)}');
  //     final uploadTask = ref.putFile(file);
  //
  //     // Monitor the upload status
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  //     }, onError: (e) {
  //       print('Error during upload: $e');
  //     });
  //
  //     // Await the upload completion
  //     await uploadTask.whenComplete(() => null);
  //     final downloadUrl = await ref.getDownloadURL();
  //     print('Uploaded successfully. File URL: $downloadUrl');
  //
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  // }
  // File? _selectedImage;
  // String? imageUrl;

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(basename(returnedImage.path));

    try {
      await referenceImageToUpload.putFile(File(returnedImage.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');

      String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
      _fireStore.collection("msg").add({
        "sender": currentUserID,
        "receiver": widget.receiverId,
        "txt": "",
        "imageUrl": imageUrl,
        "time": formattedTime,
      });

    } catch (error) {
      print('Error uploading image: $error');
    }
  }
  void _makePhoneCall() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(widget.receiverPhone);
    if (!res!) {
      print("Failed to make the call");
    }
  }

  Future<void> initPlayer() async {
    await _player.openPlayer();
    setState(() {
      isPlayerInitialized = true;
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isOnline = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    initPlayer();
    _player = FlutterSoundPlayer();
    // _player.openAudioSession();
    // initRecorder();
    WidgetsBinding.instance!.addObserver(this);
    _userStatusService.setOnline();
    // _internetConnectionSubscription = InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
    //   if (status == InternetConnectionStatus.connected) {
    //     setState(() {
    //       _connectionStatus = 'Online';
    //     });
    //   } else {
    //     setState(() {
    //       _connectionStatus = 'Offline';
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    if (widget.receiverId == currentUserID) {
      _userStatusService.setOffline();
      setState(() {
        _connectionStatus = 'Offline';
      });
    }
    WidgetsBinding.instance!.removeObserver(this);
    // _internetConnectionSubscription.cancel();
    super.dispose();
  }

  void playRecordedAudio() async {
    await _player.startPlayer(fromURI: path);
  }

  // Future initRecorder() async {
  //   final status = await Permission.microphone.request();
  //   if (status != Permission.microphone.isGranted) {
  //     throw 'mic permission not granted';
  //   }
  //   // await recorder.openRecorder();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (widget.receiverId == currentUserID) {
        _userStatusService.setOnline();
        setState(() {
          _connectionStatus = 'Online';
        });
      }
    } else if (state == AppLifecycleState.paused) {
      if (widget.receiverId == currentUserID) {
        _userStatusService.setOffline();
        setState(() {
          _connectionStatus = 'Offline';
        });
      }
    }
  }
  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SizedBox(
          height: 110,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                    GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Image.asset(
                            (sharedpref?.getString('lang') == 'ar')
                                ? 'assets/images/Layer 1.png'
                                : 'assets/images/fi-rr-angle-left.png',
                            width: 20,
                            height: 22,
                          ),
                        ),
                      ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       CircleAvatar(
                       radius: 25,
                       backgroundColor: Color(0xff442B72),
                       child: CircleAvatar(
                         backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                         radius: 25,
                       ),
                     ),
                        // FutureBuilder(
                        //   future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
                        //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                        //     if (snapshot.hasError) {
                        //       return Text('Something went wrong');
                        //     }
                        //
                        //     if (snapshot.connectionState == ConnectionState.done) {
                        //       if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
                        //         return CircleAvatar(
                        //           radius: 25,
                        //           backgroundColor: Color(0xff442B72),
                        //           child: CircleAvatar(
                        //             backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
                        //             radius: 25,
                        //           ),
                        //         );
                        //       }
                        //
                        //       Map<String, dynamic>? data = snapshot.data?.data();
                        //       if (data != null && data['busphoto'] != null) {
                        //         return CircleAvatar(
                        //           radius: 25,
                        //           backgroundColor: Color(0xff442B72),
                        //           child: CircleAvatar(
                        //             backgroundImage: NetworkImage('${data['busphoto']}'),
                        //             radius:25,
                        //           ),
                        //         );
                        //       }
                        //     }
                        //
                        //     return Container();
                        //   },
                        // ),
                        const SizedBox(
                          width: 20,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.receiverName,
                                style: TextStyle(
                                  color: Color(0xFF181818),
                                  fontSize: 14.70,
                                  fontFamily: 'Poppins-SemiBold',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _isOnline ? 'online' : 'offline',
                                  // _connectionStatus,
                                // 'online',
                                style: TextStyle(
                                  color: Color(0xFF771F98),
                                  fontSize: 12.86,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _makePhoneCall();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Image.asset(
                        'assets/images/Call.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        // AppBar(
        //   toolbarHeight: 90,
        //   centerTitle: true,
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(
        //       bottom: Radius.circular(16.49),
        //     ),
        //   ),
        //   elevation: 0.0,
        //   leading: GestureDetector(
        //     onTap: () => Navigator.of(context).pop(),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 17.0),
        //       child: Image.asset(
        //         (sharedpref?.getString('lang') == 'ar')
        //             ? 'assets/images/Layer 1.png'
        //             : 'assets/images/fi-rr-angle-left.png',
        //         width: 20,
        //         height: 22,
        //       ),
        //     ),
        //   ),
        //   actions: [
        //     GestureDetector(
        //       onTap: () {
        //         _makePhoneCall();
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 25.0),
        //         child: Image.asset(
        //           'assets/images/Call.png',
        //           height: 24,
        //           width: 24,
        //         ),
        //       ),
        //     ),
        //   ],
        //   title: Padding(
        //     padding: const EdgeInsets.only(right: 0.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         FutureBuilder(
        //           future: _firestore.collection('supervisor').doc(sharedpref!.getString('id')).get(),
        //           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        //             if (snapshot.hasError) {
        //               return Text('Something went wrong');
        //             }
        //
        //             if (snapshot.connectionState == ConnectionState.done) {
        //               if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null || snapshot.data!.data()!['busphoto'] == null || snapshot.data!.data()!['busphoto'].toString().trim().isEmpty) {
        //                 return CircleAvatar(
        //                   radius: 25,
        //                   backgroundColor: Color(0xff442B72),
        //                   child: CircleAvatar(
        //                     backgroundImage: AssetImage('assets/images/Group 237679 (2).png'), // Replace with your default image path
        //                     radius: 25,
        //                   ),
        //                 );
        //               }
        //
        //               Map<String, dynamic>? data = snapshot.data?.data();
        //               if (data != null && data['busphoto'] != null) {
        //                 return CircleAvatar(
        //                   radius: 25,
        //                   backgroundColor: Color(0xff442B72),
        //                   child: CircleAvatar(
        //                     backgroundImage: NetworkImage('${data['busphoto']}'),
        //                     radius:25,
        //                   ),
        //                 );
        //               }
        //             }
        //
        //             return Container();
        //           },
        //         ),
        //         const SizedBox(
        //           width: 20,
        //         ),
        //         SingleChildScrollView(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 widget.receiverName,
        //                 style: TextStyle(
        //                   color: Color(0xFF181818),
        //                   fontSize: 14.70,
        //                   fontFamily: 'Poppins-SemiBold',
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //               Text(
        //                 _isOnline ? 'online' : 'offline',
        //                   // _connectionStatus,
        //                 // 'online',
        //                 style: TextStyle(
        //                   color: Color(0xFF771F98),
        //                   fontSize: 12.86,
        //                   fontFamily: 'Poppins-Light',
        //                   fontWeight: FontWeight.w400,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        //   backgroundColor: Color(0xffF8F8F8),
        //   surfaceTintColor: Colors.transparent,
        // ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, bottom: 5, right: 24, top: 5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fireStore.collection("msg")
                      .orderBy("time")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      List<Widget> allMessages = [];
                      var responseMessages = snapshot.data!.docs;

                      for (var i = 0; i < responseMessages.length; i++) {
                        if ((responseMessages[i].get('sender') == currentUserID && responseMessages[i].get('receiver') == widget.receiverId) || (responseMessages[i].get('sender') == widget.receiverId && responseMessages[i].get('receiver') == currentUserID)) {
                          String txt = responseMessages[i].get('txt');
                          String sender = responseMessages[i].get('sender');
                          Map<String, dynamic> data = responseMessages[i].data() as Map<String, dynamic>;
                          String? voiceUrl = data.containsKey('voiceUrl') ? data['voiceUrl'] : null;
                          String time = responseMessages[i].get('time');

                          var messageWidget = (sender == currentUserID)
                              ? SenderMessageItem(messageContent: txt, time: time, voice: voiceUrl, isSeen: true,image: responseMessages[i].data().toString().contains('imageUrl') ?  responseMessages[i].get('imageUrl'):'',
                          )
                              : ReciverMessageItem(messageContent: txt, time: time, );
                          allMessages.add(messageWidget);
                        }
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: false, // عكس ترتيب القائمة لتظهر من الأسفل إلى الأعلى
                        shrinkWrap: true,
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          return allMessages[index];
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            )
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 24.0, bottom: 5, right: 24, top: 5),
            //     child: StreamBuilder<QuerySnapshot>(
            //       stream: _fireStore.collection("msg")
            //           .orderBy("time")
            //           .snapshots(),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           WidgetsBinding.instance!.addPostFrameCallback((_) {
            //             _scrollToBottom();
            //           });
            //           List<Widget> allMessages = [];
            //           var responseMessages = snapshot.data!.docs;
            //           for (var i = 0; i < responseMessages.length; i++) {
            //             if ((responseMessages[i].get('sender') == currentUserID && responseMessages[i].get('receiver') == widget.receiverId) || (responseMessages[i].get('sender') == widget.receiverId &&  responseMessages[i].get('receiver') == currentUserID)) {
            //
            //               String txt = responseMessages[i].get('txt');
            //               String sender = responseMessages[i].get('sender');
            //               Map<String, dynamic> data = responseMessages[i].data() as Map<String, dynamic>;
            //               String? voiceUrl = data.containsKey('voiceUrl') ? data['voiceUrl'] : null;
            //               String time = responseMessages[i].get('time');
            //
            //               var messageWidget = (sender == currentUserID)
            //                   ? SenderMessageItem(messageContent: txt, time: time, voice: voiceUrl)
            //                   : ReciverMessageItem(messageContent: txt, time: time, voice: voiceUrl!);
            //               allMessages.add(messageWidget);
            //
            //               // allMessages.add(
            //               //   sender == currentUserID
            //               //       ? SenderMessageItem(
            //               //     messageContent: txt,
            //               //     time: responseMessages[i].get('time').toString(),
            //               //     key: ValueKey(responseMessages[i].get('time')), voice: url,
            //               //   )
            //               //       : ReciverMessageItem(
            //               //     messageContent: txt,
            //               //     time: responseMessages[i].get('time').toString(),
            //               //     key: ValueKey(responseMessages[i].get('time')),
            //               //
            //               //   ),
            //               // );
            //               if (i > 0) {
            //                 previousSender = responseMessages[i - 1].get('sender');
            //               }
            //             }}
            //           return ListView.builder(
            //             controller: _scrollController,
            //             reverse: false,
            //             shrinkWrap: true,
            //             itemCount: allMessages.length,
            //             itemBuilder: (context, index) {
            //               return allMessages[index];
            //             },
            //           );
            //         } else {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         }
            //       },
            //     ),
            //   ),
            // ),
            ,Container(
              color: Colors.transparent,
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                sending = value.isEmpty;
                              });
                            },
                            controller: msgText,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              counterText: "",
                              fillColor: Color(0xffF8F8F8),
                              filled: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              hintText: 'Type here...'.tr,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              hintStyle: const TextStyle(
                                color: Color(0xFF8D8D8D),
                                fontSize: 15.58,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.w400,
                                height: 1.29,
                                letterSpacing: -0.37,
                              ),
                              enabledBorder: myInputBorder(),
                              focusedBorder: myFocusBorder(),
                              suffixIcon: sending == false
                                  ? SizedBox.shrink()
                                  : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: _pickImageFromGallery,
                                      child: Image.asset(
                                        'assets/images/Camera.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    // if (_selectedImage != null)
                                    //   Image.file(
                                    //     _selectedImage!,
                                    //     width: 100,
                                    //     height: 100,
                                    //   ),
                                    GestureDetector(
                                      onTap: () async {
                                        if(!is_record){
                                          Start_Record();
                                        }
                                        else Stop_Record();
                                        // if (_recorder?.isRecording ?? false) {
                                        //   await stop();
                                        // } else {
                                        //   await recordd();
                                        // }
                                      },
                                      child: Icon(
                                        is_record
                                        // _recorder?.isRecording ?? false
                                            ? Icons.stop
                                            : Icons.mic,
                                        size: 24,
                                        color: Color(0xFF8D8D8D),
                                      ),
                                    ),
                                    SizedBox(width: 14),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      sending
                          ? Container()
                          : TextButton(
                        onPressed: msgText.text.isEmpty ? null : () {
                          setState(() {
                            sending = true;
                          });
                          String formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
                          _fireStore.collection("msg").add({
                            "sender": currentUserID,
                            "receiver": widget.receiverId,
                            "txt": msgText.text.toString(),
                            "time": formattedTime,
                          });
                          //sendNotification("","");
                          msgText.clear();
                        },
                        child: Icon(
                          Icons.send,
                          color: Color(0xFF771F98),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder myInputBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.5)),
      borderSide: BorderSide(
        color: Color(0xFFF8F8F8),
        width: 0.5,
      ),
    );
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.5)),
      borderSide: BorderSide(
        color: Color(0xFFF8F8F8),
        width: 0.5,
      ),
    );
  }
}