import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:location/location.dart';

class StartJourneyBloc extends Bloc<StartJourneyEvent, StartJourneyState> {
  StartJourneyBloc() : super(InitialState()) {

    on<InitialEvent>((event, emit) async {
      String? busid = event.userid;
      emit(InitialState());
      try{
        Bus bus = Bus();
        GeoPoint locationData = await bus.startsharingloc(busid!);
        if(locationData.latitude != null || locationData.longitude!=null){
          emit(DataGainedState(locationData));
        }
        else{
          emit(DataLossState('err'));
        }

      }
      catch(e){
        emit(DataLossState(e.toString()));
      }

    });

  }
}

abstract class StartJourneyState{}

class InitialState extends StartJourneyState{}

class DataGainedState extends StartJourneyState{
  GeoPoint locationData;
  DataGainedState(this.locationData);
}

class DataLossState extends StartJourneyState{
  String error;
  DataLossState(this.error);
}

abstract class StartJourneyEvent{}

class InitialEvent extends StartJourneyEvent{
  String? userid;
  InitialEvent(this.userid);
}

class DataGainedEvent extends StartJourneyEvent{}

class DataLossEvent extends StartJourneyEvent{}