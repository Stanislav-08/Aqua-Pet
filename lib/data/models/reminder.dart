class Reminder {
  final String name;
  final Duration repeatEvery;
  DateTime nextNotification;
  final bool bedTime;
  final int? startHour;
  final int? endHour;

  Reminder({
    required this.name,
    required this.repeatEvery,
    required this.nextNotification,
    required this.bedTime,
    this.startHour,
    this.endHour,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'repeatEvery': repeatEvery.inMinutes,
      'nextNotification': nextNotification.toIso8601String(),
      'bedTime': bedTime,
      'startHour': startHour,
      'endHour': endHour,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      name: json['name'],
      repeatEvery: Duration(minutes: json['repeatEvery']),
      nextNotification: DateTime.parse(json['nextNotification']),
      bedTime: json['bedTime'],
      startHour: json['startHour'],
      endHour: json['endHour'],
    );
  }
}