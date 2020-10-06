import 'package:flutter/material.dart';
import 'orderDelivery.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import '../../widget/common/appHeader.dart';
import 'orderSummary.dart';
import '../../theme/index.dart' show BotigaIcons;
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
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                top: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppHeader(
                    title: "",
                    actionWidget: InkWell(
                      onTap: () {
                        debugPrint('I am Awesome');
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Text('Cancel Order',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.error)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OrderSummary(orderDetail)
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
                            color: Theme.of(context).colorScheme.surface,
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
                                      selectedColor:
                                          Theme.of(context).colorScheme.primary,
                                      outsideDaysVisible: true,
                                      weekendStyle: TextStyle().copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                    daysOfWeekStyle: DaysOfWeekStyle(
                                      weekendStyle: TextStyle().copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    headerStyle: HeaderStyle(
                                      centerHeaderTitle: false,
                                      formatButtonVisible: false,
                                    ),
                                    onDaySelected: (date, events) {
                                      final newDate =
                                          DateFormat("d MMM").format(date);
                                      Navigator.of(context).pop();
                                      Flushbar(
                                        maxWidth: 335,
                                        backgroundColor: Color(0xff2591B2),
                                        messageText: Text(
                                          'Delivery date changed to $newDate',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                        ),
                                        icon: Icon(BotigaIcons.truck,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface),
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        duration: Duration(seconds: 3),
                                        margin: EdgeInsets.all(20),
                                        padding: EdgeInsets.all(20),
                                        borderRadius: 8,
                                      ).show(context);
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                          letterSpacing: 0.2,
                                        ),
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
                            color: Theme.of(context).colorScheme.surface,
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
                                    color: Theme.of(context).primaryColor,
                                    size: 34,
                                  ),
                                  Text(
                                    'Out for delivery',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          letterSpacing: 0.2,
                                        ),
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
    );
  }
}
