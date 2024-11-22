class EndPoints {
  static const String _baseUrl = 'https://progym.pythonanywhere.com/';

  // static const String _baseUrl = 'http://10.0.2.2:8000/';

  static const String _loginUrl = "api/clients/client-login/";
  static const String _clientLatestSubscriptions =
      "api/clients/client-latest-subscriptions/";
  static const String _subscriptionPlans =
      "api/subscriptions/subscription-plan/";

  static String login() => '$_baseUrl$_loginUrl';

  static String clientLatestSubscriptions() =>
      '$_baseUrl$_clientLatestSubscriptions';

  static String subscriptionPlans(int page) =>
      '$_baseUrl$_subscriptionPlans?page=$page';
}
