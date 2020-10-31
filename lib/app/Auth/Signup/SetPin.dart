import 'package:botiga_biz/theme/index.dart';
import 'package:botiga_biz/util/httpService.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../widget/index.dart';
import '../../Home/HomeScreen.dart';
import '../../../providers/AuthProvider.dart';

class SetPin extends StatefulWidget {
  static const routeName = '/signup-setpin';
  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> with TickerProviderStateMixin {
  GlobalKey<FormState> _form;
  String pinValue;
  AnimationController _controller;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    pinValue = '';
    _isLoading = false;
    _form = GlobalKey();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadTabbarAfterAnimationCompletion);
  }

  void loadTabbarAfterAnimationCompletion(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }
  }

  Widget setPinSuccessful() {
    return Column(
      children: [
        Lottie.asset(
          'assets/lotties/checkSuccess.json',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration * 2;
            _controller.reset();
            _controller.forward();
          },
        ),
        SizedBox(height: 42.0),
        Text(
          'PIN Set successfully',
          style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
        ),
        SizedBox(height: 64.0),
      ],
    );
  }

  void _handleSetPin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final routesArgs =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      final phone = routesArgs['phone'];
      await authProvider.updatePin(phone, pinValue);
      BotigaBottomModal(isDismissible: false, child: setPinSuccessful())
          .show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Row setPinButton(Function onVerification) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      FlatButton(
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
          padding: const EdgeInsets.only(
              top: 14, bottom: 14, left: 51.5, right: 51.5),
          child: Text(
            'Set Pin',
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      )
    ]);
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

  @override
  Widget build(BuildContext context) {
    final sizedBox = SizedBox(height: 30);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Align(
            child: Text(
              "Set PIN",
              style: AppTheme.textStyle.w700.color100.size(22).lineHeight(1.0),
            ),
            alignment: Alignment.centerLeft,
          ),
          leading: IconButton(
            icon: Icon(
              BotigaIcons.arrowBack,
              color: AppTheme.color100,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      backgroundColor: AppTheme.backgroundColor,
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Last step! You are almost done. Going forward this 4-digit pin will be used to login.',
                style: AppTheme.textStyle.w500.color50.size(13).lineHeight(1.3),
              ),
              sizedBox,
              Center(child: Container(width: 200, child: pinForm())),
              sizedBox,
              setPinButton(this._handleSetPin),
            ],
          ),
        ),
      ),
    );
  }
}
