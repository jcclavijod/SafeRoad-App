part of 'cause_failure_bloc.dart';

class CauseFailureEvent extends Equatable {
  const CauseFailureEvent();

  @override
  List<Object> get props => [];
}


class AddCauseFailureList extends CauseFailureEvent {
  final List<CauseOfFailure> causeOptions;
  const AddCauseFailureList(this.causeOptions);
}

class AddSelectedOption extends CauseFailureEvent {
  final String selectedOption;
  const AddSelectedOption(this.selectedOption);
}