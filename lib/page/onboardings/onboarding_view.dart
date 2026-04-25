import 'package:flutter/material.dart';
import 'package:sign_up_in/component/color.dart';
import 'package:sign_up_in/page/onboardings/onboarding_items.dart';
import 'package:sign_up_in/page/signup/signup_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastpage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomSheet(khung đáy) để hieneer thị các chức năng skip/next page
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
        color: Colors.white,
        child: isLastpage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: () =>
                        pageController.jumpToPage(controller.items.length - 1),
                    child: Text('Skip'),
                  ),

                  // Indicator
                  SmoothPageIndicator(
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeIn,
                    ),
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: primaryColor,
                    ),
                    controller: pageController,
                    count: controller.items.length,
                  ),

                  // Next button
                  TextButton(
                    onPressed: () => pageController.nextPage(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeIn,
                    ),
                    child: Text('Next'),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index) => setState(() {
            isLastpage = controller.items.length - 1 == index;
          }),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(controller.items[index].image),
                SizedBox(height: 15),
                Text(
                  controller.items[index].title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  controller.items[index].description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff555555),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Get button started
  Widget getStarted() {
    return Container(
      width: MediaQuery.of(context).size.width * 5,
      height: 55,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: () {
          // khi bấm vào nút get started thì chuyển hướng sang signup page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignupPage()),
          );
        },
        child: Text(
          'GET STARTED',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
