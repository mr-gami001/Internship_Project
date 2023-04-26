import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Services/institute/Parents.dart';
import 'package:let_me_check/bloc/Institute_bloc/Fetch_selected_Parentdata.dart';

import '../../string_constant.dart';

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
        title: Text(StringConstant.Update_Student_Data).tr(),
      ),

      body: BlocBuilder(
        bloc: selectedParentDataBloc,
        builder: (context, state){
          if(state is FetchStudentDataState){
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
                        enabled: false,
                        controller: userid,
                        decoration: InputDecoration(
                            hintText: StringConstant.EnterUserId.tr(),
                            labelText: StringConstant.UserId.tr(),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        enabled: false,
                        controller: studentuserid,
                        decoration: InputDecoration(
                            hintText: StringConstant.Enter_Student_User_Id_.tr(),
                            labelText: StringConstant.Student_UserId.tr(),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: password,
                        decoration: InputDecoration(
                            hintText: StringConstant.EnterPassword.tr(),
                            labelText: StringConstant.Password.tr(),
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
                        child: Text(StringConstant.Save.tr(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                        onPressed: ()async{

                          var check = await parents.Updatestudentdata(name.text, userid.text, studentuserid.text, password.text);

                          if(check == 'Added'){
                            await showDialog(context: context, builder: (context)=>AlertDialog(
                              icon: Icon(CupertinoIcons.person_add_solid),
                              title: Text(StringConstant.Data_Added).tr(),
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
            return Center(child: Text(StringConstant.Error).tr(),);
          }
        },
      ),

    );;
  }
}
