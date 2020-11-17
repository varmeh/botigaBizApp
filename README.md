# botiga_biz

A new Flutter project.

## Getting Started with flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

-   [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
-   [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## App Distribution

### Android

#### For Internal Testing

-   Create an appbundle version:

```
flutter build appbundle --flavor dev --release
```

-   Once the bundle is ready, create a sharing link using [Google Internal App Sharing](https://play.google.com/console/internal-app-sharing/)

-   You get a new link for each version. Send it to set of testers of testing

#### On Play Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build appbundle --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaBizApp_1.0.0 --flavor prod --release
```

The reason to use appbundle has been detailed in [article](https://developer.android.com/guide/app-bundle?authuser=1).

Botiga bizz app

---
