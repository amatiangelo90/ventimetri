class ExceptionEvent {

  final String id;
  final String name;
  final String exception;
  final String date;


  ExceptionEvent(
      this.id,
      this.name,
      this.exception,
      this.date,
      );


  toJson(){

    return {
      'id' : id,
      'name' : name,
      'exception': exception,
      'date': date,
    };
  }


  @override
  String toString() {
    return this.exception;
  }

}