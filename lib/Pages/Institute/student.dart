import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/bloc/Institute_bloc/fetch_student_data_bloc.dart';

class student extends StatefulWidget {
  const student({Key? key}) : super(key: key);

  @override
  State<student> createState() => _studentState();
}

class _studentState extends State<student> {

  student students = student();

  StudentDataBloc _studentDataBloc = StudentDataBloc();

  @override
  void initState() {
    _studentDataBloc.add(FetchStudentDataEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text('Student Section'),

        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.popAndPushNamed(context, '/homeinst');
        },),

        actions: [
          IconButton(onPressed: ()async{
            await Navigator.pushNamed(context, '/addstudent');
          }, icon: Icon(CupertinoIcons.add_circled_solid))
        ],
        
      ),
      body: BlocBuilder<StudentDataBloc, StudentDataState>(
        bloc: _studentDataBloc,
        builder: (context, state) {

          if(state is FetchStudentDataState){
            return Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              child: CircularProgressIndicator(),
            );
          }

          else if (state is FetchedStudentDataState){

            return ListView(
              children: [

                for(StudentModel stud in state.data)Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListTile(
                    title: Text("Name : "+stud.name.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("User Id : "+stud.userid.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Text("Bus No : "+stud.busno.toString()),
                    onTap: ()async{
                      Navigator.pushNamed(context, '/UpdateStudent', arguments: stud.userid);
                    },
                  ),
                )

              ],
            );

          }

          else{
            return Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
              child: Center(
                child: Text('Error Occure'),
              ),
            );
          }

        },
      ),
    );
  }
}
