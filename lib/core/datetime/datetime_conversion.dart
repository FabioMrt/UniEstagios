import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? dateTimeFromTimestamp(Timestamp? timestamp) =>
    timestamp == null ? null : DateTime.parse(timestamp.toDate().toString());

DateTime? dateTimeUpdated(DateTime? dateTime) => DateTime.now();

dateTimeCreated(DateTime? dateTime) {
  if (dateTime == null) return DateTime.now();
  return dateTime;
}
