enum Env { development, production }

class Config {
  static const int locationLoop = 3;
  static const double locationAccuracyThreshold = 50.0;
  //TODO change every time release (development/production)
  static const env = Env.production;

  static const bool isDebugMode = env != Env.production;
  static const String webUrl = env == Env.production
      ? 'https://hrapp.forisa.co.id'
      : 'https://hrapp.forisa.co.id:9444';
  static const String apiUrl = env == Env.production
      ? 'https://hrapp.forisa.co.id/api'
      : 'https://hrapp.forisa.co.id:9444/api';
  static const String sentryDsn = 'https://1b84ef81c90f41bb9e41008627edc212@o516922.ingest.sentry.io/5623999';
  static const String onesignalAppId = '41b96691-6608-4d12-a220-9ce4859f2a0e';

  static const String placeAndroidAPIKey = 'AIzaSyCXrwiLuQKip8x9DSqMFZt563tSXhBdGiY';
  static const String placeIosAPIKey = 'AIzaSyCXrwiLuQKip8x9DSqMFZt563tSXhBdGiY';
  static const bool onesignalService = true;
}
