import 'package:equatable/equatable.dart';

import '../models/appointment.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointments extends AppointmentEvent {}

class AddAppointment extends AppointmentEvent {
  final Appointment appointment;

  const AddAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class UpdateAppointment extends AppointmentEvent {
  final Appointment appointment;

  const UpdateAppointment(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class DeleteAppointment extends AppointmentEvent {
  final int id;

  const DeleteAppointment(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleEditMode extends AppointmentEvent {}

class UpdateNameField extends AppointmentEvent {
  final String name;

  const UpdateNameField(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateDobField extends AppointmentEvent {
  final String dob;

  const UpdateDobField(this.dob);

  @override
  List<Object?> get props => [dob];
}

class UpdateGenderField extends AppointmentEvent {
  final String gender;

  const UpdateGenderField(this.gender);

  @override
  List<Object?> get props => [gender];
}

class UpdatePurposeField extends AppointmentEvent {
  final String purpose;

  const UpdatePurposeField(this.purpose);

  @override
  List<Object?> get props => [purpose];
}

class LoadAppointmentDetails extends AppointmentEvent {
  final Appointment appointment;

  const LoadAppointmentDetails(this.appointment);

  @override
  List<Object?> get props => [appointment];
}
