

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Services/loginservice.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bus{

  Future<List<BusModel>> fetchdata() async {
    try {
      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('bus').get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = await snapshot.docs;
      List<BusModel> busdata = [];
      if (queryDocumentSnapshot.isEmpty || queryDocumentSnapshot == [{0}]) {}
      else {
        
        for (QueryDocumentSnapshot items in queryDocumentSnapshot) {
          if (items.exists) {
            // busdata.add(jsonEncode(items.data().toString()));
            busdata.add(BusModel.fromJson(items.data() as Map<String, dynamic>));
          }
          // busdata[items.id] = jsonEncode(items.data());
        }
      }
      return await busdata;
    }on FirebaseException catch(e){
      return [];
    }
  }

  Future<String> adddata(int busno, String userid, String password) async{
    try{

      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      bool check = false;
      await firestore.doc('bus/${userid}').get().then((value) {
        print('data '+value.toString());
        value.exists ? check = true : check = false;
        print('check : ${check}');
        // print(check);
      }
      );

      if(check == false){
        Map<String, dynamic> data = {
          'busno' : busno,
          'userid' : userid,
          'password' : password.toString(),
        };
        BusModel.fromJson(data);
        await firestore.collection('bus').doc(userid).set(data);
        return 'Added';
      }
      else{
        return "Already";
      }



    }on FirebaseException catch(e){
      return e.code;
    }
    catch(e){
      return '${e.toString()}';
    }
  }

  Future<BusModel> fetchsbusdata(String userid) async {
    print(userid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot studentdoc = await firestore.collection('bus').doc(userid).get();
    BusModel data = await BusModel.fromJson(studentdoc.data() as Map<String,dynamic>);
    return data;
  }

  Future<GeoPoint> startsharingloc(String busid)async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Location location = Location();
    LocationData locationData= await location.getLocation();

    GeoPoint cordinates =GeoPoint(locationData.latitude!, locationData.longitude!);
    Map<String,dynamic> data = {
      'location' : cordinates,
    };
    await firestore.collection('bus').doc(busid).update(data);
    return cordinates;

  }

  Future<GeoPoint> stopsharingloc(String busid, GeoPoint lochistory)async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Map<String,dynamic> data = {
      'location' : lochistory,
    };
    await firestore.collection('bus').doc(busid).update(data);
    return lochistory;

  }

  Future<GeoPoint> getlocation(String busid) async {
    BusModel busModel = await fetchsbusdata(busid);
    if(busModel.location != null) {
      GeoPoint location = await busModel.location!;
      return location;
    }
    else{
      return GeoPoint(0, 0);
    }
  }

}

