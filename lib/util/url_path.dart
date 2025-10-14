class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String verifyOtp = 'api/app/auth/verify-otp';
  final String login = 'api/app/auth/send-otp';
  final String getStore = '/store/getStores';
  final String getProduct = '/masterAdminProducts/get';
  final String addProduct = '/gsm/product';
  final String gsmProduct = '/gsm/getByUser';
}
