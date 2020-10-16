import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';
import './SetPinSuccess.dart';
import 'package:provider/provider.dart';
import '../../../widget/index.dart';
import '../../../providers/Auth/AuthProvider.dart';

class SetPin extends StatefulWidget {
  static const routeName = '/signup-setpin';
  @override
  _SetPinState createState() => _SetPinState();
}

class _SetPinState extends State<SetPin> {
  GlobalKey<FormState> _form;
  String pinValue;

  @override
  void initState() {
    super.initState();
    pinValue = '';
    _form = GlobalKey();
  }

  void _handleSetPin() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final routesArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final phone = routesArgs['phone'];
    authProvider.updatePin(phone, pinValue).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SetPinSuccess()));
    }).catchError((error) {
      Toast(message: '$error', iconData: BotigaIcons.truck);
    });
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
              style: TextStyle(
                  color: AppTheme.color100,
                  fontSize: 22,
                  fontWeight: FontWeight.w700),
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
      body: Container(
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
    );
  }
}
