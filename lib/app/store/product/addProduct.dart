import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../providers/index.dart' show CategoryProvider, ProductProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/buttons/index.dart';
import '../../../widget/index.dart'
    show
        Toast,
        BotigaAppBar,
        BotigaBottomModal,
        BotigaTextFieldForm,
        LoaderOverlay;
import '../../home/index.dart' show HomeScreen;

class AddProduct extends StatefulWidget {
  static const routeName = 'add-product';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with TickerProviderStateMixin {
  TextEditingController _mrpController;
  GlobalKey<FormState> _formKey;

  bool _isInit;
  String _name;
  double _price;
  double _mrp;
  double _quantity;
  String _selectedQuantity;
  String _seletedCategory;
  String _seletedCategoryId;
  bool _switchValue;
  String _description;
  bool isSaving;

  FocusNode _nameFocusNode,
      _mrpFocusNode,
      _priceFocusNode,
      _quantityFocusNode,
      _descriptionFocusNode;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _mrpController = TextEditingController();

    _isInit = false;
    _switchValue = false;
    _selectedQuantity = 'kg';
    _seletedCategory = '';
    _seletedCategoryId = '';
    _name = '';
    _price = 0.0;
    _quantity = 0.0;
    _description = '';

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

  Widget addProductSuccessful() {
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
          'Product Added Successfuly',
          style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
        ),
        SizedBox(height: 64.0),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final firstCategories =
          Provider.of<CategoryProvider>(context, listen: true)
              .allCategories
              .first;
      if (firstCategories != null) {
        setState(() {
          _seletedCategory = firstCategories.name;
          _seletedCategoryId = firstCategories.id;
        });
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void showCategories() {
    List widgets = [];
    final categories =
        Provider.of<CategoryProvider>(context, listen: false).allCategories;
    for (final category in categories) {
      widgets.add(
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: AppTheme.textStyle.color100.w500.size(17),
                ),
                Radio(
                  activeColor: AppTheme.primaryColor,
                  value: category.name,
                  groupValue: _seletedCategory,
                  onChanged: (_) {
                    setState(() {
                      Navigator.of(context).pop();
                      _seletedCategory = category.name;
                      _seletedCategoryId = category.id;
                    });
                  },
                )
              ],
            ),
            Divider(
              color: AppTheme.dividerColor,
              thickness: 1.2,
            )
          ],
        ),
      );
    }
    BotigaBottomModal(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select category',
                    style: AppTheme.textStyle.color100.w700.size(22)),
                SizedBox(
                  height: 20,
                ),
                SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: ListView(
                      children: [...widgets],
                    ),
                  ),
                )
              ],
            ),
            isDismissible: true)
        .show(context);
  }

  void _handleProductSave() async {
    try {
      setState(() => isSaving = true);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.saveProduct(
          categoryId: _seletedCategoryId,
          name: _name,
          price: _price,
          quantity: _quantity,
          unit: _selectedQuantity,
          imageUrl: '',
          description: _description,
          mrp: _mrp,
          imageUrlLarge: '',
          secondaryImageUrls: []);
      await productProvider.fetchProducts();
      BotigaBottomModal(child: addProductSuccessful()).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const _sizedBox26 = SizedBox(height: 26);

    return LoaderOverlay(
      isLoading: isSaving,
      child: GestureDetector(
        onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: BotigaAppBar(
              'Add Product',
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                color: AppTheme.backgroundColor,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _handleProductSave();
                            }
                          },
                          child: Text(
                            'Add Product',
                            style: AppTheme.textStyle
                                .colored(AppTheme.backgroundColor)
                                .w600
                                .size(15),
                          ),
                        ),
                      ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BotigaTextFieldForm(
                              focusNode: _nameFocusNode,
                              labelText: 'Product name',
                              onSave: (value) => _name = value,
                              validator: emptyValidator,
                              nextFocusNode: _mrpFocusNode,
                            ),
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
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showCategories();
                                },
                                trailing: Icon(Icons.keyboard_arrow_down,
                                    color: AppTheme.color100),
                                title: _seletedCategory == ''
                                    ? Text(
                                        'Select Category',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      )
                                    : Text(
                                        '$_seletedCategory',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
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
                              icon: BotigaIcons.rupee,
                              iconSize: 14.0,
                              focusNode: _priceFocusNode,
                              labelText: 'Selling Price',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) => _price = double.parse(value),
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
                              focusNode: _quantityFocusNode,
                              labelText: 'Quantity',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) =>
                                  _quantity = double.parse(value),
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
                                          backgroundColor:
                                              _selectedQuantity == val
                                                  ? AppTheme.primaryColor
                                                  : AppTheme.dividerColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedQuantity = val;
                                          });
                                        },
                                        child: Text('$val',
                                            style: _selectedQuantity == val
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
                                handleSwitchChage: (bool value) {
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
                                maxLines: 3,
                                maxLength: 140,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                focusNode: _descriptionFocusNode,
                                labelText: 'Description',
                                onSave: (value) => _description = value,
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
}
