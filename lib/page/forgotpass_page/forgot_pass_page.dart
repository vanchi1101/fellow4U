import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/checkemail_page/checkemail_page.dart';
import 'package:sign_up_in/page/signin/signin_page.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  late Size mediaSize;

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
            Positioned(bottom: 0, top: 120, child: _buildBottom()),
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
        child: Padding(padding: EdgeInsets.all(30), child: _buildBoxForgot()),
      ),
    );
  }

  Widget _buildBoxForgot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.start,
          'Input your email, we will send you an \ninstruction to reset your password.',
          style: TextStyle(
            color: Color(0xff555555),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 19),
        _buildBlackText("Email"),
        _buildInputField(),
        SizedBox(height: 60),
        _buildButton(),
        SizedBox(height: 140),
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

  Widget _buildInputField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "yoo123@gmail.com",
        hintStyle: TextStyle(
          color: const Color(0xff121212),
          fontSize: 16,
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CheckemailPage()),
          );
        },
        child: Text(
          'SEND',
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
          "Back to ",
          style: TextStyle(color: Color(0xff757575), fontSize: 14),
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
