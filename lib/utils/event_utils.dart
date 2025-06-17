import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/event_service/event_service.dart';
import '../models/event_model/event_model.dart';

Future<List<EventModel>> fetchAllEvents(WidgetRef ref) async {
  final eventService = ref.read(eventServiceProvider.notifier);
  await eventService.loadAllEvents();
  return ref.read(eventServiceProvider);
}