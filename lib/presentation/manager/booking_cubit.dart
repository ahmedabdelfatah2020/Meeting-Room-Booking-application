import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/room_repository_impl.dart';

// States
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;
  BookingSuccess(this.bookings);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingCreated extends BookingState {
  final List<BookingModel> updatedBookings;
  BookingCreated(this.updatedBookings);
}

// Cubit
class BookingCubit extends Cubit<BookingState> {
  final RoomRepository repository;

  BookingCubit(this.repository) : super(BookingInitial());

  // جلب الحجوزات
  Future<void> fetchBookings(
    int roomId,
    String date, {
    bool isSilent = false,
  }) async {
    if (!isSilent) emit(BookingLoading());
    try {
      final bookings = await repository.getRoomBookings(roomId, date);
      // استخدام List.from بيجبر Bloc إنه يشوفها كـ Object جديد ويحدث الشاشة
      emit(BookingSuccess(List.from(bookings)));
    } catch (e) {
      if (!isSilent) emit(BookingError(e.toString()));
    }
  }

  // إنشاء حجز جديد
  // إنشاء حجز جديد
  // إنشاء حجز جديد
  Future<void> createNewBooking(BookingModel booking) async {
    emit(BookingLoading());
    try {
      // حذفنا await الزيادة هنا
      await repository.bookRoom(booking);

      // جلب القائمة المحدثة
      final updatedList = await repository.getRoomBookings(
        booking.roomId,
        booking.date,
      );

      // إرسال الحالة الجديدة مع نسخة من القائمة لضمان تحديث الـ UI
      emit(BookingCreated(List.from(updatedList)));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
