part of 'availability_bloc.dart';

class AvailabilityEvent extends Equatable {
  const AvailabilityEvent();

  @override
  List<Object> get props => [];
}

class UpdateAvailability extends AvailabilityEvent {
  final bool isAvailable;

  const UpdateAvailability(this.isAvailable);
}

class AvailabilityText extends AvailabilityEvent {
  final String availabilityText;

  const AvailabilityText(
    this.availabilityText,
  );
}
