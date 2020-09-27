import 'package:flutter/material.dart';
import '../bussiness-details-screen/addBussinessDetails.dart';
import "../store-details-screen/storeDetails.dart";

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
            leading: Image.asset("assets/icons/suitcase.png"),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Business details",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
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
            leading: Image.asset("assets/icons/store_details.png"),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Store details",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          ),
          ListTile(
            leading: Image.asset("assets/icons/money.png"),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.3, 0),
              child: Text(
                "Payment Information",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Color(0xff121715),
              size: 20,
            ),
          ),
          ListTile(
            leading: Image.asset("assets/icons/exit.png"),
            contentPadding: EdgeInsets.only(left: 0, right: 0),
            title: Align(
              alignment: Alignment(-1.2, 0),
              child: Text(
                "Logout",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
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
