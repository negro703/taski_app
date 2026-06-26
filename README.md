ظ# 🚀 # 🎯 Taskify - Task Management App

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
