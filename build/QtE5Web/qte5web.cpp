#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif
#include "qte5web.h"

// ============ QWebView =======================================
// 24
extern "C" MSVC_API void* qteQWebView_create(QWidget* parent) {
    return new QWebView(parent);
}
// 25
extern "C" MSVC_API  void qteQWebView_delete(QWebView* wd) {
    if(!wd) return;
#ifdef debDelete
    printf("del QTabBar --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 26
extern "C" MSVC_API void qteQWebView_load(QWebView* wv, QUrl* url) {
    wv->load(*url);
}
