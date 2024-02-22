// import 'package:ResellerSalesMobile/cores/bindings/binding_init.dart';
// import 'package:ResellerSalesMobile/cores/configs/config_app.dart';
// import 'package:ResellerSalesMobile/cores/configs/config_theme.dart';
// import 'package:ResellerSalesMobile/cores/data/models/user_model.dart';
// import 'package:ResellerSalesMobile/cores/data/providers/provider_pref.dart';
// import 'package:ResellerSalesMobile/cores/routes/pages.dart';
// import 'package:ResellerSalesMobile/cores/utils/NotificationHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'cores/bindings/binding_init.dart';
import 'cores/configs/config_app.dart';
import 'cores/configs/config_theme.dart';
import 'cores/data/models/user_model.dart';
import 'cores/routes/pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    Intl.defaultLocale = 'id_ID';
    initializeDateFormatting();
    // await initOneSignalPlatform();
    // final GoogleMapsFlutterPlatform mapsImplementation =
    //     GoogleMapsFlutterPlatform.instance;
    // if (mapsImplementation is GoogleMapsFlutterAndroid) {
    //   mapsImplementation.useAndroidViewSurface = true;
    //   initializeMapRenderer();
    // }
    if (ConfigApp.env == Env.production) {
      String? userModel =
      await PrefProvider.secureStorage.read(key: PrefProvider.USER_DATA);
      await SentryFlutter.init(
            (options) {
          options.dsn = ConfigApp.sentryDsn;
        },
        appRunner: () => runApp(const MyApp()),
      );
      if (userModel != null) {
        UserModel user = userModelFromJson(userModel);
        await Sentry.configureScope((scope) async => await scope.setUser(
          SentryUser(
            id: user.loginId,
            email: user.email,
            username: user.userName,
          ),
        ));
      }
    } else {
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sales Mobile Reseller',
      locale: const Locale('id', 'ID'),
      theme: ConfigTheme.lightTheme(context),
      initialRoute: Routes.INITIAL,
      unknownRoute: CorePages.unknownPage,
      getPages: CorePages.pages,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.cupertino,
      // routingCallback: (_) => print('Route: ${_?.current ?? 'Unknown Route'}'),
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

// Future<void> initOneSignalPlatform() async {
//   OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
//   OneSignal.shared.setNotificationOpenedHandler(
//           (result) => NotificationHandler.handleNotificationOpened(result));
//   await OneSignal.shared.setAppId(ConfigApp.oneSignalAPIKey);
// }
//
// Completer<AndroidMapRenderer?>? _initializedRendererCompleter;
//
// Future<AndroidMapRenderer?> initializeMapRenderer() async {
//   if (_initializedRendererCompleter != null) {
//     return _initializedRendererCompleter!.future;
//   }
//
//   final Completer<AndroidMapRenderer?> completer =
//   Completer<AndroidMapRenderer?>();
//   _initializedRendererCompleter = completer;
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final GoogleMapsFlutterPlatform mapsImplementation =
//       GoogleMapsFlutterPlatform.instance;
//   if (mapsImplementation is GoogleMapsFlutterAndroid) {
//     unawaited(mapsImplementation
//         .initializeWithRenderer(AndroidMapRenderer.latest)
//         .then((AndroidMapRenderer initializedRenderer) =>
//         completer.complete(initializedRenderer)));
//   } else {
//     completer.complete(null);
//   }
//
//   return completer.future;
// }
