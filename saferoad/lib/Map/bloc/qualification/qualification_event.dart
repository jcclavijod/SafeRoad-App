part of 'qualification_bloc.dart';

class QualificationEvent extends Equatable {
  const QualificationEvent();

  @override
  List<Object> get props => [];
}

class RatingUpdated extends QualificationEvent {
  final double rating;

  const RatingUpdated(
    this.rating,
  );
}

class AddParameters extends QualificationEvent {
  final String mechanicUid;
  final String mechanicPic;
  final String mechanicLocal;

  const AddParameters(this.mechanicUid, this.mechanicPic, this.mechanicLocal);
}
