import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import './index.dart';
import '../../theme/index.dart';
import '../../providers/index.dart' show OrdersProvider;
import '../../util/index.dart';
import '../../widget/index.dart';
import '../../models/orders/index.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = 'order-details';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  CalendarController _calendarController;
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _isLoading = false;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void handleMarkAsDelayOrders(String orderId, DateTime date,
      String apartmentId, String selectedDateForRequest) async {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      final deliveryDelayedDate = date.getRequestFormatDate();
      await ordersProvider.setDeliveryDelayed(orderId, deliveryDelayedDate);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
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

  void handleOutForDelivery(String orderId, String apartmentName,
      String apartmentId, String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.setStatusOutForDelivery(orderId);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
      Toast(
        message: 'Out for delivery',
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

  void handleRefundComplete(String orderId, String apartmentName,
      String apartmentId, String selectedDateForRequest) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.setRefundCompleted(orderId);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
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

  Widget getBottomNavbar(OrderByDateDetail orderDetail, String orderId,
      String apartmentName, String apartmentId, String selectedDateForRequest) {
    Function fn;
    String btnText;

    if (orderDetail.order.isOutForDelivery == true) {
      fn = handleMarkAsDeliverd;
      btnText = 'Mark as delivered';
    } else if (orderDetail.payment.isSuccess == true &&
        orderDetail.refund != null &&
        orderDetail.refund.isSuccess == false) {
      fn = handleRefundComplete;
      btnText = 'Mark as Refunded';
    } else {
      return SizedBox.shrink();
    }
    return SafeArea(
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
                    fn(orderId, apartmentName, apartmentId,
                        selectedDateForRequest);
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
    final orderId = routeArgs['orderId'];
    final apartmentName = routeArgs['apartmentName'];
    final apartmentId = routeArgs['apartmentId'];
    final selectedDateForRequest = routeArgs['selectedDateForRequest'];

    final OrderByDateDetail orderDetail =
        ordersProvider.getOrderDetails(orderId);

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
                                  handleCancelOrder(orderId, apartmentId,
                                      selectedDateForRequest);
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
      bottomNavigationBar: getBottomNavbar(orderDetail, orderId, apartmentName,
          apartmentId, selectedDateForRequest),
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
                Divider(
                  color: AppTheme.dividerColor,
                  thickness: 4,
                ),
                OrderStatusWidget(orderDetails: orderDetail),
                Divider(
                  color: AppTheme.dividerColor,
                  thickness: 4,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OrderListSummary(orderDetail),
                      SizedBox(
                        height: 87,
                      ),
                      (orderDetail.order.isOpen == true ||
                              orderDetail.order.isDelayed == true)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 90,
                                    height: 128,
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.color100
                                              .withOpacity(0.12),
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
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) => Container(
                                            padding:
                                                EdgeInsets.only(bottom: 24),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(16.0),
                                                topRight:
                                                    const Radius.circular(16.0),
                                              ),
                                            ),
                                            child: SafeArea(
                                              child: TableCalendar(
                                                startDay: DateTime.now(),
                                                availableCalendarFormats: const {
                                                  CalendarFormat.month: 'Month',
                                                },
                                                calendarStyle: CalendarStyle(
                                                    todayColor: AppTheme
                                                        .primaryColorVariant
                                                        .withOpacity(0.5),
                                                    selectedColor:
                                                        AppTheme.primaryColor,
                                                    outsideDaysVisible: true,
                                                    weekendStyle: AppTheme
                                                        .textStyle.color100,
                                                    outsideWeekendStyle:
                                                        AppTheme
                                                            .textStyle.color50),
                                                daysOfWeekStyle:
                                                    DaysOfWeekStyle(
                                                  weekendStyle: AppTheme
                                                      .textStyle
                                                      .colored(
                                                          AppTheme.color100),
                                                ),
                                                headerStyle: HeaderStyle(
                                                  centerHeaderTitle: false,
                                                  formatButtonVisible: false,
                                                ),
                                                onDaySelected:
                                                    (date, events, _) {
                                                  handleMarkAsDelayOrders(
                                                      orderId,
                                                      date,
                                                      apartmentId,
                                                      selectedDateForRequest);
                                                },
                                                calendarController:
                                                    _calendarController,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(BotigaIcons.delay),
                                            Text(
                                              'Mark as delay',
                                              textAlign: TextAlign.center,
                                              style: AppTheme
                                                  .textStyle.color100.w500
                                                  .size(12)
                                                  .letterSpace(0.2),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Container(
                                    width: 90,
                                    height: 128,
                                    decoration: BoxDecoration(
                                      color: AppTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.color100
                                              .withOpacity(0.12),
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
                                        handleOutForDelivery(
                                            orderId,
                                            apartmentName,
                                            apartmentId,
                                            selectedDateForRequest);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              BotigaIcons.truck,
                                              color: AppTheme.primaryColor,
                                              size: 34,
                                            ),
                                            Text(
                                              'Out for delivery',
                                              textAlign: TextAlign.center,
                                              style: AppTheme.textStyle
                                                  .colored(
                                                      AppTheme.primaryColor)
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
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
