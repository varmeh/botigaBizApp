import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../../theme/index.dart';
import '../auth/index.dart' show Welcome;

class IntroScreen extends StatelessWidget {
  static const routeName = 'intro';

  final List<Slide> _slides = [
    Slide(
      title: 'Sell your products in communities',
      description:
          'Keep track of all orders and improve delivery efficiency with our smart delivery system.',
      pathImage: 'assets/images/intro_111.png',
    ),
    Slide(
      title: 'Manage orders & deliveries',
      description:
          'Keep track of all orders and improve delivery efficiency with our smart delivery system.',
      pathImage: 'assets/images/intro_22.png',
    ),
    Slide(
      title: 'Reach more customers',
      description: 'Get instant access to communities to expand your business.',
      pathImage: 'assets/images/intro_33.png',
    ),
    Slide(
      title: '0% Commissions',
      description:
          'Receive money directly to your bank account in 1 day. Absolutely free.',
      pathImage: 'assets/images/intro_44.png',
    ),
  ];

  Widget _customTab(Slide slide) {
    const _textPadding = const EdgeInsets.symmetric(horizontal: 40);

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Image.asset(
              slide.pathImage,
              height: 246.0,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 100),
          Padding(
            padding: _textPadding,
            child: Container(
              width: double.infinity,
              child: Text(
                slide.title,
                style: AppTheme.textStyle.w700.size(22).color100,
                textAlign: TextAlign.center,
              ),
              margin: EdgeInsets.only(top: 20.0),
            ),
          ),
          Flexible(
            child: Padding(
              padding: _textPadding,
              child: Container(
                width: double.infinity,
                child: Text(
                  slide.description,
                  style: AppTheme.textStyle.w500.size(15).color50,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: IntroSlider(
          slides: this._slides,
          colorDot: AppTheme.color25,
          colorActiveDot: AppTheme.primaryColor,
          onDonePress: () {
            Navigator.of(context).pushNamed(Welcome.routeName);
          },
          listCustomTabs: _slides.map((slide) => _customTab(slide)).toList(),
          colorSkipBtn: AppTheme.backgroundColor,
          styleSkipBtn: AppTheme.textStyle.w500.size(15).color50,
          nameSkipBtn: 'Skip',
          nameNextBtn: 'Next',
          nameDoneBtn: 'Done',
          colorDoneBtn: AppTheme.backgroundColor,
          styleDoneBtn:
              AppTheme.textStyle.w500.size(15).colored(AppTheme.primaryColor),
          highlightColorDoneBtn: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
