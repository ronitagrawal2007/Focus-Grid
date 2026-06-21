# Focus Grid

A Flutter productivity app that combines **recurring task tracking** (daily & weekly habits), a **focus/Pomodoro-style timer**, and a **visual productivity history** — wrapped in a clean, theme-aware UI.

Designed and built from scratch as a personal project.

📦 **Download:** A pre-built APK is available under the [Releases](../../releases) section of this repository.

---

## ✨ Features

### 📋 Task Sheet
- Add tasks as **Daily** (repeats every day) or **Weekly** (repeats on the weekday it was created).
- Separate scrollable lists for Daily and Weekly tasks, each in its own card.
- Weekly tasks display which weekday they're tied to (e.g. `Mon`, `Wed`).
- Swipe-to-delete (`Dismissible`) on any task, with a confirmation snackbar.
- A floating "+" button opens the **Add Task** screen.

### 🏠 Home
- **Day strip** — a horizontally scrollable row of every day in the current month, auto-scrolled and centered on today.
- **Task heatmap** — a GitHub-style monthly grid where each day is color-coded by completion ratio (red → orange → light green → green), with a live count (`completed/total`) and today's cell outlined.
- **Today's task list** — checkboxes to mark tasks complete (persisted instantly), swipe-to-delete, synced against the saved task history.
- Reacts live to Hive data changes via `ValueListenableBuilder`.

### ⏱️ Focus Session
- Set a custom countdown timer (HH:MM) with input validation (minutes capped at 60).
- Animated circular progress ring showing time remaining.
- **Give Up** button to cancel/reset the current session.
- Background **music player** (loop) to play/stop ambient audio during a session.
- Switchable **background image** (2 image slots, each mapped to a different asset depending on light/dark theme — 4 images total).
- A running tally of total focus time (`productiveSeconds` / `productiveFormatted`), accumulated across sessions in-memory.

### 🗂️ Task History Calendar
- A full month-view calendar (prev/next navigation) showing which days have recorded task history.
- Tapping a day opens a bottom sheet listing that day's tasks and their completion state.

### 🌙 Dark Mode
- Toggle available from the header of every main page (Task Sheet, Home, Focus Session).
- Preference is persisted via `SharedPreferences` and reloaded on app start.

---

## 🛠️ Tech Stack

| Purpose | Package |
|---|---|
| Framework | Flutter / Dart |
| State management | `provider` |
| Local database | `hive`, `hive_flutter` |
| Key-value persistence (theme) | `shared_preferences` |
| Audio (focus session music) | `audioplayers` |
| App icons | `flutter_launcher_icons` |

---

## 📁 Project Structure

```
lib/
├── Data/
│   ├── DailyTask.dart            # Daily task templates (Hive box: DailyTaskBox)
│   ├── DateDay.dart              # Calendar/weekday helpers
│   ├── HomeTask.dart             # Builds/maintains "today's" task list
│   ├── ProductivityHistory.dart  # Per-date focus-time totals
│   ├── TaskHistory.dart          # Per-date task + completion record (Hive box: TaskHistoryBox)
│   ├── UpdatedHomeTask.dart      # Legacy/alternate version of HomeTask.dart
│   └── WeeklyTask.dart           # Weekly task templates (Hive box: WeeklyTaskBox)
│
├── Pages/
│   ├── AddTaskPage/
│   │   └── MainPage/AddTaskPage.dart  # Form to create a Daily/Weekly task
│   │
│   ├── FocusSessionPage/
│   │   ├── MainPage/FocusSessionPage.dart
│   │   ├── FocusBG.dart          # Background image picker (dropdown)
│   │   ├── FocusBGImage.dart     # Renders the selected background (theme-aware)
│   │   ├── FocusProvider.dart    # FocusTimerProvider — countdown/timer logic
│   │   ├── FSPGiveUpButton.dart  # Cancels/resets the active session
│   │   ├── FSPHeader.dart        # Title + dark mode switch
│   │   ├── FSPTimeRing.dart      # Circular countdown progress ring
│   │   ├── FSPTimeSetter.dart    # HH/MM input + Start Timer button
│   │   └── MusicSystem.dart      # Play/stop looping ambient audio
│   │
│   ├── HomePage/
│   │   ├── MainPage/HomePage.dart
│   │   ├── HPDay.dart            # Scrollable day-of-month strip
│   │   ├── HPHeader.dart         # Title + dark mode switch
│   │   ├── HPHeatMap.dart        # Monthly completion heatmap
│   │   ├── HPProductiveTime.dart # Displays accumulated focus time
│   │   └── HPTaskList.dart       # Today's checklist (checkbox + swipe to delete)
│   │
│   ├── TaskHistory/
│   │   └── TaskHistoryCalendar.dart  # Standalone monthly calendar + day detail view
│   │
│   └── TaskSheetPage/
│       ├── MainPage/TaskSheetPage.dart
│       ├── TSPAddTask.dart       # "+" button → navigates to Add Task screen
│       ├── TSPDaily.dart         # Daily task list (swipe to delete)
│       ├── TSPHeader.dart        # Title + add-task button + dark mode switch
│       └── TSPWeekly.dart        # Weekly task list (swipe to delete)
│
├── Provider/
│   ├── darkModeProvider.dart     # Holds + persists current ThemeData
│   └── TaskAddedProvider.dart    # Handles adding a task + syncing it into history
│
├── Services/
│   ├── TaskInitializationService.dart
│   └── ThemePreferencesService.dart
│
├── Theme/
│   └── ThemeMode.dart            # Light/dark ThemeData definitions
│
└── main.dart
```

