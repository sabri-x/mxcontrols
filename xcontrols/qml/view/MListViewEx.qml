/**************************************************************
** 作   者:  xcc
** 创建时间:  2020-06-04
** 描   述:
**************************************************************/
import QtQuick 2.0
import QtQuick.Controls 1.4

ListView {
    id: viewRoot;
    
    //一页取的数据数量
    property int limit: 10;
    property bool isRefresh: false;
    
    //private
    property int topMaxHt: 40;
    property string hState: "init";
    property string fState: "init";
    property Loader tipsLoader: null;
    
    signal refresh();  //发出下拉刷新信号
    signal loadMore(); //发出加载更多信号
    
    maximumFlickVelocity: 4500;
    header: isRefresh ? topRefCpt : null;
    footer: moreCpt;
    
    
    function setDatas(dModel,curSize,staJs){
        
    }
    
    /*!没有数据 或 加载数据失败时 的提示
     */
    function showTips(staJs){
        
    }
    
    function refreshCheck(){
        if( !isRefresh )
            return;
        
        if( hState != "loading" )
        {
            if( contentY >= 0 )
                hState = "init";
            else if( contentY  > -topMaxHt )
                hState = "dropdowning"
            else if( contentY <= -topMaxHt )
                hState = "releaseRef";
        }
        else{
            
        }
    }
    
    onContentYChanged: {
        // if( hState === "releaseRef" || hState === "loading" )
        console.log("---onContentYChanged------",contentY);
        refreshCheck();
    }
    
    onMovementStarted: {
        console.log("---onMovementStarted------");
    }
    
    onMovementEnded: {
        console.log("---onMovementEnded------");
    }
    
    
    onDragStarted: {
        console.log("---onDragStarted------");
        
    }
    
    onDragEnded: {
        console.log("---onDragEnded------");
        if( contentY < 0 )
        {//检测下拉刷新
            
            contentY = contentY;
            if( hState === "releaseRef" )
            {//  
                slideAni.mStart("topReleaseRef");
            }
            else
                slideAni.mStart("");
        }
    }
    
    Timer{
        id: testTimer;
        interval: 1000;
        onTriggered: {
            hState = "refFinish";
        }
    }
    
    NumberAnimation {
        id: slideAni;
        property string mType: "";
        target: view
        property: "contentY"
        duration: 200
        easing.type: Easing.InOutQuad
        
        function mStart(type){
            mType = type;
            if( type === "topReleaseRef" )
                to = -topMaxHt;
            start();
        }
        
        onStopped: {
            if( mType === "topReleaseRef" )
            {//松开手开始刷新
                hState = "loading";
                Qt.callLater(refresh);
                testTimer.start();
            }
        }
    }
    
    /*!顶部下拉刷新控件
     */
    Component{
        id: topRefCpt;
        Item{
            id: topRefCptItem;
            width: viewRoot.width;
            height: -contentY;
            //height: (state!="init" ? (contentY > -topMaxHt ? -contentY : topMaxHt) : 0);
            state: hState;
             
            Item{
                width: parent.width;
                height: topMaxHt;
                anchors.bottom: parent.bottom;
                Row{
                    height: parent.height;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    spacing: 5;
                    
                    Image {
                        id: refImage;
                        source: "qrc:/image/refresh_arrow.png";
                        width: 20;
                        height: width;
                        anchors.verticalCenter: parent.verticalCenter;
                    }
                    
                    BusyIndicator{
                        id: refLoading;
                        width: 20
                        height: width;
                        anchors.verticalCenter: parent.verticalCenter;
                        visible: running;
                        running: false; 
                    }
                    
                    Text {
                        id: refTips;
                        text: qsTr("下拉刷新");
                        font.pointSize: 10;
                        anchors.verticalCenter: parent.verticalCenter;
                    }
                }
            }
            
            transitions: [
                Transition {
                    NumberAnimation{ property: "rotation"; duration: 200}
                }
            ]
            
            states: [
                State {
                    name: "dropdowning"
                    PropertyChanges {target: refTips; text: qsTr("下拉刷新")}
                    PropertyChanges {target: refImage; visible: true; rotation: 0; source: "qrc:/image/refresh_arrow.png"}
                    PropertyChanges {target: refLoading; running: false}
                },
                State {
                    name: "releaseRef"
                    PropertyChanges {target: refTips; text: qsTr("释放更新")}
                    PropertyChanges {target: refImage; visible: true; rotation: 180; source: "qrc:/image/refresh_arrow.png"}
                    PropertyChanges {target: refLoading; running: false}
                },
                State {
                    name: "loading"
                    PropertyChanges {target: refTips; text: qsTr("加载中...")}
                    PropertyChanges {target: refImage; visible: false; source: ""}
                    PropertyChanges {target: refLoading; running: true}
                },
                State {
                    name: "refFinish"
                    PropertyChanges {target: refTips; text: qsTr("更新完成")}
                    PropertyChanges {target: refImage; visible: true; rotation: 0; source: "qrc:/image/refresh_success.png"}
                    PropertyChanges {target: refLoading; running: false}
                    PropertyChanges {target: toInitTimer; running: true}
                },
                State {
                    name: "init"
                    PropertyChanges {target: refTips; text: ""}
                    PropertyChanges {target: refImage; visible: false; source: ""}
                    PropertyChanges {target: refLoading; running: false}
                }
            ]
            
            Timer{
                id: toInitTimer;
                interval: 1000;
                repeat: false;
                onTriggered: {
                    restoreAni.to = 0;
                    restoreAni.start();
                }
            }
            
            
            NumberAnimation {
                id: restoreAni;
                target: topRefCptItem
                property: "height"
                to: 0;
                duration: 300
                easing.type: Easing.InOutQuad
                onStopped: {
                    hState = "init";
                }
            }
        }
    }
    
    /*!底部加载更多及提示控件
     */
    Component{
        id: moreCpt;
        Item{
            width: viewRoot.width;
        }
    }
    
}
