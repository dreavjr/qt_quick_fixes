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

import frompython.bridge 1.0


ApplicationWindow {
    id: mainwindow
    title: 'Application'
    width: 800
    height: 400
    visible: true

    Bridge {
        id: bridge
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            let lst = [1, 2, 3]
            let obj = {'key1' : 'value1', 'key2' : 'value2'}
            console.debug(lst, typeof lst, obj, typeof obj)
            bridge.showQObject(this)
            // bridge.showQObject(obj)
            // TypeError: Passing incompatible arguments to C++ functions from JavaScript is not allowed
            bridge.showList(lst)
            // bridge.showJSObject1(obj)
            // TypeError: Passing incompatible arguments to C++ functions from JavaScript is not allowed
            // bridge.showJSObject2(obj)
            // TypeError: Passing incompatible arguments to C++ functions from JavaScript is not allowed
            bridge.showJSObject3(obj)   // Wrong! This arrives as an empty list!
            bridge.showJSObject3([obj]) // The right workaround is passing the object _inside_ a list
            bridge.showJSObject4(JSON.stringify(obj)) // Another workaround: put object inside a string
        }

        Text {
            text: 'Click to show datatypes in console!'
            anchors.centerIn: parent
            font.pointSize: 24
            font.bold: false
        }
    }

}

