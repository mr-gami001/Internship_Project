import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/notificationservices.dart';

import '../../bloc/Institute_bloc/fetch_bus_data_for_student_bloc.dart';

class bus extends StatefulWidget {
  const bus({Key? key}) : super(key: key);

  @override
  State<bus> createState() => _busState();
}

class _busState extends State<bus> {

  Bus bus = Bus();

  BusfetchdataBloc busfetchdataBloc = BusfetchdataBloc();



  @override
  void initState() {
    busfetchdataBloc.add(fetchdataEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Bus".tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.popAndPushNamed(context, '/homeinst');
          },
        ),

        actions: [
          IconButton(onPressed: () async{
            await Navigator.pushNamed(context, '/addbus');
          }, icon: Icon(CupertinoIcons.add_circled_solid))
        ],

      ),

      body: SingleChildScrollView(
        child: BlocBuilder<BusfetchdataBloc, BusdataState>(
          bloc: busfetchdataBloc,
          builder: (context, state) {

            if(state is InitialdataState){
              return Center(child: CircularProgressIndicator(),);
            }
            
            
            else if(state is datagainedState){
              // return Text('Fetched data ${state.data}');
              return SingleChildScrollView(
                child: Column(
                  children: [


                    for (BusModel items in state.data)Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),


                      child: ListTile(
                        title: Text("Bus_No.:_".tr()+"${items.busno}",style: TextStyle(fontWeight: FontWeight.w900),textAlign: TextAlign.start,),
                        subtitle: Text("Press_For_Track_Location".tr(),textAlign: TextAlign.start,),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Bus_UserId_:_".tr()+"\n"+items.userid.toString()),
                          ],
                        ),
                        onTap: ()async {
                          await Navigator.pushNamed(context,'/tracklocation',arguments: items.userid);
                        },
                      ),
                    ),


                  ],
                ),
              );
            }
            
            else if(state is NetworkErrorSatate){
              return Center(
                child: Container(
                    height: 80,
                    width: 100,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text("Error".tr(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30),)
                ),
              );
            }

            else{
              return Center(
                child: Container(
                  height: 80,
                  width: 100,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                  color: Colors.red,
                  alignment: Alignment.center,
                    child: Text("Error".tr(),style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30),)
                ),
              );
            }

          },
        )
      )
    );
  }
}

