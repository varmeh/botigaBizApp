# Android App Distribution

## For Testing

-   Create an apk version:

```
flutter build apk --flavor dev --release
```

-   Once ready, upload it to `botiga-dev` project, `BotigaBizDev` android app in`firebase console`

-   Select testers group & send a new email for testing

## On Play Store

-   Create an **[obfuscated](https://flutter.dev/docs/deployment/obfuscate)** appbundle version for sharing with command:

```
flutter build appbundle --obfuscate --split-debug-info=/Users/varunmehta/Projects/botiga/symbols/botigaBizApp_0.1.0 --flavor prod --release
```

The reason to use appbundle has been detailed in [article](https://developer.android.com/guide/app-bundle?authuser=1).
