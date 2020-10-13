import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import "../Home/HomeScreen.dart";
import "./ForgotPin.dart";
import '../../providers/Auth/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

class EnterPin extends StatefulWidget {
  static const routeName = '/login-enter-pin';
  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final _formKey = GlobalKey<FormState>();
  bool _enableBtn = false;
  String pin = '';

  void handleLogin(BuildContext context, String phone) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signInWithPin(phone, pin).then((value) {
      authProvider.authLoginProfile = value;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style:
              AppTheme.textStyle.colored(AppTheme.surfaceColor).w500.size(15),
        ),
        icon: Icon(BotigaIcons.truck, size: 30, color: AppTheme.surfaceColor),
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
      body: Form(
        key: _formKey,
        onChanged: () =>
            setState(() => _enableBtn = _formKey.currentState.validate()),
        child: Container(
          width: double.infinity,
          color: AppTheme.primaryColor,
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
                    color: AppTheme.surfaceColor,
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
                          style: AppTheme.textStyle.size(15).w600.color100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30),
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
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          int.parse(value) == null) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => pin = '$pin$val',
                                    style: AppTheme.textStyle.w500
                                        .size(20)
                                        .color50,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        hintStyle: AppTheme.textStyle
                                            .size(20)
                                            .w500
                                            .color25,
                                        hintText: "0",
                                        border: InputBorder.none,
                                        filled: true,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0)),
                                onPressed: () {
                                  if (_enableBtn &&
                                      _formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    handleLogin(context, phone);
                                  }
                                },
                                color: _enableBtn
                                    ? AppTheme.primaryColor
                                    : AppTheme.color25,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18, bottom: 18),
                                  child: Text('Continue',
                                      style: AppTheme.textStyle
                                          .size(15)
                                          .w600
                                          .colored(AppTheme.surfaceColor)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: FlatButton(
                          child: Text('Forgot PIN?',
                              style: AppTheme.textStyle
                                  .size(15)
                                  .w600
                                  .colored(AppTheme.primaryColor)),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                LoginForgotPin.routeName,
                                arguments: {'phone': phone});
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
      ),
    );
  }
}
