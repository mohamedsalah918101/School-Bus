import 'package:flutter/cupertino.dart';

import 'SupervisorsModel.dart';

class ParentModel{
  String? child_name;
  String? class_name;
  String? bus_number;
  String? image;
  List<SupervisorsModel>? supervisors;

  ParentModel({this.child_name, this.class_name,this.bus_number,this.supervisors,this.image});
}