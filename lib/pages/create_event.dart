import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskit/components/constants.dart';
import 'package:taskit/components/my_btn_container.dart';
import 'package:taskit/components/my_sized_box.dart';
import '../features/event_service/event_service.dart';
import '../features/common_features/basic_features.dart';
import '../models/event_model/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 일정 생성하는 페이지, onEventCreated는 이거 실행되고 나서 실행될 코드
class CreateEventPage extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final Function(EventModel) onEventCreated;

  const CreateEventPage({
    super.key,
    required this.initialDate,
    required this.onEventCreated,
  });

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  late TextEditingController eventNameController;
  late TextEditingController eventMemoController;
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;

  // 처음 생성하는 이벤트니까 이거 초기값 맞네.
  bool isAllDay = false;
  bool isAlarm = false;
  bool isCompleted = false;
  bool isSaveButtonEnabled = false;
  int selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    eventMemoController = TextEditingController();
    selectedStartDate = widget.initialDate;
    selectedEndDate = widget.initialDate.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventMemoController.dispose();
    super.dispose();
  }

  // AM/PM 포맷으로 시간 표시 > 나중에 basic_features 로 옮겨도 되겠다.
  void showIOSTimePicker(bool isStartTime) {
    DateTime initialTime = isStartTime ? selectedStartDate : selectedEndDate;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 280,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text('완료'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialTime,
                  // minuteInterval: 5,
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() {
                      if (isStartTime) {
                        // 시작 시간 변경 시 날짜 정보는 유지하고 시간만 변경
                        selectedStartDate = DateTime(
                          widget.initialDate.year,
                          widget.initialDate.month,
                          widget.initialDate.day,
                          newTime.hour,
                          newTime.minute,
                        );

                        // 시작 시간이 종료 시간보다 늦으면 종료 시간 자동 조정
                        if (selectedStartDate.isAfter(selectedEndDate)) {
                          selectedEndDate =
                              selectedStartDate.add(const Duration(hours: 1));
                        }
                      } else {
                        // 종료 시간 변경 시 날짜 정보는 유지하고 시간만 변경
                        selectedEndDate = DateTime(
                          widget.initialDate.year,
                          widget.initialDate.month,
                          widget.initialDate.day,
                          newTime.hour,
                          newTime.minute,
                        );

                        // 종료 시간이 시작 시간보다 이르면 자동 조정
                        if (selectedEndDate.isBefore(selectedStartDate)) {
                          selectedEndDate =
                              selectedStartDate.add(const Duration(hours: 1));
                        }
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveEvent() async {
    // Provider에서 notifier를 읽어옴
    final eventService = ref.watch(eventServiceProvider.notifier);

    await eventService.createEvent(
      eventName: eventNameController.text,
      from: selectedStartDate,
      to: selectedEndDate,
      isAllDay: isAllDay,
      isCompleted: isCompleted,
    );

    if (mounted) {
      final latestEvent = ref.read(eventServiceProvider).last;
      widget.onEventCreated(latestEvent);
      handlePopWithKeyboardCheck(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset('assets/images/back_icn.png', width: 32),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Make Taskit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: eventNameController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.black26),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12, width: 1),
                    ),
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 50,
                child: Opacity(
                  opacity: isAllDay ? 0.2 : 1.0, // isAllDay가 true면 반투명하게
                  child: AbsorbPointer(
                    // isAllDay가 true면 탭 이벤트 무시
                    absorbing: isAllDay,
                    child: Row(
                      children: [
                        // from 영역
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showIOSTimePicker(true),
                            child: Row(
                              children: [
                                const Text(
                                  'from',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                const Spacer(),
                                Text(
                                  formatTimeString(selectedStartDate),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showIOSTimePicker(false),
                            child: Row(
                              children: [
                                const Text(
                                  'to',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                const Spacer(),
                                Text(
                                  formatTimeString(selectedEndDate),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),
              const SizedBox(height: 8),

              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAllDay ? 'Time Free' : 'Timed',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 40, // 원하는 너비
                      height: 24, // 원하는 높이
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CupertinoSwitch(
                          value: isAllDay,
                          onChanged: (value) {
                            setState(() {
                              isAllDay = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),

              const SizedBox(height: 8),

              const SizedBox(height: 8),

              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alarm',
                      style: (isAlarm)
                          ? const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )
                          : const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: 40, // 원하는 너비
                      height: 24, // 원하는 높이
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: CupertinoSwitch(
                          value: isAlarm,
                          onChanged: (value) {
                            setState(() {
                              isAlarm = value;
                            });
                          },
                          activeColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black12,
                height: 1,
              ),

              // 시간 선택 UI (isAllDay가 false일 때만 표시)

              const MySizedBox(height: 16),

              // 아이콘 선택 영역
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // 가로 스크롤
                  physics: const PageScrollPhysics(), // 스냅 효과
                  itemCount: icons.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIconIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedIconIndex == index
                              ? Colors.blue
                              : Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          icons[index],
                          color: selectedIconIndex == index
                              ? Colors.white
                              : Colors.black,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: _saveEvent,
          child: MyBtnContainer(
            color: isSaveButtonEnabled ? Colors.black87 : Colors.black26,
            child: const Center(
                child: Text(
              'Bake',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            )),
          ),
        ),
      ),
    );
  }
// iOS 스타일 TimePicker 표시
}
