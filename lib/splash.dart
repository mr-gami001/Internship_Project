

import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:let_me_check/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {

  Color? backcolor;

  SharedPreferences? logindata;

  rememberme()async{
    logindata = await SharedPreferences.getInstance();
    if(logindata!.containsKey('userdata')){
      String temp =await logindata!.getString('userdata')!;
      Map<String, dynamic> data = jsonDecode(temp);
      print("user ** ${data['user']}  userid ** ${data['userid']}");
      await navigator(data['user'].toString(), data['uesrid'].toString(), context);
    }
    else{
      print('preference nulll');
    }
  }

  @override
  void initState() {
   // rememberme();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).brightness == Brightness.light){
      backcolor = Colors.white;
    }
    if(Theme.of(context).brightness == Brightness.dark){
      backcolor = Colors.black;
    }

    return AnimatedSplashScreen(
      backgroundColor: backcolor!,
      splashTransition: SplashTransition.fadeTransition,
      centered: true,
      animationDuration: Duration(seconds: 2),
      // splash: Image.asset('android/app/src/main/res/drawable/logo.jpg',height: 40,fit: BoxFit.fitHeight,),
      splash: ImageIcon(
        AssetImage('android/app/src/main/res/mipmap-xhdpi/ic_launcher.png'),
        size: MediaQuery.of(context).size.height*0.5,
      ),
      nextScreen: login(),
      curve: Curves.slowMiddle,
    );
  }
  navigator(String user,String userid,BuildContext context){
    if(user == 'Institute'){
      Object nav = Navigator.pushNamed(context, '/homeinst',arguments: userid);
      return nav;
    }
    // if(user == 'Student'){
    //   logindata.setString('userid', name.text);
    //   Navigator.pushNamedAndRemoveUntil(context, '/homestudent', (route) => false,arguments: userid);
    // }
    if(user == 'Parents'){
      Navigator.pushNamedAndRemoveUntil(context, '/homeparents', (route) => false,arguments: userid);
    }
    if(user == 'Bus'){
      Navigator.pushNamedAndRemoveUntil(context, '/homebus', (route) => false,arguments: userid);
    }
  }
}


