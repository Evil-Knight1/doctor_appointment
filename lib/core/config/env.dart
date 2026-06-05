import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnv() async {
  await dotenv.load(fileName: "assets/envs/.env");
}

abstract class Env {
  static String get apiUrl => dotenv.env["API_URL"] ?? "";
  static String get paymobApiKey => dotenv.env["PAYMOB_API_KEY"] ?? "";
  static String get paymobIntegrationId =>
      dotenv.env["PAYMOB_INTEGRATION_ID"] ?? "";
  static String get paymobIframeId => dotenv.env["PAYMOB_IFRAME_ID"] ?? "";
  static String get googleMapsApiKey => dotenv.env["GOOGLE_MAPS_API"] ?? "";
  static String get paymobMobileWalletId =>
      dotenv.env["PAYMOB_MOBILE_WALLET_ID"] ?? "";
  static String get paymobWalletNumber =>
      dotenv.env["PAYMOB_WALLET_NUMBER"] ?? "";
}
