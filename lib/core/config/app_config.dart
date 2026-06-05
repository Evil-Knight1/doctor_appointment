class AppConfig {
  final String apiUrl;
  final String paymobApiKey;
  final String paymobIntegrationId;
  final String paymobIframeId;
  final String googleMapsApiKey;
  final String paymobMobileWalletId;
  final String paymobWalletNumber;

  AppConfig({
    required this.apiUrl,
    required this.paymobApiKey,
    required this.paymobIntegrationId,
    required this.paymobIframeId,
    required this.googleMapsApiKey,
    required this.paymobMobileWalletId,
    required this.paymobWalletNumber,
  });

  void validate() {
    if (apiUrl.isEmpty) {
      throw Exception("API_URL is not defined");
    }
    if (paymobApiKey.isEmpty) {
      throw Exception("PAYMOB_API_KEY is not defined");
    }
    if (paymobIntegrationId.isEmpty) {
      throw Exception("PAYMOB_INTEGRATION_ID is not defined");
    }
    if (paymobIframeId.isEmpty) {
      throw Exception("PAYMOB_IFRAME_ID is not defined");
    }
    if (googleMapsApiKey.isEmpty) {
      throw Exception("GOOGLE_MAPS_API is not defined");
    }
    if (paymobMobileWalletId.isEmpty) {
      throw Exception("PAYMOB_MOBILE_WALLET_ID is not defined");
    }
    if (paymobWalletNumber.isEmpty) {
      throw Exception("PAYMOB_WALLET_NUMBER is not defined");
    }
  }
}
