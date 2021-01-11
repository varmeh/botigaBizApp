import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:file_picker/file_picker.dart';

import '../../../providers/index.dart' show ProfileProvider, ServicesProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';

class BussinessDetails extends StatefulWidget {
  static const routeName = 'business-details';
  @override
  _BussinessDetailsState createState() => _BussinessDetailsState();
}

class _BussinessDetailsState extends State<BussinessDetails> {
  GlobalKey<FormState> _formKey;
  File _imageFile;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;
  String _seletedCategory, _brandName, _tagline, _businessName, _fullName;
  bool _isInit, _isLoading;
  FocusNode _brandNameFocusNode, _taglineFocusNode;
  String uploadurl, downloadUrl;
  String _imageUrl;

  String _gstin, _seletedBusinessType, _fssaiNumber, _fssaiCertificateUrl;
  DateTime _fssaiDate;
  FocusNode _gstinFocusNode, _fssaiNumberFocusNode;

  bool _businessTypeError = false,
      _fssaiDateError = false,
      _fssiCertificateError = false,
      _fssaiNumberError = false;
  File _pdfFile;
  String pdfUploadUrl = '', pdfDownloadUrl = '';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();

    _brandNameFocusNode = FocusNode();
    _taglineFocusNode = FocusNode();
    _gstinFocusNode = FocusNode();
    _fssaiNumberFocusNode = FocusNode();

    _isLoading = false;
    _isInit = false;
    loadInitialValueForForm();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedUrl();
      this._getPreSignedPdfUrl();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    _brandNameFocusNode.dispose();
    _taglineFocusNode.dispose();
    _gstinFocusNode.dispose();
    _fssaiNumberFocusNode.dispose();

