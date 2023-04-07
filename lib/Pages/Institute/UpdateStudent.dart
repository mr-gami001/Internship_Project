import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/bloc/Institute_bloc/Fetch_selected_StudentData.dart';

class UpdateStudent extends StatefulWidget {
  const UpdateStudent({Key? key}) : super(key: key);

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {

  Student student = Student();
  Bus bus = Bus();
  StudentModel? studentModel;

  TextEditingController name = TextEditingController();
  TextEditingController busno = TextEditingController();
  TextEditingController userid = TextEditingController();

  SelectedStudentDataBloc studentDataBloc = SelectedStudentDataBloc();

  @override
  void didChangeDependencies() async {
    var studentuserid = await ModalRoute.of(context)!.settings.arguments;
    studentDataBloc.add(FetchStudentDataEvent(studentuserid.toString()));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Student Data"),
      ),

      body: BlocBuilder(
        bloc: studentDataBloc,
        builder: (context, state){
          if(state is FetchStudentDataState){
            return Center(child: CircularProgressIndicator(),);
          }

          else if (state is FetchedStudentDataState){
            StudentModel tempstudent = state.data!;
            userid.text = tempstudent.userid!;
            name.text = tempstudent.name!;
            busno.text = tempstudent.busno.toString();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      enabled: false,
                      controller: userid,
                      decoration: const InputDecoration(
                          hintText: 'Enter UserId',
                          labelText: 'UserId',
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      controller: busno,
                      decoration: const InputDecoration(
                          hintText: 'Enter Bus No.',
                          labelText: 'Bus No.',
                          border: OutlineInputBorder()
                      ),
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

                        var check = await student.Updatestudentdata(name.text, userid.text, int.parse(busno.text));

                        if(check == 'Added'){
                          await showDialog(context: context, builder: (context)=>AlertDialog(
                            icon: Icon(CupertinoIcons.person_add_solid),
                            title: Text('Data Added !'),
                          ));
                          await Navigator.pushNamed(context, '/student');
                        }

                        else{
                          await showDialog(context: context, builder: (context)=>AlertDialog(title: Text(check.toString()),));
                        }

                      },
                    ),
                  ),


                ],
              ),
            );
          }

          else{
            return Center(child: Text('errror'),);
          }
        },
      ),

    );
  }
}
