import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';

class Student{

  Future<String> addstudentdata(String name , String userid , int busno) async{

    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference collection = firebaseFirestore.collection('student');

      bool check = false;
      await firebaseFirestore.doc('student/${userid}').get().then((value) {
        value.exists ? check = true : check = false ;
        // print(value);
      });
      if(check == true){
        return 'Already';
      }
      else {
        Map<String, dynamic> data = {
          'name': name,
          'busno': busno,
          'userid': userid,
        };
        StudentModel.fromJson(data);
        await collection.doc(userid).set(data);
        return 'Added';
      }
    }catch(e){
      print("Error : "+e.toString());
      return e.toString();
    }

  }


  Future<String> Updatestudentdata(String name , String userid , int busno) async{

    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference collection = firebaseFirestore.collection('student');
      Map<String, dynamic> data = {
         'name': name,
         'busno': busno,
         'userid': userid,
      };
      StudentModel.fromJson(data);
      await collection.doc(userid).update(data);
      return 'Added';
    }catch(e){
      print("Error : "+e.toString());
      return e.toString();
    }

  }

  Future<List<StudentModel>> fetchallstudentsdata() async {
    try {
      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('student').get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = await snapshot.docs;
      List<StudentModel> studentdata = [];
      if (queryDocumentSnapshot.isEmpty || queryDocumentSnapshot == [{0}]) {}
      else {

        for (QueryDocumentSnapshot items in queryDocumentSnapshot) {
          if (items.exists) {
            // busdata.add(jsonEncode(items.data().toString()));
            studentdata.add(StudentModel.fromJson(items.data() as Map<String,dynamic>));
          }
          // busdata[items.id] = jsonEncode(items.data());
        }
      }
      return await studentdata;
    }on FirebaseException catch(e){
      return [];
    }
  }

  Future<List<BusModel>> fetchbusdata() async {
    try {
      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('bus').get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = await snapshot.docs;
      List<BusModel> studentdata = [];
      if (queryDocumentSnapshot.isEmpty || queryDocumentSnapshot == [{0}]) {}
      else {

        for (QueryDocumentSnapshot items in queryDocumentSnapshot) {
          if (items.exists) {
            // busdata.add(jsonEncode(items.data().toString()));
            studentdata.add(BusModel.fromJson(items.data() as Map<String, dynamic>));
          }
          // busdata[items.id] = jsonEncode(items.data());
        }
      }
      return await studentdata;
    }on FirebaseException catch(e){
      return [];
    }
  }

  Future<StudentModel> fetchstudentdata(String userid) async {
    print(userid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot studentdoc = await firestore.collection('student').doc(userid).get();
    StudentModel data = await StudentModel.fromJson(studentdoc.data() as Map<String,dynamic>);
    return data;
  }


}
