import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.15
import QtMultimedia 5.12
import MainWindow 1.0


ApplicationWindow {
    id: mainWindow
    x: mainWindowModel.getMainWindowX()
    y: mainWindowModel.getMainWindowY()
    width: mainWindowModel.getMainWindowWidth()
    height: mainWindowModel.getMainWindowHeight()
    minimumWidth: 640
    minimumHeight: 480
    maximumWidth: 1024
    maximumHeight: 768
    visible: true
    visibility: mainWindowModel.getMainWindowMaximized() ? Window.Maximized : Window.Windowed
    title: qsTr("Linux Shutdown / Reboot System")

    onClosing: {
        quitDialog.open()

        close.accepted = false
    }

    CMainWindow {
        id: mainWindowModel;
    }

    Shortcut {
        sequence: "U"
        onActivated: {
            shutdownBtn.clicked()
        }
    }

    Shortcut {
        sequence: "R"
        onActivated: {
            rebootBtn.clicked()
        }
    }

    Shortcut {
        sequence: "Q"
        onActivated: {
            quitDialog.open()
        }
    }

    function saveMainWindowState() {
        let bMaximized = false
        if(visibility == Window.Maximized)
        {
            bMaximized = true;
        }
        mainWindowModel.setMainWindowState(x, y, width, height, bMaximized)
    }

    function enableUI() {
        menu.enabled = true
        shutdownBtn.enabled = true
        rebootBtn.enabled = true
        quitAppBtn.enabled = true
    }

    function disableUI() {
        menu.enabled = false
        shutdownBtn.enabled = false
        rebootBtn.enabled = false
        quitAppBtn.enabled = false
    }

//    property int iShutdownID: 0  // 0 : Shutdown, 1 : Reboot
//    Timer {
//        id: shutdownTimer
//        interval: 1000
//        repeat: false
//        running: false
//        triggeredOnStart: false

//        onTriggered: {
//            let password = mainWindowModel.getPassword()

//            let iError = 0;
//            if(iShutdownID == 0)
//            {
//                iError = mainWindowModel.onShutdown(password);
//            }
//            else
//            {
//                iError = mainWindowModel.onReboot(password);
//            }

//            if(iError === -1)
//            {
//                stateMessage = qsTr("Message of State will be displayed here...")
//                errorDialog.title = qsTr("Error")
//                errorDialogMessage.text = qsTr("Shutdown.wav file not found.\n") + qsTr("Or, The password has not been entered.\n")
//                errorDialog.open()
//            }
//        }
//    }

    // Result of Slot
    Connections {
        target: mainWindowModel
        function onResult() {
            enableUI()
        }
    }

    // MenuBar
    property int currentMainWindowWidth:  0
    property int currentMainWindowHeight: 0

    MenuBar {
        id: menu
        x: 0
        y: 0
        width: mainWindow.width

        // [File] Menu
        Menu {
            title: qsTr("&File(&F)")
            font.pixelSize: 16

            // [Save Password] SubMenu
//            Action {
//                text: "Save Password(&P)"
//                onTriggered: {
//                    passwordDialog.open();
//                }
//            }

            // [Quit] SubMenu
            Action {
                text: "Quit(&O)"
                onTriggered: {
                    quitDialog.open();
                }
            }
        }

        // [Help] Menu
        Menu {
            title: qsTr("&Help(&H)")
            font.pixelSize: 16

            // [about PoweroffQML] SubMenu
            Action {
                text: "about PoweroffQML(&A)"
                onTriggered: {
                    aboutDialog.open()
                }
            }

            // [about Qt] SubMenu
            Action {
                text: "about Qt(&t)"
                onTriggered: {
                    currentMainWindowWidth = mainWindow.width
                    currentMainWindowHeight = mainWindow.height

                    mainWindow.width = 1024
                    mainWindow.height = 768

                    aboutQtDialog.open()
                }
            }
        }
    }

    // MainWindow's Control
    ColumnLayout {
        x: 0
        y: menu.height
        width: mainWindow.width
        height: mainWindow.height - menu.height
        
        Label {
            text: "You can Shutdown / Reboot Linux"
            width: parent.availableWidth
            font.pointSize: 12

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            ColumnLayout.fillWidth: true
            ColumnLayout.fillHeight: true
        }

        RowLayout {
            x: 0
            width: mainWindow.width
            Layout.alignment: Qt.AlignHCenter
            scale: mainWindow.width / 480
            spacing: 20

            Button {
                id: shutdownBtn
                width: 200
                height: 35
                text: qsTr("Shutdown(&U)")

                Connections {
                    target: shutdownBtn
                    function onClicked() {
                        stateMessage.text = qsTr("It will be Shutdown your PC as soon.  Please wait a moments...\n") +
                                            qsTr("If it does not Shutdown, the password may be wrong.")

                        let bExistSoundFile = mainWindowModel.isExistSoundFile()
                        if(!bExistSoundFile)
                        {
                            stateMessage.text = qsTr("Message of State will be displayed here...\n")
                            errorDialog.title = qsTr("Error")
                            errorDialogMessage.text = qsTr("Shutdown.wav file not found.")
                            errorDialog.open()
                            return
                        }

                        saveMainWindowState()

                        disableUI()

                        mainWindowModel.start(0)  // 0 : Shutdown, 1 : Reboot
                    }
                }
            }

            Button {
                id: rebootBtn
                width: 200
                height: 35
                text: qsTr("Reboot(&R)")

                Connections {
                    target: rebootBtn
                    function onClicked() {
                        stateMessage.text = qsTr("It will be Reboot your PC as soon.  Please wait a moments...\n") +
                                            qsTr("If it does not Reboot, the password may be wrong.")

                        let bExistSoundFile = mainWindowModel.isExistSoundFile()
                        if(!bExistSoundFile)
                        {
                            stateMessage.text = qsTr("Message of State will be displayed here...\n")
                            errorDialog.title = qsTr("Error")
                            errorDialogMessage.text = qsTr("Shutdown.wav file not found.")
                            errorDialog.open()
                            return
                        }

                        saveMainWindowState()

                        disableUI()

                        mainWindowModel.start(1)  // 0 : Shutdown, 1 : Reboot
                    }
                }
            }
        }

        Label {
            id: stateMessage
            text: qsTr("Message of State will be displayed here...\n")
            width: parent.availableWidth

            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            ColumnLayout.fillWidth: true
            ColumnLayout.fillHeight: true
        }

        Button {
            id: quitAppBtn
            width: 200
            height: 30
            Layout.alignment: Qt.AlignRight
            text: qsTr("Quit(&Q)")
            ColumnLayout.bottomMargin: 20
            ColumnLayout.rightMargin: 20

            Connections {
                target: quitAppBtn
                function onClicked() {
                    quitDialog.open()
                }
            }
        }
    }

    Dialog {
        id: passwordDialog
        title: "Save Linux System Password"
        x: Math.round((mainWindow.width - width) / 2)
        y: Math.round(mainWindow.height / 6)
        width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 10 * 9)
        contentHeight: passwordColumn.height

        modal: true
        focus: true
        closePolicy: Dialog.CloseOnEscape

        ColumnLayout {
            id: passwordColumn
            x: parent.x
            width: parent.width
            spacing: 20

            TextField {
                id: passwordInput
                text: mainWindowModel.getPassword()
                width: passwordColumn.width
                Layout.alignment: Qt.AlignHCenter

                focus: true
                cursorVisible: true
                selectedTextColor: "#393939"
                horizontalAlignment: Text.AlignRight

                echoMode: TextInput.Password
                passwordMaskDelay: 2000
            }

            RowLayout {
                x: 0
                width: passwordColumn.width
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    id: savePasswordBtn
                    text: "Save"
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 10

                    Connections {
                        target: savePasswordBtn
                        function onClicked() {
                            let iError = mainWindowModel.savePassword(passwordInput.text)
                            if(iError === -1)
                            {
                                errorDialog.title = qsTr("File Error")
                                errorDialogMessage.text = qsTr("error occurred while saving the password.\n")
                                errorDialog.open()
                            }
                        }
                    }
                }

                Button {
                    id: closePasswordDialogBtn
                    text: "Close"
                    Layout.alignment: Qt.AlignRight
                    Layout.bottomMargin: 10

                    Connections {
                        target: closePasswordDialogBtn
                        function onClicked() {
                            passwordDialog.close()
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: errorDialog
        title: ""
        x: Math.round((mainWindow.width - width) / 2)
        y: Math.round(mainWindow.height / 6)
        width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 10 * 9)
        contentHeight: errorColumn.height

        modal: true
        focus: true

        ColumnLayout {
            id: errorColumn
            x: parent.x
            width: parent.width
            spacing: 20

            Label {
                id: errorDialogMessage
                text: ""
                width: errorDialog.availableWidth

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                ColumnLayout.fillWidth: true
                ColumnLayout.fillHeight: true
            }

            Button {
                id: errorDialogBtn
                text: "OK"

                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10

                Connections {
                    target: errorDialogBtn
                    function onClicked() {
                        errorDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: aboutDialog
        title: "about PoweroffQML"
        x: Math.round((mainWindow.width - width) / 2)
        y: Math.round(mainWindow.height / 6)
        width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 10 * 9)
        contentHeight: aboutColumn.height

        modal: true
        focus: true
        closePolicy: Dialog.CloseOnEscape

        ColumnLayout {
            id: aboutColumn
            x: parent.x
            width: parent.width
            spacing: 20

            Image {
                source: "PoweroffQML.svg"
                ColumnLayout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
            }

            Label {
                text: "PoweroffQML" + "\t" + mainWindowModel.getVersion()
                width: parent.availableWidth

                font.pointSize: 12

                textFormat: Label.RichText
                wrapMode: Label.WordWrap

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 10
            }

            Label {
                id: labelLink
                text: "PoweroffQML developed by Presire" + "<br><br>" +
                      "<a href=\"https://github.com/presire\">Visit Prersire Github</a>"
                width: aboutDialog.availableWidth
                textFormat: "RichText"

                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                ColumnLayout.fillWidth: true
                ColumnLayout.fillHeight: true

                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        labelLink.linkActivated("https://github.com/presire")
                    }
                }
            }

            Button {
                id: aboutDialogButton
                text: "Close"

                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20

                Connections {
                    target: aboutDialogButton
                    function onClicked() {
                        aboutDialog.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: aboutQtDialog
        title: "about Qt"
        x: 0
        y: 0
        width: 1024
        height: 768

        modal: true
        focus: true
        closePolicy: Dialog.CloseOnEscape

        onClosed: {
            mainWindow.width = currentMainWindowWidth
            mainWindow.height = currentMainWindowHeight
        }

        ScrollView {
            anchors.fill: parent

            ColumnLayout {
                id: aboutQtColumn
                x: parent.x
                width: parent.width
                spacing: 20

                RowLayout {
                    id: aboutQtRow
                    x: parent.x
                    width: parent.width
                    spacing: 20
                    ColumnLayout.topMargin: 10
                    ColumnLayout.rightMargin: 20
                    ColumnLayout.leftMargin: 20
                    ColumnLayout.bottomMargin: 20

                    Image {
                        source: "Qt.svg"
                        ColumnLayout.alignment: Qt.AlignTop
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: aboutQtLabel
                        textFormat: Label.RichText
                        text: "<html><head/><body><p><h2>About Qt</h2><br> \
                               <br> \
                               This program uses Qt version 5.15.2.<br>
                               Qt is a C++ toolkit for cross-platform application development.<br>
                               Qt provides single-source portability across all major desktop operating systems.<br>
                               It is also available for embedded Linux and other embedded and <br>
                               mobile operating systems.<br>
                               <br>
                               Qt is available under multiple licensing options designed to accommodate the needs <br>
                               of our various users.<br>
                               <br>
                               Qt licensed under our commercial license agreement is appropriate for development <br>
                               of proprietary/commercial software where you do not want to share any source code <br>
                               with third parties or otherwise cannot comply with the terms of GNU (L)GPL.<br>
                               <br>
                               Qt licensed under GNU (L)GPL is appropriate for the development of Qt applications <br>
                               provided you can comply with the terms and conditions of the respective licenses.<br>
                               <br>
                               Please see <a href=\"http://qt.io/licensing/\">qt.io/licensing</a> for an overview of Qt licensing.<br>
                               <br>
                               Copyright (C) 2021 The Qt Company Ltd and other contributors.<br>
                               Qt and the Qt logo are trademarks of The Qt Company Ltd.<br>
                               <br>
                               Qt is The Qt Company Ltd product developed as an open source project.<br>
                               See <a href=\"http://qt.io/\">qt.io</a> for more information.</p></body></html>"
                        width: aboutQtDialog.availableWidth

                        ColumnLayout.fillWidth: true
                        ColumnLayout.fillHeight: true

                        onLinkActivated: {
                            Qt.openUrlExternally(link)
                        }
                    }
                }

                Button {
                    id: aboutQtDialogBtn
                    text: "Close"

                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20

                    Connections {
                        target: aboutQtDialogBtn
                        function onClicked() {
                            aboutQtDialog.close()
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: quitDialog
        title: "Quit PoweroffQML"
        x: Math.round((mainWindow.width - width) / 2)
        y: Math.round(mainWindow.height / 6)
        width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 10 * 9)

        modal: true
        focus: true
        closePolicy: Dialog.CloseOnEscape

        ColumnLayout {
            id: quitColumn
            x: parent.x
            width: parent.width
            spacing: 20

            Label {
                text: "Do you want to quit PoweroffQML?"
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.bottomMargin: 20
            }

            RowLayout {
                x: quitDialog.x
                width: quitDialog.width
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20

                Button {
                    id: quitDialogBtnOK
                    text: "OK"
                    Layout.alignment: Qt.AlignHCenter

                    Connections {
                        target: quitDialogBtnOK
                        function onClicked() {
                            saveMainWindowState()

                            quitDialog.close()

                            Qt.quit()
                        }
                    }
                }

                Button {
                    id: quitDialogBtnCancel
                    text: "Cancel"
                    Layout.alignment: Qt.AlignHCenter

                    Connections {
                        target: quitDialogBtnCancel
                        function onClicked() {
                            quitDialog.close()
                        }
                    }
                }
            }
        }
    }
}
