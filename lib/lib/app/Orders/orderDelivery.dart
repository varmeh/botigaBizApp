import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import 'orderSummary.dart';

class OrderDelivery extends StatefulWidget {
  static const routeName = '/order-delivery';
  @override
  _OrderDeliveryState createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: () {},
                      textColor: Colors.red,
                      color: Color(0xff179F57),
                      child: Text(
                        'Mark as delivered',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
                          'Cancel order',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.error,
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
              OrderListSummary(),
            ],
          ),
        ));
  }
}
