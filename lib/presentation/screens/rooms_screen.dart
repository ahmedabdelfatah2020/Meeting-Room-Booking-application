import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/room_cubit.dart';
import '../manager/booking_cubit.dart';
import 'booking_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Rooms')),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is RoomLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomSuccess) {
            return ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (context, index) {
                final room = state.rooms[index];
                return ListTile(
                  leading: const Icon(Icons.meeting_room),
                  title: Text(room.name),
                  subtitle: Text('Capacity: ${room.capacity} Persons'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final today = DateTime.now().toString().split(' ')[0];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BookingCubit(
                            context.read<RoomCubit>().repository,
                          )..fetchBookings(room.id, today),
                          child: BookingScreen(room: room),
                        ),
                      ),
                    );
                    // أول ما يرجع، نحدث قائمة الغرف أو الحجوزات فوراً
                    context.read<RoomCubit>().fetchRooms();
                  },
                );
              },
            );
          } else if (state is RoomError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No rooms available'));
        },
      ),
    );
  }
}
