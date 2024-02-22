// import 'package:ResellerSalesMobile/cores/configs/config_constants.dart';
// import 'package:ResellerSalesMobile/cores/data/models/api/api_response_plain.dart';
// import 'package:ResellerSalesMobile/cores/data/models/app_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/platform_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/screen_argument_model.dart';
// import 'package:ResellerSalesMobile/cores/data/providers/provider_pref.dart';
// import 'package:ResellerSalesMobile/cores/routes/pages.dart';
// import 'package:ResellerSalesMobile/cores/services/AppService.dart';
// import 'package:ResellerSalesMobile/cores/services/ConnectivityService.dart';
// import 'package:ResellerSalesMobile/cores/services/PlatformService.dart';
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/models/app_model.dart';
import 'package:forisa_package/models/platform_model.dart';
import 'package:forisa_package/models/screen_argument_model.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:forisa_package/services/ConnectivityService.dart';
import 'package:forisa_package/services/PlatformService.dart';
import 'package:get/get.dart';

import '../configs/config_constants.dart';
import '../routes/pages.dart';
import '../services/AppService.dart';

class SplashController extends GetxController {
  SplashController();
  final AppService _appService = AppService();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  final PlatformService _platformService = Get.find<PlatformService>();

  var isPageLoading = false.obs;
  var errorPageLoading = APIResponsePlain().obs;

  @override
  void onInit() {
    super.onInit();
    checkAppVersion();
  }

  Future<void> checkDoneOnboarding() async {
    String? isDone = await PrefProvider.secureStorage
        .read(key: PrefProvider.IS_DONE_INTRO_KEY);

    if (isDone != 'true') {
      Get.offNamed(Routes.ONBOARDING_PAGE);
    } else {
      String? token =
          await PrefProvider.secureStorage.read(key: PrefProvider.TOKEN_KEY);
      if (token != null) {
        Get.offNamed(Routes.MAIN_LAYOUT);
      } else {
        //Delete redirect data when logout
        await PrefProvider.secureStorage
        .delete(key: PrefProvider.REDIRECT_DATA);
        Get.offNamed(Routes.LOGIN_PAGE);
      }
    }
  }

  Future<void> checkAppVersion() async {
    try {
      isPageLoading.value = true;
      errorPageLoading.value = APIResponsePlain();

      if (!_connectivityService.isNetworkAvailable()) {
        throw APIResponsePlain(
            code: '0',
            title: ConfigConstant.NETWORK_ERROR_TITLE,
            msg: ConfigConstant.NETWORK_ERROR_MSG);
      }

      AppModel appModel = await _appService.getAppVersion();
      PlatformModel platformModel = await _platformService.getPlatformInfo();

      if (int.parse(platformModel.buildNumber) <
          int.parse(appModel.data!.minVersion!)) {
        Get.offAllNamed(Routes.NEWUPDATE_PAGE,
            arguments: ScreenArgument(stringPayload: appModel.data!.storeUrl));
      } else {
        checkDoneOnboarding();
      }
    } on APIResponsePlain catch (e) {
      errorPageLoading.value = e;
    } finally {
      isPageLoading.value = false;
    }
  }
}
