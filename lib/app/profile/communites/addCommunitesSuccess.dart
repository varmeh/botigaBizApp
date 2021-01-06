import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/index.dart';
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
    _controller.addStatusListener(loadTabbarAfterAnimationCompletion);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadTabbarAfterAnimationCompletion);
    _controller.dispose();
    super.dispose();
  }

  void loadTabbarAfterAnimationCompletion(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => HomeScreen(index: 3),
            transitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16.0),
          topRight: const Radius.circular(16.0),
        ),
      ),
      child: ListView(
        children: <Widget>[
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
                  width: double.infinity,
                  child: Text(
                    'You are Servicing ${widget._aptName}',
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyle.w700.color100
                        .size(25)
                        .lineHeight(1.3),
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
        ],
      ),
    );
  }
}
