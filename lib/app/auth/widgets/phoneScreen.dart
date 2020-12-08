import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../theme/index.dart';
import '../../../widget/botigaTextFieldForm.dart';
import 'background.dart';

class PhoneScreen extends StatefulWidget {
  final String title;
  final Function navigate;

  PhoneScreen({@required this.title, @required this.navigate});

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  GlobalKey<FormState> _phoneFormKey;
  FocusNode _phoneFocusNode;
  final _phoneMaskFormatter = new MaskTextInputFormatter(
    mask: '+91 ##### #####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _phoneFormKey = GlobalKey<FormState>();
    _phoneFocusNode = FocusNode();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      title: widget.title,
      child: Column(
        children: [
          textField(),
          formButton(),
        ],
      ),
    );
  }

  Form textField() {
    return Form(
      key: _phoneFormKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, bottom: 30),
        child: BotigaTextFieldForm(
          icon: Icons.phone,
          onSave: (val) => null,
          focusNode: _phoneFocusNode,
          labelText: 'Phone Number',
          keyboardType: TextInputType.datetime,
          onChange: (val) {
            if (_phoneMaskFormatter.getUnmaskedText().length == 10) {
              // hide keyboard as there is no done button on number keyboard
              FocusScope.of(context).unfocus();
            }
          },
          validator: (val) {
            if (_phoneMaskFormatter.getUnmaskedText().isEmpty) {
              return 'Required';
            } else if (_phoneMaskFormatter.getUnmaskedText().length != 10) {
              return 'Please provide a valid 10 digit Mobile Number';
            }
            return null;
          },
          maskFormatter: _phoneMaskFormatter,
        ),
      ),
    );
  }

  Container formButton() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_phoneFormKey.currentState.validate()) {
            widget.navigate(_phoneMaskFormatter.getUnmaskedText());
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Continue',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }
}
