import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'orderList.dart';
import '../../util/index.dart';
import '../../theme/index.dart';
import '../../widget/index.dart';
import '../../providers/index.dart' show OrdersProvider, ProfileProvider;

class OrdersHome extends StatefulWidget {
  static const routeName = 'orders-home';
  @override
  _OrdersHomeState createState() => _OrdersHomeState();
}

class _OrdersHomeState extends State<OrdersHome> {
  var _loadData = true;
  DateTime selectedDate;

  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _calendarController.dispose();
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
              return HttpServiceExceptionWidget(
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
                  color: AppTheme.dividerColor,
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

  Widget _orderHeader(int revenue, int totalOrder, String name) {
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
                        _showCalendar();
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
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 0,
              color: AppTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 40),
                    Column(
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
                          '${Constants.rupeeSymbol} $revenue',
                          style: AppTheme.textStyle.color100.w500.size(22),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 106,
                    ),
                    Column(
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard(
      String apartmentId, String apartmentName, int revenue, int totalOrder) {
    return InkWell(
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
                color: AppTheme.color05,
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${Constants.revenue}',
                                          style: AppTheme.textStyle.color50.w500
                                              .size(12),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '${Constants.rupeeSymbol} $revenue',
                                          style: AppTheme
                                              .textStyle.color100.w500
                                              .size(17),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 95,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${Constants.orders}',
                                          style: AppTheme.textStyle.color50.w500
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

  Future _showCalendar() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        child: SafeArea(
          child: TableCalendar(
            initialSelectedDay: selectedDate,
            startDay: DateTime.now().subtract(Duration(days: 15)),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            calendarStyle: CalendarStyle(
                todayColor: AppTheme.primaryColorVariant.withOpacity(0.5),
                selectedColor: AppTheme.primaryColor,
                outsideDaysVisible: true,
                weekendStyle: AppTheme.textStyle.color100,
                outsideWeekendStyle: AppTheme.textStyle.color50),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: AppTheme.textStyle.colored(AppTheme.color100),
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: false,
              formatButtonVisible: false,
            ),
            onDaySelected: (date, events, _) {
              Navigator.of(context).pop();
              setState(() {
                selectedDate = date;
                _loadData = true;
              });
            },
            calendarController: _calendarController,
          ),
        ),
      ),
    );
  }

  Widget _communitiesScreen(String name, String info) {
    return Container(
      color: AppTheme.dividerColor,
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
    );
  }
}
