part of 'qualification_bloc.dart';

class QualificationState extends Equatable {
  final double rating;
  final String mechanicUid;
  final String mechanicPic;
  final String mechanicLocal;

  const QualificationState(
      {this.rating = 0,
      this.mechanicPic = "",
      this.mechanicLocal = "",
      this.mechanicUid = ""});

  QualificationState copyWith(
          {double? rating,
          String? mechanicUid,
          String? mechanicPic,
          String? mechanicLocal}) =>
      QualificationState(
        rating: rating ?? this.rating,
        mechanicUid: mechanicUid ?? this.mechanicUid,
        mechanicPic: mechanicPic ?? this.mechanicPic,
        mechanicLocal: mechanicLocal ?? this.mechanicLocal,
      );

  @override
  List<Object> get props => [rating, mechanicUid, mechanicPic, mechanicLocal];
}
