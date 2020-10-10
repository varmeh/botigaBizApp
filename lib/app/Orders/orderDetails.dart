import 'package:flutter/material.dart';
import 'orderDelivery.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import '../../widget/common/appHeader.dart';
import 'orderSummary.dart';
import '../../theme/index.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../models/Orders/OrderByDateDetail.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = '/order-details';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

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
      body: SafeArea(
        child: Container(
          color: AppTheme.surfaceColor,
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
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff121714).withOpacity(0.12),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.65,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16.0),
                                        topRight: const Radius.circular(16.0),
                                      ),
                                    ),
                                    child: TableCalendar(
                                      startDay: DateTime.now(),
                                      availableCalendarFormats: const {
                                        CalendarFormat.month: 'Month',
                                      },
                                      calendarStyle: CalendarStyle(
                                          selectedColor: AppTheme.primaryColor,
                                          outsideDaysVisible: true,
                                          weekendStyle:
                                              AppTheme.textStyle.color100,
                                          outsideWeekendStyle:
                                              AppTheme.textStyle.color50),
                                      daysOfWeekStyle: DaysOfWeekStyle(
                                        weekendStyle: AppTheme.textStyle
                                            .colored(AppTheme.surfaceColor),
                                      ),
                                      headerStyle: HeaderStyle(
                                        centerHeaderTitle: false,
                                        formatButtonVisible: false,
                                      ),
                                      onDaySelected: (date, events) {
                                        ordersProvider
                                            .setDeliveryDelayed()
                                            .then((value) {
                                          final newDate =
                                              DateFormat("d MMM").format(date);
                                          Navigator.of(context).pop();
                                          Flushbar(
                                            maxWidth: 335,
                                            backgroundColor: Color(0xff2591B2),
                                            messageText: Text(
                                              'Delivery date changed to $newDate',
                                              style: AppTheme.textStyle
                                                  .colored(
                                                      AppTheme.surfaceColor)
                                                  .w500
                                                  .size(15),
                                            ),
                                            icon: Icon(BotigaIcons.truck,
                                                size: 30,
                                                color: AppTheme.surfaceColor),
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                            duration: Duration(seconds: 3),
                                            margin: EdgeInsets.all(20),
                                            padding: EdgeInsets.all(20),
                                            borderRadius: 8,
                                          ).show(context);
                                        }).catchError((error) {
                                          print(error);
                                        });
                                      },
                                      calendarController: _calendarController,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(BotigaIcons.delay),
                                    Text(
                                      'Mark as delay',
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
                          SizedBox(
                            width: 24,
                          ),
                          Container(
                            width: 90,
                            height: 128,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff121714).withOpacity(0.12),
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
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(
                      height: 56,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
