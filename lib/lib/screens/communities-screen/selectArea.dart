import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import "./selectCommunites.dart";

class SelectArea extends StatefulWidget {
  static const routeName = '/select-area';
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            AppHeader(
              title: "Select Area",
              actionWidget: SizedBox.shrink(),
            ),
            SizedBox(
              height: 20,
            ),
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
                  // borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  // borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            getTile("Jayanagar", context),
            getTile("Basavanagudi", context),
            getTile("Jayanagar", context),
            getTile("Basavanagudi", context),
            getTile("Jayanagar", context),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 92,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Color(0xffFDF6EC),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "STAY TUNED",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "We are adding new location every week",
                    style: TextStyle(
                      color: Color(0xff815B23),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget getTile(String txt, BuildContext context) {
  return ListTile(
    onTap: () {
      Navigator.of(context).pushNamed(SelectCommunites.routeName);
    },
    contentPadding: EdgeInsets.only(left: 0, right: 0),
    title: Text(
      txt,
      style: TextStyle(
        color: Color(0xff121715),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
