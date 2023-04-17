import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import '../../bloc/Institute_bloc/fetch_parents_data_bloc.dart';

class parents extends StatefulWidget {
  const parents({Key? key}) : super(key: key);

  @override
  State<parents> createState() => _parentsState();
}

class _parentsState extends State<parents> {

  ParentsDataBloc _parentsDataBloc = ParentsDataBloc();

  @override
  void initState() {
    _parentsDataBloc.add(FetchParentsDataEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Parents").tr(),


        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.popAndPushNamed(context, '/homeinst');
        },),

        actions: [
          IconButton(onPressed: ()async{
            await Navigator.pushNamed(context, '/addparents');
          }, icon: Icon(CupertinoIcons.add_circled_solid))
        ],

      ),

        body: BlocBuilder<ParentsDataBloc, ParentsDataState>(
          bloc: _parentsDataBloc,
          builder: (context, state) {

            if(state is FetchParentsDataState){
              return Container(
                // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            else if (state is FetchedParentsDataState){

              return ListView(
                children: [

                  for(ParentsModel paren in state.data)Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ListTile(
                      title: Text("Name_:_".tr()+paren.name.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text("User_Id_:_".tr()+paren.userid.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                      trailing: Text("Student_User_Id_:_".tr()+paren.studentuserid.toString()),
                      onTap: (){
                        Navigator.pushNamed(context, '/UpdateParent',arguments: paren.userid);
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
                  child: Text("Error").tr(),
                ),
              );
            }

          },
        ),
    );
  }
}
