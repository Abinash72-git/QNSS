class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String verifyOtp = 'api/app/auth/verify-otp';
  final String login = 'api/app/auth/send-otp';
  final String getEmployee = 'api/app/customers/by-employee-mobile';
  final String getProduct = '/masterAdminProducts/get';
  final String addProduct = '/gsm/product';
  final String gsmProduct = '/gsm/getByUser';
}
