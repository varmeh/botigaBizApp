import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/index.dart' show ProfileProvider;
import '../../../theme/index.dart';
import '../../../util/index.dart';
import '../../../widget/index.dart';

class AddDeliveryFee extends StatefulWidget {
  final String apartmentId;
  final int deliveryMinOrder;
  final int deliveryFee;

  AddDeliveryFee({
    @required this.apartmentId,
    @required this.deliveryMinOrder,
    @required this.deliveryFee,
  });
  @override
  _AddDeliveryFeeState createState() => _AddDeliveryFeeState();
}

class _AddDeliveryFeeState extends State<AddDeliveryFee> {
  final _formKey = GlobalKey<FormState>();
  int _deliveryMinOrder, _deliveryFee;
  FocusNode _deliveryMinOrderFocusNode, _deliveryFeeFocusNode;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _deliveryMinOrderFocusNode = FocusNode();
    _deliveryFeeFocusNode = FocusNode();
    _isLoading = false;
    loadInitialFormValues();
  }

  @override
  void dispose() {
    _deliveryMinOrderFocusNode.dispose();
    _deliveryFeeFocusNode.dispose();
    super.dispose();
  }

  void loadInitialFormValues() {
    setState(() {
      _deliveryMinOrder = widget.deliveryMinOrder;
      _deliveryFee = widget.deliveryFee;
    });
  }

  void _handleDeliveryFeeUpdate() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.updateDeliveryFee(
          widget.apartmentId, _deliveryMinOrder, _deliveryFee);
      await await profileProvider.fetchProfile();
      Navigator.of(context).pop();
      Toast(
        message: 'Delivery fee updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: _isLoading,
      child: GestureDetector(
        onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: SafeArea(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              this._handleDeliveryFeeUpdate();
                            }
                          },
                          child: Text('Update',
                              style: AppTheme.textStyle
                                  .colored(AppTheme.backgroundColor)
                                  .size(15)
                                  .w600),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
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
                              Padding(
                                padding: const EdgeInsets.only(top: 28),
                                child: Text('Delivery fee',
                                    style: AppTheme.textStyle.color100
                                        .size(22)
                                        .w700),
                              ),
                              SizedBox(height: 24),
                              BotigaTextFieldForm(
                                initialValue: _deliveryMinOrder.toString(),
                                focusNode: _deliveryMinOrderFocusNode,
                                nextFocusNode: _deliveryFeeFocusNode,
                                labelText: 'Min. Order Amount',
                                keyboardType: TextInputType.datetime,
                                onSave: (value) =>
                                    _deliveryMinOrder = int.parse(value),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                  if (value.isNotEmpty &&
                                      int.tryParse(value) == null) {
                                    return 'Please use numbers for price';
                                  }
                                  if (int.parse(value) > 400) {
                                    return 'Max - ₹400';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 9),
                              Text(
                                  'Keep the value 0 for no delivery charges. Max - ₹400',
                                  style: AppTheme.textStyle.color50
                                      .size(12)
                                      .letterSpace(0.15)
                                      .w500),
                              SizedBox(height: 24),
                              BotigaTextFieldForm(
                                initialValue: _deliveryFee.toString(),
                                focusNode: _deliveryFeeFocusNode,
                                keyboardType: TextInputType.datetime,
                                labelText: 'Delivery fee',
                                onSave: (value) =>
                                    _deliveryFee = int.parse(value),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  }
                                  if (value.isNotEmpty &&
                                      int.tryParse(value) == null) {
                                    return 'Please use numbers for price';
                                  }
                                  if (int.parse(value) > 20) {
                                    return 'Max - ₹20';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 9,
                              ),
                              Text('Max. Delivery fee allowed is ₹20',
                                  style: AppTheme.textStyle.color50
                                      .size(12)
                                      .letterSpace(0.15)
                                      .w500),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
