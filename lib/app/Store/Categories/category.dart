import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/FormValidators.dart';
import '../../../widget/index.dart';
import '../../../models/Store/Category/StoreCategory.dart';
import '../../../providers/index.dart' show CategoryProvider, ProductProvider;

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _isProcessing = false;

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
      Toast(message: '$error', iconData: Icons.error_outline).show(context);
    } finally {
      setState(() {
        _isProcessing = false;
      });
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
}

Widget getTile(BuildContext context, StoreCategory category, Function setStatus,
    Function handleCategoryEdit) {
  final productProvider = Provider.of<ProductProvider>(context, listen: true);
  final productCount = productProvider.productCountForCategory(category.id);
  final countDispaly = productCount < 10 ? '0$productCount' : productCount;
  return Column(
    children: <Widget>[
      ListTile(
        onTap: () {
          final _formKey = GlobalKey<FormState>();
          FocusNode _categoryNameFocusNode = FocusNode();
          String _categoryName = category.name;
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
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Edit category",
                        style: AppTheme.textStyle.color100.w700.size(22),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      BotigaTextFieldForm(
                        initialValue: _categoryName,
                        focusNode: _categoryNameFocusNode,
                        labelText: "Category name",
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
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 14),
                              child: Text('Cancel',
                                  style:
                                      AppTheme.textStyle.color50.w600.size(15)),
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
                                handleCategoryEdit(category.id, _categoryName);
                              }
                            },
                            color: AppTheme.primaryColor,
                            highlightColor: AppTheme.primaryColorVariant,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 14, bottom: 14),
                              child: Text('Edit category',
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
              TextSpan(
                text: '${category.name.toUpperCase()}',
                style: AppTheme.textStyle.color100.w600.size(12).letterSpace(1),
              ),
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
                onTap: () async {
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
                    Toast(message: '$err', iconData: Icons.error_outline_sharp)
                        .show(context);
                  } finally {
                    setStatus(false);
                  }
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
