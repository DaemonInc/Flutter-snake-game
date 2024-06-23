# flutter_snake_game

Classic snake game made with Flutter using the [flame package](https://docs.flame-engine.org/latest/index.html).

## Getting Started

### How to run

- Make sure [Flutter](https://docs.flutter.dev/get-started/install) is installed on your machine
- Clone the repository

```bash
git clone https://github.com/NYJvMuijlwijk/Flutter-snake-game.git
cd Flutter-snake-game
```

- Install dependencies

```bash
flutter pub get
```

- Run the app

```bash
flutter run lib/main.dart
```

- Select the device you want to run the app on

### How to play

**Movement**

- Use the arrow keys or WASD to move the snake
- Use movement gestures on mobile devices (swipe up, down, left, right)

**Pause**

- Press `Escape` or `P` to pause the game

### Project structure

What the folders contain and the most important files:

- `assets/` contains assets used in the game
- `lib/` contains the main code of the app
  - `main.dart` is the entry point of the app
  - `components/` contains flame game components
    - `snake.dart` is the snake/player component
  - `enums/` contains enums used in the game
  - `extensions/` contains extensions/helper methods for ease of use
  - `mixins/` contains mixins classes for code separation
  - `models/` contains data models used in the game
    - `game_config.dart` is the game configuration model
  - `services/` contains services that handle game logic
    - `game_service.dart` is the main service that handles the game logic
  - `widgets/` contains flutter widgets for building the UI
