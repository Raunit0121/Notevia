# 📝 Smart Todo List - Flutter Application

A comprehensive and modern Flutter application that combines task management and note-taking capabilities with Firebase backend integration.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-9.0+-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🚀 Features

### ✨ Core Features
- **📋 Task Management**: Create, edit, and organize tasks with categories
- **📝 Note Taking**: Rich note editor with labels and organization
- **🔔 Smart Notifications**: Local notifications for task reminders
- **📅 Date Filtering**: Filter tasks by specific dates
- **🔍 Search Functionality**: Search through your notes quickly

### 🔐 Authentication
- **📧 Email/Password**: Traditional email-based authentication
- **🔑 Google Sign-In**: One-tap Google authentication
- **📱 Phone Authentication**: SMS-based OTP verification
- **🔒 Password Reset**: Secure password recovery via email

### 🎨 User Experience
- **📱 Modern UI**: Clean, intuitive interface with orange theme
- **🎭 Smooth Animations**: Lottie animations and transitions
- **📊 Visual Categories**: Icon-based task categorization
- **📌 Pin Important Items**: Pin important notes for quick access
- **🔄 Real-time Sync**: Firebase Firestore for cloud synchronization

## 📱 Screenshots

### Authentication Flow
- Splash Screen with Lottie Animation
- Onboarding Screens (3 pages)
- Welcome Screen
- Login/Signup Screens
- Phone Authentication
- OTP Verification

### Main Application
- Home Screen with Task List
- Add Task Screen
- Notes Screen with Grid Layout
- Note Editor
- Search and Filter Options

## 🛠️ Technology Stack

### Frontend
- **Flutter** - UI Framework
- **Provider** - State Management
- **Material Design** - UI Components

### Backend & Services
- **Firebase Authentication** - User authentication
- **Firebase Firestore** - Cloud database
- **Firebase Core** - Firebase initialization

### Additional Packages
- **flutter_local_notifications** - Local notifications
- **timezone** - Timezone handling
- **permission_handler** - Permission management
- **google_sign_in** - Google authentication
- **lottie** - Animations
- **intl** - Internationalization
- **cloud_firestore** - Firestore operations
- **flutter_staggered_grid_view** - Grid layouts
- **google_fonts** - Custom fonts
- **share_plus** - Share functionality
- **pin_code_fields** - OTP input

## 📋 Prerequisites

Before running this application, make sure you have:

- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (2.17 or higher)
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Project** with Authentication and Firestore enabled
- **Google Services** configured for Android/iOS

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/smart_todo_list.git
cd smart_todo_list
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication with Email/Password, Google Sign-In, and Phone
4. Create a Firestore database

#### Configure Firebase for Flutter
1. Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

2. Configure Firebase for your project:
```bash
flutterfire configure
```

3. This will generate the `firebase_options.dart` file automatically.

### 4. Platform-Specific Setup

#### Android
- Update `android/app/build.gradle` with your Firebase configuration
- Ensure `google-services.json` is in `android/app/`

#### iOS
- Update `ios/Runner/Info.plist` with Firebase configuration
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`

### 5. Run the Application
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── Screens/                  # UI Screens
│   ├── SplashScreen.dart
│   ├── OnboardingScreen.dart
│   ├── WelcomeScreen.dart
│   ├── LoginScreen.dart
│   ├── SingupScreen.dart
│   ├── phoneAuth.dart
│   ├── otpScreen.dart
│   ├── HomeScreen.dart
│   ├── add_task_screen.dart
│   ├── notes_screen.dart
│   └── add_notes_screen.dart
├── models/                   # Data Models
│   └── task_model.dart
├── services/                 # Business Logic
│   ├── notification_service.dart
│   └── ForgetPassword.dart
├── widgets/                  # Reusable Components
│   ├── task_card.dart
│   └── uihelper.dart
└── generated/               # Auto-generated Files
    └── assets.dart
```

## 🎯 Key Features Explained

### Task Management
- **Categories**: Choose from predefined categories (favorite, star, time, home)
- **Deadlines**: Set specific dates and times for tasks
- **Notes**: Add detailed notes to tasks
- **Completion Tracking**: Mark tasks as done with visual feedback
- **Date Filtering**: View tasks for specific dates

### Notes System
- **Rich Editor**: Full-featured note editor with title and content
- **Labels**: Organize notes with custom labels
- **Pinning**: Pin important notes for quick access
- **Search**: Find notes by title or content
- **Sharing**: Share notes via system share dialog
- **Grid Layout**: Masonry grid for visual organization

### Authentication Flow
- **Splash Screen**: Animated welcome with app branding
- **Onboarding**: Feature introduction for new users
- **Multiple Auth Methods**: Email, Google, and Phone authentication
- **Password Recovery**: Secure email-based password reset

## 🔧 Configuration

### Firebase Configuration
The app uses Firebase for:
- **Authentication**: User management
- **Firestore**: Data storage for tasks and notes
- **Real-time Sync**: Automatic data synchronization

### Notification Settings
- **Permission Request**: App requests notification permissions on startup
- **Task Reminders**: Local notifications for task deadlines
- **Timezone Support**: Proper timezone handling for notifications

## 📊 Data Models

### Task Model
```dart
class Task {
  String id;
  String title;
  DateTime createdAt;
  DateTime? deadline;
  IconData? category;
  String? note;
  bool isDone;
}
```

### Note Model (Firestore)
- `title`: Note title
- `text`: Note content
- `label`: Custom label
- `isPinned`: Pinned status
- `timestamp`: Creation timestamp

## 🎨 UI/UX Design

### Color Scheme
- **Primary**: `#DA6A00` (Orange)
- **Background**: `#FFF3E0` (Light Cream)
- **Secondary**: `#4E342E` (Dark Brown)
- **Accent**: `#FF9800` (Light Orange)

### Design Principles
- **Material Design**: Following Google's design guidelines
- **Responsive**: Adapts to different screen sizes
- **Accessible**: Proper contrast and touch targets
- **Intuitive**: Clear navigation and user flow

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase Team** for the backend services
- **Material Design** for the design system
- **Lottie** for the beautiful animations

## 📞 Support

If you have any questions or need help with the application:

- **Issues**: Create an issue on GitHub
- **Email**: your.email@example.com
- **Documentation**: Check the inline code comments

## 🔄 Version History

- **v1.0.0** - Initial release with basic todo and notes functionality
- **v1.1.0** - Added authentication and Firebase integration
- **v1.2.0** - Enhanced UI and added notifications
- **v1.3.0** - Added search and sharing features

---

**Made with ❤️ using Flutter and Firebase**
