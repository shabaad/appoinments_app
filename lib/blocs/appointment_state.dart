import 'package:equatable/equatable.dart';

import '../models/appointment.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoadInProgress extends AppointmentState {}

class AppointmentLoadSuccess extends AppointmentState {
  final List<Appointment> appointments;

  const AppointmentLoadSuccess([this.appointments = const []]);

  @override
  List<Object?> get props => [appointments];
}

class AppointmentOperationFailure extends AppointmentState {}

class AddEditAppointmentState extends AppointmentState {
  final String name;
  final String dob;
  final String gender;
  final String purpose;
  final bool isEditing;

  const AddEditAppointmentState({
    required this.name,
    required this.dob,
    required this.gender,
    required this.purpose,
    required this.isEditing,
  });

  AddEditAppointmentState copyWith({
    String? name,
    String? dob,
    String? gender,
    String? purpose,
    bool? isEditing,
  }) {
    return AddEditAppointmentState(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      purpose: purpose ?? this.purpose,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [name, dob, gender, purpose, isEditing];
}
