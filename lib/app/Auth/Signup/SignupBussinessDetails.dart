import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:botiga_biz/theme/index.dart';
import 'SignupStoreDetails.dart';
import '../../../widget/index.dart';
import '../../../providers/Auth/AuthProvider.dart';

class SignupBuissnessDetails extends StatefulWidget {
  static const routeName = '/signup-bussiness-detail';
  @override
  _SignupBuissnessDetailsState createState() => _SignupBuissnessDetailsState();
}

class _SignupBuissnessDetailsState extends State<SignupBuissnessDetails> {
  final _formKey = GlobalKey<FormState>();
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  String businessName;
  String firstName;
  String lastName;
  String brandName;
  String tagline;
  String seletedCategory = 'Beverages';

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
            Navigator.of(context).pop();
            if (isOther) {
              String bsCategoryName = '';
              final _bsformkey = GlobalKey<FormState>();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Form(
                    key: _bsformkey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.only(
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
                            style: AppTheme.textStyle.color100.size(22).w700,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Business Category name cannot be empty';
                              }
                              return null;
                            },
                            onSaved: (val) => bsCategoryName = val,
                            decoration: InputDecoration(
                                filled: true,
                                contentPadding: const EdgeInsets.all(17.0),
                                fillColor: AppTheme.dividerColor,
                                hintText: "Write your business category",
                                hintStyle:
                                    AppTheme.textStyle.size(15).w500.color25,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    height: 52,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      onPressed: () {
                                        if (_bsformkey.currentState
                                            .validate()) {
                                          _bsformkey.currentState.save();
                                          setState(() {
                                            seletedCategory = bsCategoryName;
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      color: AppTheme.primaryColor,
                                      child: Text(
                                        'Save category',
                                        style: AppTheme.textStyle
                                            .size(15)
                                            .w600
                                            .colored(AppTheme.backgroundColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              setState(() {
                seletedCategory = s;
              });
            }
          },
          contentPadding: EdgeInsets.all(0),
          title: Text(
            s,
            style: AppTheme.textStyle.color100.w500.size(17),
          ),
        ),
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
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
        decoration: BoxDecoration(
          color: Colors.white,
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
            Text(
              "Select category",
              style: AppTheme.textStyle.color100.size(22).w700,
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
                  style: AppTheme.textStyle.color100.size(22).w700),
              SizedBox(
                height: 24,
              ),
              ListTile(
                  onTap: () {
                    _onImageButtonPressed(ImageSource.camera, context);
                  },
                  contentPadding: EdgeInsets.only(left: 0.0),
                  leading: Icon(
                    Icons.camera_alt,
                    color: Color(0xff121715),
                  ),
                  title: Text('Take photo',
                      style: AppTheme.textStyle.color100.size(17).w500)),
              ListTile(
                onTap: () {
                  _onImageButtonPressed(ImageSource.gallery, context);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(
                  Icons.image,
                  color: Color(0xff121715),
                ),
                title: Text('Choose from gallery',
                    style: AppTheme.textStyle.color100.size(17).w500),
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

  void handleSignUp(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];

    authProvider
        .signup(businessName, seletedCategory, firstName, lastName, brandName,
            phone)
        .then((value) {
      Navigator.of(context).pushNamed(SignUpStoreDetails.routeName);
    }).catchError((error) {
      //TODO: remove this navigation
      Navigator.of(context).pushNamed(SignUpStoreDetails.routeName);
      Toast(iconData: BotigaIcons.truck, message: '$error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: AppTheme.backgroundColor,
        padding: EdgeInsets.all(10),
        child: SafeArea(
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
                        handleSignUp(context);
                      }
                    },
                    color: AppTheme.primaryColor,
                    child: Text(
                      'Save and continue',
                      style: AppTheme.textStyle
                          .size(15)
                          .w600
                          .colored(AppTheme.backgroundColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Align(
          child: Text(
            'Business details',
            style: AppTheme.textStyle.color100.size(20).w500,
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                color: AppTheme.backgroundColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Flexible(
                        child: Text(
                          "We collect these details for future communication and to create your store.",
                          style: AppTheme.textStyle.size(13).w500.color50,
                        ),
                      ),
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
                                color: AppTheme.color05,
                                child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Text('Change logo',
                                        style: AppTheme.textStyle.color100.w600
                                            .size(15))),
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
                                color: AppTheme.color05,
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(
                                    'Remove logo',
                                    style: AppTheme.textStyle.color100.w600
                                        .size(15),
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
                                color: AppTheme.color05,
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Upload logo',
                                    style: AppTheme.textStyle.color100.w600
                                        .size(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Business name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (val) => businessName = val,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(17.0),
                          fillColor: AppTheme.backgroundColor,
                          labelText: "Business Name",
                          labelStyle: AppTheme.textStyle.size(15).w500.color25,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Business owner first name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (val) => firstName = val,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(17.0),
                          fillColor: AppTheme.backgroundColor,
                          labelText: "Business Owner First Name",
                          labelStyle: AppTheme.textStyle.size(15).w500.color25,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Business owner last name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (val) => lastName = val,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(17.0),
                          fillColor: AppTheme.backgroundColor,
                          labelText: "Business Owner Last Name",
                          labelStyle: AppTheme.textStyle.size(15).w500.color25,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Brand name cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (val) => brandName = val,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(17.0),
                          fillColor: AppTheme.backgroundColor,
                          labelText: "Brand name",
                          labelStyle: AppTheme.textStyle.size(15).w500.color25,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Tagline cannot be empty';
                        }
                        return null;
                      },
                      onSaved: (val) => tagline = val,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(17.0),
                          fillColor: AppTheme.backgroundColor,
                          labelText: "Tagline",
                          labelStyle: AppTheme.textStyle.size(15).w500.color25,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 24,
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
                                'Business Category',
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
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
