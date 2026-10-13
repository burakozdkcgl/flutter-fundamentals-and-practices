# Campus Event Explorer (BIM493 - Assignment #1)

A Flutter mobile application designed for students to explore campus events, manage favorites, and handle event registrations/participations with in-memory state management.

---

## 👥 Student Information & Team Members

| Full Name | Student ID | Contribution / Role |
| :--- | :--- | :--- |
| **Student 1 Name** | `XXXXXXXXX` | Event Model, Explore Screen, Search & Filtering, Font & Asset Integration |
| **Student 2 Name** | `XXXXXXXXX` | Event Details, Double-tap Image Viewer, Join/Cancel Dialogs & State Logic |

*(Note: Replace placeholders above with your actual names and student ID numbers before final submission.)*

---

## 🚀 Setup and Run Instructions

### Prerequisites
* Flutter SDK (Stable Channel, version 3.47.x)
* Dart SDK (3.13.x+)
* An Android emulator, connected physical Android device, or Windows desktop build environment.

### Flutter Version Output
```
Flutter 3.47.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision abaf9c5237 (5 days ago) • 2026-10-08 09:51:21 -0700
Engine • hash d8a2d6c768c334d53e16277f837970ffa1e2de81 (revision deb287481e) (6 days ago) • 2026-10-07 17:09:12.000Z
Tools • Dart 3.13.5 • DevTools 2.60.0
```

### Installation Steps
1. Clone the repository or extract the project archive:
   ```bash
   git clone <repository_url>
   cd flutter-campus-events-app
   ```
2. Get project dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analysis to verify code health:
   ```bash
   flutter analyze
   ```
4. Run the automated widget tests:
   ```bash
   flutter test
   ```
5. Launch the application:
   ```bash
   flutter run
   ```

---

## 📱 Features & Implementation Details

1. **Event Data & Explore Screen:**
   - 6 mock campus events spanning 4 categories: `Technology`, `Arts`, `Sports`, and `Career`.
   - Includes initially full event (`Inter-Faculty Basketball Championship`, 0 seats) and an event with exactly one place left (`Autumn Contemporary Art Exhibition`, 1 seat).
   - Scrollable event cards with local images, category badges, venue, date/time, capacity indicators, and quick favorite toggling.

2. **Combined Search & Category Filters:**
   - Title search is case-insensitive and trims leading/trailing whitespace.
   - Filter chips for "All" plus 4 distinct categories.
   - Search and category work together simultaneously.
   - Real-time matching count indicator (`X events matching`).
   - Clear search/reset filters buttons.
   - Applied consistently across Explore, Favorites, and My Events tabs.

3. **Event Details & Image Viewer:**
   - Detailed event view showing full description, venue, date, capacity, and current participation status.
   - **Double-tap on image:** Opens the `ImageViewerScreen` showing an enlarged view with pinch/pan zoom and normal back navigation.
   - Favorite and participation action buttons with live feedback snackbars.

4. **Favorites and My Events:**
   - **Explore Tab:** Displays all campus events.
   - **Favorites Tab:** Displays only favorited events. Shows custom empty-state if empty.
   - **My Events Tab:** Displays only registered events. Shows custom empty-state if empty.
   - Badges in bottom navigation bar reflect live counts of favorites and registered events.
   - App bar displays total number of joined events.

5. **Join & Cancel Participation Logic:**
   - **Joining:** Opens confirmation dialog specifying title, date/time, and venue. Confirming decreases available seats by 1, adds to My Events, and provides visual snackbar feedback.
   - **Cancellation:** Confirms cancellation, removes event from My Events, and restores 1 available seat.
   - **Capacity Rules:** Full events (0 seats) cannot be joined and are visibly marked as "Full". Students who registered for the last available seat retain the ability to cancel.

6. **Typography & Layout:**
   - Bundled **Poppins** custom font (Regular 400, SemiBold 600, Bold 700) declared in `pubspec.yaml` and applied globally via `ThemeData`.
   - Clean Material 3 design using `Scaffold`, `NavigationBar`, `Card`, `Row`, `Column`, `Padding`, and `Expanded`.
   - At least one reusable `StatelessWidget` (`EventCard`, `EmptyStateWidget`) and `StatefulWidget` (`HomeScreen`, `EventDetailsScreen`).

---

## 🎨 Asset Credits and Licenses

### Fonts
* **Poppins Font Family**: Created by Indian Type Web (ITF) / Google Fonts.
  - License: SIL Open Font License (OFL) Version 1.1 (bundled in `assets/fonts/OFL.txt`).

### Images
All images are royalty-free photos sourced from Unsplash under the Unsplash Free License:
* `tech_hackathon.jpg`: Photo by Marvin Meyer on Unsplash (Hackathon / Collaboration)
* `art_exhibition.jpg`: Photo by Europeana on Unsplash (Art Gallery)
* `sports_tournament.jpg`: Photo by Markus Spiske on Unsplash (Sports / Basketball)
* `music_fest.jpg`: Photo by Anthony Delanoix on Unsplash (Concert / Music)
* `ai_workshop.jpg`: Photo by Desola Lanre-Ologun on Unsplash (AI / Coding Workshop)
* `career_networking.jpg`: Photo by Headway on Unsplash (Career / Networking)

---

## ⚠️ Known Limitations
* **In-Memory Storage Only:** As per the assignment specifications, favorited events and participations are stored in-memory during the active app session. Restarting the application resets state to the initial mock data.
* **Offline Scope:** No external backend, database, or authentication system is utilized.

---

## ✅ Verification & Test Checklist

- [x] **Full-event case:** Verified that an event with 0 available seats displays "Full", disables the join button, and prevents registrations.
- [x] **Cancel-dialog case:** Verified that cancelling participation displays a confirmation dialog, successfully restores available capacity by 1, and removes the item from My Events.
- [x] **Empty-search case:** Verified that searching for a non-matching query displays an empty-state message and provides a one-tap button to reset/clear filters.
- [x] **Double-tap image viewer:** Verified that double-tapping the image on the details screen opens the enlarged image viewer with back navigation.
- [x] **Search casing and whitespace:** Verified that queries like `"   hAcKaThOn   "` correctly match `"Campus Hackathon 2026"`.
- [x] **Static analysis & tests:** `flutter analyze` reported 0 issues, and all widget tests passed.

---

## 📷 Screenshots

> *Add 4 screenshots of the running application below before final submission:*

1. **Explore Screen:**
   ![Explore Screen](screenshots/explore_screen.png)

2. **Event Details Screen:**
   ![Details Screen](screenshots/details_screen.png)

3. **Favorites Screen:**
   ![Favorites Screen](screenshots/favorites_screen.png)

4. **My Events Screen:**
   ![My Events Screen](screenshots/my_events_screen.png)
