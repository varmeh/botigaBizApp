import 'package:flutter/material.dart';
import '../../util/constants.dart';
import '../../theme/index.dart' show BotigaIcons;
import '../../models/Orders/OrderByDateDetail.dart';

class OrderSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  OrderSummary(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${orderDetail.buyer.name}",
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Row(
            children: <Widget>[
              Icon(BotigaIcons.tag),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text('Order number: #${orderDetail.order.number}',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/clock.png'),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${orderDetail.order.orderDate}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Row(
            children: <Widget>[
              Icon(BotigaIcons.pin),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${orderDetail.buyer.house}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Row(
            children: <Widget>[
              Icon(
                BotigaIcons.truck,
                size: 26,
                color: Colors.black,
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${orderDetail.order.expectedDeliveryDate}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 44,
                  // width: 165,
                  child: FlatButton.icon(
                    icon: Icon(
                      BotigaIcons.call,
                      color: Colors.black,
                      size: 18,
                    ),
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Color(0xff121715).withOpacity(0.05),
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white,
                    highlightColor: Colors.orangeAccent,
                    label: Text(
                      'Call',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 13,
              ),
              Expanded(
                child: SizedBox(
                  height: 44,
                  // width: 165,
                  child: FlatButton.icon(
                    icon: Image.asset('assets/images/watsapp.png'),
                    onPressed: () {},
                    textColor: Colors.white,
                    color: Color(0xff121715).withOpacity(0.05),
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white,
                    highlightColor: Colors.orangeAccent,
                    label: Text(
                      'Whatsapp',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class OrderListSummary extends StatelessWidget {
  final OrderByDateDetail orderDetail;
  OrderListSummary(this.orderDetail);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
          child: Text(
            '${orderDetail.order.products.length} Items',
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: 0.2),
          ),
        ),
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        ),
        ...orderDetail.order.products.map((el) {
          return OrderListItem(el.name, el.price, el.quantity, el.unitInfo);
        }),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Divider(
            color: Theme.of(context).backgroundColor,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0, bottom: 0.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Total',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '${Constants.rupeeSymbol}${orderDetail.order.totalAmount}',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class OrderListItem extends StatelessWidget {
  final String name;
  final int price;
  final int quantity;
  final String unitInfo;
  OrderListItem(this.name, this.price, this.quantity, this.unitInfo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, bottom: 0.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '$quantity X $name',
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              '${Constants.rupeeSymbol}${quantity * price}',
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
