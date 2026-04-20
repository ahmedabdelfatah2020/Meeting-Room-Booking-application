import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://employeevoice.hub2.icall.com.eg',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // 1. جلب الغرف
  Future<List<RoomModel>> getRooms() async {
    try {
      final response = await _dio.get('/items/rooms');
      final List data = response.data['data'] ?? [];
      return data.map((json) => RoomModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("GetRooms Error: $e");
      throw Exception('Failed to load rooms');
    }
  }

  // 2. جلب الحجوزات - تم تصحيح الـ Endpoint والـ Mapping
  // ... الـ imports والـ BaseOptions زي ما هي
  Future<List<BookingModel>> getBookings(
    int roomId,
    String date, {
    String? timestamp,
  }) async {
    try {
      final response = await _dio.get(
        '/items/bookings',
        queryParameters: {
          'filter[room_id][_eq]': roomId,
          'filter[date][_eq]': date,
          '_t': timestamp,
        },
      );
      // لازم ندخل جوه ['data'] عشان الحجوزات تظهر
      final List data = response.data['data'] ?? [];
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // 3. إنشاء حجز جديد
  Future<void> createBooking(BookingModel booking) async {
    try {
      final Map<String, dynamic> bookingData = booking.toJson();
      // تأكد إن الـ JSON لا يحتوي على ID لو السيرفر بيكريهه تلقائي
      final response = await _dio.post('/items/bookings', data: bookingData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Booking Created Successfully on Server");
      }
    } on DioException catch (e) {
      debugPrint("API Post Error: ${e.response?.data ?? e.message}");
      throw Exception('Failed to create booking');
    }
  }
}
