import QtQuick 2.0
import "qrc:/xcqml/button/"
import "qrc:/MOpenJs.js" as OpenJs

Item {
    id: pageRoot;
    
    Component.onCompleted: Qt.callLater(init);
    
    function init(){
        var len = parseInt(grid.height/grid.itemHt);
        for(var i=0;i<len*2;i++)
            gridRep.model.append({"qmlPath": "qrc:/xcqml/button/MPushButton.qml"});
    }
    
    Rectangle{
        anchors.fill: grid;
        color: "#f5f5f5"
    }
    
    Grid{
        id: grid;
        property int itemWd: width/2;
        property int itemHt: 80;
        anchors.fill: parent;
        anchors.margins: 10;
        columns: 2;
        spacing: 1;
        Repeater{
            id: gridRep;
            model: ListModel{}
            delegate: itemCpt;
        }
    }
    
    Component{
        id: itemCpt;
        Rectangle{
            id: cptItem;
            width: grid.itemWd;
            height: grid.itemHt;
            Component.onCompleted: Qt.callLater(init);
            
            function init(){
                OpenJs.buildComponent(cptItem,model.qmlPath,{"anchors.centerIn": cptItem});
            }
        }
    }
}
