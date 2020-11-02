import 'package:botiga_biz/util/httpService.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SetPin.dart';
import '../../../widget/index.dart'
    show
        FullWidthButton,
        LoaderOverlay,
        Toast,
        BotigaTextFieldForm,
        BotigaAppBar;
import '../../../util/FormValidators.dart';
import '../../../providers/index.dart' show PinService, ProfileProvider;

class SignUpStoreDetails extends StatefulWidget {
  static const routeName = '/signup-store-detail';
  @override
  _SignUpStoreDetailsState createState() => _SignUpStoreDetailsState();
}

class _SignUpStoreDetailsState extends State<SignUpStoreDetails> {
  final _formKey = GlobalKey<FormState>();
  String _email = '',
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
      _statefocusNode;
  bool _isLoading;
  MaskTextInputFormatter _whatsappMaskFormatter;

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _whatsappFocusNode = FocusNode();
    _pincodeFocusNode = FocusNode();
    _buildingNumberFocusNode = FocusNode();
    _streetNameFocusNode = FocusNode();
    _areaFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _statefocusNode = FocusNode();
    _isLoading = false;
    _whatsappMaskFormatter = MaskTextInputFormatter(
      mask: '+91 #####-#####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  void _handlePinCodeChange(pin) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final value = await PinService.getAreaFromPincode(pin);
      List postOffices = value['PostOffice'];
      if (postOffices != null) {
        final firstArea = postOffices.first;
        if (firstArea != null) {
          setState(() {
            _area = firstArea['Name'];
          });
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleStoreDetailSave(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.updateStoreDetails(null, _watsappNumber, _email,
          _buildingNumber, _streetName, _area, _city, _state, _pincode);
      Navigator.of(context)
          .pushNamed(SetPin.routeName, arguments: {'phone': _watsappNumber});
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Store Details'),
      bottomNavigationBar: Material(
        elevation: 16.0,
        child: Container(
          color: AppTheme.backgroundColor,
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 32.0,
          ),
          child: FullWidthButton(
            title: 'Save and continue',
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _handleStoreDetailSave(context);
              }
            },
          ),
        ),
      ),
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
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
                              focusNode: _whatsappFocusNode,
                              nextFocusNode: _buildingNumberFocusNode,
                              labelText: 'Whatsapp number',
                              keyboardType: TextInputType.number,
                              onSave: (_) => _watsappNumber =
                                  _whatsappMaskFormatter.getUnmaskedText(),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Divider(
                        color: AppTheme.dividerColor,
                        thickness: 8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    "Store Address",
                                    style: AppTheme.textStyle.color100
                                        .size(15)
                                        .w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
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
