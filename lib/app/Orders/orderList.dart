import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orderRow.dart';
import 'orderDetails.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../widget/common/appHeader.dart';
import '../../theme/index.dart' show BotigaIcons;

class OrderList extends StatefulWidget {
  static const routeName = '/all-orders-list';

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
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
    final contextTheme = Theme.of(context);
    return Scaffold(
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
              : Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AppHeader(
                              title: "Orders",
                              actionWidget: IconButton(
                                icon: Icon(BotigaIcons.search),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text("TODAY",
                                style: contextTheme.textTheme.subtitle1
                                    .copyWith(
                                        color: contextTheme
                                            .colorScheme.onPrimary)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
    );
  }
}
