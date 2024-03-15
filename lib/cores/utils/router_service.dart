import 'package:flutter/material.dart';
// import 'package:forisa_attendance/pages/MapsPage.dart';
// import 'package:forisa_attendance/pages/pages.dart';

import '../../ui/pages/layout.dart';
import '../../ui/pages/login.dart';
import '../../ui/pages/notfound_page.dart';
import '../../ui/pages/onboarding.dart';
import '../../ui/pages/splash.dart';
import '../components/fullscreen_image.dart';
import '../models/model_arguments.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Splash());
    case '/login':
      return MaterialPageRoute(builder: (context) => Login());
    case '/onboarding':
      return MaterialPageRoute(builder: (context) => Onboarding());
    case '/layout':
      return MaterialPageRoute(
          builder: (context) =>
              MainLayout(settings.arguments as ScreenArguments));
    // case '/maps':
    //   return MaterialPageRoute(
    //       builder: (context) => MapsPage(
    //             settings.arguments as ScreenArguments?,
    //           ));
    default:
      return MaterialPageRoute(builder: (context) => NotFound());
  }
}

class RouterService {
  static Future push(
      {required BuildContext context, required Widget page}) async {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  static Future imageViewerPage(
      {required BuildContext context, required String url}) async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImage('', [url], true),
      ),
    );
  }
}
