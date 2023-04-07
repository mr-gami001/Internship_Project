

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/ParentsModel.dart';
import 'package:let_me_check/Model/StudentModel.dart';

class SelectedParentDataBloc extends Bloc<StudentDataEvent,StudentDataState>{
  SelectedParentDataBloc() : super(FetchStudentDataState()){


    on<FetchStudentDataEvent>((event, emit) async{

      try{
        emit(FetchStudentDataState());

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot studentdoc = await firestore.collection('parents').doc(event.userid.toString()).get();
        var temp = await studentdoc.data();
        print(temp);
        ParentsModel data = await ParentsModel.fromJson(temp as Map<String,dynamic>);

        //print(data);
        if(data != null){
          emit(FetchedStudentDataState(data));
        }
        else{
          emit(LostStudentDataState('Error to get Data'));
        }

      } catch(e){
        print(e.toString());
        emit(LostStudentDataState(e.toString()));
      }

    });

  }
}

abstract class StudentDataState{}

class FetchStudentDataState extends StudentDataState{}

class FetchedStudentDataState extends StudentDataState{
  ParentsModel? data;
  FetchedStudentDataState(this.data);
}

class LostStudentDataState extends StudentDataState{
  String? error;
  LostStudentDataState(this.error);
}

abstract class StudentDataEvent{}

class FetchStudentDataEvent extends StudentDataEvent{
  String? userid;
  FetchStudentDataEvent(this.userid);
}

class FetchedStudentDataEvent extends StudentDataEvent{}

class LostStudentDataEvent extends StudentDataEvent{}