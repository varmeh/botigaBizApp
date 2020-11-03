import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addContactDetails.dart';
import '../../../models/Apartment/ApartmentModel.dart';
import '../../../util/index.dart' show Http;
import '../../../theme/index.dart';
import '../../../widget/index.dart';
import '../../../providers/ProfileProvider.dart';

class SelectArea extends StatefulWidget {
  static const routeName = 'select-area';
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  final List<ApartmentModel> _apartments = [];
  String _query = '';
  String _deliveryType, _apartmentId;
  int _day;

  @override
  void initState() {
    super.initState();
    _deliveryType = '';
    _day = 1;
    _apartmentId = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setDeliveryDays(int days) {
    setState(() {
      _day = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Select your community'),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SearchBar(
                placeholder: 'Apartment / Area / City / Pincode',
                onSubmit: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: _searchList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> _searchList() {
    return FutureBuilder(
      future: getApartments(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return HttpServiceExceptionWidget(
            exception: snapshot.error,
            onTap: () {
              // Rebuild screen
              setState(() {});
            },
          );
        } else {
          return LoaderOverlay(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: ListView.builder(
                itemCount: _apartments.length + 1,
                itemBuilder: (context, index) {
                  return index < _apartments.length
                      ? _apartmentTile(index)
                      : _missingApartmentMessage();
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _apartmentTile(int index) {
    final apartment = _apartments[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _apartmentId = apartment.id;
        });
        _showDurationBottomSheet(context, apartment);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Text(
            apartment.name,
            style: AppTheme.textStyle.w500.color100.size(17.0).lineHeight(1.3),
          ),
          SizedBox(height: 8.0),
          Text(
            '${apartment.area}, ${apartment.city}, ${apartment.state} - ${apartment.pincode}',
            style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
          ),
          SizedBox(height: 20.0),
          Divider(
            thickness: 1.0,
            color: AppTheme.dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _missingApartmentMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        Text(
          'Don’t find your apartment?',
          style: AppTheme.textStyle.w500.color100.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 8.0),
        Text(
          'Please stay tuned, we are expanding rapidly to apartments.',
          style: AppTheme.textStyle.w500.color50.size(13.0).lineHeight(1.5),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }

  void _showDurationBottomSheet(
    BuildContext context,
    ApartmentModel apartment,
  ) {
    final profileInfo =
        Provider.of<ProfileProvider>(context, listen: false).profileInfo;
    final String email = profileInfo.contact.email;
    final String whatsapp = profileInfo.contact.whatsapp;
    final String phone = profileInfo.contact.phone;

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
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (builder) {
                                                    return Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.60,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(
                                                            16.0,
                                                          ),
                                                          topRight: const Radius
                                                              .circular(
                                                            16.0,
                                                          ),
                                                        ),
                                                      ),
                                                      child: AddContactDetails(
                                                        apartmentId:
                                                            _apartmentId,
                                                        day: _day,
                                                        deliveryType:
                                                            _deliveryType,
                                                        email: email,
                                                        phoneNumber: phone,
                                                        whatsappNumber:
                                                            whatsapp,
                                                        isSave: true,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              textColor:
                                                  AppTheme.backgroundColor,
                                              color: AppTheme.primaryColor,
                                              child: Text('Next',
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
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (builder) {
                                                    return Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.60,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(16.0),
                                                          topRight: const Radius
                                                              .circular(16.0),
                                                        ),
                                                      ),
                                                      //could change this to Color(0xFF737373),
                                                      //so you don't have to change MaterialApp canvasColor
                                                      child: AddContactDetails(
                                                        apartmentId:
                                                            _apartmentId,
                                                        day: _day,
                                                        deliveryType:
                                                            _deliveryType,
                                                        email: email,
                                                        phoneNumber: phone,
                                                        whatsappNumber:
                                                            whatsapp,
                                                        isSave: true,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              textColor:
                                                  Theme.of(context).errorColor,
                                              color: AppTheme.primaryColor,
                                              child: Text(
                                                'Next',
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

  Future<void> getApartments() async {
    try {
      final json =
          await Http.get('/api/services/apartments/search?text=$_query');
      _apartments.clear();
      json.forEach(
          (apartment) => _apartments.add(ApartmentModel.fromJson(apartment)));
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    }
  }
}
