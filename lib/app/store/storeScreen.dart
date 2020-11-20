import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/index.dart';
import '../../widget/index.dart';
import '../../util/index.dart';
import '../../providers/index.dart' show CategoryProvider, ProductProvider;
import './index.dart';

class StoreScreen extends StatefulWidget {
  static const routeName = 'store-screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  int slelectedTab = 0;
  bool _isLoading = false;
  bool _isError = false;
  bool _isInit = false;
  var _error;
  bool isSavingCategory = false;
  TabController _controller;
  List<String> tabList = ['Products', 'Categories'];

  FocusNode _categoryNameFocusNode;

  @override
  void initState() {
    super.initState();
    _categoryNameFocusNode = FocusNode();
    _controller = TabController(length: tabList.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        slelectedTab = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _categoryNameFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _fetchStoreData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _fetchStoreData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    if (!productProvider.hasProducts || !categoryProvider.hasCategories) {
      try {
        setState(() {
          _isLoading = true;
          _isError = false;
          _error = null;
        });
        await productProvider.fetchProducts();
        await categoryProvider.fetchCategories();
      } catch (err) {
        setState(() {
          _isError = true;
          _error = err;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleCategorySave(String name) async {
    try {
      setState(() {
        isSavingCategory = true;
      });
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await categoryProvider.saveCategory(name);
      await productProvider.fetchProducts();
      await categoryProvider.fetchCategories();
      Navigator.of(context).pop();
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() {
        isSavingCategory = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loader()
        : _isError
            ? HttpExceptionWidget(
                exception: _error,
                onTap: () {
                  _fetchStoreData();
                },
              )
            : LoaderOverlay(
                isLoading: isSavingCategory,
                child: Scaffold(
                  backgroundColor: AppTheme.backgroundColor,
                  floatingActionButton: _floatingButton(context),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: AppTheme.backgroundColor,
                    brightness: Brightness.light,
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
                              controller: _controller,
                              labelStyle: AppTheme.textStyle.w700.size(22.0),
                              labelColor: AppTheme.color100,
                              unselectedLabelColor: AppTheme.color25,
                              isScrollable: true,
                              labelPadding: EdgeInsets.only(left: 0, right: 0),
                              indicatorColor: Colors.transparent,
                              tabs: tabList
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
                    controller: _controller,
                    children: [
                      Products(),
                      Category(),
                    ],
                  ),
                ),
              );
  }

  Widget _floatingButton(BuildContext context) {
    final bool hasCategories =
        Provider.of<CategoryProvider>(context, listen: true)
                .allCategories
                .length >
            0;
    return (slelectedTab == 0 && !hasCategories)
        ? SizedBox.shrink()
        : Container(
            padding: EdgeInsets.only(bottom: 32.0),
            child: FloatingActionButton.extended(
              backgroundColor: AppTheme.backgroundColor,
              elevation: 4.0,
              icon: const Icon(Icons.add, color: Color(0xff179F57)),
              label: slelectedTab == 0
                  ? Text('ADD PRODUCT',
                      style: AppTheme.textStyle
                          .colored(AppTheme.primaryColor)
                          .w700
                          .size(12)
                          .letterSpace(1))
                  : Text(
                      'ADD CATEGORY',
                      style: AppTheme.textStyle
                          .colored(AppTheme.primaryColor)
                          .w700
                          .size(12)
                          .letterSpace(1),
                    ),
              onPressed: () {
                if (slelectedTab == 1) {
                  final _formKey = GlobalKey<FormState>();
                  String _categoryName = '';
                  BotigaBottomModal(
                    isDismissible: false,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Add category',
                                  style:
                                      AppTheme.textStyle.color100.w700.size(22),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                BotigaTextFieldForm(
                                  focusNode: _categoryNameFocusNode,
                                  labelText: 'Category name',
                                  onSave: (value) => _categoryName = value,
                                  validator: nameValidator,
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
                                            style: AppTheme
                                                .textStyle.color50.w600
                                                .size(15)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          _handleCategorySave(_categoryName);
                                        }
                                      },
                                      color: AppTheme.primaryColor,
                                      highlightColor:
                                          AppTheme.primaryColorVariant,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, bottom: 14),
                                        child: Text('Save category',
                                            style: AppTheme.textStyle
                                                .colored(
                                                    AppTheme.backgroundColor)
                                                .w600
                                                .size(15)),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).show(context);
                } else {
                  Navigator.of(context).pushNamed(AddProduct.routeName);
                }
              },
            ),
          );
  }
}
