import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/Parents.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/Services/loginservice.dart';
import 'package:let_me_check/Services/notificationservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Helper/Theme_Helper.dart';
import '../../Model/NotificationModel.dart';
import '../../bloc/bus_bloc/notification_history.dart';

class home_Parents extends StatefulWidget {
  const home_Parents({Key? key}) : super(key: key);

  @override
  State<home_Parents> createState() => _home_ParentsState();
}

class _home_ParentsState extends State<home_Parents> {
  Parents _parents = Parents();
  Student _student = Student();
  late StudentModel studentModel;
  String? parentsuserid;
  String? topic;
  SharedPreferences? logindata;

  NotificationServices notificationServices = NotificationServices();
  String? busno;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificaionHistoryBloc notificaionHistoryBloc = NotificaionHistoryBloc();

//this is use for shared preferences
  Future<void> rememberme() async {
    notificationServices.initializeNotification();
    logindata = await SharedPreferences.getInstance();
    Map<String, dynamic> data = await cheking();
    print("############" + data.toString());

    setState(() {
      parentsuserid = data['userid'].toString();
    });

    ParentsModel parentsModel = await _parents.fetchparentsdata(parentsuserid!);
    studentModel = await _student.fetchstudentdata(parentsModel.studentuserid!);

    busno = studentModel.busno.toString();
    await _firebaseMessaging.subscribeToTopic(busno!);
    notificaionHistoryBloc.add(InitialEvent(busno!));
  }

  @override
  void initState() {
    super.initState();

    rememberme();

    //requesting permission if permission is denied
    _firebaseMessaging.requestPermission();

    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message!.data['screen'] != null) {
        Navigator.of(context).pushNamed(message.data['screen']);
      } else {
        print('null screen defined');
      }
    });

    //onscreen notification services
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await notificationServices.showNotification(
          message, message.data['screen']);
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] != null) {
        Navigator.of(context).pushNamed(message.data['screen']);
      } else {
        print('null screen defined');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool isdark = (Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: _parents.fetchparentsdata(parentsuserid.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipOval(
                          child: Image.network(
                        'https://picsum.photos/250',
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      )),
                    ),
                  ),
                  Divider(
                    color: isdark ? Colors.white54 : Colors.black54,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10,10,10,0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  ListTile(
                      title: Text("Change_Theme".tr(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900)),
                      leading: isdark ? Icon(Icons.dark_mode_rounded,) : Icon(Icons.light_mode,color: Colors.black,),
                      onTap: (){currentTheme.toggleTheme();
                      },
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          'https://img.icons8.com/ios-filled/30/000000/name.png',
                          color: isdark ? Colors.white : Colors.black),
                      title: Text(
                        "Name_:_".tr() + snapshot.data!.name.toString(),
                        style: TextStyle(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          'https://img.icons8.com/material-sharp/30/000000/user-male-circle.png',
                          color: isdark ? Colors.white : Colors.black),
                      title: Text(
                        "User_Id_:_".tr() + snapshot.data!.userid.toString(),
                        style: TextStyle(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          'https://img.icons8.com/material-sharp/30/000000/id-verified.png',
                          color: isdark ? Colors.white : Colors.black),
                      title: Text(
                        "Student_User_Id_:_".tr() +
                            snapshot.data!.studentuserid.toString(),
                        style: TextStyle(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                          'https://img.icons8.com/ios-glyphs/30/000000/marker--v1.png',
                          color: isdark ? Colors.white : Colors.black),
                      title: Text(
                        "Track_location".tr(),
                        style: TextStyle(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () async {
                        StudentModel studentmodel =
                            await _student.fetchstudentdata(
                                snapshot.data!.studentuserid.toString());
                        Navigator.pushNamed(context, '/tracklocation',
                            arguments: studentmodel.busno);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(10, height * 0.27, 10, 0),
                    child: ListTile(
                      title: Text(
                        "Log_Out".tr(),
                        textAlign: TextAlign.center,
                      ),
                      leading: Icon(
                        Icons.logout,
                        color: isdark ? Colors.white : Colors.black,
                      ),
                      onTap: () async {
                        await logindata!.clear();
                        await FirebaseMessaging.instance.unsubscribeFromTopic(
                            studentModel.busno.toString());
                        await Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home_Parents").tr(),
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         currentTheme.toggleTheme();
        //       },
        //       icon: isdark
        //           ? Icon(Icons.dark_mode_rounded)
        //           : Icon(Icons.light_mode))
        // ],

        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context)=>[

              PopupMenuItem(
                  child: PopupMenuButton(
                      position: PopupMenuPosition.under,
                    child: ListTile(
                      title: Text("Language",style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.020),),
                      trailing: Icon(Icons.arrow_forward_ios_sharp),
                    ),
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                      child: Text("English"),
                      onTap: (){
                        context.setLocale(Locale("en","US"));
                      },
                    ),

                    PopupMenuItem(
                      child: Text("Hindi"),
                      onTap: (){
                        context.setLocale(Locale("hi","IN"));
                      },
                    ),

                    PopupMenuItem(
                      child: Text("Gujarati"),
                      onTap: (){
                        context.setLocale(Locale("gu","IN"));
                      },
                    ),


                  ]
              ))
            ],
          )
        ],
      ),
      body: BlocBuilder(
        bloc: notificaionHistoryBloc,
        builder: (context, state) {
          if (state is InitialState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataGainedState) {
            return ListView(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Bus_History".tr(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.black26),
                    ),
                  ),
                ),
                for (EmergencyNotificationModel notification in state.datamodel)
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                    child: ListTile(
                      title: Text(notification.title.toString()).tr(),
                      subtitle: Text(notification.discription.toString()),
                      trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('dd-MM')
                                .format(notification.time!.toDate())),
                            Text(DateFormat('HH-mm a')
                                .format(notification.time!.toDate())),
                          ]),
                    ),
                  )
              ],
            );
          } else if (state is DataLossState) {
            return Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
