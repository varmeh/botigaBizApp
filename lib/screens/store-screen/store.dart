import 'package:flutter/material.dart';
import "../category-screen/category.dart";
import "../product-screen/product.dart";
import '../add-product-screen/addProduct.dart';

class Store extends StatefulWidget {
  static const routeName = '/store-screen';
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int slelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 32.0),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            elevation: 4.0,
            icon: const Icon(Icons.add, color: Color(0xff179F57)),
            label: slelectedTab == 0
                ? Text(
                    'ADD PRODUCT',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff179F57),
                    ),
                  )
                : Text(
                    'ADD CATEGORY',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff179F57),
                    ),
                  ),
            onPressed: () {
              if (slelectedTab == 1) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Add category",
                            style: TextStyle(
                              color: Color(0xff121715),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          TextField(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.black.withOpacity(0.05),
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                              hintText: "Category name",
                              hintStyle: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                highlightColor: Colors.orangeAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
                                onPressed: () {
                                  debugPrint('add');
                                },
                                color: Color(0xff179F57),
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.white,
                                highlightColor: Colors.orangeAccent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, left: 16, right: 16),
                                  child: Text(
                                    'Save category',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.of(context).pushNamed(AddProduct.routeName);
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TabBar(
                    onTap: (int index) {
                      setState(() {
                        slelectedTab = index;
                      });
                    },
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    labelColor: Color(0xff121715),
                    unselectedLabelColor: Color(0xff000000).withOpacity(0.25),
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(left: 0, right: 0),
                    indicatorColor: Colors.transparent,
                    tabs: ["Products", "Categories"]
                        .map(
                          (label) => Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Tab(text: '$label'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Products(),
            Category(),
          ],
        ),
      ),
    );
  }
}
