import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'EnterPin.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNumber = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          color: AppTheme.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 70, bottom: 60, left: 20, right: 20),
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: AppTheme.textStyle.w600
                      .colored(AppTheme.backgroundColor)
                      .size(28),
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
                        padding: const EdgeInsets.only(top: 40, bottom: 30),
                        child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(patttern);
                              if (value.isEmpty) {
                                return 'Phone number cannot be empty';
                              }
                              if (!regExp.hasMatch(value)) {
                                return 'Please enter valid phone number';
                              }
                              return null;
                            },
                            onSaved: (val) => phoneNumber = val,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: AppTheme.color50,
                                ),
                                fillColor: AppTheme.backgroundColor,
                                filled: true,
                                hintText: "Phone number",
                                hintStyle:
                                    AppTheme.textStyle.size(15).w500.color50,
                                border: OutlineInputBorder())),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  Navigator.of(context).pushNamed(
                                      EnterPin.routeName,
                                      arguments: {'phone': phoneNumber});
                                }
                              },
                              color: AppTheme.primaryColor,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, bottom: 18),
                                child: Text(
                                  'Continue',
                                  style: AppTheme.textStyle.w600
                                      .size(15)
                                      .colored(AppTheme.backgroundColor),
                                ),
                              ),
                            ),
                          )
                        ],
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
