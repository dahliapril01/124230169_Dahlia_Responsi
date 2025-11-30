class ApiConstants {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';
  static const String articles = '/articles/';
  static const String blogs = '/blogs/';
  static const String reports = '/reports/';
  
  static String getEndpoint(String category) {
    return '$baseUrl/$category/';
  }
  
  static String getDetailEndpoint(String category, String id) {
    return '$baseUrl/$category/$id/';
  }
}

class StorageKeys {
  static const String isLoggedIn = 'isLoggedIn';
  static const String username = 'username';
  static const String registeredUsername = 'registered_username';
  static const String registeredPassword = 'registered_password';
}