

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:let_me_check/Model/NotificationModel.dart';
import 'package:let_me_check/Services/busservice/Bus_breakdown.dart';
import 'package:let_me_check/Services/notificationservices.dart';

import '../../string_constant.dart';

class break_down extends StatefulWidget {
  const break_down({Key? key}) : super(key: key);

  @override
  State<break_down> createState() => _break_downState();
}

class _break_downState extends State<break_down> {

  Bus_breakdown bus_breakdown = Bus_breakdown();
  NotificationServices notificationServices = NotificationServices();

  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var userid = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(

      appBar: AppBar(
        title: Text(StringConstant.BreakDown).tr(),
        centerTitle: true,

      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            margin: EdgeInsets.fromLTRB(20,20,20,0),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: title,

              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: StringConstant.Enter_title.tr(),
                labelText: StringConstant.Title.tr()
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20,20,20,0),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: desc,

              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: StringConstant.EnterDescription.tr(),
                  labelText: StringConstant.Description.tr()
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ElevatedButton(
              onPressed: ()async{
                print(userid.toString());
                if(title.text != null && desc.text != null){
                  await bus_breakdown.upload_breakdown_message(userid.toString(), title.text, desc.text);
                  await notificationServices.sendnotification(title.text, desc.text, userid.toString());
                  await notificationServices.sendnotification(title.text, desc.text, 'Institute');
                  await showDialog(context: context, builder: (context)=>AlertDialog(title: Text('Done'),icon: Icon(Icons.done_all),));
                }
              },
              child: Text(StringConstant.SendMessage.tr()),
            ),
          )

        ],
      ),

    );
  }
}
