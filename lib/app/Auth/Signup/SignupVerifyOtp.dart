import 'dart:async';
import 'package:botiga_biz/util/httpService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botiga_biz/theme/index.dart';
import '../../Auth/widgets/index.dart';
import 'SignupBussinessDetails.dart';
import '../../Home/HomeScreen.dart';
import '../../../widget/index.dart';
import '../../../providers/AuthProvider.dart';

class SignUpOtp extends StatefulWidget {
  static const routeName = 'signup-otp';
  @override
  _SignUpOtpState createState() => _SignUpOtpState();
}

class _SignUpOtpState extends State<SignUpOtp> {
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

  void _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final routesArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final phone = routesArgs['phone'];
      final value = await authProvider.verifyOtp(phone, sessionId, pinValue);
      String message = value['message'];
      if (message == "createSeller") {
        Navigator.pushReplacementNamed(
            context, SignupBuissnessDetails.routeName,
            arguments: {'phone': phone});
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getOTP() async {
    startTimer();
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final phone = routesArgs['phone'];
    try {
      final value = await authProvider.getOTP(phone);
      setState(() {
        sessionId = value['sessionId'];
      });
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    }
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
      child: LoaderOverlay(
        isLoading: _isLoading,
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
            verifyButton(this._verifyOTP),
          ],
        ),
      ),
    );
  }
}
