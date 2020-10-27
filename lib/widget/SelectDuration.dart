import 'package:flutter/material.dart';

//For Fixed Days
class ListWheelScrollViewFixedDay extends StatefulWidget {
  final Function setDeliveryDays;
  ListWheelScrollViewFixedDay({@required this.setDeliveryDays});
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
            color: _selectedItemIndex == 0 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Monday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 1 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Tuesday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 2 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Wednesday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 3 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Thrusday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 4 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Friday',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: _selectedItemIndex == 5 ? Colors.black : Colors.black12,
          ),
        ),
      ),
      Center(
        child: Text(
          'Saturday',
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
      magnification: 1.5,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      diameterRatio: 2,
      squeeze: 0.8,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedItemIndex = index;
        });
        widget.setDeliveryDays(index + 1);
      },
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
          '1 days',
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
      magnification: 1.5,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      diameterRatio: 2,
      squeeze: 0.8,
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedItemIndex = index;
        });
        widget.setDeliveryDays(index + 1);
      },
    );
  }
}
