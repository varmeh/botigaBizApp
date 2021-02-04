import 'package:flutter/material.dart';

import '../theme/index.dart';
import 'buttons/index.dart' show WhatsappIconButton, CallIconButton;

class ContactWidget extends StatelessWidget {
  final String phone;
  final String whatsapp;
  final String whatsappMessage;

  ContactWidget({
    @required this.phone,
    @required this.whatsapp,
    this.whatsappMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Queries on order or payment?',
                style:
                    AppTheme.textStyle.w500.color100.size(13).lineHeight(1.3),
              ),
              Text(
                'Contact customer directly.',
                style:
                    AppTheme.textStyle.w500.color100.size(13).lineHeight(1.3),
              ),
            ],
          ),
        ),
        SizedBox(width: 24),
        WhatsappIconButton(
          number: whatsapp,
          message: whatsappMessage,
        ),
        SizedBox(width: 16.0),
        CallIconButton(number: phone),
      ],
    );
  }
}
