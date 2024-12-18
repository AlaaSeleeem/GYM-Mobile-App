class EndPoints {
  // production:
  static const String _baseUrl = 'https://progym.pythonanywhere.com/';
  static const String frontedBaseUrl = 'https://progym.vercel.app/';

  // local emulator:
  // static const String _baseUrl = 'http://10.0.2.2:8000/';
  // static const String frontedBaseUrl = 'http://10.0.2.2:5173/';

  // local edge:
  // static const String _baseUrl = 'http://localhost:8000/';
  // static const String frontedBaseUrl = 'http://localhost:5173/';

  static const String _loginUrl = "api/clients/client-login/";

  static const String _clientDetail = "api/clients/client/";

  static const String _clientData = "api/clients/client-data/";

  static const String _changeClientPassword =
      "api/clients/change-client-password/";

  static const String _deleteRequestedPhoto =
      "api/clients/delete-requested-photo/";

  static const String _clientLatestSubscriptions =
      "api/clients/client-latest-subscriptions/";

  static const String _clientSubscriptionsHistory =
      "api/subscriptions/subscription/";

  static const String _invitations = "api/subscriptions/invitation/";

  static const String _subscriptionInvitations =
      "api/subscriptions/subscription-invitations/";

  static const String _createInvitation =
      "api/subscriptions/create-invitation/";

  static const String _subscriptionPlans =
      "api/subscriptions/subscription-plan/";

  static const String _news = "api/clients/new/";

  static const String _categories = "api/shop/product-category/";

  static const String _products = "api/shop/product-mobile/";

  static const String _orders = "api/shop/sale/";

  static const String _makeOrder = "api/shop/make-order/";

  static String login() => '$_baseUrl$_loginUrl';

  static String clientDetail(String id) => '$_baseUrl$_clientDetail$id/';

  static String clientData() => '$_baseUrl$_clientData';

  static String changeClientPassword() => '$_baseUrl$_changeClientPassword';

  static String deleteRequestedPhoto() => '$_baseUrl$_deleteRequestedPhoto';

  static String clientLatestSubscriptions() =>
      '$_baseUrl$_clientLatestSubscriptions';

  static String clientSubscriptionsHistory(int id, int page) =>
      "$_baseUrl$_clientSubscriptionsHistory?client_id=$id&page=$page";

  static String invitation(int id) => '$_baseUrl$_invitations$id/';

  static String subscriptionInvitations() =>
      "$_baseUrl$_subscriptionInvitations";

  static String createInvitation() => '$_baseUrl$_createInvitation';

  static String subscriptionPlans(int page) =>
      '$_baseUrl$_subscriptionPlans?page=$page';

  static String news(int page) => '$_baseUrl$_news?page=$page';

  static String categories() => '$_baseUrl$_categories?no_pagination=true';

  static String products(int page, String search, String category) =>
      '$_baseUrl$_products?page=$page&search=$search&category=$category';

  static String order(int id) => '$_baseUrl$_orders$id/';

  static String orders(int page, String clientId) =>
      '$_baseUrl$_orders?page=$page&client_id=$clientId';

  static String makeOrder() => '$_baseUrl$_makeOrder';
}
