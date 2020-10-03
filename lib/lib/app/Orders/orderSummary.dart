import 'package:flutter/material.dart';
import '../../util/constants.dart';
import '../../theme/index.dart' show BotigaIcons;

class OrderSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Renuka Devi",
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
                child: Text('Order number: #1234128',
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
              Image.asset('assets/icons/clock.png'),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  '31 Aug, 2020 8:10 AM',
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
                  'No. 22, Block - A, West towers, Riverside apartments, Whitefield',
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
                  'Expected delivery 16 Sept',
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
                    icon: Image.asset('assets/icons/watsapp.png'),
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
            '3 Items',
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                letterSpacing: 0.2),
          ),
        ),
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        ),
        ...[1, 2, 3].map((el) {
          return OrderListItem();
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
                  '${Constants.rupeeSymbol}1020',
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
              '1 X English Bakewell Tart',
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
              '${Constants.rupeeSymbol}120',
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
