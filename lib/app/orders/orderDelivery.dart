import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderSummary.dart';
import '../../providers/index.dart' show OrdersProvider;
import '../../theme/index.dart';
import '../../widget/index.dart' show BotigaAppBar, LoaderOverlay, Toast;
import '../../util/index.dart';
import '../../models/orders/index.dart';

class OrderDelivery extends StatefulWidget {
  static const routeName = 'order-delivery';
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

  void handleCancelOrder(
      String orderId, String apartmentId, String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.cancelOrder(orderId);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
      Toast(
        message: 'Order canceled',
        icon: Icon(
          BotigaIcons.truck,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleMarkAsDeliverd(String orderId, String apartmentName,
      String apartmentId, String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.setDeliveryStatus(orderId);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
      Toast(
        message: 'Order marked as deliverd',
        icon: Icon(
          BotigaIcons.truck,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    final orderId = routeArgs['orderId'];
    final apartmentName = routeArgs['apartmentName'];
    final apartmentId = routeArgs['apartmentId'];
    final selectedDateForRequest = routeArgs['selectedDateForRequest'];
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: true);
    final OrderByDateDetail orderDetail =
        ordersProvider.getOrderDetails(orderId);

    return Scaffold(
      appBar: BotigaAppBar(
        '',
        actions: [
          ...(orderDetail.order.isOpen || orderDetail.order.isDelayed)
              ? [
                  FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Cancel Order',
                                style: AppTheme.textStyle.w500.color100,
                              ),
                              content: Text(
                                'Are you sure you want to cancel this order?',
                                style: AppTheme.textStyle.w400.color100,
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'Don\'t Cancel',
                                    style: AppTheme.textStyle.w600.color50,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Confirm',
                                    style: AppTheme.textStyle.w600
                                        .colored(AppTheme.errorColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    handleCancelOrder(orderId, apartmentId,
                                        selectedDateForRequest);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Text('Cancel Order',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Theme.of(context).colorScheme.error)),
                  )
                ]
              : []
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      bottomNavigationBar: (orderDetail.order.isOpen ||
              orderDetail.order.isDelayed ||
              orderDetail.order.isOutForDelivery)
          ? SafeArea(
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
                              handleMarkAsDeliverd(orderId, apartmentName,
                                  apartmentId, selectedDateForRequest);
                            },
                            color: AppTheme.primaryColor,
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
            )
          : SizedBox.shrink(),
      body: SafeArea(
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Container(
            color: AppTheme.backgroundColor,
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
        ),
      ),
    );
  }
}
