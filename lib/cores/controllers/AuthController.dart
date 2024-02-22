// import 'package:ResellerSalesMobile/cores/configs/config_constants.dart';
// import 'package:ResellerSalesMobile/cores/data/models/api/api_response_plain.dart';
// import 'package:ResellerSalesMobile/cores/data/models/login_model.dart';
// import 'package:ResellerSalesMobile/cores/data/providers/provider_pref.dart';
// import 'package:ResellerSalesMobile/cores/routes/pages.dart';
// import 'package:ResellerSalesMobile/cores/services/AuthService.dart';
// import 'package:ResellerSalesMobile/cores/services/CryptoService.dart';
// import 'package:ResellerSalesMobile/cores/utils/AlertUtil.dart';
import 'package:flutter/material.dart';
import 'package:forisa_package/providers/provider_pref.dart';
import 'package:forisa_package/services/CryptoService.dart';
import 'package:forisa_package/utils/AlertUtil.dart';
import 'package:forisa_package/models/api/api_response_plain.dart';
import 'package:get/get.dart';

import '../configs/config_constants.dart';
import '../data/models/login_model.dart';
import '../routes/pages.dart';
import '../services/AuthService.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  var txtUsernameError = ''.obs;
  var txtPasswordError = ''.obs;
  var isSubmitting = false.obs;
  var passwordVisible = false.obs;

  //ChangePassword
  final TextEditingController txtNewPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();
  var newPasswordVisible = false.obs;
  var confirmPasswordVisible = false.obs;
  var txtNewPasswordError = ''.obs;
  var txtConfirmPasswordError = ''.obs;

  bool validateChangePasswordForm() {
    bool isValid = true;

    if (txtPassword.text.isEmpty) {
      txtPasswordError.value = 'Isian tidak valid';
      isValid = false;
    }
    if (txtNewPassword.text.length < 6) {
      txtNewPasswordError.value = 'Minimal 6 karakter';
      isValid = false;
    }
    if (txtNewPassword.text.isEmpty) {
      txtNewPasswordError.value = 'Isian tidak valid';
      isValid = false;
    }
    if (txtConfirmPassword.text.length < 6) {
      txtConfirmPasswordError.value = 'Minimal 6 karakter';
      isValid = false;
    }
    if (txtConfirmPassword.text.isEmpty) {
      txtConfirmPasswordError.value = 'Isian tidak valid';
      isValid = false;
    }
    if (txtNewPassword.text != txtConfirmPassword.text) {
      txtConfirmPasswordError.value = 'Password konfirmasi tidak sama';
      isValid = false;
    }

    return isValid;
  }

  void changePassword() async {
    if (validateChangePasswordForm()) {
      try {
        isSubmitting.value = true;
        String? username = await PrefProvider.secureStorage
            .read(key: PrefProvider.USERNAME_KEY);
        APIResponsePlain rsp = await _authService.changeUserPassword(
            username ?? '-',
            CryptoService.maskInput(txtPassword.text),
            CryptoService.maskInput(txtNewPassword.text));

        AlertUtil.showSnackbarStatic('Response', rsp.msg!, AlertStatus.success);
      } on APIResponsePlain catch (e) {
        AlertUtil.showSnackbarStatic('Response', e.msg!, AlertStatus.error);
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  bool validateForm() {
    bool isValid = true;

    if (txtUsername.text.isEmpty) {
      txtUsernameError.value = 'Isian tidak valid';
      isValid = false;
    }
    if (txtPassword.text.isEmpty) {
      txtPasswordError.value = 'Isian tidak valid';
      isValid = false;
    }

    return isValid;
  }

  doLogin() async {
    AlertUtil alertUtil = AlertUtil();
    if (validateForm()) {
      try {
        isSubmitting.value = true;
        LoginModel loginModel = await _authService.doLogin(
            txtUsername.text,
            CryptoService.maskInput(txtPassword.text));
        await PrefProvider.secureStorage
            .write(key: PrefProvider.TOKEN_KEY, value: loginModel.data!.token);
        await PrefProvider.secureStorage.write(
            key: PrefProvider.USERNAME_KEY, value: loginModel.data!.username);
        Get.offAllNamed(Routes.MAIN_LAYOUT);
      } on APIResponsePlain catch (e) {
        alertUtil.showSnackbar(
            ConfigConstant.ALERT_RESPONSE, e.msg!, AlertStatus.error);
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  Future<void> doLogout(BuildContext context) async {
    AlertUtil alertUtil = AlertUtil();
    bool conf = await alertUtil.showConfirmDialog(context,
        msg: 'Anda yakin akan logout ?');
    if (conf) {
      await _authService.logoutUser();
      Get.offAllNamed(Routes.LOGIN_PAGE);
    }
  }
}
