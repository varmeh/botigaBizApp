import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import '../../../providers/index.dart' show CategoryProvider, ProductProvider;
import '../../../models/store/index.dart';
import '../../../theme/index.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _isProcessing = false;
  FocusNode _categoryNameFocusNode;

  @override
  void initState() {
    _categoryNameFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _categoryNameFocusNode.dispose();

    super.dispose();
  }

  void setStatus(bool status) {
    setState(() {
      _isProcessing = status;
    });
  }

  void _handleCategoryEdit(String categoryId, String name) async {
    try {
      setState(() {
        _isProcessing = true;
      });
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await categoryProvider.editCategory(categoryId, name);
      await categoryProvider.fetchCategories();
      await productProvider.fetchProducts();
      Navigator.of(context).pop();
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  _handleCategoryDelete(StoreCategory category) async {
    try {
      setStatus(true);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await categoryProvider.deleteCategory(category.id);
      await productProvider.fetchProducts();
      await categoryProvider.fetchCategories();
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<StoreCategory> categories =
        Provider.of<CategoryProvider>(context, listen: true).allCategories;
    return (categories.length == 0)
        ? BrandingTile(
            'Thriving communities, empowering people',
            'Made by awesome team of Botiga',
          )
        : LoaderOverlay(
            isLoading: _isProcessing,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  children: <Widget>[
                    ...categories.map((category) {
                      return getTile(context, category, this.setStatus,
                          this._handleCategoryEdit);
                    })
                  ],
                ),
              ),
            ),
          );
  }

  Widget getTile(BuildContext context, StoreCategory category,
      Function setStatus, Function handleCategoryEdit) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final productCount = productProvider.productCountForCategory(category.id);
    final countDispaly = productCount < 10 ? '0$productCount' : productCount;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            final _formKey = GlobalKey<FormState>();
            String _categoryName = category.name;
            BotigaBottomModal(
              isDismissible: true,
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
                            'Edit category',
                            style: AppTheme.textStyle.color100.w700.size(22),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          BotigaTextFieldForm(
                            initialValue: _categoryName,
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
                                    handleCategoryEdit(
                                        category.id, _categoryName);
                                  }
                                },
                                color: AppTheme.primaryColor,
                                highlightColor: AppTheme.primaryColorVariant,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14, bottom: 14),
                                  child: Text('Edit category',
                                      style: AppTheme.textStyle
                                          .colored(AppTheme.backgroundColor)
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
          },
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          title: RichText(
            text: TextSpan(
              text: '$countDispaly',
              style: AppTheme.textStyle.color50.w600.size(12).letterSpace(1),
              children: <TextSpan>[
                TextSpan(
                  text: ' ',
                  style: AppTheme.textStyle.letterSpace(20),
                ),
                ...productCount != 0
                    ? [
                        TextSpan(
                          text: '${category.name.toUpperCase()}',
                          style: AppTheme.textStyle.color50.w600
                              .size(12)
                              .letterSpace(1),
                        )
                      ]
                    : [
                        TextSpan(
                          text: '${category.name.toUpperCase()}',
                          style: AppTheme.textStyle.color100.w600
                              .size(12)
                              .letterSpace(1),
                        )
                      ],
              ],
            ),
          ),
          trailing: productCount != 0
              ? Icon(
                  Icons.delete_sharp,
                  color: AppTheme.color50,
                )
              : GestureDetector(
                  child: Icon(
                    Icons.delete_sharp,
                    color: AppTheme.color100,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Delete category',
                            style: AppTheme.textStyle.w500.color100,
                          ),
                          content: Text(
                            'Are you sure you want to delete this category ?',
                            style: AppTheme.textStyle.w400.color100,
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                'Don\'t Delete',
                                style: AppTheme.textStyle.w600.color50,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Confirm',
                                style: AppTheme.textStyle.w600
                                    .colored(AppTheme.errorColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                this._handleCategoryDelete(category);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
        ),
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
        ),
      ],
    );
  }
}
