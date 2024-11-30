class EndPoints {
  // production:
  static const String _baseUrl = 'https://progym.pythonanywhere.com/';

  // local emulator:
  // static const String _baseUrl = 'http://10.0.2.2:8000/';

  // local edge:
  // static const String _baseUrl = 'http://localhost:8000/';

  static const String _loginUrl = "api/clients/client-login/";
  static const String _clientDetail = "api/clients/client/";
  static const String _clientData = "api/clients/client-data/";
  static const String _changeClientPassword =
      "api/clients/change-client-password/";
  static const String _clientLatestSubscriptions =
      "api/clients/client-latest-subscriptions/";

  static const String _clientSubscriptionsHistory =
      "api/subscriptions/subscription/";

  static const String _subscriptionPlans =
      "api/subscriptions/subscription-plan/";

  static String login() => '$_baseUrl$_loginUrl';

  static String clientDetail(String id) => '$_baseUrl$_clientDetail$id/';

  static String clientData() => '$_baseUrl$_clientData';

  static String changeClientPassword() => '$_baseUrl$_changeClientPassword';

  static String clientLatestSubscriptions() =>
      '$_baseUrl$_clientLatestSubscriptions';

  static String clientSubscriptionsHistory(int id, int page) =>
      "$_baseUrl$_clientSubscriptionsHistory?client_id=$id&page=$page";

  static String subscriptionPlans(int page) =>
      '$_baseUrl$_subscriptionPlans?page=$page';
}
