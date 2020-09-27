import 'package:flutter/material.dart';

class AddProductSuccess extends StatelessWidget {
  static const routeName = '/add-product-success';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 148, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 100.0,
                color: Color(0xff179F57),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                "Product added successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
