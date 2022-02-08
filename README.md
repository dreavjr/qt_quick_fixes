Qt Quick Fixes is an assorted collection of examples, solutions, and quick fixes for issues I encountered during my first projects in PySide6 / Qt for Python 6. Currently, the collection focuses mainly on QML issues.

Part of the collection are just usage examples a little more worked out than the ones available in the official documentation. Part are solutions/workarounds for minor issues. A couple of items are integrated solutions to larger issues.

# 1. Installation

The only dependencies are Python 3.8+ (I tested the code with Python 3.8 and 3.9) and Qt for Python 6.2 (I tested with PySide6==6.2.2). Each snippet (a pair or .py / .qml files with the same name) is self-sufficient and independent. Modules that depend on more files are in subdirectories.

# 2. The Collection

## Action (worked example)

Simple, worked example on how to use actions on QML. Illustrates the advantages of concentrating each user command into an action.

## Bridge (worked example)

Simple, worked example on how to bridge QML and Python code. Illustrates `@QmlElement` and `@QmlSingleton` (and how to import them in QML), `Property`, `Signal`, and `@Slot`.

See also: File Drag n' Drop, JS Datatypes

## Close on Quit (workaround)

Workaround for an issue in Qt 6.2.2 on macOS in which the shortcut cmd+Q will close an application without sending the `onClosing` signal to the windows to allow them to set `close.accepted`.

- close_on_quit_v1: solves the issue by installing an event filter on the application and intervening on `QEvent.Quit`
- close_on_quit_v2: (recommended) solves the issue by overwriting the platform Quit menu item with a custom entry

See also: Menu Bar, Menu Dynamic, View Events

## Dialog (worked example, counter-intuitive syntax)

Simple, worked example on how to use platform `MessageDialog`. Illustrates a counter-intuitive syntax issue in `buttons`, where failure to parenthesize the expression will lead to some buttons not showing.

## File Drag n' Drop (worked example)

Worked example on creating a `DropArea` that accepts drop events with files (and, potentially, other URLs) from outside the application. Also illustrates how to use the `Image` QML type.

See also: Bridge

## JS Datatypes (worked example, workaround)

Simple, worked example on how to transmit objects between QML and Python code. Shows two possible workarounds to JavaScript objects not being automatically translated to Python objects or dictionaries in Qt 6.2.2.

See also: Bridge

## Menu Bar (worked example)

Simple, worked example contrasting QuickControls menus (default) and platform menus (commented-out in the .qml file). Shows how to use actions on platform menus in Qt 6.2.2 by explicitly binding their attributes.

See also: Close on Quit, Menu Dynamic

## Menu Dynamic (integrated solution)

An integrated solution for the following issues:

- Switching dynamically between platform menus (macOS / Windows) and QuickControls menus (Linux)
- Auto sizing the width of QuickControls menus to hold the widest item
- Show the shortcuts on QuickControls menus

The solution is based on actions: each menu item *must* be linked to an `Action` QML object.

Thanks to [Martin Hoeher](https://martin.rpdev.net/2018/03/13/qt-quick-controls-2-automatically-set-the-width-of-menus.html) for the auto-sizing solution.

See also: Close on Quit, Menu Bar

## Preferences (integrated solution)

An integrated solution for offering a Preferences window based on the `Settings` QML type, with the following features:

- Compiling the default settings value from a single place in the code (their initial value in the QML widgets)
- Computing UI-independent values in a single place in the code (locally in the widgets)
- Providing a "Reset" action in the Preferences window, resetting each Preferences widget to its initial value
- Providing an "Apply" action in the Preferences window, triggering an action in another component to apply a change in the preferences

Since this is a slightly more complex solution, [specific instructions](preferences/README.md) are available for this example.

## View Event (worked example, workaround)

Worked example on how to view (and potentially filter) all events on the application. Illustrates how to use `QObject.eventFilter` and `QApplication.installEventFilter`. Illustrates a caveat (bug?) on Qt 6.2.2 that can lead to premature garbage collection of the event filter QObject (thanks to [QtForum.User:JonB](https://forum.qt.io/topic/133106/installeventfilter-not-working-on-pyside6) for this solution).

See also: Close on Quit

# 4. The Solutions in Context

To see the solutions in context, check out [Cook-a-Dream](https://github.com/dreavjr/cookadream), an application using Qt for Python and TensorFlow to provide a user-friendly interface for AI-generated images.


# 5. License

Copyright 2002 Eduardo Valle.

The software is available under a permissive MIT license. Please, check the [LICENSE.txt](LICENSE.txt) file for details.
