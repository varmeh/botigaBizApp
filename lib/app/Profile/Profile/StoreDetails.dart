import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/index.dart';
import '../../../util/index.dart';
import '../../../providers/index.dart' show ServicesProvider, ProfileProvider;

class StoreDeatils extends StatefulWidget {
  static const routeName = 'add-store-details';
  @override
  _StoreDeatilsState createState() => _StoreDeatilsState();
}

class _StoreDeatilsState extends State<StoreDeatils> {
  final _formKey = GlobalKey<FormState>();
  MaskTextInputFormatter _phoneMaskFormatter;
  MaskTextInputFormatter _whatsappMaskFormatter;

  String _email = '',
      _phoneNumber = '',
      _watsappNumber = '',
      _buildingNumber = '',
      _streetName = '',
      _area = '',
      _city = '',
      _state = '',
      _pincode = '';

  FocusNode _emailFocusNode,
      _whatsappFocusNode,
      _pincodeFocusNode,
      _buildingNumberFocusNode,
      _streetNameFocusNode,
      _areaFocusNode,
      _cityFocusNode,
      _statefocusNode,
      _phoneNumberFocusNode;
  bool _isLoading;
  bool checkboxValue;

  @override
  void initState() {
    super.initState();
    _phoneNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _whatsappFocusNode = FocusNode();
    _pincodeFocusNode = FocusNode();
    _buildingNumberFocusNode = FocusNode();
    _streetNameFocusNode = FocusNode();
    _areaFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _statefocusNode = FocusNode();
    _isLoading = false;
    checkboxValue = false;
    loadInitialFormValues();
  }

  @override
  void dispose() {
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _whatsappFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _buildingNumberFocusNode.dispose();
    _streetNameFocusNode.dispose();
    _areaFocusNode.dispose();
    _cityFocusNode.dispose();
    _statefocusNode.dispose();

    super.dispose();
  }

  void loadInitialFormValues() {
    final contactInfo = Provider.of<ProfileProvider>(context, listen: false)
        .profileInfo
        .contact;
    setState(() {
      _email = contactInfo.email;
      _phoneNumber = contactInfo.phone;
      _watsappNumber = contactInfo.whatsapp;
      _buildingNumber = contactInfo.address.building;
      _streetName = contactInfo.address.street;
      _area = contactInfo.address.area;
      _city = contactInfo.address.city;
      _state = contactInfo.address.state;
      _pincode = contactInfo.address.pincode;
    });
    _phoneMaskFormatter = MaskTextInputFormatter(
        mask: '+91 #####-#####',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: '91${contactInfo.phone}');

    _whatsappMaskFormatter = MaskTextInputFormatter(
        mask: '+91 #####-#####',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: '91${contactInfo.whatsapp}');
  }

