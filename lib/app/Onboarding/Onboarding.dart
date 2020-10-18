import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import '../Auth/Login/Login.dart';
import '../Auth/Signup/SignUpWelcome.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Reach more customers",
        description:
            "Vivamus amet, quam egestas elementum purus, viverra sed volutpat placerat",
        pathImage: "assets/images/intro_one.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Reach more customers",
        description:
            "Vivamus amet, quam egestas elementum purus, viverra sed volutpat placerat",
        pathImage: "assets/images/intro_one.png",
      ),
    );
    slides.add(
      new Slide(
        title: "Reach more customers",
        description:
            "Vivamus amet, quam egestas elementum purus, viverra sed volutpat placerat",
        pathImage: "assets/images/intro_one.png",
      ),
    );
  }

  void onDonePress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: Image.asset(
                currentSlide.pathImage,
                width: 331.0,
                height: 246.0,
                fit: BoxFit.contain,
              )),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    currentSlide.title,
                    style: AppTheme.textStyle.w700.size(22).color100,
                    textAlign: TextAlign.left,
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: double.infinity,
                  child: Flexible(
                    child: Text(
                      currentSlide.description,
                      style: AppTheme.textStyle.w500.size(15).color50,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                    ),
                  ),
                  margin: EdgeInsets.only(top: 20.0),
                ),
              ),
            ],
          )));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: IntroSlider(
            //backgroundColorAllSlides: AppTheme.primaryColor,
            slides: this.slides,
            colorDot: AppTheme.primaryColor,
            onDonePress: this.onDonePress,
            listCustomTabs: this.renderListCustomTabs(),
            colorSkipBtn: AppTheme.primaryColor,
            colorDoneBtn: AppTheme.primaryColor,
            highlightColorDoneBtn: AppTheme.primaryColor),
      ),
    );
  }
}
