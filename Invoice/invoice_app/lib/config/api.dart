class API {
  static const String baseUrl = "http://localhost:4000/api";

  static String login = "$baseUrl/auth/login";
  static String register = "$baseUrl/auth/register";

  static String clients = "$baseUrl/clients";
  static String items = "$baseUrl/items";
  static String invoices = "$baseUrl/invoices";
  
  static String companyMe = "$baseUrl/company/me";
  static String companyUpdate = "$baseUrl/company/me";
  static String companyLogo = "$baseUrl/company/logo";
}
