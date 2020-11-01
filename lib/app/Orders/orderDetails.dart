import 'package:flutter/material.dart';
import 'orderDelivery.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'orderSummary.dart';
import '../../theme/index.dart';
import '../../providers/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../util/index.dart';
import '../../widget/index.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = '/order-details';

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
      final deliveryDelayedDate = FormatDate.getRequestFormatDate(date);
      await ordersProvider.setDeliveryDelayed(orderId, deliveryDelayedDate);
      await ordersProvider.fetchOrderByDateApartment(
          apartmentId, selectedDateForRequest);
      final newDateforDelivery = FormatDate.getDate(date);
      Toast(
              message: '${Constants.deliveryDateChanged} $newDateforDelivery',
              iconData: BotigaIcons.truck)
          .show(context);
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
                                    onPressed: () async {
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
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.error)),
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        OrderListSummary(orderDetail),
                        SizedBox(
                          height: 87,
                        ),
                        isOrderOpen(orderDetail.order.status)
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
                                            color: Color(0xff121714)
                                                .withOpacity(0.12),
                                            blurRadius:
                                                40.0, // soften the shadow
                                            spreadRadius:
                                                0.0, //extend the shadow
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
                                                      const Radius.circular(
                                                          16.0),
                                                  topRight:
                                                      const Radius.circular(
                                                          16.0),
                                                ),
                                              ),
                                              child: SafeArea(
                                                child: TableCalendar(
                                                  startDay: DateTime.now(),
                                                  availableCalendarFormats: const {
                                                    CalendarFormat.month:
                                                        'Month',
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
                                                          AppTheme.textStyle
                                                              .color50),
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
                                                      (date, events) {
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
                                            color: Color(0xff121714)
                                                .withOpacity(0.12),
                                            blurRadius:
                                                40.0, // soften the shadow
                                            spreadRadius:
                                                0.0, //extend the shadow
                                            offset: Offset(
                                              0.0, // Move to right 10  horizontally
                                              0.0, // Move to bottom 10 Vertically
                                            ),
                                          )
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              OrderDelivery.routeName,
                                              arguments: {
                                                'orderId': orderDetail.id,
                                                'apartmentName': apartmentName,
                                                'apartmentId': apartmentId,
                                                'selectedDateForRequest':
                                                    selectedDateForRequest
                                              });
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
            _isLoading ? Loader() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
