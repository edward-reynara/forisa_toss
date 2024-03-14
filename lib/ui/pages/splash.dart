import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:forisa_attendance/components/error_future_component.dart';
// import 'package:forisa_attendance/components/loaders.dart';
// import 'package:forisa_attendance/config/config.dart';
// import 'package:forisa_attendance/config/states.dart';
// import 'package:forisa_attendance/models/model_app_version.dart';
// import 'package:forisa_attendance/models/model_arguments.dart';
// import 'package:forisa_attendance/utils/api_service.dart';
// import 'package:forisa_attendance/utils/constants.dart';
// import 'package:forisa_attendance/utils/locator.dart';
// import 'package:forisa_attendance/utils/route_obeserver.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../cores/components/error_future_component.dart';
import '../../cores/components/loaders.dart';
import '../../cores/configs/config.dart';
import '../../cores/configs/states.dart';
import '../../cores/models/model_app_version.dart';
import '../../cores/models/model_arguments.dart';
import '../../cores/utils/api_service.dart';
import '../../cores/utils/constants.dart';
import '../../cores/utils/locator.dart';
import '../../cores/utils/route_obeserver.dart';
import '../../cores/utils/tools.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with RouteAware {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  ApiService apiService = ApiService();
  late PackageInfo _packageInfo;
  late AppVersion _appVersion;
  late Future _future;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPush() {
    locator<RouteObserverService>().setCurrentPage('splash');
  }

  @override
  void initState() {
    super.initState();
    locator<RouteObserverService>().setCurrentPage('splash');
    _future = checkVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      IMG.logo,
                      scale: 1.4,
                    ),
                    defaultLoader(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Memeriksa perangkat...',
                        ),
                        Text(Config.env.name),
                      ],
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasError) {
              AppVersion appVersion = _appVersion;

              if (appVersion.version == -1) {
                return Container();
              }

              if (int.parse(_packageInfo.buildNumber) >=
                  appVersion.minVersion) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          IMG.logo,
                          scale: 1.4,
                        ),
                      ),
                      defaultLoader(),
                      Text(
                        'Mengarahkan ke home screen...',
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 250.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image:
                                  AssetImage(IMG.iconSuccess),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Update tersedia !',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Versi aplikasi anda sudah terlalu lama',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            shape: MaterialStateProperty.all(StadiumBorder()),
                          ),
                          icon: Icon(
                            FontAwesomeIcons.cloudDownloadAlt,
                            color: Colors.white,
                            size: 14.0,
                          ),
                          label: Text(
                            'Download',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            downloadUpdate(appVersion);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else {
              return errorFutureContainer(
                  error: snapshot.error,
                  callback: () {
                    setState(() {
                      _future = checkVersion();
                    });
                  },
                  context: context);
            }
          }),
    );
  }

  checkVersion() async {
    Dio dio = apiService.getApiClient(context: context);
    Response response;
    AppVersion appVersion;

    try {
      response = await dio.get('/version', queryParameters: {
        'platform': Platform.operatingSystem
      });
      appVersion = AppVersion.fromJson(response.data);

      String? buildNumber = await secureStorage.read(key: 'build_number');

      if (buildNumber == null) {
        await secureStorage.write(
            key: 'build_number', value: _packageInfo.buildNumber);
      } else {
        if (int.parse(_packageInfo.buildNumber) > int.parse(buildNumber)) {
          // ApiService.getCacheManager().clearAll();
          await secureStorage.write(
              key: 'build_number', value: _packageInfo.buildNumber);
          // print('Cache cleared!');
        }
      }

      if (int.parse(_packageInfo.buildNumber) >= appVersion.minVersion) {
        await goTo(appVersion.version.toString(), appVersion.appUrl);
      }

      setState(() {
        _appVersion = appVersion;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> downloadUpdate(AppVersion appVersion) async {
    try {
      await launchUrlString(appVersion.appUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      Tools.showAlert(context, 'Exception', 'Gagal membuka link', 'error');
    }
  }

  Future<void> goTo(String version, String url) async {
    await secureStorage.write(key: 'app_version', value: version);
    await secureStorage.write(key: 'app_url', value: url);
    String? doneIntro = await secureStorage.read(key: 'intro');
    await initStore();

    if (doneIntro == 'true') {
      String? token = await secureStorage.read(key: 'token');
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/layout',
            arguments: ScreenArguments(stringData: token));
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  Future<void> initStore() async {
    String? token = await secureStorage.read(key: 'token');
    if (token != null) {
      locator<States>().headers['Authorization'] = 'Bearer $token';
    }
  }
}
