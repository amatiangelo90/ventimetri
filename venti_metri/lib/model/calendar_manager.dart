
class CalendarManagerClass{

  final String id;
  final String date;
  final bool isOpen;
  final bool isClosed;
  final bool isLunchTime;
  final bool isDinnerTime;

  CalendarManagerClass(this.id, this.date, this.isOpen, this.isClosed, this.isLunchTime, this.isDinnerTime);

  factory CalendarManagerClass.fromMap(
      Map snapshot,
      String id){

    return CalendarManagerClass(
      id,
      snapshot['date'] as String,
      snapshot['isOpen'] as bool,
      snapshot['isClosed'] as bool,
      snapshot['isLunchTime'] as bool,
      snapshot['isDinnerTime'] as bool,
    );
  }

  toJson(){

    return {
      'id' : id,
      'date': date,
      'isOpen' : isOpen,
      'isClosed' : isClosed,
      'isLunchTime' : isLunchTime,
      'isDinnerTime' : isDinnerTime
    };

  }

  @override
  String toString() {
    return 'CalendarManagerClass{id: $id, date: $date, isOpen: $isOpen, isClosed: $isClosed, isLunchTime: $isLunchTime, isDinnerTime: $isDinnerTime}';
  }


}