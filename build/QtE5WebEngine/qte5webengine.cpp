#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif
#include "qte5webengine.h"

// ============= QWebEngine ====================
extern "C" MSVC_API void qteQWebEng_init() {
    QWebEngineView *view = new QWebEngineView(NULL);
    view->load(QUrl("http://qt-project.org/"));
    view->show();
}
// 446
extern "C" MSVC_API void* qteQWebEngView_create(QWidget* parent) {
    return new QWebEngineView(parent);
}
// 445
extern "C" MSVC_API  void qteQWebEngView_delete(QWebEngineView* wd) {
    if(!wd) return;
#ifdef debDelete
    printf("del qteQWebEng --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 447
extern "C" MSVC_API void qteQWebEngView_load(QWebEngineView* wv, QUrl* url) {
    wv->load(*url);
}
