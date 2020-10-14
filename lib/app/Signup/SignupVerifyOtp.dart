import 'package:flutter/material.dart';
import 'dart:async';
import 'SignupBussinessDetails.dart';
import '../../theme/index.dart';
import '../Auth/widgets/background.dart';
import '../../widget/pinTextField.dart';
import '../../providers/Auth/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

class SignUpOtp extends StatefulWidget {
  static const routeName = '/signup-otp';
  @override
  _SignUpOtpState createState() => _SignUpOtpState();
}

class _SignUpOtpState extends State<SignUpOtp> {
  GlobalKey<FormState> _form = GlobalKey();
  String sessionId = '';
  String pinValue = '';
  var _isInit = false;

  Timer _timer;
  int _start;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      getOtp();
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

  void verifyOtp() {
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(phone, sessionId, pinValue).then((value) {
      Navigator.pushReplacementNamed(context, SignupBuissnessDetails.routeName,
          arguments: {'phone': phone});
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style:
              AppTheme.textStyle.colored(AppTheme.surfaceColor).w500.size(15),
        ),
        icon: Icon(BotigaIcons.truck, size: 30, color: AppTheme.surfaceColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
    });
  }

  void getOtp() {
    startTimer();
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final phone = routesArgs['phone'];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getOTP(phone).then((value) {
      setState(() {
        sessionId = value['sessionId'];
      });
    }).catchError((error) {
      Flushbar(
        maxWidth: 335,
        backgroundColor: Theme.of(context).errorColor,
        messageText: Text(
          '$error',
          style:
              AppTheme.textStyle.colored(AppTheme.surfaceColor).w500.size(15),
        ),
        icon: Icon(BotigaIcons.truck, size: 30, color: AppTheme.surfaceColor),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        borderRadius: 8,
      ).show(context);
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
              getOtp();
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
          if (_form.currentState.validate()) {
            _form.currentState.save(); //value saved in pinValue
            onVerification();
          }
        },
        color: AppTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            'Verify',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.surfaceColor),
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
          resendWidget(),
          SizedBox(height: 16),
          verifyButton(verifyOtp),
        ],
      ),
    );
  }
}
