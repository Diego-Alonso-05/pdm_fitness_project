# Mobile Device Programming - Practical Project

## Project Identification

**Project name:** FIT-NESS  
**Group:** FIT-NESS

## Students

| Student number | Name |
| --- | --- |
| PV33986 | Diego Alonso Laguillo |
| PV33971 | David Gonzalez Fernandez |

## General Description

FIT-NESS is a mobile fitness application developed with **Flutter** and **Dart**.
The application allows users to choose predefined workout routines, create custom
routines from an exercise library, start workout sessions, save completed
workouts locally, estimate burned calories, and review training progress.

The app is designed as an offline-first mobile application: it uses internet
when available, but keeps important data stored locally so that the main
features remain usable without a connection.

## Assignment Requirements Covered

| Requirement | Implementation |
| --- | --- |
| Flutter + Dart multiplatform app | Flutter project with Android/iOS support and main code inside `lib/`. |
| REST API / JSON data | Exercise data is loaded through `http` from a remote JSON endpoint. |
| Local database with `sqflite` | SQLite stores workouts, cached exercises, custom routines, and the selected routine. |
| Offline-first and synchronization | API data is cached locally; if there is no internet, cached or fallback data is used. |

## Internet and Wi-Fi Usage

The application uses an internet connection in these situations:

- Loading the exercise library from the REST/JSON API.
- Refreshing/synchronizing exercise data through the **Sync Data** profile menu action.
- Opening Google Maps from the **Gyms Near You** card.

The application does **not** require internet for:

- Viewing saved workout history.
- Viewing progress calculated from local data.
- Seeing the selected routine.
- Using custom routines already saved locally.
- Using exercises already cached in SQLite.

If there is no internet connection:

1. The app tries to load exercises from the SQLite cache.
2. If the cache is empty, it uses a small built-in offline fallback list.
3. The user can still navigate through the app and use local fitness features.

## API and Offline-First Behaviour

The REST API logic is implemented in:

`lib/services/exercise_api_service.dart`

The app requests a remote JSON exercise database using the `http` package. The
request has a timeout so the app does not wait forever if the connection fails.
When the request succeeds, the exercises are stored in SQLite for later offline
usage.

If the request fails, the app loads cached exercises from:

`lib/services/database_service.dart`

This makes the exercise library usable even when Wi-Fi or mobile data is not
available.

## Local Database

SQLite is managed in:

`lib/services/database_service.dart`

The local database stores:

- Completed workouts.
- Estimated calories for completed workouts.
- Cached exercises from the API.
- Custom routines created by the user.
- The currently selected routine.

This supports persistent storage and offline-first behaviour.

## Main Features

### Home Dashboard

Implemented in:

`lib/screens/home_screen.dart`

Main elements:

- Daily overview.
- Calories burned.
- Number of completed workouts.
- Today Plan with the selected routine.
- Water intake tracker.
- Exercise library button.
- Google Maps button for nearby gyms.
- Profile menu with synchronization action.

### Routines

Implemented in:

`lib/screens/routines_screen.dart`

The app includes three predefined basic routines:

- Push
- Pull
- Legs

Users can also create custom routines from the exercise library. The selected
routine is stored locally and appears in the Home screen.

### Workout Session

Implemented in:

`lib/screens/workout_session_screen.dart`

The session screen includes:

- Workout timer.
- Current exercise.
- Set counter.
- Repetition information.
- Progress bar.
- Complete set / next exercise flow.

When a routine is completed, the app saves the workout locally and estimates
**100 kcal** burned per completed routine.

### History

Implemented in:

`lib/screens/history_screen.dart`

The history screen shows completed workouts with:

- Routine name.
- Date.
- Duration.
- Estimated calories.

### Progress

Implemented in:

`lib/screens/progress_screen.dart`

The progress screen shows:

- Total workouts.
- Total trained minutes.
- Total estimated calories.
- Weekly activity chart.
- Recent workouts.

## Animations

The project uses `flutter_animate` to make the interface more polished:

- Water drops when the user updates water intake.
- Fire animation for calories.
- Animated calories badge showing `+100 kcal / routine`.
- Dumbbell/check animation when completing sets.
- Animated badge when moving to the next exercise.
- Fire animation when completing a workout.
- Animated routine cards and active plan label.
- Staggered entry animations in the exercise library.
- Animated cards, chart and recent workouts in the progress screen.

## Google Maps Integration

The Home screen includes a **Gyms Near You** card. Pressing the **MAP** button
opens Google Maps with a search for nearby gyms.

This is implemented with:

`url_launcher`

The Android manifest includes internet permission and HTTPS intent visibility
configuration.

## General File Structure

| Folder/File | Purpose |
| --- | --- |
| `lib/main.dart` | App entry point, theme and route configuration. |
| `lib/models/` | Data models such as `Routine`, `Exercise` and `CompletedWorkout`. |
| `lib/screens/` | Main app screens: Home, Routines, Exercises, Session, Progress and History. |
| `lib/services/` | API, SQLite database and synchronization logic. |
| `lib/controllers/` | Progress calculations and summary logic. |
| `lib/widgets/` | Reusable interface components such as routine cards and bottom navigation. |
| `lib/data/` | Local predefined data, including Push, Pull and Legs routines. |
| `pubspec.yaml` | Project metadata and package dependencies. |

## Main Packages Used

| Package | Usage |
| --- | --- |
| `go_router` | Navigation between screens. |
| `http` | REST API requests and JSON data loading. |
| `sqflite` | Local SQLite database. |
| `path` | Database path handling. |
| `fl_chart` | Progress chart visualization. |
| `flutter_animate` | UI animations. |
| `url_launcher` | Opening Google Maps / external links. |
| `google_fonts` | Typography styling. |

## Delivery Notes

According to the assignment statement, the ZIP delivery should include:

- This group identification document.
- The `lib` folder.
- `pubspec.yaml`.

Optional but recommended: include this Markdown version together with the plain
text version for easier reading.
