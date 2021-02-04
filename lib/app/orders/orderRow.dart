import 'package:flutter/material.dart';

import '../../models/orders/index.dart' show OrderByDateDetail;
import '../../theme/index.dart';
import '../../util/index.dart';

class OrderRow extends StatelessWidget {
  final Function tapHandler;
  final OrderByDateDetail order;
  OrderRow(this.tapHandler, this.order);

  @override
  Widget build(BuildContext context) {
    String number = order.order.number;
    DateTime orderDate = order.order.orderDate;
    double totalAmount = order.order.totalAmount;
    int productsLength = order.order.products.length;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => this.tapHandler(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
              left: 24,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                          '#$number • $productsLength ITEM${productsLength > 1 ? 'S' : ''}',
                          style: AppTheme.textStyle.color100.w600
                              .size(15)
                              .letterSpace(1)),
                    ),
                    Flexible(
                      child: Text(
                        '₹$totalAmount',
                        style: AppTheme.textStyle.color100.w600
                            .size(15)
                            .letterSpace(1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${orderDate.getLongformatDateWithTime()}',
                          style: AppTheme.textStyle.color50.w500
                              .size(12)
                              .letterSpace(1),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.only(right: 4.0),
                              decoration: BoxDecoration(
                                color: order.order.statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              order.order.statusMessage,
                              style: AppTheme.textStyle.w500.color50
                                  .size(12)
                                  .lineHeight(1.3),
                            ),
                          ],
                        ),
                      ],
                    ),
                    order.payment.isSuccess
                        ? Image.asset('assets/images/stampPaid.png')
                        : Container(),
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
