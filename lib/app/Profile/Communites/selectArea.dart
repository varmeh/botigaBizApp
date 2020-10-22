import 'package:botiga_biz/widget/SearchBar.dart';
import 'package:flutter/material.dart';
import 'selectCommunites.dart';
import '../../../theme/index.dart';

class SelectArea extends StatefulWidget {
  static const routeName = '/select-area';
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  final areas = [
    "Jayanagar",
    "Basavanagudi",
    "Jayanagar",
    "Basavanagudi",
    "Jayanagar",
    "Basavanagudi",
    "Jayanagar",
    "Basavanagudi",
    "Jayanagar",
    "Basavanagudi",
    "Jayanagar",
    "Basavanagudi",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            BotigaIcons.arrowBack,
            color: AppTheme.color100,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          child: Text(
            'Select Area',
            style: AppTheme.textStyle.w700.color100.size(22).lineHeight(1.0),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppTheme.backgroundColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SearchBar(
                  placeholder: "Search...",
                  onSubmit: null,
                  onChange: null,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    return getTile(areas[index], context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getTile(String txt, BuildContext context) {
  return ListTile(
    onTap: () {
      Navigator.of(context).pushNamed(SelectCommunites.routeName);
    },
    contentPadding: EdgeInsets.only(left: 20, right: 20),
    title: Text(txt, style: AppTheme.textStyle.color100.size(17).w500),
  );
}
