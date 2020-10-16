import 'dart:io';
import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/Profile/BusinessProvider.dart';

class BussinessDetails extends StatefulWidget {
  static const routeName = '/business-details';
  @override
  _BussinessDetailsState createState() => _BussinessDetailsState();
}

class _BussinessDetailsState extends State<BussinessDetails> {
  final _formKey = GlobalKey<FormState>();
  PickedFile _imageFile;
  String seletedCategory = '';
  String name;
  String tagline;

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

  void handleBusinessInformationSave(BuildContext context) {
    final businessProvider =
        Provider.of<BusinessProvider>(context, listen: false);
    businessProvider
        .updateBusinessInfromation(
            name, tagline, 'https://s3.com/durl', seletedCategory)
        .then((value) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Color(0xff2591B2),
        messageText: Text(
          '${value['message']}',
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
    final businessProvider =
        Provider.of<BusinessProvider>(context, listen: false);
    final businessDetails = businessProvider.businessDetails;
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
                        handleBusinessInformationSave(context);
                      }
                    },
                    color: AppTheme.primaryColor,
                    child: Text(
                      'Save Details',
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
          title: Align(
            child: Text(
              'Business details',
              style: AppTheme.textStyle.color100.size(20).w500,
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: AppTheme.backgroundColor,
              child: Column(
                children: <Widget>[
                  _imageFile != null
                      ? Container(
                          height: 96,
                          width: 96,
                          margin: EdgeInsets.only(top: 20.0, bottom: 20),
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            child: Image.file(
                              File(_imageFile.path),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        )
                      : Container(
                          height: 96,
                          width: 96,
                          margin: EdgeInsets.only(top: 20.0, bottom: 20),
                          decoration: BoxDecoration(
                            color: AppTheme.color05,
                            shape: BoxShape.circle,
                          ),
                        ),
                  Container(
                    child: Text(
                      "Health & hunger",
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle.w700.size(17),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Prateek mishra singh",
                      textAlign: TextAlign.center,
                      style: AppTheme.textStyle.w500.size(13).color50),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        onPressed: () {
                          showImageSelectOption(context);
                        },
                        color: Color(0xff121715).withOpacity(0.05),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text('Change logo',
                              style: AppTheme.textStyle.w600.color100.size(15)),
                        ),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
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
                            style: AppTheme.textStyle.w600.color100.size(15),
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
                        return 'Brand name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (val) => '',
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
                    onSaved: (val) => '',
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
                      visualDensity: VisualDensity(horizontal: 0, vertical: -1),
                      onTap: () {
                        showCategories();
                      },
                      trailing: Icon(Icons.keyboard_arrow_down,
                          color: AppTheme.color100),
                      title: seletedCategory == ''
                          ? Text(
                              'Business Category',
                              style: AppTheme.textStyle.color100.w500.size(15),
                            )
                          : Text(
                              '$seletedCategory',
                              style: AppTheme.textStyle.color100.w500.size(15),
                            ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
