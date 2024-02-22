import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_package/widgets/appbars.dart';
import 'package:forisa_package/widgets/buttons.dart';
import 'package:get/route_manager.dart';

import '../../cores/configs/config_colors.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cleanAppBar(title: ''),
      backgroundColor: ConfigColor.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/not_found.png',
                  height: 150.0,
                ),
                const Text(
                  'Halaman tidak ditemukan !',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            buttonCompact(onPressed: () => Get.back(), text: 'Kembali', iconData: FontAwesomeIcons.arrowLeft),
          ],
        ),
      ),
    );
  }
}
