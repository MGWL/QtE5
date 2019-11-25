#include <QColor>

#define debDestr

#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif
#include "qte5Qsci.h"

// 600
extern "C" MSVC_API void* qteQScin_create(QWidget* parent) {
    return new QsciScintilla(parent);
}
// 601
extern "C" MSVC_API  void qteQScin_delete(QsciScintilla* wd) {
    if(!wd) return;
#ifdef debDelete
    printf("del QsciScintilla --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 602
extern "C" MSVC_API  void qteQScin_setColor(QsciScintilla* wd, QColor* c) {
    wd->setColor(*c);
}
// 603
extern "C" MSVC_API  bool qteQScin_overwriteMode(QsciScintilla* wd) {
    return wd->overwriteMode();
}
// 604
extern "C" MSVC_API  void qteQScin_setOverwriteMode(QsciScintilla* wd, bool overwrite) {
    wd->setOverwriteMode(overwrite);
}
// 605
extern "C" MSVC_API void* qteQScin_color(QsciScintilla* wd) {
    QColor* rez = new QColor(wd->color());    return rez;
}
// 606
extern "C" MSVC_API  void qteQScin_setPaper(QsciScintilla* wd, QColor* c) {
    wd->setPaper(*c);
}
// 607
extern "C" MSVC_API void* qteQScin_paper(QsciScintilla* wd) {
    QColor* rez = new QColor(wd->paper());    return rez;
}
// 608
extern "C" MSVC_API  void qteQScin_setFont(QsciScintilla* wd, QFont* f) {
    wd->setFont(*f);
}
// 609
extern "C" MSVC_API  void qteQScin_setAutoIndent(QsciScintilla* wd, bool overwrite) {
    wd->setOverwriteMode(overwrite);
}
// 610
extern "C" MSVC_API  bool qteQScin_isReadOnly(QsciScintilla* wd) {
    return wd->isReadOnly();
}
// 611
extern "C" MSVC_API  void qteQScin_setReadOnly(QsciScintilla* wd, bool ro) {
    wd->setReadOnly(ro);
}
// 612 // Ширина скрытого столбца номер его
extern "C" MSVC_API void qteQScin_setMarginWidth(QsciScintilla* wd,	int	margin, int width) {
    wd->setMarginWidth(margin, width);
}
// 613 Установить маску на отоброжение столбца
extern "C" MSVC_API void qteQScin_setMarginMarkerMask(QsciScintilla* wd, int margin, int mask) {
    wd->setMarginMarkerMask(margin, mask);
}
// 614 тип маркера отображаемого в столбце nm
extern "C" MSVC_API int qteQScin_markerDefine(QsciScintilla* wd, QsciScintilla::MarkerSymbol smb, int nm) {
    return wd->markerDefine(smb, nm);
}
// 615
extern "C" MSVC_API int qteQScin_markerAdd(QsciScintilla* wd, int liner, int markerNumber) {
    return wd->markerAdd(liner, markerNumber);
}

/*
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
*/
