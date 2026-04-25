import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/signin/signin_page.dart';
// import 'package:sign_up_in/config/top_curve_clipper.dart';
// import 'package:sign_up_in/component/color.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
          'Sign up',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        _buildInputRadio(),
        _buildUsername(),
        SizedBox(height: 11),
        _buildBlackText("Country"),
        _buildInputField(countryName, 'Coutry'),
        SizedBox(height: 11),
        _buildBlackText("Email"),
        _buildInputField(emailController, 'Type email'),
        SizedBox(height: 11),
        _buildBlackText("Password"),
        _buildInputField(passwordController, 'Type password', isPassword: true),
        SizedBox(height: 11),
        _buildBlackText("Confirm Password"),
        _buildInputField(
          confirmPasswordController,
          'Repeat password',
          isPassword: true,
        ),
        SizedBox(height: 19),
        _buildTextJoin(),
        SizedBox(height: 15),
        _buildButton(),
        SizedBox(height: 20),
        _buildTextMoveSignin(),
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

  Widget _buildUsername() {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlackText("First Name"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Yoo',
                  hintStyle: TextStyle(
                    color: const Color(0xff121212),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlackText("Last Name"),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Jin',
                  hintStyle: TextStyle(
                    color: const Color(0xff121212),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     Column(
    //       children: [
    //         _buildBlackText("First Name"),
    //         _buildInputField(firstName, 'Yoo', userName: 'Yoo'),
    //       ],
    //     ),
    //     SizedBox(width: 11),
    //     Column(
    //       children: [
    //         _buildBlackText("First Name"),
    //         _buildInputField(lastName, 'Jin', userName: 'Jin'),
    //       ],
    //     ),
    //   ],
    // );
  }

  Widget _buildInputRadio() {
    int userType = 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<int>(
              activeColor: primaryColor,
              value: 1, // default value
              groupValue: userType,
              onChanged: (value) {
                setState(() {
                  userType = value!;
                });
              },
            ),
            Text(
              'Traveller',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(width: 45),
        Row(
          children: [
            Radio<int>(
              value: 2,
              groupValue: userType,
              onChanged: (value) {
                setState(() {
                  userType = value!;
                });
              },
            ),
            Text(
              'Guide',
              style: TextStyle(
                color: Color(0xff333333),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildTextJoin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'By Signing Up, you agree to our ',
          style: TextStyle(color: Color(0xff757575), fontSize: 12),
        ),
        Text(
          'Terms & Conditions',
          style: TextStyle(color: primaryColor, fontSize: 12),
        ),
      ],
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
        onPressed: () {},
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTextMoveSignin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Color(0xff757575), fontSize: 12),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SigninPage()),
            );
          },
          child: Text(
            'Sign In',
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
