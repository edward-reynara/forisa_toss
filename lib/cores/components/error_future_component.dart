import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_toss/cores/components/submit_button.dart';

import '../../ui/pages/login.dart';

Container errorFutureContainer({
  required dynamic error,
  Function()? callback,
  String? btnString,
  IconData? iconData,
  required BuildContext context,
}) {
  int code = 0;
  String title = '';
  String desc = '';
  String stackTrace = '';

  try {
    stackTrace = error.stackTrace.toString();
  } catch (e) {
  }

  if (error is DioException) {
    var e = error;
    if (e.response != null) {
      code = e.response!.statusCode!;
      if (code == 429) {
        title = 'Server padat merayap';
        desc = 'Silahkan tutup dan coba buka aplikasi lagi nanti.';
      } else if (code == 500) {
        title = 'Server error';
        desc = e.response!.statusMessage!;
      } else if (code == 401) {
        title = 'Sesi Habis';
        desc = 'Silahkan login kembali.';
        btnString = 'Login';
        iconData = FontAwesomeIcons.signInAlt;
        callback = () {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (BuildContext context) => Login(),
            ),
            ModalRoute.withName('/'),
          );
        };
      } else if (code == 404) {
        title = 'Not Found';
        desc = 'Halaman tidak ditemukan.';
        btnString = 'Kembali';
        iconData = FontAwesomeIcons.arrowCircleLeft;
        callback = callback ?? () {
          Navigator.of(context).pop();
        };
      } else if (code == 503) {
        title = 'Server Maintenance';
        desc = 'Server sedang dalam pemeliharaan';
      } else {
        title = code.toString() + ' ' + e.response!.statusMessage!;
        code = 0;
      }
    } else {
      title = 'Request Error';
      desc = e.message ?? "";
      btnString = 'Ulangi';
    }
  } else {
    title = 'Platform Error';
    desc = error.toString();
    btnString = 'Ulangi';
  }

  return Container(
    alignment: Alignment.center,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 250.0,
          height: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/errors/' + code.toString() + '.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
                content: Text(stackTrace),
              )),
              child: Text(
                '($code) ' + title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Text(
              desc,
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            callback != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: buttonIconContainer(
                      iconData: iconData ?? FontAwesomeIcons.redo,
                      onPressed: callback,
                      text: btnString ?? 'Ulangi',
                      buttonColor: Colors.green,
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    ),
  );
}
