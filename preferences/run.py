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
import atexit
import random
import sys
from pathlib import Path
from PySide6.QtCore import QSettings
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication


compileSettings = len(sys.argv) > 1 and sys.argv[1] == '--compile'

appName = 'Preferences-Compile-' +str(random.randint(0, 10000000)) if compileSettings else 'Preferences-Demo'

app = QApplication(sys.argv)
app.setOrganizationName('eduardovalle.com')
app.setOrganizationDomain('tests.eduardovalle.com')
app.setApplicationName(appName)
app.setApplicationVersion('0.1')

settings = QSettings()
settingsPath = settings.fileName()
settingsFirstExecution = 'firstExecutionCompleted'

if settings.value(f'settings_internals/{settingsFirstExecution}', False):
    if compileSettings:
        print(f'ERROR: settings active for {appName} in {settingsPath}', file=sys.stderr)
        sys.exit(1)
    else:
        print(f'WARNING: there are persistent settings for {appName} in {settingsPath}', file=sys.stderr)

if compileSettings:
    def clearSettings():
        if Path(settingsPath).exists():
            print('ATTENTION! remember to delete the settings in the path below:')
            print(settingsPath)
    atexit.register(clearSettings)


if __name__ == '__main__':
    QQuickStyle.setStyle('Material')
    engine = QQmlApplicationEngine()

    rootContext = engine.rootContext()
    rootContext.setContextProperty('COMPILE_SETTINGS', compileSettings)

    applicationDir = Path(__file__).parent
    if compileSettings:
        qml_path = applicationDir / 'Preferences.qml'
    else:
        qml_path = applicationDir / 'Main.qml'

    engine.load(qml_path)
    if not engine.rootObjects():
        sys.exit(-1)
    result = app.exec()

    if result != 0:
        print('ERROR: program exitted with code:', result)
        sys.exit(result)

    settings.setValue(f'settings_internals/{settingsFirstExecution}', True)

    if compileSettings:
        def getTypeAndRepr(value):
            if isinstance(value, str):
                return 'string', value.__repr__()
            elif isinstance(value, list):
                return 'list', value.__repr__()
            elif isinstance(value, bool):
                return 'bool', str(value).lower()
            elif isinstance(value, int):
                return 'int', str(value)
            elif isinstance(value, float):
                return 'double', str(value)
            else:
                return 'var', value.__repr__()

        globalPath = applicationDir / 'GlobalSettings.qml'
        with open(globalPath, mode='wt', encoding='utf-8') as genFile:
            print('pragma Singleton', file=genFile)
            print('import QtQuick', file=genFile)
            print('', file=genFile)
            print('// THIS FILE WAS GENERATED AUTOMATICALLY:', file=genFile)
            print(f'// python {Path(__file__).name} --compile', file=genFile)
            print('', file=genFile)
            print('QtObject {', file=genFile)
            settings.beginGroup('settings_internals')
            for n in sorted(settings.childKeys()):
                if n == settingsFirstExecution:
                    continue
                v = settings.value(n)
                t, r = getTypeAndRepr(v)
                print('    readonly property %s internals_%s: %s' % (t, n, r), file=genFile)
            settings.endGroup()
            print('', file=genFile)
            settings.beginGroup('settings')
            for n in sorted(settings.childKeys()):
                v = settings.value(n)
                t, r = getTypeAndRepr(v)
                print('    readonly property %s %s: %s' % (t, n, r), file=genFile)
            settings.endGroup()
            print('}', file=genFile)

        resetPath = applicationDir / 'reset.tmp.qml'
        with open(resetPath, mode='wt', encoding='utf-8') as genFile:
            print('// THIS FILE WAS GENERATED AUTOMATICALLY:', file=genFile)
            print(f'// python {Path(__file__).name} --compile', file=genFile)
            print('function reset() {', file=genFile)
            print("    console.debug('--')", file=genFile)
            settings.beginGroup('settings_internals')
            for n in sorted(settings.childKeys()):
                if n == settingsFirstExecution:
                    continue
                print('    %s = GlobalSettings.internals_%s' % (n, n), file=genFile)
            settings.endGroup()
            print('    // INSERT CUSTOM CODE HERE !', file=genFile)
            print('    internals.sync()', file=genFile)
            print('    settings.sync()', file=genFile)
            print('}', file=genFile)

        settings.clear()
