import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                                getBotigaCalendar(
                                  context,
                                  DateTime.now()
                                      .subtract(const Duration(days: 15)),
                                  DateTime.now().add(const Duration(days: 60)),
                                  selectedDate,
                                  (DateTime date) {
                                    setState(() {
                                      selectedDate = date;
                                      selectedDateForRequest = date;
                                    });
                                    fetchData(date.getRequestFormatDate());
                                  },
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
