import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import "../home-screen/home.dart";
import "./ForgotPin.dart";

class EnterPin extends StatefulWidget {
  static const routeName = '/login-enter-pin';
  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
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
                title: "Enter PIN",
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
                        "Please enter your PIN to login",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...[1, 2, 3, 4].map((_r) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Home()));
                              },
                              color: Color(0xff179F57),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, bottom: 18),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: FlatButton(
                        child: Text(
                          'Forgot PIN?',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff179F57)),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(LoginForgotPin.routeName);
                        },
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
