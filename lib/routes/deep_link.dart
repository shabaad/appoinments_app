import 'dart:developer';

import 'package:appoinments_app/routes/route_names.dart';
import 'package:appoinments_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

class AppLinksHandler {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> handleAppLinks(BuildContext context) async {
    _appLinks.getInitialAppLink().then((link) {
      if (link != null) {
        log(link.toString());
        _navigateToRoute(context, link.toString());
      }
    });

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        log(uri.toString());

        _navigateToRoute(context, uri.toString());
      }
    });
  }

  static void _navigateToRoute(BuildContext context, String url)async {
    final Uri uri = Uri.parse(url);
    log(uri.path.toString());

    switch (uri.path) {
      case RouteName.viewAppoinments:
        router.push(RouteName.viewAppoinments);
        break;
      case RouteName.addAppoinment:
        router.push(RouteName.addAppoinment);
        break;
      case RouteName.editAppointment:
        final String? id = uri.queryParameters['id'];
        if (id != null) {
          router.push(RouteName.editAppointment);
        }
        break;
      default:
        router.push(RouteName.home);
        break;
    }
  }
}
