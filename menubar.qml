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
// import QtQuick.Controls 1.2 as QtCt1

import Qt.labs.platform as QtPl


ApplicationWindow {
    title: 'Application'
    width: 800
    height: 400
    visible: true

    Action {
        id: executeaction
        text: 'Execute'
        onTriggered: dialog.open()
    }
    Action {
        id: saveaction
        text: '&Save As...'
        shortcut: StandardKey.Save
        onTriggered: console.log('saved!')
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr('&Main')
            MenuItem { action: executeaction }
            MenuSeparator {}
            MenuItem { action: saveaction }
        }
    }

    // As of Qt 6.22 the action property is not available on platform menus, this is an workaround:
    // QtPl.MenuBar {
    //     QtPl.Menu {
    //         title: qsTr('&Main')
    //         QtPl.MenuItem { text: executeaction.text; shortcut: executeaction.shortcut; onTriggered: executeaction.trigger() }
    //         QtPl.MenuSeparator {}
    //         QtPl.MenuItem { text: saveaction.text; shortcut: saveaction.shortcut; onTriggered: saveaction.trigger() }
    //     }
    // }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onDoubleClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                dialog.open()
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
