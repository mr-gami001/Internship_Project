import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/student.dart';
import 'package:let_me_check/Services/institute/bus.dart';
import 'package:permission_handler/permission_handler.dart';

class GetBusLocationBloc extends Bloc<buslocationEvent, buslocationState> {
  GetBusLocationBloc() : super(GetBusLocationState()) {



    on<GetBusLocatioEvent>((event, emit) async {

      Permission _permission = Permission.location;
      PermissionStatus _status = await _permission.status;

      if(_status.isGranted) {
        emit(GetBusLocationState());
        try {
          Bus bus = await Bus();
          Student student = Student();

          String busUserid = await event.bususerid!;
          print(" Data ***" + busUserid);


          BusModel busdata = await bus.fetchsbusdata(
              busUserid.toString());

          if (busdata.location != GeoPoint(0, 0)) {
            print(busdata.location);
            GeoPoint buslocation = await busdata.location!;
            emit(BusLocationGainedState(buslocation, busUserid.toString()));
          }
        }
        catch (e) {
          emit(BusLocationLossState('No Location found for this bus'));
        }
      }
      else{
        PermissionStatus stat = await Permission.location.request();
        if (stat.isGranted){
          try {
            Bus bus = await Bus();
            Student student = Student();

            String busUserid = await event.bususerid!;
            print(" Data ***" + busUserid);

            BusModel busdata = await bus.fetchsbusdata(
                busUserid.toString());

            if (busdata.location != GeoPoint(0, 0)) {
              print(busdata.location);
              GeoPoint buslocation = await busdata.location!;
              emit(BusLocationGainedState(buslocation, busUserid.toString()));
            }
          }
          catch (e) {
            emit(BusLocationLossState('No Location found for this bus'));
          }
        }else {
          emit(permissiondenied());
        }
      }

    });
  }
}



abstract class buslocationState{}

class GetBusLocationState extends buslocationState{}

class permissiondenied extends buslocationState{}

class BusLocationGainedState extends buslocationState{
  String bususerid;
  GeoPoint location;
  BusLocationGainedState(this.location, this.bususerid);
}

class BusLocationLossState extends buslocationState{
  String? error;
  BusLocationLossState(this.error);
}

abstract class buslocationEvent{}

class GetBusLocatioEvent extends buslocationEvent{
  String? bususerid;
  GetBusLocatioEvent(this.bususerid);
}

class BusLocationGainedEvent extends buslocationEvent{

}

class BusLocationLossEvent extends buslocationEvent{}