import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import '../../widget/common/orderSummary.dart';
import '../order-delivery/orderDelivery.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:intl/intl.dart';
import '../../theme/index.dart' show BotigaIcons;

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
    return Scaffold(
      body: Container(
        color: Colors.white,
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
                      child: Text(
                        'Cancel Order',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xffDA3030),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OrderSummary()
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  OrderListSummary(),
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
                            color: Colors.white,
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
                                    color: Colors.white,
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
                                      selectedColor: Color(0xff179F57),
                                      outsideDaysVisible: true,
                                      weekendStyle: TextStyle()
                                          .copyWith(color: Colors.black),
                                    ),
                                    daysOfWeekStyle: DaysOfWeekStyle(
                                      weekendStyle: TextStyle()
                                          .copyWith(color: Colors.black54),
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
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        icon: Icon(BotigaIcons.truck),
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w500,
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
                            color: Colors.white,
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
                              Navigator.of(context)
                                  .pushNamed(OrderDelivery.routeName);
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
                                    style: TextStyle(
                                      color: Color(0xff179F57),
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      fontWeight: FontWeight.w500,
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
