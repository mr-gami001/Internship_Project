
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/BusModel.dart';

class home_instBloc extends Bloc<home_instEvent,home_instState>{
  home_instBloc() : super(initialState()){

    on<initialEvent>((event, emit) async{

      emit(initialState());
      try{
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        QuerySnapshot temp = await firestore.collection('bus').get();
        List<BusModel> data = [];
        for (var items in temp.docs){
          BusModel busModel = BusModel.fromJson(items);
          data.add(
            busModel
          );
        }
        if(data != null || data != []) {
          print('data received');
          emit(DataGainedState(data));
        }


      }catch(e){
        emit(DataLossState());
      }


    });

  }
}

abstract class home_instState{}

class initialState extends home_instState{}

class DataGainedState extends home_instState{
  List<BusModel> data;
  DataGainedState(this.data);
}

class DataLossState extends home_instState{}

abstract class home_instEvent{}

class initialEvent extends home_instEvent{
}

class DataGainedEvent extends home_instEvent{}

class DatalossEvent extends home_instEvent{}