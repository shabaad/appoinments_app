import 'package:appoinments_app/database/database_helper.dart';
import 'package:appoinments_app/routes/route_names.dart';
import 'package:appoinments_app/screens/home_screen.dart';
import 'package:go_router/go_router.dart';
import '../models/appointment.dart';
import '../screens/add_appointment_screen.dart';
import '../screens/appointments_list_screen.dart';
import '../screens/view_appointment_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => HomeScreen(),
    ),
     GoRoute(
      path: RouteName.viewAppoinments,
      builder: (context, state) => AppointmentsListScreen(),
    ),
    GoRoute(
      path: RouteName.addAppoinment,
      builder: (context, state) => AddAppointmentScreen(),
    ),
    GoRoute(
      path: RouteName.editAppointment,
      builder: (context, state) {
        final appointment = state.extra as Appointment;
        return ViewAppointmentScreen(appointment: appointment);
      },
    ),
  ],
);