import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Item {
    property string user: userPanel.username
    property string password: passwordField.text
    property int session: sessionPanel.session
    property double inputHeight: Screen.height * 0.175 * 0.25 * config.Scale
    property double inputWidth: Screen.width * 0.175 * config.Scale

    Column {
        spacing: 8

        anchors {
            bottom: parent.bottom
            left: parent.left
        }

        PowerPanel {}
        SessionPanel { id: sessionPanel }
    }

    Column {
        spacing: 8
        width: inputWidth

        anchors {
            // verticalCenter: parent.verticalCenter 
            // left: parent.left
            // leftMargin: parent.width * 0.15 
            centerIn: parent
        }

        UserPanel { id: userPanel }

        PasswordPanel {
            id: passwordField

            height: inputHeight
            width: parent.width
            onAccepted: sddm.login(user, password, session);
        }

        Rectangle {
            id: loginAnim

            radius: parent.width / 2
            anchors.centerIn: parent
            color: "black"
            opacity: 0

            NumberAnimation {
                id: coverScreen

                target: loginAnim
                properties: "height, width"
                from: 0
                to: Screen.width * 2
                duration: 1000
                easing.type: Easing.InExpo
            }
        }
    }

    Connections {
        function onLoginSucceeded() {
            coverScreen.start();
        }

        function onLoginFailed() {
            passwordField.text = "";
            passwordField.focus = true;
        }

        target: sddm
    }
}
