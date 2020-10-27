import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botiga_biz/theme/index.dart';
import 'addCommunitesSuccess.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import '../../../providers/Profile/ProfileProvider.dart';

class AddContactDetails extends StatefulWidget {
  final String apartmentId;
  final String deliveryType;
  final int day;
  AddContactDetails(
      {@required this.apartmentId,
      @required this.deliveryType,
      @required this.day});
  @override
  _AddContactDetailsState createState() => _AddContactDetailsState();
}

class _AddContactDetailsState extends State<AddContactDetails> {
  final _formKey = GlobalKey<FormState>();
  MaskTextInputFormatter _phoneMaskFormatter;
  MaskTextInputFormatter _whatsappMaskFormatter;

  String _email, _phoneNumber, _watsappNumber, _businessName;
  FocusNode _emailFocusNode, _whatsappFocusNode, _phoneNumberFocusNode;
  bool _isLoading;
  bool checkboxValue;

  @override
  void initState() {
    super.initState();
    _phoneNumberFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _whatsappFocusNode = FocusNode();
    _isLoading = false;
    checkboxValue = false;
    loadInitialFormValues();
  }

  void loadInitialFormValues() {
    final profileInfo =
        Provider.of<ProfileProvider>(context, listen: false).profileInfo;
    setState(() {
      _email = profileInfo.contact.email;
      _phoneNumber = profileInfo.contact.phone;
      _watsappNumber = profileInfo.contact.whatsapp;
      _businessName = profileInfo.businessName;
    });
    _phoneMaskFormatter = MaskTextInputFormatter(
        mask: '+91 #####-#####',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: profileInfo.contact.phone);

    _whatsappMaskFormatter = MaskTextInputFormatter(
        mask: '+91 #####-#####',
        filter: {"#": RegExp(r'[0-9]')},
        initialText: profileInfo.contact.whatsapp);
  }

  void _handleStoreDetailSave(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    final whatsappNumber = checkboxValue ? _phoneNumber : _watsappNumber;

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider
        .addApartment(widget.apartmentId, _phoneNumber, whatsappNumber, _email,
            widget.deliveryType, widget.day)
        .then((value) {
      profileProvider.fetchProfile().then((_) {
        setState(() {
          _isLoading = false;
        });
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (builder) {
            return AddCommunitesSuccess(
                _businessName, widget.deliveryType, widget.day);
          },
        );
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        Toast(message: '$error', iconData: Icons.error_outline).show(context);
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.all(10),
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
                            this._handleStoreDetailSave(context);
                          }
                        },
                        color: AppTheme.primaryColor,
                        child: Text('Enable Community',
                            style: AppTheme.textStyle
                                .colored(AppTheme.backgroundColor)
                                .size(15)
                                .w600),
                      ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 28),
                              child: Text('Contact Details',
                                  style: AppTheme.textStyle.color100
                                      .size(22)
                                      .w700),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text('$_businessName',
                                style:
                                    AppTheme.textStyle.color50.size(15).w500),
                            SizedBox(
                              height: 25,
                            ),
                            BotigaTextFieldForm(
                              initialValue: _email,
                              focusNode: _emailFocusNode,
                              nextFocusNode: _phoneNumberFocusNode,
                              labelText: 'Email',
                              onSave: (value) => _email = value,
                              validator: emailValidator,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            checkboxValue
                                ? BotigaTextFieldForm(
                                    initialValue:
                                        _phoneMaskFormatter.getMaskedText(),
                                    focusNode: _phoneNumberFocusNode,
                                    readOnly: true,
                                    labelText: 'Phone number',
                                    keyboardType: TextInputType.number,
                                    onSave: (_) => null,
                                  )
                                : SizedBox.shrink(),
                            !checkboxValue
                                ? BotigaTextFieldForm(
                                    initialValue:
                                        _phoneMaskFormatter.getMaskedText(),
                                    focusNode: _phoneNumberFocusNode,
                                    nextFocusNode: _whatsappFocusNode,
                                    labelText: 'Phone number',
                                    keyboardType: TextInputType.number,
                                    onSave: (_) => _phoneNumber =
                                        _phoneMaskFormatter.getUnmaskedText(),
                                    maskFormatter: _phoneMaskFormatter,
                                    validator: (_) {
                                      if (_phoneMaskFormatter
                                          .getUnmaskedText()
                                          .isEmpty) {
                                        return 'Required';
                                      } else if (_phoneMaskFormatter
                                              .getUnmaskedText()
                                              .length !=
                                          10) {
                                        return 'Please provide a valid 10 digit phone Number';
                                      }
                                      return null;
                                    },
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 16,
                            ),
                            checkboxValue
                                ? BotigaTextFieldForm(
                                    initialValue:
                                        _phoneMaskFormatter.getMaskedText(),
                                    focusNode: _phoneNumberFocusNode,
                                    readOnly: true,
                                    labelText: 'Whatsapp number',
                                    keyboardType: TextInputType.number,
                                    onSave: (_) => null,
                                  )
                                : SizedBox.shrink(),
                            !checkboxValue
                                ? BotigaTextFieldForm(
                                    initialValue:
                                        _whatsappMaskFormatter.getMaskedText(),
                                    focusNode: _whatsappFocusNode,
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
