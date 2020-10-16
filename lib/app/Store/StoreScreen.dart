import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import '../../theme/index.dart';
import '../../util/index.dart';
import './Categories/category.dart';
import './Product/product.dart';
import 'Product/addProduct.dart';
import '../../providers/Store/Category/CategoryProvider.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = '/store-screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int slelectedTab = 0;

  void _handleCategorySave(BuildContext context, String name) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.saveCategory(name).then((value) {
      Navigator.of(context).pop();
      Flushbar(
        maxWidth: 335,
        backgroundColor: Color(0xff2591B2),
        messageText: Text(
          '$value',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    }).catchError((error) {
      Navigator.of(context).pop();
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style: AppTheme.textStyle
              .colored(AppTheme.backgroundColor)
              .w500
              .size(15),
        ),
        icon:
            Icon(BotigaIcons.truck, size: 30, color: AppTheme.backgroundColor),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 32.0),
          child: FloatingActionButton.extended(
            backgroundColor: AppTheme.backgroundColor,
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
                final _formKey = GlobalKey<FormState>();
                String name;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
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
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Category name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (val) => name = val,
                              decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: const EdgeInsets.all(17.0),
                                  fillColor: AppTheme.dividerColor,
                                  hintText: "Category name",
                                  hintStyle:
                                      AppTheme.textStyle.size(15).w500.color25,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(8.0),
                                    ),
                                  )),
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
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14, bottom: 14),
                                    child: Text('Cancel',
                                        style: AppTheme.textStyle.color50.w600
                                            .size(15)),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _handleCategorySave(context, name);
                                    }
                                  },
                                  color: AppTheme.primaryColor,
                                  highlightColor: AppTheme.primaryColorVariant,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14, bottom: 14),
                                    child: Text('Save category',
                                        style: AppTheme.textStyle
                                            .colored(AppTheme.backgroundColor)
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
          backgroundColor: AppTheme.backgroundColor,
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
