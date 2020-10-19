import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'orderList.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widget/index.dart';
import '../../providers/Orders/OrdersProvider.dart';

class OrdersHome extends StatefulWidget {
  static const routeName = '/orders-home';
  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends State<OrdersHome> {
  var _isLoading = false;
  var _isError = false;
  var _isInit = false;
  var slectedDate = Constants.today;
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

  void fetchData(String date) {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    ordersProvider.fetchAggregatedOrders(date).then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      var currentDate = FormatDate.getRequestFormatDate(DateTime.now());
      fetchData(currentDate);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Widget _orderCard(
      String apartmentIdid, String apartmentName, int revenue, int totalOrder) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(OrderList.routeName, arguments: {
          'apartmentId': apartmentIdid,
          'apartmentName': apartmentName
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.color05,
                blurRadius: 40.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
                offset: Offset(
                  0.0, // Move to right
                  0.0, // Move to bottom
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Card(
                  color: AppTheme.backgroundColor,
                  elevation: 0,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  left: 27.86,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        BotigaIcons.building,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7.86,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '$apartmentName',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Divider(
                                  thickness: 1.3,
                                  color: AppTheme.dividerColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 27.86, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${Constants.revenue}',
                                          style: AppTheme.textStyle.color50.w500
                                              .size(12),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '${Constants.rupeeSymbol} $revenue',
                                          style: AppTheme
                                              .textStyle.color100.w500
                                              .size(17),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 95,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${Constants.orders}",
                                          style: AppTheme.textStyle.color50.w500
                                              .size(12),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '$totalOrder',
                                          style: AppTheme
                                              .textStyle.color100.w500
                                              .size(17),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderHeader(int revenue, int totalOrder) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(double.infinity, 245)),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 25, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hi Jashn,",
                      style: AppTheme.textStyle
                          .colored(AppTheme.backgroundColor)
                          .w700
                          .size(22),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.65,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                              ),
                            ),
                            child: TableCalendar(
                              initialSelectedDay:
                                  FormatDate.convertStringToDate(slectedDate),
                              startDay: DateTime.now(),
                              availableCalendarFormats: const {
                                CalendarFormat.month: 'Month',
                              },
                              calendarStyle: CalendarStyle(
                                  todayColor: AppTheme.primaryColorVariant
                                      .withOpacity(0.5),
                                  selectedColor: AppTheme.primaryColor,
                                  outsideDaysVisible: true,
                                  weekendStyle: AppTheme.textStyle.color100,
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
                                Navigator.of(context).pop();
                                setState(() {
                                  slectedDate =
                                      FormatDate.getTodayOrSelectedDate(date);
                                });
                                fetchData(
                                    FormatDate.getRequestFormatDate(date));
                              },
                              calendarController: _calendarController,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                              '${FormatDate.getShortDateFromDate(slectedDate)}',
                              style: AppTheme.textStyle
                                  .colored(AppTheme.backgroundColor)
                                  .w500
                                  .size(15)),
                          SizedBox(
                            width: 9,
                          ),
                          Icon(Icons.expand_more_sharp,
                              size: 25, color: AppTheme.backgroundColor),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 20,
            right: 20,
            bottom: 0,
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 0,
              color: AppTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("REVENUE",
                            style: AppTheme.textStyle.color50.w500.size(12)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${Constants.rupeeSymbol} $revenue',
                          style: AppTheme.textStyle.color100.w500.size(22),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 106,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("ORDERS",
                            style: AppTheme.textStyle.color50.w500.size(12)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$totalOrder',
                          style: AppTheme.textStyle.color100.w500.size(22),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorContext = Theme.of(context).colorScheme;
    return _isLoading
        ? Loader()
        : _isError
            ? Center(
                child: Icon(
                  Icons.error_outline,
                  color: colorContext.error,
                ),
              )
            : Consumer<OrdersProvider>(
                builder: (ctx, ordersprovider, _) {
                  final aggregatedOrders = ordersprovider.aggregatedOrders;
                  return SafeArea(
                    child: Container(
                      color: AppTheme.dividerColor,
                      child: ListView(
                        children: <Widget>[
                          _orderHeader(aggregatedOrders.totalRevenue,
                              aggregatedOrders.totalOrders),
                          ...aggregatedOrders.apartmentWiseBreakup.map(
                            (apartment) {
                              return _orderCard(
                                  apartment.id,
                                  apartment.apartmentName,
                                  apartment.orders,
                                  apartment.revenue);
                            },
                          ),
                          SizedBox(
                            height: 32,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
  }
}