  void _handlePinCodeChange(pin) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getAreaFromPincode(pin);
      List postOffices = value['PostOffice'];
      if (postOffices != null) {
        final firstArea = postOffices.first;
        if (firstArea != null) {
          setState(() {
            _area = firstArea['Name'];
          });
        }
      }
    } catch (err) {} finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleStoreDetailSave() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String whatsapp = checkboxValue ? _phoneNumber : _watsappNumber;
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.updateStoreDetails(_phoneNumber, whatsapp, _email,
          _buildingNumber, _streetName, _area, _city, _state, _pincode);
      await profileProvider.fetchProfile();
      Toast(message: 'Store details updated', iconData: Icons.check_circle)
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
        backgroundColor: AppTheme.backgroundColor,
        appBar: BotigaAppBar('Store details'),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(6.0)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              this._handleStoreDetailSave();
                            }
                          },
                          color: AppTheme.primaryColor,
                          child: Text('Save and continue',
                              style: AppTheme.textStyle
                                  .size(15)
                                  .w600
                                  .colored(AppTheme.backgroundColor))),
                    ),
                  ),
                ],
              )),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            BotigaTextFieldForm(
                              initialValue: _email,
                              focusNode: _emailFocusNode,
                              labelText: 'Email',
                              onSave: (value) => _email = value,
                              nextFocusNode: _whatsappFocusNode,
                              validator: emailValidator,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              readOnly: true,
                              initialValue: _phoneMaskFormatter.getMaskedText(),
                              focusNode: _phoneNumberFocusNode,
                              labelText: 'Phone number',
                              onSave: (_) => null,
                              maskFormatter: _phoneMaskFormatter,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            checkboxValue
                                ? BotigaTextFieldForm(
                                    readOnly: true,
                                    initialValue:
                                        _phoneMaskFormatter.getMaskedText(),
                                    focusNode: _phoneNumberFocusNode,
                                    labelText: 'Whatsapp number',
                                    onSave: (_) => null,
                                    maskFormatter: _phoneMaskFormatter,
                                  )
                                : SizedBox.shrink(),
                            !checkboxValue
                                ? BotigaTextFieldForm(
                                    initialValue:
                                        _whatsappMaskFormatter.getMaskedText(),
                                    focusNode: _whatsappFocusNode,
                                    nextFocusNode: _buildingNumberFocusNode,
                                    labelText: 'Whatsapp number',
                                    keyboardType: TextInputType.number,
                                    onSave: (_) => _watsappNumber =
                                        _whatsappMaskFormatter
                                            .getUnmaskedText(),
                                    maskFormatter: _whatsappMaskFormatter,
                                    validator: (_) {
                                      if (_whatsappMaskFormatter
                                          .getUnmaskedText()
                                          .isEmpty) {
                                        return 'Required';
                                      } else if (_whatsappMaskFormatter
                                              .getUnmaskedText()
                                              .length !=
                                          10) {
                                        return 'Please provide a valid 10 digit Watsapp Number';
                                      }
                                      return null;
                                    },
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                checkboxValue = !checkboxValue;
                              });
                            },
                            child: checkboxValue
                                ? Icon(
                                    Icons.check_box,
                                    color: AppTheme.primaryColor,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank_rounded,
                                    color: AppTheme.color100,
                                    size: 30,
                                  ),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                                "Whatsapp number same as phone number above",
                                style: AppTheme.textStyle.color100
                                    .size(14)
                                    .w500
                                    .lineHeight(1.5)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Store Address",
                              style: AppTheme.textStyle.color100.size(15).w500,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              initialValue: _buildingNumber,
                              focusNode: _buildingNumberFocusNode,
                              labelText: 'Building No.',
                              onSave: (value) => _buildingNumber = value,
                              nextFocusNode: _streetNameFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                } else if (int.tryParse(value) == null) {
                                  return 'Please enter numbers only';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              initialValue: _streetName,
                              focusNode: _streetNameFocusNode,
                              labelText: 'Street Name/Locality',
                              onSave: (value) => _streetName = value,
                              nextFocusNode: _pincodeFocusNode,
                              validator: nameValidator,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                                initialValue: _pincode,
                                focusNode: _pincodeFocusNode,
                                labelText: 'Pincode',
                                onSave: (value) => _pincode = value,
                                nextFocusNode: _areaFocusNode,
                                keyboardType: TextInputType.number,
                                onChange: (value) {
                                  _handlePinCodeChange(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  } else if (int.tryParse(value) == null) {
                                    return 'Please enter numbers only';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 16,
                            ),
                            _isLoading
                                ? BotigaTextFieldForm(
                                    readOnly: true,
                                    initialValue: _area,
                                    focusNode: _areaFocusNode,
                                    labelText: 'Area',
                                    onSave: (value) => null,
                                  )
                                : SizedBox.shrink(),
                            !_isLoading
                                ? BotigaTextFieldForm(
                                    initialValue: _area,
                                    focusNode: _areaFocusNode,
                                    labelText: 'Area',
                                    onSave: (value) => _area = value,
                                    nextFocusNode: _cityFocusNode,
                                    validator: nameValidator,
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              initialValue: _city,
                              focusNode: _cityFocusNode,
                              labelText: 'City',
                              onSave: (value) => _city = value,
                              nextFocusNode: _statefocusNode,
                              validator: nameValidator,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              initialValue: _state,
                              focusNode: _statefocusNode,
                              labelText: 'State',
                              onSave: (value) => _state = value,
                              validator: nameValidator,
                            ),
                          ],
                        ),
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
}
