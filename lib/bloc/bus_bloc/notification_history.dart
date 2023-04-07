
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/NotificationModel.dart';
import 'package:let_me_check/Services/busservice/Bus_breakdown.dart';


class NotificaionHistoryBloc extends Bloc<notification_historyEvent,notification_historyState>{
  NotificaionHistoryBloc() : super(InitialState()){

    Bus_breakdown services = Bus_breakdown();

    on<InitialEvent>((event, emit) async {

      emit(InitialState());
      String busid = event.busid;
      if(busid.isNotEmpty){

        List<EmergencyNotificationModel> data = await services.getnotifications(busid);
        print("colllll"+data.toString());
        if(data != null || data != []){
          emit(DataGainedState(data.reversed.toList()));
        }
        else{
          emit(DataLossState());
        }

      }else{
        emit(DataLossState());
      }



    });

  }
}





abstract class notification_historyState{}

class InitialState extends notification_historyState{}

class DataGainedState extends notification_historyState{
  List<EmergencyNotificationModel> datamodel;
  DataGainedState(this.datamodel);
}

class DataLossState extends notification_historyState{}

abstract class notification_historyEvent{}

class InitialEvent extends notification_historyEvent{
  String busid;
  InitialEvent(this.busid);
}

class DataGainedEvent extends notification_historyEvent{}

class DataLossEvent extends notification_historyEvent{}

