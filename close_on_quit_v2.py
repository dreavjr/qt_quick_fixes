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
from PySide6.QtCore import QObject, QEvent, Slot
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QGuiApplication


if __name__ == '__main__':
    app = QApplication(sys.argv)

    # ---> Not necessary for the solution, included for illustration/debug purposes
    @Slot()
    def about_to_quit():
        print('-- about_to_quit')
    app.aboutToQuit.connect(about_to_quit)
    # <---

    engine = QQmlApplicationEngine()
    qml_path = Path(__file__)
    qml_file = qml_path.with_suffix('.qml')
    engine.load(qml_file)
    root_objects = engine.rootObjects()
    if not root_objects:
        sys.exit(-1)

    sys.exit(app.exec())
