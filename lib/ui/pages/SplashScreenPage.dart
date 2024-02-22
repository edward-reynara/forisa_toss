// import 'package:ResellerSalesMobile/cores/configs/config_colors.dart';
// import 'package:ResellerSalesMobile/cores/controllers/SplashController.dart';
// import 'package:ResellerSalesMobile/ui/widgets/layouts.dart';
// import 'package:ResellerSalesMobile/ui/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forisa_package/widgets/loaders.dart';
import 'package:get/get.dart';

import '../../cores/configs/config_colors.dart';
import '../../cores/controllers/SplashController.dart';
import '../widgets/layouts.dart';

class SplashScreenPage extends StatelessWidget {
  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isPageLoading.value) {
          return Container(
            color: ConfigColor.backgroundColor,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    width: 250.0,
                    height: 100.0,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 200.0,
                    child: SvgPicture.asset(
                      'assets/images/splash_bottom_decoration.svg',
                      semanticsLabel: 'Bottom Decoration',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorPageLoading.value.code != null) {
          return errorFutureContainer(
            context: context,
            callback: () => controller.checkAppVersion(),
            error: controller.errorPageLoading.value,
          );
        } else {
          return Container(
            color: ConfigColor.backgroundColor,
            alignment: Alignment.center,
            child: futureLoader(),
          );
        }
      }),
    );
  }
}
