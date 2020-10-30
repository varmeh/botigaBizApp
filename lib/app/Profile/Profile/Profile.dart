import 'package:botiga_biz/widget/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BussinessDetails.dart';
import 'StoreDetails.dart';
import '../../../providers/AuthProvider.dart';
import '../../../theme/index.dart';
import '../../Auth/Login/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isProcessing = false;

  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: isProcessing,
      child: SafeArea(
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(BussinessDetails.routeName);
                },
                leading: Icon(
                  BotigaIcons.suitcase,
                  color: AppTheme.color100,
                ),
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                title: Align(
                  alignment: Alignment(-1.2, 0),
                  child: Text("Business details",
                      style: AppTheme.textStyle.color100.size(15).w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.color100,
                  size: 20,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(StoreDeatils.routeName);
                },
                leading: Image.asset("assets/images/store_details.png"),
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                title: Align(
                  alignment: Alignment(-1.2, 0),
                  child: Text("Store details",
                      style: AppTheme.textStyle.color100.size(15).w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.color100,
                  size: 20,
                ),
              ),
              ListTile(
                leading: Icon(
                  BotigaIcons.money,
                  color: AppTheme.color100,
                ),
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                title: Align(
                  alignment: Alignment(-1.3, 0),
                  child: Text(
                    "Payment Information",
                    style: AppTheme.textStyle.color100.size(15).w500,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.color100,
                  size: 20,
                ),
              ),
              ListTile(
                onTap: () async {
                  try {
                    setState(() {
                      isProcessing = true;
                    });
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.routeName, (route) => false);
                  } catch (err) {
                    setState(() {
                      isProcessing = false;
                    });
                    Toast(message: '$err', iconData: Icons.error_outline)
                        .show(context);
                  }
                },
                leading: Icon(
                  BotigaIcons.exit,
                  color: AppTheme.color100,
                ),
                contentPadding: EdgeInsets.only(left: 0, right: 0),
                title: Align(
                  alignment: Alignment(-1.2, 0),
                  child: Text("Logout",
                      style: AppTheme.textStyle.color100.size(15).w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppTheme.color100,
                  size: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
