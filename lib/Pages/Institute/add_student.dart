import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/bloc/Institute_bloc/add_bus_data.dart';

import '../../Services/institute/student.dart';
import '../../string_constant.dart';




class addstudent extends StatefulWidget {
  const addstudent({Key? key}) : super(key: key);

  @override
  State<addstudent> createState() => _addstudentState();
}

class _addstudentState extends State<addstudent> {

  Student stud = Student();


  TextEditingController name = TextEditingController();
  TextEditingController userid = TextEditingController();
  // TextEditingController pass = TextEditingController();
  int? dropdownvalue;

  List<String> dropdownlst = [];

  StudentfetchbusdataBloc _studentfetchbusdataBloc = StudentfetchbusdataBloc();

  @override
  void initState() {
    // TODO: implement initState
    _studentfetchbusdataBloc.add(GetBusDataEvent());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(StringConstant.Add_Student_Data).tr(),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<StudentfetchbusdataBloc, BusState>(
      bloc: _studentfetchbusdataBloc,
      builder: (context, state) {
        if(state is GetBusDataState){
          return Center(child: CircularProgressIndicator());
        }

        else if(state is GetBusDataGainedState){
          return Column(
            children: [

              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: StringConstant.Enter_Name.tr(),
                    labelText: StringConstant.Name1.tr(),
                    border: OutlineInputBorder()
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: userid,
                  decoration: InputDecoration(
                      hintText: StringConstant.EnterUserId.tr(),
                      labelText: StringConstant.UserId.tr(),
                      border: OutlineInputBorder()
                  ),
                ),
              ),

              // Container(
              //   margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              //   child: TextField(
              //     obscureText: true,
              //     controller: pass,
              //     decoration: const InputDecoration(
              //         hintText: 'Enter Password',
              //         labelText: 'Password',
              //         border: OutlineInputBorder()
              //     ),
              //   ),
              // ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [

                    Container(
                      child: Text(StringConstant.Enter_Bus_No.tr(),style: TextStyle(fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 30),
                      width: MediaQuery.of(context).size.width*0.55,
                      child: DropdownButton(
                        value: dropdownvalue,
                        isExpanded:  true,
                        items: state.studentdata.map((value){
                          return DropdownMenuItem(child: Text(value.busno.toString()),value: value.busno,);
                        }).toList(),

                        onChanged: (selecteditem){setState(() {
                          dropdownvalue = selecteditem;
                        });},
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height*0.075,
                width: MediaQuery.of(context).size.width*0.45,
                margin: EdgeInsets.all(20),
                child: ElevatedButton(
                  child: Text(StringConstant.Save.tr(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  onPressed: ()async{
                    var check = await stud.addstudentdata(name.text, userid.text, dropdownvalue!);
                    
                    if(check == 'Added'){
                      await showDialog(context: context, builder: (context)=>AlertDialog(
                        icon: Icon(CupertinoIcons.person_add_solid),
                        title: Text(StringConstant.Data_Added).tr(),
                      ));
                      await Navigator.pushNamed(context, '/student');
                    }

                    else if (check == 'Already'){
                      await showDialog(context: context, builder: (context)=>AlertDialog(
                        icon: Icon(Icons.account_circle),
                        title: Text(StringConstant.User_Already_Exists),
                      ));
                    }
                    else{
                      await showDialog(context: context, builder: (context)=>AlertDialog(title: Text(check.toString()),));
                    }
                    
                  },
                ),
              ),

            ],
          );
        }

        else{
          return Center(
            child: Text(StringConstant.Error).tr(),
          );
        }
      },
      ),
      ),
    );
  }
}

