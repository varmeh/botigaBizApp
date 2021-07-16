import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/store/index.dart';
import '../../../providers/index.dart' show CategoryProvider, ProductProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool _isProcessing = false;
  FocusNode _categoryNameFocusNode;
  BotigaBottomModal _bottomModal;

  @override
  void initState() {
    _categoryNameFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _categoryNameFocusNode.dispose();
    _bottomModal = null;
    super.dispose();
  }

  void setStatus(bool status) {
    setState(() {
      _isProcessing = status;
    });
  }

  void _handleCategoryEdit(String categoryId, String name) async {
    try {
      _bottomModal.animation(true);
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
      _bottomModal.animation(false);
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

  _handleCateoryVisiblity(
      String categoryId, bool visible, Function onErr) async {
    try {
      setStatus(true);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      await categoryProvider.updateCategoryVisiblity(categoryId, visible);
      await categoryProvider.fetchCategories();
    } catch (err) {
      onErr();
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
                  children: [
                    ...categories.map((category) {
                      return getTile(
                          context,
                          category,
                          this.setStatus,
                          this._handleCategoryEdit,
                          this._handleCateoryVisiblity);
                    })
                  ],
                ),
              ),
            ),
          );
  }

  Widget getTile(
      BuildContext context,
      StoreCategory category,
      Function setStatus,
      Function handleCategoryEdit,
      Function _handleCateoryVisiblity) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final productCount = productProvider.productCountForCategory(category.id);
    final countDisplay = productCount < 10 ? '0$productCount' : productCount;
    return Column(
      children: [
        ListTile(
          onTap: () {
            final _formKey = GlobalKey<FormState>();
            String _categoryName = category.name;
            _bottomModal = BotigaBottomModal(
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
                        children: [
                          Text(
                            'Edit category',
                            style: AppTheme.textStyle.color100.w700.size(22),
                          ),
                          SizedBox(height: 24),
                          BotigaTextFieldForm(
                            maxLength: 24,
                            initialValue: _categoryName,
                            focusNode: _categoryNameFocusNode,
                            labelText: 'Category name',
                            onSave: (value) => _categoryName = value,
                            validator: nameValidator,
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
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
                              TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    handleCategoryEdit(
                                        category.id, _categoryName);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 14,
                                    bottom: 14,
                                  ),
                                  child: Text(
                                    'Edit category',
                                    style: AppTheme.textStyle
                                        .colored(AppTheme.backgroundColor)
                                        .w600
                                        .size(15),
                                  ),
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
            );
            _bottomModal.show(context);
          },
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          title: RichText(
            text: TextSpan(
              text: '$countDisplay',
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
              ? CategoryAvailiblitySwitch(
                  category: category,
                  handleCateoryVisiblity: _handleCateoryVisiblity,
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
                            TextButton(
                              child: Text(
                                'Don\'t Delete',
                                style: AppTheme.textStyle.w600.color50,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
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

class CategoryAvailiblitySwitch extends StatefulWidget {
  final StoreCategory category;
  final Function handleCateoryVisiblity;

  CategoryAvailiblitySwitch(
      {@required this.category, @required this.handleCateoryVisiblity});

  @override
  _CategoryAvailiblitySwitchState createState() =>
      _CategoryAvailiblitySwitchState();
}

class _CategoryAvailiblitySwitchState extends State<CategoryAvailiblitySwitch> {
  bool visiblity = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      visiblity = widget.category.visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    String statusText = visiblity ? 'Visible' : 'Not Visible';
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            statusText,
            textAlign: TextAlign.right,
            style: AppTheme.textStyle.color50.w500.size(12).letterSpace(0.5),
          ),
        ),
        BotigaSwitch(
          scale: 0.65,
          handleSwitchChage: (bool value) {
            setState(() => visiblity = value);
            widget.handleCateoryVisiblity(widget.category.id, value, () {
              setState(() => visiblity = !value);
            });
          },
          switchValue: visiblity,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }
}
