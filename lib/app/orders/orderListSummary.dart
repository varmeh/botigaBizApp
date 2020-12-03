import 'package:flutter/material.dart';

import '../../models/orders/index.dart';
import '../../theme/index.dart';
import 'orderListItem.dart';

class OrderListSummary extends StatelessWidget {
  final String rupeeSymbol = '\u20B9';
  final OrderByDateDetail orderDetail;
  OrderListSummary(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Text(
            '${orderDetail.order.products.length} Items',
            style: AppTheme.textStyle.color100.w500.size(12).letterSpace(.02),
          ),
        ),
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
        ),
        ...orderDetail.order.products.map((el) {
          return OrderListItem(el.name, el.price, el.quantity, el.unitInfo);
        }),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Divider(
            color: AppTheme.dividerColor,
            thickness: 1.2,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Total',
                  style: AppTheme.textStyle.color100.w600.size(13),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '$rupeeSymbol${orderDetail.order.totalAmount}',
                  style: AppTheme.textStyle.color100.w600.size(13),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
