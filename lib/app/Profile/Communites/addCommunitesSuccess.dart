import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../theme/index.dart';
import '../../../util/constants.dart';
import '../../Home/HomeScreen.dart';
import '../../../widget/inviteShare.dart';

class AddCommunitesSuccess extends StatefulWidget {
  final String _businessName, _deliveryType;
  final int _day;
  final bool isSave;
  final String _deliveryMsg;

  AddCommunitesSuccess(this._businessName, this._deliveryType, this._day,
      this.isSave, this._deliveryMsg);

  @override
  _AddCommunitesSuccessState createState() => _AddCommunitesSuccessState();
}

class _AddCommunitesSuccessState extends State<AddCommunitesSuccess>
    with TickerProviderStateMixin {
  final daymap = Constants.daysMap;
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
      Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
    }
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
                      _controller.duration = composition.duration * 3;
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
                      "You are Servicing ${widget._businessName}",
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
                      ? Text("${widget._deliveryMsg}",
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyle.w500.color50
                              .size(13)
                              .lineHeight(1.0))
                      : widget._deliveryType == "duration"
                          ? Text("Delivering orders in ${widget._day} days",
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyle.w500.color50
                                  .size(13)
                                  .lineHeight(1.0))
                          : Text("Delivering orders on ${daymap[widget._day]}",
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
                  child: inviteShare(context)),
            )
          ],
        ));
  }
}
