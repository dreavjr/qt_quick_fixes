# ======================================================================================================================
# Copyright 2022 Eduardo Valle
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# The Software is provided "as is", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, including but not limited to the
# warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or
# copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or
# otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
# ======================================================================================================================
import sys
from pathlib import PurePath, Path

from PySide6.QtCore import Qt, QObject, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle

import style_rc


QML_IMPORT_NAME = "frompython.bridge"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
class Bridge(QObject):
    pass

    accepted_suffixes = {'.png', '.jpg', '.jpeg', '.bmp', '.gif', '.jp2', '.jpg2','.j2k', '.jpf',
                         '.jpx', '.pbm', '.pgm', '.ppm', '.pnm', '.pam', '.tif', '.tiff', '.webp'}

    @Slot(list, result=str)
    def checkDropUrls(self, urls):
        # print('bridge >>', urls)
        if len(urls) != 1:
            # More than one URL involved - reject
            return ''
        url = urls[0]
        if not url.isLocalFile:
            # The URL does not refer to a local file - reject
            return ''
        path = PurePath(url.toLocalFile())
        if path.suffix.lower() in self.accepted_suffixes:
            # The URL refers to a file with one of the accepted suffixes - accept...
           return str(path)
        # ...otherwise reject
        return ''


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()

    qml_file = Path(__file__).parent / 'view.qml'
    engine.load(qml_file)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
