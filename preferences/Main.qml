/*=====================================================================================================================
  Copyright 2022 Eduardo Valle

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
  persons to whom the Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
  Software.

  The Software is provided "as is", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, including but not limited to the
  warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or
  copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or
  otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
======================================================================================================================*/
import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Window 6.2
import Qt.labs.settings 6.2
import Qt.labs.platform as QtPl


ApplicationWindow {
    // --- Basic properties
    id: mainwindow
    width: Constants.defaultWidth
    height: Constants.defaultHeight
    visible: true
    title: qsTr('Preferences Demo')

    // --- Window state persistence
    Settings {
        category: 'mainwindow'
        property alias x: mainwindow.x
        property alias y: mainwindow.y
        property alias width: mainwindow.width
        property alias height: mainwindow.height
    }

    // --- Settings - Persistence
    Settings {
        category: 'settings_internals'
        property alias st_ExecutionOption: optionaction.checked
    }

    // --- Settings - Global UI-Indepentent Values
    Settings {
        id: settings
        category: 'settings'
        readonly property bool st_ExecutionOption: optionaction.checked
    }

    property bool mainwindowReady: false
    onAfterAnimating: {
        if (!mainwindowReady) {
            console.debug('>> main', getNewSettings())
            mainwindowReady = true
            reconfigureaction.trigger()
            console.debug('<< main', getNewSettings())
        }
    }

    function getNewSettings() {
        return 'Current settings: ' +
                'executeOption\u00A0=\u00A0' + settings.st_ExecutionOption + // [Qt 6.22] Local settings must be taken from the property, or they will be out of sync
                '; maximumSize\u00A0=\u00A0' + settings.value('st_MaximumSize', GlobalSettings.st_MaximumSize) +
                '; useRemoteServer\u00A0=\u00A0' + settings.value('st_UseRemoteServer', GlobalSettings.st_UseRemoteServer)
    }

    // --- UI Actions and menus
    Action {
        id: executeaction
        text: qsTr('&Execute')
        shortcut: StandardKey.Refresh
        onTriggered: dialog.open()
    }
    Action {
        id: stopaction
        text: qsTr('&Halt Execution')
        shortcut: StandardKey.Cancel
        onTriggered: { console.log('Execution halted!') }
    }
    Action {
        id: reconfigureaction
        text: qsTr('Reconfigure system')
        onTriggered: {
            settings.sync()
            maintext.text = getNewSettings()
            console.log('System reconfigured!')
        }
    }
    Action {
        id: optionaction
        text: qsTr('Execution &Option')
        checkable: true
        checked: true
        onTriggered: reconfigureaction.trigger()
    }
    Action {
        id: preferencesaction
        text: qsTr('&Preferences...')
        shortcut: StandardKey.Preferences
        onTriggered: { preferences.show(); preferences.raise(); preferences.requestActivate() }
    }
    Action {
        id: quitaction
        text: qsTr('&Quit')
        shortcut: StandardKey.Quit
        onTriggered: mainwindow.close()
    }

    Shortcut {
        sequence: StandardKey.Close
        onActivated: mainwindow.close()
    }

    QtPl.MenuBar {
        QtPl.Menu {
            title: qsTr('&Main')
            QtPl.MenuItem { text: executeaction.text; shortcut: executeaction.shortcut; onTriggered: executeaction.trigger() }
            QtPl.MenuItem { text: stopaction.text; shortcut: stopaction.shortcut; onTriggered: stopaction.trigger() }
            QtPl.MenuSeparator {}
            QtPl.MenuItem { text: optionaction.text; shortcut: optionaction.shortcut; checkable: optionaction.checkable; checked: optionaction.checked; onTriggered: optionaction.trigger() }
            QtPl.MenuItem { text: preferencesaction.text; shortcut: preferencesaction.shortcut; onTriggered: preferencesaction.trigger() }
            QtPl.MenuSeparator {}
            QtPl.MenuItem { text: quitaction.text; shortcut: quitaction.shortcut; onTriggered: quitaction.trigger() }
        }
    }

    QtPl.MessageDialog {
        id: dialog
        buttons: (QtPl.MessageDialog.Ok | QtPl.MessageDialog.Cancel)
        text: 'Dialog'
        informativeText: 'Action executed!'
    }

    Preferences {
        id: preferences
        reconfigureAction: reconfigureaction
        visible: false
    }


    Text {
        id: maintext
        text: ""
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        anchors.fill: parent
        anchors.margins: Constants.padding
        font.pointSize: 24
        font.bold: false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log(getNewSettings())
            }
        }
    }

}
