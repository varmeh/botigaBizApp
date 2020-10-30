import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../../Home/HomeScreen.dart";
import "./ForgotPin.dart";
import '../../../widget/index.dart';
import '../../Auth/widgets/index.dart';
import '../../../providers/AuthProvider.dart';

class EnterPin extends StatefulWidget {
  static const routeName = '/login-enter-pin';
  @override
  _EnterPinState createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  GlobalKey<FormState> _form;
  String pinValue;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _form = GlobalKey();
    pinValue = '';
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signInWithPin(phone, pinValue).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(message: '$error', iconData: Icons.error_outline_outlined)
          .show(context);
    });
  }

  Form pinForm() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 4,
        onSaved: (val) => pinValue = val,
      ),
    );
  }

  Container continueBtn(Function onContinue) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            onContinue();
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 14),
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

  @override
  Widget build(BuildContext context) {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    const sizedBox = SizedBox(height: 20);
    return Background(
      title: 'Enter PIN',
      backNavigation: true,
      child: LoaderOverlay(
        isLoading: _isLoading,
        child: Column(
          children: [
            sizedBox,
            Text(
              'Please enter your PIN to login',
              style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
            ),
            sizedBox,
            Center(child: Container(width: 200, child: pinForm())),
            sizedBox,
            continueBtn(this._handleLogin),
            sizedBox,
            FlatButton(
              child: Text('Forgot PIN?',
                  style: AppTheme.textStyle
                      .size(15)
                      .w600
                      .colored(AppTheme.primaryColor)),
              onPressed: () {
                Navigator.of(context).pushNamed(LoginForgotPin.routeName,
                    arguments: {'phone': phone});
              },
            ),
          ],
        ),
      ),
    );
  }
}
