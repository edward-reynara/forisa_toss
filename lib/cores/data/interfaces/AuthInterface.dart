import 'package:forisa_package/models/api/api_response_plain.dart';
import '../models/badge_notif_model.dart';
import '../models/current_progress_model.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

abstract class IAuthService {
  Future<LoginModel> doLogin(String username, String password);
  void logoutUser();
  Future<UserModel> getUserData();
  Future<APIResponsePlain> changeUserPassword(String username, String oldPassword, String newPassword);
  Future<BadgeNotifModel> getNotifBadge();
  Future<CurrentProgressModel> getCurrentProgress();
}