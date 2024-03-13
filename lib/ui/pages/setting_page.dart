import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_toss/ui/pages/webview_page.dart';
// import 'package:forisa_attendance/components/error_future_component.dart';
// import 'package:forisa_attendance/components/overlay_appbar.dart';
// import 'package:forisa_attendance/components/shimmers.dart';
// import 'package:forisa_attendance/components/submit_button.dart';
// import 'package:forisa_attendance/config/config.dart';
// import 'package:forisa_attendance/models/model_arguments.dart';
// import 'package:forisa_attendance/pages/webview_page.dart';
// import 'package:forisa_attendance/utils/constants.dart';
// import 'package:forisa_attendance/utils/tools.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../cores/components/error_future_component.dart';
import '../../cores/components/overlay_appbar.dart';
import '../../cores/components/shimmers.dart';
import '../../cores/components/submit_button.dart';
import '../../cores/configs/config.dart';
import '../../cores/models/model_arguments.dart';
import '../../cores/utils/constants.dart';
import '../../cores/utils/tools.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PackageInfo? _packageInfo;
  List<String>? deviceInfo;
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = loadPackageInfo();
    Tools.getDeviceDetails().then((info) {
      deviceInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(title: 'Pengaturan'),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: fullWidthColShimmer(true),
              );
            }

            if (!snapshot.hasError) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: constBottomNavbarPadding),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        'Akun',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/changepassword',
                                arguments: ScreenArguments(
                                    titleMenu: 'Ganti Password')),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.green,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text('Ganti Password'),
                                  ],
                                ),
                                Icon(
                                  FontAwesomeIcons.arrowRight,
                                  color: Colors.grey,
                                  size: 14.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Data perangkat
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        'Perangkat',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('Model'),
                                ],
                              ),
                              Text(this.deviceInfo?[0] ?? '-'),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('Sistem Operasi'),
                                ],
                              ),
                              Text(this.deviceInfo?[1] ?? '-'),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('Id Perangkat'),
                                ],
                              ),
                              Text(this.deviceInfo?[2] ?? '-'),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          GestureDetector(
                            onTap: () {
                              Tools.showAlert(context, 'Cache',
                                  'Hapus Cache berhasil', 'success');
                              // ApiService.getCacheManager().clearAll().then(
                              //     (value) => );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('Hapus Cache'),
                                  ],
                                ),
                                Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.grey,
                                  size: 14.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        'Tentang',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.code,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text('Versi Aplikasi'),
                                ],
                              ),
                              Text(_packageInfo?.version ?? '-'),
                            ],
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => WebviewPage(
                                'Panduan Penggunaan',
                                Config.webUrl + '/panduan',
                              ),
                            )),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.book,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Panduan Penggunaan'),
                                    ],
                                  ),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.grey,
                                    size: 14.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => WebviewPage(
                                'Kebijakan Privasi',
                                Config.webUrl + '/kebijakan-privasi',
                              ),
                            )),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.shieldAlt,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Kebijakan Privasi'),
                                    ],
                                  ),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.grey,
                                    size: 14.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 20.0,
                            thickness: 2.0,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => WebviewPage(
                                'Pusat Bantuan',
                                Config.webUrl + '/pusat-bantuan',
                              ),
                            )),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.questionCircle,
                                        color: Colors.green,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text('Pusat Bantuan'),
                                    ],
                                  ),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.grey,
                                    size: 14.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: buttonCompact(
                        iconData: FontAwesomeIcons.signOutAlt,
                        onPressed: () {
                          Tools.logoutApp(context: context);
                        },
                        text: 'Logout',
                        buttonColor: Colors.red[500],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return errorFutureContainer(
                  error: snapshot.error,
                  context: context,
                  callback: () {
                    setState(() {
                      _future = loadPackageInfo();
                    });
                  });
            }
          }),
    );
  }

  loadPackageInfo() async {
    if (_packageInfo == null) {
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          _packageInfo = packageInfo;
        });
      } catch (e) {
        e is DioException
            ? throw e
            : Tools.showAlert(context, 'Exception', e.toString(), 'error');
      }
    }
  }
}
