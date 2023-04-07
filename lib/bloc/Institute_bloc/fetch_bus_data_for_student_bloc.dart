
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/BusModel.dart';
import 'package:let_me_check/Services/institute/bus.dart';

class BusfetchdataBloc extends Bloc<BusdataEvent, BusdataState> {


  BusfetchdataBloc() : super(InitialdataState()) {


    on<fetchdataEvent>((event, emit) async {
      try{

          Bus bus = Bus();
          List<BusModel> data = await bus.fetchdata();
          print(data.toString());
          if(data.isNotEmpty && data!= [{0}]){
            print(data);
            emit(datagainedState(data));
          }else{
            emit(datalostState());
          }



      }catch(e){
        emit(dataerrorState());
      }
      }

    );

  }



}



abstract class BusdataState{}

class InitialdataState extends BusdataState{}

class NetworkErrorSatate extends BusdataState{}

class datalostState extends BusdataState{}

class datagainedState extends BusdataState{
  final List data;
  datagainedState(this.data);
}

class dataerrorState extends BusdataState{}



abstract class BusdataEvent{}

class fetchdataEvent extends BusdataEvent{}

class datalostEvent extends BusdataEvent{}

class datagainedEvent extends BusdataEvent{}

class dataerrorEvent extends BusdataEvent{}