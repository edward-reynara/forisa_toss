// import 'package:ResellerSalesMobile/cores/configs/config_colors.dart';
// import 'package:ResellerSalesMobile/cores/configs/config_constants.dart';
// import 'package:ResellerSalesMobile/cores/controllers/AuthController.dart';
// import 'package:ResellerSalesMobile/cores/data/models/screen_argument_model.dart';
// import 'package:ResellerSalesMobile/ui/widgets/buttons.dart';
// import 'package:ResellerSalesMobile/ui/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forisa_package/models/screen_argument_model.dart';
import 'package:forisa_package/widgets/buttons.dart';
import 'package:forisa_package/widgets/text_fields.dart';
import 'package:get/get.dart';

import '../../cores/configs/config_colors.dart';
import '../../cores/configs/config_constants.dart';
import '../../cores/controllers/AuthController.dart';

class LoginPage extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  final ScreenArgument _screenArgument = Get.arguments ?? ScreenArgument();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConfigColor.backgroundColor,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  repeat: ImageRepeat.noRepeat,
                  alignment: Alignment.centerLeft,
                  image: AssetImage(
                      'assets/images/login_background_decoration.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(
                  // vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: 20.0),
              decoration: BoxDecoration(
                // border: Border.all(),
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white.withOpacity(0.7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash_logo.png',
                      width: 250.0,
                      height: 100.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (_screenArgument.stringPayload == 'forced')
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Text(
                          ConfigConstant.AUTH_FORCED_LOGOUT,
                          style:
                              TextStyle(color: ConfigColor.secondaryTextColor),
                        ),
                      ),
                    Obx(() => defaultTxtField(
                        controller: controller.txtUsername,
                        label: 'Username*',
                        errorText: controller.txtUsernameError.value,
                        isDisable: controller.isSubmitting.value,
                        onChanged: (_) {
                          controller.txtUsernameError.value = '';
                        })),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Obx(() => defaultTxtField(
                        controller: controller.txtPassword,
                        label: 'Password*',
                        errorText: controller.txtPasswordError.value,
                        isDisable: controller.isSubmitting.value,
                        isSecret: !controller.passwordVisible.value,
                        maxlines: 1,
                        suffixIcon: IconButton(
                          icon: Icon(
                            !controller.passwordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            controller.passwordVisible.value =
                                !controller.passwordVisible.value;
                          },
                        ),
                        onChanged: (_) {
                          controller.txtPasswordError.value = '';
                        })),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Obx(() => buttonSubmitDefault(
                      context: context,
                      onPressed: () {
                        controller.doLogin();
                      },
                      text: 'Login',
                      iconData: FontAwesomeIcons.signInAlt,
                      isSubmitting: controller.isSubmitting.value,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
