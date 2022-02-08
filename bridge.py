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
from pathlib import Path
from PySide6.QtCore import QObject, Property, Signal, Slot
from PySide6.QtQml import QmlElement, QmlSingleton, QQmlApplicationEngine
from PySide6.QtWidgets import QApplication


QML_IMPORT_NAME = 'frompython.bridge'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class Bridge(QObject):
    '''This object bridges the UI functionality and the backend engine.'''

    def __init__(self, *args, **kwargs):
        super().__init__(*args, *kwargs)
        self._amount = 0

    amount_changed = Signal(name='amountChanged')

    def amount_get(self):
        return self._amount

    def amount_set(self, new_amount):
        self._amount = new_amount
        self.amount_changed.emit()

    amount = Property(int, amount_get, amount_set, notify=amount_changed)

    @Slot()
    def increase(self):
        # Actual functionality:
        self.amount += 1
        # Debug info:
        print('-- increase', self.amount, self.parent().children())
        self.parent().dumpObjectTree()


# The import names / versions are arbitrary and will work as long as they match in the QML file
# If desired  different elements may grouped under different import names
QML_IMPORT_NAME = 'another.arbitrary.name'
QML_IMPORT_MAJOR_VERSION = 17
QML_IMPORT_MINOR_VERSION = 31

@QmlElement
@QmlSingleton
class PythonInfo(QObject):

    @Property(str, constant=True)
    def version(self):
        return sys.version


if __name__ == '__main__':
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()
    qml_path = Path(__file__)
    qml_file = qml_path.with_suffix('.qml')
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
