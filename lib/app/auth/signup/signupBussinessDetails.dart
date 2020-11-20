import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart'
    show
        LoaderOverlay,
        BotigaTextFieldForm,
        Toast,
        FullWidthButton,
        BotigaAppBar,
        BotigaBottomModal;
import '../../../providers/index.dart' show ProfileProvider, ServicesProvider;
import '../../../util/index.dart';
import './index.dart';

class SignupBuissnessDetails extends StatefulWidget {
  static const routeName = 'signup-bussiness-detail';
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
  final _sizedBox24 = SizedBox(height: 24);
  List bsCategory;

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
    downloadUrl = '';
    bsCategory = [];
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedUrl();
      this._getBusinessCategory();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();

    _businessNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastFocusNode.dispose();
    _brandNameFocusNode.dispose();
    _taglineFocusNode.dispose();

    super.dispose();
  }

  void _getPreSignedUrl() async {
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedBrandImageUrl();
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    }
  }

  void _getBusinessCategory() async {
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getbusinessCategory();
      setState(() {
        bsCategory = value;
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
      setState(() {
        _imageFile = null;
      });
      Toast(message: Http.message(err)).show(context);
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
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
      if (e.code != null &&
          (e.code == 'photo_access_denied' ||
              e.code == 'camera_access_denied')) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Access denied',
              style: AppTheme.textStyle.w500.color100,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '${e.message} Please enable it in app setting.',
                    style: AppTheme.textStyle.w400.color100,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: AppTheme.textStyle.w600.color50,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        Toast(message: "Unexpected error").show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      bottomNavigationBar: Material(
        elevation: 16.0,
        child: Container(
          color: AppTheme.backgroundColor,
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          child: FullWidthButton(
            title: 'Save and continue',
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                handleSignUp(context);
              }
            },
          ),
        ),
      ),
      appBar: BotigaAppBar(
        'Business details',
        neverShowLeadingBtn: true,
      ),
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: AppTheme.backgroundColor,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'We collect these details for future communication and to create your store.',
                      style: AppTheme.textStyle.size(13).w500.color50,
                    ),
                  ),
                  _imageSelectionWidget(),
                  _sizedBox24,
                  BotigaTextFieldForm(
                    focusNode: _businessNameFocusNode,
                    labelText: 'Business Name',
                    onSave: (value) => _businessName = value,
                    nextFocusNode: _firstNameFocusNode,
                    validator: nameValidator,
                  ),
                  _sizedBox24,
                  BotigaTextFieldForm(
                    focusNode: _firstNameFocusNode,
                    labelText: 'Business Owner First Name',
                    onSave: (value) => _firstName = value,
                    nextFocusNode: _lastFocusNode,
                    validator: nameValidator,
                  ),
                  _sizedBox24,
                  BotigaTextFieldForm(
                    focusNode: _lastFocusNode,
                    labelText: 'Business Owner Last Name',
                    onSave: (value) => _lastName = value,
                    nextFocusNode: _brandNameFocusNode,
                    validator: nameValidator,
                  ),
                  _sizedBox24,
                  BotigaTextFieldForm(
                    focusNode: _brandNameFocusNode,
                    labelText: 'Brand Name',
                    onSave: (value) => _brandName = value,
                    nextFocusNode: _taglineFocusNode,
                    validator: nameValidator,
                  ),
                  _sizedBox24,
                  BotigaTextFieldForm(
                    focusNode: _taglineFocusNode,
                    labelText: 'Tagline',
                    onSave: (value) => _tagline = value,
                    validator: nameValidator,
                  ),
                  _sizedBox24,
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
                      title: _seletedCategory == ''
                          ? Text(
                              'Business Category',
                              style: AppTheme.textStyle.color100.w500.size(15),
                            )
                          : Text(
                              '$_seletedCategory',
                              style: AppTheme.textStyle.color100.w500.size(15),
                            ),
                    ),
                  ),
                  _sizedBox24,
                  Text.rich(
                    TextSpan(
                      text: 'By signing up, you agree to all ',
                      style: AppTheme.textStyle
                          .size(13)
                          .lineHeight(1.5)
                          .w500
                          .color50,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: AppTheme.textStyle
                              .size(13)
                              .lineHeight(1.5)
                              .w500
                              .colored(AppTheme.primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              // Note: Don't use canLaunch(url). Fails on iOS devices
                              try {
                                await launch(
                                  'https://s3.ap-south-1.amazonaws.com/products.image.prod/termsAndConditions.pdf',
                                );
                              } catch (_) {
                                Toast(
                                  message:
                                      'Failed to open agreement in browser',
                                ).show(context);
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                  _sizedBox24,
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                        left: 20,
                        right: 20,
                        bottom: 20,
                        top: 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Business category',
                            style: AppTheme.textStyle.color100.size(22).w700,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          BotigaTextFieldForm(
                            focusNode: _bsCategoryNameFocusNode,
                            labelText: 'Write your business category',
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

  Widget _imageSelectionWidget() {
    return Column(
      children: [
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
                ),
              )
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
                  shape: BoxShape.circle,
                ),
              ),
        SizedBox(height: 5),
        _imageFile != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0)),
                    onPressed: () {
                      showImageSelectOption(context);
                    },
                    color: AppTheme.color05,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Text(
                        'Change logo',
                        style: AppTheme.textStyle.color100.w600.size(15),
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0)),
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
                        style: AppTheme.textStyle.color100.w600.size(15),
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
                        borderRadius: new BorderRadius.circular(6.0)),
                    onPressed: () {
                      showImageSelectOption(context);
                    },
                    color: AppTheme.color05,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Text(
                        'Upload logo',
                        style: AppTheme.textStyle.color100.w600.size(15),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  void showCategories() {
    BotigaBottomModal(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Select category',
                  style: AppTheme.textStyle.color100.size(22).w700,
                ),
                SizedBox(
                  height: 25,
                ),
                SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: ListView(
                      children: [
                        ...bsCategory.map((bsCat) {
                          return categoryItem(bsCat, false);
                        }),
                        categoryItem('Other', true),
                      ],
                    ),
                  ),
                )
              ],
            ),
            isDismissible: true)
        .show(context);
  }

  void showImageSelectOption(BuildContext context) {
    BotigaBottomModal(
        isDismissible: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Add image', style: AppTheme.textStyle.color100.size(22).w700),
            SizedBox(
              height: 24,
            ),
            ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  _onImageButtonPressed(ImageSource.camera);
                },
                contentPadding: EdgeInsets.only(left: 0.0),
                leading: Icon(
                  Icons.camera_alt,
                  color: AppTheme.color100,
                ),
                title: Text('Take photo',
                    style: AppTheme.textStyle.color100.size(17).w500)),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                _onImageButtonPressed(ImageSource.gallery);
              },
              contentPadding: EdgeInsets.only(left: 0.0),
              leading: Icon(
                Icons.image,
                color: AppTheme.color100,
              ),
              title: Text('Choose from gallery',
                  style: AppTheme.textStyle.color100.size(17).w500),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        )).show(context);
  }

  void handleSignUp(BuildContext context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    try {
      setState(() {
        _isLoading = true;
      });
      await profileProvider.signup(_businessName, _seletedCategory, _firstName,
          _lastName, _brandName, phone, _tagline, downloadUrl);
      await KeyStore.setFirstRun();
      Navigator.of(context).pushNamed(SignUpStoreDetails.routeName);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
