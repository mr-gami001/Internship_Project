import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/bloc/Institute_bloc/add_bus_data.dart';

import '../../Services/institute/student.dart';




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
      appBar: AppBar(),
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
                  decoration: const InputDecoration(
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    border: OutlineInputBorder()
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: userid,
                  decoration: const InputDecoration(
                      hintText: 'Enter UserId',
                      labelText: 'UserId',
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
                      child: const Text('Enter Bus No. :',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 30),
                      width: MediaQuery.of(context).size.width*0.64,
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
                width: MediaQuery.of(context).size.width*0.4,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: EdgeInsets.all(20),
                child: TextButton(
                  child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                  onPressed: ()async{
                    var check = await stud.addstudentdata(name.text, userid.text, dropdownvalue!);
                    
                    if(check == 'Added'){
                      await showDialog(context: context, builder: (context)=>AlertDialog(
                        icon: Icon(CupertinoIcons.person_add_solid),
                        title: Text('Data Added !'),
                      ));
                      await Navigator.pushNamed(context, '/student');
                    }

                    else if (check == 'Already'){
                      await showDialog(context: context, builder: (context)=>AlertDialog(
                        icon: Icon(Icons.account_circle),
                        title: Text("User Already Exists"),
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
            child: Text('data'),
          );
        }
      },
      ),
      ),
    );
  }
}

