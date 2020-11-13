import 'package:flutter/material.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart'
    show BotigaTextFieldForm, BotigaAppBar, PassiveButton, PrimaryButton;

class BankDetails extends StatefulWidget {
  static const routeName = 'bank-details';
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  final _formKey = GlobalKey<FormState>();
  String _beneficiaryName;
  String _accountNumber;
  String _ifscCode;
  String _bankName;
  String _accType;
  FocusNode _beneficiaryNameFocusNode,
      _accountNumberFocusNode,
      _ifscCodeFocusNode;

  final _sizedBox16 = SizedBox(height: 16);

  @override
  void initState() {
    super.initState();
    _beneficiaryNameFocusNode = FocusNode();
    _accountNumberFocusNode = FocusNode();
    _ifscCodeFocusNode = FocusNode();
    _beneficiaryName = 'rahul';
    _accountNumber = '***************1234';
    _ifscCode = 'ici1244';
    _bankName = 'HDFC Bank';
    _accType = 'current';
  }

  @override
  void dispose() {
    _beneficiaryNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _ifscCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Bank Details'),
      body: SingleChildScrollView(
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
                                        style: AppTheme.textStyle.w500.color100
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
                            onSave: null,
                            initialValue: _beneficiaryName,
                            readOnly: true,
                          ),
                          _sizedBox16,
                          BotigaTextFieldForm(
                            focusNode: _accountNumberFocusNode,
                            labelText: 'Account Number',
                            onSave: null,
                            initialValue: _accountNumber,
                            readOnly: true,
                          ),
                          _sizedBox16,
                          BotigaTextFieldForm(
                            focusNode: _ifscCodeFocusNode,
                            labelText: 'IFSC Code',
                            onSave: null,
                            initialValue: _ifscCode,
                            readOnly: true,
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
                                      onPressed: () {},
                                      title: 'Current',
                                      width: 156.0,
                                    )
                                  : PassiveButton(
                                      onPressed: () {},
                                      title: 'Current',
                                      height: 52,
                                      width: 156.0,
                                    ),
                              _accType == 'savings'
                                  ? PrimaryButton(
                                      onPressed: () {},
                                      title: 'Savings',
                                      width: 156.0,
                                    )
                                  : PassiveButton(
                                      onPressed: () {},
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
                            "Please contact customer care to change your bank details",
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
    );
  }
}
