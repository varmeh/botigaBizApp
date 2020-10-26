import 'package:flutter/material.dart';
import 'addContactDetails.dart';
import '../../../models/Apartment/ApartmentModel.dart';
import '../../../util/network/index.dart' show HttpService;
import '../../../theme/index.dart';
import '../../../widget/index.dart';

class SelectArea extends StatefulWidget {
  static const routeName = '/select-area';
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
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            BotigaIcons.arrowBack,
            color: AppTheme.color100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          child: Text(
            'Select your community',
            style: AppTheme.textStyle.w700.color100.size(22).lineHeight(1.2),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.70,
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.45,
                                        child: ListWheelScrollViewFixedDuration(
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
                                                            0.85,
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
                                                      apartmentId: _apartmentId,
                                                      day: _day,
                                                      deliveryType:
                                                          _deliveryType,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            textColor: AppTheme.backgroundColor,
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
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                            0.85,
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
                                                      apartmentId: _apartmentId,
                                                      day: _day,
                                                      deliveryType:
                                                          _deliveryType,
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
                                                  .colored(
                                                      AppTheme.backgroundColor)
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
    );
  }

  Future<void> getApartments() async {
    try {
      final json = await HttpService()
          .get('/api/services/apartments/search?text=$_query');
      print(json);
      _apartments.clear();
      json.forEach(
          (apartment) => _apartments.add(ApartmentModel.fromJson(apartment)));
    } catch (error) {
      Toast(message: '$error', iconData: Icons.error_outline).show(context);
    }
  }
}

//For Fixed Days
class ListWheelScrollViewFixedDay extends StatefulWidget {
  final Function setDeliveryDays;
  ListWheelScrollViewFixedDay({@required this.setDeliveryDays});
  @override
  _ListWheelScrollViewFixedDayState createState() {
    return _ListWheelScrollViewFixedDayState();
  }
}

class _ListWheelScrollViewFixedDayState
    extends State<ListWheelScrollViewFixedDay> {
  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Center(
        child: Text(
          'Sunday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 0 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Monday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 1 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Tuesday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 2 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Wednesday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 3 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Thrusday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 4 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Friday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 5 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Saturday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 6 ? Colors.black : Colors.black12,
          ),
        ),
      )
    ];

    return ListWheelScrollView(
      offAxisFraction: 0,
      itemExtent: 60,
      children: items,
      magnification: 1.5,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      diameterRatio: 2,
      squeeze: 0.8,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedItemIndex = index;
        });
        widget.setDeliveryDays(index + 1);
      },
    );
  }
}

//for fixed duration
class ListWheelScrollViewFixedDuration extends StatefulWidget {
  final Function setDeliveryDays;
  ListWheelScrollViewFixedDuration({@required this.setDeliveryDays});
  @override
  _ListWheelScrollViewFixedDurationState createState() {
    return _ListWheelScrollViewFixedDurationState();
  }
}

class _ListWheelScrollViewFixedDurationState
    extends State<ListWheelScrollViewFixedDuration> {
  int _selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Center(
        child: Text(
          '1 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 0 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '2 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 1 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '3 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 2 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '4 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 3 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '5 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 4 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '6 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 5 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '7 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 6 ? Colors.black : Colors.black12,
          ),
        ),
      )
    ];

    return ListWheelScrollView(
      offAxisFraction: 0,
      itemExtent: 60,
      children: items,
      magnification: 1.5,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      diameterRatio: 2,
      squeeze: 0.8,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedItemIndex = index;
        });
        widget.setDeliveryDays(index + 1);
      },
    );
  }
}
