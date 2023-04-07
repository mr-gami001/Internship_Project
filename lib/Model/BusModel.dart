

import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel{
  int? busno;
  String? userid;
  String? password;
  GeoPoint? location;


  BusModel(
      this.busno,
      this.userid,
      this.password,
      this.location,
      );

  factory BusModel.fromJson(json){
    return BusModel(json['busno'],json['userid'],json['password'],json['location']);
  }

  toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['busno'] = this.busno;
    json['userid'] = this.userid;
    json['password'] = this.password;
    json['location'] = this.location;
  }
}