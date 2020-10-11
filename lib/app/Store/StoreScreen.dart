import 'package:flutter/material.dart';
import '../../theme/index.dart';
import '../../util/index.dart';
import './Categories/category.dart';
import './Product/product.dart';
import '../../screens/add-product-screen/addProduct.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = '/store-screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int slelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.surfaceColor,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 32.0),
          child: FloatingActionButton.extended(
            backgroundColor: AppTheme.surfaceColor,
            elevation: 4.0,
            icon: const Icon(Icons.add, color: Color(0xff179F57)),
            label: slelectedTab == 0
                ? Text('${Constants.ADD_PRODUCT_BTN}',
                    style: AppTheme.textStyle
                        .colored(AppTheme.primaryColor)
                        .w700
                        .size(12)
                        .letterSpace(1))
                : Text(
                    '${Constants.ADD_CATEGORY_BTN}',
                    style: AppTheme.textStyle
                        .colored(AppTheme.primaryColor)
                        .w700
                        .size(12)
                        .letterSpace(1),
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
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.only(
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
                            style: AppTheme.textStyle.color100.w700.size(22),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          TextField(
                            style: AppTheme.textStyle.color100.w500.size(15),
                            decoration: InputDecoration(
                              fillColor: AppTheme.color50,
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                              hintText: "Category name",
                              hintStyle:
                                  AppTheme.textStyle.color50.w500.size(17),
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
                                highlightColor: AppTheme.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                  ),
                                  child: Text('Cancel',
                                      style: AppTheme.textStyle.color50.w600
                                          .size(15)),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onPressed: () {},
                                color: AppTheme.primaryColor,
                                highlightColor: AppTheme.primaryColorVariant,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, left: 16, right: 16),
                                  child: Text('Save category',
                                      style: AppTheme.textStyle
                                          .colored(AppTheme.surfaceColor)
                                          .w600
                                          .size(15)),
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
          backgroundColor: AppTheme.surfaceColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(11),
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
                    labelStyle: AppTheme.textStyle.w700.size(22.0),
                    labelColor: AppTheme.color100,
                    unselectedLabelColor: AppTheme.color25,
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(left: 0, right: 0),
                    indicatorColor: Colors.transparent,
                    tabs: Constants.STORE_TABS
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
