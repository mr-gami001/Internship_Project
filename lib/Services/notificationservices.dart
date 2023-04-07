import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


class NotificationServices{

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      '001', 'channelName',
    importance: Importance.max,
    priority: Priority.max,
  );

  final DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );





  Future<InitializationSettings> initializeNotification () async {
    final AndroidInitializationSettings _androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final _iosInitializationSettings = DarwinInitializationSettings(
        requestCriticalPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestAlertPermission: true,
        defaultPresentSound: true,
        defaultPresentBadge: true,
        defaultPresentAlert: true
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    InitializationSettings initializationSettings =InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    return initializationSettings;
  }

  Future<String> firebasetoken()async{
    FirebaseMessaging firebaseMessaging = await FirebaseMessaging.instance;

    String? token = await firebaseMessaging.getToken();

    var subscription = await FirebaseMessaging.instance.subscribeToTopic('test1');
    await FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved");
      print(message.data);
    });
    await FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    return token!;
  }


  Future<void> showNotification (RemoteMessage message,String screenname) async {
    if(await Permission.notification.isGranted) {
      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails
      );
      print(message);
      print(screenname);
      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data.toString(),


      );

    }else{
      await Permission.notification.request();
      showNotification(message, screenname);
    }
  }

  // sendnotification()async {
  //   try {
  //     http.Response response = await http.post(
  //       Uri.parse("https://fcm.googleapis.com/fcm/send"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8",
  //         "Authorization": "key = AAAAjn3mYk4:APA91bFt113t4bwNXnY2XF59iGlqokgU4SbqhunHsEdQFKzc82IqvI3VVet8PJ2PaiC5uLTi4QBPFgHk4hCG2OsK5dj8W04SCRp2oQYzfi03wsPMZoe_YyupecCrre7PTnzQZni8zQrc"
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notificatio':<String, dynamic>{
  //             "body":"service name",
  //             "name":"first nottt"
  //           },
  //           'priority':'high',
  //           'data':<String,dynamic>{
  //             "click_action":"flutter click nott",
  //             'id':"1",
  //             "status":"done"
  //           },
  //           "to":"fwKsxhGZRfuSMPVocpweJR:APA91bEmlQb_-YjYFYDwVlITsSaX5qSj_9VgwEoy4FywzXO5QJuL1YCRQepc6I3EniQC2TLSvXzr9LcSLga1vCU0UMX2S3DVpldRyRdjZvJE6rObSwqgVEWYtHZTikRwEfmqJaJHPlGF"
  //         }
  //       )
  //     );
  //     response;
  //   }
  //   catch(e){
  //     print(e.toString());
  //   }
  // }

  requestpermission() async {
    try{
      if(await Permission.notification.isDenied){
        List reques = await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
        print(reques);
      }
      else{
        print('no request pending');
      }
    }catch(e){
      print(e.toString());
    }
  }

  sendnotification(String title , String body,String topic)async{
    try{
      final Map<String, dynamic> data = {
        "to": "/topics/$topic",
        "notification": {
          "title": title,
          "body": body,
        },

        "data": {
          "type":"order",
          "id":"001",
          "screen":"/notificationhistory",
          "click_action":"FLUTTER_NOTIFICATION_CLICK",

        }
      };

      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=AAAAjn3mYk4:APA91bFt113t4bwNXnY2XF59iGlqokgU4SbqhunHsEdQFKzc82IqvI3VVet8PJ2PaiC5uLTi4QBPFgHk4hCG2OsK5dj8W04SCRp2oQYzfi03wsPMZoe_YyupecCrre7PTnzQZni8zQrc"
        },
        body: jsonEncode(data),
        encoding: Encoding.getByName('UTF-8')
      );
      if(response.statusCode == 200){
        print('ok');
      }
      else{
        print('errr');
      }
    }
    catch(e){
      print(e);
    }
  }

}

