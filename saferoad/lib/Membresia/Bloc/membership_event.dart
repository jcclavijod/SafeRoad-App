abstract class MembresiaEvent {}

class UpdateSelectedDurationEvent extends MembresiaEvent {
  final int newDuration;

  UpdateSelectedDurationEvent(this.newDuration);
}

class AddMembresiaEvent extends MembresiaEvent {
  final String uid;
  final int selectedDuration;

  AddMembresiaEvent(this.uid, this.selectedDuration);
}
