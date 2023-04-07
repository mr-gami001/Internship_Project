

import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyNotificationModel{

  String? title;
  String? discription;
  Timestamp? time;

  EmergencyNotificationModel(
     this.title,
     this.discription,
     this.time,
      );

  factory EmergencyNotificationModel.fromJson(json){
    return EmergencyNotificationModel(
        json['title'],
        json['discription'],
        json['time']
    );
  }

  toJson(){
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['title'] = this.title;
    json['discription'] = this.discription;
    json['time'] = this.time;

  }
}