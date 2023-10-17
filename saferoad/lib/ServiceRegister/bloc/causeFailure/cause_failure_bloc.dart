import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/ServiceRegister/Repository/causeFailuresRepository.dart';
import 'package:saferoad/ServiceRegister/model/causeFailure.dart';

part 'cause_failure_event.dart';
part 'cause_failure_state.dart';

class CauseFailureBloc extends Bloc<CauseFailureEvent, CauseFailureState> {
  CauseFailureRepository causeFailureRepo = CauseFailureRepository(
      causeFailureInstance: FirebaseFirestore.instance);

  CauseFailureBloc() : super(const CauseFailureState()) {
    on<CauseFailureEvent>((event, emit) {});

    on<AddCauseFailureList>((event, emit) =>
        emit(state.copyWith(causeOptions: event.causeOptions)));

    on<AddSelectedOption>((event, emit) =>
        emit(state.copyWith(selectedOption: event.selectedOption)));
  }

  void saveList() async {
    List<CauseOfFailure> options =
        await causeFailureRepo.fetchCausesOfFailure();
    print(options.length);
    add(AddCauseFailureList(options));
  }

  void saveSelectedOption(String request,String selectedOption) {
    causeFailureRepo.addCauseFailure(request,selectedOption);
    //add(AddSelectedOption(selectedOption));
  }
}
