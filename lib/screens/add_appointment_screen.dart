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
import 'widgets.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentBloc(DatabaseHelper())..add(ToggleEditMode()),
      child: AddAppointmentForm(),
    );
  }
}

class AddAppointmentForm extends StatefulWidget {
  @override
  _AddAppointmentFormState createState() => _AddAppointmentFormState();
}

class _AddAppointmentFormState extends State<AddAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScreen(
      appBarText: 'Book Appoinment',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AddEditAppointmentState) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildTextField(
                      label: 'Name',
                      hintText: "Enter customer's name",
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
                            onChanged: (value) {
                              context
                                  .read<AppointmentBloc>()
                                  .add(UpdateNameField(value));
                            },
                            label: 'Date of birth',
                            hintText: 'DD-MM-YYYY',
                            controller: dobController,
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) {
                                context.read<AppointmentBloc>().add(
                                      UpdateDobField(DateFormat('dd-MM-yyyy')
                                          .format(picked)),
                                    );
                                dobController.text =
                                    DateFormat('dd-MM-yyyy').format(picked);
                              }
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
                            items: ['Male', 'Female'],
                            onChanged: (value) {
                              context
                                  .read<AppointmentBloc>()
                                  .add(UpdateGenderField(value!));
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
                      items: [
                        'Purpose 1',
                        'Purpose 2',
                        'Purpose 3',
                        'Purpose 4',
                        'Purpose 5'
                      ],
                      onChanged: (value) {
                        context
                            .read<AppointmentBloc>()
                            .add(UpdatePurposeField(value!));
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a purpose';
                        }
                        return null;
                      },
                    ),
                    Spacer(),
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
                            name: state.name,
                            dateOfBirth: state.dob,
                            gender: state.gender,
                            purpose: state.purpose,
                          );
                          context
                              .read<AppointmentBloc>()
                              .add(AddAppointment(appointment));
                          context.pushReplacement(RouteName.viewAppoinments);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added appoinment Successfully')));

                        }
                      },
                      child: Text('Book Now', style: TextStyle(fontSize: 18,color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
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
    required List<String> items,
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
          value: items[0],
          items: items
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
