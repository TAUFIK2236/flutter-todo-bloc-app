# Flutter Todo App with BLoC

This is a Flutter learning project built to practice Todo app development, BLoC state management, local storage, REST API requests, repository pattern, authentication, and Git/GitHub workflow.

## Project Overview

This project started as a simple Todo app and was expanded step by step.

The app includes:

- A local Todo app using SharedPreferences
- A REST API Todo screen using JSONPlaceholder
- BLoC state management
- Repository pattern
- Login/authentication using DummyJSON Auth API
- Token saving using SharedPreferences
- AuthWrapper routing based on saved token
- Git branch, pull request, and merge workflow

The main goal of this project is not only to build features, but to understand how Flutter app architecture works in a real project.

## Features

### Local Todo Features

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

### API Todo Features

- Fetch todos from an API using GET
- Create a fake todo using POST
- Update a todo title using PATCH
- Delete a todo using DELETE
- Handle API loading, success, and error states using BLoC
- Show retry button when API loading fails
- Show button loading state while creating a todo
- Convert JSON response data into Dart model objects
- Use repository pattern between BLoC and service layer

### Authentication Features

- Login using username and password
- Receive access token from API
- Save token locally using SharedPreferences
- Check saved token when the app starts
- Keep user logged in after app restart
- Logout by removing saved token
- Fetch current user data using Bearer token
- Use AuthWrapper to switch between LoginScreen and ApiTodoScreen

## Technologies Used

- Flutter
- Dart
- flutter_bloc
- shared_preferences
- http
- REST API
- JSONPlaceholder
- DummyJSON Auth API
- JSON encode/decode
- Git and GitHub

## Folder Structure

```text
lib/
 ├── blocs/
 │    ├── todo/
 │    │    ├── todo_bloc.dart
 │    │    ├── todo_event.dart
 │    │    └── todo_state.dart
 │    │
 │    ├── api_todo/
 │    │    ├── api_todo_bloc.dart
 │    │    ├── api_todo_event.dart
 │    │    └── api_todo_state.dart
 │    │
 │    └── auth/
 │         ├── auth_bloc.dart
 │         ├── auth_event.dart
 │         └── auth_state.dart
 │
 ├── models/
 │    ├── todo.dart
 │    └── api_todo.dart
 │
 ├── repositories/
 │    ├── api_todo_repository.dart
 │    └── auth_repository.dart
 │
 ├── services/
 │    ├── todo_api_service.dart
 │    └── auth_service.dart
 │
 ├── screens/
 │    ├── about_screen.dart
 │    ├── add_todo_screen.dart
 │    ├── edit_todo_screen.dart
 │    ├── todo_home_page.dart
 │    ├── api_todo_screen.dart
 │    ├── login_screen.dart
 │    └── auth_wrapper.dart
 │
 ├── widgets/
 │    └── todo_tile.dart
 │
 └── main.dart
```

## How the Local Todo App Works

The local Todo app uses BLoC to separate UI from logic.

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

## Local Todo BLoC Events

The local Todo app uses these events:

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

## Local Todo BLoC State

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

This keeps the local Todo app simple and easier to understand.

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

## API Learning Feature

This project also includes an API Todo screen to practice REST API requests in Flutter.

The API feature uses JSONPlaceholder as a fake REST API for learning and testing.

### API Used

```text
https://jsonplaceholder.typicode.com/todos
```

### API CRUD Flow

```text
GET    = fetch todos from the server
POST   = create a new todo
PATCH  = update an existing todo
DELETE = delete a todo
```

### API BLoC Flow

```text
ApiTodoScreen
→ sends an event
→ ApiTodoBloc handles the event
→ ApiTodoRepository manages the data operation
→ TodoApiService makes the HTTP request
→ API response comes back
→ JSON is decoded
→ ApiTodo objects are created
→ ApiTodoBloc emits a new state
→ BlocBuilder updates the UI
```

### API States

```text
ApiTodoLoading = data is loading
ApiTodoLoaded  = data loaded successfully
ApiTodoError   = something went wrong
```

### Important API Note

