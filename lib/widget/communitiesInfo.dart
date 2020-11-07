import 'package:flutter/material.dart';
import '../theme/index.dart';

class CommunitiesInfo extends StatelessWidget {
  final String info;
  CommunitiesInfo(this.info);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      color: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/communities.png',
            ),
            SizedBox(height: 22),
            Text(
              info,
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w700.size(20).lineHeight(1.5).color100,
            ),
            SizedBox(height: 16),
            Text(
              'Go to Profile > Communities to see available comunities',
              textAlign: TextAlign.center,
              style: AppTheme.textStyle.w500.size(13).lineHeight(1.5).color50,
            )
          ],
        ),
      ),
    );
  }
}
