import 'dart:async';
import 'package:flutter/material.dart';
import 'selectCommunites.dart';
import '../../../util/index.dart';
import '../../../theme/index.dart';
import '../../../widget/index.dart';
import '../../../util/network/index.dart' show HttpService;

class SelectArea extends StatefulWidget {
  static const routeName = '/select-area';
  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea> {
  List<String> _searchResult = [];
  List<String> _areas = [];
  TextEditingController controller = new TextEditingController();
  bool _isLoading, _isError, _isInit;
  var _error;
  String _searchQuery;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isError = false;
    _error = null;
    _isInit = false;
    _searchQuery = '';
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      getAreasForcity().then((response) {
        setState(() {
          _isLoading = false;
          for (final area in response) {
            _areas.add(area);
          }
        });
      }).catchError((err) {
        setState(() {
          _isLoading = false;
          _isError = true;
          _error = err;
        });
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Future getAreasForcity() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _error = null;
    });
    return await HttpService().get('${Constants.CITY_AREAS}');
  }

  Widget getTile(String txt) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(SelectCommunites.routeName);
      },
      contentPadding: EdgeInsets.only(left: 20, right: 20),
      title: Text(txt, style: AppTheme.textStyle.color100.size(17).w500),
    );
  }

  void onSearchTextChanged(String text) async {
    setState(() {
      _searchQuery = text;
    });
    _searchResult.clear();
    if (text.isEmpty) {
      return null;
    }
    _areas.forEach((area) {
      if (area.contains(text) || area.contains(text)) _searchResult.add(area);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
            style: AppTheme.textStyle.w700.color100.size(22).lineHeight(1.2),
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.color05,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: ListTile(
                  title: TextField(
                    cursorHeight: 16.0,
                    cursorColor: AppTheme.color05,
                    textInputAction: TextInputAction.search,
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: AppTheme.textStyle.w500.color50
                            .size(15.0)
                            .lineHeight(1.3),
                        border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: _searchQuery == ''
                      ? Icon(BotigaIcons.search)
                      : GestureDetector(
                          child: Icon(Icons.clear),
                          onTap: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Loader()
                  : _isError
                      ? HttpServiceExceptionWidget(
                          exception: _error,
                          onTap: () {
                            getAreasForcity();
                          },
                        )
                      : _searchResult.length != 0 || controller.text.isNotEmpty
                          ? ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return getTile(_searchResult[i]);
                              },
                            )
                          : ListView.builder(
                              itemCount: _areas.length,
                              itemBuilder: (context, index) {
                                return getTile(_areas[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
