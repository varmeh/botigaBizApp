import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import "../SignUp/SignUpSetPin.dart";

class LoginForgotPin extends StatefulWidget {
  static const routeName = '/forgot-pin';
  @override
  _LoginForgotPinState createState() => _LoginForgotPinState();
}

class _LoginForgotPinState extends State<LoginForgotPin> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Color(0xff179F57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 70, bottom: 60, left: 20, right: 20),
              child: LoginSignupHeader(
                title: "Forgot PIN",
                actionWidget: SizedBox.shrink(),
                showBackBtn: true,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 22, right: 22, top: 32),
                decoration: new BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(32.0),
                    topRight: const Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Please enter OTP sent to your phone number 98480 12345",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...[1, 2, 3, 4, 5, 6].map((_r) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 40,
                                child: TextField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color:
                                          Color(0xff121715).withOpacity(0.25)),
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      border: InputBorder.none,
                                      counterText: ''),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff121715).withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Text(
                      "Resend OTP in 30s",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff121715).withOpacity(0.5)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignUpSetPin.routeName);
                            },
                            color: Color(0xff179F57),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 18, bottom: 18, left: 50, right: 50),
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
