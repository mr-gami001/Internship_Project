import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> loginservice(String collname, String userid, String Pass) async {

  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var users = await firestore.collection(collname).doc(userid).get();
    if(users.data() != null){
    Map<String, dynamic>? data = await users.data();
    if (data!['userid'] == userid && data['password'] == Pass) {
      print("okay");
      print('pass: ${data['password'] } + pass : ${Pass}');
      return 'okay';
    }
    else {
      print('No Match!! ${data}');
      return 'No Match Found';
    }
    }
    else{
      return "UserId Not Found";
    }
    // print(users.data());
  }
  catch(e){
    return e.toString();
  }

}


Future<String> institutelog(String email,String pass) async {


  // FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
  // UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
  // print(credential.toString());
  // return credential;

  try{
    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
    var credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);
    print(credential.toString());
    return 'okay';

  }on FirebaseAuthException catch(e){
    print(e.code);
    return 'Firebase Error : ${e.code}';
  }catch(e){
    print(e.toString());
    return "Error ${e.toString()}";

  }

}

Future<void> logout() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  await firebaseAuth.signOut();
}

Future<String> Forgetpass(String email)async{
  try {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.sendPasswordResetEmail(email: email);
    return 'okay';
  }on FirebaseAuthException catch(e){
    return e.code;
  }
  catch(e){
    return e.toString();
  }
}

Future<Map<String , dynamic>> cheking ()async {
  SharedPreferences logindata = await SharedPreferences.getInstance();
  if(logindata.containsKey('userdata')){
    String temp =await logindata.getString('userdata')!;
    Map<String, dynamic> data =jsonDecode(temp);
    print("************$data");
    return data;
  }
  else{
    Map<String, dynamic> data = {};
    return data;
  }
}