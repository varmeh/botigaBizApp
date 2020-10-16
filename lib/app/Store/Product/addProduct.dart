import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flushbar/flushbar.dart';
import '../../../providers/Store/Category/CategoryProvider.dart';
import '../../../providers/Store/Product/ProductProvider.dart';
import '../../../theme/index.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/add-product';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _switchValue = false;
  String selectedQuantity = 'Kg';
  String seletedCategory = '';
  String seletedCategoryId = '';
  String name;
  double price;
  int quantity;
  String description;

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
                  value: category.name,
                  groupValue: seletedCategory,
                  onChanged: (_) {
                    setState(() {
                      Navigator.of(context).pop();
                      seletedCategory = category.name;
                      seletedCategoryId = category.id;
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Select category",
                  style: AppTheme.textStyle.color100.w700.size(22)),
              SizedBox(
                height: 20,
              ),
              ...widgets
            ],
          ),
        ),
      ),
    );
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
    } catch (e) {}
    Navigator.of(context).pop();
  }

  void _handleProductSave(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider
        .saveProduct(seletedCategoryId, name, price, quantity.toString(),
            selectedQuantity)
        .then((value) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16.0),
                topRight: const Radius.circular(16.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.check_circle_outline,
                        size: 100.0,
                        color: AppTheme.primaryColor,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: 242,
                        child: Text(
                          "Product added successfully!",
                          textAlign: TextAlign.center,
                          style: AppTheme.textStyle.w700.size(25).color100,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).catchError((error) {
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
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            centerTitle: false,
            title: Align(
              child: Text(
                'Add Product',
                style: TextStyle(
                    color: AppTheme.color100,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              alignment: Alignment.centerLeft,
            ),
            leading: IconButton(
              icon: Icon(
                BotigaIcons.arrowBack,
                color: AppTheme.color100,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
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
                          _handleProductSave(context);
                        }
                      },
                      color: Color(0xff179F57),
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
          child: Form(
            key: _formKey,
            child: ListView(
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      child: Image.file(
                                        File(_imageFile.path),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                          : Container(
                              width: double.infinity,
                              height: 176,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: AppTheme.color100.withOpacity(0.25),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton.icon(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    icon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 14,
                                        bottom: 14,
                                      ),
                                      child:
                                          Icon(BotigaIcons.gallery, size: 18),
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
                                      "Adding image will increase people interest in your product",
                                      textAlign: TextAlign.center,
                                      style: AppTheme.textStyle.color50.w400
                                          .size(12)
                                          .letterSpace(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Product name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (val) => name = val,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(17.0),
                            fillColor: AppTheme.backgroundColor,
                            labelText: "Product name",
                            labelStyle:
                                AppTheme.textStyle.size(15).w500.color25,
                            border: OutlineInputBorder()),
                      ),
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
                            showCategories();
                          },
                          trailing: Icon(Icons.keyboard_arrow_down,
                              color: AppTheme.color100),
                          title: seletedCategory == ''
                              ? Text(
                                  'Select Category',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                )
                              : Text(
                                  '$seletedCategory',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price cannot be empty';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Price should be number';
                          }
                          return null;
                        },
                        onSaved: (val) => price = double.parse(val),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              BotigaIcons.rupee,
                              size: 14,
                              color: AppTheme.color100,
                            ),
                            contentPadding: const EdgeInsets.all(17.0),
                            fillColor: AppTheme.backgroundColor,
                            labelText: "Price",
                            labelStyle:
                                AppTheme.textStyle.size(15).w500.color25,
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Quantity cannot be empty';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Quantity should be number';
                          }
                          return null;
                        },
                        onSaved: (val) => quantity = int.parse(val),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(17.0),
                            fillColor: AppTheme.backgroundColor,
                            labelText: "Quantity",
                            labelStyle:
                                AppTheme.textStyle.size(15).w500.color25,
                            border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 17, bottom: 17),
                  child: Container(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        ...["Kg", "gm", "liter", "ml", "pcs"].map(
                          (val) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Container(
                                height: 44,
                                width: 67,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedQuantity = val;
                                    });
                                  },
                                  color: selectedQuantity == val
                                      ? AppTheme.primaryColor
                                      : AppTheme.dividerColor,
                                  child: Text('$val',
                                      style: selectedQuantity == val
                                          ? AppTheme.textStyle
                                              .size(13)
                                              .w600
                                              .colored(AppTheme.backgroundColor)
                                          : AppTheme.textStyle.color100
                                              .size(13)
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
                        child: TextFormField(
                          autofocus: true,
                          onSaved: (val) => description = val,
                          maxLines: 3,
                          maxLength: 80,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(17.0),
                              fillColor: AppTheme.backgroundColor,
                              hintText: "Description",
                              labelText: "Description",
                              alignLabelWithHint: true,
                              labelStyle:
                                  AppTheme.textStyle.size(15).w500.color25,
                              border: OutlineInputBorder()),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ));
  }
}
