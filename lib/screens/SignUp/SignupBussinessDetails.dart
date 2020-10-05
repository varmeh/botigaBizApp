import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import './SignupStoreDetails.dart';

class SignupBuissnessDetails extends StatefulWidget {
  static const routeName = '/signup-bussiness-detail';
  @override
  _SignupBuissnessDetailsState createState() => _SignupBuissnessDetailsState();
}

class _SignupBuissnessDetailsState extends State<SignupBuissnessDetails> {
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  void _onImageButtonPressed(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 96,
        maxHeight: 96,
        imageQuality: 20,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {}
    Navigator.of(context).pop();
  }

  Widget categoryItem(String s, bool isOther) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pop(context);
            if (isOther) {
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
                    padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Business category",
                          style: TextStyle(
                              color: Color(0xff121715),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextField(
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration(
                                fillColor: Colors.black.withOpacity(0.05),
                                filled: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                                hintText: "Write your business category",
                                hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.5)),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8.0)))),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 52,
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(6.0)),
                                  onPressed: () {},
                                  color: Color(0xff179F57),
                                  child: Text(
                                    'Save category',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
          contentPadding: EdgeInsets.all(0),
          title: Text(
            s,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        ),
      ],
    );
  }

  void showCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.60,
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
            categoryItem("Beverages", false),
            categoryItem("Clothings", false),
            categoryItem("Speciality foods", false),
            categoryItem("Other", true),
          ],
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
                  _onImageButtonPressed(ImageSource.camera, context);
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
                  _onImageButtonPressed(ImageSource.gallery, context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          color: Colors.white,
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
                      Navigator.of(context)
                          .pushNamed(SignUpStoreDetails.routeName);
                    },
                    color: Color(0xff179F57),
                    child: Text(
                      'Save and continue',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Business details",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff121715)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            "We collect these details for future communication and to create your store.",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff121715).withOpacity(0.5)),
                          ),
                        ),
                      ],
                    ),
                    _imageFile != null
                        ? Container(
                            height: 96,
                            width: 96,
                            margin: EdgeInsets.only(top: 25.0, bottom: 20),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipRRect(
                              child: Image.file(
                                File(_imageFile.path),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ))
                        : Container(
                            height: 96,
                            width: 96,
                            child: Icon(
                              Icons.storefront,
                              size: 40,
                            ),
                            margin: EdgeInsets.only(top: 25.0, bottom: 20),
                            decoration: BoxDecoration(
                                color: Color(0xff121715).withOpacity(0.05),
                                shape: BoxShape.circle)),
                    SizedBox(
                      height: 5,
                    ),
                    _imageFile != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0)),
                                onPressed: () {
                                  showImageSelectOption(context);
                                },
                                color: Color(0xff121715).withOpacity(0.05),
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Change logo',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0)),
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                                color: Color(0xff121715).withOpacity(0.05),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(
                                    'Remove logo',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(6.0)),
                                onPressed: () {
                                  showImageSelectOption(context);
                                },
                                color: Color(0xff121715).withOpacity(0.05),
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Upload logo',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 30,
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
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Business Name",
                            hintText: "Business Name",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 24,
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
                            labelText: "Business Owner First Name",
                            hintText: "Business Owner First Name",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 24,
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
                            labelText: "Business Owner Last Name",
                            hintText: "Business Owner Last Name",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 24,
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
                            labelText: "Brand Name",
                            hintText: "Brand Name",
                            alignLabelWithHint: true,
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 24,
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
                            labelText: "Tagline",
                            hintText: "Tagline",
                            alignLabelWithHint: true,
                            helperText: "Optional",
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 24,
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
                          'Business Category',
                          style: TextStyle(
                              color: Color(0xff121715).withOpacity(0.75),
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ))),
      ),
    );
  }
}
