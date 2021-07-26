class Location{
  int id;
  String location;
  String addressLc;


  Location(this.id, this.location, this.addressLc);

  static List<Location> getLocationSlots() {
    return <Location>[
      Location(1, 'Selezionare la Sede',''),
      Location(2, 'Cisternino', 'Via G. D\'Amico, 11, 72014 Cisternino BR'),
      Location(3, 'Locorotondo', 'Via Nardelli, 71, 70010 Locorotondo BA'),
      Location(4, 'Monopoli', 'Via Giuseppe Garibaldi, 66, 70043 Monopoli BA'),
    ];
  }

}