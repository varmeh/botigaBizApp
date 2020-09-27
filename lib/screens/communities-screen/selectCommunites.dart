import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../widget/common/appHeader.dart';
import "./addContactDetails.dart";

class SelectCommunites extends StatelessWidget {
  static const routeName = '/select-communites';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            AppHeader(
              title: "Communities",
              actionWidget: SizedBox.shrink(),
            ),
            SizedBox(
              height: 20,
            ),
            CommunityTile("Jayanagar"),
            CommunityTile("Basavanagudi"),
            CommunityTile("Jayanagar"),
            CommunityTile("Basavanagudi"),
            CommunityTile("Jayanagar"),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityTile extends StatefulWidget {
  final String title;
  CommunityTile(this.title);
  @override
  _CommunityTileState createState() => _CommunityTileState();
}

class _CommunityTileState extends State<CommunityTile> {
  bool _switchValue = false;
  int selected = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text(
            widget.title,
            style: TextStyle(
                color: Color(0xff121715),
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          trailing: Transform.scale(
            alignment: Alignment.centerRight,
            scale: 0.75,
            child: CupertinoSwitch(
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                });
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: double.infinity,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "How do you deliver?",
                            style: TextStyle(
                                color: Color(0xff121715),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            width: double.infinity,
                            height: 128,
                            decoration: new BoxDecoration(
                              color: Colors.white,
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
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.80,

                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(16.0),
                                            topRight:
                                                const Radius.circular(16.0),
                                          ),
                                        ),
                                        //could change this to Color(0xFF737373),
                                        //so you don't have to change MaterialApp canvasColor
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  AppHeader(
                                                    title: "Fixed duration",
                                                    actionWidget:
                                                        SizedBox.shrink(),
                                                  ),
                                                  SizedBox(
                                                    height: 24,
                                                  ),
                                                  Text(
                                                    "Deliver order in",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff121715),
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 20),
                                                    child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.45,
                                                        child:
                                                            ListWheelScrollViewFixedDuration()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 52,
                                                        child: FlatButton(
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      6.0)),
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder:
                                                                    (builder) {
                                                                  return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.90,
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            new BorderRadius.only(
                                                                          topLeft:
                                                                              const Radius.circular(16.0),
                                                                          topRight:
                                                                              const Radius.circular(16.0),
                                                                        ),
                                                                      ),
                                                                      //could change this to Color(0xFF737373),
                                                                      //so you don't have to change MaterialApp canvasColor
                                                                      child:
                                                                          AddContactDetails());
                                                                });
                                                          },
                                                          textColor: Colors.red,
                                                          color:
                                                              Color(0xff179F57),
                                                          child: Text(
                                                            'Next',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Fixed Duration",
                                        style: TextStyle(
                                            color: Color(0xff121715),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Deliver orders within specific days of order placement. ex: 2 days from order',
                                        style: TextStyle(
                                            color: Color(0xff121715)
                                                .withOpacity(0.5),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Container(
                            width: double.infinity,
                            height: 128,
                            decoration: new BoxDecoration(
                              color: Colors.white,
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
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (builder) {
                                      return Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.80,

                                        decoration: new BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(16.0),
                                            topRight:
                                                const Radius.circular(16.0),
                                          ),
                                        ),
                                        //could change this to Color(0xFF737373),
                                        //so you don't have to change MaterialApp canvasColor
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  AppHeader(
                                                    title: "Fixed day",
                                                    actionWidget:
                                                        SizedBox.shrink(),
                                                  ),
                                                  SizedBox(
                                                    height: 24,
                                                  ),
                                                  Text(
                                                    "Deliver order in",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff121715),
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            bottom: 20),
                                                    child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.45,
                                                        child:
                                                            ListWheelScrollViewFixedDay()),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 52,
                                                        child: FlatButton(
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                          .circular(
                                                                      6.0)),
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder:
                                                                    (builder) {
                                                                  return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.90,
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            new BorderRadius.only(
                                                                          topLeft:
                                                                              const Radius.circular(16.0),
                                                                          topRight:
                                                                              const Radius.circular(16.0),
                                                                        ),
                                                                      ),
                                                                      //could change this to Color(0xFF737373),
                                                                      //so you don't have to change MaterialApp canvasColor
                                                                      child:
                                                                          AddContactDetails());
                                                                });
                                                          },
                                                          textColor: Colors.red,
                                                          color:
                                                              Color(0xff179F57),
                                                          child: Text(
                                                            'Next',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Fixed Day",
                                        style: TextStyle(
                                            color: Color(0xff121715),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Deliver orders on a specific day of the week. ex: every Sunday',
                                        style: TextStyle(
                                            color: Color(0xff121715)
                                                .withOpacity(0.5),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).whenComplete(() {
                  setState(() {
                    _switchValue = false;
                  });
                });
              },
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).backgroundColor,
          thickness: 1,
        )
      ],
    );
  }
}

class ListWheelScrollViewFixedDay extends StatefulWidget {
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
              color: _selectedItemIndex == 0 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Monday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 1 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Tuesday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 2 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Wednesday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 3 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Thrusday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 4 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Friday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 5 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          'Saturday',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 6 ? Colors.black : Colors.black12),
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
      onSelectedItemChanged: (index) => {
        setState(() {
          _selectedItemIndex = index;
        })
      },
    );
  }
}

//for fixed duration
class ListWheelScrollViewFixedDuration extends StatefulWidget {
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
              color: _selectedItemIndex == 0 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '2 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 1 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '3 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 2 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '4 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 3 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '5 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 4 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '6 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 5 ? Colors.black : Colors.black12),
        ),
      ),
      Center(
        child: Text(
          '7 days',
          style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: _selectedItemIndex == 6 ? Colors.black : Colors.black12),
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
      onSelectedItemChanged: (index) => {
        setState(() {
          _selectedItemIndex = index;
        })
      },
    );
  }
}
