// import 'package:ResellerSalesMobile/cores/data/interfaces/NotificationInterface.dart';
// import 'package:ResellerSalesMobile/cores/data/models/api/api_response_plain.dart';
// import 'package:ResellerSalesMobile/cores/data/models/device_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/notification_subscsribe_model.dart';
// import 'package:ResellerSalesMobile/cores/data/providers/provider_api.dart';
// import '../../../../forisa_toss/lib/cores/routes/api.dart';
// import 'package:ResellerSalesMobile/cores/utils/ApiUtil.dart';
import 'package:dio/dio.dart';
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/utils/DeviceUtil.dart';
import 'package:get/instance_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../data/interfaces/NotificationInterface.dart';
import '../data/models/device_model.dart';
import '../data/models/notification_subscsribe_model.dart';
import '../routes/api.dart';
import 'ApiUtil.dart';

class NotificationService implements INotificationService {
  final APIProvider _apiProvider = Get.find<APIProvider>();
  late final Dio _dio = _apiProvider.getApiClient();

  @override
  Future<bool> checkSubscribeStatus(String playerId) async {
    try {
      // TODO CHECK EDO
      // OSDeviceState? status =
      //     await OneSignal.shared.getDeviceState();
      Response response = await _dio.get(ApiRoutes.CHECK_NOTIFICATION_SUBSCRIBE,
          queryParameters: {"ExtDeviceId": playerId});

      if (ApiUtil.checkAPIResponsePlain(response).code !=
          APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      NotificationSubscribeModel model =
          NotificationSubscribeModel.fromJson(response.data);
      //TODO CHECK EDO
      // return (status?.subscribed ?? false) &&
      //     model.data!.isSubscribed == '1';
      return model.data!.isSubscribed == '1';
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }

  @override
  Future<String> getPlayerId() async {
    // TODO CHECK EDO
    // OSDeviceState? status =
    //     await OneSignal.shared.getDeviceState();
    // return status?.userId ?? '-';
    return '-';
  }

  @override
  Future<APIResponsePlain> updateSubscription(
      String playerId, bool subscribe) async {
    try {
      // await OneSignal.shared.disablePush(!subscribe); //TODO CHECK EDO

      DeviceModel deviceModel = (await Deviceutil.getDeviceInfo()) as DeviceModel;

      Response response =
          await _dio.post(ApiRoutes.UPDATE_NOTIFICATION_SUBSCRIBE, data: {
        "ExtDeviceId": playerId,
        "DeviceType": "onesignal",
        "ExtInfo1": deviceModel.deviceOs,
        "IsSubscribed": subscribe ? '1' : '0'
      });
      APIResponsePlain rsp = ApiUtil.checkAPIResponsePlain(response);
      if (rsp.code != APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return rsp;
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }
}
