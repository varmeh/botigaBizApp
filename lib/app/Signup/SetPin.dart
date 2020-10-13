import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import './SetPinSuccess.dart';
import '../../providers/Auth/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

class SetPin extends StatefulWidget {
  static const routeName = '/signup-setpin';
  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  String pin = '1234';

  void _handleUpdatePin() {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.updatePin(phone, pin).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SetPinSuccess()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Align(
            child: Text(
              "Set PIN",
              style: TextStyle(
                  color: AppTheme.color100,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
            ),
            alignment: Alignment.centerLeft,
          ),
          leading: IconButton(
            icon: Icon(
              BotigaIcons.arrowBack,
              color: AppTheme.color100,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
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
                        Text(
                            "Last step! You are almost done. Going forward this 4-digit pin will be used to login.",
                            style: AppTheme.textStyle.color50.w500.size(13)),
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
                                      style: AppTheme.textStyle.color25.w500
                                          .size(20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0)),
                              onPressed: () {
                                _handleUpdatePin();
                              },
                              color: Color(0xff179F57),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 14, bottom: 14, left: 18, right: 18),
                                child: Text(
                                  'Set PIN',
                                  style: AppTheme.textStyle.color50.w600
                                      .size(15)
                                      .colored(AppTheme.surfaceColor),
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
