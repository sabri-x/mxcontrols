import QtQuick 2.0
import "qrc:/xcqml/view/"

Rectangle {
    
    Component.onCompleted: init();
    
    function init(){
        for(var i=0;i<20;i++)
            view.model.append({});
    }
     
    MListViewEx{
        id: view;
        anchors.fill: parent;
        isRefresh: true;
        model: ListModel{}
        delegate: Item{
            width: view.width;
            height: 40;
            
            Text {
                text: qsTr("测试数据%1").arg(index+1);
                font.pointSize: 14;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 20;
            }
            
            Rectangle{
                width: parent.width;
                height: 1;
                anchors.bottom: parent.bottom;
                color: "#d7d7d7"
            }
        }
    }
    
}
