import 'package:flutter/material.dart';
import 'orderRow.dart';
import 'orderList.dart';
import '../../util/constants.dart';
import '../../theme/index.dart' show BotigaIcons;

class OrdersHome extends StatefulWidget {
  static const routeName = '/orders-home';
  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends State<OrdersHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _orderCard(context, "Riverside apartment", "380", "5", [1, 2, 3]),
        _orderCard(context, "Riverside apartment", "340", "5", [1, 2, 3]),
        _orderCard(context, "Riverside apartment", "390", "5", [1, 2, 3]),
      ],
    );
  }
}

Widget _orderCard(BuildContext context, String apartmentName, String revenue,
    String totalOrder, List orderList) {
  final contextTheme = Theme.of(context);
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 490,
                width: double.infinity,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 16,
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
                              style: contextTheme.textTheme.headline6,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 27.86, bottom: 27),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${Constants.revenue}',
                                  style: contextTheme.textTheme.subtitle2,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '${Constants.rupeeSymbol} $revenue',
                                  style: contextTheme.textTheme.subtitle2,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 95,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${Constants.orders}",
                                  style: contextTheme.textTheme.subtitle2,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  '$totalOrder',
                                  style: contextTheme.textTheme.subtitle2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: contextTheme.backgroundColor,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      ...orderList.map((el) {
                        return OrderRow(() {});
                      }),
                      _viewAllOrders(context)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 48,
      ),
    ],
  );
}

Widget _viewAllOrders(context) {
  return Container(
    padding: EdgeInsets.only(top: 18.0, bottom: 8.0, left: 24, right: 20),
    child: InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(OrderList.routeName);
      },
      child: Text(
        Constants.viewAllOrders,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
