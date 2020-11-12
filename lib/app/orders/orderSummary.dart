import 'package:flutter/material.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widget/index.dart' show ContactWidget;
import '../../models/orders/index.dart';

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
    } else if (orderDetail.order.isDelivered) {
      deliveryMsg =
          'Delivered on ${orderDetail.order.expectedDeliveryDate.getDate()}';
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
        (orderDetail.order.isOpen ||
                orderDetail.order.isDelayed ||
                orderDetail.order.isOutForDelivery)
            ? Padding(
                padding: const EdgeInsets.only(top: 27, bottom: 24),
                child: ContactWidget(
                    whatsapp: orderDetail.buyer.whatsapp,
                    phone: orderDetail.buyer.phone),
              )
            : SizedBox(
                height: 27,
              ),
      ],
    );
  }
}

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
