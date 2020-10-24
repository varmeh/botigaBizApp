import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botiga_biz/theme/index.dart';
import 'addCommunitesSuccess.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';
import '../../../providers/Profile/StoreProvider.dart';

class AddContactDetails extends StatefulWidget {
  @override
  _AddContactDetailsState createState() => _AddContactDetailsState();
}

class _AddContactDetailsState extends State<AddContactDetails> {
  final _formKey = GlobalKey<FormState>();
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 #####-#####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _whatsappMaskFormatter = MaskTextInputFormatter(
    mask: '+91 #####-#####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _email = '', _phoneNumber = '', _watsappNumber = '';
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
  }

  void _handleStoreDetailSave(BuildContext context) {
    setState(() {
      _isLoading = true;
    });
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider
        .updateStoreDetails(
            _phoneNumber, _watsappNumber, _email, "", "", "", "", "", 0)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return AddCommunitesSuccess();
        },
      );
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: BotigaIcons.truck).show(context);
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
                            Text('Nature nest',
                                style:
                                    AppTheme.textStyle.color50.size(15).w500),
                            SizedBox(
                              height: 25,
                            ),
                            BotigaTextFieldForm(
                              focusNode: _emailFocusNode,
                              labelText: 'Email',
                              onSave: (value) => _email = value,
                              nextFocusNode: _phoneNumberFocusNode,
                              validator: emailValidator,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
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
                                  return 'Please provide a valid 10 digit Mobile Number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            BotigaTextFieldForm(
                              focusNode: _whatsappFocusNode,
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
