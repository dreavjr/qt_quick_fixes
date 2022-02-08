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
import functools
from pathlib import Path
from PySide6.QtCore import QObject
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication


def destroyed(who):
    print(f'-- {who} destroyed')

app = QApplication(sys.argv)
app.destroyed.connect(functools.partial(destroyed, 'app'))

class EventInspector(QObject):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # This is not necessary for the solution, but makes the issue with premature garbage collection visible
        self.destroyed.connect(functools.partial(destroyed, 'eventinspector'))

    def eventFilter(self, obj, event):
        # print('obj >>', obj, 'event >>', event, 'type >>', event.type())
        print('event type >>', event.type())
        return super().eventFilter(obj, event)

# [Bug QT 6.22?] The filter has to be instantiated on a separate variable, passing it directly as a parameter results in
#  it being garbage-collected. Thanks to User:@JonB on Qt Forum for this diagnostic and fix
eventinspector = EventInspector()
app.installEventFilter(eventinspector)

# This doesn't work and usually fails completely silently
# app.installEventFilter(EventInspector())


if __name__ == '__main__':

    engine = QQmlApplicationEngine()
    qml_path = Path(__file__)
    qml_file = qml_path.with_suffix('.qml')
    engine.load(qml_file)
    root_objects = engine.rootObjects()
    if not root_objects:
        sys.exit(-1)

    # mainwindow = root_objects[0]
    print('>> exec')
    result = app.exec()
    print('<< exec')
    sys.exit(result)
