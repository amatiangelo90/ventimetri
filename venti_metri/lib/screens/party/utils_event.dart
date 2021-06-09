import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:venti_metri/model/event_class.dart';

var kEvents = LinkedHashMap<DateTime, List<EventClass>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

var _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(2021, 10, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => EventClass(title: 'Event $item | ${index + 1}' , location: '' , date: null ,listDrinkId: 0 ,passwordEvent:  0 ,id: '0')))..addAll({

  /*DateTime.now().add(Duration(days: 4)): [
    EventClass('Festa Grande','1', DateTime.now(), 'Locorotondo',1234, 0),
    EventClass('Festa Bomminella','1531', DateTime.now(), 'Locorotondo',1234, 0),
    EventClass('Festa Bomminella','1531', DateTime.now(), 'Locorotondo',2234, 0),
    EventClass('San Valentino1 ','14', DateTime.now(), 'Locorotondo',1935, 0),
  ],
  DateTime.now().add(Duration(days: 3)): [
    EventClass('Sagra Dell\'Uva Casalini','123123123', DateTime.now(), 'Locorotondo',1542, 0),
    EventClass('Lotus Festival','144321', DateTime.now(), 'Locorotondo',5292,0),
  ],
  DateTime.now().add(Duration(days: 1)): [
    EventClass('Today\'s Event 9','1', DateTime.now(), 'Locorotondo',5412, 0),
  ],*/
});

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);