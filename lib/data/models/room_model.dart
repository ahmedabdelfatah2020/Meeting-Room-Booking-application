class RoomModel {
  final int id;
  final String name;
  final int capacity;

  RoomModel({required this.id, required this.name, required this.capacity});

  // وظيفة لتحويل البيانات من JSON (ليستة من السيرفر) لـ Object في دارت
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      capacity: json['capacity'] ?? 0,
    );
  }
}
