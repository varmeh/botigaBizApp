import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderList.dart';
import '../../util/constants.dart';
import '../../theme/index.dart' show BotigaIcons;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final ordersProvider = Provider.of<OrdersProvider>(context);
      setState(() {
        _isError = false;
        _isLoading = true;
      });
      ordersProvider.fetchAggregatedOrders().then((_) {
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
    final colorContext = Theme.of(context).colorScheme;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
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
                  return Container(
                    color: colorContext.surface,
                    child: ListView(
                      children: <Widget>[
                        _orderHeader(context, aggregatedOrders.totalRevenue,
                            aggregatedOrders.totalOrders),
                        ...aggregatedOrders.apartmentWiseBreakup.map(
                          (order) {
                            return _orderCard(context, order.apartmentName,
                                order.orders, order.revenue);
                          },
                        ),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  );
                },
              );
  }
}

Widget _orderCard(
    BuildContext context, String apartmentName, int revenue, int totalOrder) {
  final contextTheme = Theme.of(context);
  return InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(OrderList.routeName);
    },
    child: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.12),
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
                elevation: 1,
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
                                top: 32,
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
                                  Text(
                                    '$apartmentName',
                                    style: contextTheme.textTheme.subtitle1,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Divider(
                                color: contextTheme.backgroundColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 27.86, bottom: 27),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '${Constants.revenue}',
                                        style: contextTheme.textTheme.overline,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '${Constants.rupeeSymbol} $revenue',
                                        style: contextTheme.textTheme.headline5,
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
                                        style: contextTheme.textTheme.overline,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        '$totalOrder',
                                        style: contextTheme.textTheme.headline5,
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

Widget _orderHeader(BuildContext context, int revenue, int totalOrder) {
  return ConstrainedBox(
    constraints: BoxConstraints.tight(Size(double.infinity, 290)),
    child: new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 237,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(12.0),
                  bottomRight: const Radius.circular(12.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hi Jashn,",
                    style: Theme.of(context).textTheme.headline3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "TODAY",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.expand_more_sharp,
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 164,
          left: 20,
          right: 20,
          bottom: 0,
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 1,
            color: Theme.of(context).colorScheme.surface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 336,
              height: 113,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("REVENUE",
                          style: Theme.of(context).textTheme.overline),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${Constants.rupeeSymbol} $revenue',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("ORDERS",
                          style: Theme.of(context).textTheme.overline),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$totalOrder',
                        style: Theme.of(context).textTheme.headline3,
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
