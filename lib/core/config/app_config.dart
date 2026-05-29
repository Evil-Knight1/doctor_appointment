class AppConfig {
  final String apiUrl;
  final String paymobApiKey;
  final String paymobIntegrationId;
  final String paymobIframeId;
  final String googleMapsApiKey;

  AppConfig({
    required this.apiUrl,
    required this.paymobApiKey,
    required this.paymobIntegrationId,
    required this.paymobIframeId,
    required this.googleMapsApiKey,
  });

  void validate() {
    if (apiUrl.isEmpty) {
      throw Exception("API_URL is not defined");
    }
  }
}
