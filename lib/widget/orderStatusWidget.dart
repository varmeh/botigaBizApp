import 'package:flutter/material.dart';
import '../theme/index.dart';
import '../models/orders/index.dart' show OrderByDateDetail;
import './index.dart'
    show
        StatusImageWidget,
        ImageStatus,
        PassiveButton,
        BotigaBottomModal,
        WhatsappButton;

class OrderStatusWidget extends StatelessWidget {
  final OrderByDateDetail orderDetails;

  OrderStatusWidget({
    @required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Container();
    String paymentTitle;
    ImageStatus paymentStatus;
    String paymentSubtitle;
    String refundAmount;

    // Order Payment Message
    if (orderDetails.payment.isSuccess) {
      paymentStatus = ImageStatus.success;
      paymentTitle = 'Paid via ${orderDetails.payment.paymentMode}';
    } else if (orderDetails.payment.isPending) {
      paymentStatus = ImageStatus.pending;
      paymentTitle = 'Payment pending, Please wait for 20 mins.';
    } else {
      paymentStatus = ImageStatus.failure;
      paymentTitle = 'Payment Failed';
    }

    if (orderDetails.refund.status != null) {
      if (!orderDetails.refund.isSuccess) {
        refundAmount = orderDetails.refund.amount;
        paymentSubtitle = 'You need to Refund';
        button = PassiveButton(
          width: 157,
          icon: Icon(Icons.update, size: 18.0),
          title: 'Refund',
          onPressed: () => _whatsappModal(context, orderDetails),
        );
      }
    }

    return Container(
      child: Column(
        children: [
          _tile(
              baseImage: 'assets/images/card.png',
              status: paymentStatus,
              title: paymentTitle,
              subTitle: paymentSubtitle,
              button: button,
              refundAmount: refundAmount),
        ],
      ),
    );
  }

  Widget _tile({
    String baseImage,
    ImageStatus status,
    String title,
    String subTitle,
    String refundAmount,
    Widget button,
  }) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusImageWidget(
                  baseImage: baseImage,
                  status: status,
                ),
                SizedBox(width: 24),
                Text(
                  title,
                  style: AppTheme.textStyle.color100.w500
                      .size(13)
                      .lineHeight(1.38),
                )
              ],
            ),
          ),
          refundAmount != null
              ? Divider(
                  color: AppTheme.dividerColor,
                  thickness: 4,
                )
              : SizedBox.shrink(),
          refundAmount != null
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subTitle,
                            style: AppTheme.textStyle.color50.w500
                                .size(13)
                                .lineHeight(1.38),
                          ),
                          Text(
                            "\u20B9 $refundAmount",
                            style: AppTheme.textStyle.color100.w500
                                .size(13)
                                .lineHeight(1.38),
                          )
                        ],
                      ),
                      button != null ? button : SizedBox.shrink()
                    ],
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  void _whatsappModal(BuildContext context, OrderByDateDetail orderDetails) {
    final _sizedBox = SizedBox(height: 16.0);
    final _padding = const EdgeInsets.symmetric(horizontal: 10.0);

    BotigaBottomModal(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _padding,
            child: Text(
              'How to Refund?',
              style:
                  AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              '1. Message customer for thier preferred UPI / refund method.',
              style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              '2. Transfer the money to customer as per your convenience',
              style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              '3. Once done. Come back and mark as refund. We will notify the customer :)',
              style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
            ),
          ),
          SizedBox(height: 32.0),
          Center(
            child: WhatsappButton(
              title: 'Whatsapp Customer',
              phone: orderDetails.buyer.whatsapp,
              width: 220.0,
              message:
                  'Botiga Reminder:\nHello ${orderDetails.buyer.name},\nThis is a reminder for refund of amount ${orderDetails.refund.amount} for order number ${orderDetails.order.number} cancelled on ${orderDetails.order.completionDate}',
            ),
          ),
          _sizedBox,
        ],
      ),
    ).show(context);
  }
}
