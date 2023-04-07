import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/bloc/Student_bloc/studentdata_busassociate.dart';

class studentListByBus extends StatefulWidget {
  const studentListByBus({Key? key}) : super(key: key);

  @override
  State<studentListByBus> createState() => _studentListByBusState();
}

class _studentListByBusState extends State<studentListByBus> {

  StudentDataBusAssociateBloc studentDataBusAssociateBloc = StudentDataBusAssociateBloc();
  String? bususerid;

  @override
  void didChangeDependencies() async {
    bususerid = await ModalRoute.of(context)!.settings.arguments.toString();
    studentDataBusAssociateBloc.add(InitEvent(bususerid));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      appBar:  AppBar(
        title: Text("Student List"),
        centerTitle: true,
        
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed('/busnotifications', arguments: bususerid);
          }, icon: Icon(CupertinoIcons.bell_fill))
        ],
      ),

      body: BlocBuilder(
        bloc: studentDataBusAssociateBloc,
        builder: (context, state){
          if(state is InitState){
            return Center(child: CircularProgressIndicator(),);
          }
          
          else if( state is DataGainedState){
            return ListView(
              children: [
                
                for (var items in state.filteredData)Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: MediaQuery.of(context).size.height*0.13,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text("Name : ${items.name.toString()}",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Container(margin: EdgeInsets.only(top: 10),child: Text("Student User Id : "+items.userid.toString(), textAlign: TextAlign.center)),
                  ),
                )
                
              ],
            );
          }

          else if(state is NullDataState){
            return Center(
              child: Text("No Data Found!", style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
            );
          }
          
          else{
            return Center(child: Text("Error"),);
          }
        },
      ),
    );
  }
}
