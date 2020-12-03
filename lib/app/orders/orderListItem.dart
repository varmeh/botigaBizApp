import 'package:flutter/material.dart';

import '../../theme/index.dart';

class OrderListItem extends StatelessWidget {
  final String rupeeSymbol = '\u20B9';
  final String name;
  final int price;
  final int quantity;
  final String unitInfo;
  OrderListItem(this.name, this.price, this.quantity, this.unitInfo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, bottom: 0.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '$quantity X $name',
              style: AppTheme.textStyle.color100.w500.size(13),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              '$rupeeSymbol${quantity * price}',
              style: AppTheme.textStyle.color100.w500.size(13),
            ),
          )
        ],
      ),
    );
  }
}
