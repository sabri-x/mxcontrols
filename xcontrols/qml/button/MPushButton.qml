import QtQuick 2.0

Rectangle{
    id: itemRoot;
    
    property alias text: textItem.text;
    property alias fontPiSize: textItem.font.pointSize;
    property alias textColor: textItem.color;
    property int tpMargin: 8;
    property int lrMargin: 30;
    
    signal clicked();
    
    implicitHeight: textItem.height + tpMargin*2;
    implicitWidth: textItem.width + lrMargin*2;
    radius: height*0.10;
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0.96,0.96,0.96,ma.opaRatio) }
        GradientStop { position: 1.0; color: Qt.rgba(0.8,0.8,0.8,ma.opaRatio) }
    }
    
    MouseArea{
        id: ma;
        property double opaRatio: 1.0;
        anchors.fill: parent;
        onClicked: itemRoot.clicked();
    }
    
    states: [
        State {
            when: ma.pressed;
            PropertyChanges {target: ma; opaRatio: 0.66}
        },
        State {
            when: ma.released || ma.canceled;
            PropertyChanges {target: ma; opacity: 1.0}
        }
    ]
    
    Text {
        id: textItem;
        font.pointSize: 10;
        anchors.centerIn: parent;
        text: qsTr("按钮");
    }
    
    
}