---

## 🔄 How It Works

### Navigation
The app shell (`MainPage` in `main.dart`) is a `PageView` + `BottomNavigationBar` with three tabs: **Task Sheet → Home → Focus**. Adding a task pushes a replacement route to `AddTaskPage`, which on submit pushes a replacement route straight back to the Task Sheet tab.

### Task lifecycle
1. On **Add Task**, a task is created as `Daily` or `Weekly` (weekly tasks are tagged with the current weekday) and saved as a **template** in Hive (`DailyTaskBox` / `WeeklyTaskBox`) via `TaskAddedProvider`.
2. On every app launch, `initializeTodayTasks()` checks a Hive flag (`init_<YYYY-MM-DD>`) to see if today's checklist has already been generated.
   - **First launch of the day:** matching Daily templates, plus Weekly templates whose weekday matches today, are copied into `TaskHistoryBox` under today's date key — this becomes today's checklist.
   - **Every later launch that day:** the already-saved checklist (with whatever boxes are already ticked) is loaded back in, so progress isn't lost.
3. Ticking a checkbox on Home updates the list in memory and is persisted back into `TaskHistoryBox`. Swiping a task away removes it from both the in-memory list and `TaskHistoryBox` for that day.
4. Tasks are matched by a generated unique `id` (falling back to name+type for older entries) so two same-named tasks don't collide.

### Home page
`HPDay` auto-centers on today inside a horizontal strip of the whole month. `HPHeatMap` listens directly to the `TaskHistoryBox` (`ValueListenableBuilder`) and recolors itself live as tasks are completed — completion ratio per day drives the color from red (low) to green (fully done). `HPTaskList` loads (or lazily initializes) today's tasks and keeps them in sync with both the global task list and Hive.

### Focus session
`FocusTimerProvider` runs a `Timer.periodic` countdown from a user-set duration, exposing `hours` / `minutes` / `ratio` for the UI ring. Stopping early or letting it finish both roll the elapsed time into an in-memory cumulative total (`productiveSeconds`), shown on the Home page via `HPProductiveTime`. The background image and music are independent UI flourishes — the image swaps between two presets (4 underlying assets split by light/dark theme), and the music player loops a single ambient track.

### Task History Calendar
A separate month-view calendar living in `Pages/TaskHistory/TaskHistoryCalendar.dart` (not currently wired into the bottom nav) that marks which days have saved task history and opens a bottom sheet with that day's tasks when tapped.

### Theming
`DarkModeProvider` holds the active `ThemeData` (`lightMode` / `darkMode` from `ThemeMode.dart`). Every page header has its own dark-mode `CupertinoSwitch`, all bound to the same provider. Changes are persisted via `ThemePreferencesService` (`SharedPreferences`) and reloaded on next launch.

---

## 🚀 Getting Started

**Prerequisites:** Flutter SDK (Dart `^3.11.5` or newer).

```bash
# Install dependencies
flutter pub get

# Run on a connected device/emulator
flutter run
```

Required assets (referenced by the Focus Session background/music features):
```
assets/Image/1.jpeg
assets/Image/2.jpeg
assets/Image/3.jpeg
assets/Image/4.jpeg
assets/bg.mp3
```

If you change any Hive model annotations, regenerate adapters with:
```bash
flutter pub run build_runner build
```

---

## 📥 Download

A built APK is published in this repo's **Releases** — grab the latest one from there if you just want to install the app without building it yourself.

---

## 📦 Key Dependencies

```yaml
provider: ^6.1.5+1
audioplayers: ^6.6.0
hive: ^2.2.3
hive_flutter: ^1.1.0
shared_preferences: ^2.5.5
```

Dev tools: `flutter_lints`, `build_runner`, `hive_generator`, `flutter_launcher_icons`.

---

## 📝 Notes

- A few earlier iteration files (`AddTask.dart`, `UpdatedHomeTask.dart`) exist alongside their newer replacements (`TaskAddedProvider.dart`/`HomeTask.dart`) — only the latter are actively used from `main.dart`.
- `TaskHistoryCalendar` is fully built but isn't currently linked from the bottom navigation — it's reachable only if you wire up a route to it.
- `HPProductiveTime` is built but not currently placed in `HomePage`'s widget tree — the productive-time figure is therefore tracked but not yet shown on Home.
- Weekly task matching uses short English weekday names (`Mon`–`Sun`), so it isn't locale-aware.

---

## 💡 Possible Next Steps

- Surface `HPProductiveTime` and a route to `TaskHistoryCalendar` in the UI
- Edit existing tasks (not just delete) from the Task Sheet
- Reminders/notifications for incomplete tasks
- Weekly/monthly productivity charts
- Cloud backup & sync across devices

---

## Author

Designed and built independently as a personal productivity tool.
#   F o c u s - G r i d  
 