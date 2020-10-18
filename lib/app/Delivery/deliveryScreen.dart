import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/rendering.dart';
import '../Orders/orderDetails.dart';
import '../../models/Apartment/Apartments.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import '../../providers/Orders/OrdersProvider.dart';
import '../../providers/Apartment/ApartmentProvide.dart';

class DeliveryScreen extends StatefulWidget {
  static const routeName = '/all-delivery-list';
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  bool _isLoading;
  bool _isError;
  bool _isInit;
  String selectedStatus;
  String slectedDate;
  bool fabIsVisible;
  Apartment apartment;
  GlobalKey<ScaffoldState> _scaffoldKey;
  CalendarController _calendarController;
  ScrollController _scrollcontroller;

  @override
  void initState() {
    super.initState();
    loadSettings();
    _calendarController = CalendarController();
    _scrollcontroller = ScrollController();
    _scrollcontroller.addListener(() {
      setState(() {
        fabIsVisible = _scrollcontroller.position.userScrollDirection ==
            ScrollDirection.reverse;
      });
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _scrollcontroller.dispose();
    super.dispose();
  }

  loadSettings() async {
    final deafaultApartment =
        Provider.of<ApartmentProvider>(context, listen: false)
            .defaultAppartment;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _isLoading = false;
    _isError = false;
    _isInit = false;
    fabIsVisible = false;
    selectedStatus = 'All';
    apartment = deafaultApartment;
    slectedDate = 'TODAY';
  }

  void fetchDeliveryData(String aprtmentId, String currentDate) {
    final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
    setState(() {
      _isError = false;
      _isLoading = true;
    });
    orderProvider.fetchOrderByDateApartment(aprtmentId, currentDate).then((_) {
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
      final apartment = Provider.of<ApartmentProvider>(context, listen: false)
          .defaultAppartment;
      final aprtmentId = apartment != null ? apartment.id : '';
      final currentDate = FormatDate.getRequestFormatDate(DateTime.now());
      fetchDeliveryData(aprtmentId, currentDate);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Align(
          child: Text(
            "Delivery",
            style: TextStyle(
                color: AppTheme.color100,
                fontSize: 22,
                fontWeight: FontWeight.w700),
          ),
          alignment: Alignment.centerLeft,
        ),
        actions: [
          IconButton(
            icon: Icon(
              BotigaIcons.search,
              color: AppTheme.color100,
            ),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: AppTheme.dividerColor,
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
                color: AppTheme.backgroundColor,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    ...apartments.map((apartment) {
                      return ListTile(
                          title: Text(
                            '${apartment.apartmentName}',
                            style: AppTheme.textStyle.color100.w500.size(15),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              apartment = apartment;
                              slectedDate = FormatDate.getTodayOrSelectedDate(
                                  DateTime.now());
                            });
                            final currentDate =
                                FormatDate.getRequestFormatDate(DateTime.now());
                            fetchDeliveryData(apartment.id, currentDate);
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
                _scaffoldKey.currentState.openEndDrawer();
              });
            },
            label: Padding(
              padding: const EdgeInsets.only(
                  left: 0, top: 10, bottom: 10, right: 30),
              child: Text(
                'Select apartment',
                style: AppTheme.textStyle
                    .colored(AppTheme.primaryColor)
                    .w600
                    .size(12),
              ),
            ),
            icon: Icon(
              Icons.chevron_left,
              color: Color(0xff179F57),
            ),
            backgroundColor: Colors.white,
          ),
          alignment: fabIsVisible ? Alignment(3.6, 0.9) : Alignment(1.8, 0.9)),
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
              : SafeArea(
                  child: Container(
                    color: AppTheme.backgroundColor,
                    child: ListView(
                      controller: _scrollcontroller,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "Order to be sent out today",
                                style: AppTheme.textStyle.color50.w500.size(15),
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
                                      "Out for delivery",
                                      "Deliverd",
                                      "Delayed"
                                    ].map((val) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12),
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
                                            },
                                            color: selectedStatus == val
                                                ? AppTheme.primaryColor
                                                : AppTheme.dividerColor,
                                            child: Text('$val',
                                                style: selectedStatus == val
                                                    ? AppTheme.textStyle
                                                        .colored(AppTheme
                                                            .backgroundColor)
                                                        .w500
                                                        .size(13)
                                                    : AppTheme
                                                        .textStyle.color100.w500
                                                        .size(13)),
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
                                width: 220,
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
                                    Flexible(
                                      child: Text(
                                        '${apartment.apartmentName}',
                                        style: AppTheme.textStyle.w500.color100
                                            .size(15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.65,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
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
                                            todayColor: AppTheme
                                                .primaryColorVariant
                                                .withOpacity(0.5),
                                            selectedColor:
                                                AppTheme.primaryColor,
                                            outsideDaysVisible: true,
                                            weekendStyle:
                                                AppTheme.textStyle.color100,
                                            outsideWeekendStyle:
                                                AppTheme.textStyle.color50),
                                        daysOfWeekStyle: DaysOfWeekStyle(
                                          weekendStyle: AppTheme.textStyle
                                              .colored(AppTheme.color100),
                                        ),
                                        headerStyle: HeaderStyle(
                                          centerHeaderTitle: false,
                                          formatButtonVisible: false,
                                        ),
                                        onDaySelected: (date, events) {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            slectedDate = FormatDate
                                                .getTodayOrSelectedDate(date);
                                          });
                                          fetchDeliveryData(
                                              apartment.id,
                                              FormatDate.getRequestFormatDate(
                                                  date));
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
                                      width: 7,
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
                        Consumer<OrdersProvider>(
                            builder: (ctx, orderProvider, _) {
                          final deliveryByDateDetails =
                              orderProvider.orderByDateApartment;
                          if (orderProvider == null) {
                            return SizedBox();
                          }

                          return Column(
                            children: [
                              ...deliveryByDateDetails.map((deliveryRow) {
                                return DeliveryRow(
                                    deliveryRow, apartment.apartmentName);
                              })
                            ],
                          );
                        }),
                        Consumer<OrdersProvider>(
                            builder: (ctx, orderProvider, _) {
                          final deliveryByDateDetails =
                              orderProvider.orderByDateApartment;
                          if (orderProvider == null) {
                            return SizedBox();
                          }

                          return Column(
                            children: [
                              ...deliveryByDateDetails.map((deliveryRow) {
                                return DeliveryRow(
                                    deliveryRow, apartment.apartmentName);
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
                ),
    );
  }
}

class DeliveryRow extends StatelessWidget {
  final OrderByDateDetail delivery;
  final String apartmentName;
  DeliveryRow(this.delivery, this.apartmentName);

  _handleOutForDelivery(BuildContext context, String orderId) {
    final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
    orderProvider.setDeliveryStatus(orderId).then((value) {
      Toast(message: '$value', iconData: BotigaIcons.truck).show(context);
    }).catchError((error) {
      Toast(message: '$error', iconData: BotigaIcons.truck).show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          OrderDetails.routeName,
          arguments: {'orderId': delivery.id, 'apartmentName': apartmentName},
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff121714).withOpacity(0.12),
              blurRadius: 20.0, // soften the shadow
              spreadRadius: 0.0, //extend the shadow
              offset: Offset(
                0.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
          child: Card(
              elevation: 0,
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                              style: AppTheme.textStyle.color100.w600
                                  .size(15)
                                  .letterSpace(0.5),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "#${delivery.order.number} • ${delivery.order.products.length} ITEMS",
                              style: AppTheme.textStyle.color50.w500.size(13),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${Constants.rupeeSymbol} ${delivery.order.totalAmount}',
                                  style: AppTheme.textStyle.color100.w500
                                      .size(15)
                                      .letterSpace(1),
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
                                    "${delivery.order.status.toUpperCase()}",
                                    style: AppTheme.textStyle
                                        .colored(AppTheme.backgroundColor)
                                        .w500
                                        .size(12),
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
                                  width: 1.2, color: AppTheme.dividerColor),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: InkWell(
                            onTap: () {
                              this._handleOutForDelivery(context, delivery.id);
                            },
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
                                      color: AppTheme.dividerColor),
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
                                    style: AppTheme.textStyle.color100.w500
                                        .size(12)
                                        .letterSpace(0.2),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
