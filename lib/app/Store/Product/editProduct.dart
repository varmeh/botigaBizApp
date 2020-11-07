import 'dart:io';
import 'package:botiga_biz/widget/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../../../providers/index.dart' show ProductProvider, ServicesProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import '../../home/index.dart' show HomeScreen;
import '../../../models/store/index.dart';

class EditProduct extends StatefulWidget {
  final String productId;
  final String categoryId;
  final String categoryName;
  EditProduct({this.productId, this.categoryId, this.categoryName});
  static const routeName = 'edit-product';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct>
    with TickerProviderStateMixin {
  PickedFile _imageFile;
  ImagePicker _picker;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;
  GlobalKey<FormState> _formKey;
  bool _isInit;
  String _name;
  double _price;
  int _quantity;
  String _selectedUnit;
  String _seletedCategory;
  String _seletedCategoryId;
  String _productId;
  bool _switchValue;
  String _description;
  String uploadurl = '', downloadUrl = '', _imageUrl = '';
  bool isSaving;
  FocusNode _nameFocusNode,
      _priceFocusNode,
      _quantityFocusNode,
      _descriptionFocusNode;
  bool _available;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _picker = ImagePicker();

    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();
    _isInit = false;
    _nameFocusNode = FocusNode();
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
      this._getPreSignedUrl();
      loadInitialFormValue();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void loadInitialFormValue() {
    Product product = Provider.of<ProductProvider>(context, listen: false)
        .getProductById(widget.categoryId, widget.productId);
    if (product != null) {
      List productSpec = product.size.split(" ");
      setState(() {
        _productId = widget.productId;
        _seletedCategory = widget.categoryName;
        _seletedCategoryId = widget.categoryId;
        _imageUrl = product.imageUrl;
        _name = product.name;
        _price = double.parse(product.price.toString());
        _quantity = int.parse(productSpec.elementAt(0));
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
            _controller.duration = composition.duration * 3;
            _controller.reset();
            _controller.forward();
          },
        ),
        SizedBox(height: 42.0),
        Text(
          'Product updated Successfuly',
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
            _controller.duration = composition.duration * 3;
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

  void _getPreSignedUrl() async {
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedImageUrl();
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    }
  }

  void _handleImageUpload(PickedFile file) async {
    try {
      await Provider.of<ServicesProvider>(context, listen: false)
          .uploadImageToS3(uploadurl, file);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
      setState(() {
        _imageFile = null;
      });
    }
  }

  void showImageSelectOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Add image",
                  style: AppTheme.textStyle.color100.w700.size(22)),
              SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(Icons.camera_alt, color: AppTheme.color100),
                title: Text(
                  'Take photo',
                  style: AppTheme.textStyle.color100.w500.size(17),
                ),
              ),
              ListTile(
                onTap: () {
                  _onImageButtonPressed(ImageSource.gallery, context: context);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(
                  Icons.image,
                  color: AppTheme.color100,
                ),
                title: Text(
                  'Choose from gallery',
                  style: AppTheme.textStyle.color100.w500.size(17),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 335,
        maxHeight: 176,
        imageQuality: 20,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      this._handleImageUpload(pickedFile);
    } catch (e) {
      Toast(message: Http.message(e)).show(context);
    }
    Navigator.of(context).pop();
  }

  void _handleProductEdit() async {
    try {
      setState(() {
        isSaving = true;
      });
      final _productDescription = _switchValue == true ? _description : '';
      final updateImage = _imageFile != null ? true : false;
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      await productProvider.updateProduct(
          _seletedCategoryId,
          _productId,
          _name,
          _price,
          _quantity,
          _selectedUnit,
          downloadUrl,
          _productDescription,
          _available,
          updateImage);
      await productProvider.fetchProducts();
      BotigaBottomModal(child: editSuccessful()).show(context);
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  void _handleDelete() async {
    try {
      setState(() {
        isSaving = true;
      });
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
            'Edit Product',
            actions: [
              FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Delete product",
                            style: AppTheme.textStyle.color100.w600
                                .size(14)
                                .letterSpace(.02),
                          ),
                          content: Text(
                            "Are you sure you want to delete this product ?",
                            style: AppTheme.textStyle.color100.w500
                                .size(13)
                                .letterSpace(.02),
                          ),
                          actions: [
                            FlatButton(
                              child: Text(
                                "Yes",
                                style: AppTheme.textStyle.color100.w500
                                    .size(13)
                                    .letterSpace(.02),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _handleDelete();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "No",
                                style: AppTheme.textStyle.color100.w500
                                    .size(13)
                                    .letterSpace(.02),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text('Delete',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Theme.of(context).colorScheme.error)),
              )
            ],
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
                            _handleProductEdit();
                          }
                        },
                        color: AppTheme.primaryColor,
                        child: Text(
                          'Edit Product',
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
                                    Size(double.infinity, 176),
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 176,
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
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                showImageSelectOption(context);
                                              },
                                              child: Image.asset(
                                                'assets/images/image_edit.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                              },
                                              child: Image.asset(
                                                'assets/images/image_delete.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints.tight(
                                    Size(double.infinity, 176),
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      EditProductNetworkAvatar(
                                          imageUrl: _imageUrl),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                showImageSelectOption(context);
                                              },
                                              child: Image.asset(
                                                'assets/images/image_edit.png',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 26,
                          ),
                          BotigaTextFieldForm(
                              initialValue: _name,
                              focusNode: _nameFocusNode,
                              labelText: "Product name",
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
                          SizedBox(
                            height: 26,
                          ),
                          BotigaTextFieldForm(
                              initialValue: _price.toString(),
                              icon: BotigaIcons.rupee,
                              iconSize: 14.0,
                              focusNode: _priceFocusNode,
                              labelText: "Price",
                              keyboardType: TextInputType.number,
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
                            initialValue: _quantity.toString(),
                            focusNode: _quantityFocusNode,
                            labelText: "Quantity",
                            keyboardType: TextInputType.number,
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
                            ...["kg", "gms", "lt", "ml", "piece", "pieces"].map(
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
                                          _selectedUnit = val;
                                        });
                                      },
                                      color: _selectedUnit == val
                                          ? AppTheme.primaryColor
                                          : AppTheme.dividerColor,
                                      child: Text('$val',
                                          style: _selectedUnit == val
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
                              "Add description",
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
                              initialValue: _description,
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
