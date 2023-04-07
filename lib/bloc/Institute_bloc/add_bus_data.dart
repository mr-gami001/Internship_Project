

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Services/institute/student.dart';

import '../../Model/StudentModel.dart';
import '../../Services/institute/bus.dart';

class StudentfetchbusdataBloc extends Bloc<BusEvent, BusState> {


  StudentfetchbusdataBloc() : super(GetBusDataState()) {


    on<GetBusDataEvent>((event, emit) async {
      try{

        Bus bus = Bus();

        List<BusModel> data = await bus.fetchdata();
        if(data.isNotEmpty && data!= [{0}]){

          print(data.toString());

          print(data);
          emit(GetBusDataGainedState(data));
        }else{
          emit(StudentDataLostState());
        }



      }catch(e){
        emit(StudentDataLostState());
      }
    }

    );

  }



}


abstract class BusState{}

class GetBusDataState extends BusState{}

class GetBusDataGainedState extends BusState{
  List<BusModel> studentdata;
  GetBusDataGainedState(this.studentdata);
}

class StudentDataLostState extends BusState{}

abstract class BusEvent{}

class GetBusDataEvent extends BusEvent{}

class StudentDataLostEvent extends BusEvent{}