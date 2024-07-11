import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/database_helper.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final DatabaseHelper databaseHelper;

  AppointmentBloc(this.databaseHelper) : super(AppointmentInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<AddAppointment>(_onAddAppointment);
    on<UpdateAppointment>(_onUpdateAppointment);
    on<DeleteAppointment>(_onDeleteAppointment);
    on<ToggleEditMode>(_onToggleEditMode);
    on<UpdateNameField>(_onUpdateNameField);
    on<UpdateDobField>(_onUpdateDobField);
    on<UpdateGenderField>(_onUpdateGenderField);
    on<UpdatePurposeField>(_onUpdatePurposeField);
    on<LoadAppointmentDetails>(_onLoadAppointmentDetails);

    // Emit initial state for adding a new appointment
    if (state is AppointmentInitial) {
      emit(AddEditAppointmentState(
        name: '',
        dob: '',
        gender: 'Male', // or null if you want it to be initially empty
        purpose: 'Purpose 1', // or null if you want it to be initially empty
        isEditing: false,
      ));
    }
  }

  Future<void> _onLoadAppointments(LoadAppointments event, Emitter<AppointmentState> emit) async {
    emit(AppointmentLoadInProgress());
    try {
      final appointments = await databaseHelper.queryAllAppointments();
      emit(AppointmentLoadSuccess(appointments));
    } catch (_) {
      emit(AppointmentOperationFailure());
    }
  }

  Future<void> _onAddAppointment(AddAppointment event, Emitter<AppointmentState> emit) async {
    try {
      await databaseHelper.insertAppointment(event.appointment);
      final appointments = await databaseHelper.queryAllAppointments();
      emit(AppointmentLoadSuccess(appointments));
    } catch (_) {
      emit(AppointmentOperationFailure());
    }
  }

  Future<void> _onUpdateAppointment(UpdateAppointment event, Emitter<AppointmentState> emit) async {
    try {
      await databaseHelper.updateAppointment(event.appointment);
      final appointments = await databaseHelper.queryAllAppointments();
      emit(AppointmentLoadSuccess(appointments));
    } catch (_) {
      emit(AppointmentOperationFailure());
    }
  }

  Future<void> _onDeleteAppointment(DeleteAppointment event, Emitter<AppointmentState> emit) async {
    try {
      await databaseHelper.deleteAppointment(event.id);
      final appointments = await databaseHelper.queryAllAppointments();
      emit(AppointmentLoadSuccess(appointments));
    } catch (_) {
      emit(AppointmentOperationFailure());
    }
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<AppointmentState> emit) {
    if (state is AddEditAppointmentState) {
      final currentState = state as AddEditAppointmentState;
      emit(currentState.copyWith(isEditing: !currentState.isEditing));
    }
  }

  void _onUpdateNameField(UpdateNameField event, Emitter<AppointmentState> emit) {
    if (state is AddEditAppointmentState) {
      final currentState = state as AddEditAppointmentState;
      emit(currentState.copyWith(name: event.name));
    }
  }

  void _onUpdateDobField(UpdateDobField event, Emitter<AppointmentState> emit) {
    if (state is AddEditAppointmentState) {
      final currentState = state as AddEditAppointmentState;
      emit(currentState.copyWith(dob: event.dob));
    }
  }

  void _onUpdateGenderField(UpdateGenderField event, Emitter<AppointmentState> emit) {
    if (state is AddEditAppointmentState) {
      final currentState = state as AddEditAppointmentState;
      emit(currentState.copyWith(gender: event.gender));
    }
  }

  void _onUpdatePurposeField(UpdatePurposeField event, Emitter<AppointmentState> emit) {
    if (state is AddEditAppointmentState) {
      final currentState = state as AddEditAppointmentState;
      emit(currentState.copyWith(purpose: event.purpose));
    }
  }

  void _onLoadAppointmentDetails(LoadAppointmentDetails event, Emitter<AppointmentState> emit) {
    emit(AddEditAppointmentState(
      name: event.appointment.name,
      dob: event.appointment.dateOfBirth,
      gender: event.appointment.gender,
      purpose: event.appointment.purpose,
      isEditing: false,
    ));
  }
}
