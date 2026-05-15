# Flutter Todo App with BLoC

This is a simple Todo app built with Flutter. The goal of this project is to practice Flutter basics, clean folder structure, navigation, local storage, and BLoC state management.

## Project Overview

This app allows users to manage daily tasks. Users can add, edit, delete, and mark todos as complete or incomplete. The app also saves todos locally, so the data stays even after restarting the app.

This project was built as a learning project to understand how Flutter UI works with BLoC architecture.

## Features

- Add new todos
- Edit existing todos
- Delete todos
- Mark todos as complete or incomplete
- Show an empty message when there are no todos
- Show SnackBar messages after actions
- Navigate between screens
- Save todos locally using SharedPreferences
- Load saved todos when the app opens
- Use BLoC for state management
- Clean folder structure

## Technologies Used

- Flutter
- Dart
- flutter_bloc
- shared_preferences
- JSON encode/decode

## Folder Structure

```text
lib/
 ├── blocs/
 │    └── todo/
 │         ├── todo_bloc.dart
 │         ├── todo_event.dart
 │         └── todo_state.dart
 │
 ├── models/
 │    └── todo.dart
 │
 ├── screens/
 │    ├── about_screen.dart
 │    ├── add_todo_screen.dart
 │    ├── edit_todo_screen.dart
 │    └── todo_home_page.dart
 │
 ├── widgets/
 │    └── todo_tile.dart
 │
 └── main.dart
````

## How the App Works

The app uses BLoC to separate the UI from the logic.

Simple flow:

```text
User action
→ Event is sent
→ TodoBloc handles the event
→ New state is emitted
→ BlocBuilder rebuilds the UI
→ Updated todos are saved locally
```

Example:

```text
User adds a todo
→ AddTodoEvent is sent
→ TodoBloc adds the new todo
→ TodoLoaded(updatedTodos) is emitted
→ UI updates
→ Todos are saved in SharedPreferences
```

## BLoC Events

The app uses these events:

```text
LoadTodosEvent
AddTodoEvent
DeleteTodoEvent
EditTodoEvent
ToggleTodoEvent
```

### LoadTodosEvent

This event runs when the app starts. It loads saved todos from local storage.

### AddTodoEvent

This event adds a new todo to the list.

### DeleteTodoEvent

This event deletes a todo using its index.

### EditTodoEvent

This event updates an existing todo title.

### ToggleTodoEvent

This event changes a todo between complete and incomplete.

## BLoC State

The app uses a simple state:

```text
TodoLoaded
```

`TodoLoaded` contains the current todo list.

```dart
class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded(this.todos);
}
```

This keeps the app simple and easier to understand.

## Local Storage

The app uses SharedPreferences to save todos locally.

Because SharedPreferences cannot save custom objects directly, each Todo object is converted into JSON before saving.

Save flow:

```text
Todo object
→ toJson()
→ Map
→ jsonEncode()
→ JSON String
→ SharedPreferences
```

Load flow:

```text
SharedPreferences
→ JSON String
→ jsonDecode()
→ Map
→ Todo.fromJson()
→ Todo object
```

## Screens

### Todo Home Screen

The main screen shows the todo list. It also allows users to open the add screen, edit screen, and about screen.

### Add Todo Screen

This screen allows users to type a new todo and save it.

### Edit Todo Screen

This screen allows users to update an existing todo.

### About Screen

This screen gives simple information about the app.

## How to Run the Project

1. Clone this repository.

```bash
git clone <repository-link>
```

2. Go into the project folder.

```bash
cd <project-folder-name>
```

3. Install packages.

```bash
flutter pub get
```

4. Start an emulator or connect a physical device.

5. Run the app.

```bash
flutter run
```

Or run on a specific emulator:

```bash
flutter run -d emulator-5554
```

## What I Learned

Through this project, I practiced:

* Flutter widgets
* Stateful screens
* Navigation using Navigator.push and Navigator.pop
* Passing data between screens
* TextEditingController
* ListView.builder
* Reusable widgets
* Local storage with SharedPreferences
* JSON encoding and decoding
* BLoC events
* BLoC states
* BlocProvider
* BlocBuilder
* Clean folder structure

## Future Improvements

* Add due dates for todos
* Add priority levels
* Add categories
* Add search
* Add Firebase authentication
* Sync todos with a backend API
* Improve UI design
* Add dark mode

