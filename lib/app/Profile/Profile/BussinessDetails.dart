import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../../widget/index.dart';
import '../../../util/index.dart';
import '../../../providers/index.dart' show ProfileProvider, ImageService;

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
  String _seletedCategory, _brandName, _tagline, _businessName, _fullName;
  bool _isInit, _isLoading;
  FocusNode _brandNameFocusNode, _taglineFocusNode;
  String uploadurl, downloadUrl;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _picker = ImagePicker();

    maxWidthController = TextEditingController();
    maxHeightController = TextEditingController();
    qualityController = TextEditingController();

    _brandNameFocusNode = FocusNode();
    _taglineFocusNode = FocusNode();
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
    });
  }

  void _getPreSignedUrl() async {
    try {
      final value = await ImageService.getPresignedBrandImageUrl();
      setState(() {
        uploadurl = value['uploadUrl'];
        downloadUrl = value['downloadUrl'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    }
  }

  void _handleImageUpload(PickedFile file) async {
    try {
      await ImageService.uploadImageToS3(uploadurl, file);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
      setState(() {
        _imageFile = null;
      });
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
      Toast(message: Http.message(e)).show(context);
    }
    Navigator.of(context).pop();
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

  void handleBusinessInformationSave() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final updateImage = _imageFile != null ? true : false;
      await profileProvider.updateBusinessInfromation(
          _brandName, _tagline, downloadUrl, _seletedCategory, updateImage);
      await profileProvider.fetchProfile();
      Toast(message: 'Business details updated', iconData: Icons.check_circle)
          .show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0)),
                                onPressed: () {
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
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                                color: AppTheme.color05,
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(
                                    'Remove logo',
                                    style: AppTheme.textStyle.w600.color100
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
                                  showImageSelectOption();
                                },
                                color: AppTheme.color05,
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    "Change logo",
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
                      initialValue: _brandName,
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
                      initialValue: _tagline,
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
                        tileColor: AppTheme.dividerColor,
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -1),
                        trailing: Icon(Icons.keyboard_arrow_down,
                            color: AppTheme.color50),
                        title: Text(
                          '$_seletedCategory',
                          style: AppTheme.textStyle.color100.w500.size(15),
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
