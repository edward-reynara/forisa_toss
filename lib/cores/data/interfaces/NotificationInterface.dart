import 'dart:async';
import 'package:forisa_package/models/api/api_response_plain.dart';

abstract class INotificationService {
  FutureOr<String> getPlayerId();
  Future<bool> checkSubscribeStatus(String playerId);
  Future<APIResponsePlain> updateSubscription(String playerId, bool subscribe);
}