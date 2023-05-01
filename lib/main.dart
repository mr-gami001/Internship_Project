import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:let_me_check/Pages/Bus/break_down.dart';
import 'package:let_me_check/Pages/Bus/home_bus.dart';
import 'package:let_me_check/Pages/Bus/notificationhistory.dart';
import 'package:let_me_check/Pages/Institute/UpdateParent.dart';
import 'package:let_me_check/Pages/Institute/add_bus.dart';
import 'package:let_me_check/Pages/Institute/add_parents.dart';
import 'package:let_me_check/forgetpass.dart';
import 'package:let_me_check/Pages/Institute/home_Institute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:let_me_check/Pages/Institute/parents.dart';
import 'package:let_me_check/Pages/Institute/student.dart';
import 'package:let_me_check/Pages/Parents/Track_Location.dart';
import 'package:let_me_check/Pages/Parents/home_Parents.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Institute/Student_List_bus_assosiated.dart';
import 'Pages/Institute/UpdateStudent.dart';
import 'Pages/Institute/add_student.dart';
import 'Pages/Institute/bus.dart';
import 'Pages/Institute/busnotifications.dart';
import 'Pages/Student/home_Student.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'Helper/Theme_Helper.dart';
import 'package:easy_localization/easy_localization.dart';

Theme_Help theme = Theme_Help();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  //for crash analysis
  FlutterError.onError = (error) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(error);
  };
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };


  await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      criticalAlert: true,
      carPlay: true,
      provisional: true);

  //initialize the easy localization service
  EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      child: myApp(),
      fallbackLocale: Locale('en', 'US'),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('gu', 'IN')
      ],
      path: 'assets/translations'));
}

class myApp extends StatefulWidget {

  myApp({Key? key}) : super(key: key);


  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {



  set() async {
    SharedPreferences log = await SharedPreferences.getInstance();
    if (log.containsKey('theme')) {
      if (log.getString('theme') == 'dark') {
        print('0000000000000000000');
        currentTheme.toggleTheme();
      }
    }
  }

  @override
  void initState() {
    set();
    currentTheme.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() async {

    await Permission.location.request();
    await Permission.notification.request();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeAnimationDuration: Duration(seconds: 5),
      themeMode: currentTheme.currentTheme,
      theme: theme.light_theme(),
      darkTheme: theme.dark_theme(),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routes: {
        '/': (context) => login(),
        '/forgetpass': (context) => forgetpass(),
        '/homeinst': (context) => home_institute(),
        '/homestudent': (context) => home_Student(),
        '/homeparents': (context) => home_Parents(),
        '/homebus': (context) => home_Bus(),
        '/student': (context) => student(),
        '/parents': (context) => parents(),
        '/bus': (context) => bus(),
        '/addstudent': (context) => addstudent(),
        '/addparents': (context) => addparents(),
        '/addbus': (context) => addbus(),
        '/tracklocation': (context) => tracklocation(),
        '/breakdown': (context) => break_down(),
        '/notificationhistory': (context) => notificationhistory(),
        '/busnotifications': (context) => busnotifications(),
        '/studentlsitbusassosiated': (context) => studentListByBus(),
        '/UpdateStudent': (context) => UpdateStudent(),
        '/UpdateParent': (context) => UpdateParent(),
      },
    );
  }
}
