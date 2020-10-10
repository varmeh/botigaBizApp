import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import 'orderSummary.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import 'package:provider/provider.dart';
import '../../theme/index.dart';

class OrderDelivery extends StatefulWidget {
  static const routeName = '/order-delivery';
  @override
  _OrderDeliveryState createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final OrderByDateDetail orderDetail =
        ordersProvider.getOrderDetails(routeArgs['orderId']);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppTheme.surfaceColor,
            elevation: 0,
            centerTitle: false,
            title: Align(
              child: Text(
                "",
                style: TextStyle(
                    color: AppTheme.color100,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              alignment: Alignment(-1.1, 0),
            ),
            actions: [
              FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  ordersProvider.cancelOrder(routeArgs['orderId']);
                },
                child: Text('Cancel Order',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).colorScheme.error)),
              )
            ],
            leading: IconButton(
              icon: Icon(
                BotigaIcons.arrowBack,
                color: AppTheme.color100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: AppTheme.surfaceColor,
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          ordersProvider.setDeliveryStatus("delivered");
                        },
                        textColor: Colors.red,
                        color: Color(0xff179F57),
                        child: Text(
                          'Mark as delivered',
                          style: AppTheme.textStyle
                              .colored(AppTheme.surfaceColor)
                              .w500
                              .size(15),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[OrderSummary(orderDetail)],
                  ),
                ),
                OrderListSummary(orderDetail),
              ],
            ),
          ),
        ));
  }
}
