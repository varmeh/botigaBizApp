import 'package:flutter/material.dart';

import '../../models/orders/index.dart';
import '../../theme/index.dart';
import '../../util/index.dart';
import '../orders/index.dart' show OrderDetails;

const rupeeSymbol = '\u20B9';

class DeliveryRow extends StatelessWidget {
  final OrderByDateDetail delivery;
  final String apartmentName;
  final String apartmentId;
  final Function handleOutForDelivery;
  final DateTime selectedDateForRequest;
  final Function handleMarkAsDeliverd;

  DeliveryRow(
      this.delivery,
      this.apartmentName,
      this.apartmentId,
      this.handleOutForDelivery,
      this.selectedDateForRequest,
      this.handleMarkAsDeliverd);

  _handleOutForDelivery(String orderId) {
    this.handleOutForDelivery(orderId);
  }

  _handleMarkAsDeliverd(String orderId) {
    this.handleMarkAsDeliverd(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final date = selectedDateForRequest == null
            ? DateTime.now()
            : selectedDateForRequest;
        Navigator.of(context).pushNamed(
          OrderDetails.routeName,
          arguments: {
            'flowType': 'delivery',
            'id': delivery.id,
            'apartmentName': apartmentName,
            'apartmentId': apartmentId,
            'selectedDateForRequest': date.getRequestFormatDate()
          },
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.color100.withOpacity(0.12),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${delivery.buyer.house}, ${delivery.buyer.name}',
                          style: AppTheme.textStyle.color100.w600
                              .size(15)
                              .letterSpace(0.5),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                '#${delivery.order.number} • ${delivery.order.products.length} ITEMS',
                            style: AppTheme.textStyle.color50.w500.size(13),
                            children: <TextSpan>[
                              TextSpan(
                                  text: [1, 2, 3, 4, 5].map((e) => ' ').join()),
                              TextSpan(
                                text:
                                    '$rupeeSymbol${delivery.order.totalAmount}',
                                style: AppTheme.textStyle.color100.w500
                                    .size(16)
                                    .lineHeight(1.33),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.only(right: 4.0),
                              decoration: BoxDecoration(
                                color: delivery.order.statusColor,
                                shape: BoxShape.circle,
                              ),
                              child: delivery.order.isDelivered == true
                                  ? Icon(
                                      Icons.check,
                                      size: 12,
                                      color: AppTheme.backgroundColor,
                                    )
                                  : SizedBox.shrink(),
                            ),
                            Text(
                              delivery.order.statusMessage,
                              style: AppTheme.textStyle.w500.color50
                                  .size(16)
                                  .lineHeight(1.3),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  (delivery.order.isOpen || delivery.order.isDelayed)
                      ? Container(
                          padding: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 1.2, color: AppTheme.dividerColor),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: InkWell(
                            onTap: () {
                              this._handleOutForDelivery(delivery.id);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Icon(
                                      BotigaIcons.truck,
                                      size: 30,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.dividerColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: 70,
                                  height: 32,
                                  child: Text(
                                    'Out for delivery',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.textStyle.color100.w500
                                        .size(12)
                                        .letterSpace(0.2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  delivery.order.isOutForDelivery
                      ? Container(
                          padding: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 1.2, color: AppTheme.dividerColor),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: InkWell(
                            onTap: () {
                              this._handleMarkAsDeliverd(delivery.id);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 25,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.dividerColor),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width: 70,
                                  height: 32,
                                  child: Text(
                                    'Delivered',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.textStyle.color100.w500
                                        .size(12)
                                        .letterSpace(0.2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
