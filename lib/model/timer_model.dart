class TimerModel {
  final DateTime? matchStartDate;
  final DateTime? matchEndDate;
  final String timerName;

  TimerModel({
    this.matchStartDate,
    this.matchEndDate,
    this.timerName = 'No Name',
  });

  Map<String, dynamic> toMap() {
    return {
      'timerName': timerName,
      'matchStartDate': matchStartDate?.millisecondsSinceEpoch,
      'matchEndDate': matchEndDate?.millisecondsSinceEpoch,
    };
  }

  TimerModel copyWith({
    DateTime? matchStartDate,
    DateTime? matchEndDate,
    String? timerName,
  }) {
    return TimerModel(
      matchStartDate: matchStartDate ?? this.matchStartDate,
      matchEndDate: matchStartDate ?? this.matchStartDate,
      timerName: timerName ?? this.timerName,
    );
  }
}
