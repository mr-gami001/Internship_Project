import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:let_me_check/Model/NotificationModel.dart';
import 'package:let_me_check/bloc/bus_bloc/notification_history.dart';

class busnotifications extends StatefulWidget {
  const busnotifications({Key? key}) : super(key: key);

  @override
  State<busnotifications> createState() => _busnotificationsState();
}


class _busnotificationsState extends State<busnotifications> {

  NotificaionHistoryBloc notificaionHistoryBloc = NotificaionHistoryBloc();
  var busid;



  @override
  void didChangeDependencies() {
    busid =ModalRoute.of(context)?.settings.arguments;
    notificaionHistoryBloc.add(InitialEvent(busid.toString()));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus_Notification").tr(),
        centerTitle: true,
      ),

      body: BlocBuilder(
        bloc: notificaionHistoryBloc,
        builder: (context, state){
          if(state is InitialState){
            return Center(child: CircularProgressIndicator(),);
          }

          else if (state is DataGainedState){
            return ListView(
              children: [

                for(EmergencyNotificationModel notification in state.datamodel)Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
              ),
              child: ListTile(
                title: Text(notification.title.toString()).tr(),
                subtitle: Text(notification.discription.toString()),
                trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd-MM').format(notification.time!.toDate())),
                      Text(DateFormat('HH-mm a').format(notification.time!.toDate())),

                    ]),
              ),
            )

              ],
            );
          }

          else if (state is DataLossState){
            return Center(child: Text('Error').tr(),);
          }

          else{
            return Center(child: Text('Error').tr(),);
          }
        },
      ),
    );
  }
}
