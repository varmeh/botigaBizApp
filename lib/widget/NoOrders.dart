import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/index.dart';

class NoOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/fish.json',
              width: 160.0,
              height: 160.0,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 8.0),
            Text(
              'No orders yet!',
              style:
                  AppTheme.textStyle.w700.color100.size(16.0).lineHeight(2.1),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Spread the message to your customers that you are accepting orders',
              textAlign: TextAlign.center,
              style:
                  AppTheme.textStyle.w500.color50.size(13.0).letterSpace(0.2),
            ),
            SizedBox(height: 35.0),
            FlatButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
              ),
              onPressed: () {},
              color: AppTheme.dividerColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 30, right: 30),
                child: Text(
                  'Invite Customers',
                  style: AppTheme.textStyle.w600
                      .size(15.0)
                      .lineHeight(1.5)
                      .colored(AppTheme.color100),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
