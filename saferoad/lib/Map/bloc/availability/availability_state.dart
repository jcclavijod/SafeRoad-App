part of 'availability_bloc.dart';

class AvailabilityState extends Equatable {
  final bool isAvailable;
  final String availabilityText;

  const AvailabilityState(
      {this.isAvailable = false, this.availabilityText = "Desconectado"});

  AvailabilityState copyWith({bool? isAvailable, String? availabilityText}) =>
      AvailabilityState(
          isAvailable: isAvailable ?? this.isAvailable,
          availabilityText: availabilityText ?? this.availabilityText);

  @override
  List<Object> get props => [isAvailable, availabilityText];
}
