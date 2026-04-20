import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/data_sources/room_api_service.dart';
import 'data/repositories/room_repository_impl.dart';
import 'presentation/manager/room_cubit.dart';
import 'presentation/screens/rooms_screen.dart';

void main() {
  // تجهيز الـ Repository والـ Service
  final apiService = ApiService();
  final roomRepository = RoomRepository(apiService);

  runApp(MyApp(roomRepository: roomRepository));
}

class MyApp extends StatelessWidget {
  final RoomRepository roomRepository;
  const MyApp({super.key, required this.roomRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomCubit(roomRepository)..fetchRooms(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meeting Room Booking',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const RoomsScreen(),
      ),
    );
  }
}
