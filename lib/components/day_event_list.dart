import 'package:flutter/material.dart';
import '../models/event_model/event_model.dart';
import 'badge_icon_list.dart';

// 이벤트 리스트 위젯
class DayEventsList extends StatelessWidget {
  final List<EventModel> events;
  final void Function(EventModel) onTapEvent;
  final void Function(EventModel) onLongPressEvent;

  const DayEventsList({
    super.key,
    required this.events,
    required this.onTapEvent,
    required this.onLongPressEvent,
  });

  @override
  Widget build(BuildContext context) {
    // 리스트 정렬순서 바꾸는 함수 (isCompleted를 맨 나중에 등)
    final sortedEvents = List<EventModel>.from(events)
      ..sort((a, b) {
        // 1. isCompleted가 true인 것은 맨 아래로
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        // 2. isAllDay가 true인 것은 위로
        if (a.isAllDay != b.isAllDay) {
          return a.isAllDay ? -1 : 1;
        }
        // 3. isAllDay가 false인 경우 시작 시간이 빠른 순
        if (!a.isAllDay && !b.isAllDay) {
          return a.from.compareTo(b.from);
        }
        // 나머지는 순서 유지
        return 0;
      });
    //



    return ListView.builder(
      itemCount: sortedEvents.length,
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        return GestureDetector(
          onTap: () => onTapEvent(event),
          onLongPress: () => onLongPressEvent(event),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(getBadgeAssetPath(event.badgeId)),
                  ),
                  Text(event.eventName),
                  const Spacer(),
                  event.isAllDay
                      ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Free',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${event.from.hour}:${event.from.minute.toString().padLeft(2, '0')} - ${event.to.hour}:${event.to.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
