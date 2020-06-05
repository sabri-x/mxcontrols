/**************************************************************
** 作   者:  xcc
** 创建时间:  2020-06-04
** 描   述: ListView视图扩展，使它拥有以下功能:
           1. 下拉到一定位置时发出刷新信号
           2. 滑动到底部 或 一定位置时，发出加载更多数据信号
           3. 显示提示信息
**************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.4

ListView {
    id: viewRoot;
    
    //一页取的数据数量
    property int limit: 12;
    //是否下拉刷新
    property bool isRefresh: false;
    //提前加载-还没到底部时就开始发送加载更多数据信号------只有滑动停止时才会检测
    property bool isBeforehandLoad: true;
    //提前加载的提前高度
    property int beforehandLoadHt: 300;
    
    //提示内容控件
    property var tipsComponent: null;
    
    signal refresh();  //发出下拉刷新信号
    signal loadMore(); //发出加载更多信号
    
    maximumFlickVelocity: 4500;
    clip: true;
    
    
    /*!开始加载，会发出加载更多数据信号，并启动loading
     * 适用于初始化状态时调用
     */
    function startLoading(toInit){
        if( viewObj.fState === "loading" )
            return;
        
        if( toInit )
            init();
        
        if( count <=0 )
            viewObj.showCenterLoading();
        
        if( viewObj.fState === "more" || viewObj.fState === "init" )
            loadMore();
    }
    
    /*!设置数据到视图
     * 调用时机： 初始加载数据 或 加载更多 数据返回时，调用此方法
     * 描   述:  1. 填充数据到视图中；
                2. 根据返回的数据数量，设置加载状态
                3. 根据返回的code，显示提示信息
     */
    function setDatas(datas,curSize,staJs){
        viewObj.hideCenterLoading();
        if( staJs.code === 0 )
        {//正确返回
            if( curSize > limit ){
                if( curSize%limit == 0 )
                    viewObj.fState = "more";
                else
                    viewObj.fState = "noMore";
            }
            else if( curSize === limit )
                viewObj.fState = "more";
            else if( (count+curSize) >= limit )
                viewObj.fState = "noMore";
            else if( count > 0 )
                viewObj.fState = "notLimit";
            else
                viewObj.fState = "noData";
            
            if( !model )
                model = datas;
            
            if( viewObj.fState == "noData" )
                viewObj.showTips(staJs);
        }
        else if( count > 0 )
        {//加载失败，但已经取到数据了，
            viewObj.fState = "more";
        }
        else
        {//加载失败，没有取到数据，提示失败原因
            viewObj.fState = "init";
            viewObj.showTips(staJs);
        }
    }
    
    /*!刷新数据完成时，调用此方法，复位刷新状态
     */
    function refreshFinish(){
        viewObj.hState = "refFinish";
    }
    
    /*! 初始化参数，回到初始化状态
     */
    function init(){
        viewObj.topCurHt = 0;
        viewObj.hState = "init";
        viewObj.fState = "init";
        model = null;
        
        if( viewObj.tipsLoader )
            viewObj.tipsLoader.sourceComponent = undefined;
    }
    
    
    QtObject{
        id: viewObj;
        property int topMaxHt: 40;
        property int topCurHt: 0;
        property int beforehandLoadEndY: (contentHeight-height-beforehandLoadHt);
        property string hState: "init";
        property string fState: "init";
        property Loader tipsLoader: null;
        property var centerLoading: null;
        
        
        /*!没有数据 或 加载数据失败时 的提示
         */
        function showTips(staJs){
            if( tipsLoader ){
                tipsLoader = Qt.createQmlObject('import QtQuick.Controls 1.4; BusyIndicator {anchors.fill: viewRoot;}',
                                                viewRoot,
                                                "dynamicViewExLoader");
            }
        }
        
        /*!顶部刷新状态检测
         */
        function refresStateCheck(){
            if( !isRefresh )
                return;
            
            if( flicking || contentY >= 0 ){
                if( hState != "loading" )
                    hState = "init";
                topCurHt = 0;
                return;
            }
            topCurHt = -contentY;
            
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
        
        /*!检查是否刷新
         */
        function checkRefresh(){
            if( contentY < 0 )
            {//检测下拉刷新
                if( hState === "releaseRef" )
                {//  
                    slideAni.mStart("topReleaseRef");
                }
                else
                    slideAni.mStart("");
            }
        }
        
        /*!检查加载更多
         */
        function checkLoadMore(){
            if( fState === "loading" || contentY <= 0 )
                return;
            
            if( fState != "more" || count <=0 )
                return;
            
            if( atYEnd || ( isBeforehandLoad && contentY >= beforehandLoadEndY )){
                fState = "loading";
                loadMore();
            }
        }
        
        
        //启动loading
        function showCenterLoading(){
            if( !centerLoading ){
                centerLoading = cLoadingCpt.createObject(viewRoot,{});
                centerLoading.running = true;
            }
        }
        
        function hideCenterLoading(){
            if( centerLoading )
            {
                centerLoading.running = false;
                centerLoading.destroy();
                centerLoading = null;
            }
        }
        
    }
    
    header: isRefresh ? topRefCpt : null;
    footer: moreCpt;
    
    //检查是否触发刷新
    onDragEnded: viewObj.checkRefresh();
    onContentYChanged: {
        viewObj.refresStateCheck();
        if( isBeforehandLoad )
            viewObj.checkLoadMore();
    }
    
    //检查是否触发加载更多
    onMovementEnded: viewObj.checkLoadMore();
    onFlickEnded: viewObj.checkLoadMore();
    onAtYEndChanged: viewObj.checkLoadMore();
    
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
                to = -viewObj.topMaxHt;
            else 
                to = 0;
            start();
        }
        
        onStopped: {
            if( mType === "topReleaseRef" )
            {//松开手开始刷新
                viewObj.hState = "loading";
                Qt.callLater(refresh);
            }
            mType = "";
        }
    }
    
    /*!顶部下拉刷新控件
     */
    Component{
        id: topRefCpt;
        Item{
            id: topRefCptItem;
            width: viewRoot.width;
            height: viewObj.topCurHt;
            state: viewObj.hState;
            
            Item{
                width: parent.width;
                height: viewObj.topMaxHt;
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
                    viewObj.hState = "init";
                }
            }
        }
    }
    
    /*!底部加载更多及提示控件
     */
    Component{
        id: moreCpt;
        Item{
            id: moreCptItem;
            width: viewRoot.width;
            state: viewObj.fState;
            visible: height>0;
            
            Row{
                height: parent.height;
                anchors.horizontalCenter: parent.horizontalCenter;
                spacing: 5;
                
                BusyIndicator{
                    id: moreLoading;
                    width: 20
                    height: width;
                    anchors.verticalCenter: parent.verticalCenter;
                    visible: running;
                    running: false; 
                }
                
                Text {
                    id: moreTips;
                    font.pointSize: 11;
                    anchors.verticalCenter: parent.verticalCenter;
                }
            }
            
            states: [
                State {
                    name: "more"
                    PropertyChanges { target: moreTips; text: "上拉加载更多";}
                    PropertyChanges { target: moreCptItem; height: 30;}
                    PropertyChanges { target: moreLoading; running: false;}
                },
                State {
                    name: "loading"
                    PropertyChanges { target: moreTips; text: "正在加载...";}
                    PropertyChanges { target: moreCptItem; height: 30;}
                    PropertyChanges { target: moreLoading; running: true;}
                },
                State {
                    name: "noMore"
                    PropertyChanges { target: moreTips; text: "没有更多数据";}
                    PropertyChanges { target: moreCptItem; height: 30;}
                    PropertyChanges { target: moreLoading; running: false;}
                },
                State {
                    name: "notLimit" || "noData" || "init"
                    PropertyChanges { target: moreTips; text: "";}
                    PropertyChanges { target: moreCptItem; height: 0;}
                    PropertyChanges { target: moreLoading; running: false;}
                }
            ]
        }
    }
    
    
    Component{
        id: cLoadingCpt;
        BusyIndicator {
            anchors.centerIn: parent
            width: 50;
            height: width;
            anchors.verticalCenterOffset: -parent.height/4;
        }
    }
    
}
