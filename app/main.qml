import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0

import SXControls 1.0

Window {
    visible: true
    width: 600
    height: 700
    title: qsTr("Hello World")
    Component.onCompleted: Qt.callLater(init);
    
    function init(){
        view.model.append({"title": qsTr("按钮"),"path": "qrc:/MButtonPage.qml"});
        view.currentIndex = 0;
    }
    
    function changed(){
        var model = view.model.get(view.currentIndex);
        loader.setSource(model.path,{});
    }
    
    RowLayout{
        anchors.fill: parent;
        spacing: 0;
        ListView{
            id: view;
            Layout.fillHeight: true;
            Layout.preferredWidth: 150;
            model: ListModel{}
            maximumFlickVelocity: 5000;
            currentIndex: -1;
            onCurrentIndexChanged: Qt.callLater(changed);
            
            delegate: Rectangle{
                width: view.width;
                height: 50;
                color: view.currentIndex==index ? "#d7d7d7" : "white";
                MouseArea{
                    anchors.fill: parent;
                    onClicked: view.currentIndex=index;
                }
                
                Text {
                    text: model.title;
                    font.pointSize: 16;
                    anchors.centerIn: parent;
                }
                
                Rectangle{
                    width: parent.width;
                    height: 1;
                    anchors.bottom: parent.bottom;
                    color: "#f5f5f5";
                }
            }
        }
        
        Rectangle{
            Layout.fillHeight: true;
            Layout.preferredWidth: 1;
            color: "#f5f5f5";
        }
        
        Loader{
            id: loader;
            Layout.fillWidth: true;
            Layout.fillHeight: true;
        }
    }
    
}
