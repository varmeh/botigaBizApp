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

final _slotRange = [
  {'title': '6 AM - 9 AM', 'value': '6AM - 9AM'},
  {'title': '9 AM - 12 PM', 'value': '9AM - 12PM'},
  {'title': '12 PM - 3 PM', 'value': '12PM - 3PM'},
  {'title': '3 PM - 6 PM', 'value': '3PM - 6PM'},
  {'title': '6 PM - 9 PM', 'value': '6PM - 9PM'},
];

class _CommunityTileState extends State<CommunityTile> {
  bool _switchValue;
  String _deliveryType, _apartmentId;
  int _day, _selectedSlotIndex;
  List<bool> _schedule = List.filled(7, false);
  bool _switchValueChangedByUser = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _deliveryType = '';
      _day = 1;
      _apartmentId = widget.apt.id;
      _selectedSlotIndex = 0;
    });
  }

  void _handleSwitchChange(bool value) {
    setState(() {
      _switchValue = value;
      _switchValueChangedByUser = true;
    });
    widget.setApartmentStatus(widget.apt.id, value, () {
      setState(() => _switchValue = !value);
    });
  }

  void setDeliveryDays(int days) {
    setState(() => _day = days);
  }

  void setDeliveryWeek(List<bool> schedule) {
    _schedule = schedule;
  }

  @override
  Widget build(BuildContext context) {
    if (_switchValueChangedByUser) {
      _switchValueChangedByUser = false;
    } else {
      _switchValue = widget.apt.live;
    }

    final _hasSlot =
        widget.apt.deliverySlot != null && widget.apt.deliverySlot.isNotEmpty;

    final _deliveryText = widget.apt.deliveryFee != 0
        ? 'Delivery fee of ₹${widget.apt.deliveryFee} on order below ₹${widget.apt.deliveryMinOrder}'
        : 'Free delivery';

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.apt.apartmentName,
                      style: AppTheme.textStyle.w500
                          .size(15)
                          .lineHeight(1.33)
                          .color100,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.apt.apartmentArea,
                      style: AppTheme.textStyle
                          .size(15)
                          .w500
                          .color50
                          .lineHeight(1.33),
                    ),
                  ],
                ),
              ),
              BotigaSwitch(
                handleSwitchChange: (bool value) {
                  this._handleSwitchChange(value);
                },
                switchValue: _switchValue,
                alignment: Alignment.topRight,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.apt.deliveryMessage,
                      style: AppTheme.textStyle
                          .size(15)
                          .w500
                          .color50
                          .lineHeight(1.33),
                    ),
                    SizedBox(height: 4.0),
                    _hasSlot
                        ? Text(
                            widget.apt.deliverySlot,
                            style: AppTheme.textStyle
                                .size(15)
                                .w500
                                .color50
                                .lineHeight(1.33),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(width: 24),
              GestureDetector(
                onTap: () => _editBottomModal(context),
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
          SizedBox(height: 16),
          Text(
            _deliveryText,
            style: AppTheme.textStyle.size(15).w500.color50.lineHeight(1.33),
          ),
          SizedBox(height: 16),
          Divider(
            color: AppTheme.dividerColor,
            thickness: 1.2,
          )
        ],
      ),
    );
  }

  void _showDurationBottomSheet() {
    BotigaBottomModal(
      isDismissible: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                setState(() => _deliveryType = 'duration');
                _deliveryScheduleBottomModal(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fixed Duration',
                        style: AppTheme.textStyle.color100.size(15).w700),
                    Text(
                        'Deliver orders within certain days of order placement eg: 2 days from date of order',
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
                setState(() => _deliveryType = 'weeklySchedule');
                _deliveryScheduleBottomModal(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fixed Days',
                        style: AppTheme.textStyle.color100.size(15).w700),
                    Text(
                      'Deliver orders on specific days of the week. eg: Wed & Sat ',
                      style: AppTheme.textStyle.color50.size(13).w500,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    ).show(context);
  }

  void _editBottomModal(BuildContext context) {
    BotigaBottomModal(
      isDismissible: true,
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                _showDurationBottomSheet();
              },
              tileColor: AppTheme.dividerColor,
              leading: Icon(
                BotigaIcons.truck,
                size: 30,
              ),
              title: Text(
                'Change Delivery Schedule',
                style:
                    AppTheme.textStyle.w500.color100.lineHeight(1.33).size(15),
              ),
            ),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 0,
            child: ListTile(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (builder) {
                    return Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.65,
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
                          whatsappNumber: widget.apt.contact.whatsapp,
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
                'Update Contact Information',
                style:
                    AppTheme.textStyle.w500.color100.lineHeight(1.33).size(15),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    ).show(context);
  }

  void _deliveryScheduleBottomModal(BuildContext context) {
    Navigator.pop(context);
    bool _isFixedDuration = _deliveryType == 'duration';
    const _sizedBox20 = SizedBox(height: 20);
    final _appBar = _isFixedDuration ? 'Fixed duration' : 'Fixed days';

    final _deliveryMessage =
        _isFixedDuration ? 'Deliver order in' : 'Deliver order on';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 22.0,
                right: 22.0,
                top: 42.0,
                bottom: 32.0,
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BotigaAppBar(_appBar),
                      _sizedBox20,
                      Text(
                        _deliveryMessage,
                        style: AppTheme.textStyle.color100.size(17).w700,
                      ),
                      _sizedBox20,
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: _isFixedDuration
                            ? ListWheelScrollViewFixedDuration(
                                setDeliveryDays: setDeliveryDays)
                            : FixedDaysSelector(
                                setDeliveryWeek: setDeliveryWeek,
                                setModalState: setState,
                              ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      6.0,
                                    ),
                                  ),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                                onPressed: () => _slotBottomModal(context),
                                child: Text(
                                  'Next',
                                  style: AppTheme.textStyle
                                      .colored(AppTheme.backgroundColor)
                                      .size(15)
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _slotBottomModal(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 22.0,
                right: 22.0,
                top: 42.0,
                bottom: 32.0,
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BotigaAppBar('Approximate Time'),
                      Padding(
                        padding: const EdgeInsets.only(left: 55.0),
                        child: Text(
                          'This is specific to this community and helps customers to plan effectively',
                          style: AppTheme.textStyle.color50.w500
                              .size(12)
                              .lineHeight(1.3)
                              .letterSpace(0.2),
                        ),
                      ),
                      SizedBox(height: 24),
                      ..._slotRange.asMap().entries.map(
                            (entry) => _slotButton(
                              entry.value['title'],
                              entry.key,
                              setState,
                            ),
                          ),
                      SizedBox(height: 80),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      6.0,
                                    ),
                                  ),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                                onPressed: () => widget.updateDeliverySchedule(
                                  _apartmentId,
                                  _deliveryType,
                                  _day,
                                  _schedule,
                                  _slotRange[_selectedSlotIndex]['value'],
                                ),
                                child: Text(
                                  'Done',
                                  style: AppTheme.textStyle
                                      .colored(AppTheme.backgroundColor)
                                      .size(15)
                                      .w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _slotButton(String title, int index, StateSetter modalStateSetter) {
    final _isSelected = _selectedSlotIndex == index;
    return InkWell(
      onTap: () => modalStateSetter(() => _selectedSlotIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: _isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 14.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: AppTheme.textStyle
                .colored(
                  _isSelected ? AppTheme.backgroundColor : AppTheme.color100,
                )
                .size(15)
                .w600,
          ),
        ),
      ),
    );
  }
}
