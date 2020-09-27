import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ListView(
        children: <Widget>[
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context),
          getTile(context),
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
  return Column(
    children: <Widget>[
      ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
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
        trailing: Icon(Icons.delete_outline),
      ),
      Divider(
        color: Theme.of(context).backgroundColor,
        thickness: 1,
      ),
    ],
  );
}
