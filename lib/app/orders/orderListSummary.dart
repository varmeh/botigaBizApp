import 'package:flutter/material.dart';

import '../../models/orders/index.dart';
import '../../theme/index.dart';
import 'orderListItem.dart';

class OrderListSummary extends StatelessWidget {
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
            '${orderDetail.order.products.length} Item${orderDetail.order.products.length > 1 ? 's' : ''}',
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
        SizedBox(height: 24.0),
        _discountData(),
        _total(),
      ],
    );
  }

  Widget _discountData() {
    final _sizedBox20 = SizedBox(height: 20);
    final _style =
        AppTheme.textStyle.w500.size(13).lineHeight(1.2).letterSpace(0.2);

    return orderDetail.order.hasCoupon
        ? Column(
            children: [
              Divider(color: AppTheme.dividerColor, thickness: 1),
              _sizedBox20,
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Items total',
                            style: _style.color100,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '₹${orderDetail.order.totalAmount + orderDetail.order.discountAmount}',
                            style: _style.color100,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    _sizedBox20,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Coupon Applied (${orderDetail.order.couponCode})',
                            style: _style.color100,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '-₹${orderDetail.order.discountAmount}',
                            style: _style.colored(AppTheme.primaryColor),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _sizedBox20,
            ],
          )
        : Container();
  }

  Widget _total() {
    final style = AppTheme.textStyle.w600.color100.size(13).lineHeight(1.6);

    return Padding(
        padding: const EdgeInsets.only(bottom: 52.0, left: 20, right: 20),
        child: Column(
          children: [
            Divider(
              thickness: 1,
              color: AppTheme.dividerColor,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: style,
                ),
                RichText(
                  text: TextSpan(
                    text: '₹',
                    style: AppTheme.textStyle.w400.color100
                        .size(13.0)
                        .lineHeight(1.6),
                    children: [
                      TextSpan(
                        text: orderDetail.order.totalAmount.toString(),
                        style: style,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
