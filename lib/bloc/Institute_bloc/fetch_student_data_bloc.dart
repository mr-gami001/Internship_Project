

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/student.dart';

class StudentDataBloc extends Bloc<StudentDataEvent,StudentDataState>{
  StudentDataBloc() : super(FetchStudentDataState()){

    on<FetchStudentDataEvent>((event, emit) async{

      try{

        Student student = Student();
        List<StudentModel> data = await student.fetchallstudentsdata();
        if(data.isNotEmpty || data != []){
          emit(FetchedStudentDataState(data));
        }
        else{
          emit(LostStudentDataState('Error to get Data'));
        }

      } catch(e){
        emit(LostStudentDataState(e.toString()));
      }

    });

  }
}

abstract class StudentDataState{}

class FetchStudentDataState extends StudentDataState{}

class FetchedStudentDataState extends StudentDataState{
  List<StudentModel> data;
  FetchedStudentDataState(this.data);
}

class LostStudentDataState extends StudentDataState{
  String? error;
  LostStudentDataState(this.error);
}

abstract class StudentDataEvent{}

class FetchStudentDataEvent extends StudentDataEvent{}

class FetchedStudentDataEvent extends StudentDataEvent{}

class LostStudentDataEvent extends StudentDataEvent{}