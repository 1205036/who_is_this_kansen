# Who Is This Kansen

A Pokedex-style guessing game for Azur Lane kansens, built in Flutter.

Show a kansen, identify it by name, unlock its entry in the Kansendex, and work toward dex completion.

## Status

Early development. v1 targets iOS first (followed by Android), English-only, offline-first, with the Iron Blood roster as the minimum viable scope.

## Architecture

- Clean Architecture (`presentation` / `domain` / `data` / `core`).
- BLoC for state management via `flutter_bloc`.
- `freezed` for value types, `slang` for app-text localization, `shared_preferences` for unlock progress.

## Working on the project

```sh
flutter pub get
dart run slang                       # regenerate i18n after editing lib/i18n/*.json
dart run build_runner build          # regenerate freezed files
flutter test
flutter run
```
