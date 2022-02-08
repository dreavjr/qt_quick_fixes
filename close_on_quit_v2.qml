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
import Qt.labs.platform


ApplicationWindow {
    id: mainwindow
    title: 'Application'
    width: 800
    height: 400
    visible: true

    property bool closing_confirmed: false

    onClosing: close => {
        console.debug('-- onClosing', 'mainwindow.closing_confirmed =', mainwindow.closing_confirmed)
        if (!mainwindow.closing_confirmed) {
            close.accepted = false
            closedialog.open()
        }

    }

    // Solves the issue of QApplication quitting without querying the main
    // window about closing when pressing cmd+Q on macOS
    MenuBar {
        id: menubar
        Menu {
            title: ''
            MenuItem {
                id: quitaction
                text: qsTr('&Quit')
                shortcut: StandardKey.Quit
                onTriggered: mainwindow.close()
            }
        }
    }

    MessageDialog {
        id: closedialog
        buttons: (MessageDialog.Yes | MessageDialog.No)
        text: 'Confirm Quit?'
        informativeText: 'Are you sure you want to quit?'
        onYesClicked: function() {
            mainwindow.closing_confirmed = true
            mainwindow.close()
        }
    }

}
