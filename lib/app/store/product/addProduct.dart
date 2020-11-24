import 'dart:io';
import 'package:botiga_biz/widget/buttons/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../providers/index.dart'
    show CategoryProvider, ProductProvider, ServicesProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../home/index.dart' show HomeScreen;
import '../../../widget/index.dart'
    show
        Toast,
        BotigaAppBar,
        BotigaBottomModal,
        BotigaTextFieldForm,
        LoaderOverlay,
        ImageSelectionWidget;

class AddProduct extends StatefulWidget {
  static const routeName = 'add-product';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with TickerProviderStateMixin {
  PickedFile _imageFile;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;

  GlobalKey<FormState> _formKey;

  bool _isInit;
  String _name;
  double _price;
  int _quantity;
  String _selectedQuantity;
  String _seletedCategory;
  String _seletedCategoryId;
  bool _switchValue;
  String _description;
  String uploadurl = '', downloadUrl = '';
  bool isSaving;

  FocusNode _nameFocusNode,
      _priceFocusNode,
      _quantityFocusNode,
      _descriptionFocusNode;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();

    _isInit = false;
    _switchValue = false;
    _selectedQuantity = 'kg';
    _seletedCategory = '';
    _seletedCategoryId = '';
    _name = '';
    _price = 0.0;
    _quantity = 0;
    _description = '';

    _nameFocusNode = FocusNode();
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

    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();

    _nameFocusNode.dispose();
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
      this._getPreSignedUrl();
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

  void _getPreSignedUrl() async {
    try {
      setState(() {
        isSaving = true;
      });
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedImageUrl();
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  void _handleImageUpload(PickedFile file) async {
    try {
      setState(() {
        isSaving = true;
      });
      await Provider.of<ServicesProvider>(context, listen: false)
          .uploadImageToS3(uploadurl, file);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
      setState(() {
        _imageFile = null;
      });
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  void showCategories() {
    List<Widget> widgets = [];
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
              children: <Widget>[
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

  void showImageSelectOption(BuildContext context) {
    ImageSelectionWidget(
      width: 180,
      height: 135,
      imageQuality: 100,
      onImageSelection: (imageFile) {
        setState(() {
          _imageFile = imageFile;
        });
        this._handleImageUpload(imageFile);
      },
    ).show(context);
  }

  void _handleProductSave() async {
    try {
      setState(() {
        isSaving = true;
      });
      final saveImageUrl = _imageFile != null ? downloadUrl : '';
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.saveProduct(_seletedCategoryId, _name, _price,
          _quantity, _selectedQuantity, saveImageUrl, _description);
      await productProvider.fetchProducts();
      BotigaBottomModal(child: addProductSuccessful()).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  void _handleImageDelete() async {
    try {
      setState(() {
        isSaving = true;
      });
      await Provider.of<ServicesProvider>(context, listen: false)
          .deleteImageFromS3(downloadUrl);
      setState(() {
        _imageFile = null;
      });
    } catch (err) {
      Toast(message: "Unable to delete image").show(context);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: isSaving,
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
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            _handleProductSave();
                          }
                        },
                        color: AppTheme.primaryColor,
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
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _imageFile != null
                              ? ConstrainedBox(
                                  constraints: BoxConstraints.tight(
                                    Size(double.infinity, 135),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 135,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          child: Image.file(
                                            File(_imageFile.path),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            PassiveButton(
                                              title: "Change",
                                              onPressed: () {
                                                showImageSelectOption(context);
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: AppTheme.color100,
                                                size: 17,
                                              ),
                                              height: 44,
                                              width: 135,
                                            ),
                                            PassiveButton(
                                              title: "Remove",
                                              onPressed: () {
                                                _handleImageDelete();
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: AppTheme.color100,
                                                size: 17,
                                              ),
                                              height: 44,
                                              width: 135,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 176,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      style: BorderStyle.solid,
                                      color:
                                          AppTheme.color100.withOpacity(0.25),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton.icon(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20,
                                            top: 14,
                                            bottom: 14,
                                          ),
                                          child: Icon(BotigaIcons.gallery,
                                              size: 18),
                                        ),
                                        onPressed: () {
                                          showImageSelectOption(context);
                                        },
                                        color: Colors.black.withOpacity(0.05),
                                        label: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 20,
                                            top: 14,
                                            bottom: 14,
                                            left: 8,
                                          ),
                                          child: Text('Add image',
                                              style: AppTheme
                                                  .textStyle.color100.w500
                                                  .size(15)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 55, right: 55, top: 16),
                                        child: Text(
                                          'Adding image will increase people interest in your product',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.textStyle.color50.w400
                                              .size(12)
                                              .letterSpace(0.2)
                                              .lineHeight(1.5),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 55,
                                            right: 55,
                                            top: 8,
                                            bottom: 10),
                                        child: Text(
                                          '*Upload Landscape Image',
                                          textAlign: TextAlign.center,
                                          style: AppTheme
                                              .textStyle.color100.w500
                                              .size(12)
                                              .letterSpace(0.2)
                                              .lineHeight(1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 26,
                          ),
                          BotigaTextFieldForm(
                              focusNode: _nameFocusNode,
                              labelText: 'Product name',
                              onSave: (value) => _name = value,
                              validator: nameValidator,
                              nextFocusNode: _priceFocusNode),
                          SizedBox(
                            height: 26,
                          ),
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
                          SizedBox(
                            height: 26,
                          ),
                          BotigaTextFieldForm(
                              icon: BotigaIcons.rupee,
                              iconSize: 14.0,
                              focusNode: _priceFocusNode,
                              labelText: 'Price',
                              keyboardType: TextInputType.datetime,
                              onSave: (value) => _price = double.parse(value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                } else if (double.tryParse(value) == null) {
                                  return 'Please use numbers for price';
                                }
                                return null;
                              },
                              nextFocusNode: _quantityFocusNode),
                          SizedBox(
                            height: 26,
                          ),
                          BotigaTextFieldForm(
                            focusNode: _quantityFocusNode,
                            labelText: 'Quantity',
                            keyboardType: TextInputType.datetime,
                            onSave: (value) => _quantity = int.parse(value),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Required';
                              } else if (int.tryParse(value) == null) {
                                return 'Please use numbers for quantity';
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
                          children: <Widget>[
                            ...['kg', 'gms', 'lt', 'ml', 'piece', 'pieces'].map(
                              (val) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Container(
                                    height: 44,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _selectedQuantity = val;
                                        });
                                      },
                                      color: _selectedQuantity == val
                                          ? AppTheme.primaryColor
                                          : AppTheme.dividerColor,
                                      child: Text('$val',
                                          style: _selectedQuantity == val
                                              ? AppTheme.textStyle
                                                  .size(13)
                                                  .lineHeight(1.5)
                                                  .w600
                                                  .colored(
                                                      AppTheme.backgroundColor)
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
                          children: <Widget>[
                            Text(
                              'Add description',
                              style: AppTheme.textStyle.size(15).w500.color100,
                            ),
                            Transform.scale(
                              alignment: Alignment.centerLeft,
                              scale: 0.75,
                              child: CupertinoSwitch(
                                value: _switchValue,
                                onChanged: (bool value) {
                                  setState(() {
                                    _switchValue = value;
                                  });
                                  _descriptionFocusNode.requestFocus();
                                },
                              ),
                            )
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
                              maxLength: 80,
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
    );
  }
}
