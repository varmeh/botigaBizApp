import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../providers/index.dart' show ProfileProvider;
import '../theme/index.dart';
import 'toast.dart';

Widget inviteShare(BuildContext context) {
  const borderRadius = BorderRadius.only(
    topLeft: const Radius.circular(16.0),
    topRight: const Radius.circular(16.0),
  );

  final sellerBrand = Provider.of<ProfileProvider>(context, listen: false)
      .profileInfo
      .brand
      .name;
  final text =
      'Dear Customer,\n$sellerBrand is now selling its products on Botiga app.\nSee our entire catalog & place orders till Midnight 12 AM and track conveniently.\nDownload Botiga app now - https://bit.ly/botigaApp';

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            'SHARE WITH YOUR CUSTOMERS',
            style: AppTheme.textStyle.w700
                .size(12)
                .lineHeight(1.4)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/coupan.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          child: Text(
            text,
            style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
          ),
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
              onPressed: () {
                FlutterClipboard.copy(text).then((_) {
                  Toast(
                    message: 'Copied to Clipboard',
                    icon: Icon(
                      Icons.content_copy_outlined,
                      size: 24,
                      color: AppTheme.backgroundColor,
                    ),
                  ).show(context);
                }).catchError((_, __) => null);
              },
              color: AppTheme.color100,
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
                padding: const EdgeInsets.only(left: 13, top: 13, bottom: 13),
                child: Image.asset('assets/images/whatsapp.png'),
              ),
              onPressed: () {
                Share.share(text)
                    .then((_) => Navigator.pop(context))
                    .catchError((_, __) => null); //catch error do nothing
              },
              color: AppTheme.color100,
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
  );
}
