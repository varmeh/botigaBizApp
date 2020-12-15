import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../models/profile/index.dart';
import '../../providers/index.dart' show ProfileProvider, DeliveryProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'deliveryRow.dart';
import 'emptyDelivery.dart';

const rupeeSymbol = '\u20B9';
const TODAY = 'TODAY';

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
  ScrollController _scrollcontroller;
  var _error;
  bool _showSearch;
  String _query;

  @override
  void initState() {
    super.initState();
    loadSettings();
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
    _scrollcontroller.dispose();
    super.dispose();
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
                appBar: !_showSearch && (hasApt && hasEnabledApt)
                    ? BotigaAppBar(
                        'Delivery',
                        neverShowLeadingBtn: true,
                        actions: [
                          IconButton(
                            icon: Icon(
                              BotigaIcons.search,
                              color: AppTheme.color100,
                            ),
                            onPressed: () {
                              setState(() {
                                _showSearch = true;
                              });
                            },
                          )
                        ],
                      )
                    : null,
                backgroundColor: AppTheme.backgroundColor,
                key: _scaffoldKey,
                endDrawer: _getDrawer(hasApt, hasEnabledApt),
                floatingActionButton: _getFloatingButton(hasApt, hasEnabledApt),
                body: (hasApt && hasEnabledApt)
                    ? GestureDetector(
                        onVerticalDragDown: (_) =>
                            FocusScope.of(context).unfocus(),
                        child: SafeArea(
                          child: LoaderOverlay(
                            isLoading: _isProcessing,
                            child: Container(
                              color: AppTheme.backgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _getSearch(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 10),
                                        child: Text(
                                          'Order to be sent out today',
                                          style: AppTheme.textStyle.color50.w500
                                              .size(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView(
                                      controller: _scrollcontroller,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Container(
                                            height: 44,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                ...statusMap.keys.map((val) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12),
                                                    child: Container(
                                                      height: 44,
                                                      child: FlatButton(
                                                        shape: new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
                                                                        .circular(
                                                                    12.0)),
                                                        onPressed: () {
                                                          setState(() {
                                                            selectedStatus =
                                                                val;
                                                          });
                                                        },
                                                        color: selectedStatus ==
                                                                val
                                                            ? AppTheme
                                                                .primaryColor
                                                            : AppTheme
                                                                .dividerColor,
                                                        child: Text('$val',
                                                            style: selectedStatus ==
                                                                    val
                                                                ? AppTheme
                                                                    .textStyle
                                                                    .colored(
                                                                        AppTheme
                                                                            .backgroundColor)
                                                                    .w500
                                                                    .size(13)
                                                                : AppTheme
                                                                    .textStyle
                                                                    .color100
                                                                    .w500
                                                                    .size(13)),
                                                      ),
                                                    ),
                                                  );
                                                })
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20),
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
                                                              .textStyle
                                                              .w500
                                                              .color100
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
                                                    getBotigaCalendar(
                                                      context,
                                                      DateTime.now().subtract(
                                                          Duration(days: 15)),
                                                      DateTime.now().add(
                                                          const Duration(
                                                              days: 60)),
                                                      selectedDate,
                                                      (DateTime date) {
                                                        setState(() {
                                                          selectedDate = date;
                                                          selectedDateForRequest =
                                                              date;
                                                        });
                                                        fetchDeliveryData(
                                                            apartment.id,
                                                            date.getRequestFormatDate());
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Flexible(
                                                        child: Text(
                                                            '${selectedDate.getTodayOrSelectedDate()}',
                                                            style: Theme.of(
                                                                    context)
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
                                        Consumer<DeliveryProvider>(builder:
                                            (ctx, deliveryProvider, _) {
                                          var deliveryListByApartment;
                                          bool isTodaySelected = selectedDate
                                                  .getTodayOrSelectedDate() ==
                                              TODAY;
                                          if (isTodaySelected) {
                                            deliveryListByApartment = deliveryProvider
                                                    .deliveryByApartmentToday[
                                                '${apartment.id}-${selectedDate.getRequestFormatDate()}'];
                                          } else {
                                            deliveryListByApartment =
                                                deliveryProvider
                                                    .deliveryListByApartmentOtherDay;
                                          }

                                          if (deliveryListByApartment == null ||
                                              deliveryListByApartment.length ==
                                                  0) {
                                            return EmptyDelivery();
                                          }

                                          final filterdStatusDetails =
                                              selectedStatus == 'All'
                                                  ? deliveryListByApartment
                                                  : deliveryListByApartment
                                                      .where((deliveryRow) {
                                                      return deliveryRow
                                                              .order.status ==
                                                          statusMap[
                                                              selectedStatus];
                                                    });

                                          if (filterdStatusDetails.length ==
                                              0) {
                                            return EmptyDelivery();
                                          }

                                          var deliveries = filterdStatusDetails;
                                          if (_query != '' && _query != null) {
                                            deliveries = deliveries.where(
                                              (_delivery) {
                                                return _delivery.order.number
                                                        .toLowerCase()
                                                        .contains(_query
                                                            .toLowerCase()) ==
                                                    true;
                                              },
                                            );
                                          }

                                          return Column(
                                            children: [
                                              ...deliveries.map((deliveryRow) {
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : !hasApt
                        ? CommunitiesInfo('No Communities Added')
                        : CommunitiesInfo('No Communities enabled'));
  }

  void loadSettings() async {
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
    _showSearch = false;
    _query = '';
  }

  void fetchDeliveryData(String aprtmentId, String currentDate) async {
    if (aprtmentId != null &&
        aprtmentId != '' &&
        currentDate != null &&
        currentDate != '') {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      if (deliveryProvider
              .deliveryByApartmentToday['$aprtmentId-$currentDate'] !=
          null) {
        return;
      }
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

  Widget _getSearch() {
    return _showSearch
        ? Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SearchBar(
                      placeholder: "Search by order number...",
                      onClear: () {
                        setState(() {
                          _query = '';
                        });
                      },
                      onChange: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                      onSubmit: (_) {},
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.close,
                      color: AppTheme.color100,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSearch = false;
                        _query = '';
                      });
                    },
                  )
                ],
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _getDrawer(bool hasApt, bool hasEnabledApt) {
    return (hasApt && hasEnabledApt)
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
                                          .colored(AppTheme.primaryColor)
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
                                  fetchDeliveryData(apartment.id,
                                      selectedDate.getRequestFormatDate());
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            alignment: Alignment(1, 0.8),
          )
        : SizedBox.shrink();
  }

  Widget _getFloatingButton(bool hasApt, bool hasEnabledApt) {
    return (hasApt && hasEnabledApt)
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
        : SizedBox.shrink();
  }
}
