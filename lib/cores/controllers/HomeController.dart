import 'package:dio/dio.dart' as dio_http_client;
import 'package:flutter/material.dart';
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/models/screen_argument_model.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:forisa_package/utils/AlertUtil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../configs/config_colors.dart';
import '../configs/config_constants.dart';
import '../data/models/badge_notif_model.dart' as BadgeNotif;
import '../data/models/counter_info_model.dart';
import '../data/models/current_progress_model.dart';
import '../data/models/home_menu_model.dart';
import '../data/models/user_model.dart';
import '../routes/api.dart';
import '../services/ApiUtil.dart';
import '../services/AuthService.dart';
import '../services/NotificationService.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final APIProvider _apiProvider = Get.find<APIProvider>();
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  late final dio_http_client.Dio _dio = _apiProvider.getApiClient();

  var userModel = UserModel().obs;
  var counterInfoList = <CounterInfo>[].obs;
  var badge = BadgeNotif.Data(link: '', notifQty: '', title: '').obs;
  HomeMenuModel? homeMenuModel;

  var isProgressLoading = false.obs;
  var isMenuLoading = false.obs;

  APIResponsePlain errorMenuLoading = APIResponsePlain();

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _updatePlayerId();
    loadHomeInfo();
    doRedirect();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getHomeMenu() async {
    try {
      isMenuLoading.value = true;
      errorMenuLoading = APIResponsePlain();

      dio_http_client.Response response = await _dio.get(ApiRoutes.HOME_MENU);
      APIResponsePlain apiResponsePlain =
          ApiUtil.checkAPIResponsePlain(response);
      if (apiResponsePlain.code == APIProvider.SUCCESS_API_CODE) {
        homeMenuModel = HomeMenuModel.fromJson(response.data);
      } else {
        throw response;
      }
    } catch (e) {
      errorMenuLoading = ApiUtil.checkAPIResponsePlain(e);
    } finally {
      isMenuLoading.value = false;
    }
  }

  Future<void> getCurrentProgress() async {
    try {
      isProgressLoading.value = true;
      CurrentProgressModel currentProgressModel =
          await _authService.getCurrentProgress();
      counterInfoList.clear();
      if (currentProgressModel.data!.isNotEmpty) {
        currentProgressModel.data!
            .forEach((e) => counterInfoList.add(CounterInfo(
                  title: e.title!,
                  qty: e.notifQty!,
                  fromColor: ConfigColor.getRandomColor(RandomColorMode.dark),
                  toColor: ConfigColor.getRandomColor(RandomColorMode.light),
                  onClick: () async => await Get.toNamed(
                    '/${e.link}',
                    arguments: ScreenArgument(pageTitle: e.title),
                  )?.whenComplete(() => loadHomeInfo()),
                )));
        counterInfoList.refresh();
      } else {
        counterInfoList.add(CounterInfo(
              title: 'No Item',
              qty: '',
              fromColor: Colors.grey.shade300,
              toColor: Colors.grey.shade600,
            ));
      }
    } catch (e) {
      //
    } finally {
      isProgressLoading.value = false;
    }
  }

  Future<void> loadHomeInfo() async {
    getCurrentProgress();
    getHomeMenu();
    try {
      UserModel model = await _authService.getUserData();
      await PrefProvider.secureStorage
          .write(key: PrefProvider.USER_DATA, value: userModelToJson(model));
      userModel.value = model;
      BadgeNotif.BadgeNotifModel badgeNotifModel = await _authService.getNotifBadge();
      badge.value = badgeNotifModel.data!;
    } catch (e) {
      AlertUtil.showSnackbarStatic('Error', e.toString(), AlertStatus.error);
    }
  }

  void _updatePlayerId() async {
    try {
      String playerId = await _notificationService.getPlayerId();

      String? notificationEnabled = await PrefProvider.secureStorage
          .read(key: PrefProvider.ENABLE_NOTIFICATION);
      if (notificationEnabled == null) {
        await PrefProvider.secureStorage
            .write(key: PrefProvider.ENABLE_NOTIFICATION, value: '1');
        notificationEnabled = '1';
      }
      if (notificationEnabled == '1') {
        // await OneSignal.shared.disablePush(false); //TODO CHECK EDO
      }

      await _notificationService.updateSubscription(
          playerId, notificationEnabled == '1' ? true : false);
    } on APIResponsePlain catch (e) {
      AlertUtil.showSnackbarStatic(
          ConfigConstant.ALERT_INFO, e.msg!, AlertStatus.info);
    }
  }

  void doRedirect() async {
    String? data =
        await PrefProvider.secureStorage.read(key: PrefProvider.REDIRECT_DATA);
    if (data != null) {
      ScreenArgument argument = screenArgumentFromJson(data);
      await PrefProvider.secureStorage.delete(key: PrefProvider.REDIRECT_DATA);
      Get.toNamed('/${argument.link}', arguments: argument);
    }
  }
}
