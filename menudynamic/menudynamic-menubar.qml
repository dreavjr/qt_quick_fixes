@.MenuBar {
    id: menubar
    @.<Menu> {
        title: qsTr('&File')
        action: openaction
        action: saveaction
        @.MenuSeparator{}
        action: quitaction
    }
    @.<Menu> {
        title: qsTr('&Edit')
        action: copyaction
        action: pasteaction
    }
    @.<Menu> {
        title: qsTr('&Execute')
        action: executeaction
        action: stopaction
        @.MenuSeparator{}
        action: immediateaction
        action: preferencesaction
    }
    @.<Menu> {
        title: qsTr('&Help')
        action: aboutaction
    }
}
