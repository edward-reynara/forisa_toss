import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_toss/ui/pages/setting_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../cores/components/overlay_appbar.dart';
import '../../cores/configs/config.dart';
import '../../cores/models/model_arguments.dart';
import '../../cores/models/model_default.dart';
import '../../cores/utils/api_service.dart';
import '../../cores/utils/locator.dart';
import '../../cores/utils/route_obeserver.dart';
import '../../cores/utils/tools.dart';
import 'home_page.dart';

class MainLayout extends StatefulWidget {
  final ScreenArguments screenArguments;

  const MainLayout(this.screenArguments, {super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with RouteAware {
  int _selectedBottomNavIndex = 0;
  final _bottomNavPages = [];
  ApiService apiService = ApiService();

  void _onTapItem(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didPush() {
    locator<RouteObserverService>().setCurrentPage('home');
    print('didPush${locator<RouteObserverService>().currentPage}');
  }

  @override
  void initState() {
    super.initState();
    locator<RouteObserverService>().setCurrentPage('home');
    print(locator<RouteObserverService>().currentPage);
    _bottomNavPages.addAll([
      Homepage(),
      // ProfileHomePage(),
      const SettingPage(),
    ]);
    //TODO: remove when prod
    if (!Config.isDebugMode) {
      // checkOneSignal();
    }
    checkPassword();
    checkContract();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: [1, 3].contains(_selectedBottomNavIndex)
            ? null
            : overlayAppBar(context),
        body: _bottomNavPages.elementAt(_selectedBottomNavIndex),
        extendBody: true,
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.0),
              child: BottomNavigationBar(
                iconSize: 20.0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.house),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.circleUser),
                    label: 'Profil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.wrench),
                    label: 'Pengaturan',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedBottomNavIndex,
                onTap: _onTapItem,
                backgroundColor: Colors.green,
                fixedColor: Colors.white,
                selectedFontSize: 14.0,
                selectedIconTheme: const IconThemeData(size: 24.0),
                elevation: 4.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: const Text(
              'Konfirmasi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            content: const Text('Anda yakin akan keluar aplikasi ?'),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.grey[500]),
                ),
                child: const Text(
                  'Tidak',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                ),
                child: const Text(
                  'Ya',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // Future<void> checkOneSignal() async {
  //   OSDeviceState? state = await OneSignal.shared.getDeviceState();
  //   if (state != null) {
  //     if (!state.subscribed) {
  //       await OneSignal.shared.disablePush(false);
  //     }
  //   }
  // }

  void checkPassword() async {
    Dio dio = apiService.getApiClient(context: context);
    Response response;
    DefaultModel defaultModel;

    response = await dio.get('/user/checkpassword');

    defaultModel = DefaultModel.fromJson(response.data);

    if (defaultModel.status == 1) {
      Tools.dialogResponse(
        context: context,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/changepassword',
              arguments: ScreenArguments(titleMenu: 'Ganti Password'));
        },
        status: 0,
        title: 'Silahkan ganti password',
        msg:
            'Anda masih menggunakan password default aplikasi. Jika butuh bantuan hubungi admin.',
        outsideDismiss: true,
        canPop: true,
      );
    }
  }

  void checkContract() async {
    Dio dio = apiService.getApiClient(context: context);
    Response response;
    DefaultModel defaultModel;

    try {
      response = await dio.get('/contract/check_pending');
      defaultModel = DefaultModel.fromJson(response.data);
      var data = response.data;

      if (defaultModel.status == 1) {
        Tools.dialogResponse(
          context: context,
          onPressed: () async {
            Navigator.of(context).pop();
            if (data['lockflag'] != null && data['lockflag'] == 1) {
              await Navigator.of(context)
                  .pushNamed('/${data['lockurl']}',
                      arguments: ScreenArguments(titleMenu: 'Pending Kontrak'))
                  .whenComplete(() {
                checkContract();
              });
            }
          },
          status: 1,
          title: defaultModel.msg,
          msg: '',
          outsideDismiss: false,
          canPop: false,
        );
      }
    } catch (e) {
      //
    }
  }
}
