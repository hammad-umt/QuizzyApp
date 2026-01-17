# QuizzyApp Pro 📚

**Master Pakistani Curriculum with AI-Powered MCQ Quizzes**

We have created this application as our Semester Final project for Mobile Application Development where we learned Flutter. QuizzyApp Pro is an innovative learning platform that helps students master concepts through multiple-choice questions (MCQs) - the most effective learning method!

## 🌟 Key Features

- ✨ **MCQs for Effective Learning**: Remember concepts easier with interactive multiple-choice questions
- 📚 **Complete Pakistani Curriculum**: Questions from all major subjects and boards
- 🎓 **Subject-Based Organization**: Navigate through organized chapters for structured learning
- 🎯 **Flexible Quiz Options**: Choose the number of MCQs (5, 10, 15, 20, 25, 30, 50)
- 📊 **Detailed Performance Analytics**: Track your progress with comprehensive result analysis
- 🔐 **Secure Authentication**: Firebase authentication for personalized learning
- 🌙 **Dark/Light Theme**: Comfortable viewing in any lighting condition
- 📱 **Cross-Platform Support**: Works on Android, iOS, and Web

## 💡 Why MCQs?

MCQs (Multiple-Choice Questions) are scientifically proven to be the **easiest and most effective way to remember concepts**:

- **Active Recall**: Retrieve information from memory to strengthen learning
- **Immediate Feedback**: Know instantly if your answer is correct
- **Pattern Recognition**: Spot common exam questions and patterns  
- **Time Efficiency**: Practice in realistic exam conditions
- **Memory Retention**: MCQs improve long-term knowledge retention

## 🚀 Installation & Setup

### Prerequisites

Before you install QuizzyApp Pro, make sure you have:

- **Flutter SDK** (v3.0 or higher)
- **Dart SDK** (v3.0 or higher)
- **Android Studio** or **Xcode** (for mobile development)
- **Git** for version control
- A **Firebase project** set up

### Step-by-Step Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/QuizzyApp.git
cd QuizzyApp
```

#### 2. Install Flutter Dependencies

```bash
flutter pub get
```

#### 3. Configure Firebase

- Create a Firebase project at [firebase.google.com](https://firebase.google.com)
- Set up Firebase Authentication (Email/Password)
- Set up Firestore Database
- Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
- Place them in the respective directories

#### 4. Run the Application

**For Android**:
```bash
flutter run
```

**For iOS**:
```bash
flutter pub get
cd ios
pod install
cd ..
flutter run
```

**For Web**:
```bash
flutter run -d chrome
```

### Building for Release

#### Android Release

```bash
flutter build apk --release
# or for App Bundle (recommended for Play Store)
flutter build appbundle --release
```

The APK will be located at: `build/app/outputs/apk/release/app-release.apk`

#### iOS Release

```bash
flutter build ipa --release
```

## 🎮 How to Use

1. **Sign Up/Login**: Create an account using your email
2. **Select Board**: Choose your education board (FSC, SSC, etc.)
3. **Choose Discipline**: Select Science, Commerce, or Arts
4. **Pick Subject**: Choose the subject you want to practice
5. **Select Chapters**: Pick chapters and MCQ count (5-50 questions)
6. **Start Quiz**: Answer questions and get instant feedback
7. **View Results**: Analyze your performance with detailed analytics
8. **Logout**: Use the logout button in the top-right corner to safely exit

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── quiz_provider.dart        # State management
├── firebase_options.dart     # Firebase configuration
├── screens/                  # UI Screens
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── chapter_mcq_selection_screen.dart
│   ├── quiz_screen.dart
│   └── result_screen.dart
├── services/                 # Business logic
│   ├── firebase_auth_service.dart
│   ├── board_data_service.dart
│   └── notification_service.dart
└── firebaseServices/         # Firebase utilities
    └── firebase_Services.dart
```

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Firebase**: Backend services (Auth, Firestore, Cloud Functions)
- **Provider**: State management
- **Material Design 3**: UI components

## 🔐 Security

- Secure Firebase Authentication
- Data encryption in transit
- User data privacy protection
- Regular security updates

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- **Project**: Semester Final Project
- **Subject**: Mobile Application Development
- **Framework**: Flutter

## 📞 Support

For support, email us or open an issue on GitHub.

---

**Start Learning Better Today with QuizzyApp Pro! 🚀**

Master concepts faster with scientifically-proven MCQ learning methodology.

