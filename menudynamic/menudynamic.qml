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
import QtQuick.Window 6.2
import QtQuick.Controls 6.2
import Qt.labs.platform as QtPl

import frompython.keysequences 1.0


ApplicationWindow {
    id: mainwindow
    title: 'Application'
    width: 800
    height: 400
    visible: true

    Action {
        id: executeaction
        text: 'Run!'
        onTriggered: rundialog.open()
        shortcut: 'Return'
    }
    Action {
        id: stopaction
        text: qsTr('Sto&p run')
        enabled: false
        shortcut: StandardKey.Cancel
        onTriggered: console.log(this.text)
    }
    Action {
        id: immediateaction
        text: qsTr('Run soon after open')
        checkable: true
        checked: true
        onTriggered: console.log(this.text)
    }
    Action {
        id: copyaction
        text: qsTr('&Copy')
        shortcut: StandardKey.Copy
        onTriggered: console.log(this.text)
    }
    Action {
        id: pasteaction
        text: qsTr('&Paste')
        shortcut: StandardKey.Paste
        onTriggered: console.log(this.text)
    }
    Action {
        id: openaction
        text: qsTr('&Open...')
        shortcut: StandardKey.Open
        onTriggered: console.log(this.text)
    }
    Action {
        id: saveaction
        text: qsTr('&Save As...')
        shortcut: StandardKey.Save
        onTriggered: console.log(this.text)
    }
    Action {
        id: preferencesaction
        text: qsTr('&Preferences...')
        shortcut: StandardKey.Preferences
        onTriggered: console.log(this.text)
    }
    Action {
        id: quitaction
        text: qsTr('&Quit')
        shortcut: StandardKey.Quit
        onTriggered: { console.log(this.text); mainwindow.close() }
    }
    Action {
        id: aboutaction
        text: qsTr('&About...')
        onTriggered: console.log(this.text)
    }

    //<<<application_menubar>>>//

    //<<<application_menucontext>>>//


    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                menucontext.application_menucontext_open_function()
            }
        }

        onDoubleClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                executeaction.trigger()
            }
        }
    }

    QtPl.MessageDialog {
        id: rundialog
        buttons: QtPl.MessageDialog.Ok
        text: 'Dialog'
        informativeText: 'Run finished ok!'
    }

}
