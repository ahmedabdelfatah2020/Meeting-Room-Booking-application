import 'package:flutter/material.dart';
import '../../data/models/booking_model.dart';

class SuccessScreen extends StatelessWidget {
  final BookingModel booking;
  final String roomName;

  const SuccessScreen({
    super.key,
    required this.booking,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea عشان المحتوى ميبقاش تحت الكاميرا أو النوتش
      body: SafeArea(
        child: Center(
          // SingleChildScrollView هو الحل لرسالة الـ Overflow بـ 230 بكسل
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "تم الحجز بنجاح!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // كارت تفاصيل الحجز
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        8.0,
                      ), // تقليل البادنج الداخلي شوية
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // يخلي الكارت ياخد مساحة المحتوى بس
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.meeting_room,
                              color: Colors.blue,
                            ),
                            title: const Text("اسم الغرفة"),
                            subtitle: Text(roomName),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            title: const Text("التاريخ"),
                            subtitle: Text(booking.date),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.access_time,
                              color: Colors.blue,
                            ),
                            title: const Text("الموعد"),
                            subtitle: Text(
                              "من ${booking.startTime} إلى ${booking.endTime}",
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            title: const Text("باسم المستخدم"),
                            subtitle: Text(booking.userName),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width:
                        double.infinity, // الزرار واخد عرض الشاشة لسهولة الضغط
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        "العودة للرئيسية",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
