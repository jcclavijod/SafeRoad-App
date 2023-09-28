import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saferoad/Auth/model/user_model.dart';
import 'package:saferoad/Map/Repository/qualificationRepository.dart';

part 'qualification_event.dart';
part 'qualification_state.dart';

class QualificationBloc extends Bloc<QualificationEvent, QualificationState> {
  QualificationBloc() : super(const QualificationState()) {
    on<RatingUpdated>(
        (event, emit) => emit(state.copyWith(rating: event.rating)));

    on<AddParameters>((event, emit) => emit(state.copyWith(
        mechanicUid: state.mechanicUid,
        mechanicPic: state.mechanicPic,
        mechanicLocal: state.mechanicLocal)));
  }
  final QualificationRepository qualificationRepository =
      QualificationRepository();

  void updateState(double rating) {
    add(RatingUpdated(rating));
  }

  void getDocuments(
      String mechanicId, String mechanicPic, String mechanicLocal) {
    print("°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°");
    print(mechanicId);
    print(mechanicPic);
    print(mechanicLocal);
    add(AddParameters(mechanicId, mechanicPic, mechanicLocal));
    print("°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°");
  }

  void setData() async {
    qualificationRepository.saveRating(state.rating, state.mechanicUid);
  }
}
