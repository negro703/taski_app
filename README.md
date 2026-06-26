<<<<<<< HEAD
# 🎯 Taskify - Task Management App

A production-ready task management application built with **Flutter** and **Firebase**. 

> **Developer Note:** This project marks my return to software engineering after completing my service in the Egyptian Armed Forces Engineering Corps. My primary focus here wasn't just building a beautiful UI, but rather implementing a robust foundation: Clean Architecture, strict data isolation, and comprehensive testing.

---

## 📸 Application Glimpse

### Authentication & Setup
| Login / Google Auth | Workspace Creation |
| :---: | :---: |
| <img src="WhatsApp%20Image%202026-06-26%20at%208.26.21%20AM.jpeg" width="250"> | <img src="WhatsApp%20Image%202026-06-26%20at%208.26.22%20AM.jpeg" width="250"> |

### Task Management Flow
| Main Dashboard | Daily Tasks List | Status Update |
| :---: | :---: | :---: |
| <img src="WhatsApp%20Image%202026-06-26%20at%208.26.43%20AM.jpeg" width="250"> | <img src="WhatsApp%20Image%202026-06-26%20at%208.26.25%20AM.jpeg" width="250"> | <img src="WhatsApp%20Image%202026-06-26%20at%208.26.24%20AM.jpeg" width="250"> |

---

## 🛠️ Under the Hood (Technical Highlights)

This app serves as a practical implementation of advanced software engineering concepts:

*   **Architecture:** Strictly follows **Clean Architecture** (Presentation, Domain, Data layers) for clean, maintainable, and scalable code.
*   **State Management:** Powered entirely by **BLoC/Cubit** for predictable state transitions and reactive UI.
*   **Security & Data Isolation:** Implemented dynamic Firestore filters based on `userId`. Users can only access their own tasks, completely preventing data leakage.
*   **Authentication:** Seamless **Google Sign-In** integration linked securely with Firebase Auth.
*   **Quality Assurance:** Covered with behavioral **Unit Tests** for the BLoC logic, ensuring that feature updates do not break existing functionality (7/7 Passed).

---

## 🚀 How to Run

1. Clone the repository:
   ```bash
   git clone [https://github.com/negro703/taski_app.git](https://github.com/negro703/taski_app.git)
=======
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
>>>>>>> c7db80e1ef7962aa5e5b57ffc7adcd591b5c5cc1
