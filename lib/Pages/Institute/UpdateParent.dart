import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Services/institute/Parents.dart';
import 'package:let_me_check/bloc/Institute_bloc/Fetch_selected_Parentdata.dart';

class UpdateParent extends StatefulWidget {
  const UpdateParent({Key? key}) : super(key: key);

  @override
  State<UpdateParent> createState() => _UpdateParentState();
}

class _UpdateParentState extends State<UpdateParent> {

  Parents parents = Parents();
  SelectedParentDataBloc selectedParentDataBloc = SelectedParentDataBloc();

  TextEditingController name = TextEditingController();
  TextEditingController studentuserid = TextEditingController();
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void didChangeDependencies() async {
    var parentsid = await ModalRoute.of(context)!.settings.arguments;
    selectedParentDataBloc.add(FetchStudentDataEvent(parentsid.toString()));
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
        bloc: selectedParentDataBloc,
        builder: (context, state){
          if(state is FetchStudentDataEvent){
            return Center(child: CircularProgressIndicator(),);
          }

          else if (state is FetchedStudentDataState){
            ParentsModel tempstudent = state.data!;
            userid.text = tempstudent.userid!;
            name.text = tempstudent.name!;
            studentuserid.text = tempstudent.studentuserid!;
            password.text = tempstudent.password!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                        enabled: false,
                        controller: studentuserid,
                        decoration: const InputDecoration(
                            hintText: 'Enter Student User Id :',
                            labelText: 'Student UserId',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: password,
                        decoration: const InputDecoration(
                            hintText: 'Enter Password',
                            labelText: 'Password',
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

                          var check = await parents.Updatestudentdata(name.text, userid.text, studentuserid.text, password.text);

                          if(check == 'Added'){
                            await showDialog(context: context, builder: (context)=>AlertDialog(
                              icon: Icon(CupertinoIcons.person_add_solid),
                              title: Text('Data Added !'),
                            ));
                            await Navigator.pushNamed(context, '/parents');
                          }

                          else{
                            await showDialog(context: context, builder: (context)=>AlertDialog(title: Text(check.toString()),));
                          }

                        },
                      ),
                    ),


                  ],
                ),
              ),
            );
          }

          else{
            return Center(child: Text('errror'),);
          }
        },
      ),

    );;
  }
}
