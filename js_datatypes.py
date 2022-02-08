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
import json
import sys
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtQml import QmlElement, QQmlApplicationEngine
from PySide6.QtWidgets import QApplication


QML_IMPORT_NAME = 'frompython.bridge'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class Bridge(QObject):
    '''This object bridges the UI functionality and the backend engine.'''

    @Slot(QObject)
    def showQObject(self, obj):
        print('-- object:', obj)

    @Slot(list)
    def showList(self, lst):
        print('-- list:', lst)

    # Wrong! Results in a type error as JS Object cannot be converted into Python object via C++ function
    @Slot(object)
    def showJSObject1(self, obj):
        print('-- object:', obj)

    # Wrong! Results in a type error as JS Object cannot be converted into Python object via C++ function
    @Slot(dict)
    def showJSObject2(self, obj):
        print('-- object:', obj)

    # Workaround: put object inside list
    @Slot(list)
    def showJSObject3(self, obj):
        print('-- list: %s' % obj)
        print('   object: %s' % (obj[0] if obj else 'error! empty list!'))

    # Workaround: serialize the object in QML and deserialize in Python
    @Slot(str)
    def showJSObject4(self, obj):
        print('-- string: "%s"' % obj)
        print('   object: %s' % json.loads(obj))


if __name__ == '__main__':
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_path = Path(__file__)
    qml_file = qml_path.with_suffix('.qml')
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
