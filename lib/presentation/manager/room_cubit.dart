import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/room_repository_impl.dart';
import '../../../data/models/room_model.dart';

// 1. الحالات اللي الشاشة ممكن تكون فيها
abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomSuccess extends RoomState {
  final List<RoomModel> rooms;
  RoomSuccess(this.rooms);
}

class RoomError extends RoomState {
  final String message;
  RoomError(this.message);
}

// 2. الـ Cubit اللي بيتحكم في الحالات دي
class RoomCubit extends Cubit<RoomState> {
  final RoomRepository repository;

  RoomCubit(this.repository) : super(RoomInitial());

  // وظيفة جلب الغرف
  Future<void> fetchRooms() async {
    emit(RoomLoading()); // قول للشاشة "حملي"
    try {
      final rooms = await repository.getAllRooms();
      emit(RoomSuccess(rooms)); // قول للشاشة "البيانات وصلت خدي اهي"
    } catch (e) {
      emit(RoomError("تأكد من اتصالك بالإنترنت")); // قول للشاشة "فيه مشكلة"
    }
  }
}
