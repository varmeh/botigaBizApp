import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Home/HomeScreen.dart';
import '../../Profile/Communites/addContactDetails.dart';
import '../../../models/Profile/Profile.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart';
import '../../../providers/ProfileProvider.dart';

class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  bool isLoading = false;

  void setApartmentStatus(String aptId, bool value, Function onFail) {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.setApartmentStatus(aptId, value).then((value) {
      profileProvider.fetchProfile().then((_) {
        setState(() {
          isLoading = false;
        });
        Toast(message: '$value', iconData: Icons.check_circle).show(context);
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        onFail();
        Toast(message: '$err', iconData: Icons.error_outline).show(context);
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      onFail();
      Toast(message: '$err', iconData: Icons.error_outline).show(context);
    });
  }

  void updateDeliverySchedule(
      String _apartmentId, String _deliveryType, int _day) {
    Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    profileProvider
        .updateApartmentDeliveryScheduled(_apartmentId, _deliveryType, _day)
        .then((value) {
      profileProvider.fetchProfile().then((_) {
        setState(() {
          isLoading = false;
        });
        Toast(message: '$value', iconData: Icons.check_circle).show(context);
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Toast(message: '$err', iconData: Icons.error_outline).show(context);
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Toast(message: '$err', iconData: Icons.error_outline).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Apartment> apartments =
        Provider.of<ProfileProvider>(context, listen: true).allApartment;
    if (apartments.length == 0) {
      return BrandingTile(
        'Thriving communities, empowering people',
        'Made by awesome team of Botiga',
      );
    }
    return LoaderOverlay(
      isLoading: isLoading,
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: ListView.builder(
          itemCount: apartments.length,
          itemBuilder: (context, index) {
            return CommunityTile(
                apartments[index], setApartmentStatus, updateDeliverySchedule);
          },
        ),
      ),
    );
  }
}

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
            top: 32,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("How do you deliver?",
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

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (builder) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, bottom: 48.0),
                                        child: BottomSheetHeader(
                                          title: "Fixed duration",
                                        ),
                                      ),
                                      Text(
                                        "Deliver order in",
                                        style: AppTheme.textStyle.color100
                                            .size(17)
                                            .w700,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20,
                                        ),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          child:
                                              ListWheelScrollViewFixedDuration(
                                                  setDeliveryDays:
                                                      setDeliveryDays),
                                        ),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                widget.updateDeliverySchedule(
                                                    _apartmentId,
                                                    _deliveryType,
                                                    _day);
                                              },
                                              textColor:
                                                  AppTheme.backgroundColor,
                                              color: AppTheme.primaryColor,
                                              child: Text('Done',
                                                  style: AppTheme.textStyle
                                                      .colored(AppTheme
                                                          .backgroundColor)
                                                      .size(15)
                                                      .w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Fixed Duration",
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
                        color: Color(0xff121714).withOpacity(0.12),
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

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (builder) {
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.80,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16.0),
                                topRight: const Radius.circular(16.0),
                              ),
                            ),
                            //could change this to Color(0xFF737373),
                            //so you don't have to change MaterialApp canvasColor
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, bottom: 48.0),
                                        child: BottomSheetHeader(
                                          title: "Fixed day",
                                        ),
                                      ),
                                      Text("Deliver order in",
                                          style: AppTheme.textStyle.color100
                                              .size(17)
                                              .w700),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20,
                                        ),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.45,
                                          child: ListWheelScrollViewFixedDay(
                                              setDeliveryDays: setDeliveryDays),
                                        ),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                widget.updateDeliverySchedule(
                                                    _apartmentId,
                                                    _deliveryType,
                                                    _day);
                                              },
                                              textColor:
                                                  Theme.of(context).errorColor,
                                              color: AppTheme.primaryColor,
                                              child: Text(
                                                'Done',
                                                style: AppTheme.textStyle
                                                    .colored(AppTheme
                                                        .backgroundColor)
                                                    .size(15)
                                                    .w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Fixed Day",
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
          ),
        ),
      ),
    );
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
          trailing: Transform.scale(
            alignment: Alignment.topRight,
            scale: 0.75,
            child: CupertinoSwitch(
              value: _switchValue,
              onChanged: (bool value) {
                this._handleSwitchChage(value);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.apt.deliveryMessage,
              style: AppTheme.textStyle.size(15).w500.color50.lineHeight(1.33),
            ),
            _switchValue
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 40),
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16.0),
                              topRight: const Radius.circular(16.0),
                            ),
                          ),
                          child: SafeArea(
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.60,
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
                                                phoneNumber:
                                                    widget.apt.contact.phone,
                                                whatsappNumber:
                                                    widget.apt.contact.whatsapp,
                                                isSave: false,
                                                deliveryMsg:
                                                    widget.apt.deliveryMessage),
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
                                      'Edit contact information',
                                      style: AppTheme.textStyle.w500.color100
                                          .lineHeight(1.33)
                                          .size(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "EDIT",
                      style: AppTheme.textStyle
                          .size(15)
                          .w600
                          .colored(AppTheme.primaryColor)
                          .lineHeight(1.33),
                    ),
                  )
                : SizedBox.shrink()
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
