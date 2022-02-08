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
import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.1
import QtQuick.Window 2.1
import QtQuick.Controls.Material 2.1

import frompython.bridge 1.0


ApplicationWindow {
    id: page
    width: 800
    height: 400
    visible: true
    title: "Image Viewer"
    Material.theme: Material.Dark
    Material.accent: Material.Red

    Bridge {
        id: bridge
    }

    DropArea {
        anchors.fill: parent

        onEntered: drag => { // DragEvent drag
            // drag.accept(Qt.CopyAction);
            // drag.accept(bridge.checkDropMimeTypes(drag.formats, drag.hasUrls))
            console.log(">>> onEntered")
            console.log(drag.urls)
            drag.accept(bridge.checkDropUrls(drag.urls) ? Qt.CopyAction : Qt.IgnoreAction)
            console.log("onEntered <<<")
        }

        onPositionChanged: drag => { // DragEvent drag
            // console.log("onPositionChanged")
            // console.log(">>> onPositionChanged")
            // console.log(drag.urls)
            drag.accept(bridge.checkDropUrls(drag.urls) ? Qt.CopyAction : Qt.IgnoreAction)
            // console.log("onPositionChanged <<<")
        }

        onDropped: drop => { // DragEvent drop
            console.log("onDropped")
            let image_file = bridge.checkDropUrls(drop.urls)
            if (image_file) {
                image_view.source = image_file
                drop.accept()
            }
        }

        Image {
            id: image_view
            objectName: "image_view"
            source: "placeholder.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit

        }
    }

}
