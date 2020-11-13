import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/index.dart';
import '../models/orders/index.dart' show OrderByDateDetail;
import './index.dart'
    show
        StatusImageWidget,
        ImageStatus,
        PassiveButton,
        BotigaBottomModal,
        WhatsappButton,
        Toast;

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
    bool isRefundSuccess;

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
      if (orderDetails.refund.isSuccess) {
        isRefundSuccess = true;
        refundAmount = orderDetails.refund.amount;
      } else {
        refundAmount = orderDetails.refund.amount;
        isRefundSuccess = false;
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
              refundAmount: refundAmount,
              phone: orderDetails.buyer.phone,
              isRefundSuccess: isRefundSuccess,
              context: context),
        ],
      ),
    );
  }

  Widget _tile(
      {String baseImage,
      ImageStatus status,
      String title,
      String subTitle,
      String refundAmount,
      Widget button,
      String phone,
      bool isRefundSuccess,
      BuildContext context}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    ),
                  ],
                ),
                status == ImageStatus.failure
                    ? GestureDetector(
                        onTap: () async {
                          String url =
                              'whatsapp://send?phone=91$phone&text=${Uri.encodeComponent("some dummy")}';
                          if (await canLaunch(url)) {
                            Future.delayed(Duration(milliseconds: 300),
                                () async {
                              await launch(url);
                            });
                          } else {
                            Toast(
                              message:
                                  'Please download whatsapp to use this feature',
                              icon: Image.asset(
                                'assets/images/watsapp.png',
                                width: 28.0,
                                height: 28.0,
                                color: AppTheme.backgroundColor,
                              ),
                            ).show(context);
                          }
                        },
                        child: Text(
                          'Remind Customer',
                          textAlign: TextAlign.right,
                          style: AppTheme.textStyle
                              .size(13)
                              .lineHeight(1.3)
                              .w600
                              .colored(AppTheme.primaryColor),
                        ),
                      )
                    : SizedBox.shrink(),
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
              ? isRefundSuccess
                  ? Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusImageWidget(
                            baseImage: baseImage,
                            status: ImageStatus.success,
                          ),
                          SizedBox(width: 24),
                          Text(
                            "Refund success",
                            style: AppTheme.textStyle.color100.w500
                                .size(13)
                                .lineHeight(1.38),
                          ),
                        ],
                      ),
                    )
                  : Padding(
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
              '1. Message customer for their preferred UPI / refund method',
              style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
            ),
          ),
          _sizedBox,
          Padding(
            padding: _padding,
            child: Text(
              '2. Transfer the money to customer at the earliest possible',
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
