

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/institute/student.dart';

class Parents{

  Future<String> addparentsdata(String name , String userid ,String studentuserid, String password) async{

    try {
      bool check = false;
      print(studentuserid);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      DocumentReference student = firebaseFirestore.collection('student').doc(studentuserid);
      await firebaseFirestore.doc('student/${studentuserid}').get().then((value) {
        print('data '+value.toString());
        value.exists ? check = true : check = false;
        print('check : ${check}');
        // print(check);
      }
      );


      if(check == true){
        CollectionReference collection = firebaseFirestore.collection('parents');
        Map<String, dynamic> data = {
          'name' : name,
          'userid':userid,
          'studentuserid':studentuserid,
          'password':password.toString(),
        };
        ParentsModel.fromJson(data);
        await collection.doc(userid).set(data);
        return 'added';
      }
      else if(check == false){
        return 'student not found';
      }
      else{
        return 'null';
      }


    }catch(e){
      return e.toString();
    }

  }

  Future<String> Updatestudentdata(String name , String userid ,String studentuserid, String password) async{

    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference collection = firebaseFirestore.collection('student');
      Map<String, dynamic> data = {
        'name' : name,
        'userid':userid,
        'studentuserid':studentuserid,
        'password':password.toString(),
      };
      StudentModel.fromJson(data);
      await collection.doc(userid).update(data);
      return 'Added';
    }catch(e){
      print("Error : "+e.toString());
      return e.toString();
    }

  }

  Future<List<ParentsModel>> fetchAllParentsdata() async {
    try {
      FirebaseFirestore firestore = await FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('parents').get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = await snapshot.docs;
      List<ParentsModel> studentdata = [];
      if (queryDocumentSnapshot.isEmpty || queryDocumentSnapshot == [{0}]) {}
      else {

        for (QueryDocumentSnapshot items in queryDocumentSnapshot) {
          if (items.exists) {
            // busdata.add(jsonEncode(items.data().toString()));
            studentdata.add(ParentsModel.fromJson(items.data() as Map<String,dynamic>));
          }
          // busdata[items.id] = jsonEncode(items.data());
        }
      }
      return await studentdata;
    }on FirebaseException catch(e){
      return [];
    }
  }

  Future<ParentsModel> fetchparentsdata(String userid) async {
    print(userid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot studentdoc = await firestore.collection('parents').doc(userid).get();
    ParentsModel data = await ParentsModel.fromJson(studentdoc.data() as Map<String,dynamic>);
    return data;
  }

  Future<GeoPoint>  fetchstudentlocation(String userid) async{
      Student student = await Student();
      Bus bus = await Bus();
      ParentsModel parentsModel = await fetchparentsdata(userid);
      StudentModel busid = await student.fetchstudentdata(parentsModel.studentuserid!);
      BusModel busModel = await bus.fetchsbusdata(busid.busno.toString());
      return busModel.location!;
  }

}