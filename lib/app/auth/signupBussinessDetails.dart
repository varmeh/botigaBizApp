import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

import '../../providers/index.dart' show ProfileProvider, ServicesProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'index.dart';

class SignupBuissnessDetails extends StatefulWidget {
  static const routeName = 'signup-bussiness-detail';
  @override
  _SignupBuissnessDetailsState createState() => _SignupBuissnessDetailsState();
}

class _SignupBuissnessDetailsState extends State<SignupBuissnessDetails> {
  GlobalKey<FormState> _formKey;
  File _imageFile, _pdfFile;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;
  String _businessName = '',
      _firstName = '',
      _lastName = '',
      _brandName = '',
      _tagline = '',
      _seletedCategory,
      _seletedBusinessType,
      _gstNumber = '',
      _fssaiNumber = '';

  DateTime _fssaiDate;

  FocusNode _businessNameFocusNode,
      _firstNameFocusNode,
      _lastFocusNode,
      _brandNameFocusNode,
      _taglineFocusNode,
      _gstNumberFocusNode,
      _fssaiNumberFocusNode;

  String uploadurl, downloadUrl;
  String pdfUploadUrl, pdfDownloadUrl;
  bool _isInit;
  bool _isLoading;
  final _sizedBox24 = SizedBox(height: 24);
  List bsCategory;
  bool showFssaiOption;
  bool _hasGstNumber;

  //Error state to handle on form submit
  bool _categoryError,
      _businessTypeError,
      _fssaiDateError,
      _fssiCertificateError;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();

    _isInit = false;
    _seletedCategory = '';
    _seletedBusinessType = '';

    _businessNameFocusNode = FocusNode();
    _firstNameFocusNode = FocusNode();
    _lastFocusNode = FocusNode();
    _brandNameFocusNode = FocusNode();
    _taglineFocusNode = FocusNode();
    _gstNumberFocusNode = FocusNode();
    _fssaiNumberFocusNode = FocusNode();

    _isLoading = false;
    uploadurl = '';
    downloadUrl = '';
    pdfUploadUrl = '';
    pdfDownloadUrl = '';
    bsCategory = [];
    showFssaiOption = false;

    _categoryError = false;
    _businessTypeError = false;
    _fssaiDateError = false;
    _fssiCertificateError = false;
    _hasGstNumber = true;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedImageUrl();
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
    _gstNumberFocusNode.dispose();
    _fssaiNumberFocusNode.dispose();

