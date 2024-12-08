# MPro Notes

MPro Notes is a simple note-taking app with persistent data storage. The app allows users to create, update, and delete notes. It utilizes various Flutter packages to provide a smooth and efficient user experience.

## Features

- Create, update, and delete notes
- Persistent data storage using Drift
- Customizable themes with Provider
- Beautiful fonts with Google Fonts
- Popover menus for additional options
- Cupertino icons for a consistent look and feel

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/mpro_notes.git
   cd mpro_notes

2. Install dependencies:
   ```sh
    flutter pub get

3. Generate necessary files:
   ```sh
   flutter pub run build_runner build

4. Run the app:
   ```sh
   flutter run

## Dependencies

### Main Dependencies

- `cupertino_icons: ^1.0.8`
- `drift: ^2.22.1`
- `drift_flutter: ^0.2.2`
- `provider: ^6.1.2`
- `popover: ^0.3.1`
- `google_fonts: ^6.2.1`
- `flutter_launcher_icons: ^0.14.2`

### Dev Dependencies

- `flutter_lints: ^4.0.0`
- `drift_dev: ^2.22.1`
- `build_runner: ^2.4.13`

## Usage

1. Open the app.
2. Use the floating action button to create a new note.
3. Tap on vertical ellipsis to edit or delete a note.
4. Enjoy taking notes!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.