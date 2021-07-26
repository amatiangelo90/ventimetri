class TimeSlotPickup {
  int id;
  String slot;

  TimeSlotPickup(this.id, this.slot);

  static List<TimeSlotPickup> getTimeSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
      TimeSlotPickup(2, '12:30'),
      TimeSlotPickup(3, '13:00'),
      TimeSlotPickup(4, '13:30'),
      TimeSlotPickup(5, '14:00'),
      TimeSlotPickup(6, '19:30'),
      TimeSlotPickup(7, '20:00'),
      TimeSlotPickup(8, '20:30'),
      TimeSlotPickup(9, '21:00'),
      TimeSlotPickup(10, '21:30'),
    ];
  }
  static List<TimeSlotPickup> getDinnerSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
      TimeSlotPickup(2, '19:30'),
      TimeSlotPickup(3, '20:00'),
      TimeSlotPickup(4, '20:30'),
      TimeSlotPickup(5, '21:00'),
      TimeSlotPickup(6, '21:30'),
    ];
  }

  static List<TimeSlotPickup> getTimeLunchSlots() {
    return <TimeSlotPickup>[
      TimeSlotPickup(1, 'Seleziona Orario'),
      TimeSlotPickup(2, '12:30'),
      TimeSlotPickup(3, '13:00'),
      TimeSlotPickup(4, '13:30'),
      TimeSlotPickup(5, '14:00'),
    ];
  }
}