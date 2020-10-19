import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botiga_biz/theme/index.dart';
import '../Signup/SetPin.dart';
import '../../Auth/widgets/index.dart';
import '../../../widget/index.dart';
import '../../../providers/Auth/AuthProvider.dart';

class LoginForgotPin extends StatefulWidget {
  static const routeName = '/forgot-pin';
  @override
  _LoginForgotPinState createState() => _LoginForgotPinState();
}

class _LoginForgotPinState extends State<LoginForgotPin> {
  GlobalKey<FormState> _form = GlobalKey();
  String sessionId;
  String pinValue;
  bool _isInit;
  bool _isLoading;

  Timer _timer;
  int _start;

  @override
  void initState() {
    super.initState();
    sessionId = '';
    pinValue = '';
    _isInit = false;
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      this._getOTP();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) =>
          setState(() => _start < 1 ? _timer.cancel() : _start = _start - 1),
    );
  }

  void _verifyOTP() {
    setState(() {
      _isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    authProvider.verifyOtp(phone, sessionId, pinValue).then((value) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, SetPin.routeName,
          arguments: {'phone': phone});
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Toast(iconData: BotigaIcons.truck, message: '$error');
    });
  }

  void _getOTP() {
    startTimer();
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phone = routesArgs['phone'];
    authProvider.getOTP(phone).then((value) {
      setState(() {
        sessionId = value['sessionId'];
      });
    }).catchError((error) {
      Toast(iconData: BotigaIcons.truck, message: '$error').show(context);
    });
  }

  Form otpForm() {
    return Form(
      key: _form,
      child: PinTextField(
        pins: 6,
        onSaved: (val) => pinValue = val,
      ),
    );
  }

  StatelessWidget resendWidget() {
    return _start > 0
        ? Text(
            'Resend OTP in ${_start}s',
            style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.5),
          )
        : GestureDetector(
            onTap: () {
              this._getOTP();
            },
            child: Text(
              'Resend OTP',
              style: AppTheme.textStyle.w500
                  .colored(AppTheme.primaryColor)
                  .size(13)
                  .lineHeight(1.5),
            ),
          );
  }

  Container verifyButton(Function onVerification) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        onPressed: () {
          if (_isLoading) {
            return null;
          }
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            onVerification();
          }
        },
        color: _isLoading ? AppTheme.dividerColor : AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Verify',
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
    const sizedBox = SizedBox(height: 32);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];

    return Background(
      title: 'Verify OTP',
      backNavigation: true,
      child: Column(
        children: [
          sizedBox,
          Text(
            'Please enter OTP sent to your phone number $phone',
            style: AppTheme.textStyle.w500.color100.size(15).lineHeight(1.3),
          ),
          sizedBox,
          otpForm(),
          SizedBox(height: 12),
          !_isLoading ? resendWidget() : SizedBox.shrink(),
          SizedBox(height: 16),
          verifyButton(this._verifyOTP),
          SizedBox(height: 32),
          _isLoading ? Loader() : SizedBox.shrink()
        ],
      ),
    );
  }
}
