import 'dart:io';
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
import 'package:school_account/Functions/functions.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/components/reciver_message_item.dart';
import 'package:school_account/supervisor_parent/components/sender_message_item.dart';
import 'package:school_account/supervisor_parent/components/user_online.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController msgText = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String? currentUserID = sharedpref?.getString('id'); // replace with actual user email
  String previousSender = '';
  UserStatusService _userStatusService = UserStatusService();
  bool sending = true;
  final ScrollController _scrollController = ScrollController();
  FlutterSoundRecorder? _recorder;
  // final String? currentUserEmail = sharedpref?.getString('id'); // replace with actual user email
  String? _audioPath;
  File? _selectedImage;
  String? imageUrl;
  File? file;
  List<Widget> allMessages = [];
  bool _isRecording = false;
  String? _recordingPath;
  late Record audioRecord;
  final recorder = FlutterSoundRecorder();

  Future record() async {
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    await recorder.stopRecorder();
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path);
    });

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child('name');

    try {
      await referenceImageToUpload.putFile(File(returnedImage.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');
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

  @override
  void initState() {
    super.initState();
    initRecorder();
    WidgetsBinding.instance!.addObserver(this);
    _userStatusService.setOnline();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _userStatusService.setOffline();
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != Permission.microphone.isGranted) {
      throw 'mic permission not granted';
    }
    await recorder.openRecorder();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _userStatusService.setOffline();
    } else if (state == AppLifecycleState.resumed) {
      _userStatusService.setOnline();
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
        child: AppBar(
          toolbarHeight: 90,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16.49),
            ),
          ),
          elevation: 0.0,
          leading: GestureDetector(
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
          actions: [
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
          title: Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Ellipse 1.png',
                  height: 50,
                  width: 50,
                ),
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
                        'online',
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
          ),
          backgroundColor: Color(0xffF8F8F8),
          surfaceTintColor: Colors.transparent,
        ),
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
                        if ((responseMessages[i].get('sender') == currentUserID && responseMessages[i].get('receiver') == widget.receiverId) || (responseMessages[i].get('sender') == widget.receiverId &&  responseMessages[i].get('receiver') == currentUserID)) {

                          String txt = responseMessages[i].get('txt');
                          String sender = responseMessages[i].get('sender');
                          allMessages.add(
                            sender == currentUserID
                                ? SenderMessageItem(
                              messageContent: txt,
                              time: responseMessages[i].get('time').toString(),
                              key: ValueKey(responseMessages[i].get('time')),
                            )
                                : ReciverMessageItem(
                              messageContent: txt,
                              time: responseMessages[i].get('time').toString(),
                              key: ValueKey(responseMessages[i].get('time')),

                            ),
                          );
                          if (i > 0) {
                            previousSender = responseMessages[i - 1].get('sender');
                          }
                        }}
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: false,
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
            ),
            Container(
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
                                    GestureDetector(
                                      onTap: () async {
                                        if (_recorder?.isRecording ?? false) {
                                          await stop();
                                        } else {
                                          await record();
                                        }
                                      },
                                      child: Icon(
                                        _recorder?.isRecording ?? false
                                            ? Icons.stop
                                            : Icons.mic,
                                        size: 24,
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