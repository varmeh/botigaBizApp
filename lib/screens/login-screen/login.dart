import 'package:flutter/material.dart';
import '../home-screen/home.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
          child: Text("login"),
        ),
      ),
    ));
  }
}
