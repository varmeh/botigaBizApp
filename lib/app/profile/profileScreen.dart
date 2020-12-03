import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../theme/index.dart';
import 'Communites/index.dart' show Communities, SelectArea;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: slelectedTab == 1
          ? Padding(
              padding: EdgeInsets.only(bottom: 28.0),
              child: OpenContainer(
                closedColor: AppTheme.backgroundColor,
                closedShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                closedElevation: 4.0,
                transitionDuration: Duration(milliseconds: 500),
                closedBuilder: (context, openContainer) {
                  return FloatingActionButton.extended(
                    backgroundColor: AppTheme.backgroundColor,
                    elevation: 4.0,
                    icon: const Icon(Icons.add, color: Color(0xff179F57)),
                    label: Text('NEW COMMUNITY',
                        style: AppTheme.textStyle
                            .size(12)
                            .w700
                            .letterSpace(1)
                            .colored(AppTheme.primaryColor)),
                    onPressed: () {
                      openContainer();
                    },
                  );
                },
                openBuilder: (_, __) => SelectArea(),
              ),
            )
          : SizedBox.shrink(),
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
