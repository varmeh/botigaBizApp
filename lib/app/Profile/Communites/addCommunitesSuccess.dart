import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/index.dart';
import '../../../util/constants.dart';
import '../../Home/HomeScreen.dart';

class AddCommunitesSuccess extends StatelessWidget {
  final String _businessName, _deliveryType;
  final int _day;
  final daymap = Constants.daysMap;
  AddCommunitesSuccess(this._businessName, this._deliveryType, this._day);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        //could change this to Color(0xFF737373),
        //so you don't have to change MaterialApp canvasColor
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(HomeScreen.routeName));
                    },
                  )
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset(
                    'assets/lotties/checkSuccess.json',
                    width: 160.0,
                    height: 160.0,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: 242,
                    child: Text(
                      "You are Servicing $_businessName",
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle.w700.color100
                          .size(25)
                          .lineHeight(1.0),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _deliveryType == "duration"
                      ? Text("Delivering orders in $_day days",
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyle.w500.color50
                              .size(13)
                              .lineHeight(1.0))
                      : Text("Delivering orders on ${daymap[_day]}",
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyle.w500.color50
                              .size(13)
                              .lineHeight(1.0))
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 22, right: 22, top: 32),
                decoration: BoxDecoration(
                  color: AppTheme.color05,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(32.0),
                    topRight: const Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                        ),
                      ),
                      child: Center(
                        child: Text("SHARE WITH YOUR CUSTOMERS",
                            style: AppTheme.textStyle.w700
                                .colored(AppTheme.backgroundColor)
                                .size(12)
                                .lineHeight(1.0)
                                .letterSpace(1)),
                      ),
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/coupan.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 20, left: 20, bottom: 20),
                        child: Text(
                            "Hi, Now you can see our entire catalog of healthynuts online. Place orders anytime and track conveniently. Download Botiga app now. https://botiga.app/xcGha",
                            style: AppTheme.textStyle.w500.color100.size(13)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            onPressed: () {},
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text('Copy message',
                                  style: AppTheme.textStyle.w600
                                      .colored(AppTheme.backgroundColor)
                                      .size(15)),
                            ),
                          ),
                          FlatButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                            icon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 13, top: 13, bottom: 13),
                              child: Image.asset('assets/images/watsapp.png'),
                            ),
                            onPressed: () {},
                            color: Colors.black,
                            label: Padding(
                              padding: const EdgeInsets.only(
                                right: 13,
                                top: 13,
                                bottom: 13,
                              ),
                              child: Text(
                                'Share',
                                style: AppTheme.textStyle.w600
                                    .colored(AppTheme.backgroundColor)
                                    .size(15),
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
        ));
  }
}
