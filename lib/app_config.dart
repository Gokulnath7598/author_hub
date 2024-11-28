import 'package:flutter_config/flutter_config.dart';

enum Flavor { production, staging }

class AppConfig {

  AppConfig({required this.flavor, required this.appLabel, required this.scheme, required this.scope, required this.host});

  factory AppConfig.initiate() {
    return shared = AppConfig(
        flavor: (FlutterConfig.get('ENVIRONMENT') == 'staging') ? Flavor.staging : Flavor.production,
        appLabel: FlutterConfig.get('APP_LABEL').toString(),
        scheme: FlutterConfig.get('SCHEME').toString(),
        scope: FlutterConfig.get('SCOPE').toString(),
        host: FlutterConfig.get('HOST').toString());
  }
  Flavor flavor;
  String appLabel;
  String scheme;
  String scope;
  String host;

  static AppConfig shared = AppConfig.initiate();
}
