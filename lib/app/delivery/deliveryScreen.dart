import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/rendering.dart';
import 'emptyDelivery.dart';
import '../orders/index.dart' show OrderDetails;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import '../../providers/index.dart' show ProfileProvider, DeliveryProvider;
import '../../models/profile/index.dart';
import '../../models/orders/index.dart';

const rupeeSymbol = '\u20B9';

class DeliveryScreen extends StatefulWidget {
  static const routeName = 'all-delivery-list';
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  Map<String, String> statusMap = {
    'All': 'All',
    'Open': 'open',
    'Out for delivery': 'out',
    'Deliverd': 'delivered',
    'Delayed': 'delayed',
    'Cancelled': 'cancelled'
  };
  bool _isLoading;
  bool _isError;
  bool _isInit;
  bool _isProcessing;
  String selectedStatus;
  DateTime selectedDate;
  DateTime selectedDateForRequest;
  bool fabIsVisible;
  Apartment apartment;
  GlobalKey<ScaffoldState> _scaffoldKey;
  CalendarController _calendarController;
  ScrollController _scrollcontroller;
  var _error;

  @override
  void initState() {
    super.initState();
    loadSettings();
    _calendarController = CalendarController();
    _scrollcontroller = ScrollController();
    _scrollcontroller.addListener(() {
      setState(() {
        fabIsVisible = _scrollcontroller.position.userScrollDirection ==
            ScrollDirection.forward;
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
        Provider.of<ProfileProvider>(context, listen: false).defaultApartment;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _isLoading = false;
    _isError = false;
    _isInit = false;
    fabIsVisible = true;
    _isProcessing = false;
    selectedStatus = 'All';
    apartment = deafaultApartment;
    selectedDate = DateTime.now();
    selectedDateForRequest = DateTime.now();
    _error = null;
  }

  void fetchDeliveryData(String aprtmentId, String currentDate) async {
    if (aprtmentId != null &&
        aprtmentId != '' &&
        currentDate != null &&
        currentDate != '') {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      setState(() {
        _isError = false;
        _isLoading = true;
        _error = null;
      });
      try {
        await deliveryProvider.fetchDeliveryListByApartment(
            aprtmentId, currentDate);
      } catch (err) {
        setState(() {
          _isError = true;
          _isLoading = false;
          _error = err;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleOutForDelivery(String orderId) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      final date = selectedDateForRequest == null
          ? DateTime.now()
          : selectedDateForRequest;
      await deliveryProvider.setStatusOutForDelivery(orderId);
      await deliveryProvider.fetchDeliveryListByApartment(
          apartment.id, date.getRequestFormatDate());
      Toast(
        message: 'Order out for delivery',
        icon: Icon(
          BotigaIcons.truck,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _handleMarkAsDeliverd(String orderId) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      final date = selectedDateForRequest == null
          ? DateTime.now()
          : selectedDateForRequest;
      await deliveryProvider.setDeliveryStatus(orderId);
      await deliveryProvider.fetchDeliveryListByApartment(
          apartment.id, date.getRequestFormatDate());
      Toast(
        message: 'Order marked as deliverd',
        icon: Icon(
          BotigaIcons.truck,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void fetchDefaultDeliveryDetails() {
    final apartment =
        Provider.of<ProfileProvider>(context, listen: false).defaultApartment;
    final aprtmentId = apartment != null ? apartment.id : '';
    final currentDate = DateTime.now().getRequestFormatDate();
    if (aprtmentId != null && aprtmentId != '') {
      fetchDeliveryData(aprtmentId, currentDate);
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      fetchDefaultDeliveryDetails();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasApt =
        Provider.of<ProfileProvider>(context, listen: false).totalApartment > 0;
    final bool hasEnabledApt =
        Provider.of<ProfileProvider>(context, listen: false)
            .hasAnyEnabledApartment;
    return _isLoading
        ? Loader()
        : _isError
            ? HttpExceptionWidget(
                exception: _error,
                onTap: () {
                  fetchDefaultDeliveryDetails();
                },
              )
            : Scaffold(
                appBar: BotigaAppBar(
                  'Delivery',
                  neverShowLeadingBtn: true,
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
                endDrawer: (hasApt && hasEnabledApt)
                    ? Align(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                          child: SizedBox(
                            width: 291,
                            height: 360,
                            child: Consumer<ProfileProvider>(
                                builder: (ctx, profileProvider, _) {
                              final apartments = profileProvider.allApartment;
                              return Drawer(
                                  child: Container(
                                padding: EdgeInsets.all(20),
                                color: AppTheme.backgroundColor,
                                child: ListView(
                                  padding: EdgeInsets.all(0),
                                  children: <Widget>[
                                    ...apartments.map((_apartment) {
                                      return ListTile(
                                        title: Text(
                                          '${_apartment.apartmentName}',
                                          style: apartment.id == _apartment.id
                                              ? AppTheme.textStyle
                                                  .colored(
                                                      AppTheme.primaryColor)
                                                  .w500
                                                  .size(15)
                                              : AppTheme.textStyle.color100.w500
                                                  .size(15),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            apartment = _apartment;
                                          });
                                          fetchDeliveryData(
                                              apartment.id,
                                              selectedDate
                                                  .getRequestFormatDate());
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ));
                            }),
                          ),
                        ),
                        alignment: Alignment(1, 0.8),
                      )
                    : SizedBox.shrink(),
                floatingActionButton: (hasApt && hasEnabledApt)
                    ? fabIsVisible
                        ? FloatingActionButton.extended(
                            onPressed: () {
                              // Add your onPressed code here!
                              setState(() {
                                _scaffoldKey.currentState.openEndDrawer();
                              });
                            },
                            label: Text(
                              'Select apartment',
                              style: AppTheme.textStyle
                                  .colored(AppTheme.primaryColor)
                                  .w600
                                  .size(12)
                                  .lineHeight(1.5),
                            ),
                            icon: Icon(
                              Icons.chevron_left,
                              color: AppTheme.primaryColor,
                            ),
                            backgroundColor: AppTheme.backgroundColor,
                          )
                        : FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                _scaffoldKey.currentState.openEndDrawer();
                              });
                            },
                            child: Icon(
                              Icons.chevron_left,
                              color: AppTheme.primaryColor,
                            ),
                            backgroundColor: AppTheme.backgroundColor,
                          )
                    : SizedBox.shrink(),
                body: (hasApt && hasEnabledApt)
                    ? SafeArea(
                        child: LoaderOverlay(
                          isLoading: _isProcessing,
                          child: Container(
                            color: AppTheme.backgroundColor,
                            child: ListView(
                              controller: _scrollcontroller,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Text(
                                        'Order to be sent out today',
                                        style: AppTheme.textStyle.color50.w500
                                            .size(15),
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
                                            ...statusMap.keys.map((val) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12),
                                                child: Container(
                                                  height: 44,
                                                  child: FlatButton(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
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
                                                        style: selectedStatus ==
                                                                val
                                                            ? AppTheme.textStyle
                                                                .colored(AppTheme
                                                                    .backgroundColor)
                                                                .w500
                                                                .size(13)
                                                            : AppTheme.textStyle
                                                                .color100.w500
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
                                      left: 20.0, right: 10, top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                  BotigaIcons.building,
                                                  size: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  '${apartment.apartmentName}',
                                                  style: AppTheme
                                                      .textStyle.w500.color100
                                                      .size(15),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 100,
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 24),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            16.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            16.0),
                                                  ),
                                                ),
                                                child: SafeArea(
                                                  child: TableCalendar(
                                                    initialSelectedDay:
                                                        selectedDate,
                                                    startDay: DateTime.now()
                                                        .subtract(
                                                            Duration(days: 15)),
                                                    availableCalendarFormats: const {
                                                      CalendarFormat.month:
                                                          'Month',
                                                    },
                                                    calendarStyle: CalendarStyle(
                                                        todayColor: AppTheme
                                                            .primaryColorVariant
                                                            .withOpacity(0.5),
                                                        selectedColor: AppTheme
                                                            .primaryColor,
                                                        outsideDaysVisible:
                                                            true,
                                                        weekendStyle: AppTheme
                                                            .textStyle.color100,
                                                        outsideWeekendStyle:
                                                            AppTheme.textStyle
                                                                .color50),
                                                    daysOfWeekStyle:
                                                        DaysOfWeekStyle(
                                                      weekendStyle: AppTheme
                                                          .textStyle
                                                          .colored(AppTheme
                                                              .color100),
                                                    ),
                                                    headerStyle: HeaderStyle(
                                                      centerHeaderTitle: false,
                                                      formatButtonVisible:
                                                          false,
                                                    ),
                                                    onDaySelected:
                                                        (date, events, _) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {
                                                        selectedDate = date;
                                                        selectedDateForRequest =
                                                            date;
                                                      });
                                                      fetchDeliveryData(
                                                          apartment.id,
                                                          date.getRequestFormatDate());
                                                    },
                                                    calendarController:
                                                        _calendarController,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Text(
                                                    '${selectedDate.getTodayOrSelectedDate()}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1),
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Icon(
                                                Icons.expand_more_sharp,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Consumer<DeliveryProvider>(
                                    builder: (ctx, deliveryProvider, _) {
                                  final deliveryListByApartment =
                                      deliveryProvider.deliveryListByApartment;

                                  if (deliveryListByApartment == null ||
                                      deliveryListByApartment.length == 0) {
                                    return EmptyDelivery();
                                  }

                                  final filterdStatusDetails =
                                      selectedStatus == 'All'
                                          ? deliveryListByApartment
                                          : deliveryListByApartment
                                              .where((deliveryRow) {
                                              return deliveryRow.order.status ==
                                                  statusMap[selectedStatus];
                                            });

                                  if (filterdStatusDetails.length == 0) {
                                    return EmptyDelivery();
                                  }

                                  return Column(
                                    children: [
                                      ...filterdStatusDetails
                                          .map((deliveryRow) {
                                        return DeliveryRow(
                                            deliveryRow,
                                            apartment.apartmentName,
                                            apartment.id,
                                            this._handleOutForDelivery,
                                            selectedDateForRequest,
                                            this._handleMarkAsDeliverd);
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
                      )
                    : !hasApt
                        ? CommunitiesInfo('No Communities Added')
                        : CommunitiesInfo('No Communities enabled'));
  }
}

class DeliveryRow extends StatelessWidget {
  final OrderByDateDetail delivery;
  final String apartmentName;
  final String apartmentId;
  final Function handleOutForDelivery;
  final DateTime selectedDateForRequest;
  final Function handleMarkAsDeliverd;

  DeliveryRow(
      this.delivery,
      this.apartmentName,
      this.apartmentId,
      this.handleOutForDelivery,
      this.selectedDateForRequest,
      this.handleMarkAsDeliverd);

  _handleOutForDelivery(String orderId) {
    this.handleOutForDelivery(orderId);
  }

  _handleMarkAsDeliverd(String orderId) {
    this.handleMarkAsDeliverd(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final date = selectedDateForRequest == null
            ? DateTime.now()
            : selectedDateForRequest;
        Navigator.of(context).pushNamed(
          OrderDetails.routeName,
          arguments: {
            'flowType': 'delivery',
            'id': delivery.id,
            'apartmentName': apartmentName,
            'apartmentId': apartmentId,
            'selectedDateForRequest': date.getRequestFormatDate()
          },
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.color100.withOpacity(0.12),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15, top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${delivery.buyer.house}, ${delivery.buyer.name}',
                          style: AppTheme.textStyle.color100.w600
                              .size(15)
                              .letterSpace(0.5),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        RichText(
                          text: TextSpan(
                            text:
                                '#${delivery.order.number} • ${delivery.order.products.length} ITEMS',
                            style: AppTheme.textStyle.color50.w500.size(13),
                            children: <TextSpan>[
                              TextSpan(
                                  text: [1, 2, 3, 4, 5].map((e) => ' ').join()),
                              TextSpan(
                                text:
                                    '$rupeeSymbol${delivery.order.totalAmount}',
                                style: AppTheme.textStyle.color100.w500
                                    .size(16)
                                    .lineHeight(1.33),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.only(right: 4.0),
                              decoration: BoxDecoration(
                                color: delivery.order.statusColor,
                                shape: BoxShape.circle,
                              ),
                              child: delivery.order.isDelivered == true
                                  ? Icon(
                                      Icons.check,
                                      size: 12,
                                      color: AppTheme.backgroundColor,
                                    )
                                  : SizedBox.shrink(),
                            ),
                            Text(
                              delivery.order.statusMessage,
                              style: AppTheme.textStyle.w500.color50
                                  .size(16)
                                  .lineHeight(1.3),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  (delivery.order.isOpen || delivery.order.isDelayed)
                      ? Container(
                          padding: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 1.2, color: AppTheme.dividerColor),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: InkWell(
                            onTap: () {
                              this._handleOutForDelivery(delivery.id);
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
                                    'Out for delivery',
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
                      : SizedBox.shrink(),
                  delivery.order.isOutForDelivery
                      ? Container(
                          padding: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                  width: 1.2, color: AppTheme.dividerColor),
                            ),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: InkWell(
                            onTap: () {
                              this._handleMarkAsDeliverd(delivery.id);
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
                                      Icons.check,
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
                                    'Delivered',
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
                      : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
