
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Model/StudentModel.dart';
import '../../Services/institute/student.dart';

class StudentDataBusAssociateBloc extends Bloc<studentbusassociateEvent, studentbusassociateState>{
  StudentDataBusAssociateBloc() : super(InitState()) {

    on<InitEvent>((event, emit) async {
      emit(InitState());

      Student student = Student();
      List<StudentModel> studentdata = await student.fetchallstudentsdata();
      List<StudentModel> templist = [];
      print(event.busid);
      for(StudentModel items in studentdata){
        if(items.busno.toString() == event.busid.toString()){
          templist.add(items);
        }
      }
      print(templist);
      if(templist.isNotEmpty){
        emit(DataGainedState(templist));
      }

      else if (templist.isEmpty){
        emit(NullDataState());
      }

      else{ emit(DataLossState());}

    });

  }
}


abstract class studentbusassociateState{}

class InitState extends studentbusassociateState{}

class DataGainedState extends studentbusassociateState{
  List<StudentModel> filteredData;
  DataGainedState(this.filteredData);
}

class NullDataState extends studentbusassociateState{}

class DataLossState extends studentbusassociateState{}


abstract class studentbusassociateEvent{}

class InitEvent extends studentbusassociateEvent{
  String? busid ;
  InitEvent(this.busid);
}

class DataGainedEvent extends studentbusassociateEvent{}