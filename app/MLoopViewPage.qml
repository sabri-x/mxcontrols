import QtQuick 2.0
import QtQuick.Controls 2.14
import "qrc:/xcqml/view/"

Item {
    id: viewRoot;
    
    Component.onCompleted: init();
    
    function init(){
        lModel.append({"color": "red"});
        lModel.append({"color": "orange"});
        lModel.append({"color": "yellow"});
        lModel.append({"color": "green"});
        lModel.append({"color": "blue"});
    }
    
    ListModel{
        id: lModel;
    }
        
    Column{
        width: parent.width - 20;
        anchors.centerIn: parent;
        spacing: 4;
        
        MVerLoopView{
            id: vView;
            width: parent.width;
            height: 200;
            model: lModel;
            delegate: itemCpt;
            
            Text {
                text: qsTr("上下滑动");
                font.pointSize: 12;
                anchors.centerIn: parent;
            }
            
            PageIndicator{
                id: vPi;
                anchors.horizontalCenter: parent.horizontalCenter;
                currentIndex: parent.currentIndex;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: height/2;
                count: parent.count;
                delegate: Component{
                    Rectangle{
                        width: 6;
                        height: 6;
                        radius: height/2;
                        color: (index===vPi.currentIndex ? "gray" : "white");
                    }
                }
            }
        }
        
        MHorLoopView{
            id: hView;
            width: parent.width;
            height: vView.height;
            model: lModel;
            delegate: itemCpt;
            
            Text {
                text: qsTr("左右滑动");
                font.pointSize: 12;
                anchors.centerIn: parent;
            }
            
            PageIndicator{
                id: hPi;
                anchors.horizontalCenter: parent.horizontalCenter;
                currentIndex: parent.currentIndex;
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: height/2;
                count: parent.count;
                delegate: Component{
                    Rectangle{
                        width: 6;
                        height: 6;
                        radius: height/2;
                        color: (index===hPi.currentIndex ? "gray" : "white");
                    }
                }
            }
        }
    }
    
    Component{
        id: itemCpt;
        Rectangle{
            width: vView.width;
            height: vView.height;
            color: model.color;
            border.color: Qt.lighter(color);
            border.width: 2;
            radius: 2;
        }
    }
    
    
}
