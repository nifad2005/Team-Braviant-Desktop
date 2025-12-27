# Team Braviant Desktop App

Welcome to **Team Braviant Desktop**! 🚀  
This repository contains the **Flutter desktop application template** for our team projects. It is designed to run on **Windows, macOS, Linux**, as well as mobile platforms (optional).

---

## 📌 Project Purpose

This project serves as a **central starting point for all Team Braviant desktop apps**. It provides:  
- Cross-platform compatibility  
- Clean project structure  
- Ready-to-use Flutter setup for desktop and mobile  
- A foundation to quickly build UI and features  

Our goal: **Empower team members to contribute efficiently** and build innovative solutions.  

---

## 🗂 Folder Structure

| Folder/File      | Description |
|-----------------|-------------|
| `lib/`          | Dart source code for the app (UI, logic, features) |
| `android/`      | Android-specific native code |
| `ios/`          | iOS-specific native code |
| `windows/`      | Windows desktop build files |
| `macos/`        | macOS desktop build files |
| `linux/`        | Linux desktop build files |
| `web/`          | Web version support files |
| `test/`         | Unit and widget tests |
| `pubspec.yaml`  | Flutter dependencies configuration |
| `README.md`     | Project documentation (this file) |
| `.gitignore`    | Specifies files to ignore in Git |
| `analysis_options.yaml` | Lint rules and coding standards |

---

## 🚀 Getting Started

### 1. Prerequisites
Make sure you have:  
- Flutter SDK installed ([Flutter Docs](https://flutter.dev/docs/get-started/install))  
- Dart SDK (comes with Flutter)  
- Desktop platform enabled:  
```bash
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
