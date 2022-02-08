# Preferences

This package is part of [Qt Quick Fixes](https://github.com/dreavjr/qt_quick_fixes). Please check the main package for more information, notably on licensing.

This package is an integrated solution for a Preferences window based on the `Settings` QML type, with the following features:

- Compiling the default settings value from a single place in the code (their initial value in the QML widgets)
- Computing UI-independent values in a single place in the code
- Providing a "Reset" button in the Preferences window, resetting each widget to its initial value
- Providing an "Apply" button in the Preferences window, triggering an action in another component

## Running the Example

For running the example as is, execute the `run.py` script.

## Adapting the Solution

To adapt the code for your application, follow this workflow:

- Edit `Preferences.qml`, adding the widgets necessary for the user to customize each setting
- Update the "Settings - Persistence" section in `Preferences.qml`, binding the properties needed to restore the widgets' states
- Update the "Settings - Global UI-Independent Values" section in `Preferences.qml`, creating or binding calculated properties to be used elsewhere in the application

    The design principle is that the application should not directly use the Persistence settings stored in `settings_internals`: those depend on the widgets and could change if, for example, the design replaces a checkbox for a pair of radio boxes. The UI-Independent values should be more "logical" way, independent of those details.

- Recompute the default settings calling `run.py --compile`. That will update the `GlobalSettings.qml` automatically and recreate `reset.tmp.qml`
- Update the `reset()` function in `Preferences.qml` with the code in `reset.tmp.qml` (reincorporating, eventually, any custom processing)

## System-Specific Advice

### Linux

In Linux, the preferences are stored in `~/.config/{organizationName}/{applicationName}.conf`, with attributes from `QApplication`. Deleting this file is usually enough to get rid of the preferences, for example:

```rm ~/.config/eduardovalle.com/Preferences-Demo.conf```

### macOS

In macOS, preferences are stored in `~/Library/Preferences/{org}.{app}.plist`, with org being the reversed domain from `QApplication.organizationName` (e.g., "com.eduardovalle" for "eduardovalle.com") and app being `QApplication.applicationName`. Simply deleting this file often fails to have an immediate effect because of the preferences cache.

A brute force solution is to stop the preferences cache processes, with:

```killall cfprefsd```

A neater alternative (but that some users report not always to work) is to use the proper macOS commands:

```defaults delete {organizationName}.{applicationName}```

For example, instead of using...

```rm ~/Library/Preferences/com.eduardovalle.Preferences-Demo.plist```

...the command below should get rid of both the preferences file and cache:

```defaults delete com.eduardovalle.Preferences-Demo```
