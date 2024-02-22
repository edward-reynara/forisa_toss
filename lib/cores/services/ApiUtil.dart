// import 'package:ResellerSalesMobile/cores/configs/config_constants.dart';
// import 'package:ResellerSalesMobile/cores/data/models/api/api_response_plain.dart';
// import 'package:ResellerSalesMobile/cores/data/models/app_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/api/error_model.dart';
// import 'package:ResellerSalesMobile/cores/data/models/screen_argument_model.dart';
// import 'package:ResellerSalesMobile/cores/data/providers/provider_api.dart';
// import 'package:ResellerSalesMobile/cores/routes/pages.dart';
// import 'package:ResellerSalesMobile/cores/services/AuthService.dart';
// import 'package:ResellerSalesMobile/cores/services/ConnectivityService.dart';
import 'package:dio/dio.dart' as dio_http_client;
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:forisa_package/models/api/error_model.dart';
import 'package:forisa_package/models/app_model.dart';
import 'package:forisa_package/models/screen_argument_model.dart';
import 'package:forisa_package/providers/provider_api.dart';
import 'package:forisa_package/services/ConnectivityService.dart';
import 'package:get/get.dart';

import '../configs/config_constants.dart';
import '../routes/pages.dart';
import 'AuthService.dart';

class ApiUtil {
  static APIResponsePlain checkAPIResponsePlain(dynamic response) {
    if (response is dio_http_client.Response) {
      var rsp = response.data;
      String responseCode = rsp['response_code'] ?? '0';
      String responseMsg = rsp['response_msg'] ?? '-';

      switch (responseCode) {
        case APIProvider.INPUT_ERROR_API_CODE:
          ErrorModel inputErrorModel = ErrorModel.fromJson(response.data);
          return APIResponsePlain(
              code: responseCode,
              msg:
                  '${inputErrorModel.responseMsg}\n${inputErrorModel.error!.arrMessage!.join('\n')}');
        case APIProvider.GENERAL_ERROR_API_CODE:
          ErrorModel inputErrorModel = ErrorModel.fromJson(response.data);
          return APIResponsePlain(
              code: responseCode, msg: inputErrorModel.responseMsg);
        case APIProvider.INVALID_TOKEN_API_CODE:
          AuthService().logoutUser().whenComplete(() => Get.offAllNamed(Routes.LOGIN_PAGE, arguments: ScreenArgument(stringPayload: 'forced')));
          return APIResponsePlain(code: responseCode, msg: 'Invalid Token');
        case APIProvider.INVALID_AUTHCODE_API_CODE:
          ErrorModel inputErrorModel = ErrorModel.fromJson(response.data);
          return APIResponsePlain(
              code: responseCode, msg: inputErrorModel.responseMsg);
        case APIProvider.INVALID_VERSION_API_CODE:
          AppModel appModel = AppModel.fromJson(response.data);
          Get.offAllNamed(Routes.NEWUPDATE_PAGE,
              arguments: ScreenArgument(stringPayload: appModel.data!.storeUrl));
          return APIResponsePlain(
              code: responseCode,
              msg: 'New Update Available',
              payload: appModel.data!.storeUrl);
        default:
          return APIResponsePlain(code: responseCode, msg: responseMsg);
      }
    } else if (response is dio_http_client.DioError) {
      dio_http_client.DioError err = response;
      return APIResponsePlain(
          code: err.response == null ? '0' : (err.response?.statusCode.toString() ?? '0'),
          title: ConfigConstant.NETWORK_ERROR_TITLE,
          msg: !Get.find<ConnectivityService>().isNetworkAvailable()
              ? ConfigConstant.NETWORK_ERROR_MSG
              : err.message);
    } else {
      return APIResponsePlain(
          code: '-', title: 'Framework Error', msg: response.toString());
    }
  }
}
