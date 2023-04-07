
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:let_me_check/Model/NotificationModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/notificationservices.dart';

class Bus_breakdown{

  Future upload_breakdown_message(String userid, String title, String desc)async{
    // print(Timestamp.now());
    DateTime temp = DateTime.now();
    NotificationServices notificationServices = NotificationServices();


    print(temp);
    String formetdata = DateFormat("yyyy-MM-dd HH:mm:ss").format(temp);
    print(formetdata);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String, dynamic> breakmsg = {
      'title' : title,
      'discription' : desc,
      'time' : DateTime.tryParse(formetdata),
    };
    await firestore.collection('bus').doc(userid).collection('notifications').doc(formetdata).set(breakmsg);
    
  }

  Future<List<EmergencyNotificationModel>> getnotifications(String busid)async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<EmergencyNotificationModel> data = [];
    QuerySnapshot buscoll = await firestore.doc('bus/$busid').collection('notifications').get();
    for (var items in buscoll.docs){
     data.add(
       EmergencyNotificationModel.fromJson(items.data())
     );
    }
    return data;
  }

}