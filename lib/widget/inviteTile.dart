import 'package:flutter/material.dart';
import '../theme/index.dart';
import './botigaBottomModal.dart';
import './inviteShare.dart';

class InviteTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        gradient: LinearGradient(
          colors: [const Color(0xffFFD645), const Color(0xffFFE380)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 23, top: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite Customers',
                    style: AppTheme.textStyle.w700
                        .size(20.0)
                        .lineHeight(1.3)
                        .color100,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Share your store with customers for more orders.',
                    style: AppTheme.textStyle.w500
                        .size(13.0)
                        .lineHeight(1.5)
                        .color100,
                  ),
                  SizedBox(height: 10.0),
                  FlatButton(
                    onPressed: () {
                      BotigaBottomModal(
                              child: inviteShare(context),
                              color: Color(0xffF3F3F3))
                          .show(context);
                    },
                    child: Text(
                      'Invite Now',
                      style: AppTheme.textStyle.w600
                          .size(15)
                          .lineHeight(1.5)
                          .colored(AppTheme.backgroundColor),
                    ),
                    color: AppTheme.color100,
                    height: 42.0,
                    minWidth: 136.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset('assets/images/invite.png')
        ],
      ),
    );
  }
}
