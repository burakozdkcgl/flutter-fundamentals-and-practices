# campus event explorer

student 1: name surname - student_id (event model, explore screen, filters)
student 2: name surname - student_id (details screen, join/cancel dialogs, image viewer)

## how to run
```bash
cd 01-campus-event-explorer
flutter pub get
flutter run
```

## flutter version
```
Flutter 3.47.7 • channel stable • https://github.com/flutter/flutter.git
Framework • revision abaf9c5237 (5 days ago) • 2026-10-08 09:51:21 -0700
Engine • hash d8a2d6c768c334d53e16277f837970ffa1e2de81 (revision deb287481e) (6 days ago) • 2026-10-07 17:09:12.000Z
Tools • Dart 3.13.5 • DevTools 2.60.0
```

## what the app does
simple campus events explorer built with flutter. works completely offline. in-memory only, no backend or database.


## checklist
- [x] full event: 0 available spots shows full, disabled join button.
- [x] cancel dialog: confirm dialog appears on cancel, restores capacity and removes from my events.
- [x] empty search: shows message when nothing matches and button to clear search.

## assets and limitations
- poppins font from google fonts / itf (license included in assets/fonts/ofl.txt).
- images from unsplash and estu logo.
- in-memory only, no backend or database.

## screenshots
| | | |
| :---: | :---: | :---: |
| <img src="docs/screenshots/assignment1_01_explore_overview.png" width="280" /> | <img src="docs/screenshots/assignment1_02_event_details_dialog.png" width="280" /> | <img src="docs/screenshots/assignment1_03_favorites_collection.png" width="280" /> |
| <img src="docs/screenshots/assignment1_04_sort_bottom_sheet.png" width="280" /> | <img src="docs/screenshots/assignment1_05_search_dark_mode.png" width="280" /> | <img src="docs/screenshots/assignment1_06_my_events_sports_dark.png" width="280" /> |

