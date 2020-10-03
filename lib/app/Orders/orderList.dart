import 'package:flutter/material.dart';
import 'orderRow.dart';
import 'orderDetails.dart';
import '../../widget/common/appHeader.dart';
import '../../util/constants.dart';
import '../../theme/index.dart' show BotigaIcons;

class OrderList extends StatelessWidget {
  static const routeName = '/all-orders-list';

  @override
  Widget build(BuildContext context) {
    final contextTheme = Theme.of(context);
    return Scaffold(
      body: Container(
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
                          .copyWith(color: contextTheme.colorScheme.onPrimary)),
                  SizedBox(
                    height: 25,
                  ),
                  _orderCard(context),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((el) {
              return OrderRow(() {
                Navigator.of(context).pushNamed(OrderDetails.routeName);
              });
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

Widget _orderCard(BuildContext context) {
  final contextTextTheme = Theme.of(context).textTheme;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: double.infinity,
        height: 153,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff121714).withOpacity(0.12),
              blurRadius: 40.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
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
                            'Riverside apartment',
                            style: contextTextTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 27.86,
                        bottom: 27,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${Constants.revenue}',
                                style: contextTextTheme.subtitle2,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${Constants.rupeeSymbol} 6, 680',
                                style: contextTextTheme.headline6,
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
                                style: contextTextTheme.subtitle2,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '80',
                                style: contextTextTheme.headline6,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
