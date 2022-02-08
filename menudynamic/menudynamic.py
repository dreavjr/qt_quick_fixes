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
import re
import sys
from pathlib import Path
from PySide6.QtCore import QObject, QSysInfo, Qt, Slot
from PySide6.QtGui import QKeySequence
from PySide6.QtQml import QQmlApplicationEngine, QmlElement, QmlSingleton
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication

QML_IMPORT_NAME = 'frompython.keysequences'
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
@QmlSingleton
class KeySeqs(QObject):
    '''This object bridges the UI functionality and the backend engine.'''

    @Slot(int, result=str)
    @Slot(str, result=str)
    def get(self, sequence):
        if isinstance(sequence, int):
            sequence = QKeySequence.StandardKey(sequence)
        seq = QKeySequence(sequence)
        portable = seq.toString(QKeySequence.SequenceFormat.PortableText)
        native = seq.toString(QKeySequence.SequenceFormat.NativeText)
        print(sequence, seq, f'"{portable}"', f'"{native}"')
        return native

    @Slot(int, result=str)
    @Slot(str, result=str)
    def inMenu(self, sequence):
        if isinstance(sequence, str) and sequence=='':
            return ''
        shortcut_text = self.get(sequence)
        if shortcut_text == '':
            return ''
        return  f' <i>{shortcut_text}</i>'

SEQUENCE_GETTER_DEF = 'KeySeqs'

def openUTF8Resource(resourcePath, lines=False):
    with open(resourcePath, 'rt', encoding='utf-8') as resourceFile:
        resource = resourceFile.readlines() if lines else resourceFile.read()
    return resource

def qmlProcessMenu(menuSource, platform, platformPrefix='QtPl.', qtPrefix='', sequenceGetter=SEQUENCE_GETTER_DEF):
    '''Processes menu source, using or not platform version.'''
    if platform:
        menuSource = re.sub(r'action:\s*([A-Za-z0-9_]+)',
                            r'QtPl.MenuItem { text: \1.text; shortcut: \1.shortcut; checkable: \1.checkable; '
                            r'checked: \1.checked; enabled: \1.enabled; onTriggered: \1.trigger() }', menuSource)
        importPrefix = platformPrefix
        menuElement = 'Menu'
        openFunction = 'open'
    else:
        if sequenceGetter:
            replacement  = r'MenuItem { text: \1.text + '
            replacement += sequenceGetter + r'.inMenu(\1.shortcut ? \1.shortcut  : ""); action: \1 }'
        else:
            replacement = r'MenuItem { action: \1 }'
        menuSource = re.sub(r'action:\s*([A-Za-z0-9_]+)', replacement, menuSource)
        importPrefix = qtPrefix
        menuElement = 'MenuFit'
        openFunction = 'popup'
    menuSource = re.sub(r'^\s*@\.', importPrefix, menuSource, flags=re.MULTILINE)
    menuSource = re.sub(r'<Menu>', menuElement, menuSource)
    menuSource = re.sub(r'{([\t ]*\n)*[\t ]*', '{ ', menuSource)
    menuSource = re.sub(r'}([\t ]*\n)*[\t ]*', '} ', menuSource)
    menuSource = re.sub(r'([\t ]*\n)+[\t ]*', '; ', menuSource)
    return menuSource, openFunction

def qmlTranslateAllMenus(qmlSource, menuPathPrefix, platform, sequenceGetter=SEQUENCE_GETTER_DEF):
    for menuType in ('menubar', 'menucontext',):
        qmlMenuPath = menuPathPrefix + f'-{menuType}.qml'
        qmlMenuSource = openUTF8Resource(qmlMenuPath)
        qmlMenuSource, openFunction = qmlProcessMenu(qmlMenuSource, platform=platform, sequenceGetter=sequenceGetter)
        if menuType == 'menubar' and not platform:
            qmlMenuSource = f'menuBar: {qmlMenuSource}'
        qmlSource = qmlSource.replace(f'//<<<application_{menuType}>>>//', qmlMenuSource)
        qmlSource = qmlSource.replace(f'application_{menuType}_open_function', openFunction)
    return qmlSource


if __name__ == '__main__':
    platform = '' if len(sys.argv) <=1 else sys.argv[1]
    if platform == '-h' or platform == '--help':
        print('usage: python menudynamic.py [macos|win10|generic]', file=sys.stderr)
        sys.exit(1)

    PLATFORM_SYSTEM = QSysInfo.kernelType()
    PLATFORM_VERSION = QSysInfo.kernelType()
    PLATFORM_MACOS = platform == 'macos' or (platform =='' and PLATFORM_SYSTEM == 'darwin')
    PLATFORM_WIN10 = platform == 'win10' or (platform =='' and (PLATFORM_SYSTEM == 'winnt' and PLATFORM_VERSION >= '10.'))
    PLATFORM_MENUS = PLATFORM_MACOS or PLATFORM_WIN10
    CONTROLS_THEME = 'Material' if PLATFORM_MACOS else 'Universal'

    app = QApplication(sys.argv)
    QQuickStyle.setStyle(CONTROLS_THEME)
    engine = QQmlApplicationEngine()
    if not PLATFORM_MACOS:
        app.setAttribute(Qt.AA_DontShowShortcutsInContextMenus, on=False)

    applicationPath = Path(__file__).resolve(strict=True)
    rootContext = engine.rootContext()
    rootContext.setContextProperty('CONTROLS_THEME', CONTROLS_THEME)

    # opens the QML source and applies necessary translations
    # applicationPath = Path(__file__).resolve(strict=True)
    qmlPath = applicationPath.with_suffix('.qml')
    qmlSource = openUTF8Resource(qmlPath)
    qmlSource = qmlTranslateAllMenus(qmlSource, str(applicationPath.with_suffix('')), platform=PLATFORM_MENUS)

    # print('-----')
    # print(qmlSource)
    # print('-----')

    # loads the QML engine
    engine.loadData(qmlSource.encode(), url=qmlPath.as_uri())

    rootObjects = engine.rootObjects()
    if not rootObjects:
        sys.exit(-1)

    sys.exit(app.exec())
