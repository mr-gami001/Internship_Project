import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/Services/notificationservices.dart';
import 'package:let_me_check/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/StudentModel.dart';

class home_Student extends StatefulWidget {
  const home_Student({Key? key}) : super(key: key);

  @override
  State<home_Student> createState() => _home_StudentState();
}

class _home_StudentState extends State<home_Student> {

  Student _student = Student();
  NotificationServices _notificationServices = NotificationServices();

  @override
  void didChangeDependencies() async{
    var studentuserid = ModalRoute.of(context)?.settings.arguments;
    StudentModel studentModel = await _student.fetchstudentdata(studentuserid.toString());
    FirebaseMessaging.instance.subscribeToTopic(studentModel.busno.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var studentuserid = ModalRoute.of(context)?.settings.arguments;

          return Scaffold(

            drawer: Drawer(
              child: FutureBuilder(
                future: _student.fetchstudentdata(studentuserid.toString()),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView(
                      children: [

                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: ClipOval(child: Image.network('https://picsum.photos/250',alignment: Alignment.center,filterQuality: FilterQuality.high,)),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(10,10,10,0),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text("Name : "+snapshot.data!.name.toString(),style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(10,10,10,0),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text("User Id : "+snapshot.data!.userid.toString(),style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.fromLTRB(10,10,10,0),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text("Bus No. : "+snapshot.data!.busno.toString(),style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.center,),
                          ),
                        ),
                        
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: ElevatedButton(
                            child: Text("Log Out"),
                            onPressed: ()async {
                              SharedPreferences user = await SharedPreferences.getInstance();
                              await user.clear();
                              await Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                            },
                          ),
                        ),

                      ],
                    );
                  }

                  else{
                    return Center(child: CircularProgressIndicator(),);
                  }

                },
              ),
            ),

            appBar: AppBar(
              centerTitle: true,
              title: Text('Student Dashboard'),
            ),

            body: Center(
              child: Column(
                children: [

                  ElevatedButton(
                    onPressed: ()async{
                      StudentModel studentModel = await _student.fetchstudentdata(studentuserid.toString());
                      print("${studentModel.userid}  ${studentModel.name}");
                    },
                    child: Text('data'),
                  ),

                  ElevatedButton(onPressed: ()async{
                    String token = await _notificationServices.firebasetoken();
                    print(token);
                  }, child: Text("Message token"))

                ],
              ),
            ),

          );
  }
}

