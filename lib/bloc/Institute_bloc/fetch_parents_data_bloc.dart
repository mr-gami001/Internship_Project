

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Services/institute/Parents.dart';

class ParentsDataBloc extends Bloc<ParentsDataEvent,ParentsDataState>{
  ParentsDataBloc() : super(FetchParentsDataState()){

    on<FetchParentsDataEvent>((event, emit) async{

      try{

        Parents parents = Parents();
        List<ParentsModel> data = await parents.fetchAllParentsdata();
        if(data.isNotEmpty || data != []){
          emit(FetchedParentsDataState(data));
        }
        else{
          emit(LostParentsDataState('Error to get Data'));
        }

      } catch(e){
        emit(LostParentsDataState(e.toString()));
      }

    });

  }
}

abstract class ParentsDataState{}

class FetchParentsDataState extends ParentsDataState{}

class FetchedParentsDataState extends ParentsDataState{
  List<ParentsModel> data;
  FetchedParentsDataState(this.data);
}

class LostParentsDataState extends ParentsDataState{
  String? error;
  LostParentsDataState(this.error);
}

abstract class ParentsDataEvent{}

class FetchParentsDataEvent extends ParentsDataEvent{}

class FetchedParentsDataEvent extends ParentsDataEvent{}

class LostParentsDataEvent extends ParentsDataEvent{}