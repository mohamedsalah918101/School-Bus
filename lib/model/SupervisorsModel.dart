import 'package:flutter/cupertino.dart';

class SupervisorsModel{
  String? id;
  String? name;
  String? phone;
  String? bus_id;
  String? lat='0';
  String? lang='0';


  SupervisorsModel({this.id, this.name,this.phone,this.bus_id,this.lat,required this.lang});
}