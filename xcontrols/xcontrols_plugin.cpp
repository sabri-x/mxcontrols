#include "xcontrols_plugin.h"
#include "myitem.h"

#include <qqml.h>

void XcontrolsPlugin::registerTypes(const char *uri)
{
    // @uri SXControls
    qmlRegisterType<MyItem>(uri, 1, 0, "MyItem");
}

