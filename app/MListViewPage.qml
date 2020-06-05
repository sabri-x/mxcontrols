import QtQuick 2.0
import "qrc:/xcqml/view/"

Rectangle {
    
    property int num: 0;
    Component.onCompleted: init();
    
    function init(){
        view.startLoading();
    }
    
    function loadDatas(){
        var len = num<2 ? view.limit : view.limit/2;
        var cD = new Date();
        for(var i=0;i<len;i++)
            datasModel.append({"text": qsTr("%1. %2").arg(i+1).arg(Qt.formatDateTime(cD,"yyyy-MM-dd hh:mm:ss.zzz"))});
        view.setDatas(datasModel,len,{"code": 0,"message": ""})
        num++;
    }
    
    function refreshDatas(){
        var cD = new Date();
        for(var i=2;i>=0;i--)
            datasModel.insert(0,{"text": qsTr("%1. %2").arg(i+1).arg(Qt.formatDateTime(cD,"yyyy-MM-dd hh:mm:ss.zzz"))});
        view.refreshFinish();
    }
    
    Timer{
        id: loadTimer;
        property bool isRefresh: false;
        interval: 1000;
        onTriggered: {
            if( isRefresh )   
                refreshDatas();
            else
                loadDatas();
        }
    }
    
    ListModel{
        id: datasModel;
        
    }
    
    MListViewEx{
        id: view;
        anchors.fill: parent;
        isRefresh: true;
        
        onRefresh: {
            loadTimer.isRefresh = true;
            loadTimer.start();
        }
        
        onLoadMore: {
            loadTimer.isRefresh = false;
            loadTimer.start();
        }
        
        delegate: Item{
            width: view.width;
            height: 80;
            
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    view.startLoading(((index+1)%2 == 0 ));
                }
            }
            
            Text {
                text: model.text;
                font.pointSize: 12;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 20;
            }
            
            Rectangle{
                width: parent.width;
                height: 1;
                anchors.bottom: parent.bottom;
                color: "#f5f5f5"
            }
        }
    }
    
}
