import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

//my imports
import 'package:illustrashirt/constants.dart';
import 'package:illustrashirt/main.dart';
import 'package:illustrashirt/screens/Enterance.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {

  //Widget For Title
  Widget titleWidget(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: KprimaryColor,
            fontSize: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
          child: Text(
            subTitle,
            style: TextStyle(
              color: KbuttonColor,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  //List of Pages


  @override
  Widget build(BuildContext context) {

    final withScreen = MediaQuery.of(context).size.width;
    final heightScreen = MediaQuery.of(context).size.height;

    List<PageViewModel> getPages() {
      return [
        PageViewModel(
          image: Padding(
            padding: EdgeInsets.only(top:100),
            child: Image.asset(
              'assets/images/onBoardings/onboarding_1.png',

            ),
          ),
          titleWidget: titleWidget(
            "ORIGINAL DESIGNS",
            "OF ILLUSTRASHIRT",
          ),
          bodyWidget: Text("All what we list here is made by our designers.",
              textAlign: TextAlign.center,
              style: TextStyle(color: KbuttonColor,)),
          footer: Text(
            "@AppDev_HiTec",
            style: TextStyle(color: KbuttonColor),
          ),
        ),

        PageViewModel(
          image: Padding(
            padding: const EdgeInsets.only(top:100),
            child: new Image.asset('assets/images/onBoardings/onboarding_2.png',),
          ),
          titleWidget: titleWidget(
            "PREMIUM QUALITY",
            "OF ILLUSTRASHIRT",
          ),
          bodyWidget: Text("We pick only premium and luxurious materials for our products that provides COMFORT..",
              textAlign: TextAlign.center,
              style: TextStyle(color: KbuttonColor)),
          footer: Text(
            "@AppDev_HiTec",
            style: TextStyle(color: KbuttonColor, fontSize: 12),
          ),
        ),

        PageViewModel(
          image: Padding(
            padding: const EdgeInsets.only(top:100),
            child: new Image.asset('assets/images/onBoardings/onboarding_3.png',),
          ),
          titleWidget: titleWidget(
            "OVER 100 DESIGNS",
            "OF ILLUSTRASHIRT",
          ),
          bodyWidget: Text("Wide range  of designs and multiple different categories and topics. and as we're talking right now,numbers are getting bumped up fast.",
              textAlign: TextAlign.center,
              style: TextStyle(color: KbuttonColor)),
          footer: Text(
            "@AppDev_HiTec",
            style: TextStyle(color: KbuttonColor, fontSize: 12),
          ),
        ),
      ];
    }

    return Scaffold(
      backgroundColor: KsecondaryColor,
      body: IntroductionScreen(
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(color: KbuttonColor),
        ),
        dotsDecorator: DotsDecorator(
          activeColor: KprimaryColor,
          color: KbuttonColor,
        ),
        onSkip: () {
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Enterance()));
          },
        globalBackgroundColor: KsecondaryColor,
        done: Text(
          "Done",
          style: TextStyle(
            color: KbuttonColor,
          ),
        ),
        pages: getPages(),
        onDone: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Enterance()));
        },
      ),
    );
  }
}
