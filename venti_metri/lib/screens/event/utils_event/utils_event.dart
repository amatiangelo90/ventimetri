import 'dart:collection';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:venti_metri/model/events_models/bar_position_class.dart';
import 'package:venti_metri/model/events_models/event_class.dart';


LinkedHashMap<DateTime, List<EventClass>> getKEvents(List<EventClass> eventsList) {

  var linkedHashMap = LinkedHashMap<DateTime, List<EventClass>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(buildListEvent(eventsList));
  return linkedHashMap;
}

Map<String, EventClass> getMapAlreadyUsedPassword(List<EventClass> eventsList){
  Map<String, EventClass> map = Map<String, EventClass>();

  eventsList.forEach((element) {
    print(element.passwordEvent);
    map[element.passwordEvent.toString()] = element;
  });
  return map;
}
Map<String, BarPositionClass> getMapBarPosition(List<BarPositionClass> barChampPositionList){
  Map<String, BarPositionClass> map = Map<String, BarPositionClass>();

  barChampPositionList.forEach((element) {
    map[element.passwordBarChampPosition.toString()] = element;
  });
  return map;
}

Map<DateTime, List<EventClass>> buildListEvent(List<EventClass> eventsList) {
  Map<DateTime, List<EventClass>> map1 = Map();
  eventsList.forEach((element) {
    if(map1.containsKey(buildDateKeyFromDate(element.date))){
      map1[buildDateKeyFromDate(element.date)].add(element);
    }else{
      List<EventClass> listToAdd = [element];
      map1[buildDateKeyFromDate(element.date)] = listToAdd;
    }
  });
  return map1;

}

DateTime buildDateKeyFromDate(Timestamp date) {

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day, 0 ,0 ,0 ,0, 0);
}

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

String getAppIxFromNameEvent(String text) {
  return text.replaceAll(' ', '').toLowerCase();
}

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);