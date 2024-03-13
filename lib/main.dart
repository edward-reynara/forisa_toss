import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:forisa_attendance/utils/one_signal_opened_handler.dart';
import 'package:forisa_toss/ui/pages/notfound_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'cores/configs/config.dart';
import 'cores/utils/router_service.dart' as router;
import 'cores/utils/locator.dart';
import 'cores/utils/navigation_service.dart';
import 'cores/utils/route_obeserver.dart';

FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    setupLocator();
    Intl.defaultLocale = 'id_ID';
    await initializeDateFormatting();
    //await Jiffy.locale('id');
    await Jiffy.setLocale('id');
    if (!Config.isDebugMode) {
      // await initOneSignalPlatform();
      String? nik = await _secureStorage.read(key: 'nik');
      String? name = await _secureStorage.read(key: 'name');

      await SentryFlutter.init(
            (options) {
          options.dsn = Config.sentryDsn;
        },
        appRunner: () => runApp(MyApp()),
      );
      await Sentry.configureScope((scope) async => await scope.setUser(
        SentryUser(
          id: nik ?? '0',
          username: name ?? 'New User',
        ),
      ));
    } else {
      runApp(MyApp());
    }
    configLoading();
  });
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.dark
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false;
}

// Future<void> initOneSignalPlatform() async {
//   OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
//   OneSignal.shared.setNotificationOpenedHandler(
//           (result) => OnesignalOpenedHandler.handleNotification(result));
//   await OneSignal.shared.setAppId(Config.onesignalAppId);
// }

// Future<ByteData> loadCert() async {
//   ByteData bytes = await rootBundle.load('assets/images/forisa.pem');
//
//   return bytes;
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: (Config.isDebugMode),
      theme: ThemeData(
        canvasColor: Colors.grey[200],
        primaryColor: Colors.green,
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: Colors.green, secondary: Colors.orange),
      ),
      // home: Splash(),
      initialRoute: '/',
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (settings) => router.generateRoute(settings),
      onUnknownRoute: (RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (context) => NotFound(),
      ),
      navigatorObservers: [
        locator<RouteObserverService>().routeObserver,
        SentryNavigatorObserver(),
      ],
      builder: EasyLoading.init(),
    );
  }
}
