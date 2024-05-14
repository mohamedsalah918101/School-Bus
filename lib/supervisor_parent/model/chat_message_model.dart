import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}



class  MessageWidgett extends StatelessWidget{

  String? Sender , Msg , Previous;
  MessageWidgett({this.Sender , this.Msg , this.Previous});
  var _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(20),
          color: Sender == _auth.currentUser!.email? Colors.blue : Colors.pink ,
          child: Text(Msg!),
        ),
        (Previous!=Sender)?Padding(padding: EdgeInsets.all(10),
          child:Text(Sender!) ,):Container()

      ],
    );
  }

}
