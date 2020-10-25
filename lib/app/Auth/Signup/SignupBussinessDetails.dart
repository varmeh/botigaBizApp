import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:botiga_biz/theme/index.dart';
import 'SignupStoreDetails.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import '../../../providers/Auth/AuthProvider.dart';
import '../../../providers/Services/ImageService.dart';

class SignupBuissnessDetails extends StatefulWidget {
  static const routeName = '/signup-bussiness-detail';
  @override
  _SignupBuissnessDetailsState createState() => _SignupBuissnessDetailsState();
}

class _SignupBuissnessDetailsState extends State<SignupBuissnessDetails> {
  GlobalKey<FormState> _formKey;
  PickedFile _imageFile;
  ImagePicker _picker;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;
  String _businessName = '',
      _firstName = '',
      _lastName = '',
      _brandName = '',
      _tagline = '',
      _seletedCategory;
  FocusNode _businessNameFocusNode,
      _firstNameFocusNode,
      _lastFocusNode,
      _brandNameFocusNode,
      _taglineFocusNode;

  String uploadurl, downloadUrl;
  bool _isInit;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _picker = ImagePicker();
    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();
    _isInit = false;
    _seletedCategory = 'Beverages';
    _businessNameFocusNode = FocusNode();
    _firstNameFocusNode = FocusNode();
    _lastFocusNode = FocusNode();
    _brandNameFocusNode = FocusNode();
    _taglineFocusNode = FocusNode();
    _isLoading = false;
    uploadurl = '';
    downloadUrl =
        'https://products.image.dev.s3.ap-south-1.amazonaws.com/5f7730a57a8a7aafb139f511_hLOmFS.png';
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedUrl();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _getPreSignedUrl() {
    print("--------------------->>");
    ImageService.getPresignedImageUrl().then((value) {
      print("++$value");
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    }).catchError((error) {
      print("7*****$error");
      Toast(message: '$error', iconData: Icons.error_outline);
    });
  }

  void _handleImageUpload(PickedFile file) {
    ImageService.uploadImageToS3(uploadurl, file).then((value) {
      print(value);
    }).catchError((error) {
      print(error);
      Toast(message: '$error', iconData: Icons.error_outline_sharp)
          .show(context);
      setState(() {
        _imageFile = null;
      });
    });
  }

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
      _handleImageUpload(pickedFile);
    } catch (e) {
      Toast(message: '$e', iconData: Icons.error_outline_sharp).show(context);
    }
    Navigator.of(context).pop();
  }

  Widget categoryItem(String s, bool isOther) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            if (isOther) {
              String _bsCategoryName = '';
              final _bsformkey = GlobalKey<FormState>();
              FocusNode _bsCategoryNameFocusNode = FocusNode();

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
                          BotigaTextFieldForm(
                            focusNode: _bsCategoryNameFocusNode,
                            labelText: "Write your business category",
                            onSave: (value) => _bsCategoryName = value,
                            validator: nameValidator,
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
                                            _seletedCategory = _bsCategoryName;
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
                _seletedCategory = s;
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
    setState(() {
      _isLoading = true;
    });
    authProvider
        .signup(_businessName, _seletedCategory, _firstName, _lastName,
            _brandName, phone, _tagline, downloadUrl)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamed(SignUpStoreDetails.routeName);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
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
                      if (_isLoading) {
                        return null;
                      }
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        handleSignUp(context);
                      }
                    },
                    color: _isLoading
                        ? AppTheme.dividerColor
                        : AppTheme.primaryColor,
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
      body: Stack(
        children: [
          SafeArea(
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
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                            style: AppTheme
                                                .textStyle.color100.w600
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                        BotigaTextFieldForm(
                          focusNode: _businessNameFocusNode,
                          labelText: 'Business Name',
                          onSave: (value) => _businessName = value,
                          nextFocusNode: _firstNameFocusNode,
                          validator: nameValidator,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        BotigaTextFieldForm(
                          focusNode: _firstNameFocusNode,
                          labelText: 'Business Owner First Name',
                          onSave: (value) => _firstName = value,
                          nextFocusNode: _lastFocusNode,
                          validator: nameValidator,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        BotigaTextFieldForm(
                          focusNode: _lastFocusNode,
                          labelText: 'Business Owner Last Name',
                          onSave: (value) => _lastName = value,
                          nextFocusNode: _brandNameFocusNode,
                          validator: nameValidator,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        BotigaTextFieldForm(
                          focusNode: _brandNameFocusNode,
                          labelText: 'Brand Name',
                          onSave: (value) => _brandName = value,
                          nextFocusNode: _taglineFocusNode,
                          validator: nameValidator,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        BotigaTextFieldForm(
                          focusNode: _taglineFocusNode,
                          labelText: 'Tagline',
                          onSave: (value) => _tagline = value,
                          validator: nameValidator,
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
                            title: _seletedCategory == ''
                                ? Text(
                                    'Business Category',
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
                      ],
                    )),
              ),
            ),
          ),
          _isLoading ? Loader() : SizedBox.shrink()
        ],
      ),
    );
  }
}
