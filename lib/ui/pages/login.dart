import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:forisa_attendance/models/model_arguments.dart';
// import 'package:forisa_attendance/models/model_default.dart';
// import 'package:forisa_attendance/models/model_error.dart';
// import 'package:forisa_attendance/models/model_user.dart';
// import 'package:forisa_attendance/utils/api_service.dart';
// import 'package:forisa_attendance/utils/tools.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../cores/models/model_arguments.dart';
import '../../cores/models/model_default.dart';
import '../../cores/models/model_error.dart';
import '../../cores/models/model_user.dart';
import '../../cores/utils/api_service.dart';
import '../../cores/utils/tools.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool passwordVisible = false;
  ApiService apiService = ApiService();
  String errorMessage = '';

  @override
  void dispose() {
    nikController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Center(
            child: loginBody(),
          );
        }));
  }

  loginBody() => SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[loginHeader(), loginFields()],
          ),
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            scale: 1.4,
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );

  loginFields() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                controller: nikController,
                maxLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    // hintText: "xxxxxxxx",
                    labelText: "ID Karyawan",
                    suffixIcon: Icon(Icons.person)),
                // keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  // FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 30.0,
              ),
              child: TextField(
                controller: passwordController,
                maxLines: 1,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    // hintText: "Masukan Password Anda",
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    )),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: Builder(builder: (BuildContext context) {
                return ElevatedButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.signInAlt,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all(StadiumBorder()),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () => doLogin(),
                );
              }),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "2019 PT. Forisa Nusapersada",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

  void doLogin() {
    String nik = nikController.text;
    String password = passwordController.text;
    bool valid = true;

    // !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) -- validate email

    if (nik.isEmpty) {
      valid = false;
    }

    if (password.isEmpty || password.length < 6) {
      valid = false;
    }

    if (valid) {
      requestLogin(nik, password);
    } else {
      Tools.showAlert(context, "Validasi", "Form Tidak Valid", "error");
    }
  }

  Future<void> requestLogin(nik, password) async {
    Dio dio = apiService.getApiClient(useToken: false, context: context);
    Response response;
    LoginResponse loginResponse;

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      await EasyLoading.show();
      response = await dio.post("/login", data: {
        "username": nik,
        "password": password,
        "os_type": Platform.operatingSystem
      });
      loginResponse = LoginResponse.fromJson(response.data);

      // OneSignal.shared.disablePush(false);
      await secureStorage.write(key: 'token', value: loginResponse.token);
      await secureStorage.write(
          key: 'name', value: loginResponse.user.displayName);
      await secureStorage.write(key: 'nik', value: loginResponse.user.userName);
      Navigator.of(context).pushReplacementNamed('/layout',
          arguments: ScreenArguments(stringData: loginResponse.token));
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 422) {
          ErrorModel errorResponse = ErrorModel.fromJson(e.response!.data);
          Tools.showAlert(context, 'Response',
              errorResponse.message.join('\n').toString(), 'error');
        } else {
          DefaultModel defaultModel = DefaultModel.fromJson(e.response!.data);
          Tools.showAlert(context, 'Response', defaultModel.msg,
              defaultModel.status == 1 ? 'success' : 'error');
        }
      } else {
        Tools.showAlert(context, 'Response', e.message ?? "", 'error');
      }
    } finally {
      await EasyLoading.dismiss();
    }
  }
}

class LoginResponse {
  String status;
  String token;
  User user;

  LoginResponse({
    required this.status,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        status: json["status"],
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "user": user.toJson(),
      };
}
