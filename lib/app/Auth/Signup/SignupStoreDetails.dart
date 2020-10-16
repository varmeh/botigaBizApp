import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import '../../../providers/Profile/StoreProvider.dart';
import 'SetPin.dart';

class SignUpStoreDetails extends StatefulWidget {
  static const routeName = '/signup-store-detail';
  @override
  _SignUpStoreDetailsState createState() => _SignUpStoreDetailsState();
}

class _SignUpStoreDetailsState extends State<SignUpStoreDetails> {
  final _formKey = GlobalKey<FormState>();

  String email;

  String watsappNumber;

  int pincode;

  String buildingNumber;

  String streetName;

  String area;

  String city;

  String state;

  void handleStoreDetailSave(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider
        .updateStoreDetails(watsappNumber, watsappNumber, email, buildingNumber,
            streetName, area, city, state, pincode)
        .then((value) {
      Navigator.of(context)
          .pushNamed(SetPin.routeName, arguments: {'phone': watsappNumber});
    }).catchError((error) {
      //TODO: remove the navigation
      Navigator.of(context)
          .pushNamed(SetPin.routeName, arguments: {'phone': watsappNumber});
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Align(
            child: Text(
              'Store details',
              style: AppTheme.textStyle.color100.size(20).w500,
            ),
            alignment: Alignment.centerLeft,
          ),
          leading: IconButton(
            icon: Icon(
              BotigaIcons.arrowBack,
              color: AppTheme.color100,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0)),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          handleStoreDetailSave(context);
                        }
                      },
                      color: Color(0xff179F57),
                      child: Text(
                        'Save and continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Email cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => email = val,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Email",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Whatsapp number cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => watsappNumber = val,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.message),
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Whatsapp number",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Divider(
                      color: AppTheme.dividerColor,
                      thickness: 8,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "Store Address",
                                  style:
                                      AppTheme.textStyle.color100.size(15).w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Building No. / Flat No. cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => buildingNumber = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Building No. / Flat No.",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Street Name/Locality cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => streetName = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Street Name/Locality",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Area cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => area = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Area",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Pincode cannot be empty';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Pincode should be number';
                              }
                              return null;
                            },
                            onSaved: (val) => pincode = int.parse(val),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "Pincode",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'City cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => city = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "City",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'State cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => state = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.backgroundColor,
                                labelText: "State",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
