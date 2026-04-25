import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/signin/signin_page.dart';

class CheckemailPage extends StatefulWidget {
  const CheckemailPage({super.key});

  @override
  State<CheckemailPage> createState() => _CheckemailPageState();
}

class _CheckemailPageState extends State<CheckemailPage> {
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
        child: Padding(padding: EdgeInsets.all(30), child: _buildEmail()),
      ),
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          textAlign: TextAlign.start,
          'Check Email',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 20),
        Text(
          textAlign: TextAlign.start,
          'Please check your email for the instructions on \nhow to reset your password.',
          style: TextStyle(
            color: Color(0xff555555),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 28),
        _buildImageEmail(),
        SizedBox(height: 90),
        _buildTextMoveSignin(),
      ],
    );
  }

  Widget _buildImageEmail() {
    return Column(children: [Image.asset('assets/images/envelope.png')]);
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
