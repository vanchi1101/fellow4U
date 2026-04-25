import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/forgotpass_page/forgot_pass_page.dart';
import 'package:sign_up_in/page/navigationbar/mainnavigation.dart';
import 'package:sign_up_in/page/signup/signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late Size mediaSize;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Splash.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 20, left: 20, child: _buildLogoTop()),
            Positioned(bottom: 0, child: _buildBottom()),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/Group.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(padding: EdgeInsets.all(30), child: _buildFormSignup()),
      ),
    );
  }

  Widget _buildFormSignup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign In',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Welcome back, Yoo Jin',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 19),
        _buildBlackText("Email"),
        _buildInputField(emailController, 'Type email'),
        SizedBox(height: 11),
        _buildBlackText("Password"),
        _buildInputField(passwordController, 'Type password', isPassword: true),
        SizedBox(height: 8),
        _buildLinkForgotPass(),
        SizedBox(height: 19),
        _buildButton(),
        SizedBox(height: 30),
        _buildTextSigninWith(),
        SizedBox(height: 25),
        _buildGroupSocial(),
        SizedBox(height: 55),
        _buildTextMoveSignup(),
      ],
    );
  }

  Widget _buildBlackText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label, {
    isPassword = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
        labelText: label,
        labelStyle: TextStyle(fontSize: 15, color: Color(0xff999999)),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildGroupSocial() {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          SizedBox(width: 20),
          Image.asset('assets/images/talk.png'),
          SizedBox(width: 20),
          Image.asset('assets/images/line.png'),
        ],
      ),
    );
  }

  Widget _buildLinkForgotPass() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgotPassPage()),
        );
      },
      child: Text(
        'Forgot Password',
        style: TextStyle(
          color: Color.fromARGB(255, 125, 125, 125),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextSigninWith() {
    return Center(
      child: Text(
        'or sign in with',
        style: TextStyle(
          color: Color(0xff555555),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 5,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3), // màu bóng
            blurRadius: 12, // độ mờ
            spreadRadius: 2, // độ lan
            offset: Offset(6, 6), // vị trí bóng (x, y)
          ),
        ],
        color: primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainNavigation()),
          );
        },
        child: Text(
          'SIGN IN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTextMoveSignup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Color(0xff757575), fontSize: 12),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
