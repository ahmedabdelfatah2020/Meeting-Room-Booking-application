# Meeting Room Booking App

A Flutter application designed to manage and book meeting rooms efficiently. This project was developed as a technical task to demonstrate clean architecture, state management, and API integration.

## 🚀 Features
- **Rooms List:** Display all available meeting rooms with their capacity.
- **Booking Management:** View existing bookings for each room to avoid scheduling conflicts.
- **Smart Validation:** - Prevents booking in the past.
    - Ensures end time is after start time.
    - **Overlap Detection:** A custom algorithm checks the local list of bookings to prevent double-booking the same slot before sending data to the server.
- **Real-time Updates:** Immediate UI feedback after a successful booking.

## 🛠️ Technical Decisions & Architecture
- **State Management:** Used **Bloc/Cubit** for its predictability and clear separation between business logic and UI.
- **Clean Architecture:** Organized the project into layers (Data, Models, Manager/Cubit, Presentation) to ensure maintainability and scalability.
- **API Handling:** Implemented using **Dio** for robust HTTP requests, including custom headers and query parameters to handle server-side caching issues.
- **Cache Busting:** Implemented a timestamp strategy on GET requests to ensure the app fetches the most recent booking data from the Directus backend.

## 📦 Libraries Used
- `flutter_bloc`: For state management.
- `dio`: For REST API integration.
- `equatable`: To simplify object comparisons in Bloc states.

## ⚙️ How to Run
1. Clone the repository:
   ```bash
   git clone [YOUR_REPOSITORY_URL]# Meeting-Room-Booking-application
Build a small Meeting Room Booking application using Flutter.

2. Navigate to the project folder:
Bash
cd meeting_room_booking

3. Install dependencies:
Bash
flutter pub get

4. Run the application:
Bash
flutter run

⏱️ Approximate Time Spent
Around 4 to 5 hours (including UI implementation, Bloc logic, and debugging API caching/overlap issues).
