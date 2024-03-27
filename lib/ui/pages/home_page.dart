import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_toss/cores/models/model_menu.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../cores/components/loaders.dart';
import '../../cores/components/shimmers.dart';
import '../../cores/configs/config.dart';
import '../../cores/models/model_arguments.dart';
import '../../cores/models/model_error.dart';
import '../../cores/models/model_menu_item.dart' as menu_item_model;
import '../../cores/models/model_news.dart';
import '../../cores/models/model_status_summary.dart';
import '../../cores/utils/api_service.dart';
import '../../cores/utils/cache_model.dart';
import '../../cores/utils/constants.dart';
import '../../cores/utils/locator.dart';
import '../../cores/utils/tools.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomeState createState() => _HomeState();
}

List<menu_item_model.Menu> menuItems = [];

class _HomeState extends State<Homepage> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late Future<bool> futureReqPermission;
  late Future _futureBerita;
  late Future<StatusSummary?> _futureStatusSummary;
  String name = '-';
  String nik = '-';
  late Future _futureMenu;
  final _apiService = ApiService();
  List<News> news = [];
  String inboxUnread = '-';
  bool updateAvailable = false;
  StatusSummary? _statusSummary;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureReqPermission = Tools.checkPermission(context: context);
    _loadHomePage(init: true);
    _checkRedirect();
  }

  Future<void> _loadHomePage({bool init = false}) async {
    _futureMenu = _getMenus();
    _futureBerita = _loadNews();
    _futureStatusSummary = _getStatusSummary();
    if (!init) {
      setState(() {});
    }
    _loadIdentity();
    //TODO: remove when prod
    if (Config.onesignalService == true) {
      updateOsPlayerId();
    }
    // _loadUnread();
    _checkVersion();
  }

  Future<void> updateOsPlayerId() async {
    // OSDeviceState? status = await OneSignal.shared.getDeviceState();
    // String? playerId = status?.userId;
    // print('playerid = $playerId');
    // ApiService _apiService = ApiService();
    // Dio dio = _apiService.getApiClient(context: context);
    // Response response;
    //
    // try {
    //   response = await dio
    //       .post('/user/submitosplayerid', data: {'PlayerId': playerId});
    //   print(response.data);
    // } on DioException catch (e) {
    //   print(e.message);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: futureReqPermission,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return defaultLoader();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            bool grant = snapshot.data as bool;
            if (!grant) {
              return Center(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  label: const Text(
                    'Cek Hak Akses Perangkat',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      futureReqPermission =
                          Tools.checkPermission(context: context);
                    });
                  },
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _loadHomePage(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 0.0,
                      top: 20.0,
                      right: 10.0,
                      bottom: constBottomNavbarPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (updateAvailable) _updateAvailableWidget(),
                      _ProfileWidget(name: name, nik: nik, inboxUnread: inboxUnread),
                      //Menu Utama
                      MenuUtama(
                        parentContext: context,
                        future: _futureMenu,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FutureBuilder(
                            future: _futureStatusSummary,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return statusSummaryShimmer(true, context);
                              }

                              if (!snapshot.hasError) {
                                _statusSummary =
                                    snapshot.data;
                                if (_statusSummary == null) {
                                  return const Card(
                                    child: Center(
                                      child: Text(
                                          'Data Ringkasan tidak ditemukan'),
                                    ),
                                  );
                                }
                                return Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.vertical(
                                              top: Radius.circular(5.0)),
                                          color: Colors.orange[500],
                                        ),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Ringkasan\nPeriode ${Tools.formatIdDate('dd MMM yyyy', _statusSummary!.period!.startDate)} - ${Tools.formatIdDate('dd MMM yyyy', _statusSummary!.period!.endDate)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   width: double.infinity,
                                      //   color: Colors.white,
                                      //   child:
                                      //       summaryDataTable(_statusSummary!),
                                      // ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              'Berita Terbaru',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              // onTap: () => Navigator.push(
                              //   // context,
                              //   // CupertinoPageRoute(
                              //   //   builder: (context) => MessageTabPage(
                              //   //       ScreenArguments(
                              //   //           titleMenu: 'Berita',
                              //   //           initialIndex: 1)),
                              //   // ),
                              // ),
                              child: const Text('Lihat Semua'),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                          future: _futureBerita,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              //Untuk shimmer
                              return Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                height: 150.0,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 2,
                                  itemBuilder: (context, index) =>
                                      beritaShimmer(true, context),
                                ),
                              );
                            }
                            if (!snapshot.hasError) {
                              news = snapshot.data as List<News>;
                              return Container(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  // vertical: 10.0,
                                ),
                                height: 150.0,
                                child: ListView.builder(
                                  // padding: EdgeInsets.only(bottom: 10.0, left: 2.0,),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: news.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   CupertinoPageRoute(
                                        //     builder: (context) =>
                                        //         NewsDetailPage(news[index]),
                                        //   ),
                                        // );
                                      },
                                      child: Hero(
                                        tag: 'news_photo_${news[index].msgId}',
                                        child: Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(right: 10.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                    news[index].photoUrl +
                                                        news[index]
                                                            .msgPhoto
                                                            .split('#')
                                                            .first,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(right: 10.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              padding: const EdgeInsets.only(
                                                left: 5.0,
                                                bottom: 5.0,
                                                top: 15.0,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: <Color>[
                                                    Colors.grey[600]!,
                                                    Colors.grey[300]!
                                                        .withOpacity(0),
                                                  ],
                                                ),
                                                borderRadius: const BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(15.0),
                                                  bottomRight:
                                                      Radius.circular(15.0),
                                                ),
                                              ),
                                              child: Text(
                                                news[index].msgSubject,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(snapshot.error.toString()),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<News>> _loadNews() async {
    Dio dio = _apiService.getApiClient(context: context);
    Response response;
    List<News> items = [];

    try {
      response = await dio.get('/news/index', queryParameters: {
        'Type': 'NEWS',
        'Page': 1,
      });

      for (var item in response.data) {
        items.add(News.fromJson(item));
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }

    return items;
  }

  // Future<void> _loadUnread() async {
  //   Dio dio = _apiService.getApiClient(context: context);
  //   Response response;
  //
  //   try {
  //     response = await dio.get('/news/unreadcount');
  //
  //     for (var item in response.data) {
  //       NewsUnread newsUnread = NewsUnread.fromJson(item);
  //       if (newsUnread.msgType == 'INBOX') {
  //         if (newsUnread.qtyUnread != '0') {
  //           if (mounted) {
  //             setState(() {
  //               inboxUnread = newsUnread.qtyUnread;
  //             });
  //           }
  //         }
  //       }
  //     }
  //   } on DioException catch (e) {
  //     print('Unread:' + (e.message ?? ""));
  //   }
  // }

  Future<StatusSummary?> _getStatusSummary() async {
    Dio dio = _apiService.getApiClient(context: context);
    Response response;
    StatusSummary? statusSummary;

    try {
      response = await dio.get('/employeestatussummary', queryParameters: {
        'Periode': Tools.formatIdDate('yyyy-MM-dd', DateTime.now())
      });

      statusSummary = StatusSummary.fromJson(response.data);
    } on DioException catch (e) {
      Tools.handleAPIError(context, e);
    } catch (e) {
      throw Exception(e.toString());
    }
    return statusSummary;
  }

  Future _getMenus() async {
    // MenuItem checkMenuItem = locator<CacheModel>().menuUtama;
    // if (checkMenuItem != null) {
    //   setState(() {
    //     menuItems = checkMenuItem.mainmenu;
    //   });
    //   return;
    // }
    Dio dio = _apiService.getApiClient(context: context);
    Response response;

    try {
      response = await dio.get('/getmenu');
      var menuItem = menu_item_model.MenuItem.fromJson(response.data);
      setState(() {
        menuItems = menuItem.mainmenu;
        locator<CacheModel>().menuUtama = menuItem as MenuItem;
      });
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          ErrorModel errorResponse = ErrorModel.fromJson(e.response!.data);
          Tools.showAlert(context, 'Response',
              errorResponse.message.join('\n').toString(), 'error');
        } else if (e.response!.statusCode == 401) {
          await secureStorage.deleteAll();
          await secureStorage.write(key: 'intro', value: 'true');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Perhatian'),
                  content: const Text('Sesi anda telah habis silahkan login kembali'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                            builder: (BuildContext context) => const Login(),
                          ),
                          ModalRoute.withName('/'),
                        );
                      },
                    ),
                  ],
                );
              });
        } else {
          throw Exception(e.response!.statusMessage);
        }
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> _checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String? appVersion = await secureStorage.read(key: 'app_version');
    if (appVersion != null) {
      if (int.parse(packageInfo.buildNumber) < int.parse(appVersion)) {
        updateAvailable = true;
      }
    }
  }

  Future<void> _loadIdentity() async {
    String? name = await secureStorage.read(key: 'name');
    String? nik = await secureStorage.read(key: 'nik');
    setState(() {
      this.name = name ?? '-';
      this.nik = nik ?? '-';
    });
  }

  _checkRedirect() async {
    String? redirect = await secureStorage.read(key: 'redirect');
    String? page = await secureStorage.read(key: 'page');
    String? data = await secureStorage.read(key: 'redirect_data');
    if (redirect == 'true') {
      await secureStorage.delete(key: 'redirect');
      await secureStorage.delete(key: 'page');
      await secureStorage.delete(key: 'redirect_data');
      Navigator.of(context).pushNamed(page!, arguments: newsFromJson(data!));
    }
  }

  Widget _updateAvailableWidget() => Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: Card(
          color: Colors.green[300],
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Update aplikasi tersedia',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  icon: const Icon(
                    FontAwesomeIcons.download,
                    color: Colors.white,
                    size: 10.0,
                  ),
                  label: const Text(
                    'Download',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    String? appUrl = await secureStorage.read(key: 'app_url');
                    if (appUrl != null) {
                      try {
                        await launchUrlString(appUrl,
                            mode: LaunchMode.externalApplication);
                      } catch (e) {
                        Tools.showAlert(context, 'Exception',
                            'Gagal membuka link', 'error');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
class _ProfileWidget extends StatelessWidget {
  final String name;
  final String nik;
  final String inboxUnread;

  const _ProfileWidget({
    required this.name,
    required this.nik,
    required this.inboxUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      width: double.infinity,
      child: Card(
        elevation: 1.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    // OSPermissionSubscriptionState status =
                    //     await OneSignal.shared
                    //         .getPermissionSubscriptionState();
                    // String playerId =
                    //     status.subscriptionStatus.userId;
                    // await OneSignal.shared
                    //     .postNotification(OSCreateNotification(
                    //   playerIds: [playerId],
                    //   content: 'Tes',
                    //   heading: 'Dari Internal',
                    //   // additionalData: {
                    //   //   'page': 'news',
                    //   //   'data': news[0].toJson()
                    //   // },
                    // ));
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 30.0,
                    foregroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                    ),
                    Text(nik),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  // onTap: () => Navigator.push(
                  //   // context,
                  //   // CupertinoPageRoute(
                  //   //   builder: (context) => MessageTabPage(ScreenArguments(
                  //   //       titleMenu: 'Berita', initialIndex: 0)),
                  //   // ),
                  // ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    alignment: Alignment.center,
                    child: badges.Badge(
                      badgeContent: Text(
                        inboxUnread,
                        style: const TextStyle(color: Colors.white),
                      ),
                      showBadge: inboxUnread != '-',
                      child: const Icon(
                        FontAwesomeIcons.inbox,
                        color: Colors.green,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuUtama extends StatelessWidget {
  final BuildContext parentContext;
  final Future future;

  const MenuUtama({super.key, required this.parentContext, required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            var items = List<MenuUtamaPlaceholder>.generate(
                8, (i) => const MenuUtamaPlaceholder());
            return Container(
              padding: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 5.0,
                    color: Colors.grey[200]!,
                    offset: const Offset(0, 0),
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    mainAxisSpacing: 2.0,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    children: items,
                  ),
                ),
              ),
            );
          }
          if (!snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 2.0,
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 2.0,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: menuItems
                        .map((menu) => GestureDetector(
                              onTap: () {
                                if (menu.link == 'logout') {
                                  Tools.logoutApp(context: context);
                                } else if (menu.link == 'absen') {
                                  Tools.checkLocationService(context)
                                      .then((enabled) {
                                    if (!enabled) {
                                      Tools.dialogResponse(
                                        context: context,
                                        onPressed: () async {
                                          await AppSettings
                                                  .openAppSettings()
                                              .whenComplete(() =>
                                                  Navigator.of(context).pop());
                                        },
                                        status: 0,
                                        title: 'Pengaturan Lokasi Tidak Aktif',
                                        msg:
                                            'Silahkan aktifkan pengaturan lokasi smartphone anda lalu kembali',
                                      );
                                    } else {
                                      Navigator.pushNamed(
                                        parentContext,
                                        '/${menu.link}',
                                        arguments: ScreenArguments(
                                          parentId: menu.menuId,
                                          titleMenu: menu.menuDisplayName,
                                        ),
                                      );
                                    }
                                  });
                                } else {
                                  Navigator.pushNamed(
                                    parentContext,
                                    '/${menu.link}',
                                    arguments: ScreenArguments(
                                      parentId: menu.menuId,
                                      titleMenu: menu.menuDisplayName,
                                    ),
                                  );
                                }
                              },
                              child: MenuUtamaItem(
                                displayName: menu.menuDisplayName,
                                iconUrl: menu.icon,
                                menuId: menu.menuId,
                                linkTo: menu.link,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          } else {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(snapshot.error.toString()),
                ),
              ),
            );
          }
        });
  }
}

class MenuUtamaItem extends StatelessWidget {
  final String menuId;
  final String displayName;
  final String linkTo;
  final String iconUrl;

  const MenuUtamaItem(
      {super.key, required this.menuId,
      required this.displayName,
      required this.linkTo,
      required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 55.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: CachedNetworkImage(
              imageUrl: iconUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SpinKitRipple(
                color: Colors.green,
              ),
            ),
          ),
        ),
        Expanded(
          child: AutoSizeText(
            displayName,
            style: const TextStyle(
              fontSize: 12.0,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}

class MenuUtamaPlaceholder extends StatelessWidget {
  const MenuUtamaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return menuUtamaShimmer(true);
  }
}
