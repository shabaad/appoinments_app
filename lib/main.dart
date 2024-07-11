import 'package:appoinments_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/appointment_bloc.dart';
import 'blocs/appointment_event.dart';
import 'database/database_helper.dart';
import 'routes/deep_link.dart';
import 'screens/appointments_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentBloc(DatabaseHelper())..add(LoadAppointments()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        title: 'Appointment App',
         theme: ThemeData.dark(),
        builder: (context, child) {
        AppLinksHandler.handleAppLinks(context);
        return child!;}
      ),
    );
  }
}
