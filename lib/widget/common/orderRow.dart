import 'package:flutter/material.dart';
import '../../util/constants.dart';

class OrderRow extends StatelessWidget {
  final Function tapHandler;
  OrderRow(this.tapHandler);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        this.tapHandler();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 15.0,
              left: 24,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "#1234128 .8 ITEMS",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        wordSpacing: 1,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffE9A136),
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      padding:
                          EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
                      child: Text(
                        "OPEN",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "31 Aug, 2020 8:10 AM",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      '${Constants.rupeeSymbol} 460',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
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
        ],
      ),
    );
  }
}
