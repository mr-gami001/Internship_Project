

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/Parents.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/Services/loginservice.dart';
import 'package:let_me_check/bloc/bus_bloc/notification_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class notificationhistory extends StatefulWidget {
  const notificationhistory({Key? key}) : super(key: key);

  @override
  State<notificationhistory> createState() => _notificationhistoryState();
}

class _notificationhistoryState extends State<notificationhistory> {

  NotificaionHistoryBloc notificaionHistoryBloc = NotificaionHistoryBloc();

  SharedPreferences? logindata;
  String? busid;

  Future<void> rememberme()async{
    logindata = await SharedPreferences.getInstance();
    Map<String, dynamic> data = await cheking();
    if(data['user'] == 'Parents'){
      Student student = Student();
      Parents parents = Parents();
      ParentsModel parentsModel = await parents.fetchparentsdata(data['userid']);
      StudentModel studentModel=await student.fetchstudentdata(parentsModel.studentuserid!);
      busid =await studentModel.busno.toString();
    }
    else{
      busid = await data['userid'];
    }
    notificaionHistoryBloc.add(InitialEvent(busid!));
    print('***********${busid.toString()}');
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

    return Scaffold(

      body: BlocBuilder(
        bloc: notificaionHistoryBloc,
        builder: (context, state){


          if(state is InitialState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else if(state is DataGainedState){
            return ListView.builder(
              itemCount: state.datamodel.length,
              itemBuilder: (context, int index){

                Timestamp temptime = state.datamodel[index].time!;
                var Date = DateFormat('dd-MM').format(temptime.toDate());
                var time = DateFormat('HH-mm a').format(temptime.toDate());
                print(time);
                return Container(
                  height: height*0.1,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black26,
                  ),
                  child: ListTile(
                    title: Text(state.datamodel[index].title.toString(),style: TextStyle(fontSize: height*0.025),).tr(),
                    subtitle: Text(state.datamodel[index].discription.toString(),style: TextStyle(fontSize: height*0.025),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Date),
                        Text(time)
                      ],
                    ),
                  ),
                );
              },
            );
          }

          else{
            return Center(child: Container(child: Text("Error").tr(),));
          }

        },
      ),

      appBar: AppBar(
        title: Text("Notification_History").tr(),
        centerTitle: true,
      ),
    );
  }
}
