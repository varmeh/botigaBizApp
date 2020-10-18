import 'package:flutter/material.dart';
import 'orderDelivery.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'orderSummary.dart';
import '../../theme/index.dart';
import '../../providers/Orders/OrdersProvider.dart';
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

  void handleMarkAsDelayOrders(String orderId, DateTime date) {
    Navigator.of(context).pop();
    setState(() {
      _isLoading = true;
    });
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final deliveryDelayedDate = FormatDate.getRequestFormatDate(date);
    ordersProvider
        .setDeliveryDelayed(orderId, deliveryDelayedDate)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      final newDateforDelivery = FormatDate.getDate(date);
      Toast(
              message: '${Constants.deliveryDateChanged} $newDateforDelivery',
              iconData: BotigaIcons.truck)
          .show(context);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline_sharp)
          .show(context);
    });
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

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgs =
        ModalRoute.of(context).settings.arguments;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final orderId = routeArgs['orderId'];
    final apartmentName = routeArgs['apartmentName'];
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
                handleCancelOrder(orderId);
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
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
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
                                      color:
                                          Color(0xff121714).withOpacity(0.12),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
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
                                              weekendStyle:
                                                  AppTheme.textStyle.color100,
                                              outsideWeekendStyle:
                                                  AppTheme.textStyle.color50),
                                          daysOfWeekStyle: DaysOfWeekStyle(
                                            weekendStyle: AppTheme.textStyle
                                                .colored(AppTheme.color100),
                                          ),
                                          headerStyle: HeaderStyle(
                                            centerHeaderTitle: false,
                                            formatButtonVisible: false,
                                          ),
                                          onDaySelected: (date, events) {
                                            handleMarkAsDelayOrders(
                                                orderId, date);
                                          },
                                          calendarController:
                                              _calendarController,
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
                                      color:
                                          Color(0xff121714).withOpacity(0.12),
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
                                    Navigator.of(context).pushNamed(
                                        OrderDelivery.routeName,
                                        arguments: {
                                          'orderId': orderDetail.id,
                                          'apartmentName': apartmentName,
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
                        ),
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
