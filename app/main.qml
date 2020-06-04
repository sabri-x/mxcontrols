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
        view.model.append({"title": qsTr("ListView扩展"),"path": "qrc:/MListViewPage.qml"});
        view.model.append({"title": qsTr("按钮"),"path": "qrc:/MButtonPage.qml"});
        view.model.append({"title": qsTr("循环视图"),"path": "qrc:/MLoopViewPage.qml"});
        view.currentIndex = 0;
    }
    
    function changed(){
        var model = view.model.get(view.currentIndex);
        loader.setSource(model.path,{});
    }
    
    ColumnLayout{
        anchors.fill: parent;
        spacing: 0;
        Text {
            id: titleItem;
            Layout.preferredHeight: 60;
            Layout.alignment: Qt.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            text: qsTr("标题")
            font.pointSize: 15;
        }
        
        Rectangle{
            Layout.preferredHeight: 1;
            Layout.fillWidth: true;
            color: "#f5f5f5";
        }
        
        RowLayout{
            Layout.fillHeight: true;
            Layout.fillWidth: true;
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
                    height: 40;
                    color: view.currentIndex==index ? "#f5f5f5" : "white";
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: view.currentIndex=index;
                    }
                    
                    Text {
                        text: model.title;
                        font.pointSize: 13;
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
                asynchronous: true;
            }
        }
    }

}
