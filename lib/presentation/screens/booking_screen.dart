import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/room_model.dart';
import '../../data/models/booking_model.dart';
import '../manager/booking_cubit.dart';
import 'success_screen.dart';

class BookingScreen extends StatefulWidget {
  final RoomModel room;
  const BookingScreen({super.key, required this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _nameController = TextEditingController();
  static final String _today = DateTime.now().toString().split(' ')[0];
  late final _dateController = TextEditingController(text: _today);

  final _startController = TextEditingController();
  final _endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingCubit>().fetchBookings(widget.room.id, _today);
    });
  }

  DateTime _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  bool _isValidFormat(String time) {
    final RegExp timeRegExp = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegExp.hasMatch(time);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.room.name}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state is BookingCreated) {
              if (!mounted) return;

              final confirmedBooking = BookingModel(
                roomId: widget.room.id,
                date: _dateController.text,
                startTime: _startController.text,
                endTime: _endController.text,
                userName: _nameController.text,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(
                    roomName: widget.room.name,
                    booking: confirmedBooking,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            List<BookingModel> displayList = [];
            if (state is BookingSuccess) {
              displayList = state.bookings;
            } else if (state is BookingCreated) {
              displayList = state.updatedBookings;
            }

            // تم استبدال الـ Column بـ SingleChildScrollView لحل مشكلة الـ Overflow
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Enter Booking Details:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'Start Time (e.g. 10:00)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _endController,
                    decoration: const InputDecoration(
                      labelText: 'End Time (e.g. 11:00)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is BookingLoading
                          ? null
                          : () {
                              if (_nameController.text.isEmpty ||
                                  _startController.text.isEmpty ||
                                  _endController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fill all fields")),
                                );
                                return;
                              }

                              if (!_isValidFormat(_startController.text) || 
                                  !_isValidFormat(_endController.text)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Invalid time format. Use HH:mm")),
                                );
                                return;
                              }

                              final newStart = _parseTime(_startController.text);
                              final newEnd = _parseTime(_endController.text);

                              if (!newEnd.isAfter(newStart)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("End time must be after start time")),
                                );
                                return;
                              }

                              bool isOverlapping = false;
                              for (var existing in displayList) {
                                final existStart = _parseTime(existing.startTime);
                                final existEnd = _parseTime(existing.endTime);

                                if (newStart.isBefore(existEnd) && newEnd.isAfter(existStart)) {
                                  isOverlapping = true;
                                  break;
                                }
                              }

                              if (isOverlapping) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("عفواً، هذا الوقت محجوز بالفعل!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final newBooking = BookingModel(
                                roomId: widget.room.id,
                                date: _dateController.text,
                                startTime: _startController.text,
                                endTime: _endController.text,
                                userName: _nameController.text,
                              );
                              context.read<BookingCubit>().createNewBooking(newBooking);
                            },
                      child: state is BookingLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Confirm Booking'),
                    ),
                  ),
                  const Divider(height: 40, thickness: 2),
                  const Text(
                    "Reserved Slots:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // تم استخدام ListView مع shrinkWrap لأنها داخل ScrollView
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final b = displayList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: const Icon(Icons.history_toggle_off, color: Colors.blue),
                          title: Text(b.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Time: ${b.startTime} - ${b.endTime}"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}