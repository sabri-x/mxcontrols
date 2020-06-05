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
        titleItem.text = model.title;
        loader.setSource(model.path,{});
    }
    
    ColumnLayout{
        anchors.fill: parent;
        spacing: 0;
        
        Text {
            id: titleItem;
            Layout.preferredHeight: 60;
            Layout.fillWidth: true;
            horizontalAlignment: Text.AlignHCenter;
            verticalAlignment: Text.AlignVCenter;
            text: qsTr("标题");
            font.pointSize: 15;
            
            
            Image {
                id: menuImg;
                property bool isFold: true;
                source: isFold ? "qrc:/image/menu_3line_black.png" : "qrc:/image/arrow_dark.png";
                height: 30;
                width: sourceSize.width/sourceSize.height*height;
                rotation: (isFold ? 0 : 180);
                anchors.verticalCenter: parent.verticalCenter;
                anchors.leftMargin: 20;
                anchors.left: parent.left;
                MouseArea{
                    anchors.fill: parent;
                    anchors.margins: -20;
                    onClicked: menuImg.isFold = !menuImg.isFold;
                }
            }
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
                property int maxWd: 0;
                Layout.fillHeight: true;
                Layout.preferredWidth: (menuImg.isFold ? 0 : maxWd);
                model: ListModel{}
                maximumFlickVelocity: 5000;
                currentIndex: -1;
                onCurrentIndexChanged: Qt.callLater(changed);
                
                states: [
                    State {
                        when: menuImg.isFold
                        PropertyChanges {target: view; Layout.preferredWidth: 0}
                    },
                    State {
                        when: !menuImg.isFold
                        PropertyChanges {target: view; Layout.preferredWidth: 150}
                    }
                ]
                
                transitions: Transition {
                    NumberAnimation { properties: "Layout.preferredWidth"; duration: 200; easing.type: Easing.InOutQuad }
                }
                
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
