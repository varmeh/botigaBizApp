import 'package:flutter/material.dart';
import "./profileScreen.dart";
import "../communities-screen/communities.dart";
import "../communities-screen/selectArea.dart";

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int slelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 32.0),
          child: slelectedTab == 1
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  elevation: 4.0,
                  icon: const Icon(Icons.add, color: Color(0xff179F57)),
                  label: Text(
                    "NEW COMMUNITY",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff179F57),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SelectArea.routeName);
                  },
                )
              : null,
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TabBar(
                    onTap: (int index) {
                      setState(() {
                        slelectedTab = index;
                      });
                    },
                    labelStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    labelColor: Color(0xff121715),
                    unselectedLabelColor: Color(0xff000000).withOpacity(0.25),
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(left: 0, right: 0),
                    indicatorColor: Colors.transparent,
                    tabs: ["Profile", "Communities"]
                        .map(
                          (label) => Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Tab(text: '$label'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ProfileScreen(),
            Communities(),
          ],
        ),
      ),
    );
  }
}
