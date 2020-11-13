import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart'
    show
        FullWidthButton,
        LoaderOverlay,
        Toast,
        BotigaTextFieldForm,
        BotigaAppBar,
        PrimaryButton,
        PassiveButton;
import '../../../util/index.dart';
import '../../../providers/index.dart' show ProfileProvider;
import './index.dart';

class SignUpBankeDetails extends StatefulWidget {
  static const routeName = 'signup-bank-detail';
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
    _accType = 'current';
    _beneficiaryName = '';
    _accountNumber = '';
    _ifscCode = '';
    _bankName = 'HDFC Bank';
    _isLoading = false;
  }

  @override
  void dispose() {
    _beneficiaryNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _ifscCodeFocusNode.dispose();
    super.dispose();
  }

  void _handleIfscCodeChange(pin) async {
    //TODO: get bank name from ifsc code
  }

  void _handleBankDetailSave(BuildContext context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    Navigator.of(context)
        .pushNamed(SetPin.routeName, arguments: {'phone': phone});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Bank Details'),
      bottomNavigationBar: Material(
        elevation: 16.0,
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
                _handleBankDetailSave(context);
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
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
                                          "Please make sure all details as per your bank account",
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
                              focusNode: _beneficiaryNameFocusNode,
                              labelText: 'Beneficiary Name',
                              onSave: (value) => _beneficiaryName = value,
                              nextFocusNode: _accountNumberFocusNode,
                              validator: nameValidator,
                              keyboardType: TextInputType.text,
                            ),
                            _sizedBox16,
                            BotigaTextFieldForm(
                              focusNode: _accountNumberFocusNode,
                              labelText: 'Account Number',
                              onSave: (value) => _accountNumber = value,
                              nextFocusNode: _ifscCodeFocusNode,
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required';
                                } else if (int.tryParse(value) == null) {
                                  return 'Please enter numbers only';
                                }
                                return null;
                              },
                            ),
                            _sizedBox16,
                            BotigaTextFieldForm(
                              focusNode: _ifscCodeFocusNode,
                              labelText: 'IFSC Code',
                              onSave: (value) => _ifscCode = value,
                              validator: nameValidator,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _accType == 'current'
                                    ? PrimaryButton(
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
                                    ? PrimaryButton(
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
                              "All the money will be credit to this bank account in T+1 day",
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
    );
  }
}
