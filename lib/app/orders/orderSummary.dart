import 'package:flutter/material.dart';

import '../../models/orders/index.dart';
import '../../theme/index.dart';
import '../../util/index.dart';

class OrderSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  final String apartmentName;
  OrderSummary(this.orderDetail, this.apartmentName);

  @override
  Widget build(BuildContext context) {
    String deliveryMsg = '';
    if (orderDetail.order.isOpen || orderDetail.order.isDelayed) {
      deliveryMsg =
          'Expected delivery ${orderDetail.order.expectedDeliveryDate.getDate()}';
    } else if (orderDetail.order.isOutForDelivery) {
      deliveryMsg = 'Order Shipped';
    } else if (orderDetail.order.isDelivered) {
      deliveryMsg =
          'Delivered on ${orderDetail.order.expectedDeliveryDate.getDate()}';
    } else if (orderDetail.order.isCancelled) {
      deliveryMsg = 'Order ${orderDetail.order.statusMessage}';
    } else {
      deliveryMsg = orderDetail.order.statusMessage;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${orderDetail.buyer.name}',
          style: AppTheme.textStyle.color100.w600.size(22),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Row(
            children: <Widget>[
              Icon(BotigaIcons.tag),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text('Order number: #${orderDetail.order.number}',
                    style: AppTheme.textStyle.color100.w500.size(13)),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/clock.png'),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${orderDetail.order.orderDate.getLongformatDateWithTime()}',
                  style: AppTheme.textStyle.color100.w500.size(13),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Row(
            children: <Widget>[
              Icon(BotigaIcons.pin),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${orderDetail.buyer.house} $apartmentName',
                  style: AppTheme.textStyle.color100.w500.size(13),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 19.0),
          child: Row(
            children: <Widget>[
              Icon(
                BotigaIcons.truck,
                size: 26,
                color: Colors.black,
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                  child: Text(
                '$deliveryMsg',
                style: AppTheme.textStyle.color100.w500.size(13),
              ))
            ],
          ),
        ),
      ],
    );
  }
}
