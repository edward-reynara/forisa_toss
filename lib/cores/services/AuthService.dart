import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:dio/dio.dart' as dio_http_client;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../configs/config_app.dart';
import '../data/interfaces/AuthInterface.dart';
import '../data/models/badge_notif_model.dart';
import '../data/models/current_progress_model.dart';
import '../data/models/login_model.dart';
import '../data/models/user_model.dart';
import '../routes/api.dart';
import 'ApiUtil.dart';

class AuthService implements IAuthService {
  // final APIProvider _apiProvider = Get.find<APIProvider>();
  // final NotificationService _notificationService = NotificationService();
  final APIProvider _apiProvider = APIProvider(
      apiUrl:ConfigApp.apiUrl,
      clientAppCode:ConfigApp.clientAppCode,
      clientApiId:ConfigApp.clientApiId,
      clientApiKey:ConfigApp.clientApiKey
  );
  late final dio_http_client.Dio _dio = _apiProvider.getApiClient();

  @override
  Future<void> logoutUser() async {
    // String playerId = await _notificationService.getPlayerId();
    // await _notificationService.updateSubscription(playerId, false);
    // await OneSignal.shared.disablePush(true);//TODO CHECK EDO
    await PrefProvider.resetAfterLogin();
    // await APIProvider.getCacheManager().clearAll();
  }

  @override
  Future<LoginModel> doLogin(String username, String password) async {
    try {
      dio_http_client.Response response = await _dio.post(ApiRoutes.AUTH_LOGIN,
          data: {'username': username, 'password': password});

      if (ApiUtil.checkAPIResponsePlain(response).code !=
          APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return LoginModel.fromJson(response.data);
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }

  @override
  Future<UserModel> getUserData() async {
    try {
      // HttpClient.Response response = await _dio.get(ApiRoutes.AUTH_USER_INFO,
      //     options: APIProvider.getCacheOptions());
      dio_http_client.Response response = await _dio.get(ApiRoutes.AUTH_USER_INFO);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }

  @override
  Future<APIResponsePlain> changeUserPassword(
      String username, String oldPassword, String newPassword) async {
    try {
      dio_http_client.Response response = await _dio
          .post(ApiRoutes.AUTH_CHANGE_PASSWORD, data: {
        "username": username,
        "oldpassword": oldPassword,
        "password": newPassword
      });
      APIResponsePlain check = ApiUtil.checkAPIResponsePlain(response);

      if (check.code != APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return check;
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }

  @override
  Future<BadgeNotifModel> getNotifBadge() async {
    try {
      dio_http_client.Response response = await _dio.get(ApiRoutes.AUTH_BADGE_NOTIF);
      APIResponsePlain check = ApiUtil.checkAPIResponsePlain(response);

      if (check.code != APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return BadgeNotifModel.fromJson(response.data);
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }

  @override
  Future<CurrentProgressModel> getCurrentProgress() async {
    try {
      dio_http_client.Response response =
          await _dio.get(ApiRoutes.AUTH_CURRENT_PROGRESS);
      APIResponsePlain check = ApiUtil.checkAPIResponsePlain(response);

      if (check.code != APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return CurrentProgressModel.fromJson(response.data);
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }
}
