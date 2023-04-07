

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:let_me_check/Model/StudentModel.dart';
import 'package:let_me_check/Services/institute/student.dart';

class TempstudentfetchdataBloc extends Bloc<TempStudentdataEvent, TempStudentdataState> {


  TempstudentfetchdataBloc() : super(TempStudentInitialdataState()) {


    on<fetchTempStudentdataEvent>((event, emit) async {
      try{

        Student student = Student();
        List<StudentModel> data = await student.fetchallstudentsdata();
        print(data.toString());
        if(data.isNotEmpty && data!= [{0}]){
          print(data);
          emit(TempStudentdatagainedState(data));
        }else{
          emit(TempStudentdatalostState());
        }



      }catch(e){
        emit(TempStudentdataerrorState());
      }
    }

    );

  }



}



abstract class TempStudentdataState{}

class TempStudentInitialdataState extends TempStudentdataState{}

class NetworkErrorSatate extends TempStudentdataState{}

class TempStudentdatalostState extends TempStudentdataState{}

class TempStudentdatagainedState extends TempStudentdataState{
  final List<StudentModel> data;
  TempStudentdatagainedState(this.data);
}

class TempStudentdataerrorState extends TempStudentdataState{}



abstract class TempStudentdataEvent{}

class fetchTempStudentdataEvent extends TempStudentdataEvent{}

class TempStudentdatalostEvent extends TempStudentdataEvent{}

class TempStudentdatagainedEvent extends TempStudentdataEvent{}

class TempStudentdataerrorEvent extends TempStudentdataEvent{}