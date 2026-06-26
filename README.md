ظ# 🚀 Taskify - Advanced Task Management App

Taskify is a production-ready, collaborative task management application built with **Flutter** and **Firebase**. The core focus of this project isn't just the UI, but implementing enterprise-level software engineering practices, scalable architecture, strict data security, and comprehensive testing.

---

## 📸 Screenshots & UI
> **Note:** Place your app screenshots inside a `/screenshots` folder in your repository and link them below!

| Login & Authentication | Dashboard & Projects | Task Management |
| :---: | :---: | :---: |
| <img src="screenshots/login.png" width="250"> | <img src="screenshots/dashboard.png" width="250"> | <img src="screenshots/tasks.png" width="250"> |

---

## 🛠️ Technical Highlights & Architecture

The app strictly follows **Clean Architecture** principles combined with the **BLoC/Cubit** pattern for state management, ensuring complete separation of concerns, testability, and scalability.

### 📐 Layer Breakdown:
*   **Presentation Layer:** Driven by Flutter UI components and BLoC/Cubit to manage strict state transitions (Loading, Success, Error states).
*   **Domain Layer (Core):** Contains pure Dart business logic, including Entities and abstract Use Cases (independent of any external libraries).
*   **Data Layer:** Handles data retrieval and persistence. Implements Data Sources (Firebase Firestore remote & Hive local storage) and Repository Implementations.

### 🔐 Advanced Features Implemented:
*   **Strict Data Isolation:** Enhanced security layout where Firestore query rules dynamically append `.where('userId', isEqualTo: currentUserId)`. Users can only stream or write their own tasks, completely eliminating data leaks.
*   **Google Sign-In Authentication:** Seamless Firebase Auth integration linking Google credentials with a secure Firestore user sync flow.
*   **Offline Support:** Native caching mechanisms using Hive for local storage.

---

## 🧪 Robust Testing & Code Quality
Quality Assurance was integrated from day one. Code maintenance is guaranteed through explicit static analysis and modular unit testing.

*   **Behavioral Unit Tests:** 100% pass rate on BLoC state transitions (`TasksBloc`, `QuotesCubit`).
*   **Code Quality:** Cleaned architecture with `0 errors, 0 warnings` verified via regular `flutter analyze` scans.

```bash
# Run tests to verify the suite
flutter test

# Verify production code quality
flutter analyze
