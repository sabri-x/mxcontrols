/**************************************************************
** 作   者:  xcc
** 创建时间:  2020-05-27
** 描   述:  左右可以无限循环滑动的视图，适用于不需要连续加载数据的场景
        n:  数据数量不得少于3个,否则滑动时控件之间会有空隙
**************************************************************/
import QtQuick 2.0

Item {
    id: viewRoot;
    
    property alias delegate: pView.delegate;
    property alias model: pView.model;
    property alias count: pView.count;
    property alias interactive: pView.interactive;
    property bool isAutoScroll: true;//是否自动滚动
    property alias interval: autoTimer.interval;
    property alias currentIndex: pView.currentIndex;
    
    clip: true;
    
    Timer{
        id: autoTimer;
        interval: 3000;
        repeat: true;
        onTriggered: {
            if( count <=1 )
                return;
            if( pView.currentIndex < pView.count )
                pView.currentIndex = pView.currentIndex + 1;
            else
                pView.currentIndex = 0;
        }
    }
    
    PathView{
        id: pView;
        path: horPath
        height: parent.height;
        width: parent.width*3;
        pathItemCount: 3;
        interactive: count>1;
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        snapMode: PathView.SnapOneItem;
        maximumFlickVelocity: 4000;
        anchors.horizontalCenter: parent.horizontalCenter;
        
        onCountChanged: {
            if( isAutoScroll )
                autoTimer.restart();
        }
        
        onMovementStarted: autoTimer.stop();
        onMovementEnded: autoTimer.restart();
    }
    
    Path{
        id: horPath;
        startX: 0
        startY: pView.height/2;
        PathLine{x:pView.width/2; y: pView.height/2; }
        PathLine{x:pView.width; y: pView.height/2;}
    }
}
