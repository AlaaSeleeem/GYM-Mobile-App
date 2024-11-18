class EndPoints {
  // static const String _baseUrl = 'http://10.0.2.2:8000/';
  static const String _baseUrl = 'https://progym.pythonanywhere.com/';
  static const String _loginUrl = "api/clients/client-login/";

  static String login() => '$_baseUrl$_loginUrl';
}
