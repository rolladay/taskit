import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../components/appointment_builder.dart';
import '../components/common_components.dart';
import '../components/event_detail_sheet.dart';
import '../features/calendar_features/calendar_data_source.dart';
import '../features/providers/selected_date_provider.dart';
import '../models/event_model/event_model.dart';
import '../services/objectbox/event_model_repository.dart';
import 'create_event.dart';


class DayPlanner extends ConsumerStatefulWidget {
  const DayPlanner({super.key});

  @override
  DayPlannerState createState() => DayPlannerState();
}

class DayPlannerState extends ConsumerState<DayPlanner> {
  late CalendarController _calendarController;
  EventDataSource? _dataSource;
  late DateTime _selectedDate;// 초기 날짜 설정

  // initState안에서 컨트롤러 정의가 이뤄지는게 좋음. 메모리 관리 등
  @override
  void initState() {
    super.initState();
    _selectedDate = ref.read(selectedDateProvider);
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.day;
    _calendarController.displayDate = _selectedDate;
    _loadEvents();
    print(_selectedDate);
    print("Provider 값: ${ref.read(selectedDateProvider)}");
  }

  // 클래스 내 정의한 _dataSource 변수에 이벤트리스트(SHC데이터) 선언
  Future<void> _loadEvents() async {
    final events = await EventRepository.getAllEvents();
    setState(() {
      _dataSource = EventDataSource(events);
    });
  }

  void _handleDateNavigation(int offset) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: offset));
      _calendarController.displayDate = _selectedDate;
    });
  }



  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();
    final diff = _selectedDate.difference(DateTime(today.year, today.month, today.day)).inDays;

    String dDayText;
    if (diff == 0) {
      dDayText = "Today";
    } else if (diff > 0) {
      dDayText = "D+$diff";
    } else {
      dDayText = "D$diff";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              // DateFormat('yyyy dd MMMM').format(_selectedDate),
              style: GoogleFonts.tiltWarp(
                fontSize: 22,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8,),
            Text(
              dDayText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: _dataSource == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfCalendar(
          dataSource: _dataSource,
          todayHighlightColor: Colors.black,
          //scheduler에서
          appointmentBuilder: appointmentBuilder,

          appointmentTextStyle: const TextStyle(
            fontSize: 10, // 원하는 크기로 조정
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headerHeight: 0,
          viewHeaderHeight: 120,

          // 사용자가 스와이프나 탭할떄 호출되는 함수
          onViewChanged: (ViewChangedDetails details) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                // details...는 필요. 프로바이더 상태업데이트와 별도로 로컬 상태관리 필요
                _selectedDate = details.visibleDates.first;
                ref.read(selectedDateProvider.notifier).updateDate(_selectedDate);
              });
            });
          },
          controller: _calendarController,
          view: CalendarView.day,
          onTap: (CalendarTapDetails details) {
            print('onTap called');
            print('details: $details');
            print('appointments: ${details.appointments}');

            if (details.targetElement == CalendarElement.calendarCell ||
                details.targetElement == CalendarElement.appointment) {
              final selectedEvent = findSelectedEvent(details.date, details.appointments);
              print('showModalBottomSheet 호출 직전');
              if (selectedEvent != null) {
                // 이벤트 상세 모달
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) => EventDetailSheet(
                    event: selectedEvent,
                    onDelete: () {
                      Navigator.pop(context);
                      _loadEvents();
                    },
                    onEdit: () {
                      Navigator.pop(context);
                      // 수정 화면 이동 등 추가 가능
                    },
                  ),
                );
                print('showModalBottomSheet 호출 직후');
              } else {
                // 이벤트가 없으면 일정 생성 페이지로 이동
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CreateEventPage(
                          initialDate: details.date!,
                          onEventCreated: (EventModel newEvent) async {
                            await _loadEvents();
                          },
                        ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              }
            }
          },
          timeSlotViewSettings: const TimeSlotViewSettings(
            startHour: 06,
            minimumAppointmentDuration: Duration(minutes: 30),
            timeIntervalHeight: 60,
            timeFormat: 'HH:mm',
            timeTextStyle: TextStyle(fontSize: 12),
          ),
          todayTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}