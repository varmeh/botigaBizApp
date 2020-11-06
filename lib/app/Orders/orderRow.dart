import 'package:flutter/material.dart';
import '../../util/index.dart';
import '../../theme/index.dart';

const rupeeSymbol = '\u20B9';

class OrderRow extends StatelessWidget {
  final Function tapHandler;
  final String number;
  final DateTime orderDate;
  final String status;
  final int totalAmount;
  final int productsLength;
  OrderRow(this.tapHandler, this.number, this.productsLength, this.orderDate,
      this.status, this.totalAmount);

  @override
  Widget build(BuildContext context) {
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
                    Text("#$number .$productsLength ITEMS",
                        style: AppTheme.textStyle.color100.w600
                            .size(15)
                            .letterSpace(1)),
                    Container(
                      decoration: BoxDecoration(
                        color: statusColor(status),
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      padding:
                          EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
                      child: Text(
                        '${status.toUpperCase()}',
                        style: AppTheme.textStyle
                            .colored(AppTheme.backgroundColor)
                            .w600
                            .size(12)
                            .letterSpace(1),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${FormatDate.getLongformatDateWithTime(orderDate)}',
                        style: AppTheme.textStyle.color50.w500
                            .size(12)
                            .letterSpace(1)),
                    Text(
                      '$rupeeSymbol $totalAmount',
                      style: AppTheme.textStyle.color100.w600
                          .size(15)
                          .letterSpace(1),
                    ),
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
