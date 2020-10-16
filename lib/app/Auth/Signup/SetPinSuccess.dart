import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import '../../Home/HomeScreen.dart';

class SetPinSuccess extends StatefulWidget {
  static const routeName = '/signup-setpin-success';
  @override
  _SetPinSuccessState createState() => _SetPinSuccessState();
}

class _SetPinSuccessState extends State<SetPinSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(6.0)),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomeScreen()));
                        },
                        color: AppTheme.primaryColor,
                        child: Text(
                          'Go to Store',
                          style: AppTheme.textStyle
                              .colored(AppTheme.backgroundColor)
                              .size(15)
                              .w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: AppTheme.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 148, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    size: 150.0,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "PIN Set successfully",
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyle.w700.size(25),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
