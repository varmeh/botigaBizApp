import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderSummary.dart';
import 'orderFinalResult.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../theme/index.dart';
import 'package:flushbar/flushbar.dart';

class OrderDelivery extends StatefulWidget {
  static const routeName = '/order-delivery';
  @override
  _OrderDeliveryState createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleCancelOrder(BuildContext context, String orderId) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.cancelOrder(orderId).then((value) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Color(0xff2591B2),
        messageText: Text(
          '${value['message']}',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

  void handleMarkAsDeliverd(
      BuildContext context, String orderId, String apartmentName) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.setDeliveryStatus(orderId).then((value) {
      Navigator.of(context).pushNamed(OrderFinalResult.routeName, arguments: {
        'orderId': orderId,
        'apartmentName': apartmentName,
      });
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

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
            actions: [
              FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  handleCancelOrder(context, orderId);
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
        backgroundColor: AppTheme.backgroundColor,
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
                          handleMarkAsDeliverd(context, orderId, apartmentName);
                        },
                        textColor: Colors.red,
                        color: Color(0xff179F57),
                        child: Text(
                          'Mark as delivered',
                          style: AppTheme.textStyle
                              .colored(AppTheme.backgroundColor)
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
                    children: <Widget>[
                      OrderSummary(orderDetail, apartmentName)
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
