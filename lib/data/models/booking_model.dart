class BookingModel {
  final int? id; // اختياري لأن عند الحجز الجديد السيرفر هو اللي بيكرته
  final int roomId;
  final String date;
  final String startTime;
  final String endTime;
  final String userName;

  BookingModel({
    this.id,
    required this.roomId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userName,
  });

  // تحويل من JSON لـ Object (عشان نعرض الحجوزات اللي جاية من السيرفر)
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      roomId: json['room_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      userName: json['user_name'],
    );
  }

  // تحويل من Object لـ JSON (عشان لما نبعت حجز جديد للسيرفر)
  Map<String, dynamic> toJson() {
    return {
      "room_id": roomId,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "user_name": userName,
    };
  }
}
