import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/profile/index.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart';
import '../../profile/index.dart' show AddContactDetails;

class CommunityTile extends StatefulWidget {
  final Apartment apt;
  final Function setApartmentStatus;
  final Function updateDeliverySchedule;
  CommunityTile(this.apt, this.setApartmentStatus, this.updateDeliverySchedule);
  @override
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  bool _switchValue;
  String _deliveryType, _apartmentId;
  int _day;

  @override
  void initState() {
    super.initState();
    setState(() {
      _switchValue = widget.apt.live;
      _deliveryType = '';
      _day = 1;
      _apartmentId = widget.apt.id;
    });
  }

  void _handleSwitchChage(bool value) {
    setState(() {
      _switchValue = value;
    });
    widget.setApartmentStatus(widget.apt.id, value, () {
      setState(() {
        _switchValue = !value;
      });
    });
  }

  void setDeliveryDays(int days) {
    setState(() {
      _day = days;
    });
  }

  void _showDurationBottomSheet() {
    BotigaBottomModal(
      isDismissible: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('How do you deliver?',
              style: AppTheme.textStyle.color100.size(22).w700),
          SizedBox(
            height: 24,
          ),
          Container(
            width: double.infinity,
            height: 128,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.color100.withOpacity(0.12),
                  blurRadius: 40.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    0.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _deliveryType = 'duration';
                });

                BotigaBottomModal(
                  isDismissible: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      BotigaAppBar('Fixed duration'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Deliver order in',
                          style: AppTheme.textStyle.color100.size(17).w700),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListWheelScrollViewFixedDuration(
                            setDeliveryDays: setDeliveryDays),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                ),
                                onPressed: () {
                                  widget.updateDeliverySchedule(
                                      _apartmentId, _deliveryType, _day);
                                },
                                textColor: AppTheme.backgroundColor,
                                color: AppTheme.primaryColor,
                                child: Text('Done',
                                    style: AppTheme.textStyle
                                        .colored(AppTheme.backgroundColor)
                                        .size(15)
                                        .w600),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ).show(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Fixed Duration',
                        style: AppTheme.textStyle.color100.size(15).w700),
                    Text(
                        'Deliver orders within specific days of order placement. ex: 2 days from order',
                        style: AppTheme.textStyle.color50.size(13).w500)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Container(
            width: double.infinity,
            height: 128,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.color100.withOpacity(0.12),
                  blurRadius: 40.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(
                    0.0, // Move to right 10  horizontally
                    0.0, // Move to bottom 10 Vertically
                  ),
                )
              ],
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _deliveryType = 'day';
                });

                BotigaBottomModal(
                  isDismissible: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      BotigaAppBar('Fixed day'),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Deliver order every',
                          style: AppTheme.textStyle.color100.size(17).w700),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListWheelScrollViewFixedDay(
                            setDeliveryDays: setDeliveryDays),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    6.0,
                                  ),
                                ),
                                onPressed: () {
                                  widget.updateDeliverySchedule(
                                      _apartmentId, _deliveryType, _day);
                                },
                                textColor: AppTheme.backgroundColor,
                                color: AppTheme.primaryColor,
                                child: Text('Done',
                                    style: AppTheme.textStyle
                                        .colored(AppTheme.backgroundColor)
                                        .size(15)
                                        .w600),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ).show(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Fixed Day',
                        style: AppTheme.textStyle.color100.size(15).w700),
                    Text(
                      'Deliver orders on a specific day of the week. ex: every Sunday',
                      style: AppTheme.textStyle.color50.size(13).w500,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(widget.apt.apartmentName,
              style:
                  AppTheme.textStyle.w500.size(15).lineHeight(1.33).color100),
          subtitle: Text(
            widget.apt.apartmentArea,
            style: AppTheme.textStyle.size(15).w500.color50.lineHeight(1.33),
          ),
          trailing: BotigaSwitch(
            handleSwitchChage: (bool value) {
              this._handleSwitchChage(value);
            },
            switchValue: _switchValue,
            alignment: Alignment.topRight,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.apt.deliveryMessage,
              style: AppTheme.textStyle.size(15).w500.color50.lineHeight(1.33),
            ),
            GestureDetector(
              onTap: () {
                BotigaBottomModal(
                  isDismissible: true,
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            _showDurationBottomSheet();
                          },
                          tileColor: AppTheme.dividerColor,
                          leading: Icon(
                            BotigaIcons.truck,
                            size: 30,
                          ),
                          title: Text(
                            'Change delivery details',
                            style: AppTheme.textStyle.w500.color100
                                .lineHeight(1.33)
                                .size(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Card(
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (builder) {
                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.80,
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(
                                        16.0,
                                      ),
                                      topRight: const Radius.circular(
                                        16.0,
                                      ),
                                    ),
                                  ),
                                  child: AddContactDetails(
                                      apartmentId: widget.apt.id,
                                      email: widget.apt.contact.email,
                                      phoneNumber: widget.apt.contact.phone,
                                      whatsappNumber:
                                          widget.apt.contact.whatsapp,
                                      isSave: false,
                                      deliveryMsg: widget.apt.deliveryMessage),
                                );
                              },
                            );
                          },
                          tileColor: AppTheme.dividerColor,
                          leading: Icon(
                            Icons.supervisor_account_sharp,
                            size: 30,
                          ),
                          title: Text(
                            'Update contact information',
                            style: AppTheme.textStyle.w500.color100
                                .lineHeight(1.33)
                                .size(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).show(context);
              },
              child: Text(
                'EDIT',
                style: AppTheme.textStyle
                    .size(15)
                    .w600
                    .colored(AppTheme.primaryColor)
                    .lineHeight(1.33),
              ),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Divider(
          color: AppTheme.dividerColor,
          thickness: 1.2,
        )
      ],
    );
  }
}
