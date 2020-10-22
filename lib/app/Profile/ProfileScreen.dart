import 'package:flutter/material.dart';
import 'Profile/Profile.dart';
import '../../theme/index.dart';
import 'Communites/communities.dart';
import 'Communites/selectArea.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int slelectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 32.0),
          child: slelectedTab == 1
              ? FloatingActionButton.extended(
                  backgroundColor: AppTheme.backgroundColor,
                  elevation: 4.0,
                  icon: const Icon(Icons.add, color: Color(0xff179F57)),
                  label: Text("NEW COMMUNITY",
                      style: AppTheme.textStyle
                          .size(12)
                          .w700
                          .letterSpace(1)
                          .colored(AppTheme.primaryColor)),
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
            preferredSize: Size.fromHeight(11),
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
                    labelStyle: AppTheme.textStyle.size(22).w700,
                    labelColor: AppTheme.color100,
                    unselectedLabelColor: AppTheme.color25,
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
            Profile(),
            Communities(),
          ],
        ),
      ),
    );
  }
}
