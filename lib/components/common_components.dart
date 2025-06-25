import '../models/event_model/event_model.dart';

EventModel? findSelectedEvent(DateTime? tappedDate, List<dynamic>? appointments) {
  if (tappedDate == null || appointments == null) return null;
  for (final appointment in appointments) {
    if (appointment is EventModel) {
      if (!tappedDate.isBefore(appointment.from) && tappedDate.isBefore(appointment.to)) {
        return appointment;
      }
    }
  }
  return null;
}