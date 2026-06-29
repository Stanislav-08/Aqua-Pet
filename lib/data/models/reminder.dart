class Reminder {
  final String name;
  final int repeatEvery;
  final bool bedTime;
  final int? startHour;
  final int? endHour;

  Reminder({
    required this.name,
    required this.repeatEvery,
    required this.bedTime,
    required this.startHour,
    required this.endHour,
  });
}