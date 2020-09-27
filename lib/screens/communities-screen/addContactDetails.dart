import 'package:flutter/material.dart';
import "./addCommunitesSuccess.dart";

class AddContactDetails extends StatefulWidget {
  @override
  _AddContactDetailsState createState() => _AddContactDetailsState();
}

class _AddContactDetailsState extends State<AddContactDetails> {
  bool checkedValue = true;
  @override
  Widget build(BuildContext context) {
    bool checkboxValue = true;
    return Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Contact Details',
                  style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Nature nest',
                  style: TextStyle(
                    color: Color(0xff121715).withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
                    labelText: "Contact name",
                    hintText: "Contact name",
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
              ],
            ),
          ),
          Container(
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
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (builder) {
                              return AddCommunitesSuccess();
                            },
                          );
                        },
                        color: Color(0xff179F57),
                        child: Text(
                          'Enable Community',
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
              ))
        ],
      ),
    );
  }
}
