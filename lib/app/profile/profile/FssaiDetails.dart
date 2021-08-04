import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';

import '../../../providers/index.dart' show ProfileProvider, ServicesProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import './fssaiCertificate.dart';

class FssaiDetails extends StatefulWidget {
  static const routeName = 'fssai-details';
  @override
  _FssaiDetailsState createState() => _FssaiDetailsState();
}

class _FssaiDetailsState extends State<FssaiDetails> {
  GlobalKey<FormState> _formKey;
  String _seletedCategory, _brandName, _tagline;
  bool _isInit, _isLoading;
  String downloadUrl;
  String _gstin, _seletedBusinessType, _fssaiNumber, _fssaiCertificateUrl;
  DateTime _fssaiDate;
  FocusNode _fssaiNumberFocusNode;
  File _pdfFile;
  String pdfUploadUrl = '', pdfDownloadUrl = '';
  PDFDocument _doc;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _fssaiNumberFocusNode = FocusNode();

    _isLoading = false;
    _isInit = false;
    loadInitialValueForForm();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedPdfUrl();
      this._getPreSignedUrl();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
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
      _gstin = profile.gstin;
      _seletedBusinessType = profile.businessType;
      _fssaiNumber = _hasValue(profile.fssaiNumber) ? profile.fssaiNumber : '';
      _fssaiDate = _hasValue(profile.fssaiValidityDate)
          ? DateTime.parse(profile.fssaiValidityDate)
          : null;

      _fssaiCertificateUrl = _hasValue(profile.fssaiCertificateUrl)
          ? profile.fssaiCertificateUrl
          : '';
      _pdfFile = null;
      PDFDocument.fromURL(_fssaiCertificateUrl).then((value) => _doc = value);
    });
  }

  void handleBusinessInformationSave() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final updateImage = false;
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
        message: 'Fssai details updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
      this.loadInitialValueForForm();
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
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
      _doc = await PDFDocument.fromFile(file);
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

  void _getPreSignedUrl() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getPresignedBrandImageUrl();
      setState(() {
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

  bool _hasValue(val) {
    if (val != null && val != '') {
      return true;
    }
    return false;
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
                      child: ActiveButton(
                          title: 'Save Details',
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              handleBusinessInformationSave();
                            }
                          })),
                ],
              ),
            ),
          ),
          appBar: BotigaAppBar(
            'FSSAI details',
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          BotigaTextFieldForm(
                            initialValue: _fssaiNumber,
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _fssaiNumberFocusNode,
                            labelText: 'FSSAI Number',
                            onChange: (value) => {
                              setState(() {
                                _fssaiNumber = value;
                              })
                            },
                            onSave: (value) => _fssaiNumber = value,
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
                                color: AppTheme.color25,
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
                                  getBotigaCalendar(
                                    context,
                                    DateTime.now(),
                                    DateTime.now()
                                        .add(const Duration(days: 3650)),
                                    DateTime.now(),
                                    (DateTime date) {
                                      setState(() {
                                        _fssaiDate = date;
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
                          SizedBox(
                            height: 24,
                          ),
                          _doc != null
                              ? ConstrainedBox(
                                  constraints: BoxConstraints.tight(
                                    Size(double.infinity, 156),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 156,
                                        height: 256,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: PDFViewer(
                                          document: _doc,
                                          showIndicator: false,
                                          showNavigation: false,
                                          showPicker: false,
                                        ),
                                      ),
                                      SizedBox(width: 12),
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
                                              height: 20,
                                            ),
                                            PassiveButton(
                                              title: "View",
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute<Null>(
                                                    builder:
                                                        (BuildContext context) {
                                                      return FssaiCertificate(
                                                          _doc);
                                                    },
                                                  ),
                                                );
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 156,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        border: Border.all(
                                          style: BorderStyle.solid,
                                          color: AppTheme.color100
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
                                                const EdgeInsets.only(top: 10),
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
                                            padding:
                                                const EdgeInsets.only(top: 10),
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
