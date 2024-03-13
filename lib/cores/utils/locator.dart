import 'package:forisa_toss/cores/utils/route_obeserver.dart';
import 'package:get_it/get_it.dart';

import '../configs/states.dart';
import 'cache_model.dart';
import 'navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerSingleton(NavigationService());
  locator.registerSingleton(RouteObserverService());
  locator.registerSingleton(CacheModel());
  locator.registerSingleton(States());
}