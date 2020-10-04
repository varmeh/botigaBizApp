import 'package:flutter/material.dart';
import '../../util/constants.dart';

class OrderRow extends StatelessWidget {
  final Function tapHandler;
  final String number;
  final String orderDate;
  final String status;
  final int totalAmount;
  final int productsLength;
  OrderRow(this.tapHandler, this.number, this.productsLength, this.orderDate,
      this.status, this.totalAmount);

  @override
  Widget build(BuildContext context) {
    final contextTextTheme = Theme.of(context).textTheme;
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
                        style: contextTextTheme.subtitle1.copyWith(
                          wordSpacing: 1,
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE9A136),
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      padding:
                          EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
                      child: Text(
                        '${status.toUpperCase()}',
                        style: contextTextTheme.overline.copyWith(
                            letterSpacing: 1,
                            color: Theme.of(context).colorScheme.surface),
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
                    Text('$orderDate',
                        style: contextTextTheme.overline
                            .copyWith(color: Colors.grey[500])),
                    Text(
                      '${Constants.rupeeSymbol} $totalAmount',
                      style: contextTextTheme.subtitle1.copyWith(
                        wordSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).backgroundColor,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
