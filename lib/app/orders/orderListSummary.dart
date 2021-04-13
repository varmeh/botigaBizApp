import 'package:flutter/material.dart';

import '../../widget/index.dart' show DashedDivider;
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
        _discountAndDeliveryData(),
        _total(),
        _settledAmount(),
      ],
    );
  }

  Widget _discountAndDeliveryData() {
    return orderDetail.order.hasCoupon || orderDetail.order.hasDeliveryFee
        ? Column(
            children: [
              Divider(color: AppTheme.dividerColor, thickness: 1),
              SizedBox(height: 4), // 20 pixels padding by _billTile
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    _billTile(
                      title: 'Items total',
                      amount:
                          '₹${orderDetail.order.totalAmount + orderDetail.order.discountAmount - orderDetail.order.deliveryFee}',
                    ),
                    _billTile(
                      title: 'Delivery Fee',
                      amount: '₹${orderDetail.order.deliveryFee.toDouble()}',
                    ),
                    orderDetail.order.hasCoupon
                        ? _billTile(
                            title:
                                'Coupon Applied (${orderDetail.order.couponCode})',
                            amount: '-₹${orderDetail.order.discountAmount}',
                            color: AppTheme.primaryColor)
                        : SizedBox.shrink()
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          )
        : Container();
  }

  Widget _billTile({String title, String amount, Color color}) {
    final _style = AppTheme.textStyle.w500.color100
        .size(13)
        .lineHeight(1.2)
        .letterSpace(0.2);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: _style.color100,
          ),
          SizedBox(width: 24),
          Text(
            amount,
            style: color != null ? _style.colored(color) : _style,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _total() {
    final style = AppTheme.textStyle.w600.color100.size(13).lineHeight(1.6);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Divider(
            thickness: 1,
            color: AppTheme.dividerColor,
          ),
          SizedBox(height: 16.0),
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
      ),
    );
  }

  Widget _settledAmount() {
    final style = AppTheme.textStyle.w600
        .size(15)
        .lineHeight(1.3)
        .colored(AppTheme.primaryColor);

    final isValidAmount = orderDetail.payment.transferredAmount != null &&
        orderDetail.payment.transferredAmount != 0;

    return isValidAmount
        ? Padding(
            padding: const EdgeInsets.only(
                top: 24.0, bottom: 32.0, left: 20, right: 20),
            child: Column(
              children: [
                DashedDivider(),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Settlement',
                      style: AppTheme.textStyle.w500.color100
                          .size(13)
                          .lineHeight(1.5),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '₹',
                        style: style,
                        children: [
                          TextSpan(
                            text: orderDetail.payment.transferredAmount
                                .toString(),
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                DashedDivider(),
              ],
            ),
          )
        : Container();
  }
}
