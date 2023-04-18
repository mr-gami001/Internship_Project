import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:let_me_check/Services/loginservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>["Institute", "Parents", "Bus"];

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String dropdownValue = list.first;
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  bool visible = true;
  IconData suffixicon = Icons.visibility_off;
  bool obsecuretext = true;



  late SharedPreferences logindata;

  rememberme() async {
    logindata = await SharedPreferences.getInstance();
    if (logindata.containsKey('userdata')) {
      String temp = await logindata.getString('userdata')!;
      Map<String, dynamic> data = jsonDecode(temp);
      print("user ** ${data['user']}  userid ** ${data['userid']}");
      await navigator(
          data['user'].toString(), data['uesrid'].toString(), context);
    } else {
      print('preference nulll');
    }
  }

  @override
  void initState() {
    rememberme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Widget elevatedchild = Text(
      "Login".tr(),
      style: TextStyle(fontSize: 20),
    );

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.18, bottom: 10),
          height: height * 0.15,
          width: width,
          alignment: Alignment.center,
          child: CircleAvatar(
            backgroundColor: (Theme.of(context).brightness == Brightness.dark)
                ? Colors.black12
                : Colors.black12,
            child: ClipOval(
                child: ImageIcon(
              AssetImage(
                  "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"),
              color: (Theme.of(context).brightness == Brightness.dark)
                  ? Colors.white
                  : Colors.black,
              size: height * 0.15,
            )),
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
            width: MediaQuery.of(context).size.height * 0.7,
            child: TextField(
              controller: name,
              decoration: InputDecoration(
                hintText: "Enter_User_Id".tr(),
                labelText: "User_Id".tr(),
                border: OutlineInputBorder(),
              ),
            )),
        Container(
            margin: EdgeInsets.only(left: 20, top: 0, right: 20),
            width: MediaQuery.of(context).size.height * 0.7,
            child: TextField(
              controller: password,
              obscureText: obsecuretext,
              enableSuggestions: false,
              toolbarOptions: ToolbarOptions(
                copy: false,
                cut: false,
                paste: false,
                selectAll: false,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(suffixicon),
                  onPressed: () {
                    setState(() {
                      if (obsecuretext == true) {
                        suffixicon = Icons.visibility;
                        obsecuretext = false;
                      } else {
                        suffixicon = Icons.visibility_off;
                        obsecuretext = true;
                      }
                    });
                  },
                ),
                hintText: "Enter_Password".tr(),
                labelText: "Password".tr(),
                border: OutlineInputBorder(),
              ),
            )),
        Container(
          alignment: Alignment.topRight,
          child: Visibility(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/forgetpass');
              },
              child: Text("Forget_Passs?").tr(),
            ),
            visible: visible,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(25, 0, 20, 20),
          width: MediaQuery.of(context).size.height * 0.7,
          child: DropdownButtonFormField(
            isDense: true,
            isExpanded: true,
            value: dropdownValue,
            alignment: AlignmentDirectional.center,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
                if (dropdownValue == 'Institute') {
                  visible = true;
                } else {
                  visible = false;
                }
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value).tr(),
              );
            }).toList(),
          ),
        ),


        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(
            child: elevatedchild,
            onPressed: () async {
              print(context.toString());

              setState(() {
                elevatedchild = CircularProgressIndicator(
                  color: Colors.white,
                );
              });
              if (dropdownValue == 'Institute') {
                String Credential =
                    await institutelog(name.text, password.text);
                // if(Credential == 'okay'){
                //   logindata.setString('userid', name.text);
                //   await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>home_institute()), (route) => false);
                // }
                if (Credential == 'okay') {
                  Map<String, String> userdata = {
                    'user': dropdownValue.toString(),
                    'userid': name.text.toString()
                  };
                  await logindata.setString('userdata', jsonEncode(userdata));
                  print(
                      "shared preference data : *** ${logindata.getString('user')} *** ${logindata.getString('userid')}");
                  navigator(dropdownValue, name.text, context);
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(Credential),
                          ));
                  setState(() {
                    elevatedchild =
                        Text("Login", style: TextStyle(fontSize: 20)).tr();
                  });
                }
              } else {
                String check = await loginservice(
                    dropdownValue.toLowerCase(), name.text, password.text);
                if (check == 'okay') {
                  Map<String, String> userdata = {
                    'user': dropdownValue.toString(),
                    'userid': name.text.toString()
                  };
                  await logindata.setString('userdata', jsonEncode(userdata));
                  navigator(dropdownValue, name.text, context);
                } else {
                  await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(check),
                          ));
                  setState(() {
                    elevatedchild = Text("Login").tr();
                  });
                }
              }
            },
          ),
        ),
      ],
    )));
  }

  @override
  void dispose() {
    name.dispose();
    password.dispose();
    super.dispose();
  }

  //navigator routes which is reflected on which type of user
  navigator(String user, String userid, BuildContext context) {
    if (user == 'Institute') {
      Object nav = Navigator.pushNamed(context, '/homeinst', arguments: userid);
      return nav;
    }
    // if(user == 'Student'){
    //   logindata.setString('userid', name.text);
    //   Navigator.pushNamedAndRemoveUntil(context, '/homestudent', (route) => false,arguments: userid);
    // }
    if (user == 'Parents') {
      logindata.setString('userid', name.text);
      Navigator.pushNamedAndRemoveUntil(
          context, '/homeparents', (route) => false,
          arguments: userid);
    }
    if (user == 'Bus') {
      logindata.setString('userid', name.text);
      Navigator.pushNamedAndRemoveUntil(context, '/homebus', (route) => false,
          arguments: userid);
    }
  }
}