    super.dispose();
  }

  void _getPreSignedImageUrl() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedBrandImageUrl();
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getPreSignedPdfUrl() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedePdfUrl();
      setState(() {
        pdfUploadUrl = value['uploadUrl'];
        pdfDownloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  void _handleImageUpload(File file) async {
    if (file == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ServicesProvider>(context, listen: false)
          .uploadImageToS3(uploadurl, file);
    } catch (err) {
      setState(() {
        _imageFile = null;
      });
      Toast(message: 'Something went wrong!').show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePdfUpload(File file) async {
    if (file == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ServicesProvider>(context, listen: false)
          .uploadPdfToS3(pdfUploadUrl, file);
    } catch (err) {
      setState(() {
        _pdfFile = null;
      });
      Toast(message: 'Something went wrong!').show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handlePdfChange() async {
    File oldFile = _pdfFile;
    setState(() {
      _pdfFile = null;
    });
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        _pdfFile = file;
        _fssiCertificateError = false;
      });
      _handlePdfUpload(_pdfFile);
    } else {
      setState(() {
        _pdfFile = oldFile;
      });
    }
  }

  Widget _getErrorText(bool errorVal) {
    return errorVal
        ? Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              "Required",
              style:
                  AppTheme.textStyle.w400.size(12).colored(AppTheme.errorColor),
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      bottomNavigationBar: Material(
        elevation: 16.0,
        child: SafeArea(
          child: Container(
            color: AppTheme.backgroundColor,
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PolicyWebiewScreen(
                                  'https://s3.ap-south-1.amazonaws.com/products.image.prod/termsAndConditions.html',
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                _sizedBox24,
                FullWidthButton(
                  title: 'Save and continue',
                  onPressed: () {
                    setState(() {
                      _categoryError = _seletedCategory == '';
                      _businessTypeError = _seletedBusinessType == '';
                      _fssaiDateError = showFssaiOption && _fssaiDate == null;
                      _fssiCertificateError =
                          showFssaiOption && _pdfFile == null;
                    });
                    if (_formKey.currentState.validate()) {
                      if (_seletedCategory == '' ||
                          _seletedBusinessType == '') {
                        return null;
                      }
                      if (showFssaiOption &&
                          (_fssaiDate == null || _pdfFile == null)) {
                        return null;
                      }
                      _formKey.currentState.save();
                      handleSignUp(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: BotigaAppBar(
        'Business details',
        neverShowLeadingBtn: true,
      ),
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: GestureDetector(
          onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      color: AppTheme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            onChange: (value) {
                              setState(() {
                                _businessName = value;
                              });
                            },
                            nextFocusNode: _firstNameFocusNode,
                            validator: emptyValidator,
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
                            validator: emptyValidator,
                          ),
                          _sizedBox24,
                          BotigaTextFieldForm(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _taglineFocusNode,
                            labelText: 'Tagline',
                            onSave: (value) => _tagline = value,
                            validator: emptyValidator,
                            nextFocusNode: _gstNumberFocusNode,
                          ),
                          _sizedBox24,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: _categoryError
                                    ? AppTheme.errorColor
                                    : AppTheme.color25,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                          ),
                          _getErrorText(_categoryError),
                          _sizedBox24,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: _businessTypeError
                                    ? AppTheme.errorColor
                                    : AppTheme.color25,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: ListTile(
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -1),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showBusinessType();
                                },
                                trailing: Icon(Icons.keyboard_arrow_down,
                                    color: AppTheme.color100),
                                title: _seletedBusinessType == ''
                                    ? Text(
                                        'Business Type',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      )
                                    : Text(
                                        '$_seletedBusinessType',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      ),
                              ),
                            ),
                          ),
                          _getErrorText(_businessTypeError),
                          _sizedBox24,
                          BotigaTextFieldForm(
                            validator:
                                _hasGstNumber ? emptyValidator : (_) => null,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _gstNumberFocusNode,
                            labelText: 'GSTIN',
                            onSave: (value) => _gstNumber = value,
                            readOnly: !_hasGstNumber,
                          ),
                          _sizedBox24,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _hasGstNumber = !_hasGstNumber;
                                      });
                                    },
                                    child: !_hasGstNumber
                                        ? Icon(
                                            Icons.check_box,
                                            color: AppTheme.primaryColor,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons
                                                .check_box_outline_blank_rounded,
                                            color: AppTheme.color100,
                                            size: 30,
                                          ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'I don’t have GST number',
                                    style: AppTheme.textStyle.color100
                                        .size(13)
                                        .w600
                                        .lineHeight(1.5),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Visibility(
                                visible: !_hasGstNumber,
                                child: Text(
                                    'I, ${_businessName != '' ? _businessName : "merchant"}, gives a declaration that I am not liable to register under section 22 of CGST Act, 2017 as my sales are below the prescribed threshold limit for registration under the aforesaid provision.',
                                    style: AppTheme.textStyle.color50
                                        .size(12)
                                        .w500
                                        .lineHeight(1.5)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 5),
                      child: Divider(
                        color: AppTheme.dividerColor,
                        thickness: 4,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            title: Text(
                              "Are you in food business?",
                              style: AppTheme.textStyle.w700.color100
                                  .size(12)
                                  .lineHeight(1.2)
                                  .letterSpace(0.2),
                            ),
                            subtitle: Text(
                              "We need FSSAI Details",
                              style: AppTheme.textStyle.w500.color50
                                  .size(12)
                                  .lineHeight(1.2)
                                  .letterSpace(0.2),
                            ),
                            trailing: BotigaSwitch(
                              handleSwitchChage: (bool value) {
                                _getPreSignedPdfUrl();
                                setState(() {
                                  showFssaiOption = value;
                                });
                                _fssaiNumberFocusNode.requestFocus();
                              },
                              switchValue: showFssaiOption,
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          !showFssaiOption
                              ? SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 12,
                                    ),
                                    BotigaTextFieldForm(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      focusNode: _fssaiNumberFocusNode,
                                      labelText: 'FSSAI Number',
                                      validator: emptyValidator,
                                      onSave: (value) => _fssaiNumber = value,
                                    ),
                                    _sizedBox24,
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.5),
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: _fssaiDateError
                                              ? AppTheme.errorColor
                                              : AppTheme.color25,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4.0),
                                        child: ListTile(
                                          visualDensity: VisualDensity(
                                              horizontal: 0, vertical: -1),
                                          onTap: () {
                                            getBotigaCalendar(
                                              context,
                                              DateTime.now(),
                                              DateTime.now().add(
                                                  const Duration(days: 3650)),
                                              DateTime.now(),
                                              (DateTime date) {
                                                setState(() {
                                                  _fssaiDate = date;
                                                  _fssaiDateError = false;
                                                });
                                              },
                                            );
                                          },
                                          trailing: Icon(Icons.date_range,
                                              color: AppTheme.color50),
                                          title: _fssaiDate == null
                                              ? Text(
                                                  'FSSAI Validity Date',
                                                  style: AppTheme
                                                      .textStyle.color50.w500
                                                      .size(15),
                                                )
                                              : Text(
                                                  '${_fssaiDate.getRequestFormatDate()}',
                                                  style: AppTheme
                                                      .textStyle.color100.w500
                                                      .size(15),
                                                ),
                                        ),
                                      ),
                                    ),
                                    _getErrorText(_fssaiDateError),
                                    _sizedBox24,
                                    _pdfFile != null
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints.tight(
                                              Size(double.infinity, 156),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 156,
                                                  height: 156,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: ClipRRect(
                                                    child: PDF.file(
                                                      _pdfFile,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      PassiveButton(
                                                        title: "Change",
                                                        onPressed: () {
                                                          handlePdfChange();
                                                        },
                                                        height: 44,
                                                        width: 135,
                                                      ),
                                                      _sizedBox24,
                                                      PassiveButton(
                                                        title: "Delete",
                                                        onPressed: () {
                                                          setState(() {
                                                            _pdfFile = null;
                                                          });
                                                        },
                                                        height: 44,
                                                        width: 135,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 156,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    style: BorderStyle.solid,
                                                    color: _fssiCertificateError
                                                        ? AppTheme.errorColor
                                                        : AppTheme.color100
                                                            .withOpacity(0.25),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    PassiveButton(
                                                      icon: Icon(
                                                        Icons.upload_file,
                                                        color: AppTheme.color50,
                                                      ),
                                                      title: "Upload",
                                                      onPressed: () {
                                                        handlePdfChange();
                                                      },
                                                      height: 44,
                                                      width: 135,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Text(
                                                        'Upload FSSAI certificate',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTheme
                                                            .textStyle
                                                            .color50
                                                            .w500
                                                            .size(12)
                                                            .letterSpace(0.2)
                                                            .lineHeight(1.5),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Text(
                                                        '* only pdf',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTheme
                                                            .textStyle
                                                            .color100
                                                            .w500
                                                            .size(10)
                                                            .letterSpace(0.2)
                                                            .lineHeight(1.2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _getErrorText(
                                                  _fssiCertificateError),
                                            ],
                                          ),
                                  ],
                                ),
                          _sizedBox24,
                        ],
                      ),
                    )
                  ],
                ),
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
                                            _categoryError = false;
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
                _categoryError = false;
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
                  color: AppTheme.color100.withOpacity(0.05),
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

  void showBusinessType() {
    List<String> businessTypes = [
      'Private Limited',
      'Proprietorship',
      'Partnership',
      'Individual',
      'Public Limited',
      'LLP'
    ];
    BotigaBottomModal(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Select Business Type',
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
                        ...businessTypes.map((bs) {
                          return bussinessTypeItem(bs);
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
            isDismissible: true)
        .show(context);
  }

  Widget bussinessTypeItem(String s) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              _seletedBusinessType = s;
              _businessTypeError = false;
            });
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

  void showImageSelectOption(BuildContext context) {
    ImageSelectionWidget(
      width: 150,
      height: 150,
      onImageSelection: (imageFile) {
        setState(() {
          _imageFile = imageFile;
        });
        this._handleImageUpload(imageFile);
      },
    ).show(context);
  }

  void handleSignUp(BuildContext context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    final createToken = routesArgs['createToken'];
    final fssaiDateString =
        _fssaiDate != null ? _fssaiDate.getRequestFormatDate() : '';
    try {
      setState(() {
        _isLoading = true;
      });
      final _gstString = _hasGstNumber == true ? _gstNumber : 'GSTNotRequired';
      await profileProvider.signup(
          _businessName,
          _seletedCategory,
          _firstName,
          _lastName,
          _brandName,
          phone,
          _tagline,
          downloadUrl,
          createToken,
          _seletedBusinessType,
          _gstString,
          _fssaiNumber,
          fssaiDateString,
          pdfDownloadUrl);
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
