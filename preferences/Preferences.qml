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
import QtQuick.Controls 6.2
import QtQuick.Layouts 6.2
import QtQuick.Window 6.2
import Qt.labs.settings 6.2


Window {
    id: preferenceswindow
    flags: (Qt.Window | Qt.Dialog)
    visible: true

    // Those layout options resize the window automatically with the contents, and disable resizing by user
    readonly property real targetWidth: (alloptions.width + 2*Constants.padding)
    readonly property real targetHeight: (alloptions.height + 2*Constants.padding)
    width: targetWidth
    height: targetHeight
    minimumWidth: targetWidth
    minimumHeight: targetHeight
    maximumWidth: targetWidth
    maximumHeight: targetHeight

    // --- Window state persistence
    Settings {
        category: 'preferenceswindow'
        property alias x: preferenceswindow.x
        property alias y: preferenceswindow.y
    }

    // --- Settings - Persistence
    Settings {
        id: internals
        category: 'settings_internals'
        // >>> Update this section by hand before compiling the settings
        property alias st_MaximumSize: maximumsize.currentIndex
        property alias st_UseRemoteServer: useremoteserver.checkState
        // <<<

        // >>> Update this section from the file reset.tmp.qml after compiling the settings
        function reset() {
            console.debug('--')
            st_MaximumSize = GlobalSettings.internals_st_MaximumSize
            st_UseRemoteServer = GlobalSettings.internals_st_UseRemoteServer
            // INSERT CUSTOM CODE HERE !
            internals.sync()
            settings.sync()
        }
        // <<<
    }


    // --- Settings - Global UI-Independent Values
    Settings {
        id: settings
        category: 'settings'
        // >>> Update this section by hand before compiling the settings
        readonly property int  st_MaximumSize: maximumsize.currentValue
        readonly property bool st_UseRemoteServer: useremoteserver.checkState === Qt.Checked
        // <<<
    }

    property var allSettingsNames: ''
    property string allSettings: ''
    property bool allSettingsHaveChanged: false
    function findSettings() {
        let names = []
        for (let property in settings) {
            if (property.startsWith('st_') && !property.endsWith('Changed')) {
                names.push(property)
            }
        }
        names.sort()
        console.debug('listSettings', names)
        allSettingsNames = names
    }
    function getSettingsValues() {
        let values = JSON.stringify(allSettingsNames.map(n => settings[n]))
        console.debug('getSettingsValues', values)
        return values
    }
    function connectSettings() {
        allSettingsNames.forEach(n => {
            settings[n + 'Changed'].connect(checkSettings)
        })
    }
    function registerSettings() {
            allSettings = getSettingsValues()
            allSettingsHaveChanged = false
            console.debug('-- settings registered:', allSettings)
    }
    function checkSettings() {
            allSettingsHaveChanged = getSettingsValues() !== allSettings
    }

    property bool preferenceswindowReady: false
    onAfterAnimating: {
        if (!preferenceswindowReady) {
            console.debug('>> preferences ready')
            preferenceswindowReady = true
            findSettings()
            registerSettings()
            connectSettings()
            console.debug('<< preferences ready')
        }
    }

    // --- Action from main window to trigger when applying the new settings
    property var reconfigureAction: null

    // --- Shortcut for closing the window with standard key sequences
    Shortcut {
        sequence: StandardKey.Close
        onActivated: preferenceswindow.close()
    }

    // --- Theme-compatible background-pane
    Pane {
        anchors.fill: parent
    }

    // >>>>> AI options
    ColumnLayout {
        id: alloptions
        x: Constants.padding
        y: Constants.padding
        spacing: Constants.spacing

        GroupBox {
            title: qsTr('Execution options:')
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: Constants.spacing

                // -- Maximum image size
                RowLayout {
                    spacing: Constants.spacing
                    Label {
                        text: qsTr('Maximum size:')
                    }
                    ComboBox {
                        id: maximumsize
                        implicitContentWidthPolicy: ComboBox.WidestText
                        currentIndex: 1
                        textRole: 'label'
                        valueRole: 'value'
                        model: [
                                { label: '512',  value: 512 },
                                { label: '1024', value: 1024 },
                                { label: '2048', value: 2048 },
                                { label: qsTr('no limit'), value: 0 },
                            ]
                    }
                }
                Text {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0
                    wrapMode: Text.Wrap
                    text: qsTr('unlimited size will affect the speed of the system and may result in out-of-memory errors')
                    color: this.Material.color(this.Material.Red)
                    visible: maximumsize.currentValue == 0
                }

                CheckBox {
                    id: useremoteserver
                    text: qsTr('Use remote server')
                }
                Text {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 0
                    wrapMode: Text.Wrap
                    text: qsTr('remote server allows processing larger batches, but may be less reliable and may be slower for smaller tasks — uncheck if you experience tasks that fail to finish')
                    color: this.Material.color(this.Material.Red)
                    visible: useremoteserver.checkState === Qt.Checked
                }

            }
        }

        // ----- Reset all options
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: buttonlayout.height
            Layout.minimumWidth: buttonlayout.width
            color: 'transparent'
            RowLayout {
                id: buttonlayout
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                spacing: Constants.spacing
                Button {
                    id: resetbutton
                    text: qsTr('Reset to defaults')
                    Layout.alignment: (Qt.AlignBottom | Qt.AlignLeft)
                    onClicked: internals.reset()
                }
                Button {
                    id: reloadbutton
                    text: qsTr('Apply new settings')
                    Layout.alignment: (Qt.AlignBottom | Qt.AlignLeft)
                    visible: allSettingsHaveChanged
                    enabled: (reconfigureAction ? reconfigureAction.enabled : true)
                    onClicked: {
                        if (reconfigureAction) {
                            reconfigureAction.trigger()
                        }
                        registerSettings()
                    }
                }
            }
        }

    }
}
