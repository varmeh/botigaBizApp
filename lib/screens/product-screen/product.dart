import 'package:flutter/material.dart';
import '../../util/constants.dart';
import 'package:flutter/cupertino.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 10,
      ),
      child: ListView(
        children: <Widget>[
          TextField(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            decoration: InputDecoration(
              fillColor: Theme.of(context).backgroundColor,
              filled: true,
              contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xff121715),
              ),
              hintText: "Search...",
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context)
        ],
      ),
    );
  }
}

Widget getTile(context) {
  final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent);
  return Column(
    children: <Widget>[
      Theme(
        data: theme,
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: ExpansionTile(
            title: RichText(
              text: TextSpan(
                text: '03 ',
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff121614).withOpacity(0.5),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ',
                    style: TextStyle(
                      letterSpacing: 20,
                    ),
                  ),
                  TextSpan(
                    text: 'DESERT',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff121714),
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Column(
                children: [
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: 0,
                    endIndent: 300,
                  ),
                  ProductItemRow(),
                  Divider(
                    color: Theme.of(context).backgroundColor,
                    thickness: 1,
                  ),
                  ProductItemRow(),
                  Divider(
                    color: Theme.of(context).backgroundColor,
                    thickness: 1,
                  ),
                  ProductItemRow(),
                  Divider(
                    color: Theme.of(context).backgroundColor,
                    thickness: 1,
                  ),
                  ProductItemRow()
                ],
              )
            ],
          ),
        ),
      ),
      Divider(
        color: Theme.of(context).backgroundColor,
        thickness: 1,
      ),
    ],
  );
}

class ProductItemRow extends StatefulWidget {
  @override
  _ProductItemRowState createState() => _ProductItemRowState();
}

class _ProductItemRowState extends State<ProductItemRow> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://www.spendwithpennies.com/wp-content/uploads/2015/10/Chocolate-Ganache-22.jpg')),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 12, top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Chocolate Ganache",
                            style: TextStyle(
                              color: Color(0xff121715),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _switchValue
                              ? Text(
                                  "Available",
                                  style: TextStyle(
                                    color: Color(0xff121715),
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  "Not Available",
                                  style: TextStyle(
                                    color: Color(0xff121715),
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '500 gms .${Constants.rupeeSymbol}120',
                              style: TextStyle(
                                color: Color(0xff121715).withOpacity(0.5),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Transform.scale(
                            alignment: Alignment.topRight,
                            scale: 0.75,
                            child: CupertinoSwitch(
                              value: _switchValue,
                              onChanged: (bool value) {
                                setState(
                                  () {
                                    _switchValue = value;
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Chocolate cream filled crispy waffles",
            style: TextStyle(
              color: Color(0xff121715),
              fontSize: 12,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
