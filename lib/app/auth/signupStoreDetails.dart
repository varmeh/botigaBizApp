import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show ServicesProvider, ProfileProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart'
    show
        FullWidthButton,
        LoaderOverlay,
        Toast,
        BotigaTextFieldForm,
        BotigaAppBar;
import 'index.dart';

class SignUpStoreDetails extends StatefulWidget {
  static const routeName = 'signup-store-detail';
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

  TextEditingController _areaController, _cityController, _stateController;

  final _sizedBox16 = SizedBox(height: 16);

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
      mask: '+91 ##### #####',
      filter: {'#': RegExp(r'[0-9]')},
    );

    _areaController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();

    _emailFocusNode.dispose();
    _whatsappFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _buildingNumberFocusNode.dispose();
    _buildingNumberFocusNode.dispose();
    _streetNameFocusNode.dispose();
    _areaFocusNode.dispose();
    _cityFocusNode.dispose();
    _statefocusNode.dispose();

    super.dispose();
  }

  void _handlePinCodeChange(pin) async {
    setState(() => _isLoading = true);
    try {
      final value = await Provider.of<ServicesProvider>(context, listen: false)
          .getAreaFromPincode(pin);
      List postOffices = value['PostOffice'];
      if (postOffices != null) {
        final firstArea = postOffices.first;
        if (firstArea != null) {
          setState(() {
            _areaController.text = firstArea['Name'];
            _cityController.text = firstArea['District'];
            _stateController.text = firstArea['State'];
          });
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleStoreDetailSave(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.updateStoreDetails(null, _watsappNumber, _email,
          _buildingNumber, _streetName, _area, _city, _state, _pincode);
      Navigator.of(context).pushNamed(SignUpBankeDetails.routeName,
          arguments: {'phone': _watsappNumber});
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Store Details'),
      bottomNavigationBar: Material(
        elevation: 16.0,
        child: SafeArea(
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
                  _handleStoreDetailSave(context);
                }
              },
            ),
          ),
        ),
      ),
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: GestureDetector(
          onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                keyboardType: TextInputType.emailAddress,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                focusNode: _whatsappFocusNode,
                                nextFocusNode: _buildingNumberFocusNode,
                                labelText: 'Whatsapp number',
                                keyboardType: TextInputType.datetime,
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
                                    return 'Please provide a valid 10 digit Whatsapp Number';
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
                                      'Store Address',
                                      style: AppTheme.textStyle.color100
                                          .size(15)
                                          .w500,
                                    ),
                                  ),
                                ],
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                focusNode: _buildingNumberFocusNode,
                                labelText: 'Building',
                                onSave: (value) => _buildingNumber = value,
                                nextFocusNode: _streetNameFocusNode,
                                validator: emptyValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                focusNode: _streetNameFocusNode,
                                labelText: 'Street Name/Locality',
                                onSave: (value) => _streetName = value,
                                nextFocusNode: _pincodeFocusNode,
                                validator: emptyValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                focusNode: _pincodeFocusNode,
                                labelText: 'Pincode',
                                onSave: (value) => _pincode = value,
                                nextFocusNode: _areaFocusNode,
                                keyboardType: TextInputType.datetime,
                                onChange: (value) {
                                  if (value.length == 6) {
                                    FocusScope.of(context)
                                        .requestFocus(_areaFocusNode);
                                    _handlePinCodeChange(value);
                                  }
                                },
                                validator: integerValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                readOnly: _isLoading,
                                textEditingController: _areaController,
                                focusNode: _areaFocusNode,
                                labelText: 'Area',
                                onSave: (value) => _area = value,
                                nextFocusNode: _cityFocusNode,
                                validator: emptyValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                readOnly: _isLoading,
                                textEditingController: _cityController,
                                focusNode: _cityFocusNode,
                                labelText: 'City',
                                onSave: (value) => _city = value,
                                nextFocusNode: _statefocusNode,
                                validator: nameValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                readOnly: _isLoading,
                                textEditingController: _stateController,
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
      ),
    );
  }
}
