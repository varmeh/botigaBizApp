import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orders/index.dart';
import '../../providers/index.dart' show OrdersProvider, DeliveryProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'index.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = 'order-details';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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

  Future refetchScreenData(String apartmentId, String selectedDateForRequest,
      bool shouldNavigateBack) async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: false);
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    if (routeArgs['flowType'] == 'order') {
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
    } else {
      await deliveryProvider.fetchDeliveryListByApartment(
          apartmentId, selectedDateForRequest);
      if (shouldNavigateBack == true) {
        Navigator.of(context).pop();
      }
    }
  }

  void handleMarkAsDelayOrders(String id, DateTime date, String apartmentId,
      String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      final deliveryDelayedDate = date.getRequestFormatDate();
      await deliveryProvider.setDeliveryDelayed(id, deliveryDelayedDate);
      await refetchScreenData(apartmentId, selectedDateForRequest, true);
      final newDateforDelivery = date.getDate();
      Toast(
        message: 'Delivery date changed to $newDateforDelivery',
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

  void handleMarkAsDeliverd(String id, String apartmentName, String apartmentId,
      String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      await deliveryProvider.setDeliveryStatus(id);
      await refetchScreenData(apartmentId, selectedDateForRequest, false);
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

  void handleOutForDelivery(String id, String apartmentName, String apartmentId,
      String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      await deliveryProvider.setStatusOutForDelivery(id);
      await refetchScreenData(apartmentId, selectedDateForRequest, false);
      Toast(
        message: 'Order Shipped',
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

  void handleCancelOrder(
      String id, String apartmentId, String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.cancelOrder(id);
      await refetchScreenData(apartmentId, selectedDateForRequest, false);
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

  void handleRefundComplete(String id, String apartmentName, String apartmentId,
      String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.setRefundCompleted(id);
      await refetchScreenData(apartmentId, selectedDateForRequest, false);
      Toast(
        message: 'Refund success',
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

  Widget getBottomNavbar(OrderByDateDetail orderDetail, String id,
      String apartmentName, String apartmentId, String selectedDateForRequest) {
    Function fn;
    String btnText;

    if (orderDetail.order.isOutForDelivery == true) {
      fn = handleMarkAsDeliverd;
      btnText = 'Mark Delivered';
    } else if (orderDetail.refund.isRefundDue) {
      fn = handleRefundComplete;
      btnText = 'Mark Refunded';
    } else {
      return SizedBox.shrink();
    }
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  onPressed: () {
                    fn(id, apartmentName, apartmentId, selectedDateForRequest);
                  },
                  color: AppTheme.primaryColor,
                  child: Text(
                    btnText,
                    style: AppTheme.textStyle
                        .colored(AppTheme.backgroundColor)
                        .w500
                        .size(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: true);
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: true);
    final id = routeArgs['id'];
    final apartmentName = routeArgs['apartmentName'];
    final apartmentId = routeArgs['apartmentId'];
    final selectedDateForRequest = routeArgs['selectedDateForRequest'];
    final divider = Divider(
      color: AppTheme.dividerColor,
      thickness: 4,
    );

    OrderByDateDetail orderDetail = (routeArgs['flowType'] == 'order')
        ? ordersProvider.getOrderDetails(id)
        : deliveryProvider.getDeliveryDetails(
            id, apartmentId, selectedDateForRequest);
    if (orderDetail == null) {
      return Scaffold(
        body: SizedBox.shrink(),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(
        '',
        actions: [
          ...(orderDetail.order.isOpen == true ||
                  orderDetail.order.isDelayed == true)
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
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  handleCancelOrder(
                                      id, apartmentId, selectedDateForRequest);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Cancel Order',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  )
                ]
              : []
        ],
      ),
      bottomNavigationBar: getBottomNavbar(
          orderDetail, id, apartmentName, apartmentId, selectedDateForRequest),
      body: SafeArea(
        child: LoaderOverlay(
          isLoading: _isLoading,
          child: Container(
            color: AppTheme.backgroundColor,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 24.0,
                  ),
                  child: OrderSummary(orderDetail, apartmentName),
                ),
                divider,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: ContactWidget(
                    whatsapp: orderDetail.buyer.whatsapp,
                    phone: orderDetail.buyer.phone,
                  ),
                ),
                divider,
                OrderStatusWidget(orderDetails: orderDetail),
                divider,
                OrderListSummary(orderDetail),
                SizedBox(height: 40),
                (orderDetail.order.isOpen == true ||
                        orderDetail.order.isDelayed == true)
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 128,
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.color100.withOpacity(0.12),
                                    blurRadius: 40.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  getBotigaCalendar(
                                    context,
                                    DateTime.now(),
                                    DateTime.now()
                                        .add(const Duration(days: 90)),
                                    DateTime.now(),
                                    (DateTime date) {
                                      handleMarkAsDelayOrders(id, date,
                                          apartmentId, selectedDateForRequest);
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        BotigaIcons.delay,
                                        size: 24,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Change Delivery Date',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.textStyle.color100.w500
                                            .size(12)
                                            .letterSpace(0.2),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24),
                            Container(
                              width: 90,
                              height: 128,
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.color100.withOpacity(0.12),
                                    blurRadius: 40.0, // soften the shadow
                                    spreadRadius: 0.0, //extend the shadow
                                    offset: Offset(
                                      0.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  handleOutForDelivery(id, apartmentName,
                                      apartmentId, selectedDateForRequest);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        BotigaIcons.truck,
                                        color: AppTheme.primaryColor,
                                        size: 34,
                                      ),
                                      Text(
                                        'Mark Shipped',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.textStyle
                                            .colored(AppTheme.primaryColor)
                                            .w500
                                            .size(12)
                                            .letterSpace(0.3),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
