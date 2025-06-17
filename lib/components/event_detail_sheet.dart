


import 'package:flutter/material.dart';

import '../models/event_model/event_model.dart';

class EventDetailSheet extends StatelessWidget {
  final EventModel event;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const EventDetailSheet({
    super.key,
    required this.event,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.eventName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Image.asset('assets/images/clock.png', width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                event.isAllDay
                    ? '종일'
                    : '${event.from.hour}:${event.from.minute.toString().padLeft(2, '0')} - ${event.to.hour}:${event.to.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('삭제'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
