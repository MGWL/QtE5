import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.1
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: root
    width: 300
    height: 180
    visible: true
    title: "QML window"

   Connections {
        target: test // test мы содали в QtE5: qmlEngine.setContextProperty("test", w1.acTest);
        // Ловим сигал, который испускает строка в QtE5: acTest.toQmlString("....");
        onQstrChange: {
            idTextField.text = test.qstr
        }
    }	

    TextField {
		id: idTextField
		width: 280
        text: test.qstr
        placeholderText: "User name"
        anchors.centerIn: parent

        // onTextChanged: backend.userName = text
    }
    RowLayout {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        Item { Layout.fillWidth: true }
        Label { text: "Строка для передачи в QtE5:" }
        TextField { 
			onEditingFinished: { 
				test.qstr = text;      // Строку мы запихнули в актион 
				test.Qml_Slot_ANI(13); // и дернули его, что бы он обработал её. 13 - пример передачи числа
			} 
		}
    }     
}
