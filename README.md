- [Botiga Business App](#botiga-business-app)
  - [Command to generate models using json_serializable](#command-to-generate-models-using-json_serializable)
  - [Custom Icons](#custom-icons)
  - [Issues with iOS build](#issues-with-ios-build)
  - [App Version Number](#app-version-number)
  - [Firebase App Distribution](#firebase-app-distribution)
    - [Android](#android)
    - [iOS](#ios)
  - [App Distribution](#app-distribution)
    - [On Play Store](#on-play-store)
    - [On App Store](#on-app-store)

# Botiga Business App

Botiga eCommerce Platform hosts 2 mobile apps:

-   A Customer app (this one)
-   A Merchant app

These apps essentially covers the 2 aspects of marketplace - `supply` & `demand`

This app manages supply chain & is used by Botiga merchants to manage catalog, track orders & deliver products

## Command to generate models using json_serializable

```
flutter pub run build_runner build --delete-conflicting-outputs
```

## Custom Icons

-   Custom icons added using [Flutter Icon Generator](https://www.fluttericon.com/).

-   [How to do it?](https://medium.com/deviniti-technology-driven-blog/the-best-way-to-add-custom-icons-to-your-flutter-project-6381ab697813)

## Issues with iOS build

-   If you face unexpected build issues, do a clean build with the following:

```
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
```

-   [GeneratedPluginRegistrant.m Module not found](https://github.com/flutter/flutter/issues/43986)

## App Version Number

-   Flutter app version follows format `<version>+<buildNumber>` e.g. 0.2.1+2
-   `version` update mandatory for apple appstore
-   `buildNumber` update mandatory for playstore. Increment by 1 for every release

-   In short, change both version & build number before pushing to appstore & playstore

## Firebase App Distribution

-   Firebase app distribution would be used for testing apps
-   It should be done via `botiga-dev` project
-   Select appropriate `app` in `firebase console` for testing & upload your version there
-   Send the email to all testers & notify them

### Android

-   Create an apk version:

```
flutter build apk --flavor dev --release
```

-   Upload it

### iOS

-   First, create an ios app version:

```
flutter build ios --flavor dev --release
```

-   Once app is built, archieve it as explaind [here](https://flutter.dev/docs/deployment/ios#create-a-build-archive)

-   Once archieve is done, it will open distribution organizer

-   Use it to build an `Ad-hoc` distribution archieve. Once finished, `distribution archieve - ipa` will be exported at the path of your choice.

-   Upload the ipa

## App Distribution

### On Play Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build appbundle --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaBizApp_1.0.0+3 --flavor prod --release
```

-   `botigaBizApp_<version>` Version here should match one in pubspec.yaml

The reason to use appbundle has been detailed in [article](https://developer.android.com/guide/app-bundle?authuser=1).

### On App Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build ios --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaBizApp_1.0.0+3 --flavor prod --release
```

-   `botigaBizApp_<version>` Version here should match one in pubspec.yaml
-   Once app is built, archieve it as explaind [here](https://flutter.dev/docs/deployment/ios#create-a-build-archive)

-   Once archieve is done, it will open distribution organizer
