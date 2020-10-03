import 'package:flutter/material.dart';
import './SignupVerifyOtp.dart';

class SignupWelcome extends StatefulWidget {
  static const routeName = '/signup-welcome';
  @override
  _SignupWelcomeState createState() => _SignupWelcomeState();
}

class _SignupWelcomeState extends State<SignupWelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Color(0xff179F57),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  top: 70, bottom: 60, left: 20, right: 20),
              child: Text(
                "Welcome to Botiga",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: Color(0xffFFFFFF)),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 22, right: 22, top: 32),
                decoration: new BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(32.0),
                    topRight: const Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          onSaved: (val) => '',
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone),
                              // hasFloatingPlaceholder: true,
                              fillColor: Colors.white,
                              filled: true,
                              // labelText: "Phone number",
                              hintText: "Phone number",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder())),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0)),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignUpOtp.routeName);
                            },
                            color: Color(0xff179F57),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 18, bottom: 18),
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
