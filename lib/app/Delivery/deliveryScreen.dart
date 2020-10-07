import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../widget/common/appHeader.dart';
import '../../providers/Delivery/DeliveryProvider.dart';
import '../../providers/Apartment/ApartmentProvide.dart';
import '../../theme/index.dart' show BotigaIcons;
import '../../util/constants.dart';
import '../../models/Delivery/DeliveryByDateDetails.dart';

class DeliveryScreen extends StatefulWidget {
  static const routeName = '/all-delivery-list';
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  bool _isLoading = false;
  bool _isError = false;
  bool _isInit = false;
  String apartmentName = "";
  String selectedStatus = "";
  String slectedDate = "";
  bool isFloatingButtonClicked = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    loadSettings();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  loadSettings() async {
    setState(() {
      selectedStatus = 'All';
      apartmentName = 'Select apartment';
      slectedDate = 'TODAY';
    });
  }

  void fetchDeliveryData() {
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: false);
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    deliveryProvider.fetchDeliveryByDateDeatils().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
      fetchDeliveryData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      endDrawer: Align(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          child: SizedBox(
            width: 291,
            height: 360,
            child: Consumer<ApartmentProvider>(
                builder: (ctx, apartmentprovider, _) {
              final apartments = apartmentprovider.allAprtment;
              if (apartments.length == 0) {
                return SizedBox();
              }
              return Drawer(
                  child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    ...apartments.map((apartment) {
                      return ListTile(
                          title: Text(
                            '${apartment.apartmentName}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              isFloatingButtonClicked = false;
                              apartmentName = apartment.apartmentName;
                            });
                          });
                    }),
                  ],
                ),
              ));
            }),
          ),
        ),
        alignment: Alignment(1, 0.8),
      ),
      floatingActionButton: Align(
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
              setState(() {
                isFloatingButtonClicked = !isFloatingButtonClicked;
              });
            },
            label: Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 30),
              child: InkWell(
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                  setState(() {
                    isFloatingButtonClicked = false;
                    _scaffoldKey.currentState.openEndDrawer();
                  });
                },
                child: Text(
                  'Select apartment',
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            icon: Icon(
              Icons.chevron_left,
              color: Color(0xff179F57),
            ),
            backgroundColor: Colors.white,
          ),
          alignment: !isFloatingButtonClicked
              ? Alignment(4, 0.9)
              : Alignment(1.8, 0.9)),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _isError
              ? Center(
                  child: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              : Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 25),
                            child: AppHeader(
                              showBackBtn: false,
                              title: "Delivery",
                              actionWidget: IconButton(
                                  icon: Icon(BotigaIcons.search),
                                  onPressed: () {}),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "Order to be sent out today",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Color(0xff000000).withOpacity(0.5),
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 44,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  ...[
                                    "All",
                                    "Open",
                                    "out for delivery",
                                    "Deliverd",
                                    "Delayed"
                                  ].map((val) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Container(
                                        height: 44,
                                        child: FlatButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      12.0)),
                                          onPressed: () {
                                            setState(() {
                                              selectedStatus = val;
                                            });
                                            fetchDeliveryData();
                                          },
                                          color: selectedStatus == val
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background
                                                  .withOpacity(0.50),
                                          child: Text('$val',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                    color: selectedStatus == val
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .surface
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                  )),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      BotigaIcons.building,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '$apartmentName',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.65,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16.0),
                                        topRight: const Radius.circular(16.0),
                                      ),
                                    ),
                                    child: TableCalendar(
                                      startDay: DateTime.now(),
                                      availableCalendarFormats: const {
                                        CalendarFormat.month: 'Month',
                                      },
                                      calendarStyle: CalendarStyle(
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        outsideDaysVisible: true,
                                        weekendStyle: TextStyle().copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                      daysOfWeekStyle: DaysOfWeekStyle(
                                        weekendStyle: TextStyle().copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                      ),
                                      headerStyle: HeaderStyle(
                                        centerHeaderTitle: false,
                                        formatButtonVisible: false,
                                      ),
                                      onDaySelected: (date, events) {
                                        final newDate =
                                            DateFormat("yMd").format(date);
                                        Navigator.of(context).pop();
                                        setState(() {
                                          slectedDate = newDate;
                                        });
                                        fetchDeliveryData();
                                      },
                                      calendarController: _calendarController,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Text('$slectedDate',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.expand_more_sharp,
                                    size: 25,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<DeliveryProvider>(
                          builder: (ctx, deliveryprovider, _) {
                        final deliveryByDateDetails =
                            deliveryprovider.deliveryByDateDetails;
                        if (deliveryprovider == null) {
                          return SizedBox();
                        }

                        return Column(
                          children: [
                            ...deliveryByDateDetails.map((deliveryRow) {
                              return DeliveryRow(deliveryRow);
                            })
                          ],
                        );
                      }),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
    );
  }
}

class DeliveryRow extends StatelessWidget {
  final DeliveryByDateDetails delivery;
  DeliveryRow(this.delivery);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xff121714).withOpacity(0.01),
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Card(
            margin: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15, top: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "No.202, ${delivery.buyer.name}",
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      wordSpacing: 1,
                                    ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "#${delivery.order.number} • ${delivery.order.products.length} ITEMS",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Colors.grey[500]),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '${Constants.rupeeSymbol} ${delivery.order.totalAmount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      letterSpacing: 1,
                                    ),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffE9A136),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2))),
                                padding: EdgeInsets.only(
                                    left: 6, right: 6, top: 4, bottom: 4),
                                child: Text(
                                  "${delivery.order.status}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          letterSpacing: 1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 1,
                                color: Colors.black.withOpacity(0.05)),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: Icon(
                                  BotigaIcons.truck,
                                  size: 30,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.05)),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              width: 70,
                              height: 32,
                              child: Text(
                                "Out for delivery",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        letterSpacing: 0.2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
