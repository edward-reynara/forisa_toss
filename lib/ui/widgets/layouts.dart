import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/utils/AlertUtil.dart';
import 'package:forisa_package/widgets/buttons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cores/configs/config_constants.dart';
import '../../cores/routes/pages.dart';
import '../../cores/services/AuthService.dart';

Container errorFutureContainer({
  required BuildContext context,
  required dynamic error,
  Function()? callback,
  String? btnString,
  IconData? iconData,
}) {
  String title = '';
  String? desc;
  String responseCode = '';
  btnString ??= 'Ulangi';

  if (error is APIResponsePlain) {
    responseCode = error.code ?? '-';

    switch (responseCode) {
      case APIProvider.GENERAL_ERROR_API_CODE:
        title = 'General Error';
        desc = error.msg;
        break;
      case APIProvider.INVALID_TOKEN_API_CODE:
        title = 'Session Expired';
        desc = error.msg;
        iconData = FontAwesomeIcons.signInAlt;
        btnString = 'Login';
        callback = () async {
          await AuthService().logoutUser();
          Get.offAllNamed(Routes.LOGIN_PAGE);
        };
        btnString = 'Login';
        break;
      case '800001':
        title = 'Authentication';
        desc = error.msg;
        break;
      case '800002':
        title = 'New Update';
        desc = 'App version too old';
        iconData = FontAwesomeIcons.cloudDownloadAlt;
        btnString = 'Download';
        callback = () async {
          if (await canLaunch(error.payload!)) {
            await launch(error.payload!);
          } else {
            AlertUtil.showSnackbarStatic(ConfigConstant.ALERT_INFO,
                'Can not open update URL', AlertStatus.info);
          }
        };
        break;
      default:
        title = error.title ?? '-';
        desc = error.msg;
    }
  } else if (error is DioError) {
    title = 'Network Error';
    desc = error.message;
    responseCode = error.response?.statusCode.toString() ?? '0';
  } else {
    title = 'Unknown Error';
    desc = error.toString();
  }

  return Container(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          height: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: const DecorationImage(
              image: AssetImage('assets/images/error_future_img.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '($responseCode) $title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            Text(
              desc ?? '-',
              style: const TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
            ),
            callback != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buttonSubmitDefault(
                      context: context,
                      iconData: iconData ?? FontAwesomeIcons.redo,
                      onPressed: callback,
                      text: btnString,
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    ),
  );
}

Widget emptyDataWidget({
  String? msg,
  Function()? onPressed,
  String? btnText,
  IconData? iconData,
}) =>
    Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/no_data.png',
              width: 150.0,
              height: 200.0,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              msg ?? 'Data tidak ditemukan',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            if (onPressed != null)
              buttonCompact(
                  onPressed: onPressed,
                  text: btnText ?? 'Ulangi',
                  iconData: iconData ?? FontAwesomeIcons.redoAlt),
          ],
        ),
      ),
    );
