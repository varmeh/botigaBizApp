import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../theme/index.dart';
import '../../widget/index.dart' show inviteShare, BotigaBottomModal;

class EmptyDelivery extends StatefulWidget {
  @override
  _EmptyDeliveryState createState() => _EmptyDeliveryState();
}

class _EmptyDeliveryState extends State<EmptyDelivery>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/rabbit.json',
              width: 330,
              height: 300,
              fit: BoxFit.fill,
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration * 0.75;
                _controller.reset();
                _controller.forward();
              },
            ),
            Text(
              'No deliveries today',
              style: AppTheme.textStyle.w700.color100.size(16).lineHeight(1.4),
            ),
            SizedBox(height: 8.0),
            Text(
              'Spread the message to your customers that you are accepting orders',
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w500.color50
                  .size(12)
                  .lineHeight(1.4)
                  .letterSpace(0.2),
            ),
            sizedBox,
            TextButton(
              onPressed: () {
                BotigaBottomModal(
                        child: inviteShare(context), color: Color(0xffF3F3F3))
                    .show(context);
              },
              child: Text(
                'Invite Customers',
                style:
                    AppTheme.textStyle.w500.color100.size(15).lineHeight(1.5),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: AppTheme.color05,
                minimumSize: Size(188.0, 44.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
