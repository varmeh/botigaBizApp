import 'package:flutter/material.dart';
import '../../widget/common/appHeader.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../add-product-success/addProductSuccess.dart';

class MyStatefulWidget extends StatefulWidget {
  final label;
  MyStatefulWidget(this.label);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(this.label);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _isSelected = false;
  final label;
  _MyStatefulWidgetState(this.label);

  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: this.label,
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
        });
      },
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            value
                ? IconButton(
                    icon: Icon(
                      Icons.check_box,
                      size: 30,
                      color: Color(0xff179F57),
                    ),
                    onPressed: () {
                      onChanged(false);
                    })
                : IconButton(
                    icon: Icon(
                      Icons.check_box_outline_blank,
                      size: 30,
                      color: Color(0xff121715),
                    ),
                    onPressed: () {
                      onChanged(true);
                    },
                  )
          ],
        ),
      ),
    );
  }
}

class AddProduct extends StatefulWidget {
  static const routeName = '/add-product';
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _switchValue = false;
  String selectedQuantity = 'Kg';
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void showCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
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
              Text(
                "Select category",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 25,
              ),
              MyStatefulWidget("Deserts"),
              MyStatefulWidget("Cakes"),
              MyStatefulWidget("Cookies"),
              MyStatefulWidget("Snacks"),
              MyStatefulWidget("Deserts"),
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
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
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
              Text(
                "Add image",
                style: TextStyle(
                    color: Color(0xff121715),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(Icons.camera_alt, color: Color(0xff121715)),
                title: Text(
                  'Take photo',
                  style: TextStyle(
                      color: Color(0xff121715),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ListTile(
                onTap: () {
                  _onImageButtonPressed(ImageSource.gallery, context: context);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(
                  Icons.image,
                  color: Color(0xff121715),
                ),
                title: Text(
                  'Choose from gallery',
                  style: TextStyle(
                      color: Color(0xff121715),
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddProductSuccess()));
                    },
                    color: Color(0xff179F57),
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AppHeader(
                        title: "Add Product",
                        actionWidget: InkWell(
                          onTap: () {
                            debugPrint('I am Awesome');
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(
                        height: 29,
                      ),
                      _imageFile != null
                          ? ConstrainedBox(
                              constraints: BoxConstraints.tight(
                                  Size(double.infinity, 176)),
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
                                      )),
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
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/image_edit.png'),
                                                fit: BoxFit.cover,
                                              )),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _imageFile = null;
                                              });
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/icons/image_delete.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      )),
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
                                  color: Colors.black.withOpacity(0.25),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton.icon(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    icon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 14,
                                        bottom: 14,
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                          'assets/icons/addimage.png',
                                        ),
                                      ),
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
                                      child: Text(
                                        'Add image',
                                        style: TextStyle(
                                          color: Color(0xff372D21),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 55, right: 55, top: 16),
                                    child: Text(
                                      "Adding image will increase people interest in your product",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff121715)
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0.2),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        onSaved: (val) => '',
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Product name",
                          hintText: "Product name",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                style: BorderStyle.solid,
                                color: Colors.black.withOpacity(0.25),
                                width: 1.0)),
                        child: ListTile(
                          onTap: () {
                            showCategories();
                          },
                          trailing: Icon(Icons.keyboard_arrow_down,
                              color: Color(0xff121715)),
                          title: Text(
                            'Select Category',
                            style: TextStyle(
                                color: Color(0xff121715).withOpacity(0.75),
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          onSaved: (val) => '',
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: Image(
                                height: 22,
                                image: AssetImage(
                                  'assets/icons/rupee.png',
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Price",
                              hintText: "Price",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder())),
                      SizedBox(
                        height: 26,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                          onSaved: (val) => '',
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Quantity",
                              hintText: "Quantity",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder())),
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
                        ...["Kg", "gm", "liter", "ml", "pc"].map((val) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              height: 44,
                              width: 67,
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0)),
                                onPressed: () {
                                  setState(() {
                                    selectedQuantity = val;
                                  });
                                },
                                color: selectedQuantity == val
                                    ? Color(0xff179F57)
                                    : Colors.black.withOpacity(0.25),
                                child: Text(
                                  '$val',
                                  style: TextStyle(
                                      color: selectedQuantity == val
                                          ? Colors.white
                                          : Color(0xff121715),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 0, bottom: 26),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Add description",
                          style: TextStyle(
                              color: Color(0xff121715),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
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
                            left: 20, right: 20, bottom: 26),
                        child: TextFormField(
                            onSaved: (val) => '',
                            validator: (value) {
                              if (value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            maxLines: 3,
                            maxLength: 80,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                alignLabelWithHint: true,
                                labelText: "Description",
                                hintText: "Description",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder())),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ));
  }
}
