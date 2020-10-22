import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'addCommunitesSuccess.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';

class AddContactDetails extends StatefulWidget {
  @override
  _AddContactDetailsState createState() => _AddContactDetailsState();
}

class _AddContactDetailsState extends State<AddContactDetails> {
  bool checkboxValue, _isLoading;
  GlobalKey<FormState> _formKey;
  String _contactName, _email, _phone, _watsapp;
  FocusNode _contactNameFocusNode,
      _emailFocusNode,
      _phoneFocusNode,
      _watsappFocusNode;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _contactName = '';
    _email = '';
    _phone = '';
    _watsapp = '';
    checkboxValue = false;
    _isLoading = false;
    _contactNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _watsappFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Contact Details',
                      style: AppTheme.textStyle.color100.size(22).w700),
                  SizedBox(
                    height: 8,
                  ),
                  Text('Nature nest',
                      style: AppTheme.textStyle.color50.size(15).w500),
                  SizedBox(
                    height: 25,
                  ),
                  BotigaTextFieldForm(
                    focusNode: _contactNameFocusNode,
                    labelText: 'Contact Name',
                    onSave: (value) => _contactName = value,
                    nextFocusNode: _emailFocusNode,
                    validator: nameValidator,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BotigaTextFieldForm(
                    focusNode: _emailFocusNode,
                    labelText: 'Email',
                    onSave: (value) => _email = value,
                    nextFocusNode: _phoneFocusNode,
                    validator: emailValidator,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BotigaTextFieldForm(
                    focusNode: _phoneFocusNode,
                    labelText: 'Phone number',
                    onSave: (value) => _phone = value,
                    nextFocusNode: _watsappFocusNode,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BotigaTextFieldForm(
                    focusNode: _watsappFocusNode,
                    labelText: 'Whatsapp number',
                    onSave: (value) => _watsapp = value,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            checkboxValue = !checkboxValue;
                            _watsapp = _phone;
                          });
                        },
                        child: checkboxValue
                            ? Icon(
                                Icons.check_box,
                                color: AppTheme.primaryColor,
                                size: 30,
                              )
                            : Icon(
                                Icons.check_box_outline_blank,
                                color: AppTheme.color100,
                                size: 30,
                              ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                            "Whatsapp number same as phone number above",
                            style: AppTheme.textStyle.color100
                                .size(15)
                                .w500
                                .lineHeight(1.5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SafeArea(
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
            )
          ],
        ),
      ),
    );
  }
}
