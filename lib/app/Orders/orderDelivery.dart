import 'package:botiga_biz/util/httpService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderSummary.dart';
import '../../providers/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../theme/index.dart';
import '../../widget/index.dart';
import '../../util/index.dart';

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
      Toast(message: 'Order canceled', iconData: BotigaIcons.truck)
          .show(context);
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
      Toast(message: "Order marked as deliverd", iconData: BotigaIcons.truck)
          .show(context);
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
        appBar: AppBar(
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            actions: [
              ...isOrderOpen(orderDetail.order.status)
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
                                        handleCancelOrder(orderId, apartmentId,
                                            selectedDateForRequest);
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
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.error)),
                      )
                    ]
                  : []
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
        bottomNavigationBar: isOrderOpen(orderDetail.order.status)
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
              )
            : SizedBox.shrink(),
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
