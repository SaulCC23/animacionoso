# 🐻 AnimaciOso - Interactive Animated Login



<div align="center">

<img src="assets/Flutter-Demo-Google-Chrome-2025-09-18-16-10-17.gif" width="400" alt="AnimaciOso Demo"/>

**An interactive login screen featuring an adorable animated bear that reacts to user interactions in real-time**

✨ *Where authentication meets entertainment* ✨

</div>

## 📋 Features

🎭 **Smart Eye Tracking**: The bear follows your typing with its eyes, character by character  
🙈 **Privacy Aware**: Automatically covers its eyes when you enter your password  
⏱️ **Idle Behavior**: Returns to neutral position after 3 seconds of inactivity  
🎉 **Success Animation**: Celebrates when you log in successfully  
😔 **Error Feedback**: Shows disappointment when credentials are incorrect  
📱 **Responsive Design**: Works seamlessly across different screen sizes  

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point and MaterialApp configuration
└── screens/
    └── login_screen.dart     # Main login screen with Rive animations and interactions

assets/
└── animated_login_character.riv  # Rive animation file containing the bear character
```

### 📁 Key Files Description

- **`main.dart`**: Sets up the Flutter app and navigation to the login screen
- **`login_screen.dart`**: Contains all the magic ✨ - handles user interactions, Rive animation controls, form validation, and state management for the animated bear

## 🎨 What is Rive?

**Rive** is a powerful real-time interactive design and animation tool that allows designers and developers to create responsive, interactive animations that can react to user input, game state, or any other dynamic content.

### 🔧 State Machine Magic

The **State Machine** in Rive is like the brain 🧠 of our animated bear. It defines:

- **States**: Different poses and expressions (idle, checking, hands up, success, fail)
- **Inputs**: Variables that control behavior (`isChecking`, `isHandsUp`, `numLook`, triggers)
- **Transitions**: How the bear moves between different states based on user actions
- **Logic**: Rules that determine when and how animations should play

In our project, the State Machine controls:
- 👀 **Eye tracking** based on text input length
- 🙈 **Hand positions** when switching between email and password fields
- 🎭 **Facial expressions** for success and error states
- ⚡ **Smooth transitions** between all animation states

## 🎬 Demo

*Coming soon: GIF demonstration showing the complete functionality*

### 🔑 Test Credentials
```
📧 Email: saulcetina@gmail.com
🔐 Password: 1234
```

## 📚 Academic Information

**Subject**: Mobile Development  
**Professor**: Rodrigo Fidel Gaxiola Sosa 
**Institution**: Instituto Tecnologico De Mérida 

## 🎨 Animation Credits

Special thanks to the original creator of the bear animation:  
 
https://rive.app/marketplace/3645-7621-remix-of-login-machine/ 🙏

*The original Rive file has been adapted and enhanced with additional interactive features for this project.*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/animacionoso.git
   cd animacionoso
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 🛠️ Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  rive: ^0.12.4  # For interactive animations
```



---

<div align="center">

Made with love 💜 by Saul Alexis Cetina Canul💜

Bringing joy to daily interactions ✨

⭐ Don't forget to give this repository a star if you liked it! ⭐

</div>
