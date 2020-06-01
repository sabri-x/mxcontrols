
function buildComponent(parent,qml,args) {
    var cpt = Qt.createComponent(qml);
    if (cpt.status === Component.Ready)
        cpt = cpt.createObject(parent,args);
    else{
        console.log("--errorString=",cpt.errorString());
    }
    return cpt;
}
