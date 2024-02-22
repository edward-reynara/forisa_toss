// import 'package:ResellerSalesMobile/cores/controllers/AuthController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/CartController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/HomeController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/OnboardingController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/ProductController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/ResellerController.dart';
// import 'package:ResellerSalesMobile/cores/controllers/SplashController.dart';
// import 'package:ResellerSalesMobile/cores/data/models/screen_argument_model.dart';

import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:get/get.dart';
import 'package:forisa_package/services/PlatformService.dart';
import 'package:forisa_package/services/ConnectivityService.dart';
import '../configs/config_app.dart';
import '../controllers/AuthController.dart';
import '../controllers/HomeController.dart';
import '../controllers/OnboardingController.dart';
import '../controllers/SplashController.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PlatformService>(PlatformService(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
    Get.put<PrefProvider>(PrefProvider(), permanent: true);
    Get.put<APIProvider>(APIProvider(
        apiUrl:ConfigApp.apiUrl,
        clientAppCode:ConfigApp.clientAppCode,
        clientApiId:ConfigApp.clientApiId,
        clientApiKey:ConfigApp.clientApiKey
    ), permanent: true);
  }
}

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

// class ResellerBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ResellerController>(() => ResellerController(ScreenArgument(stringPayload: 'list')));
//   }
// }
//
// class ProductBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ProductController>(() => ProductController());
//   }
// }
//
// class CartBinding implements Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<CartController>(() => CartController());
//   }
// }
