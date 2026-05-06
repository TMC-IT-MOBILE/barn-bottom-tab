# Barn Bottom Tab

A customizable animated bottom tab bar for Flutter with drag interaction and smooth transitions.

## ✨ Features

- Drag to switch tabs
- Tap to select tabs
- Smooth animated indicator
- Fully customizable UI
- Supports custom widgets for each tab

---

## 🚀 Usage

```dart
import 'package:flutter/material.dart';
import 'package:barn_bottom_tab/barn_owl_bottom_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DemoScreen(),
    );
  }
}

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BarnBottomTab(
          containerWidth: 300,
          numOfTabs: 4,
          tabWidgets: const [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.favorite),
            Icon(Icons.person),
          ],
          onSelectTab: (index) {
            debugPrint("Selected tab: $index");
          },
        ),
      ),
    );
  }
}
```
---
## 📸 Preview

![Demo](https://github.com/TMC-IT-MOBILE/barn-bottom-tab/blob/main/assets/bottom_tab_animated.gif)
---
## 🛠️ TODO

- Add glassmorphism (blur + transparency) support for tab and container
- Improve cross-platform blur consistency (Android & iOS)
- Add customizable blur intensity (sigmaX, sigmaY)
- Optional backdrop performance optimization
- Add preset themes (glass, solid, minimal)
- Add animation customization options
---
## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  barn_bottom_tab: ^0.0.1


