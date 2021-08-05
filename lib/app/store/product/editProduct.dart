import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/store/index.dart';
import '../../../providers/index.dart' show ProductProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart'
    show
        Toast,
        BotigaAppBar,
        BotigaBottomModal,
        BotigaTextFieldForm,
        LoaderOverlay,
        ActiveButton,
        PassiveButton,
        BotigaSwitch;
import '../../home/index.dart' show HomeScreen;

class EditProduct extends StatefulWidget {
  final String productId;
  final String categoryId;
  final String categoryName;

  EditProduct({
    this.productId,
    this.categoryId,
    this.categoryName,
  });

  static const routeName = 'edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct>
    with TickerProviderStateMixin {
  TextEditingController _mrpController;

  GlobalKey<FormState> _formKey;
  bool _isInit;
  String imageUrl;
  String _name;
  double _price;
  double _mrp;
  double _quantity;
  String _selectedUnit;
  String _seletedCategory;
  String _seletedCategoryId;
  String _productId;
  bool _switchValue;
  String _description;
  bool isSaving;
  FocusNode _nameFocusNode,
      _mrpFocusNode,
      _priceFocusNode,
      _quantityFocusNode,
      _descriptionFocusNode;
  bool _available;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _mrpController = TextEditingController();

    _isInit = false;
    _nameFocusNode = FocusNode();
    _mrpFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    isSaving = false;
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadTabbarAfterAnimationCompletion);
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      loadInitialFormValue();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadTabbarAfterAnimationCompletion);
    _controller.dispose();
    _mrpController.dispose();

    _nameFocusNode.dispose();
    _mrpFocusNode.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizedBox26 = SizedBox(height: 26);

    return LoaderOverlay(
      isLoading: isSaving,
      child: GestureDetector(
        onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: BotigaAppBar(
              'Update Product',
              actions: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Delete product',
                            style: AppTheme.textStyle.w500.color100,
                          ),
                          content: Text(
                            'Are you sure you want to delete this product?',
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
                                _handleDelete();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Delete',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                )
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                color: AppTheme.backgroundColor,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 52,
                          child: this.isFormEdited()
                              ? ActiveButton(
                                  title: 'Update',
                                  onPressed: () {
                                    if (this.isFormEdited() &&
                                        _formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _handleProductEdit();
                                    }
                                  })
                              : PassiveButton(
                                  title: 'Update', onPressed: () {})),
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BotigaTextFieldForm(
                                initialValue: _name,
                                focusNode: _nameFocusNode,
                                labelText: 'Product name',
                                onSave: (value) => _name = value,
                                onChange: (_) => handleFormChange(),
                                validator: emptyValidator,
                                nextFocusNode: _priceFocusNode),
                            _sizedBox26,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.5),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: AppTheme.color25,
                                  width: 1.0,
                                ),
                              ),
                              child: ListTile(
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -1),
                                tileColor: AppTheme.color05,
                                trailing: Icon(Icons.keyboard_arrow_down,
                                    color: AppTheme.color100),
                                title: Text(
                                  '$_seletedCategory',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                ),
                              ),
                            ),
                            _sizedBox26,
                            BotigaTextFieldForm(
                              icon: BotigaIcons.rupee,
                              iconSize: 14.0,
                              focusNode: _mrpFocusNode,
                              textEditingController: _mrpController,
                              labelText: 'MRP (Optional)',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) {
                                if (value.isNotEmpty &&
                                    double.tryParse(value) != null) {
                                  _mrp = double.parse(value);
                                }
                              },
                              onChange: (_) => handleFormChange(),
                              validator: (value) {
                                if (value.isNotEmpty &&
                                    double.tryParse(value) == null) {
                                  return 'Please use numbers for price';
                                }
                                return null;
                              },
                              nextFocusNode: _priceFocusNode,
                            ),
                            _sizedBox26,
                            BotigaTextFieldForm(
                              initialValue: _price.toString(),
                              icon: BotigaIcons.rupee,
                              iconSize: 14.0,
                              focusNode: _priceFocusNode,
                              labelText: 'Price',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) => _price = double.parse(value),
                              onChange: (_) => handleFormChange(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                } else if (double.tryParse(value) == null) {
                                  return 'Please use numbers for price';
                                } else if (_mrpController.text.isNotEmpty &&
                                    double.tryParse(_mrpController.text) !=
                                        null &&
                                    double.parse(_mrpController.text) <=
                                        double.tryParse(value)) {
                                  return 'Selling Price should be lower than MRP';
                                }
                                return null;
                              },
                              nextFocusNode: _quantityFocusNode,
                            ),
                            _sizedBox26,
                            BotigaTextFieldForm(
                              initialValue: _quantity.toString(),
                              focusNode: _quantityFocusNode,
                              labelText: 'Quantity',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) =>
                                  _quantity = double.parse(value),
                              onChange: (_) => handleFormChange(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                } else if (double.tryParse(value) == null) {
                                  return 'Please use numbers for price';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 17, bottom: 17),
                        child: Container(
                          height: 44,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...['kg', 'gms', 'lt', 'ml', 'piece', 'pieces']
                                  .map(
                                (val) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Container(
                                      height: 44,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          backgroundColor: _selectedUnit == val
                                              ? AppTheme.primaryColor
                                              : AppTheme.dividerColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedUnit = val;
                                          });
                                        },
                                        child: Text('$val',
                                            style: _selectedUnit == val
                                                ? AppTheme.textStyle
                                                    .size(13)
                                                    .lineHeight(1.5)
                                                    .w600
                                                    .colored(AppTheme
                                                        .backgroundColor)
                                                : AppTheme.textStyle.color100
                                                    .size(13)
                                                    .lineHeight(1.5)
                                                    .w600),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add description',
                                style:
                                    AppTheme.textStyle.size(15).w500.color100,
                              ),
                              BotigaSwitch(
                                handleSwitchChange: (bool value) {
                                  setState(() {
                                    _switchValue = value;
                                  });
                                  _descriptionFocusNode.requestFocus();
                                },
                                switchValue: _switchValue,
                                alignment: Alignment.centerLeft,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _switchValue == true
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 15, bottom: 15, top: 25),
                              child: BotigaTextFieldForm(
                                initialValue: _description,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 3,
                                maxLength: 140,
                                focusNode: _descriptionFocusNode,
                                labelText: 'Description',
                                onSave: (value) => _description = value,
                                onChange: (_) => handleFormChange(),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  void handleFormChange() {
    Future.delayed(const Duration(milliseconds: 5), () {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {});
      }
    });
  }

  bool isFormEdited() {
    bool isEdited = true;
    Product product = Provider.of<ProductProvider>(context, listen: false)
        .getProductById(widget.categoryId, widget.productId);
    if (product == null) {
      isEdited = false;
    } else {
      List productSpec = product.size.split(' ');
      double quantity = double.parse(productSpec.elementAt(0));
      String selectedUnit = productSpec.elementAt(1);
      String description = _switchValue ? _description : '';
      if (product.name == _name &&
          product.price == _price &&
          quantity == _quantity &&
          selectedUnit == _selectedUnit &&
          product.description == description &&
          product.mrp == _mrp) {
        isEdited = false;
      }
    }
    return isEdited;
  }

  void loadInitialFormValue() {
    Product product = Provider.of<ProductProvider>(context, listen: false)
        .getProductById(widget.categoryId, widget.productId);
    if (product != null) {
      List productSpec = product.size.split(' ');
      setState(() {
        _productId = widget.productId;
        _seletedCategory = widget.categoryName;
        _seletedCategoryId = widget.categoryId;
        imageUrl = product.imageUrl;
        _name = product.name;
        _price = double.parse(product.price.toString());
        if (product.mrp != null) {
          _mrpController.text =
              product.mrp.toString(); // used to set initial value of mrp
          _mrp = product.mrp; // used for validation in isFormEdited()
        }
        _quantity = double.parse(productSpec.elementAt(0));
        _selectedUnit = productSpec.elementAt(1);
        _switchValue =
            (product.description != '' && product.description != null)
                ? true
                : false;
        _description = product.description;
        _available = product.available;
      });
    }
  }

  void loadTabbarAfterAnimationCompletion(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(index: 1),
          transitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    }
  }

  Widget editSuccessful() {
    return Column(
      children: [
        Lottie.asset(
          'assets/lotties/checkSuccess.json',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration * 1;
            _controller.reset();
            _controller.forward();
          },
        ),
        SizedBox(height: 42.0),
        Text(
          'Product updated successfuly',
          textAlign: TextAlign.center,
          style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
        ),
        SizedBox(height: 64.0),
      ],
    );
  }

  Widget deleteSuccessful() {
    return Column(
      children: [
        Lottie.asset(
          'assets/lotties/checkSuccess.json',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration * 1;
            _controller.reset();
            _controller.forward();
          },
        ),
        SizedBox(height: 42.0),
        Text(
          'Product deleted Successfuly',
          style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
        ),
        SizedBox(height: 64.0),
      ],
    );
  }

  void _handleProductEdit() async {
    try {
      setState(() => isSaving = true);

      final _productDescription = _switchValue == true ? _description : '';
      Product product = Provider.of<ProductProvider>(context, listen: false)
          .getProductById(widget.categoryId, widget.productId);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      await productProvider.updateProduct(
          categoryId: _seletedCategoryId,
          productId: _productId,
          name: _name,
          price: _price,
          mrp: _mrp,
          quantity: _quantity,
          unit: _selectedUnit,
          imageUrl: product.imageUrl,
          description: _productDescription,
          availableStatus: _available,
          imageUrlLarge: product.imageUrlLarge,
          secondaryImageUrls: product.secondaryImageUrls);

      await productProvider.fetchProducts();
      BotigaBottomModal(child: editSuccessful()).show(context);
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _handleDelete() async {
    try {
      setState(() => isSaving = true);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.deleteProduct(
        _seletedCategoryId,
        _productId,
      );
      await productProvider.fetchProducts();
      BotigaBottomModal(child: deleteSuccessful()).show(context);
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => isSaving = false);
    }
  }
}
