import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import "./SignUpPinSucessFull.dart";

class SignUpSetPin extends StatefulWidget {
  static const routeName = '/signup-setpin';
  @override
  _SignUpSetPinState createState() => _SignUpSetPinState();
}

class _SignUpSetPinState extends State<SignUpSetPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppHeader(
                          title: "Set PIN",
                          actionWidget: InkWell(
                            onTap: () {
                              debugPrint('I am Awesome');
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Last step! You are almost done. Going forward this 4-digit pin will be used to login.",
                          style: TextStyle(
                              color: Color(0xff121715).withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ...[1, 2, 3, 4].map((_r) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 6, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 40,
                                    child: TextField(
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Color(0xff121715)
                                              .withOpacity(0.25)),
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      decoration: InputDecoration(
                                          hintText: "0",
                                          border: InputBorder.none,
                                          counterText: ''),
                                      textAlign: TextAlign.center,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Color(0xff121715).withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignupPinSuccessfull()));
                              },
                              color: Color(0xff179F57),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 14, bottom: 14, left: 18, right: 18),
                                child: Text(
                                  'Set PIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
