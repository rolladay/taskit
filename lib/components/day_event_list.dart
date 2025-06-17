import 'package:flutter/material.dart';
import '../models/event_model/event_model.dart';

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
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
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
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/clock.png'),
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
