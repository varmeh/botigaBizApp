import 'package:flutter/material.dart';

import '../theme/index.dart';

// For Fixed Days Selection
class FixedDaysSelector extends StatefulWidget {
  final Function setDeliveryWeek;
  final StateSetter setModalState;

  FixedDaysSelector({
    @required this.setDeliveryWeek,
    @required this.setModalState,
  });

  @override
  _FixedDaysSelectorState createState() => _FixedDaysSelectorState();
}

class _FixedDaysSelectorState extends State<FixedDaysSelector> {
  var _week = [
    ['Sunday', false],
    ['Monday', false],
    ['Tuesday', false],
    ['Wednesday', false],
    ['Thursday', false],
    ['Friday', false],
    ['Saturday', false],
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _week.length,
      itemBuilder: (context, index) {
        return _dayButton(index);
      },
    );
  }

  Widget _dayButton(int index) {
    final _day = _week[index];
    return InkWell(
      onTap: () {
        widget.setModalState(() => _week[index][1] = !_day[1]);
        List<bool> _schedule = _week.map((e) => e[1]).toList().cast<bool>();
        widget.setDeliveryWeek(_schedule);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: _day[1] ? AppTheme.primaryColor : AppTheme.dividerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 14, bottom: 14.0),
          child: Text(
            _day[0],
            textAlign: TextAlign.left,
            style: AppTheme.textStyle
                .colored(
                  _day[1] ? AppTheme.backgroundColor : AppTheme.color100,
                )
                .size(15)
                .w600,
          ),
        ),
      ),
    );
  }
}

//for fixed duration
class ListWheelScrollViewFixedDuration extends StatefulWidget {
  final Function setDeliveryDays;
  ListWheelScrollViewFixedDuration({@required this.setDeliveryDays});
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
          '1 day',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 0 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '2 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 1 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '3 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 2 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '4 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 3 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '5 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 4 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '6 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 5 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          '7 days',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 6 ? Colors.black : Colors.black12,
          ),
        ),
      )
    ];

    return ListWheelScrollView(
      offAxisFraction: 0,
      itemExtent: 60,
      children: items,
      magnification: 1.4,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      diameterRatio: 2,
      squeeze: 1,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedItemIndex = index;
        });
        widget.setDeliveryDays(index + 1);
      },
    );
  }
}
