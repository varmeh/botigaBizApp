import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/index.dart';
import '../../../widget/inviteShare.dart';
import '../../home/index.dart' show HomeScreen;

class AddCommunitesSuccess extends StatefulWidget {
  final String _aptName, _deliveryType;
  final int _day;
  final bool isSave;
  final String _deliveryMsg;

  AddCommunitesSuccess(this._aptName, this._deliveryType, this._day,
      this.isSave, this._deliveryMsg);

  @override
  _AddCommunitesSuccessState createState() => _AddCommunitesSuccessState();
}

class _AddCommunitesSuccessState extends State<AddCommunitesSuccess>
    with TickerProviderStateMixin {
  final daymap = {
    1: 'Sunday',
    2: 'Monday',
    3: 'Tuesday',
    4: 'Wednesday',
    5: 'Thrusday',
    6: 'Friday',
    7: 'Saturday'
  };
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
        ),
      ),
      child: SafeArea(
        child: ListView(
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
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller.duration = composition.duration * 1;
                      _controller.reset();
                      _controller.forward();
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: 242,
                    child: Text(
                      'You are Servicing ${widget._aptName}',
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle.w700.color100
                          .size(25)
                          .lineHeight(1.0),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  !widget.isSave
                      ? Text('${widget._deliveryMsg}',
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyle.w500.color50
                              .size(13)
                              .lineHeight(1.0))
                      : widget._deliveryType == 'duration'
                          ? Text('Delivering orders in ${widget._day} days',
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyle.w500.color50
                                  .size(13)
                                  .lineHeight(1.0))
                          : Text('Delivering orders on ${daymap[widget._day]}',
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 22, right: 22, top: 32),
              decoration: BoxDecoration(
                color: AppTheme.color05,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(32.0),
                  topRight: const Radius.circular(32.0),
                ),
              ),
              child: inviteShare(context),
            )
          ],
        ),
      ),
    );
  }
}
