import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import './SignUpSetPin.dart';

class SignUpStoreDetails extends StatefulWidget {
  static const routeName = '/signup-store-detail';
  @override
  _SignUpStoreDetailsState createState() => _SignUpStoreDetailsState();
}

class _SignUpStoreDetailsState extends State<SignUpStoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
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
                      Navigator.of(context).pushNamed(SignUpSetPin.routeName);
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
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppHeader(
                          title: "Store details",
                          actionWidget: InkWell(
                            onTap: () {
                              debugPrint('I am Awesome');
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Email",
                                hintText: "Email",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.message),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Whatsapp number",
                                hintText: "Whatsapp number",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 32),
                  child: Divider(
                    color: Theme.of(context).backgroundColor,
                    thickness: 8,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20.0),
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
                                style: TextStyle(
                                    color: Color(0xff121715),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
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
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Building No. / Flat No.",
                                hintText: "Building No. / Flat No.",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Street Name/Locality",
                                hintText: "Street Name/Locality",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Pincode",
                                hintText: "Pincode",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "City",
                                hintText: "City",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                            onSaved: (val) => '',
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "State",
                                hintText: "State",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 69,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
