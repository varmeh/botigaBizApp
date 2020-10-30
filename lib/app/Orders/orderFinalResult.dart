import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderSummary.dart';
import '../../providers/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../util/index.dart';
import '../../theme/index.dart';

class OrderFinalResult extends StatelessWidget {
  static const routeName = '/order-final-result';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    final orderId = routeArgs['orderId'];
    final apartmentName = routeArgs['apartmentName'];
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final OrderByDateDetail orderDetail =
        ordersProvider.getOrderDetails(orderId);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                BotigaIcons.arrowBack,
                color: AppTheme.color100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OrderFinalSummary(orderDetail, apartmentName)
                    ],
                  ),
                ),
                OrderListSummary(orderDetail),
              ],
            ),
          ),
        ));
  }
}

class OrderFinalSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  final String apartmentName;
  OrderFinalSummary(this.orderDetail, this.apartmentName);

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
                  '${Constants.deliverdOn} ${FormatDate.getDate(orderDetail.order.expectedDeliveryDate)}',
                  style: AppTheme.textStyle.color100.w500.size(13),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
