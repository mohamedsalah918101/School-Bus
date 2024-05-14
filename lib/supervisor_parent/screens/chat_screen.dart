import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_account/main.dart';
import '../model/chat_message_model.dart';
import '../components/reciver_message_item.dart';
import '../components/sender_message_item.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // FocusNode inputNode = FocusNode();
  // final FocusNode _focusNode = FocusNode();
  // bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    List<ChatMessage> messages = [
      ChatMessage(messageContent: "I’m waiting Bus", messageType: "sender"),
      ChatMessage(messageContent: "On my way", messageType: "receiver"),
      ChatMessage(
          messageContent: "Hi Aya are you arrive to me at 7 AM?",
          messageType: "receiver"),
      ChatMessage(
          messageContent: "Of course, we arrive on time please be Ready",
          messageType: "sender"),
      ChatMessage(
          messageContent: "Hey, Shady is Ready ", messageType: "sender"),
    ];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFFFFFF),
      appBar:PreferredSize(
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color:  Color(0x3F000000),
              blurRadius: 12,
              offset: Offset(-1, 4),
              spreadRadius: 0,
            )
          ]),
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
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Image.asset(
                  (sharedpref?.getString('lang') == 'ar')?
                  'assets/images/Layer 1.png':
                  'assets/images/fi-rr-angle-left.png',
                  width: 20,
                  height: 22,),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Image.asset(
                  'assets/images/Call.png',
                  height: 24,
                  width: 24,
                ),
              ),
            ],
            title: Row(
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
                        'Aya Essam'.tr,
                        style: TextStyle(
                          color: Color(0xFF181818),
                          fontSize: 14.70,
                          fontFamily: 'Poppins-SemiBold',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Online'.tr,
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
            backgroundColor:  Color(0xffF8F8F8),
            surfaceTintColor: Colors.transparent,
          ),
        ),
        preferredSize: Size.fromHeight(90),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 24.0,bottom: 5, right:24 , top: 5),
              child: ListView.separated(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return messages[index].messageType == "receiver"
                      ? ReciverMessageItem(
                    messageContent: messages[index].messageContent,
                    time: '18.29',
                  )
                      : SenderMessageItem(
                    messageContent: messages[index].messageContent,
                    time: '18.29',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height:15,
                  );
                },
              ),
            ),
            // bottomNavigationBar:
            Container(
              color: Colors.transparent,
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                            child: TextFormField(
                              onTap: (){
                              },
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  counterText: "",
                                  fillColor: Color(0xffF8F8F8),
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(20.0),
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
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // added line
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/Camera.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Image.asset(
                                          'assets/images/Voice.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),


                          )),
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
        ));
  }

  OutlineInputBorder myFocusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.5)),
        borderSide: BorderSide(
          color: Color(0xFFF8F8F8),
          width: 0.5,
        ));
  }
// void openKeyboard () {
//   FocusScope.of(context).requestFocus(inputNode);
// }
} // below is custom color class