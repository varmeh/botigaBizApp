import 'dart:async';

import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import '../../../widget/common/appHeader.dart';
import '../Signup/SetPin.dart';
import '../../../providers/Auth/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

class LoginForgotPin extends StatefulWidget {
  static const routeName = '/forgot-pin';
  @override
  _LoginForgotPinState createState() => _LoginForgotPinState();
}

class _LoginForgotPinState extends State<LoginForgotPin> {
  String sessionId;
  var _isInit = false;
  int timeRemaining = 30;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      getOtp();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Future countDownTimer() async {
    for (int x = 29; x >= 0; x--) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          timeRemaining = x;
        });
      });
    }
  }

  void getOtp() {
    countDownTimer();
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getOTP(phone).then((value) {
      setState(() {
        sessionId = value['sessionId'];
      });
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

  void verifyOtp() {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(phone, sessionId, '').then((value) {
      Navigator.of(context)
          .pushNamed(SetPin.routeName, arguments: {'phone': phone});
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

  Widget build(BuildContext context) {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final phone = routesArgs['phone'];
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
                  color: AppTheme.backgroundColor,
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
                        "Please enter OTP sent to your phone number $phone",
                        style: AppTheme.textStyle.size(15).w600,
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
                                  style:
                                      AppTheme.textStyle.size(20).w500.color25,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                      hintText: "0",
                                      border: InputBorder.none,
                                      counterText: ''),
                                  textAlign: TextAlign.center,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.color05,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    timeRemaining > 0
                        ? Text(
                            "Resend OTP in $timeRemaining s",
                            style: AppTheme.textStyle.size(13).w500.color50,
                          )
                        : GestureDetector(
                            onTap: () {
                              getOtp();
                            },
                            child: Text('Resend OTP',
                                style: AppTheme.textStyle
                                    .size(15)
                                    .w600
                                    .colored(AppTheme.primaryColor)),
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
                              verifyOtp();
                            },
                            color: AppTheme.primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 18, bottom: 18, left: 50, right: 50),
                              child: Text(
                                'Verify',
                                style: AppTheme.textStyle
                                    .size(15)
                                    .w600
                                    .colored(AppTheme.backgroundColor),
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
