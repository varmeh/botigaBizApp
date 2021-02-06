import 'dart:math';
import 'package:botiga_biz/widget/index.dart';
import 'package:flutter/material.dart';

import '../../models/orders/index.dart';
import '../../theme/index.dart';
import '../../util/index.dart';
import '../orders/index.dart' show OrderDetails;

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
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${delivery.buyer.house}, ${delivery.buyer.name}',
                                style: AppTheme.textStyle.color100.w600
                                    .size(15)
                                    .letterSpace(0.5),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text:
                                      '#${delivery.order.number} • ${delivery.order.products.length} ITEM${delivery.order.products.length > 1 ? 'S' : ''}',
                                  style: AppTheme.textStyle.color50.w500
                                      .size(13)
                                      .lineHeight(1.2),
                                  children: [
                                    TextSpan(text: '  '),
                                    TextSpan(
                                      text: '₹${delivery.order.totalAmount}',
                                      style: AppTheme.textStyle.color100.w500
                                          .size(13)
                                          .lineHeight(1.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        delivery.payment.isSuccess
                            ? Image.asset('assets/images/stampPaid.png')
                            : Container(),
                      ],
                    ),
                  ),
                  delivery.order.isCompleted
                      ? _completedDeliveryStatus()
                      : _updateDeliveryStatus(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _completedDeliveryStatus() {
    final image = delivery.order.isDelivered
        ? 'assets/images/success.png'
        : 'assets/images/failure.png';

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(image, width: 16, height: 16),
          SizedBox(width: 4),
          Text(
            delivery.order.statusMessage,
            style: AppTheme.textStyle.w500.color50.size(12).lineHeight(1.3),
          ),
        ],
      ),
    );
  }

  Widget _updateDeliveryStatus(BuildContext context) {
    const _sizedBox = SizedBox(height: 16);

    return Column(
      children: [
        _sizedBox,
        DottedDivider(
          start: Point(0.0, 0.0),
          width: MediaQuery.of(context).size.width - 40,
          color: Color(0xff121715).withOpacity(0.25),
        ),
        _sizedBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                    ),
                    Expanded(
                      child: Text(
                        delivery.order.statusMessage,
                        overflow: TextOverflow.clip,
                        style: AppTheme.textStyle.w500.color50
                            .size(12)
                            .lineHeight(1.3),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              (delivery.order.isOpen || delivery.order.isDelayed)
                  ? _outForDeliveryButton()
                  : _markDeliveredButton()
            ],
          ),
        ),
      ],
    );
  }

  Widget _outForDeliveryButton() {
    return InkWell(
      onTap: () {
        this._handleOutForDelivery(delivery.id);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 180),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.dividerColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Text(
            'Out for delivery'.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTheme.textStyle.color100.w600.size(12).letterSpace(0.2),
          ),
        ),
      ),
    );
  }

  Widget _markDeliveredButton() {
    return InkWell(
      onTap: () {
        this._handleMarkAsDeliverd(delivery.id);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 180),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.dividerColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                'Mark Delivered'.toUpperCase(),
                textAlign: TextAlign.center,
                style:
                    AppTheme.textStyle.color100.w600.size(12).letterSpace(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