JSONPlaceholder is a fake API. POST, PATCH, and DELETE requests return successful responses, but the data is not permanently saved on the server.

## Repository Pattern

This project uses the repository pattern for the API feature.

Simple structure:

```text
ApiTodoScreen
→ ApiTodoBloc
→ ApiTodoRepository
→ TodoApiService
→ API server
```

Meaning:

```text
Service = makes the actual HTTP request
Repository = manages the data layer
Bloc = handles events and states
UI = displays the state
```

This keeps the BLoC cleaner because the BLoC does not directly depend on the API service.

## Authentication Feature

This project includes a basic authentication flow using the DummyJSON Auth API.

### Auth APIs Used

```text
https://dummyjson.com/auth/login
https://dummyjson.com/auth/me
```

### Login Test Account

```text
username: emilys
password: emilyspass
```

### Auth Flow

```text
User enters username and password
→ LoginRequestedEvent is sent
→ AuthBloc calls AuthRepository
→ AuthRepository calls AuthService
→ AuthService sends POST login request
→ API returns access token
→ Token is saved in SharedPreferences
→ AuthSuccess state is emitted
→ AuthWrapper shows ApiTodoScreen
```

### Token Check Flow

```text
App starts
→ CheckAuthStatusEvent is sent
→ AuthBloc asks AuthRepository for saved token
→ If token exists, AuthSuccess is emitted
→ If token does not exist, AuthInitial is emitted
→ AuthWrapper decides which screen to show
```

### Logout Flow

```text
User taps logout
→ LogoutRequestedEvent is sent
→ AuthBloc calls AuthRepository.logout()
→ Saved token is removed from SharedPreferences
→ AuthInitial state is emitted
→ AuthWrapper shows LoginScreen
```

### Authenticated Request Flow

```text
User taps person icon
→ GetCurrentUserEvent is sent
→ Saved token is loaded
→ Token is sent in Authorization header
→ API returns current user data
→ SnackBar shows current user name
```

### Authorization Header

```text
Authorization: Bearer token
```

The token acts like a login ticket. The app sends the token to prove that the user is logged in.

## Screens

### Todo Home Screen

The local Todo screen shows the todo list. It allows users to add, edit, delete, and complete todos.

### Add Todo Screen

This screen allows users to type a new local todo and save it.

### Edit Todo Screen

This screen allows users to update an existing local todo.

### API Todo Screen

This screen shows todos from the JSONPlaceholder API. It supports GET, POST, PATCH, and DELETE request practice.

### Login Screen

This screen allows users to log in using the DummyJSON Auth API.

### AuthWrapper

This screen decides whether to show LoginScreen or ApiTodoScreen based on the saved token.

### About Screen

This screen gives simple information about the app.

## Git and GitHub Workflow

This project uses a professional Git workflow.

```text
main branch = stable project
api-learning branch = API CRUD feature
auth-learning branch = authentication feature
```

Workflow used:

```text
Create feature branch
→ Build feature
→ Commit changes
→ Push branch to GitHub
→ Open Pull Request
→ Merge into main
```

This keeps the main branch stable while new features are developed separately.

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

- Flutter widgets
- Stateful screens
- Navigation using Navigator.push and Navigator.pop
- Passing data between screens
- TextEditingController
- ListView.builder
- Reusable widgets
- Local storage with SharedPreferences
- JSON encoding and decoding
- BLoC events
- BLoC states
- BlocProvider
- BlocBuilder
- BlocListener
- BlocConsumer
- API loading, success, and error states
- HTTP GET, POST, PATCH, and DELETE requests
- API service class
- Repository pattern
- Dependency injection basics
- Login API request
- Access token handling
- Saving token with SharedPreferences
- Checking auth status on app startup
- Logout flow
- Authenticated API request using Bearer token
- AuthWrapper screen routing
- Git branches
- Pull requests
- Merging branches into main

## Future Improvements

- Add due dates for todos
- Add priority levels
- Add categories
- Add search
- Improve UI design
- Add dark mode
- Add signup flow
- Add Firebase authentication
- Add Firestore database
- Sync todos with a real backend API
- Add profile screen
- Add better error handling