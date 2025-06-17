import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../components/day_event_list.dart';
import '../components/event_detail_sheet.dart';
import '../features/calendar_features/calendar_data_source.dart';
import '../features/common_features/crud_features.dart';
import '../features/event_service/event_service.dart';
import '../features/providers/selected_date_provider.dart';
import '../models/event_model/event_model.dart';
import '../utils/event_utils.dart';
import '../utils/time_utils.dart';
import 'create_event.dart';


class MonthlyCalendar extends ConsumerStatefulWidget {
  const MonthlyCalendar({super.key});

  @override
  MonthlyCalendarState createState() => MonthlyCalendarState();
}

class MonthlyCalendarState extends ConsumerState<MonthlyCalendar> {
  late CalendarController _calendarController;
  late DateTime _selectedDate;
  EventDataSource? _dataSource;
  List<EventModel> _selectedDateEvents = [];
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _selectedDate = ref.read(selectedDateProvider);
    _loadEvents();
    // updateSelectedDateEvents는 _loadEvents 이후 호출해야 최신 데이터 반영 가능
  }

  Future<void> _loadEvents() async {
    final events = await fetchAllEvents(ref);
    setState(() {
      _dataSource = EventDataSource(events);
      _opacity = 1.0;
      updateSelectedDateEvents();
    });
    print('로드된 이벤트 수: ${events.length}');
    // ... 기타 코드
  }

  // 분리불가능
  void updateSelectedDateEvents() {
    _selectedDateEvents = _dataSource?.appointments
        ?.where((event) => TimeUtils.isSameDay(event.from, _selectedDate))
        .map((event) => event as EventModel)
        .toList() ??
        [];
  }


  Widget _buildDayEventsList() {
    return DayEventsList(
      events: _selectedDateEvents,
      onTapEvent: (event) {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return EventDetailSheet(
              event: event,
              onDelete: () {
                Navigator.pop(context);
                showDeleteDialog(event, context, ref, () async {
                  await _loadEvents();
                });
              },
              onEdit: () {
                Navigator.pop(context);
                // 수정 화면 이동 등 구현
              },
            );
          },
        );
      },
      onLongPressEvent: (event) => showDeleteDialog(event, context, ref, () async {
        await _loadEvents();
      }),
    );
  }


  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventList = ref.watch(eventServiceProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          DateFormat('yyyy MMMM').format(_selectedDate),
          style: GoogleFonts.tiltWarp(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SfCalendar(
                view: CalendarView.month,
                dataSource: _dataSource,
                controller: _calendarController,
                viewHeaderHeight: 16,
                viewHeaderStyle: const ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                monthCellBuilder:
                    (BuildContext buildContext, MonthCellDetails details) {
                  bool hasAppointments = _dataSource?.appointments?.any(
                          (event) => TimeUtils.isSameDay(event.from, details.date)) ??
                      false;

                  final middleDate =
                  details.visibleDates[details.visibleDates.length ~/ 2];

                  List<EventModel> dayEvents = _dataSource?.appointments
                      ?.where(
                          (event) => TimeUtils.isSameDay(event.from, details.date))
                      .map((event) => event as EventModel)
                      .toList() ??
                      [];

                  Color textColor;
                  if (details.date.month == middleDate.month) {
                    textColor = Colors.black;
                  } else if (details.date.isBefore(middleDate)) {
                    textColor = Colors.grey[400]!;
                  } else {
                    textColor = Colors.grey[400]!;
                  }

                  if (TimeUtils.isSameDay(details.date, DateTime.now())) {
                    textColor = Colors.blue;
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black26,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          details.date.day.toString(),
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                cellBorderColor: Colors.transparent,
                headerHeight: 0,
                todayHighlightColor: Colors.black,
                selectionDecoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.1),
                  border: Border.all(color: Colors.black87, width: 2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                ),
                monthViewSettings: const MonthViewSettings(
                  dayFormat: 'EEE',
                  appointmentDisplayCount: 3,
                  showTrailingAndLeadingDates: true,
                ),
                onViewChanged: (ViewChangedDetails details) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      DateTime visibleMonthDate = details
                          .visibleDates[details.visibleDates.length ~/ 2];
                      int currentDay = _selectedDate.day;
                      int lastDayOfMonth = DateTime(visibleMonthDate.year,
                          visibleMonthDate.month + 1, 0)
                          .day;
                      int targetDay = currentDay > lastDayOfMonth
                          ? lastDayOfMonth
                          : currentDay;
                      DateTime newSelectedDate = DateTime(visibleMonthDate.year,
                          visibleMonthDate.month, targetDay);
                      _selectedDate = newSelectedDate;
                      _calendarController.selectedDate = newSelectedDate;
                      ref
                          .read(selectedDateProvider.notifier)
                          .updateDate(newSelectedDate);
                      updateSelectedDateEvents();
                    });
                  });
                },
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.calendarCell) {
                    if (TimeUtils.isSameDay(details.date!, _selectedDate)) {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                              CreateEventPage(
                                initialDate: details.date!,
                                onEventCreated: (EventModel newEvent) async {
                                  await _loadEvents();
                                },
                              ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          },
                        ),
                      );
                    } else {
                      setState(() {
                        _selectedDate = details.date!;
                        ref
                            .read(selectedDateProvider.notifier)
                            .updateDate(_selectedDate);
                        updateSelectedDateEvents();
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Taskit  ${DateFormat('MM/dd').format(_selectedDate)} ',
                style: GoogleFonts.tiltWarp(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 6,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 400),
                child: _selectedDateEvents.isNotEmpty
                    ? _buildDayEventsList()
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/empty_taskit.png', width: 36),
                      const SizedBox(height: 16),
                      const Text(
                        'Task it easy.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
