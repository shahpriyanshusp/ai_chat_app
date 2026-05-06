# 💬 AI Chat App

A scalable and maintainable Flutter application built using **Clean Architecture** principles.  
This project is structured for clarity, testability, and long-term growth.

---

## 📂 Project Structure
lib/
├── core/
│   └── constants/
│
├── data/
│   ├── models/
│   ├── datasource/
│   └── repository/
│
├── domain/
│   ├── entities/
│   ├── repository/
│   └── usecases/
│
├── presentation/
│   ├── bloc/
│   ├── screens/
│   └── widgets/


// for what i used this command `flutter pub run build_runner build --delete-conflicting-outputs` : 
// i used this command to generate the code for the drift database