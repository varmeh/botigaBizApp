import 'package:flutter/material.dart';

import '../../theme/index.dart';
import 'Communites/index.dart' show Communities;
import 'Profile/profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int slelectedTab = 0;
  List<String> tabList = ['Profile', 'Communities'];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabList.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        slelectedTab = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: AppTheme.backgroundColor,
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
                  controller: _controller,
                  labelStyle: AppTheme.textStyle.size(22).w700,
                  labelColor: AppTheme.color100,
                  unselectedLabelColor: AppTheme.color25,
                  isScrollable: true,
                  labelPadding: EdgeInsets.only(left: 0, right: 0),
                  indicatorColor: Colors.transparent,
                  tabs: tabList
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
        controller: _controller,
        children: [
          Profile(),
          Communities(),
        ],
      ),
    );
  }
}
