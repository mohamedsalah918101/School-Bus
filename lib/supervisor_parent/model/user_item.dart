import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:school_account/main.dart';
import 'package:school_account/supervisor_parent/components/reciver_message_item.dart';
import 'package:school_account/supervisor_parent/components/sender_message_item.dart';
import 'package:school_account/supervisor_parent/model/chat_message_model.dart';
import 'package:school_account/supervisor_parent/model/final_chat_model.dart';

// class UserItem extends StatefulWidget{
//   const UserItem({Key? key, required this.user});
//
//   final ChatModel user;
//
//   @override
//   State<UserItem> createState() => _UserItemState();
// }
//
// class _UserItemState extends State<UserItem>{
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100, // Provide a height
//       width: double.infinity,  // Provide a width
//       child: ListTile(
//           leading: CircleAvatar(
//             radius: 30,
//             backgroundImage: NetworkImage(
//               widget.user.image,
//             ),
//           )
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Chat extends StatefulWidget{
  @override
  State<Chat> createState() {
    return ChatState();
  }
}
class ChatState extends State<Chat>{

  TextEditingController msgText = TextEditingController();


  var _auth = FirebaseAuth.instance;
  var _fireStore = FirebaseFirestore.instance;
  String perevious = " ";

  @override
  Widget build(BuildContext context) {
    if(_auth.currentUser !=null){
      print("object");
    }
    // addMsg();
    return Scaffold(
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
      body: Column(
        children: [
             // List<ChatMessage> messages = [
             //    ChatMessage(messageContent: "I’m waiting Bus", messageType: "sender"),
             //    ChatMessage(messageContent: "On my way", messageType: "receiver"),
             //    ChatMessage(
             //        messageContent: "Hi Aya are you arrive to me at 7 AM?",
             //        messageType: "receiver"),
             //    ChatMessage(
             //        messageContent: "Of course, we arrive on time please be Ready",
             //        messageType: "sender"),
             //    ChatMessage(
             //        messageContent: "Hey, Shady is Ready ", messageType: "sender"),
             //  ];
          StreamBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> messages = []; // Initialize an empty list of widgets
                var responseMessages = snapshot.data!.docs;
                for (int i = 0; i < responseMessages.length; i++) {
                  String txt = responseMessages[i].get('txt');
                  String sender = responseMessages[i].get('sender');
                  Timestamp time = responseMessages[i].get('time');

                  DateTime dateTime = time.toDate();
                  String formattedTime = "${dateTime.hour}:${dateTime.minute}";


                  // Check if the sender is the current user
                  if (sender == _auth.currentUser!.email) {
                    // If sender is the current user, add a SenderMessageItem
                    messages.add(SenderMessageItem(
                      messageContent: txt,
                      time: formattedTime,
                    ));
                  } else {
                    // If sender is someone else, add a ReciverMessageItem
                    messages.add(ReciverMessageItem(
                      messageContent: txt,
                      time: formattedTime,
                    ));
                  }

                  // Add a SizedBox between messages
                  messages.add(SizedBox(height: 15));
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.only(left: 24.0,bottom: 5, right:24 , top: 5),
                    children: messages, // Add the list of messages here
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(), // Or any loading indicator
                );
              }
            },
            stream: _fireStore.collection("msg").orderBy("time").snapshots(),
          ),

          // StreamBuilder<QuerySnapshot>(
          //   builder: (context,snapshot){
          //     if (snapshot.hasData){
          //       List <MessageWidgett> AllMsg = [];
          //       var responceMessage = snapshot.data!.docs;
          //       for( int i = 0 ; i <responceMessage.length ;i++)
          //       {
          //         String txt = responceMessage[i].get('txt');
          //         // String sender = responceMessage[i].get('sender');
          //         AllMsg.add(MessageWidgett(Sender:responceMessage[i].get('sender'),Msg: txt, Previous : perevious));
          //         if(i > 0){
          //           perevious = responceMessage[i-1].get('sender');
          //         }
          //       }
          //
          //       return Expanded(
          //           // child: ListView(
          //           //   reverse: true,
          //           //   children: AllMsg,
          //           // )
          //         child: ListView.separated(
          //           itemCount: messages.length,
          //           shrinkWrap: true,
          //           padding: const EdgeInsets.only(top: 10, bottom: 10),
          //           physics: const NeverScrollableScrollPhysics(),
          //           itemBuilder: (context, index) {
          //             return messages[index].messageType == "receiver"
          //                 ? ReciverMessageItem(
          //               messageContent: messages[index].messageContent,
          //               time: '18.29',
          //             )
          //                 : SenderMessageItem(
          //               messageContent: messages[index].messageContent,
          //               time: '18.29',
          //             );
          //           },
          //           separatorBuilder: (BuildContext context, int index) {
          //             return SizedBox(
          //               height:15,
          //             );
          //           },
          //         ),
          //       );}
          //     else{
          //       return Center(
          //         child:Text(
          //          ' color: Colors.blue',
          //         ),
          //       );
          //     }
          //   }, stream: _fireStore.collection("msg").orderBy("time").snapshots(), ),
          Row(
            children: [
              // SizedBox(width: 10,),
              Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                    child: TextFormField(
                      controller: msgText,
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
              TextButton(
                onPressed: (){
                  _fireStore.collection("msg").add({
                    "sender": _auth.currentUser!.email,
                    "txt" : msgText.text.toString(),
                    "time" : DateTime.now(),
                  });
                  msgText.clear();
                }, child: Icon(
                Icons.send ,
                size: 30,),
              ) ,
            ],) ,
          SizedBox(height: 10,)
        ],),
    );

  }
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

// class ChatService {
//   final CollectionReference _messagesCollection =
//   FirebaseFirestore.instance.collection('messages');
//
//   Stream<QuerySnapshot> get messages {
//     return _messagesCollection.orderBy('timestamp').snapshots();
//   }
//
//   Future<void> addMessage(String messageContent, String messageType) async {
//     await _messagesCollection.add({
//       'content': messageContent,
//       'type': messageType,
//       'timestamp': Timestamp.now(),
//     });
//   }
// }