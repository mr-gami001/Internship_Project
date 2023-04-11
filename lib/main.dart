import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:let_me_check/splash.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Institute/Student_List_bus_assosiated.dart';
import 'Pages/Institute/UpdateStudent.dart';
import 'Pages/Institute/add_student.dart';
import 'Pages/Institute/bus.dart';
import 'Pages/Institute/busnotifications.dart';
import 'Pages/Student/home_Student.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'package:camera/camera.dart';
import 'Helper/Theme_Helper.dart';

Theme_Help theme = Theme_Help();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();

  await Permission.location.request();
  await Permission.notification.request();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    sound: true,
    criticalAlert: true,
    carPlay: true,
    provisional: true
  );

  runApp(
   myApp()
  );
}


class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {



  set()async{
    SharedPreferences log = await SharedPreferences.getInstance();
    if(log.containsKey('theme')){
      if(log.getString('theme') == 'dark'){
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
  Widget build(BuildContext context) {
    return MaterialApp(
      themeAnimationDuration: Duration(seconds: 5),
      themeMode: currentTheme.currentTheme,
      theme: theme.light_theme(),
      darkTheme: theme.dark_theme(),

      debugShowCheckedModeBanner: false,

      // home: AnimatedSplashScreen(
      //   splashTransition: SplashTransition.scaleTransition,
      //   splashIconSize: 70,
      //   duration: 2500,
      //   splash: Image.asset('android/app/src/main/res/drawable/logo.jpg',height: 40,fit: BoxFit.fitHeight,),
      //   nextScreen: login(),
      //
      //
      // ),

      routes: {
        '/' : (context) => splash(),

        '/login': (context) => login(),
        '/forgetpass' : (context) => forgetpass(),
        '/homeinst': (context) => home_institute(),


        '/homestudent' : (context)=>home_Student(),
        '/homeparents' : (context)=>home_Parents(),
        '/homebus' : (context)=>home_Bus(),


        '/student' : (context)=>student(),
        '/parents' : (context) => parents(),
        '/bus': (context) => bus(),


        '/addstudent': (context) => addstudent(),
        '/addparents': (context) => addparents(),
        '/addbus': (context) => addbus(),

        '/tracklocation' : (context) => tracklocation(),


        '/breakdown' : (context) => break_down(),
        '/notificationhistory' : (context) => notificationhistory(),
        '/busnotifications' : (context) => busnotifications(),

        '/studentlsitbusassosiated' : (context) => studentListByBus(),
        '/UpdateStudent' : (context) => UpdateStudent(),
        '/UpdateParent' : (context) => UpdateParent(),
      },
    );
  }
}