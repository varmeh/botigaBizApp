import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import '../../widget/common/orderSummary.dart';

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
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                      onPressed: () {},
                      textColor: Colors.red,
                      color: Color(0xff179F57),
                      child: Text(
                        'Mark as delivered',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xffDA3030),
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
