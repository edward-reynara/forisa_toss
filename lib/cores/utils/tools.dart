import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart' as device_info;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:forisa_attendance/components/default_dialog.dart';
// import 'package:forisa_attendance/components/submit_button.dart';
// import 'package:forisa_attendance/models/model_error.dart';
// import 'package:forisa_attendance/pages/login.dart';
import 'package:forisa_package/widgets/buttons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as p_handler;
import 'package:platform_device_id_v3/platform_device_id.dart';

import '../../ui/pages/login.dart';
import '../components/default_dialog.dart';
import '../models/model_error.dart';

class Tools {
  static Future<bool> showConfirmDialog(BuildContext context,
      {String? title, String? msg, String? okText, String? cancelText}) async {
    return await showDialog<bool?>(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(title ?? 'Konfirmasi'),
                content: Text(msg ?? 'Apakah anda yakin ?'),
                actions: <Widget>[
                  buttonCompact(
                    buttonColor: Colors.transparent,
                    textColor: Colors.black,
                    text: cancelText ?? 'Tidak',
                    onPressed: () {
                      Navigator.pop(dialogContext, false);
                    },
                  ),
                  buttonCompact(
                    text: okText ?? 'OK',
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                    },
                  ),
                ],
              );
            }) ??
        false;
  }

  static void showAlert(
      BuildContext context, String title, String msg, String type,
      {Duration? duration}) {
    Flushbar(
      title: title,
      message: msg,
      isDismissible: true,
      duration: duration ?? const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(5.0),
      // margin: EdgeInsets.all(5.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: [
        BoxShadow(
            color: Colors.grey.shade800,
            offset: const Offset(0.0, 2.0),
            blurRadius: 3.0)
      ],
      icon: const Icon(
        Icons.notifications,
        color: Colors.white,
      ),
      leftBarIndicatorColor: type == 'error'
          ? Colors.red
          : type == 'info'
              ? Colors.blue
              : Colors.green,
      shouldIconPulse: false,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }

  // static Future<bool> checkMockLocation() async {
  //   Location location = Location();
  //   location.changeSettings(accuracy: LocationAccuracy.high);
  //   LocationData position = await location.getLocation();
  //   return position.isMock!;
  // }

  static Future<List<String>> getDeviceDetails({deviceIdOnly = false}) async {
    String deviceName = '';
    String deviceVersion = '';
    String deviceID = '';
    final deviceInfoPlugin = device_info.DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion =
            '${Platform.operatingSystem} ${build.version.release}';
        // deviceID = build.androidId ?? '-';
        const androidIdPlugin = AndroidId();
        try {
          deviceID = (await androidIdPlugin.getId())!;
          if (deviceID == ''){
            deviceID = (await PlatformDeviceId.getDeviceId)!;
          }
        } on PlatformException {
          deviceID = 'Failed to get Android ID.';
        }
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemName;
        deviceID = data.identifierForVendor ?? '-';
      }
    } on PlatformException catch (e) {
      print(e.message);
    }

    if (deviceIdOnly == true) {
      return [deviceID];
    }

    return [deviceName, deviceVersion, deviceID];
  }

  static String formatIdDate(String format, DateTime? date) {
    if (date == null) {
      return '-';
    }
    Intl.defaultLocale = 'id_ID';
    initializeDateFormatting();
    return DateFormat(format).format(date).toString();
  }

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  static String thousandNumber(int? number) {
    if (number == null) {
      return 'InvalidNum';
    }
    Intl.defaultLocale = 'id_ID';
    final formater = NumberFormat("###,###.###");
    return formater.format(number);
  }

  static getMonthName(int month) {
    List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  static logoutApp({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
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
            content: const Text('Anda yakin akan logout ?'),
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green[500])),
                child: const Text(
                  'Ya',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  // FlutterSecureStorage secureStorage =
                  //     new FlutterSecureStorage();
                  // await secureStorage.deleteAll();
                  // await secureStorage.write(key: 'intro', value: 'true');
                  // await OneSignal.shared.disablePush(true);
                  // // await ApiService.getCacheManager().clearAll();
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     CupertinoPageRoute(
                  //       builder: (context) => Login(),
                  //     ),
                  //     ModalRoute.withName('/'));
                },
              ),
            ],
          );
        });
  }

  static Future<bool> checkPermission({required BuildContext context}) async {
    bool grantedPermissions = true;
    var build = await device_info.DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid) {
      if (build.version.sdkInt < 23) {
        return grantedPermissions;
      }
    }
    List<p_handler.Permission> permissionsRequest = [];

    //check permission is granted
    bool locationPermission = await p_handler.Permission.locationWhenInUse.isGranted;
    bool cameraPermission = await p_handler.Permission.camera.isGranted;
    if (!locationPermission) {
      permissionsRequest.add(p_handler.Permission.locationWhenInUse);
    }
    if (!cameraPermission) {
      permissionsRequest.add(p_handler.Permission.camera);
    }

    if (build.version.sdkInt > 32) {
      //for android >= 33
      bool photosPermission = await p_handler.Permission.photos.isGranted;
      bool videosPermission = await p_handler.Permission.videos.isGranted;
      bool audioPermission = await p_handler.Permission.audio.isGranted;
      if (!photosPermission) {
        permissionsRequest.add(p_handler.Permission.photos);
      }
      if (!videosPermission) {
        permissionsRequest.add(p_handler.Permission.videos);
      }
      if (!audioPermission) {
        permissionsRequest.add(p_handler.Permission.audio);
      }
    } else {
      //for android sdk < 32
      bool storagePermission = await p_handler.Permission.storage.isGranted;
      if (!storagePermission) {
        permissionsRequest.add(p_handler.Permission.storage);
      }
    }

    //Looping Permission request
    if (permissionsRequest.isNotEmpty) {
      Map<p_handler.Permission, p_handler.PermissionStatus> statuses =
      await permissionsRequest.request();
      statuses.forEach(
              (p_handler.Permission permission, p_handler.PermissionStatus pStatus) {
            if (pStatus != p_handler.PermissionStatus.granted) {
              grantedPermissions = false;
            }
          });
    }

    bool locService = await checkLocationService(context);

    if (!locService) {
      grantedPermissions = false;
      dialogResponse(
        context: context,
        onPressed: () async {
          await AppSettings.openAppSettings().whenComplete(() => Navigator.of(context).pop())  ;
        },
        status: 0,
        title: 'Pengaturan Lokasi Tidak Aktif',
        msg: 'Silahkan aktifkan pengaturan lokasi smartphone anda lalu kembali',
      );
    }

    return grantedPermissions;
  }

  static Future<bool> checkLocationService(BuildContext context) async {
    return await p_handler.Permission.location.serviceStatus.isEnabled;
  }

  static exitApp({required BuildContext context}) async {
    return await showDialog(
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
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
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
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
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
    ).then((val) {
      return val ?? false;
    });
  }

  static dialogResponse({
    required BuildContext context,
    String title = '',
    String msg = '',
    required int status,
    required Function() onPressed,
    bool outsideDismiss = false,
    bool canPop = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: outsideDismiss,
      builder: (context) =>
          DefaultDialog(title, msg, status, onPressed, outsideDismiss, canPop),
    );
  }

  static String thumbnailNews(String urlPhoto, String plainText) {
    return urlPhoto + plainText.split('#').first;
  }

  static String convertTwoDecimal(String value) {
    // if (value.length >= 4) {
    //   return value.substring(0, value.indexOf('.')+3);
    // }
    return value;
  }

  static handleAPIError(DioException e, BuildContext context) {
    if (e.response != null) {
      if (e.response?.statusCode == 422) {
        ErrorModel errorResponse = ErrorModel.fromJson(e.response?.data);
        Tools.showAlert(
            context, 'Response', errorResponse.message.join('\n'), 'error');
      } else if (e.response?.statusCode == 401) {
        FlutterSecureStorage secureStorage = const FlutterSecureStorage();
        secureStorage.deleteAll();
        secureStorage.write(key: 'intro', value: 'true');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Perhatian'),
                content: const Text('Sesi anda telah habis silahkan login kembali'),
                actions: <Widget>[
                  OutlinedButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                          builder: (_) => Login(),
                        ),
                        ModalRoute.withName('/'),
                      );
                    },
                  ),
                ],
              );
            });
      } else {
        Tools.showAlert(context, 'Response',
            e.response?.statusMessage ?? 'Unknown Error', 'error');
      }
    } else {
      Tools.showAlert(context, 'Response', e.message ?? "", 'error');
    }
  }

  static String randomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static Future<String?> getDownloadDirectory() async {
    Directory dir;
    String? path;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory())!;
      path = '${dir.path}/Download';
      bool isExist = await Directory(path).exists();
      if (!isExist) {
        await Directory(path).create(recursive: true);
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }
    return path;
  }

  static Future<String?> getTempDir() async {
    Directory dir;
    String? path;
    dir = await getTemporaryDirectory();
    path = dir.path;
    return path;
  }

  static String numberToRupiahResult(double number) {
    var result = numberToRupiah(number);
    return "${result
            .trim()
            .split(' ')
            .map((e) => '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}')
            .toList()
            .join(' ')} Rupiah";
  }

  static String numberToRupiah(double number) {
    number = number.abs();
    var numberInINA = [
      "",
      "satu",
      "dua",
      "tiga",
      "empat",
      "lima",
      "enam",
      "tujuh",
      "delapan",
      "sembilan",
      "sepuluh",
      "sebelas"
    ];
    var temp = '';
    if (number < 12) {
      temp = " ${numberInINA[number.toInt()]}";
    } else if (number < 20) {
      temp = "${numberToRupiah(number - 10)} belas";
    } else if (number < 100) {
      temp =
          "${numberToRupiah(number / 10)} puluh${numberToRupiah(number % 10)}";
    } else if (number < 200) {
      temp = " seratus${numberToRupiah(number - 100)}";
    } else if (number < 1000) {
      temp = "${numberToRupiah(number / 100)} ratus${numberToRupiah(number % 100)}";
    } else if (number < 2000) {
      temp = " seribu${numberToRupiah(number - 1000)}";
    } else if (number < 1000000) {
      temp = "${numberToRupiah(number / 1000)} ribu${numberToRupiah(number % 1000)}";
    } else if (number < 1000000000) {
      temp = "${numberToRupiah(number / 1000000)} juta${numberToRupiah(number % 1000000)}";
    } else if (number < 1000000000000) {
      temp = "${numberToRupiah(number / 1000000000)} milyar${numberToRupiah(number % 1000000000)}";
    } else if (number < 1000000000000000) {
      temp = "${numberToRupiah(number / 1000000000000)} trilyun${numberToRupiah(number % 1000000000000)}";
    }
    return temp.trimRight();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.'; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
