import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../providers/index.dart' show DeliveryProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'deliveryRow.dart';
import 'emptyDelivery.dart';

const TODAY = 'TODAY';

class DeliveryScreen extends StatefulWidget {
  static const routeName = 'all-delivery-list';
  final argument;

  DeliveryScreen({@required this.argument});
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  Map<String, String> statusMap = {
    'All': 'All',
    'Open': 'open',
    'Shipped': 'out',
    'Delivered': 'delivered',
    'Cancelled': 'cancelled'
  };

  bool _isLoading;
  bool _isError;
  bool _isInit;
  bool _isProcessing;
  var _error;
  bool _showSearch;
  String _query;
  String selectedStatus;
  String apartmentId;
  String apartmentName;
  DateTime selectedDate;
  String deliverySlot;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  void dispose() {
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
    return _isError
        ? HttpExceptionWidget(
            exception: _error,
            onTap: () {
              fetchDefaultDeliveryDetails();
            },
          )
        : LoaderOverlay(
            isLoading: _isLoading,
            child: Scaffold(
                appBar: !_showSearch
                    ? BotigaAppBar(
                        apartmentName,
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
                body: GestureDetector(
                  onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
                  child: SafeArea(
                    child: LoaderOverlay(
                      isLoading: _isProcessing,
                      child: Container(
                        color: AppTheme.backgroundColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _getSearch(),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Container(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    ...statusMap.keys.map((val) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Container(
                                          height: 34,
                                          child: FlatButton(
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0)),
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
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () => pullToRefresh(),
                                color: AppTheme.primaryColor,
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Consumer<DeliveryProvider>(
                                        builder: (ctx, deliveryProvider, _) {
                                      var deliveryListByApartment;
                                      bool isTodaySelected = selectedDate
                                              .getTodayOrSelectedDate() ==
                                          TODAY;
                                      if (isTodaySelected) {
                                        deliveryListByApartment = deliveryProvider
                                                .deliveryByApartmentToday[
                                            '$apartmentId-${selectedDate.getRequestFormatDate()}'];
                                      } else {
                                        deliveryListByApartment =
                                            deliveryProvider
                                                .deliveryListByApartmentOtherDay;
                                      }

                                      if (deliveryListByApartment == null ||
                                          deliveryListByApartment.length == 0) {
                                        return EmptyDelivery();
                                      }

                                      final filterdStatusDetails =
                                          selectedStatus == 'All'
                                              ? deliveryListByApartment
                                              : selectedStatus == 'Open'
                                                  ? deliveryListByApartment
                                                      .where((deliveryRow) {
                                                      return deliveryRow.order
                                                                  .status ==
                                                              'open' ||
                                                          deliveryRow.order
                                                                  .status ==
                                                              'delayed';
                                                    })
                                                  : deliveryListByApartment
                                                      .where((deliveryRow) {
                                                      return deliveryRow
                                                              .order.status ==
                                                          statusMap[
                                                              selectedStatus];
                                                    });

                                      var deliveries = filterdStatusDetails;
                                      if (_query != '' && _query != null) {
                                        deliveries = deliveries.where(
                                          (_delivery) {
                                            return _delivery.order.number
                                                    .toLowerCase()
                                                    .contains(
                                                        _query.toLowerCase()) ==
                                                true;
                                          },
                                        );
                                      }

                                      final slotMsg = deliverySlot != null &&
                                              deliverySlot.isNotEmpty
                                          ? 'Delivery by $deliverySlot'
                                          : 'Please add delivery slot';
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0,
                                                left: 20.0,
                                                right: 20,
                                                bottom: 20),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${filterdStatusDetails.length} Deliveries',
                                                  style: AppTheme
                                                      .textStyle.color50.w500
                                                      .size(12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: AppTheme.primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 6,
                                            ),
                                            child: Center(
                                              child: Text(
                                                slotMsg,
                                                style: AppTheme.textStyle.w500
                                                    .size(13)
                                                    .lineHeight(1.3)
                                                    .colored(
                                                      AppTheme.backgroundColor,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          ...deliveries.map((deliveryRow) {
                                            return DeliveryRow(
                                                deliveryRow,
                                                apartmentName,
                                                apartmentId,
                                                this._handleOutForDelivery,
                                                selectedDate,
                                                this._handleMarkAsDeliverd);
                                          })
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          );
  }

  void loadSettings() {
    final arguments = widget.argument;
    _isLoading = false;
    _isError = false;
    _isInit = false;
    _isProcessing = false;
    selectedDate = DateTime.now();
    _error = null;
    _showSearch = false;
    _query = '';
    selectedStatus = 'All';
    apartmentId = arguments['apartmentId'];
    apartmentName = arguments['apartmentName'];
    selectedDate = arguments['selectedDate'];
    deliverySlot = arguments['deliverySlot'];
  }

  void fetchDeliveryData(String aprtmentId, String date) async {
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: false);
    if (deliveryProvider.deliveryByApartmentToday['$aprtmentId-$date'] !=
        null) {
      return;
    }
    setState(() {
      _isError = false;
      _isLoading = true;
      _error = null;
    });
    try {
      await deliveryProvider.fetchDeliveryListByApartment(aprtmentId, date);
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

  void _handleOutForDelivery(String orderId) async {
    setState(() {
      _isProcessing = true;
    });
    try {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      await deliveryProvider.setStatusOutForDelivery(orderId);
      await deliveryProvider.fetchDeliveryListByApartment(
          apartmentId, selectedDate.getRequestFormatDate());
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
      await deliveryProvider.setDeliveryStatus(orderId);
      await deliveryProvider.fetchDeliveryListByApartment(
          apartmentId, selectedDate.getRequestFormatDate());
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
    fetchDeliveryData(apartmentId, selectedDate.getRequestFormatDate());
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

  Future pullToRefresh() async {
    return await Provider.of<DeliveryProvider>(context, listen: false)
        .fetchDeliveryListByApartment(
            apartmentId, selectedDate.getRequestFormatDate());
  }
}
