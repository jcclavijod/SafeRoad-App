part of 'cause_failure_bloc.dart';

class CauseFailureState extends Equatable {
  final List<CauseOfFailure> causeOptions;
  final String selectedOption;

  const CauseFailureState({
    this.causeOptions = const [],
    this.selectedOption = "",
  });

  CauseFailureState copyWith({
    List<CauseOfFailure>? causeOptions,
    String? selectedOption
  }) =>
      CauseFailureState(
        causeOptions: causeOptions ?? this.causeOptions,
        selectedOption: selectedOption ?? this.selectedOption,
      );

  @override
  List<Object> get props => [causeOptions,selectedOption];
}
