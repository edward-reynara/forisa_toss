enum Env { production, development }

abstract class ConfigApp {
  //TODO change every time release (development/production)
  static const env = Env.development;

  static const String webUrl = env == Env.production
      ? 'https://reseller.forisa.co.id'
      : 'https://reseller.forisa.co.id:8710';
  static const String apiUrl = env == Env.production
      ? 'https://reseller.forisa.co.id/api'
      : 'https://reseller.forisa.co.id:8710/api';

  static const String locale = 'id_ID';
  static const String lang = 'ID';
  static const String placeAndroidAPIKey =
      'AIzaSyCXrwiLuQKip8x9DSqMFZt563tSXhBdGiY';
  static const String placeIosAPIKey =
      'AIzaSyCXrwiLuQKip8x9DSqMFZt563tSXhBdGiY';
  static const String oneSignalAPIKey = env == Env.production
      ? '8ce97c5e-a33f-4ca8-95ba-601afa74e99a'
      : '232ad261-d527-40f3-bede-a584408f1855';
  static const String sentryDsn =
      'https://6b6e92e1d5d04390b851fcfb70204473@o516922.ingest.sentry.io/5805528';

  //API Config
  static const String clientApiKey = 'ZZSAWdmJodSFzUMOf9I0tsC7gB6yeaDa7CoX5tB5';
  static const String clientApiId = '5';
  static const String clientAppCode = 'RMS';
}
