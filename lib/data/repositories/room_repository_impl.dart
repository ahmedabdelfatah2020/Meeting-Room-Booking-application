import 'package:flutter/foundation.dart';
import '../data_sources/room_api_service.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';

class RoomRepository {
  final ApiService apiService;
  RoomRepository(this.apiService);

  // جلب الغرف
  Future<List<RoomModel>> getAllRooms() async {
    try {
      return await apiService.getRooms();
    } catch (e) {
      debugPrint("GetAllRooms Error: $e");
      rethrow;
    }
  }

  // جلب الحجوزات - معدل لكسر الـ Cache نهائياً
  Future<List<BookingModel>> getRoomBookings(int roomId, String date) async {
    try {
      // نستخدم الوقت الحالي كبصمة فريدة للطلب
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // بنمرر الـ timestamp للـ ApiService
      final bookings = await apiService.getBookings(
        roomId,
        date,
        timestamp: timestamp,
      );
      

      debugPrint(
        "Fetched ${bookings.length} bookings for $date (TS: $timestamp)",
      );
      return bookings;
      
    } catch (e) {
      debugPrint("Repository Error: $e");
      rethrow;
    }
  }

  // عمل حجز جديد
  Future<void> bookRoom(BookingModel booking) async {
    try {
      await apiService.createBooking(booking);
      debugPrint("Success: Booking created for ${booking.userName}");
    } catch (e) {
      debugPrint("BookRoom Error: $e");
      rethrow;
    }
  }
}
