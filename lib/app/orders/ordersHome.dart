import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show OrdersProvider, ProfileProvider;
import '../../theme/index.dart';
import '../../util/index.dart';
import '../../widget/index.dart';
import 'index.dart';

class OrdersHome extends StatefulWidget {
  static const routeName = 'orders-home';
  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends State<OrdersHome> {
  final String rupeeSymbol = '\u20B9';
  var _loadData = true;
  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: _loadData
              ? provider
                  .fetchAggregatedOrders(selectedDate.getRequestFormatDate())
              : null,
          builder: (context, snapshot) {
            _loadData = false;
            if (snapshot.hasError) {
              return HttpExceptionWidget(
                exception: snapshot.error,
                onTap: () {
                  setState(() => _loadData = true);
                },
              );
            }
            final profileProvider =
                Provider.of<ProfileProvider>(context, listen: false);

            if (profileProvider.totalApartment == 0) {
              return _communitiesScreen(
                profileProvider.profileInfo.firstName,
                'No Communities Added',
              );
            }

            if (!profileProvider.hasAnyEnabledApartment) {
              return _communitiesScreen(
                profileProvider.profileInfo.firstName,
                'No Communities enabled',
              );
            }

            final aggregatedOrders = provider.aggregatedOrders;

            return RefreshIndicator(
              onRefresh: () => provider
                  .fetchAggregatedOrders(selectedDate.getRequestFormatDate()),
              color: AppTheme.primaryColor,
              child: LoaderOverlay(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                child: Container(
                  color: AppTheme.backgroundColor,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    children: [
                      _orderHeader(
                        aggregatedOrders?.totalRevenue ?? 0,
                        aggregatedOrders?.totalOrders ?? 0,
                        profileProvider.profileInfo.firstName,
                      ),
                      ...aggregatedOrders == null ||
                              aggregatedOrders.apartmentWiseBreakup.length == 0
                          ? [EmptyOrders()]
                          : aggregatedOrders.apartmentWiseBreakup.map(
                              (apartment) => _orderCard(
                                apartment.id,
                                apartment.apartmentName,
                                apartment.revenue,
                                apartment.orders,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _orderHeader(double revenue, int totalOrder, String name) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(double.infinity, 285)),
      child: new Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 240,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 65, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Hi, $name',
                      style: AppTheme.textStyle
                          .colored(AppTheme.backgroundColor)
                          .w700
                          .size(22),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        getBotigaCalendar(
                          context,
                          DateTime.now().subtract(const Duration(days: 15)),
                          DateTime.now().add(const Duration(days: 60)),
                          selectedDate,
                          (DateTime date) {
                            setState(() {
                              selectedDate = date;
                              _loadData = true;
                            });
                          },
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${selectedDate.getTodayOrSelectedDate()}',
                            style: AppTheme.textStyle
                                .colored(AppTheme.backgroundColor)
                                .w500
                                .size(15),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Icon(
                            Icons.expand_more_sharp,
                            size: 25,
                            color: AppTheme.backgroundColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 170,
            left: 20,
            right: 20,
            bottom: 0,
            child: Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.color25,
                    blurRadius: 40.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right
                      0.0, // Move to bottom
                    ),
                  ),
                ],
              ),
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: AppTheme.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 27.86, right: 27.86),
                  width: double.infinity,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'REVENUE',
                              style: AppTheme.textStyle.color50.w500.size(12),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '$rupeeSymbol $revenue',
                              style: AppTheme.textStyle.color100.w500.size(22),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'ORDERS',
                              style: AppTheme.textStyle.color50.w500.size(12),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$totalOrder',
                              style: AppTheme.textStyle.color100.w500.size(22),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(String apartmentId, String apartmentName, double revenue,
      int totalOrder) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed(OrderList.routeName, arguments: {
          'apartmentId': apartmentId,
          'apartmentName': apartmentName,
          'selectedDateForRequest': selectedDate
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.color25,
                blurRadius: 40.0, // soften the shadow
                spreadRadius: 0.0, //extend the shadow
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 18,
                                  left: 27.86,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Icon(
                                        BotigaIcons.building,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7.86,
                                    ),
                                    Flexible(
                                      child: Text(
                                        '$apartmentName',
                                        style: AppTheme.textStyle.color100.w500
                                            .size(15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Divider(
                                  thickness: 1.3,
                                  color: AppTheme.dividerColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 27.86, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'REVENUE',
                                            style: AppTheme
                                                .textStyle.color50.w500
                                                .size(12),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            '$rupeeSymbol $revenue',
                                            style: AppTheme
                                                .textStyle.color100.w500
                                                .size(17),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'ORDERS',
                                            style: AppTheme
                                                .textStyle.color50.w500
                                                .size(12),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            '$totalOrder',
                                            style: AppTheme
                                                .textStyle.color100.w500
                                                .size(17),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _communitiesScreen(String name, String info) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 60),
        height: 800,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 240,
                padding: const EdgeInsets.only(top: 65, left: 25),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(5.0),
                    bottomRight: const Radius.circular(5.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  'Hi $name',
                  style: AppTheme.textStyle
                      .colored(AppTheme.backgroundColor)
                      .w700
                      .size(22),
                ),
              ),
            ),
            Positioned(
              top: 170,
              left: 20,
              right: 20,
              height: 500,
              child: CommunitiesInfo(info),
            ),
          ],
        ),
      ),
    );
  }
}
