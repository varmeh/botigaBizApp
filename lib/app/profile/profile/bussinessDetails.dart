import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  String _gstin, _seletedBusinessType;
  FocusNode _gstinFocusNode;

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
    _isLoading = false;
    _isInit = false;
    loadInitialValueForForm();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getPreSignedUrl();
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
      await profileProvider.updateBusinessInfromation(
          _brandName,
          _tagline,
          downloadUrl,
          _seletedCategory,
          updateImage,
          _seletedBusinessType,
          _gstin,
          null,
          null,
          null);
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
                    child: SizedBox(
                      height: 52,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            handleBusinessInformationSave();
                          }
                        },
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
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        backgroundColor: AppTheme.color05,
                                      ),
                                      onPressed: () {
                                        showImageSelectOption();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Text('Change logo',
                                            style: AppTheme
                                                .textStyle.w600.color100
                                                .size(15)),
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        backgroundColor: AppTheme.color05,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      },
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
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(6.0),
                                        ),
                                        backgroundColor: AppTheme.color05,
                                      ),
                                      onPressed: () {
                                        showImageSelectOption();
                                      },
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
                              color: AppTheme.dividerColor,
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
                                trailing: Icon(Icons.keyboard_arrow_down,
                                    color: AppTheme.color50),
                                title: Text(
                                  '$_seletedCategory',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                ),
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
                              color: AppTheme.dividerColor,
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
                                trailing: Icon(Icons.keyboard_arrow_down,
                                    color: AppTheme.color50),
                                title: Text(
                                  '$_seletedBusinessType',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
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
