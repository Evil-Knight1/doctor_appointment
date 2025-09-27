# Doctor Appointment App

A Flutter project for managing doctor appointments with a clean and scalable architecture.

---

## 📐 System Design

```
lib/
 └── core/
      ├── di/            # Dependency Injection (GetIt setup)
      ├── networking/    # Dio, Retrofit, interceptors, API configs
      ├── widgets/       # Shared/reusable widgets
      ├── routes/        # App navigation setup
      ├── themes/        # Light/Dark theme, typography, colors
      └── helpers/       # Utils, formatters, validators, constants
  
 └── features/
      └── home/
           ├── data/
           │    ├── models/   # Data models
           │    └── repos/    # Repository implementations
           ├── logic/         # Bloc / Cubit for state management
           └── ui/
                ├── screens/  # Feature screens
                └── widgets/  # Feature-specific widgets
```

---

## 🚀 Tech Stack

* **Flutter** (MVVM + Bloc)
* **Dio + Retrofit** for networking
* **GetIt** for dependency injection
* **Hive / Shared Preferences** for local storage
* **intl + easy_localization** for multi-language support
* **Firebase** (authentication, chat, notifications, calls)

---

## 📚 Resources

* [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
* [Flutter Cookbook](https://docs.flutter.dev/cookbook)
* [Flutter Documentation](https://docs.flutter.dev/)

---

## 📝 About

This project is the starting point for building a **doctor appointment application** with clean architecture and modular structure, making it easy to scale and maintain.
