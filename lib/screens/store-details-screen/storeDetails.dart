import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';

class AddStoreDeatils extends StatefulWidget {
  static const routeName = '/add-store-details';
  @override
  _AddStoreDeatilsState createState() => _AddStoreDeatilsState();
}

class _AddStoreDeatilsState extends State<AddStoreDeatils> {
  bool checkedValue = true;
  @override
  Widget build(BuildContext context) {
    bool checkboxValue = true;
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
                      borderRadius: new BorderRadius.circular(6.0),
                    ),
                    onPressed: () {},
                    color: Color(0xff179F57),
                    child: Text(
                      'Save details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 20.0,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Email",
                            hintText: "Email",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Phone number",
                            hintText: "Phone number",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Whatsapp number",
                            hintText: "Whatsapp number",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: checkboxValue
                                  ? Icon(
                                      Icons.check_box,
                                      color: Color(0xff179F57),
                                      size: 30,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      color: Color(0xff121715),
                                      size: 30,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                "Whatsapp number same as phone number above",
                                style: TextStyle(
                                  color: Color(0xff121715),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Building No. / Flat No.",
                            hintText: "Building No. / Flat No.",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Street Name/Locality",
                            hintText: "Street Name/Locality",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Pincode",
                            hintText: "Pincode",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "City",
                            hintText: "City",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "State",
                            hintText: "State",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 69,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
