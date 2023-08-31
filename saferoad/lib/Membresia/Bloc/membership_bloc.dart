import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:saferoad/Membresia/model/membresia_model.dart';
import 'package:saferoad/Membresia/repository/membresia_repository.dart';

class MembresiaBloc {
  final MembresiaRepository _repository = MembresiaRepository();
  final _selectedDuration = BehaviorSubject<int>.seeded(1);
  Stream<int> get selectedDurationStream => _selectedDuration.stream;
  int get selectedDuration => _selectedDuration.value;

  void updateSelectedDuration(int newDuration) {
    _selectedDuration.add(newDuration);
  }

  Future<bool> checkActiveMembership(String uid) async {
    return await _repository.checkActiveMembership(uid);
  }

  Future<membresiaModel> getActiveMembership(String uid) async {
    return await _repository.getActiveMembership(uid);
  }

  Future<void> addMembresia(String uid, int selectedDuration) async {
    double monthlyCost = 20000;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final hasActiveMembership = await _repository.checkActiveMembership(uid);
      if (hasActiveMembership) {
        print('El usuario ya tiene una membresía activa.');
        return;
      }

      final planName = selectedPlan(selectedDuration);
      final membresia = membresiaModel(
        uid: user.uid,
        membresia: planName,
        precio: calculateCost(selectedDuration).toString(),
        fechaInicial: DateTime.now().toString(),
        fechaFinal: DateTime.now()
            .add(Duration(days: 30 * selectedDuration))
            .toString(),
        estado: 'Activo',
      );

      await _repository.addMembresia(membresia);
      print('Membresía agregada');
    } else {
      print('Usuario no autenticado');
    }
  }

  String selectedPlan(int duration) {
    switch (duration) {
      case 1:
        return 'Mensual';
      case 6:
        return 'Semestral';
      case 12:
        return 'Anual';
      default:
        return 'Mensual';
    }
  }

  int calculateCost(int months) {
    double monthlyCost = 20000;
    return (monthlyCost * months).toInt();
  }

  void dispose() {
    _selectedDuration.close();
  }
}
