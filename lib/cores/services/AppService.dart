import 'package:forisa_package/interfaces/AppInterface.dart';
import 'package:forisa_package/models/app_model.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_http_client;
import '../routes/api.dart';
import 'ApiUtil.dart';

class AppService implements IAppService {
  final APIProvider apiProvider = Get.find<APIProvider>();
  late final dio_http_client.Dio _dio = apiProvider.getApiClient();

  @override
  Future<AppModel> getAppVersion() async {
    try {
      dio_http_client.Response response = await _dio.get(ApiRoutes.CHECK_VERSION);
      if (ApiUtil.checkAPIResponsePlain(response).code !=
          APIProvider.SUCCESS_API_CODE) {
        throw response;
      }
      return AppModel.fromJson(response.data);
    } catch (e) {
      throw ApiUtil.checkAPIResponsePlain(e);
    }
  }
}
