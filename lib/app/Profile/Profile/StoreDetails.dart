import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import '../../../providers/Profile/StoreProvider.dart';

class StoreDeatils extends StatefulWidget {
  static const routeName = '/add-store-details';
  @override
  _StoreDeatilsState createState() => _StoreDeatilsState();
}

class _StoreDeatilsState extends State<StoreDeatils> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = true;
  String email = '';
  String phoneNumber = '';
  String watsappNumber = '';
  String buildingNumber = '';
  String streetName = '';
  int pincode = 0;
  String city = '';
  String state = '';
  String area = '';

  void handleStoreDetailSave(BuildContext context) {
    String watsappNumberUpdated;
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    //For watsappnumber same as phone number
    if (checkedValue) {
      watsappNumberUpdated = phoneNumber;
    } else {
      watsappNumberUpdated = watsappNumber;
    }
    storeProvider
        .updateStoreDetails(phoneNumber, watsappNumberUpdated, email,
            buildingNumber, streetName, area, city, state, pincode)
        .then((value) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Color(0xff2591B2),
        messageText: Text(
          '${value['message']}',
          style:
              AppTheme.textStyle.colored(AppTheme.surfaceColor).w500.size(15),
        ),
        icon: Icon(BotigaIcons.truck, size: 30, color: AppTheme.surfaceColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style:
              AppTheme.textStyle.colored(AppTheme.surfaceColor).w500.size(15),
        ),
        icon: Icon(BotigaIcons.truck, size: 30, color: AppTheme.surfaceColor),
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
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final storeDetails = storeProvider.storeDetails;

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          handleStoreDetailSave(context);
                        }
                      },
                      color: AppTheme.primaryColor,
                      child: Text('Save details',
                          style: AppTheme.textStyle
                              .colored(AppTheme.surfaceColor)
                              .w600
                              .size(15)),
                    ),
                  ),
                ),
              ],
            )),
      ),
      appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
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
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.surfaceColor,
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
                                return 'Phone number cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => phoneNumber = val,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.surfaceColor,
                                labelText: "Phone number",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          !checkedValue
                              ? Column(children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Whatsapp number cannot be empty';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => watsappNumber = val,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(17.0),
                                        fillColor: AppTheme.surfaceColor,
                                        labelText: "Whatsapp number",
                                        labelStyle: AppTheme.textStyle
                                            .size(15)
                                            .w500
                                            .color25,
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ])
                              : SizedBox.shrink(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    checkedValue = !checkedValue;
                                  });
                                },
                                child: checkedValue
                                    ? Icon(
                                        Icons.check_box,
                                        color: AppTheme.primaryColor,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank,
                                        color: AppTheme.color100,
                                        size: 30,
                                      ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                    "Whatsapp number same as phone number above",
                                    style: AppTheme.textStyle.color100.w500
                                        .size(15)),
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
                                fillColor: AppTheme.surfaceColor,
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
                                fillColor: AppTheme.surfaceColor,
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
                                fillColor: AppTheme.surfaceColor,
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
                                fillColor: AppTheme.surfaceColor,
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
                                fillColor: AppTheme.surfaceColor,
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
                                fillColor: AppTheme.surfaceColor,
                                labelText: "State",
                                labelStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
