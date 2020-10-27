import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/index.dart';
import 'inviteShare.dart';
import 'botigaBottomModal.dart';

class EmptyDelivery extends StatelessWidget {
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
            ),
            Text(
              'No delivery yet!',
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
            FlatButton(
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
              color: AppTheme.color05,
              height: 44.0,
              minWidth: 188.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
