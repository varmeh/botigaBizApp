import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show ProfileProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart'
    show
        FullWidthButton,
        LoaderOverlay,
        Toast,
        BotigaTextFieldForm,
        BotigaAppBar,
        ActiveButton,
        PassiveButton;
import '../home/homeScreen.dart';

class SignUpBankeDetails extends StatefulWidget {
  static const routeName = 'signup-bank-detail';
  final bool isSignUpFlow;
  final String beneficiaryName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountType;
  SignUpBankeDetails(
      {this.beneficiaryName = '',
      this.accountNumber = '',
      this.ifscCode = '',
      this.bankName = '',
      this.accountType = 'current',
      this.isSignUpFlow = true});
  @override
  _SignUpBankeDetailsState createState() => _SignUpBankeDetailsState();
}

class _SignUpBankeDetailsState extends State<SignUpBankeDetails> {
  final _formKey = GlobalKey<FormState>();
  String _beneficiaryName, _accountNumber, _ifscCode, _accType, _bankName;

  FocusNode _beneficiaryNameFocusNode,
      _accountNumberFocusNode,
      _ifscCodeFocusNode;
  bool _isLoading;
  final _sizedBox16 = SizedBox(height: 16);

  @override
  void initState() {
    super.initState();
    _beneficiaryNameFocusNode = FocusNode();
    _accountNumberFocusNode = FocusNode();
    _ifscCodeFocusNode = FocusNode();
    _accType = widget.accountType;
    _beneficiaryName = widget.beneficiaryName;
    _accountNumber = widget.accountNumber;
    _ifscCode = widget.ifscCode;
    _bankName = widget.bankName;
    _isLoading = false;
  }

  @override
  void dispose() {
    _beneficiaryNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _ifscCodeFocusNode.dispose();
    super.dispose();
  }

  void _handleIfscCodeChange(String ifsc) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final bankDetails = await profileProvider.getBankNameFromIfsc(ifsc);
      setState(() {
        _bankName = bankDetails['BANK'];
      });
    } catch (err) {
      setState(() {
        _bankName = '';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleBankDetailSave() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.updateBankDetails(
          _beneficiaryName, _accountNumber, _ifscCode, _bankName, _accType);
      if (widget.isSignUpFlow == true) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        Toast(
          message:
              'Bank details updated. Please contact support team for bank details validation',
          icon: Icon(
            Icons.check_circle,
            size: 24,
            color: AppTheme.backgroundColor,
          ),
        ).show(context);
      }
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
        appBar: BotigaAppBar('Bank Details'),
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
                    _handleBankDetailSave();
                  }
                },
              ),
            ),
          ),
        ),
        body: GestureDetector(
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
                              Container(
                                width: double.infinity,
                                height: 75,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffFDF6EC),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Icon(Icons.info_outline),
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Please make sure all details are as per your bank account.',
                                            style: AppTheme
                                                .textStyle.w500.color100
                                                .size(13)
                                                .lineHeight(1.3),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              BotigaTextFieldForm(
                                initialValue: _beneficiaryName,
                                focusNode: _beneficiaryNameFocusNode,
                                labelText: 'Beneficiary Name',
                                onSave: (value) => _beneficiaryName = value,
                                nextFocusNode: _accountNumberFocusNode,
                                validator: emptyValidator,
                                keyboardType: TextInputType.text,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                initialValue: _accountNumber,
                                focusNode: _accountNumberFocusNode,
                                labelText: 'Account Number',
                                onSave: (value) => _accountNumber = value,
                                nextFocusNode: _ifscCodeFocusNode,
                                keyboardType: TextInputType.datetime,
                                validator: integerValidator,
                              ),
                              _sizedBox16,
                              BotigaTextFieldForm(
                                initialValue: _ifscCode,
                                focusNode: _ifscCodeFocusNode,
                                labelText: 'IFSC Code',
                                onSave: (value) => _ifscCode = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  } else if (value.length != 11) {
                                    return 'IFSC is an 11-digit alphanumeric code';
                                  }
                                  return null;
                                },
                                onChange: (value) {
                                  if (value.length == 11) {
                                    _handleIfscCodeChange(value);
                                  }
                                },
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                _bankName,
                                style: AppTheme.textStyle.w500.color100
                                    .size(13)
                                    .lineHeight(1.3),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Type of Account",
                                style: AppTheme.textStyle.w500.color100
                                    .size(15)
                                    .lineHeight(1.5),
                              ),
                              _sizedBox16,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _accType == 'current'
                                      ? ActiveButton(
                                          onPressed: () {
                                            setState(() {
                                              _accType = 'current';
                                            });
                                          },
                                          title: 'Current',
                                          width: 156.0,
                                        )
                                      : PassiveButton(
                                          onPressed: () {
                                            setState(() {
                                              _accType = 'current';
                                            });
                                          },
                                          title: 'Current',
                                          height: 52,
                                          width: 156.0,
                                        ),
                                  _accType == 'savings'
                                      ? ActiveButton(
                                          onPressed: () {
                                            setState(() {
                                              _accType = 'savings';
                                            });
                                          },
                                          title: 'Savings',
                                          width: 156.0,
                                        )
                                      : PassiveButton(
                                          onPressed: () {
                                            setState(() {
                                              _accType = 'savings';
                                            });
                                          },
                                          title: 'Savings',
                                          height: 52,
                                          width: 156.0,
                                        )
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "All the money will be credit to this bank account in T+2 days. For details, refer FAQs in profile tab.",
                                style: AppTheme.textStyle.w500.color50
                                    .size(13)
                                    .lineHeight(1.3),
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
