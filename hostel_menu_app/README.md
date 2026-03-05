![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange?logo=firebase)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![Version](https://img.shields.io/badge/Version-1.1.2-purple)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

# 🍽 Hostel Menu App

A **production-level Flutter mobile application** built for managing and viewing daily hostel menus with **Role-Based Access Control (RBAC)**, **Firebase backend**, **real-time updates**, **push notifications**, and **in-app update system**.

This project demonstrates a **complete real-world architecture** using Flutter + Firebase and follows modular and scalable project structure.

---

# 🚀 Download APK

👉 **Latest Release (v1.1.2)**
https://github.com/Stranger4uu/Production-level-apps/releases/download/v1.1.2/hostel-menu-v1.1.2.apk

---

# ✨ Features

### 🔐 Authentication

• Firebase Phone Authentication
• Secure login system
• User information stored in Firestore

---

### 👨‍🎓 Student Panel

• View today's hostel menu
• Separate sections for:

* Breakfast
* Lunch
* Dinner
  • Real-time updates from Firebase

---

### 👨‍💼 Admin Panel

#### Main Admin

• Add new food items
• Update menu items
• Delete menu items

#### Sub Admin

• Update existing menu items

---

### 🔔 Push Notifications

• Users receive notifications whenever the menu is updated
• Powered by **Firebase Cloud Messaging + Cloud Functions**

Example notification:

```
Menu Updated
Poha updated for Breakfast
```

---

### 🔄 In-App Update System

• App automatically checks for latest version
• Users receive update popup if a new version is available
• APK is downloaded directly from GitHub Releases

---

# 🏗 Tech Stack

### Mobile

• Flutter
• Dart

### Backend

• Firebase Authentication
• Firebase Firestore
• Firebase Cloud Messaging
• Firebase Cloud Functions

### DevOps

• GitHub Releases
• Netlify (landing page hosting)

---

# 📂 Project Structure

```
lib/
 ├── models/
 ├── providers/
 ├── screens/
 ├── services/
 ├── widgets/
 └── main.dart
```

This modular architecture keeps the project **scalable and maintainable**.

---

# 🔐 Roles in System

| Role       | Permissions                |
| ---------- | -------------------------- |
| Student    | View menu                  |
| Sub Admin  | Update menu                |
| Main Admin | Add / Update / Delete menu |

---

# ⚙️ How the Notification System Works

```
Admin updates menu
        ↓
Firestore notification document created
        ↓
Cloud Function triggers
        ↓
Push notification sent to all users
```

---

# 🧠 Key Learning Outcomes

• Production-level Flutter architecture
• Firebase backend integration
• Role-based access control (RBAC)
• Push notification system
• In-app update system
• Cloud Functions automation

---

# 📌 Version

**Current Version:** `v1.1.2`

---

# 👨‍💻 Author

**Yash Saini**

GitHub:
https://github.com/Stranger4uu

---

# ⭐ Support

If you like this project, consider giving it a **star ⭐ on GitHub**.
