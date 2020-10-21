import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderSummary.dart';
import 'orderFinalResult.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../theme/index.dart';
import '../../widget/index.dart';

class OrderDelivery extends StatefulWidget {
  static const routeName = '/order-delivery';
  @override
  _OrderDeliveryState createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleCancelOrder(String orderId) {
    setState(() {
      _isLoading = true;
    });
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.cancelOrder(orderId).then((value) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '${value['message']}', iconData: BotigaIcons.truck)
          .show(context);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline_sharp)
          .show(context);
    });
  }

  void handleMarkAsDeliverd(String orderId, String apartmentName) {
    setState(() {
      _isLoading = true;
    });
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.setDeliveryStatus(orderId).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(OrderFinalResult.routeName, arguments: {
        'orderId': orderId,
        'apartmentName': apartmentName,
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline_sharp)
          .show(context);
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Cancel Order",
                            style: AppTheme.textStyle.color100.w600
                                .size(14)
                                .letterSpace(.02),
                          ),
                          content: Text(
                            "Are you sure you want to cancel this order ?",
                            style: AppTheme.textStyle.color100.w500
                                .size(13)
                                .letterSpace(.02),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                "Yes",
                                style: AppTheme.textStyle.color100.w500
                                    .size(13)
                                    .letterSpace(.02),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                handleCancelOrder(orderId);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "No",
                                style: AppTheme.textStyle.color100.w500
                                    .size(13)
                                    .letterSpace(.02),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
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
                          handleMarkAsDeliverd(orderId, apartmentName);
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
          child: Stack(
            children: [
              Container(
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
              _isLoading ? Loader() : SizedBox.shrink(),
            ],
          ),
        ));
  }
}