    super.dispose();
  }

  void loadInitialValueForForm() {
    final profile =
        Provider.of<ProfileProvider>(context, listen: false).profileInfo;
    setState(() {
      _brandName = profile.brand.name;
      _tagline = profile.brand.tagline;
      _seletedCategory = profile.businessCategory;
      _businessName = profile.businessName;
      _fullName = '${profile.firstName} ${profile.lastName}';
      _imageUrl = profile.brand.imageUrl;
      _gstin = _hasValue(profile.gstin) ? profile.gstin : '';
      _seletedBusinessType =
          _hasValue(profile.businessType) ? profile.businessType : '';
      _fssaiNumber = _hasValue(profile.fssaiNumber) ? profile.fssaiNumber : '';
      _fssaiDate = _hasValue(profile.fssaiValidityDate)
          ? DateTime.parse(profile.fssaiValidityDate)
          : null;
      _fssaiCertificateUrl = _hasValue(profile.fssaiCertificateUrl)
          ? profile.fssaiCertificateUrl
          : '';
    });
  }

  void _getPreSignedUrl() async {
    setState(() {
      _isLoading = true;
    });
    try {
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

  void showImageSelectOption() {
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

  void handleBusinessInformationSave() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final updateImage = _imageFile != null ? true : false;
      final fssaiCertUrl =
          _pdfFile != null ? pdfDownloadUrl : _fssaiCertificateUrl;
      final fssaiDateString =
          _fssaiDate != null ? _fssaiDate.getRequestFormatDate() : '';
      await profileProvider.updateBusinessInfromation(
          _brandName,
          _tagline,
          downloadUrl,
          _seletedCategory,
          updateImage,
          _seletedBusinessType,
          _gstin,
          _fssaiNumber,
          fssaiDateString,
          fssaiCertUrl);
      await profileProvider.fetchProfile();
      Toast(
        message: 'Business details updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  bool _hasValue(val) {
    if (val != null && val != '') {
      return true;
    }
    return false;
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
    return LoaderOverlay(
      isLoading: _isLoading,
      child: GestureDetector(
        onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppTheme.backgroundColor,
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
                          if (_hasValue(_seletedBusinessType) == false) {
                            setState(() {
                              _businessTypeError = true;
                            });
                            return null;
                          }

                          if (_hasValue(_fssaiNumber) == true &&
                              _hasValue(_fssaiDate) == true &&
                              _hasValue(_pdfFile) == true) {
                            //Alow check to pass
                          } else {
                            if (_hasValue(_fssaiNumber) == false &&
                                _hasValue(_fssaiDate) == false &&
                                _hasValue(_pdfFile) == false) {
                              //Alow check to pass
                            } else {
                              setState(() {
                                _fssaiNumberError = !_hasValue(_fssaiNumber);
                                _fssaiDateError = !_hasValue(_fssaiDate);
                                _fssiCertificateError = !_hasValue(_pdfFile);
                              });
                              return null;
                            }
                          }

                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleBusinessInformationSave();
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
          appBar: BotigaAppBar(
            'Business details',
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      color: AppTheme.backgroundColor,
                      child: Column(
                        children: <Widget>[
                          _imageFile != null
                              ? Container(
                                  height: 96,
                                  width: 96,
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 20),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    child: Image.file(
                                      File(_imageFile.path),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                )
                              : ProfileNetworkAvatar(
                                  imageUrl: _imageUrl,
                                ),
                          Container(
                            child: Text(
                              '$_businessName',
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyle.w700.size(17),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('$_fullName',
                              textAlign: TextAlign.center,
                              style: AppTheme.textStyle.w500.size(13).color50),
                          SizedBox(
                            height: 24,
                          ),
                          _imageFile != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0)),
                                      onPressed: () {
                                        showImageSelectOption();
                                      },
                                      color: AppTheme.color05,
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Text('Change logo',
                                            style: AppTheme
                                                .textStyle.w600.color100
                                                .size(15)),
                                      ),
                                    ),
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
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
                                          style: AppTheme
                                              .textStyle.w600.color100
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
                                        showImageSelectOption();
                                      },
                                      color: AppTheme.color05,
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Text(
                                          'Change logo',
                                          style: AppTheme
                                              .textStyle.color100.w600
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
                            initialValue: _brandName,
                            focusNode: _brandNameFocusNode,
                            labelText: 'Brand name',
                            onSave: (value) => _brandName = value,
                            validator: emptyValidator,
                            nextFocusNode: _taglineFocusNode,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          BotigaTextFieldForm(
                            initialValue: _tagline,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _taglineFocusNode,
                            labelText: 'Tagline',
                            onSave: (value) => _tagline = value,
                            validator: emptyValidator,
                            nextFocusNode: _gstinFocusNode,
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
                              contentPadding:
                                  EdgeInsets.only(top: 4, bottom: 4, left: 8),
                              tileColor: AppTheme.dividerColor,
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: -1),
                              trailing: Icon(Icons.keyboard_arrow_down,
                                  color: AppTheme.color50),
                              title: Text(
                                '$_seletedCategory',
                                style:
                                    AppTheme.textStyle.color100.w500.size(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          BotigaTextFieldForm(
                            initialValue: _gstin,
                            focusNode: _gstinFocusNode,
                            labelText: 'GST No.',
                            onSave: (value) => _gstin = value,
                            validator: emptyValidator,
                          ),
                          SizedBox(
                            height: 24,
                          ),
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
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppTheme.dividerColor,
                      thickness: 4,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            title: Text(
                              "FSSAI DETAILS",
                              style: AppTheme.textStyle.w700.color100
                                  .size(12)
                                  .lineHeight(1.2)
                                  .letterSpace(0.2),
                            ),
                            subtitle: Text(
                              "Fill only if you are are in Food Business",
                              style: AppTheme.textStyle.w500.color50
                                  .size(12)
                                  .lineHeight(1.2)
                                  .letterSpace(0.2),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: _fssaiNumberError
                                    ? AppTheme.errorColor
                                    : AppTheme.color25,
                                width: 1.0,
                              ),
                            ),
                            child: BotigaTextFieldForm(
                                initialValue: _fssaiNumber,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                focusNode: _fssaiNumberFocusNode,
                                labelText: 'FSSAI Number',
                                onChange: (value) => _fssaiNumber = value,
                                onSave: (value) => _fssaiNumber = value,
                                hideBorder: true),
                          ),
                          _getErrorText(_fssaiNumberError),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.5),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: _fssaiDateError
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
                                  DateTime selectedDate = _fssaiDate == null
                                      ? DateTime.now()
                                      : _fssaiDate;
                                  getBotigaCalendar(
                                    context,
                                    DateTime.now(),
                                    DateTime.now()
                                        .add(const Duration(days: 3650)),
                                    selectedDate,
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
                                        style: AppTheme.textStyle.color50.w500
                                            .size(15),
                                      )
                                    : Text(
                                        '${_fssaiDate.getRequestFormatDate()}',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      ),
                              ),
                            ),
                          ),
                          _getErrorText(_fssaiDateError),
                          SizedBox(
                            height: 24,
                          ),
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
                                              BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          child: PDF.file(
                                            _pdfFile,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            PassiveButton(
                                              title: "Change",
                                              onPressed: () {
                                                handlePdfChange();
                                              },
                                              height: 44,
                                              width: 135,
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
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
                              : (_fssaiCertificateUrl != null &&
                                      _fssaiCertificateUrl != '')
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
                                                  BorderRadius.circular(8),
                                            ),
                                            child: PDF.network(
                                              _fssaiCertificateUrl,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                PassiveButton(
                                                  title: "Change",
                                                  onPressed: () {
                                                    handlePdfChange();
                                                  },
                                                  height: 44,
                                                  width: 135,
                                                ),
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
                                                BorderRadius.circular(8.0),
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
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  'Upload FSSAI certificate',
                                                  textAlign: TextAlign.center,
                                                  style: AppTheme
                                                      .textStyle.color50.w500
                                                      .size(12)
                                                      .letterSpace(0.2)
                                                      .lineHeight(1.5),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  '* only pdf',
                                                  textAlign: TextAlign.center,
                                                  style: AppTheme
                                                      .textStyle.color100.w500
                                                      .size(10)
                                                      .letterSpace(0.2)
                                                      .lineHeight(1.2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _getErrorText(_fssaiDateError),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
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
}
