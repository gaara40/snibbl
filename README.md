# Snibbl - Poetry, in its smallest, softest form

**Snibbl** is a creative social platform for poets and micro-storytellers. It allows users to share their poems, read others’ work, and engage through likes, comments, and saves. With a unique guest login mode, casual readers can explore poetry without needing an account. Powered by **Firebase** and **Flutter**, Snibbl ensures a smooth and secure experience for all poetry enthusiasts.

## ✨ Features
- 📩 **Email & Password Signup** (via Firebase Auth)  
- 🔑 **Google Sign-In**  
- 👤 **Guest Login Mode** (read-only experience with a generated guest username)  
- 📝 **Post Poems** (for registered users only)  
- ❤️ **Like, Save & Comment** on poems  
- 🔍 **Search Poets**  
- 🔔 **Notifications** (get notified when someone likes your post)  
- 📰 **Feed of Poems** (everyone can browse)  

## 🛠 Tech Stack
- **Flutter** (UI framework)  
- **Firebase**  
  - Authentication (email/password, Google, guest)  
  - Firestore (for posts, comments, likes, saves)   
  - Cloud Messaging (FCM) - push notifications (likes, comments, etc.) 
- **Riverpod** (state management)  


## ⚙️ Installation & Setup

### 1. Clone the repository

```bash
git clone https://github.com/gaara40/snibbl.git
cd snibbl
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

- Add your Firebase project
- Enable Auth, Firestore, Storage, and Cloud Messaging
- Place the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective folders

### 4. Run the app

```bash
flutter run
```
