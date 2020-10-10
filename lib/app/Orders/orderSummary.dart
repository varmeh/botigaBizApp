import 'package:flutter/material.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../models/Orders/OrderByDateDetail.dart';

class OrderSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  OrderSummary(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${orderDetail.buyer.name}",
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
                  '${FormatDate.getLongformatDateWithTime(orderDetail.order.orderDate)}',
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
                  '${orderDetail.buyer.house}',
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
                  'Expected delivery ${FormatDate.getDate(orderDetail.order.expectedDeliveryDate)}',
                  style: AppTheme.textStyle.color100.w500.size(13),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 27, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 44,
                  // width: 165,
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    icon: Icon(
                      BotigaIcons.call,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {},
                    color: Color(0xff121715).withOpacity(0.05),
                    highlightColor: AppTheme.primaryColor,
                    label: Text(
                      'Call',
                      style: AppTheme.textStyle.color100.w500.size(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              Expanded(
                child: SizedBox(
                  height: 44,
                  // width: 165,
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    icon: Image.asset('assets/images/watsapp.png'),
                    onPressed: () {},
                    color: Color(0xff121715).withOpacity(0.05),
                    highlightColor: AppTheme.primaryColor,
                    label: Text(
                      'Whatsapp',
                      style: AppTheme.textStyle.color100.w500.size(15),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class OrderListSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  OrderListSummary(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
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
                  '${Constants.rupeeSymbol}${orderDetail.order.totalAmount}',
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
              '${Constants.rupeeSymbol}${quantity * price}',
              style: AppTheme.textStyle.color100.w500.size(13),
            ),
          )
        ],
      ),
    );
  }
}
