import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/index.dart' show OrdersProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'index.dart';

class OrderList extends StatefulWidget {
  static const routeName = 'all-orders-list';

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  bool _isLoading = false;
  bool _isError = false;
  var _error;
  bool _isInit = false;
  bool _showSearch = false;
  String _query = '';
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateForRequest;
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

  void fetchData(String date) async {
    setState(() {
      _error = null;
      _isError = false;
      _isLoading = true;
    });
    try {
      final routesArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final id = routesArgs['apartmentId'];
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);
      await ordersProvider.fetchOrderByDateApartment(id, date);
    } catch (err) {
      setState(() {
        _error = err;
        _isError = true;
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final routesArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      DateTime date = routesArgs['selectedDateForRequest'];
      var currentDate = date.getRequestFormatDate();
      fetchData(currentDate);
      setState(() {
        selectedDateForRequest = date;
        selectedDate = date;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final aprtmentName = routesArgs['apartmentName'];
    final apartmentId = routesArgs['apartmentId'];
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: !_showSearch
          ? BotigaAppBar(
              aprtmentName,
              actions: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    BotigaIcons.search,
                    color: AppTheme.color100,
                  ),
                  onPressed: () {
                    setState(() {
                      _showSearch = true;
                    });
                  },
                )
              ],
            )
          : null,
      body: _isLoading
          ? Loader()
          : _isError
              ? HttpExceptionWidget(
                  exception: _error,
                  onTap: () {
                    fetchData(DateTime.now().getRequestFormatDate());
                  },
                )
              : SafeArea(
                  child: GestureDetector(
                    onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
                    child: Container(
                      color: AppTheme.backgroundColor,
                      child: Column(
                        children: [
                          _showSearch
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: AppTheme.color100,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Expanded(
                                          child: SearchBar(
                                            placeholder:
                                                "Search by order number...",
                                            onClear: () {
                                              setState(() {
                                                _query = '';
                                              });
                                            },
                                            onChange: (value) {
                                              setState(() {
                                                _query = value;
                                              });
                                            },
                                            onSubmit: (_) {},
                                          ),
                                        ),
                                        IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          icon: Icon(
                                            Icons.close,
                                            color: AppTheme.color100,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _showSearch = false;
                                              _query = '';
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 20, right: 20),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    padding: EdgeInsets.only(bottom: 24),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16.0),
                                        topRight: const Radius.circular(16.0),
                                      ),
                                    ),
                                    child: SafeArea(
                                      child: TableCalendar(
                                        initialSelectedDay: selectedDate,
                                        startDay: DateTime.now()
                                            .subtract(Duration(days: 15)),
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
                                        onDaySelected: (date, events, _) {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            selectedDate = date;
                                            selectedDateForRequest = date;
                                          });
                                          fetchData(
                                              date.getRequestFormatDate());
                                        },
                                        calendarController: _calendarController,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Text(
                                      '${selectedDate.getTodayOrSelectedDate()}',
                                      style: AppTheme.textStyle.color100.w500
                                          .size(15)),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Icon(Icons.expand_more_sharp,
                                      size: 25, color: AppTheme.color100),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                Consumer<OrdersProvider>(
                                    builder: (ctx, ordersprovider, _) {
                                  final orderByDateApartment =
                                      ordersprovider.orderByDateApartment;
                                  if (orderByDateApartment == null ||
                                      orderByDateApartment.length == 0) {
                                    return EmptyOrders();
                                  }

                                  var orders = orderByDateApartment;
                                  if (_query != '' && _query != null) {
                                    orders = orders.where(
                                      (_order) {
                                        return _order.order.number
                                                .toLowerCase()
                                                .contains(
                                                    _query.toLowerCase()) ==
                                            true;
                                      },
                                    );
                                  }
                                  return Column(
                                    children: [
                                      ...orders.map((orderRow) {
                                        return OrderRow(
                                          () {
                                            Navigator.of(context).pushNamed(
                                              OrderDetails.routeName,
                                              arguments: {
                                                'flowType': 'order',
                                                'id': orderRow.id,
                                                'apartmentName': aprtmentName,
                                                'apartmentId': apartmentId,
                                                'selectedDateForRequest':
                                                    selectedDateForRequest ==
                                                            null
                                                        ? DateTime.now()
                                                            .getRequestFormatDate()
                                                        : selectedDateForRequest
                                                            .getRequestFormatDate()
                                              },
                                            );
                                          },
                                          orderRow.order,
                                        );
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
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
