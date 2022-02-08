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


ApplicationWindow {
    title: 'Application'
    width: 800
    height: 400
    visible: true

    Action {
        id: executeaction
        text: 'Execute'
        enabled: enableaction.checked
        onTriggered: dialog.open()
    }
    Action {
        id: enableaction
        text: 'Execution enabled'
        checkable: true
        checked: true
    }
    Action {
        id: saveaction
        text: '&Save As...'
        shortcut: StandardKey.Save
        onTriggered: console.log('saved!')
    }

    Menu {
        id: contextmenu
        MenuItem { action: executeaction }
        MenuItem { action: enableaction }
        MenuSeparator {}
        MenuItem { action: saveaction }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                contextmenu.popup()
            }
        }

        onDoubleClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                // Actions may be used to "centralize" when / where / how a certain command is executed
                // This reduces code redundancies and minimizes mistakes...
                executeaction.trigger()
                // ...the code above is equivalent to the redundant and more verbose:
                // if (enableaction.checked) {
                //     dialog.open()
                // }
            }
        }
    }

    QtPl.MessageDialog {
        id: dialog
        buttons: (QtPl.MessageDialog.Ok | QtPl.MessageDialog.Cancel)
        text: 'Dialog'
        informativeText: 'Action executed!'
    }
}
