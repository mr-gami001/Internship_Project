import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Pages/Institute/parents.dart';
import 'package:let_me_check/bloc/Institute_bloc/fetch_stuent_data_for_parents.dart';

import '../../Services/institute/Parents.dart';
import '../../string_constant.dart';
import 'home_Institute.dart';

class addparents extends StatefulWidget {
  const addparents({Key? key}) : super(key: key);

  @override
  State<addparents> createState() => _addparentsState();
}

class _addparentsState extends State<addparents> {

  TextEditingController name = TextEditingController();
  TextEditingController userid = TextEditingController();
  TextEditingController studentuserid = TextEditingController();
  TextEditingController pass = TextEditingController();
  Parents _parents = Parents();
  String? dropdownvalue;
  TempstudentfetchdataBloc _tempstudentfetchdataBloc = TempstudentfetchdataBloc();

  bool obsecuretext = true;
  IconData obsecureicon = Icons.visibility_off;

  @override
  void initState() {
    _tempstudentfetchdataBloc.add(fetchTempStudentdataEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(StringConstant.Add_Parents_Data).tr(),
      ),

      body: SingleChildScrollView(
        child: BlocBuilder<TempstudentfetchdataBloc, TempStudentdataState>(
          bloc: _tempstudentfetchdataBloc,
          builder: (context, state) {

    if(state is TempStudentInitialdataState){
      return Container(
        // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    else if (state is TempStudentdatagainedState){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          Container(
              margin: EdgeInsets.fromLTRB(20,20,20,0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: StringConstant.Enter_Name.tr(),
                  labelText: StringConstant.Name1.tr(),
                  border: OutlineInputBorder(),
                ),
              )
          ),

          Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: userid,
                decoration: InputDecoration(
                  hintText: StringConstant.EnterUserId.tr(),
                  labelText: StringConstant.UserId.tr(),
                  border: OutlineInputBorder(),
                ),
              )
          ),

          // Container(
          //     margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          //     width: MediaQuery.of(context).size.height*0.7,
          //     child: TextField(
          //       controller: studentuserid,
          //       decoration: InputDecoration(
          //         hintText: "Enter Students UserId",
          //         labelText: 'student userid',
          //         border: OutlineInputBorder(),
          //       ),
          //     )
          // ),


          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [

                Container(
                  child: Text(StringConstant.Select_Student.tr(),style: TextStyle(fontWeight: FontWeight.bold),),
                ),

                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  padding: EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    isExpanded: true,
                    value: dropdownvalue,

                    items: state.data.map((value){
                      return DropdownMenuItem(child: Text(value.name.toString()),value: value.userid,);
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
              margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              width: MediaQuery.of(context).size.height*0.7,
              child: TextField(
                controller: pass,
                obscureText: obsecuretext,
                decoration: InputDecoration(
                  hintText: StringConstant.EnterPassword.tr(),
                  labelText: StringConstant.Password.tr(),
                  border: OutlineInputBorder(),

                  suffixIcon: IconButton(
                    icon: Icon(obsecureicon),
                    onPressed: (){
                      setState(() {
                        if(obsecuretext == true){
                          obsecuretext = false;
                          obsecureicon = Icons.visibility;
                        }else{
                          obsecuretext = true;
                          obsecureicon = Icons.visibility_off;
                        }
                      });
                    },


                  )
                ),
              )
          ),

          Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: ()async{

                if(name != null && userid != null && pass != null){
                  String check = await _parents.addparentsdata(name.text , userid.text ,dropdownvalue!, pass.text);


                  if(check == 'added'){
                    await showDialog(context: context, builder: (context)=>AlertDialog(
                      icon: Icon(Icons.done),
                      title: Text(StringConstant.Done).tr(),
                    ));
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>parents()));
                  }

                  else if(check == 'student not found'){
                    await showDialog(context: context, builder: (context)=>AlertDialog(
                      icon: Icon(Icons.no_accounts),
                      title: Text(StringConstant.Invalid_Student_User_Id).tr(),
                    ));
                  }


                  else{
                    await showDialog(context: context, builder: (context)=>AlertDialog(
                      icon: Icon(Icons.error),
                      title: Text(StringConstant.Error).tr(),
                    ));
                  }

                }else{

                  showDialog(context: context, builder: (context)=>AlertDialog(title: Text('Enter valid value'),));
                }
              },

              child: Text(StringConstant.Save.tr(),style: TextStyle(color: Colors.white,fontSize: 20),),),
            height: MediaQuery.of(context).size.height*0.075,
            width: MediaQuery.of(context).size.width*0.5,
          ),

        ],


      );
    }

    else{
      return Text(StringConstant.Error).tr();
    }

  },
),
      ),
    );
  }
}
