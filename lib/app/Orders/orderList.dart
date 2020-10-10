import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'orderRow.dart';
import 'orderDetails.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../theme/index.dart';

class OrderList extends StatefulWidget {
  static const routeName = '/all-orders-list';

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  var _isLoading = false;
  var _isError = false;
  var _isInit = false;
  var slectedDate = 'TODAY';
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
  void didChangeDependencies() {
    if (!_isInit) {
      final ordersProvider = Provider.of<OrdersProvider>(context);
      setState(() {
        _isError = false;
        _isLoading = true;
      });
      ordersProvider.fetchOrderByDateApartment().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          elevation: 0,
          centerTitle: false,
          title: Align(
            child: Text(
              "Orders",
              style: TextStyle(
                  color: AppTheme.color100,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            alignment: Alignment.centerLeft,
          ),
          actions: [
            IconButton(
              icon: Icon(
                BotigaIcons.search,
                color: AppTheme.color100,
              ),
              onPressed: () {},
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isError
              ? Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              : SafeArea(
                  child: Container(
                    color: AppTheme.surfaceColor,
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
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
                                                AppTheme.primaryColor,
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
                                          final newDate =
                                              DateFormat("yMd").format(date);
                                          Navigator.of(context).pop();
                                          setState(() {
                                            slectedDate = newDate;
                                          });
                                        },
                                        calendarController: _calendarController,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text('$slectedDate',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15)),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Icon(Icons.expand_more_sharp,
                                        size: 25, color: AppTheme.color100),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Consumer<OrdersProvider>(
                            builder: (ctx, ordersprovider, _) {
                          final orderByDateApartment =
                              ordersprovider.orderByDateApartment;
                          if (orderByDateApartment == null) {
                            return SizedBox();
                          }

                          return Column(
                            children: [
                              ...orderByDateApartment.map((orderRow) {
                                return OrderRow(() {
                                  Navigator.of(context).pushNamed(
                                    OrderDetails.routeName,
                                    arguments: {
                                      'orderId': orderRow.id,
                                    },
                                  );
                                },
                                    orderRow.order.number,
                                    orderRow.order.products.length,
                                    orderRow.order.orderDate,
                                    orderRow.order.status,
                                    orderRow.order.totalAmount);
                              })
                            ],
                          );
                        }),
                        SizedBox(
                          height: 61,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
