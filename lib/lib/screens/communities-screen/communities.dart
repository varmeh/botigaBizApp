import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Communities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ListView(
        children: <Widget>[
          CommunityTile("Prestige seaside"),
          CommunityTile("Nature nest"),
          CommunityTile("Nature nest"),
          CommunityTile("Tata Santoni"),
        ],
      ),
    );
  }
}

class CommunityTile extends StatefulWidget {
  final String title;
  CommunityTile(this.title);
  @override
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            widget.title,
            style: TextStyle(
              color: Color(0xff121715),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.75,
            child: CupertinoSwitch(
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        )
      ],
    );
  }
}
