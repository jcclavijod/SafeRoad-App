import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final QualificationRepository qualificationRepository = QualificationRepository(
    firestore: FirebaseFirestore.instance,
    user: FirebaseAuth.instance.currentUser,
  );

  void updateState(double rating) {
    add(RatingUpdated(rating));
  }

  void getDocuments(
      String mechanicId, String mechanicPic, String mechanicLocal) {
    add(AddParameters(mechanicId, mechanicPic, mechanicLocal));
  }

  void setData() async {
    qualificationRepository.saveRating(state.rating, state.mechanicUid);
  }
}
