import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Helper/Theme_Helper.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Services/notificationservices.dart';
import 'package:let_me_check/bloc/Institute_bloc/home_insstBloc.dart';
import 'package:let_me_check/login.dart';
import 'package:let_me_check/main.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/loginservice.dart';

class home_institute extends StatefulWidget {
  const home_institute({Key? key}) : super(key: key);

  @override
  State<home_institute> createState() => _home_instituteState();
}

class _home_instituteState extends State<home_institute> {
  late SharedPreferences logindata;

  NotificationServices notificationServices = NotificationServices();
  home_instBloc homebloc = home_instBloc();

  Future<void> rememberme() async {
    logindata = await SharedPreferences.getInstance();
    print("++++++++++++++++" + logindata.getString('theme').toString());
  }

  @override
  void initState() {
    FirebaseMessaging.instance;
    rememberme();
    FirebaseMessaging.instance.subscribeToTopic('Institute');

    //backgroung notification services
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message!.data['screen'] != null) {
        // Navigator.of(context).pushNamed(message.data['screen']);
        print(message.notification);
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
        // Navigator.of(context).pushNamed(message.data['screen']);
        print(message.notification);
      } else {
        print('null screen defined');
      }
    });
    homebloc.add(initialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    bool isdark = (Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  // child: ClipOval(child: Image.network('https://blogger.googleusercontent.com/img/a/AVvXsEgp6umpLmGBhzOawWLkL3_te2Trf_ZpfOC1_t-FKseBT5tJTq7l-kjHkf-ecbD_yD-96uRGDk19dnk8Ve-XpYQS_NCPjDbeOdWUG7W4U482VBMCB8WUfZ6Ue8d0NIXbx7iWUt9zZoOkELH_ihYuAof_Ftq0VkvTBuNqdHWfQyNurOazZf8JalDkQ8Dl',alignment: Alignment.center,filterQuality: FilterQuality.high,))),
                  child: ClipOval(
                      child: Image.network(
                    'https://picsum.photos/250',
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                  ))),
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
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.network(
                  "https://img.icons8.com/ios-glyphs/30/000000/bus.png",
                  color: isdark ? Colors.white : Colors.black,
                ),
                title: Text(
                  "Bus_Data".tr(),
                  style: TextStyle(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.pushNamed(context, '/bus');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.network(
                    'https://img.icons8.com/windows/32/000000/schoolboy-at-a-desk.png',
                    color: isdark ? Colors.white : Colors.black),
                title: Text(
                  "Student_Data".tr(),
                  style: TextStyle(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.of(context).pushNamed('/student');
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.network(
                    "https://img.icons8.com/ios-glyphs/30/000000/couple-man-woman.png",
                    color: isdark ? Colors.white : Colors.black),
                title: Text(
                  "Parents_Data".tr(),
                  style: TextStyle(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  await Navigator.pushNamed(context, '/parents');
                },
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10, height * 0.27, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () async {
                    await logindata.clear();
                    await logout();
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic('Institute');
                    await Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  },
                  leading: Icon(Icons.logout,
                      color: isdark ? Colors.white : Colors.black),
                  title: Text(
                    "Log_Out".tr(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                )),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home_Institute").tr(),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         if (!isdark) {
        //           await logindata.setString('theme', 'dark');
        //         }
        //         if (isdark) {
        //           await logindata.setString('theme', 'light');
        //         }
        //         currentTheme.toggleTheme();
        //       },
        //       icon: isdark
        //           ? Icon(Icons.dark_mode_rounded)
        //           : Icon(Icons.light_mode))
        // ],

        actions: [
          PopupMenuButton(
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
          )
        ],
      ),
      body: BlocBuilder(
        bloc: homebloc,
        builder: (context, state) {
          if (state is initialState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataGainedState) {
            print('data gained state');
            return ListView(
              children: [
                for (BusModel busdata in state.data)
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: MediaQuery.of(context).size.height * 0.13,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        "Bus_No.:_".tr() + "${busdata.userid.toString()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                      subtitle: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text("View_Student_List".tr(),
                              textAlign: TextAlign.center)),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            '/studentlsitbusassosiated',
                            arguments: busdata.userid);
                      },
                    ),
                  )
              ],
            );
          } else if (state is DataLossState) {
            return Container(
              child: Text("Error").tr(),
            );
          } else {
            return Container(
              child: Text("Error").tr(),
            );
          }
        },
      ),
    );
  }
}

Future _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}
