import 'package:appoinments_app/screens/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../blocs/appointment_bloc.dart';
import '../blocs/appointment_event.dart';
import '../blocs/appointment_state.dart';
import '../database/database_helper.dart';
import '../routes/route_names.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(DatabaseHelper())..add(LoadAppointments()),
      child: GradientBackgroundScreen(
             appBarText: 'View Appoinments',

        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AppointmentLoadSuccess) {
              final appointments = state.appointments;
              return ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return Card(
                    color: Color(0xFF202020),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        appointment.name,
                        style: TextStyle(color: Colors.white),
                      ),
                     
                      trailing: TextButton(
                        onPressed: () async {
                          await context.push(RouteName.editAppointment, extra: appointment);
                          context.read<AppointmentBloc>().add(LoadAppointments());
                        },
                        child: Text(
                          'View',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AppointmentOperationFailure) {
              return Center(child: Text('Failed to load appointments', style: TextStyle(color: Colors.white)));
            } else {
              return Center(child: Text('No appointments found', style: TextStyle(color: Colors.white)));
            }
          },
        ),
      ),
    );
  }
}