import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/event_model/event_model.dart';
import '../event_service/event_service.dart';

void showDeleteDialog(
    dynamic appointment,
    BuildContext context,
    WidgetRef ref,
    VoidCallback onDelete,
    ) {
  final event = appointment as EventModel;
  // Provider에서 notifier를 읽어옴
  final eventService = ref.read(eventServiceProvider.notifier);

  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Text(
            '일정 삭제',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('\'${event.eventName}\' 일정을 삭제하시겠습니까?'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소', style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: () async {
                  // Provider를 통해 삭제
                  await eventService.deleteEvent(event.id);
                  Navigator.pop(context);
                  onDelete();
                },
                child: const Text(
                  '삭제',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );
}