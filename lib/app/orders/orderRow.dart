import 'package:flutter/material.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../models/orders/index.dart' show Order;

const rupeeSymbol = '\u20B9';

class OrderRow extends StatelessWidget {
  final Function tapHandler;
  final Order order;
  OrderRow(this.tapHandler, this.order);

  @override
  Widget build(BuildContext context) {
    String number = order.number;
    DateTime orderDate = order.orderDate;
    int totalAmount = order.totalAmount;
    int productsLength = order.products.length;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        this.tapHandler();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
              left: 24,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text('#$number .$productsLength ITEMS',
                          style: AppTheme.textStyle.color100.w600
                              .size(15)
                              .letterSpace(1)),
                    ),
                    Flexible(
                      child: Text(
                        '$rupeeSymbol $totalAmount',
                        style: AppTheme.textStyle.color100.w600
                            .size(15)
                            .letterSpace(1),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text('${orderDate.getLongformatDateWithTime()}',
                          style: AppTheme.textStyle.color50.w500
                              .size(12)
                              .letterSpace(1)),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order.statusMessage,
                            style: AppTheme.textStyle.w500.color50
                                .size(12)
                                .lineHeight(1.3),
                          ),
                          Container(
                            width: 12.0,
                            height: 12.0,
                            margin: const EdgeInsets.only(left: 4.0),
                            decoration: BoxDecoration(
                              color: order.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: AppTheme.dividerColor,
            thickness: 1.2,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
