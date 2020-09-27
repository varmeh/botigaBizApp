import '../order-screen/orderList.dart';
import 'package:flutter/material.dart';
import '../../widget/common/orderRow.dart';
import '../../util/constants.dart';

class Order extends StatefulWidget {
  static const routeName = '/order-screen';
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
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
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          top: 32, bottom: 16, left: 27.86),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Image(
                              image: AssetImage('assets/icons/building.png'),
                            ),
                          ),
                          SizedBox(
                            width: 7.86,
                          ),
                          Text(
                            '$apartmentName',
                            style: Theme.of(context).textTheme.headline6,
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
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${Constants.rupeeSymbol} $revenue',
                                style: Theme.of(context).textTheme.subtitle2,
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
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '$totalOrder',
                                style: Theme.of(context).textTheme.subtitle2,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).backgroundColor,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    ...orderList.map((el) {
                      return OrderRow(() {});
                    }),
                    _viewAllOrders(context)
                  ],
                )),
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
            fontWeight: FontWeight.w600),
      ),
    ),
  );
}
