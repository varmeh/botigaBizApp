import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/index.dart' show DeliveryProvider, ProfileProvider;
import '../../widget/index.dart';
import '../../theme/index.dart';
import '../../models//delivery/index.dart' show AggregateDelivery;
import './deliveryScreen.dart';

import '../../util/index.dart';

class AggregateDeliveryScreen extends StatefulWidget {
  static const routeName = 'aggregate-delivery-screen';
  @override
  _AggregateDeliveryScreenState createState() =>
      _AggregateDeliveryScreenState();
}

class _AggregateDeliveryScreenState extends State<AggregateDeliveryScreen> {
  bool _isLoading;
  bool _isError;
  bool _isInit;
  var _error;
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      if (deliveryProvider.aggregateDeliveries.length == 0) {
        fetchAggregateDeliveryData(selectedDate.getRequestFormatDate());
        _isInit = true;
      }
    }
    super.didChangeDependencies();
  }

  void loadSettings() async {
    _isLoading = false;
    _isError = false;
    _isInit = false;
    selectedDate = DateTime.now();
    _error = null;
  }

  void fetchAggregateDeliveryData(String date) async {
    if (date != null) {
      final deliveryProvider =
          Provider.of<DeliveryProvider>(context, listen: false);
      setState(() {
        _isError = false;
        _isLoading = true;
        _error = null;
      });
      try {
        await deliveryProvider.getAggregateDelivery(date);
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

  @override
  Widget build(BuildContext context) {
    final bool hasApt =
        Provider.of<ProfileProvider>(context, listen: false).totalApartment > 0;
    final bool hasEnabledApt =
        Provider.of<ProfileProvider>(context, listen: false)
            .hasAnyEnabledApartment;
    return _isError
        ? HttpExceptionWidget(
            exception: _error,
            onTap: () {
              fetchAggregateDeliveryData(selectedDate.getRequestFormatDate());
            },
          )
        : Scaffold(
            appBar: BotigaAppBar(
              'Delivery',
              neverShowLeadingBtn: true,
            ),
            backgroundColor: AppTheme.backgroundColor,
            body: (hasApt && hasEnabledApt)
                ? GestureDetector(
                    onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
                    child: SafeArea(
                      child: LoaderOverlay(
                        isLoading: _isLoading,
                        child: Container(
                          color: AppTheme.backgroundColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20, left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order to be sent out",
                                      style: AppTheme.textStyle.w500.color50
                                          .size(13)
                                          .lineHeight(1.3),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          getBotigaCalendar(
                                            context,
                                            DateTime.now()
                                                .subtract(Duration(days: 15)),
                                            DateTime.now()
                                                .add(const Duration(days: 60)),
                                            selectedDate,
                                            (DateTime date) {
                                              setState(() {
                                                selectedDate = date;
                                              });
                                              fetchAggregateDeliveryData(
                                                  date.getRequestFormatDate());
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  '${selectedDate.getTodayOrSelectedDate()}',
                                                  style: AppTheme.textStyle.w500
                                                      .colored(
                                                          AppTheme.primaryColor)
                                                      .size(13)
                                                      .lineHeight(1.3)),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Icon(
                                              Icons.expand_more_sharp,
                                              size: 25,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
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
                                        return Column(
                                          children: [
                                            ...deliveryProvider
                                                .aggregateDeliveries
                                                .map((_delivery) {
                                              return _aggregateDeliveryCard(
                                                  _delivery);
                                            }),
                                            SizedBox(
                                              height: 20,
                                            )
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
                  )
                : !hasApt
                    ? CommunitiesInfo('No Communities Added')
                    : CommunitiesInfo('No Communities enabled'),
          );
  }

  Future pullToRefresh() async {
    final date = selectedDate != null ? selectedDate : DateTime.now();
    return await Provider.of<DeliveryProvider>(context, listen: false)
        .getAggregateDelivery(date.getRequestFormatDate());
  }

  Widget _aggregateDeliveryCard(AggregateDelivery delivery) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DeliveryScreen(argument: {
                  'apartmentId': delivery.apartment.id,
                  'apartmentName': delivery.apartment.apartmentName,
                  'selectedDate': selectedDate,
                  'deliverySlot': delivery.apartment.deliverySlot
                })));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.color05,
                blurRadius: 16.0, // soften the shadow
                spreadRadius: 8.0, //extend the shadow
                offset: Offset(
                  0.0, // Move to right
                  0.0, // Move to bottom
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                child: Card(
                  color: AppTheme.backgroundColor,
                  elevation: 0,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        delivery.apartment.apartmentName,
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${delivery.count} DELIVERIES',
                                            style: AppTheme
                                                .textStyle.color50.w500
                                                .size(12),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Text(
                                            'Deliver by ${delivery.apartment.deliverySlot}',
                                            style: AppTheme
                                                .textStyle.color100.w500
                                                .size(12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
