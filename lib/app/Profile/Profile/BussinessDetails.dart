import 'dart:io';
import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../../widget/index.dart';
import '../../../util/index.dart';
import 'package:image_picker/image_picker.dart';
import '../../../providers/Profile/BusinessProvider.dart';
import '../../../providers/Services/ImageService.dart';

class BussinessDetails extends StatefulWidget {
  static const routeName = '/business-details';
  @override
  _BussinessDetailsState createState() => _BussinessDetailsState();
}

class _BussinessDetailsState extends State<BussinessDetails> {
  GlobalKey<FormState> _formKey;
  ImagePicker _picker;
  PickedFile _imageFile;
  TextEditingController maxWidthController,
      maxHeightController,
      qualityController;
  String _seletedCategory, _brandName, _tagline;
  bool _isInit, _isLoading;
  FocusNode _brandNameFocusNode, _taglineFocusNode;
  String uploadurl, downloadUrl;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _picker = ImagePicker();
    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();

    _brandName = '';
    _tagline = '';
    _seletedCategory = 'Beverages';
    _brandNameFocusNode = FocusNode();
    _taglineFocusNode = FocusNode();
    _isLoading = false;
    _isInit = false;
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
    ImageService.getPresignedImageUrl().then((value) {
      print(value);
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    }).catchError((error) {
      Toast(message: '$error', iconData: Icons.error_outline).show(context);
    });
  }

  void _handleImageUpload(PickedFile file) {
    ImageService.uploadImageToS3(uploadurl, file).then((value) {
      print(value);
    }).catchError((error) {
      Toast(message: '$error', iconData: Icons.error_outline_sharp)
          .show(context);
      setState(() {
        _imageFile = null;
      });
    });
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
              String bsCategoryName = '';
              FocusNode bsCategoryNode = FocusNode();
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
                          BotigaTextFieldForm(
                            focusNode: bsCategoryNode,
                            labelText: "Write your business category",
                            onSave: (value) => bsCategoryName = value,
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
                                            _seletedCategory = bsCategoryName;
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

  void showImageSelectOption() {
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
          ),
        ),
      ),
    );
  }

  void handleBusinessInformationSave() {
    setState(() {
      _isLoading = true;
    });
    final businessProvider =
        Provider.of<BusinessProvider>(context, listen: false);
    businessProvider
        .updateBusinessInfromation(
            _brandName, _tagline, 'https://s3.com/durl', _seletedCategory)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '${value['message']}', iconData: Icons.error_outline)
          .show(context);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline).show(context);
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
                      if (_isLoading) {
                        return null;
                      }
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        handleBusinessInformationSave();
                      }
                    },
                    color: _isLoading
                        ? AppTheme.dividerColor
                        : AppTheme.primaryColor,
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
        child: Stack(
          children: [
            Form(
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
                              if (_isLoading) {
                                return null;
                              }
                              showImageSelectOption();
                            },
                            color: AppTheme.color05,
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text('Change logo',
                                  style: AppTheme.textStyle.w600.color100
                                      .size(15)),
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            onPressed: () {
                              if (_isLoading) {
                                return null;
                              }
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            color: AppTheme.color05,
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Text(
                                'Remove logo',
                                style:
                                    AppTheme.textStyle.w600.color100.size(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      BotigaTextFieldForm(
                        focusNode: _brandNameFocusNode,
                        labelText: "Brand name",
                        onSave: (value) => _brandName = value,
                        validator: nameValidator,
                        nextFocusNode: _taglineFocusNode,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      BotigaTextFieldForm(
                        focusNode: _taglineFocusNode,
                        labelText: "Tagline",
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
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                )
                              : Text(
                                  '$_seletedCategory',
                                  style:
                                      AppTheme.textStyle.color100.w500.size(15),
                                ),
                        ),
                      ),
                    ],
                  )),
            ),
            _isLoading ? Loader() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
