import 'package:flutter/material.dart';
import '../home-screen/home.dart';

class SignupPinSuccessfull extends StatefulWidget {
  static const routeName = '/signup-setpin-success';
  @override
  _SignupPinSuccessfullState createState() => _SignupPinSuccessfullState();
}

class _SignupPinSuccessfullState extends State<SignupPinSuccessfull> {
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Home()));
                      },
                      color: Color(0xff179F57),
                      child: Text(
                        'Go to Store',
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
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 148, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  size: 150.0,
                  color: Color(0xff179F57),
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  "PIN Set successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
