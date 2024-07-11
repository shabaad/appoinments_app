import 'package:appoinments_app/screens/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../blocs/appointment_bloc.dart';
import '../blocs/appointment_event.dart';
import '../blocs/appointment_state.dart';
import '../database/database_helper.dart';
import '../models/appointment.dart';
import '../routes/route_names.dart';

class ViewAppointmentScreen extends StatelessWidget {
  final Appointment appointment;

  ViewAppointmentScreen({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(DatabaseHelper())
        ..add(LoadAppointmentDetails(appointment)),
      child: ViewAppointmentForm(appointment: appointment),
    );
  }
}

class ViewAppointmentForm extends StatefulWidget {
  final Appointment appointment;

  const ViewAppointmentForm({Key? key, required this.appointment})
      : super(key: key);

  @override
  _ViewAppointmentFormState createState() => _ViewAppointmentFormState();
}

class _ViewAppointmentFormState extends State<ViewAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dobController.text = widget.appointment.dateOfBirth;
    nameController.text = widget.appointment.name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AddEditAppointmentState) {
          return GradientBackgroundScreen(
            appBarText:
                state.isEditing ? 'Edit Appointment' : 'View Appointment',
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildTextField(
                      label: 'Name',
                      hintText: "Enter customer's name",
                      controller: nameController,
                      readOnly: !state.isEditing,
                      onChanged: (value) {
                        context
                            .read<AppointmentBloc>()
                            .add(UpdateNameField(value));
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Date of birth',
                            hintText: 'DD-MM-YYYY',
                            controller: dobController,
                            readOnly: true,
                            onTap: state.isEditing
                                ? () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      context.read<AppointmentBloc>().add(
                                            UpdateDobField(
                                                DateFormat('dd-MM-yyyy')
                                                    .format(picked)),
                                          );
                                      dobController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(picked);
                                    }
                                  }
                                : null,
                            onChanged: (value) {
                              context
                                  .read<AppointmentBloc>()
                                  .add(UpdateDobField(value));
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Gender',
                            value: state.gender,
                            items: ['Male', 'Female'],
                            enabled: state.isEditing, // Conditionally enable
                            onChanged: (value) {
                              if (state.isEditing) {
                                context
                                    .read<AppointmentBloc>()
                                    .add(UpdateGenderField(value!));
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildDropdownField(
                      label: 'Purpose',
                      value: state.purpose,
                      items: [
                        'Purpose 1',
                        'Purpose 2',
                        'Purpose 3',
                        'Purpose 4',
                        'Purpose 5'
                      ],
                      enabled: state.isEditing, // Conditionally enable
                      onChanged: (value) {
                        if (state.isEditing) {
                          context
                              .read<AppointmentBloc>()
                              .add(UpdatePurposeField(value!));
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a purpose';
                        }
                        return null;
                      },
                    ),
                    Spacer(),
                    if (!state.isEditing)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.read<AppointmentBloc>().add(ToggleEditMode());
                        },
                        child: Text(
                          'Edit Details',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (state.isEditing)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final appointment = Appointment(
                              id: widget.appointment.id,
                              name: state.name,
                              dateOfBirth: state.dob,
                              gender: state.gender,
                              purpose: state.purpose,
                            );
                            context
                                .read<AppointmentBloc>()
                                .add(UpdateAppointment(appointment));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Updated appoinment Successfully')));
                          }
                        },
                        child: Text(
                          'Update Appoinment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    SizedBox(width: 16),
                    if (!state.isEditing)
                      Center(
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<AppointmentBloc>()
                                .add(DeleteAppointment(widget.appointment.id!));
                            context.pushReplacement(RouteName.viewAppoinments);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Deleted Successfully')));
                          },
                          child: Text(
                            'Delete Appointment',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    bool readOnly = false,
    void Function()? onTap,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Color(0xFF202020),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    bool enabled = true,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF202020),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: value,
          items: items
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          disabledHint: Text(value,
              style: TextStyle(
                  color: Colors.white)), // Display current value when disabled
        ),
      ],
    );
  }
}
