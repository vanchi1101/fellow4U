class AuthService {
  static void signIn(String email, String password) {
    if (email == 'test@gmail.com' && password == '123456') {
      print('Đăng nhập thành công');
    } else {
      print('Sai tài khoản hoặc mật khẩu');
    }
  }

  static void signUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    print('Đăng ký thành công: $email');
  }
}
