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
  - Cloud Storage (for media, if used)  
  - Cloud Messaging (for notifications)  
- **Riverpod** (state management)  


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
