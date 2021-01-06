import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils/date_models.dart';
import 'utils/date_utils.dart';
import '../../theme/index.dart';
import '../botigaBottomModal.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BotigaCalendar extends StatefulWidget {
  final DateTime minDate;
  final DateTime maxDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDayPressed;
  final EdgeInsetsGeometry listPadding;

  BotigaCalendar(
      {@required this.minDate,
      @required this.maxDate,
      @required this.selectedDate,
      this.onDayPressed,
      this.listPadding})
      : assert(minDate != null),
        assert(maxDate != null),
        assert(minDate.isBefore(maxDate));

  @override
  _BotigaCalendarState createState() => _BotigaCalendarState();
}

class _BotigaCalendarState extends State<BotigaCalendar> {
  DateTime _minDate;
  DateTime _maxDate;
  List<Month> _months;
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _months = DateUtils.extractWeeks(widget.minDate, widget.maxDate);
    _minDate = widget.minDate.removeTime();
    _maxDate = widget.maxDate.removeTime();
  }

  @override
  void didUpdateWidget(BotigaCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _months = DateUtils.extractWeeks(widget.minDate, widget.maxDate);
      _minDate = widget.minDate.removeTime();
      _maxDate = widget.maxDate.removeTime();
    }
  }

  void _scrollToSelectedMonth(int positionToScroll) {
    _scrollController.scrollTo(
        index: positionToScroll, duration: Duration(milliseconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              padding: widget.listPadding ?? EdgeInsets.zero,
              itemCount: _months.length,
              itemBuilder: (BuildContext context, int position) {
                return _MonthView(
                    scrollToSelected: _scrollToSelectedMonth,
                    positionToScroll: position,
                    month: _months[position],
                    minDate: _minDate,
                    maxDate: _maxDate,
                    onDayPressed: widget.onDayPressed,
                    selectedDate: widget.selectedDate);
              }),
        ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  final Month month;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onDayPressed;
  final DateTime selectedDate;
  final Function scrollToSelected;
  final int positionToScroll;

  _MonthView(
      {@required this.month,
      @required this.minDate,
      @required this.maxDate,
      @required this.selectedDate,
      @required this.scrollToSelected,
      @required this.positionToScroll,
      this.onDayPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DefaultMonthView(month: month.month, year: month.year),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Table(
            children: [
              TableRow(
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                    .map(
                      (String d) => Center(
                        child: Text(
                          d,
                          style: AppTheme.textStyle.color25.w600
                              .size(16)
                              .lineHeight(1.3),
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Table(
            children: month.weeks
                .map((Week week) => _generateFor(context, week))
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  TableRow _generateFor(BuildContext context, Week week) {
    DateTime firstDay = week.firstDay;

    return TableRow(
      children: List<Widget>.generate(DateTime.daysPerWeek, (int position) {
        DateTime day = DateTime(week.firstDay.year, week.firstDay.month,
            firstDay.day + (position - (firstDay.weekday - 1)));

        if ((position + 1) < week.firstDay.weekday ||
            (position + 1) > week.lastDay.weekday ||
            day.isBefore(minDate) ||
            day.isAfter(maxDate)) {
          return const SizedBox();
        } else {
          return AspectRatio(
              aspectRatio: 1.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onDayPressed != null
                    ? () {
                        if (onDayPressed != null) {
                          onDayPressed(day);
                        }
                      }
                    : null,
                child: _DefaultDayView(
                    date: day,
                    selectedDate: selectedDate,
                    scrollToSelected: scrollToSelected,
                    positionToScroll: positionToScroll),
              ));
        }
      }, growable: false),
    );
  }
}

class _DefaultMonthView extends StatelessWidget {
  final int month;
  final int year;

  _DefaultMonthView({@required this.month, @required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Text(
        DateFormat('MMMM yyyy').format(DateTime(year, month)).toUpperCase(),
        style: AppTheme.textStyle.color25.w600.size(16).lineHeight(1.3),
      ),
    );
  }
}

class _DefaultDayView extends StatelessWidget {
  final DateTime date;
  final DateTime selectedDate;
  final Function scrollToSelected;
  final int positionToScroll;

  _DefaultDayView(
      {@required this.date,
      @required this.selectedDate,
      @required this.scrollToSelected,
      @required this.positionToScroll});

  @override
  Widget build(BuildContext context) {
    bool isSelected = DateFormat('dd MMMM yyyy').format(selectedDate) ==
        DateFormat('dd MMMM yyyy').format(date);
    if (isSelected) {
      Future.delayed(const Duration(milliseconds: 1), () {
        scrollToSelected(positionToScroll);
      });
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color:
                isSelected == true ? AppTheme.primaryColor : Colors.transparent,
            shape: BoxShape.circle),
        child: Center(
          child: Text(
            DateFormat('d').format(date),
            style: isSelected == true
                ? AppTheme.textStyle.w500
                    .size(15)
                    .lineHeight(1.5)
                    .colored(AppTheme.backgroundColor)
                : AppTheme.textStyle.color100.w500.size(15).lineHeight(1.5),
          ),
        ),
      ),
    );
  }
}

typedef MonthBuilder = Widget Function(
    BuildContext context, int month, int year);
typedef DayBuilder = Widget Function(BuildContext context, DateTime date,
    {bool isSelected});
typedef PeriodChanged = void Function(DateTime minDate, DateTime maxDate);

void getBotigaCalendar(BuildContext context, DateTime minDate, DateTime maxDate,
    DateTime selectedDate, Function onDayPressed) {
  BotigaBottomModal(
    isDismissible: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 26),
          child: Text(
            "Select date",
            style: AppTheme.textStyle.color100.w600.size(22).lineHeight(1.3),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
            ),
          ),
          child: BotigaCalendar(
            minDate: minDate,
            maxDate: maxDate,
            listPadding: EdgeInsets.zero,
            selectedDate: selectedDate,
            onDayPressed: (DateTime date) {
              Navigator.of(context).pop();
              onDayPressed(date);
            },
          ),
        ),
      ],
    ),
  ).show(context);
}
