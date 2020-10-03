import 'package:flutter/material.dart';
import '../bussiness-details-screen/addBussinessDetails.dart';
import "../store-details-screen/storeDetails.dart";
import '../../theme/index.dart' show BotigaIcons;

class ProfileScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AddBussinessDetails.routeName);
            },
            leading: Icon(
              BotigaIcons.suitcase,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Business details",
                style: TextStyle(
                  color: Color(0xff121715),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(AddStoreDeatils.routeName);
            },
            leading: Image.asset("assets/images/store_details.png"),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Store details",
                style: TextStyle(
                  color: Color(0xff121715),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          ),
          ListTile(
            leading: Icon(
              BotigaIcons.money,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                "Payment Information",
                style: TextStyle(
                  color: Color(0xff121715),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          ),
          ListTile(
            leading: Icon(
              BotigaIcons.exit,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Color(0xff121715),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
