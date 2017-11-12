// For MSVC set __declspec(dllexport), for MinGW do not
#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif


#include "qte5widgets.h"

// !!!!!!!!!!!!!!!!
// #define debDelete 1

#define debDestr 1

#define sizeTabCallDlang 100


struct CallRecord {
    // char sig[32];           // Сигнатура
    // char par[10];           // Параметры
    void* adrObj;           // Адрес объекта
    void* adrMet;           // Адрес метода
};

CallRecord tabCallDlang[sizeTabCallDlang];

// 344
// =========== QObject ==========
extern "C" MSVC_API  QObject* qteQObject_parent(QObject* qobj) {
    return qobj->parent();
}
extern "C" MSVC_API void QObject_setObjectName(QObject* obj, QString* qs) {
    obj->setObjectName(*qs);
}
extern "C" MSVC_API void* QObject_objectName(QObject* obj, QString* qs) {
    *qs = obj->objectName();
    return *((void**)&( *qs ));
}
extern "C" MSVC_API void QObject_dumpObjectInfo(QObject* obj, int ps) {
    if(ps == 0) obj->dumpObjectInfo();
    if(ps == 1) obj->dumpObjectTree();
}

// =========== QApplication ==========
extern "C" MSVC_API  QtRefH qteQApplication_create1(int* argc, char *argv[], int AnParam3) {
    // This string for CLang Mac OSX. No work witchout this string ....
    // void* zz =
    //        QCoreApplication::libraryPaths().join(",").toUtf8().data();

    // Init tabCallDlang for link QScript and Dlang

    for(int i = 0; i != sizeTabCallDlang; i++) {
        tabCallDlang[i].adrMet = NULL;
        tabCallDlang[i].adrObj = NULL;
    }

    return (QtRefH)new QApplication(*argc, argv, AnParam3);
}
extern "C" MSVC_API  void qteQApplication_delete1(QApplication* app) {
#ifdef debDelete
    printf("del QApplication --> \n");
#endif
#ifdef debDestr
    // delete (QApplication*)app;
    if(app->parent() == NULL) delete (QApplication*)app;
#endif
#ifdef debDelete
    printf("------------> Ok\n");
#endif
}
extern "C" MSVC_API  int qteQApplication_sizeof(QtRefH app) {
    return sizeof(*(QApplication*)app);
}
extern "C" MSVC_API  void qteQApplication_appDirPath(QtRefH app, QtRefH qs) {
    *(QString*)qs = ((QApplication*)app)->applicationDirPath();
}
extern "C" MSVC_API  void qteQApplication_appFilePath(QtRefH app, QtRefH qs) {
    *(QString*)qs = ((QApplication*)app)->applicationFilePath();
}

extern "C" MSVC_API  void qteQApplication_processEvents(QtRefH app) {
    ((QApplication*)app)->processEvents();
}

//* ---------------------------------------------------
extern "C" MSVC_API  int qteQApplication_exec(QtRefH app) {
    return ((QApplication*)app)->exec();
}

/*
extern "C" MSVC_API  int qteQApplication_exec( QApplication* app) {
    return app->exec();
}
*/
// ---------------------------------------------------

extern "C" MSVC_API  void qteQApplication_aboutQt(QtRefH app) {
    ((QApplication*)app)->aboutQt();
}
extern "C" MSVC_API  void qteQApplication_quit(QtRefH app) {
    ((QApplication*)app)->quit();
}
// 276
extern "C" MSVC_API  void qteQApplication_exit(QtRefH app, int kod) {
    ((QApplication*)app)->exit(kod);
}
// 277
extern "C" MSVC_API  void qteQApplication_setStyleSheet(QtRefH app, QString* str) {
    printf(">setStyleSheet");
    ((QApplication*)app)->setStyleSheet(*str);
}
// 428
extern "C" MSVC_API  void qteQApplication_setX1(QApplication* app, void* adr, int pr) {
    switch ( pr ) {
    case 0:   app->restoreOverrideCursor();                         break;
    case 1:   app->setApplicationDisplayName(*((QString*)adr));     break;
    // case 2:   app->setDesktopFileName(*((QString*)adr));                     break;
    case 3:   app->setDesktopSettingsAware((bool)adr);              break;
    // case 4:   app->setFallbackSessionManagementEnabled((bool)adr);           break;
    case 5:   app->setFont(*((QFont*)adr));                         break;
    case 6:   app->setWindowIcon(*((QIcon*)adr));                   break;
    case 7:   app->setStyleSheet(*((QString*)adr));                 break;

    }
}

// =========== QLineEdit ==========
eQLineEdit::eQLineEdit(QWidget *parent): QLineEdit(parent) {
    aKeyPressEvent = NULL; aDThis = NULL;
}
eQLineEdit::~eQLineEdit() {
}

void eQLineEdit::keyPressEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyPressEvent == NULL) {
        QLineEdit::keyPressEvent(event); return;
    }
    if ((aKeyPressEvent != NULL) && (aDThis == NULL)) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp)aKeyPressEvent)((QtRefH)event);
        if(otv != NULL) {  QLineEdit::keyPressEvent(otv); }
        return;
    }
    if ((aKeyPressEvent != NULL) && (aDThis != NULL)) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QLineEdit::keyPressEvent(otv); }
    }
}
extern "C" MSVC_API  void qteQLineEdit_setKeyPressEvent(eQLineEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" MSVC_API  eQLineEdit* qteQLineEdit_create1(QWidget* parent) {
    return new eQLineEdit(parent);
}
extern "C" MSVC_API  void qteQLineEdit_delete1(eQLineEdit* wd) {
#ifdef debDelete
    printf("del eQLineEdit --> n\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
//84
extern "C" MSVC_API  void qteQLineEdit_set(eQLineEdit* qw, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   qw->setText(*qstr); break;
    case 1:   qw->insert(*qstr);  break;
    case 2:   qw->setInputMask(*qstr); break;
    }
}
/*
extern "C" MSVC_API  void qteQLineEdit_setfocus(eQLineEdit* qw) {
     qw->setFocus();
}
*/
extern "C" MSVC_API  void qteQLineEdit_clear(eQLineEdit* qw) {
     qw->clear();
}
extern "C" MSVC_API  void qteQLineEdit_text(eQLineEdit* wd, QString* qs) {
    *qs = wd->text();
}
// 287
extern "C" MSVC_API  void qteQLineEdit_setX1(eQLineEdit* wd, bool r, int pr) {
    switch ( pr ) {
    case 0:   wd->cursorWordBackward(r);    break;
    case 1:   wd->cursorWordForward(r);    break;
    case 2:   wd->end(r);   break;
    case 3:   wd->home(r);   break;
    case 4:   wd->setClearButtonEnabled(r);     break;
    case 5:   wd->setDragEnabled(r);      break;
    case 6:   wd->setFrame(r); break;
    case 7:   wd->setModified(r); break;
    case 8:   wd->setReadOnly(r); break;
    }
}
// 288
extern "C" MSVC_API  bool qteQLineEdit_getX1(eQLineEdit* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->dragEnabled();              break;
    case 1:   rez = wd->hasAcceptableInput();       break;
    case 2:   rez = wd->hasFrame();                 break;
    case 3:   rez = wd->hasSelectedText();          break;
    case 4:   rez = wd->isClearButtonEnabled();     break;
    case 5:   rez = wd->isModified();               break;
    case 6:   rez = wd->isReadOnly();               break;
    case 7:   rez = wd->isRedoAvailable();          break;
    case 8:   rez = wd->isUndoAvailable();          break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQLineEdit_setAlignment(eQLineEdit* wd, Qt::Alignment flag) {
    wd->setAlignment(flag);
}
//439
extern "C" MSVC_API  int qteQLineEdit_getInt(eQLineEdit* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->cursorPosition();           break;
    case 1:   rez = wd->maxLength();                break;
    case 2:   rez = wd->selectionStart();           break;
    }
    return rez;
}
//440
extern "C" MSVC_API  void qteQLineEdit_setX2(eQLineEdit* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->del();                break;
    case 1:   wd->deselect();           break;
    case 2:   wd->backspace();          break;
    }
}
//441
extern "C" MSVC_API  void qteQLineEdit_setX3(eQLineEdit* wd, int a, int b, int pr) {
    bool bb = false;
    if(a == 0) bb = false; else bb = true;
    switch ( pr ) {
    case 0:   wd->setSelection(a,b);                break;
    case 1:   wd->setMaxLength(b);                  break;
    case 2:   wd->setCursorPosition(b);             break;
    case 3:   wd->cursorBackward(bb, b);            break;
    case 4:   wd->cursorForward(bb, b);             break;
    case 5:   wd->setSelection(0, wd->text().length()); break;
    case 6:   wd->setEchoMode((QLineEdit::EchoMode)a);  break;
    }
}

// =========== QStatusBar ==========
extern "C" MSVC_API  QStatusBar* qteQStatusBar_create1(QWidget* parent) {
    return new QStatusBar(parent);
}
extern "C" MSVC_API  void qteQStatusBar_delete1(QStatusBar* wd) {
#ifdef debDelete
    printf("del QStatusBar --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
//93
extern "C" MSVC_API  void qteQStatusBar_showMessage(QStatusBar* wd, QString* qs, int timeout) {
    wd->showMessage(*qs, timeout);
}
// 314
extern "C" MSVC_API  void qteQStatusBar_addWidgetXX1(QStatusBar* wd, QWidget* awd, int st, int pr) {
    switch ( pr ) {
        case 0:   wd->addPermanentWidget(awd, st);     break;
        case 1:   wd->addWidget(awd, st);              break;
    }
}

// =========== QMainWinsow ==========
eQMainWindow::eQMainWindow(QWidget *parent, Qt::WindowFlags f): QMainWindow(parent, f) {
}
eQMainWindow::~eQMainWindow() {
}
extern "C" MSVC_API  eQMainWindow* qteQMainWindow_create1(QWidget* parent, Qt::WindowFlags f) {
    return new eQMainWindow(parent, f);
}

extern "C" MSVC_API  void qteQMainWindow_delete1(eQMainWindow* wd) {
#ifdef debDelete
    printf("del eQMainWindow --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQMainWindow_setXX(QMainWindow* wd, QWidget* s, int pr) {
    switch ( pr ) {
        case 0:   wd->setCentralWidget(s);              break;
        case 1:   wd->setMenuBar((QMenuBar*)s);         break;
        case 2:   wd->setStatusBar((QStatusBar*)s);     break;
        case 3:   wd->addToolBar((QToolBar*)s);         break;
    }
}
extern "C" MSVC_API  void qteQMainWindow_addToolBar(QMainWindow* wd, QToolBar* s, Qt::ToolBarArea pr) {
    wd->addToolBar(pr, s);
}

// =========== QWidget ==========
eQWidget::eQWidget(QWidget *parent, Qt::WindowFlags f): QWidget(parent, f) {
    aDThis = NULL;       // Хранит адрес экземпляра объекта D
    aKeyPressEvent = NULL;
    aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
    aMousePressEvent = NULL;
    aMouseReleaseEvent = NULL;
}
eQWidget::~eQWidget() {
}
// -------------------------------------------------
extern "C" MSVC_API  void qteQWidget_setKeyPressEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_KeyPressEvent = 1001;
    ((eQWidget*)wd)->aKeyPressEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_KeyPressEvent = 2001;
}
void eQWidget::keyPressEvent(QKeyEvent *event) {
    if( aBEG_KeyPressEvent != 1001 ) return;
    if( aEND_KeyPressEvent != 2002 ) return;
    if (aKeyPressEvent == NULL) return;
    if ((aKeyPressEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aKeyPressEvent)((QtRefH)event);
    }
    if ((aKeyPressEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
    }
}
// -------------------------------------------------

extern "C" MSVC_API  void qteQWidget_setPaintEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_PaintEvent = 1002;
    ((eQWidget*)wd)->aPaintEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_PaintEvent = 2002;
}
void eQWidget::paintEvent(QPaintEvent *event) {
    if( aBEG_PaintEvent != 1002 ) return;
    if( aEND_PaintEvent != 2002 ) return;
    if (aPaintEvent == NULL) return;
    QPainter qp(this);

    if (aDThis == NULL) {
        ((ExecZIM_v__vp_vp)aPaintEvent)((QtRefH)event, (QtRefH)&qp);
    }
    else  {
        ((ExecZIM_v__vp_vp_vp)aPaintEvent)(*(void**)aDThis, (QtRefH)event, (QtRefH)&qp);
    }

}

// -------------------------------------------------
extern "C" MSVC_API  void qteQWidget_setaMouseWheelEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_MouseWheelEvent = 1003;
    ((eQWidget*)wd)->aMouseWheelEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_MouseWheelEvent = 2003;
}

void eQWidget::wheelEvent(QWheelEvent* event) {
    // printf("eQWidget::paintEvent  event = %p   aBEG = %d   aEND = %d  aMouseWheelEvent = %p   aDThis = %p \n", event, aBEG_MouseWheelEvent, aEND_MouseWheelEvent, aMouseWheelEvent, aDThis);
    if( aBEG_MouseWheelEvent != 1003 ) return;
    if( aEND_MouseWheelEvent != 2003 ) return;
    if (aMouseWheelEvent == NULL) return;
    if ((aMouseWheelEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aMouseWheelEvent)((QtRefH)event);
    }
    if ((aMouseWheelEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aMouseWheelEvent)(*(void**)aDThis, (QtRefH)event);
    }
}

// -------------------------------------------------

extern "C" MSVC_API  void qteQWidget_setMousePressEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_MousePressEvent = 1004;
    ((eQWidget*)wd)->aMousePressEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_MousePressEvent = 2004;
}
void eQWidget::mousePressEvent(QMouseEvent *event) {
    if( aBEG_MousePressEvent != 1004 ) return;
    if( aEND_MousePressEvent != 2004 ) return;
    if (aMousePressEvent == NULL) return;
    if ((aMousePressEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aMousePressEvent)((QtRefH)event);
    }
    if ((aMousePressEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aMousePressEvent)(*(void**)aDThis, (QtRefH)event);
    }
}

// -------------------------------------------------

extern "C" MSVC_API  void qteQWidget_setMouseReleaseEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_MouseReleaseEvent = 1005;
    ((eQWidget*)wd)->aMouseReleaseEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_MouseReleaseEvent = 2005;
}
void eQWidget::mouseReleaseEvent(QMouseEvent *event) {
    if( aBEG_MouseReleaseEvent != 1005 ) return;
    if( aEND_MouseReleaseEvent != 2005 ) return;
    if (aMouseReleaseEvent == NULL) return;
    if ((aMouseReleaseEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aMouseReleaseEvent)((QtRefH)event);
    }
    if ((aMouseReleaseEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aMouseReleaseEvent)(*(void**)aDThis, (QtRefH)event);
    }
}

// -------------------------------------------------
extern "C" MSVC_API  void qteQWidget_setCloseEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_CloseEvent = 1006;
    ((eQWidget*)wd)->aCloseEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_CloseEvent = 2006;
}
void eQWidget::closeEvent(QCloseEvent *event) {
    if( aBEG_CloseEvent != 1006 ) return;
    if( aEND_CloseEvent != 2006 ) return;
    if (aCloseEvent == NULL) return;
    if ((aCloseEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aCloseEvent)((QtRefH)event);
    }
    if ((aCloseEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aCloseEvent)(*(void**)aDThis, (QtRefH)event);
    }
}
// -------------------------------------------------
extern "C" MSVC_API  void qteQWidget_setResizeEvent(eQWidget* wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_ResizeEvent = 1007;
    wd->aResizeEvent = adr;
    wd->aDThis = dThis;
    ((eQWidget*)wd)->aEND_ResizeEvent = 2007;
}
void eQWidget::resizeEvent(QResizeEvent *event) {
    if( aBEG_ResizeEvent != 1007 ) return;
    if( aEND_ResizeEvent != 2007 ) return;
    if (aResizeEvent == NULL) return;
    if(aDThis == NULL) {
         ((ExecZIM_v__vp)aResizeEvent)(event);
    } else {
        ((ExecZIM_v__vp_vp)aResizeEvent)(*(void**)aDThis, event);
    }
}
extern "C" MSVC_API  QtRefH qteQWidget_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new eQWidget((eQWidget*)parent, f);
}
extern "C" MSVC_API  void qteQWidget_delete1(eQWidget* wd) {
#ifdef debDelete
    printf("del QWidget --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQWidget_contentsRect(QWidget* wd, QRect* tk) {
    *tk = wd->contentsRect();
}
extern "C" MSVC_API  void qteQWidget_setGeometry(QWidget* wd, int x, int y, int w, int h) {
    wd->setGeometry(x, y, w, h);
}
extern "C" MSVC_API  void qteQWidget_setSizePolicy(QWidget* wd, QSizePolicy::Policy w, QSizePolicy::Policy h) {
    wd->setSizePolicy(w,  h);
}
extern "C" MSVC_API  void qteQWidget_setVisible(QtRefH wd, bool f) {
    ((QWidget*)wd)->setVisible(f);
}
extern "C" MSVC_API  bool qteQWidget_isVisible(QtRefH wd) {
    return (bool)((QWidget*)wd)->isVisible();
}
extern "C" MSVC_API  void qteQWidget_setWindowTitle(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setWindowTitle(*(QString*)qs);
}
extern "C" MSVC_API  void qteQWidget_setStyleSheet(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setStyleSheet(*(QString*)qs);
}
extern "C" MSVC_API  void qteQWidget_setToolTip(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setToolTip(*(QString*)qs);
}
extern "C" MSVC_API  void qteQWidget_setMMSize(QtRefH wd, bool mm, int w, int h) {
    if(mm) { ((QWidget*)wd)->setMinimumSize(w, h); }
    else   { ((QWidget*)wd)->setMaximumSize(w, h); }
}
extern "C" MSVC_API  void qteQWidget_setEnabled(QtRefH wd, bool b) {
    ((QWidget*)wd)->setEnabled(b);
}
extern "C" MSVC_API  void qteQWidget_setLayout(QtRefH wd, QtRefH la) {
    ((QWidget*)wd)->setLayout((QLayout*)la);
}
extern "C" MSVC_API  void qteQWidget_setMax1(QWidget* wd, int pr, int r) {
    switch ( pr ) {
    case 0:   wd->setMaximumWidth(r);    break;
    case 1:   wd->setMinimumWidth(r);    break;
    case 2:   wd->setMaximumHeight(r);   break;
    case 3:   wd->setMinimumHeight(r);   break;
    case 4:   wd->setFixedHeight(r);     break;
    case 5:   wd->setFixedWidth(r);      break;
    case 6:   wd->setToolTipDuration(r); break;
    }
}
extern "C" MSVC_API  void qteQWidget_exWin1(QWidget* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->setFocus();            break;
    case 1:   wd->close();               break;
    case 2:   wd->hide();                break;
    case 3:   wd->show();                break;
    case 4:   wd->showFullScreen();      break;
    case 5:   wd->showMaximized();       break;
    case 6:   wd->showMinimized();       break;
    case 7:   wd->showNormal();          break;
    case 8:   wd->update();              break;
    case 9:   wd->raise();               break;
    case 10:  wd->lower();               break;
    }
}
extern "C" MSVC_API  void qteQWidget_exWin2(QWidget* wd, int pr, int w, int h) {
    switch ( pr ) {
    case 0:   wd->move(w, h);            break;
    case 1:   wd->resize(w, h);          break;
    }
}
extern "C" MSVC_API  void qteQWidget_setFont(QWidget* wd, QFont* fn) {
    wd->setFont(*fn);
}
extern "C" MSVC_API  void* qteQWidget_winId(QWidget* wd) {
    return (void*)wd->winId();
}
extern "C" MSVC_API  int qteQWidget_getPr(QWidget* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->x();            break;
    case 1:   rez = wd->y();            break;
    case 2:   rez = wd->width();        break;
    case 3:   rez = wd->height();       break;
    }
    return rez;
}
extern "C" MSVC_API  bool qteQWidget_getBoolXX(QWidget* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->hasFocus();     break;
    case 1:   rez = wd->acceptDrops();  break;
    case 2:   rez = wd->autoFillBackground();  break;
    case 3:   rez = wd->hasMouseTracking();  break;
    case 4:   rez = wd->isActiveWindow();  break;
    case 5:   rez = wd->isEnabled();  break;
    case 6:   rez = wd->isFullScreen();  break;
    case 7:   rez = wd->isHidden();  break;
    case 8:   rez = wd->isMaximized();  break;
    case 9:   rez = wd->isMinimized();  break;
    case 10:  rez = wd->isModal();  break;
    case 11:  rez = wd->isWindow();  break;
    case 12:  rez = wd->isWindowModified();  break;
    case 13:  rez = wd->underMouse();  break;
    case 14:  rez = wd->updatesEnabled();  break;
    }
    return rez;
}

// =========== QString ==========
extern "C" MSVC_API  QtRefH qteQString_create1(void) {
    return (QtRefH)new QString();
}
// QString из wchar
extern "C" MSVC_API  QtRefH qteQString_create2(QChar* s, int size) {
    return (QtRefH) new QString(s, size);
}
extern "C" MSVC_API  void qteQString_delete(QString* wd) {
#ifdef debDelete
    printf("del QString --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("-----------> Ok\n");
#endif
}
extern "C" MSVC_API  QtRefH qteQString_data(QtRefH qs) {
    return (QtRefH)((QString*)qs)->data();
}
extern "C" MSVC_API  int qteQString_size(QtRefH qs) {
    return ((QString*)qs)->size();
}
extern "C" MSVC_API  int qteQString_sizeOf(void) {
    // int a = 5;
    // printf("adr a = %d", (unsigned int)&a);
    QString s("ABCD");
    // printf("adr s = %d", (unsigned int)&s);
    // int b = 6;
    // printf("adr b = %d", (unsigned int)&b);
    return sizeof(s);
}

// =========== QColor ==========
extern "C" MSVC_API  QtRefH qteQColor_create1(void) {
    return (QtRefH)new QColor();
}
// 324
extern "C" MSVC_API  QColor* qteQColor_create2(QRgb r) {
    return new QColor(r);
}
// 425
extern "C" MSVC_API  QColor* qteQColor_create3(Qt::GlobalColor r) {
    return new QColor(r);
}

extern "C" MSVC_API  void qteQColor_delete(QColor* wd) {
#ifdef debDelete
    printf("del QColor --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQColor_setRgb(QtRefH wc, int r, int g, int b, int a) {
    ((QColor*)wc)->setRgb(r,g,b,a);
}
extern "C" MSVC_API  void qteQColor_getRgb(QColor* wc, int* r, int* g, int* b, int* a) {
    wc->getRgb(r, g, b, a);
}
// 322
extern "C" MSVC_API  QRgb qteQColor_rgb(QColor* wc) {
    return wc->rgb();
}
// 323
extern "C" MSVC_API  void qteQColor_setRgb2(QColor* wc, QRgb r) {
    return wc->setRgba(r);
}


// =========== QBrush ==========
extern "C" MSVC_API  QtRefH qteQBrush_create1(void) {
    return (QtRefH)new QBrush();
}
extern "C" MSVC_API  void qteQBrush_delete(QBrush* wd) {
#ifdef debDelete
    printf("del QBrush --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 179
extern "C" MSVC_API  void qteQBrush_setColor(QBrush* qs, QColor* qc) {
    qs->setColor(*qc);
}
extern "C" MSVC_API  void qteQBrush_setStyle(QBrush* qs, Qt::BrushStyle bs) {
    qs->setStyle(bs);
}
// =========== QPen ==========
extern "C" MSVC_API  QtRefH qteQPen_create1(void) {
    return (QtRefH)new QPen();
}
// 396
extern "C" MSVC_API  QtRefH qteQPen_create2(QColor* qc) {
    return (QtRefH)new QPen(*qc);
}
extern "C" MSVC_API  void qteQPen_delete(QPen* wd) {
#ifdef debDelete
    printf("del QPen --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQPen_setColor(QPen* qs, QColor* qc) {
    qs->setColor(*qc);
}
extern "C" MSVC_API  void qteQPen_setStyle(QPen* qs, Qt::PenStyle st) {
    qs->setStyle(st);
}
extern "C" MSVC_API  void qteQPen_setWidth(QPen* qs, int w) {
    qs->setWidth(w);
}

// =========== QPalette ==========
extern "C" MSVC_API  QtRefH qteQPalette_create1(void) {
    return (QtRefH)new QPalette();
}
extern "C" MSVC_API  void qteQPalette_delete(QPalette* wd) {
#ifdef debDelete
    printf("del QPalette --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// =========== QPushButton =========
extern "C" MSVC_API  QtRefH qteQPushButton_create1(QtRefH parent, QtRefH name) {
    return  (QtRefH) new QPushButton((const QString &)*name, (QWidget*)parent);
}
extern "C" MSVC_API  void qteQPushButton_delete(QPushButton* wd) {
#ifdef debDelete
    printf("del QPushButton --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQPushButton_setXX(QPushButton* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoDefault(p); break;
    case 1:   wd->setDefault(p);     break;
    case 2:   wd->setFlat(p);        break;
    }
}
// =========== QAbstractButton =========
extern "C" MSVC_API  void qteQAbstractButton_setText(QtRefH wd, QtRefH qs) {
    ((QAbstractButton*)wd)->setText( (const QString &)*qs  );
}
extern "C" MSVC_API  void qteQAbstractButton_text(QtRefH wd, QtRefH qs) {
    *(QString*)qs = ((QAbstractButton*)wd)->text();
}
extern "C" MSVC_API  void qteQAbstractButton_setXX(QAbstractButton* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoExclusive(p); break;
    case 1:   wd->setAutoRepeat(p);    break;
    case 2:   wd->setCheckable(p);     break;
    case 3:   wd->setDown(p);          break;
    case 4:   wd->setChecked(p);       break;
    }
}
extern "C" MSVC_API  void qteQAbstractButton_setIcon(QAbstractButton* wd, QIcon* p) {
    wd->setIcon(*p);
}

extern "C" MSVC_API  bool qteQAbstractButton_getXX(QAbstractButton* wd, int pr) {
    bool rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->autoExclusive();    break;
    case 1:   rez = wd->autoRepeat();       break;
    case 2:   rez = wd->isCheckable();      break;
    case 3:   rez = wd->isChecked();        break;
    case 4:   rez = wd->isDown();           break;
    }
    return rez;
}

// =========== QSlot ==========


extern "C" MSVC_API  void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
extern "C" MSVC_API  void qteDisconnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot) {
    QObject::disconnect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot);
}


// ===================== QGridLayout ====================
extern "C" MSVC_API  QGridLayout* qteQGridLayout_create1(QWidget* wd) {
    return new QGridLayout(wd);
}
extern "C" MSVC_API  void qteQGridLayout_delete(QGridLayout* wd) {
#ifdef debDelete
    printf("del QGridLayout --> %p\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("----------------> Ok\n");
#endif
}
extern "C" MSVC_API  int qteQGridLayout_getXX1(QGridLayout* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->columnCount();           break;
    case 1:   rez = wd->horizontalSpacing();     break;
    case 2:   rez = wd->rowCount();              break;
    case 3:   rez = wd->spacing();               break;
    case 4:   rez = wd->verticalSpacing();       break;
    }
    return rez;
}
extern "C" MSVC_API void qteQGridLayout_addWidget1(QGridLayout* wd, QWidget* w, int r, int c, Qt::Alignment ali) {
    wd->addWidget(w, r, c, ali);
}
extern "C" MSVC_API void qteQGridLayout_addWidget2(QGridLayout* wd, QWidget* w, int r, int c, int rs, int cs, Qt::Alignment ali) {
    wd->addWidget(w, r, c, rs, cs, ali);
}
extern "C" MSVC_API  int qteQGridLayout_setXX1(QGridLayout* wd, int par, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->columnMinimumWidth(par);        break;
    case 1:   rez = wd->columnStretch(par);             break;
    case 2:   rez = wd->rowMinimumHeight(par);          break;
    case 3:   rez = wd->rowStretch(par);               break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQGridLayout_setXX2(QGridLayout* wd, int par1, int par2, int pr) {
    switch ( pr ) {
    case 0:   wd->setColumnMinimumWidth(par1, par2);        break;
    case 1:   wd->setColumnStretch(par1, par2);             break;
    case 2:   wd->setRowMinimumHeight(par1, par2);          break;
    case 3:   wd->setRowStretch(par1, par2);                break;
    }
}
extern "C" MSVC_API void qteQGridLayout_addLayout1(QGridLayout* wd, QLayout* w, int r, int c, Qt::Alignment ali) {
    wd->addLayout(w, r, c, ali);
}

// ===================== QLyout ====================
// 35
extern "C" MSVC_API  QtRefH qteQVBoxLayout(QWidget* wd) {
    if(wd == NULL) {
        return  (QtRefH) new QVBoxLayout();
    } else {
        return  (QtRefH) new QVBoxLayout(wd);
    }
    // return  (QtRefH) new QVBoxLayout(wd);
}
// 36
extern "C" MSVC_API  QtRefH qteQHBoxLayout(QWidget* wd) {
    if(wd == NULL) {
        return  (QtRefH) new QHBoxLayout();
    } else {
        return  (QtRefH) new QHBoxLayout(wd);
    }
}
// 34
extern "C" MSVC_API  QtRefH qteQBoxLayout(QtRefH wd, QBoxLayout::Direction dir) {
    return  (QtRefH) new QBoxLayout(dir, (QWidget*)wd);
}
// 37
extern "C" MSVC_API  void qteQBoxLayout_delete(QBoxLayout* wd) {
#ifdef debDelete
    printf("del QBoxLayout --> %p\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("----------------> Ok\n");
#endif
}
// 344
extern "C" MSVC_API  void qteQVBoxLayout_delete(QVBoxLayout* wd) {
#ifdef debDelete
    printf("del QVBoxLayout --> %p\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("----------------> Ok\n");
#endif
}
// 345
extern "C" MSVC_API  void qteQHBoxLayout_delete(QHBoxLayout* wd) {
#ifdef debDelete
    printf("del QHBoxLayout --> %p\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("----------------> Ok\n");
#endif
}

extern "C" MSVC_API  void qteQBoxLayout_addWidget(QtRefH BoxLyout, QtRefH widget, int stretch, int align) {
    ((QBoxLayout*)BoxLyout)->addWidget((QWidget*)widget, stretch, (Qt::Alignment)align);
}
extern "C" MSVC_API  void qteQBoxLayout_addLayout(QtRefH BoxLyout, QtRefH layout) {
	((QBoxLayout*)BoxLyout)->addLayout((QBoxLayout*)layout);
}
extern "C" MSVC_API  void qteQBoxLayout_setSpacing(QBoxLayout* BoxLyout, int sp) {
    BoxLyout->setSpacing(sp);
}
extern "C" MSVC_API  int qteQBoxLayout_spacing(QBoxLayout* BoxLyout) {
    return BoxLyout->spacing();
}
extern "C" MSVC_API  void qteQBoxLayout_setMargin(QBoxLayout* BoxLyout, int sp) {
    BoxLyout->setMargin(sp);
}
extern "C" MSVC_API  int qteQBoxLayout_margin(QBoxLayout* BoxLyout) {
    return BoxLyout->margin();
}
// ===================== QFrame ====================
eQFrame::eQFrame(QWidget *parent, Qt::WindowFlags f): QFrame(parent, f) {
    aKeyPressEvent = NULL;
    // aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
}
eQFrame::~eQFrame() {
}
/*
extern "C" MSVC_API  QFrame* qteQFrame_create1(QWidget* parent, Qt::WindowFlags f) {
    QFrame* nf = new QFrame(parent);
    nf->setFrameShape(QFrame::Box); //>setFrameStyle(QFrame::Panel | QFrame::Raised);
    nf->show();
    return new QFrame(parent, f);
}
extern "C" MSVC_API  QFrame* qteQFrame_create1(QWidget* parent, Qt::WindowFlags f) {
    return new QFrame(parent, f);
}
*/

extern "C" MSVC_API  eQFrame* qteQFrame_create1(QWidget* parent, Qt::WindowFlags f) {
    return new eQFrame(parent, f);
}
extern "C" MSVC_API  void qteQFrame_delete1(eQFrame* wd) {
#ifdef debDelete
    printf("del eQFrame --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
void eQFrame::keyPressEvent(QKeyEvent *event) {
    if(aKeyPressEvent != NULL) {
        ((ExecZIM_v__vp)aKeyPressEvent)((QtRefH)event);
    }
}
/*  Переопределив Paint - получаем обычный QWidget
 *  ---------------------------------------------
void eQFrame::paintEvent(QPaintEvent *event) {
    if(aPaintEvent != NULL) {
        ((ExecZIM_v__vp)aPaintEvent)((QtRefH)event);
    }
}
*/
void eQFrame::closeEvent(QCloseEvent *event) {
    if(aCloseEvent != NULL) {
        ((ExecZIM_v__vp)aCloseEvent)((QtRefH)event);
    }
}
void eQFrame::resizeEvent(QResizeEvent *event) {
    if(aResizeEvent != NULL) {
         ((ExecZIM_v__vp)aResizeEvent)(event);
    }
}
extern "C" MSVC_API  void qteQFrame_setFrameShape(QtRefH fr, QFrame::Shape sh)
{
    ((QFrame*)fr)->setFrameShape(sh);
}
extern "C" MSVC_API  void qteQFrame_setFrameShadow(QtRefH fr, QFrame::Shadow sh)
{
    ((QFrame*)fr)->setFrameShadow(sh);
}
extern "C" MSVC_API  void qteQFrame_setLineWidth(QtRefH fr, int sh)
{
    ((QFrame*)fr)->setLineWidth(sh);
}
extern "C" MSVC_API  void qteQFrame_listChildren(eQFrame* wd) {
    QObjectList list = wd->children();

    for(int i = 0; i != list.count(); i++) {
        printf("qt ==> %p\n", list[i]);
    }
}

// ===================== QLabel ====================
extern "C" MSVC_API  QtRefH qteQLabel_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new QLabel((QWidget*)parent, f);
}
extern "C" MSVC_API  void qteQLabel_delete1(QLabel* wd) {
#ifdef debDelete
    printf("del QLabel --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQLabel_setText(QtRefH wd, QtRefH qs) {
    ((QLabel*)wd)->setText(*(QString*)qs);
}
extern "C" MSVC_API  void qteQLabel_setPixmap(QLabel* wd, QPixmap* pm) {
    wd->setPixmap(*pm);
}
// ===================== QEvent ====================
extern "C" MSVC_API  int qteQEvent_type(QEvent* ev) {
    return ev->type();
}
extern "C" MSVC_API  void qteQEvent_ia(QEvent* ev, int pr) {
    switch ( pr ) {
    case 0:   ev->ignore();    break;
    case 1:   ev->accept();  break;
    }
}
//347
// ===================== QMouseEvent ====================
extern "C" MSVC_API  int qteQMouseEvent1(QMouseEvent* ev, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = ev->x();    break;
    case 1:   rez = ev->y();    break;
    case 2:   rez = ev->globalX();    break;
    case 3:   rez = ev->globalY();    break;
    }
    return rez;
}
//436
// ===================== QMouseEvent2 ====================
extern "C" MSVC_API  int qteQMouseEvent2(QWheelEvent* ev, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = ev->x();    break;
    case 1:   rez = ev->y();    break;
    case 2:   rez = ev->globalX();    break;
    case 3:   rez = ev->globalY();    break;
    }
    return rez;
}
//437
extern "C" MSVC_API  void qteQMouseangleDelta(QWheelEvent* ev, QPoint* point, int pr) {
    switch ( pr ) {
    case 0:   *point = ev->angleDelta();    break;
    case 1:   *point = ev->globalPos();     break;
    case 2:   *point = ev->pixelDelta();    break;
    case 3:   *point = ev->pos();           break;
    }
}

extern "C" MSVC_API  Qt::MouseButton qteQMouse_button(QMouseEvent* ev) {
    return ev->button();
}
// ===================== QResizeEvent ====================
extern "C" MSVC_API  QtRefH qteQResizeEvent_size(QResizeEvent* ev) {
    return (QtRefH)&ev->size();
}
extern "C" MSVC_API  QtRefH qteQResizeEvent_oldSize(QResizeEvent* ev) {
    return (QtRefH)&ev->oldSize();
}
// ===================== QSize ====================
extern "C" MSVC_API  QtRefH qteQSize_create1(int wd, int ht) {
    return (QtRefH)new QSize(wd, ht);
}
extern "C" MSVC_API  void qteQSize_delete1(QSize* wd) {
#ifdef debDelete
    printf("del QSize --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  int qteQSize_width(QSize* ev) {
    return ev->width();
}
extern "C" MSVC_API  int qteQSize_height(QSize* ev) {
    return ev->height();
}
extern "C" MSVC_API  void qteQSize_setWidth(QSize* ev, int wd) {
    return ev->setWidth(wd);
}
extern "C" MSVC_API  void qteQSize_setHeight(QSize* ev, int ht) {
    return ev->setHeight(ht);
}
// ===================== QKeyEvent ====================
extern "C" MSVC_API  int qteQKeyEvent_key(QKeyEvent* ev) {
    return ev->key();
}
extern "C" MSVC_API  int qteQKeyEvent_count(QKeyEvent* ev) {
    return ev->count();
}
// 285
extern "C" MSVC_API  unsigned int qteQKeyEvent_modifiers(QKeyEvent* ev) {
    return (unsigned int)ev->modifiers();
}

// ===================== QAbstractScrollArea ====================
extern "C" MSVC_API  QtRefH qteQAbstractScrollArea_create1(QtRefH parent) {
    return (QtRefH)new QAbstractScrollArea((QWidget*)parent);
}
extern "C" MSVC_API  void qteQAbstractScrollArea_delete1(QAbstractScrollArea* wd) {
#ifdef debDelete
    printf("del QAbstractScrollArea --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// ===================== QPlainTextEdit ====================

eQPlainTextEdit::eQPlainTextEdit(QWidget *parent): QPlainTextEdit(parent) {
    aKeyPressEvent = NULL; aDThis = NULL; aKeyReleaseEvent = NULL;
    aPaintEvent = NULL;
}
eQPlainTextEdit::~eQPlainTextEdit() {
}

// -------------------------------------------------

extern "C" MSVC_API  void eQPlainTextEdit_setPaintEvent(eQPlainTextEdit* wd, void* adr, void* dThis) {
    wd->aPaintEvent = adr;
    wd->aDThis = dThis;
}
void eQPlainTextEdit::paintEvent(QPaintEvent *event) {
    QPlainTextEdit::paintEvent(event);
    if (aPaintEvent == NULL) return;

    // QPainter qp(this);
    if (aDThis == NULL) {
        ((ExecZIM_v__vp_vp)aPaintEvent)((QtRefH)event, (QtRefH)NULL);
    }
    else  {
        ((ExecZIM_v__vp_vp_vp)aPaintEvent)(*(void**)aDThis, (QtRefH)event, (QtRefH)NULL);
    }
}

// -------------------------------------------------

void eQPlainTextEdit::gsetViewportMargins(int left, int top, int right, int bottom) {
    setViewportMargins(left, top, right, bottom);
}
void eQPlainTextEdit::gfirstVisibleBlock(QTextBlock* tb) {
    *tb = firstVisibleBlock();
}
int  eQPlainTextEdit::getXYWH(QTextBlock* tb, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   // top
        rez = (int) blockBoundingGeometry(*tb).translated(contentOffset()).top();
        break;
    case 1:   // bottom
        rez = (int) blockBoundingGeometry(*tb).translated(contentOffset()).top();
        rez = rez + (int) blockBoundingRect(*tb).height();
        break;
    }
    return rez;
}
extern "C" MSVC_API  int qteQPlainTextEdit_getXYWH(eQPlainTextEdit* wd, QTextBlock* tb, int pr) {
    return wd->getXYWH(tb, pr);
}

extern "C" MSVC_API  void qteQPlainTextEdit_setViewportMargins(eQPlainTextEdit* wd,
                    int left, int top, int right, int bottom) {
    wd->gsetViewportMargins(left, top, right, bottom);
}

void eQPlainTextEdit::keyPressEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyPressEvent == NULL) {QPlainTextEdit::keyPressEvent(event); return; }
    if (aKeyPressEvent != NULL) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QPlainTextEdit::keyPressEvent(otv); }
    }
}
void eQPlainTextEdit::keyReleaseEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyReleaseEvent == NULL) {QPlainTextEdit::keyReleaseEvent(event); return; }
    if (aKeyReleaseEvent != NULL) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyReleaseEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QPlainTextEdit::keyReleaseEvent(otv); }
    }
}
extern "C" MSVC_API  eQPlainTextEdit* qteQPlainTextEdit_create1(QWidget* parent) {
    return new eQPlainTextEdit(parent);
}
extern "C" MSVC_API  void qteQPlainTextEdit_delete1(eQPlainTextEdit* wd) {
#ifdef debDelete
    printf("del eQPlainTextEdit --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQPlainTextEdit_setKeyPressEvent(eQPlainTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" MSVC_API  void qteQPlainTextEdit_setKeyReleaseEvent(eQPlainTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyReleaseEvent = adr;
    wd->aDThis = aThis;
}
extern "C" MSVC_API  void qteQPlainTextEdit_appendPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->appendPlainText((const QString &)*str);
}
extern "C" MSVC_API  void qteQPlainTextEdit_appendHtml(QPlainTextEdit* wd, QtRefH str) {
    wd->appendHtml((const QString &)*str);
}
extern "C" MSVC_API  void qteQPlainTextEdit_setPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->setPlainText((const QString &)*str);
}
extern "C" MSVC_API  void qteQPlainTextEdit_insertPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->insertPlainText((const QString &)*str);
}
extern "C" MSVC_API  void qteQPlainTextEdit_cutn(QPlainTextEdit* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->cut();    break;
    case 1:   wd->clear();  break;
    case 2:   wd->paste();  break;
    case 3:   wd->copy();   break;
    case 4:   wd->selectAll();   break;
    case 5:   wd->selectionChanged();  break;
    case 6:   wd->centerCursor();  break;
    case 7:   wd->undo();  break;
    case 8:   wd->redo();  break;
    }
}
// 329
extern "C" MSVC_API bool qteQPlainTextEdit_find1(QPlainTextEdit* wd, QString* qs, QTextDocument::FindFlags fl) {
    // QMessageBox::information(NULL, *qs, *qs);
    return wd->find(*qs, fl);
}
// 330
extern "C" MSVC_API bool qteQPlainTextEdit_find2(QPlainTextEdit* wd, QRegExp* qs, QTextDocument::FindFlags fl) {
    // QMessageBox::information(NULL, *qs, *qs);
    return wd->find(*qs, fl);
}

extern "C" MSVC_API  void qteQPlainTextEdit_toPlainText(QPlainTextEdit* wd, QtRefH qs) {
    *(QString*)qs = wd->toPlainText();
}
extern "C" MSVC_API  QTextDocument* qteQPlainTextEdit_document(QPlainTextEdit* wd) {
    return wd->document();
}
// 230
extern "C" MSVC_API  void qteQPlainTextEdit_textCursor(QPlainTextEdit* wd, QTextCursor* tk) {
    *tk = wd->textCursor();
}
// 253
extern "C" MSVC_API  void qteQPlainTextEdit_setTextCursor(QPlainTextEdit* wd, QTextCursor* tk) {
    wd->setTextCursor(*tk);
}
extern "C" MSVC_API  void qteQPlainTextEdit_cursorRect(QPlainTextEdit* wd, QRect* tk) {
    *tk = wd->cursorRect();
}
extern "C" MSVC_API  void qteQPlainTextEdit_setTabStopWidth(QPlainTextEdit* wd, int width) {
    wd->setTabStopWidth(width);
}
// 282
extern "C" MSVC_API  void qteQPlainTextEdit_firstVisibleBlock(eQPlainTextEdit* wd, QTextBlock* tb) {
    wd->gfirstVisibleBlock(tb);
}
// 294
extern "C" MSVC_API  void qteQPlainTextEdit_setWordWrapMode(eQPlainTextEdit* wd, QTextOption* tb) {
    wd->setWordWrapMode(tb->wrapMode());
}
//
extern "C" MSVC_API  int qteQPlainTextEdit_getXX1(eQPlainTextEdit* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->blockCount();           break;
    case 1:   rez = wd->maximumBlockCount();    break;
    case 2:   rez = wd->cursorWidth();          break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQPlainTextEdit_setCursorPosition(eQPlainTextEdit* wd, int line, int col) {
    QTextCursor cursor = wd->textCursor();
    cursor.setPosition(wd->document()->findBlockByNumber(line).position());
    cursor.movePosition(QTextCursor::NextCharacter,
                        QTextCursor::MoveAnchor,
                        col);
    wd->setTextCursor(cursor);
}


// ===================== QAction ====================
// Скорее всего будет сделано так:
// -------------------------------
// Любой слот всегда! передаёт в обработчик D два параметра,
// 1 - Адрес объекта и 2 - N установленный при инициадизации

// Специализированные слоты для обработки сообщений с параметрами
// всегда передают Адрес и N (см выше) и дальше сами параметры


eAction::eAction(QObject* parent)  : QAction(parent) {
    aDThis = NULL; aSlotN = NULL; N = 0;
}
eAction::~eAction() {}

void eAction::Slot() {
    if ((aSlotN != NULL) && (aDThis == NULL)) { ((ExecZIM_v__v)aSlotN)(); }
    if ((aSlotN != NULL) && (aDThis != NULL)) { ((ExecZIM_v__vp)aSlotN)(*(void**)aDThis); }
}
void eAction::SlotN() { // Вызвать глобальную функцию с параметром N (диспетчерезатор)
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(N);
}
void eAction::Slot_Bool(bool b) { // Вызвать глобальную функцию с параметром b - булево
    if (aSlotN != NULL)  ((ExecZIM_v__b)aSlotN)(b);
}
void eAction::Slot_Int(int i) { // Вызвать глобальную функцию с параметром
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(i);
}

//--------- Новые слоты ---------------
void eAction::Slot_v__A_N_v() { // Новый тип слота - универсальный
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n)aSlotN)(*(void**)aDThis, N);
}
void eAction::Slot_v__A_N_b(bool pr) { // Новый тип слота - универсальный
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_b)aSlotN)(*(void**)aDThis, N, pr);
}
void eAction::Slot_v__A_N_i(int pn) { // Новый тип слота - универсальный
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_i)aSlotN)(*(void**)aDThis, N, pn);
}
void eAction::Slot_v__A_N_QObject(QObject* pn) {
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_i)aSlotN)(*(void**)aDThis, N, (size_t)pn);
}

//--------- СверхНовые слоты ---------------
extern "C" typedef void  (*ExecZIM_AN)(void*, int);
void eAction::Slot_AN() {
    if (aSlotN != NULL)  ((ExecZIM_AN)aSlotN)(*(void**)aDThis, N);
}
extern "C" typedef void  (*ExecZIM_ANI)(void*, int, int);
void eAction::Slot_ANI(int z) {
    if (aSlotN != NULL)  ((ExecZIM_ANI)aSlotN)(*(void**)aDThis, N, z);
}
extern "C" typedef void  (*ExecZIM_ANII)(void*, int, int, int);
void eAction::Slot_ANII(int z, int z2) {
    if (aSlotN != NULL)  ((ExecZIM_ANII)aSlotN)(*(void**)aDThis, N, z, z2);
}
extern "C" typedef void  (*ExecZIM_ANB)(void*, int, int);
void eAction::Slot_ANB(bool z) {
    if (aSlotN != NULL)  ((ExecZIM_ANB)aSlotN)(*(void**)aDThis, N, z);
}
void eAction::Slot_ANQ(QObject* pn) {
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_i)aSlotN)(*(void**)aDThis, N, (size_t)pn);
}
void eAction::Slot_ANQ(QMdiSubWindow* pn) {
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_i)aSlotN)(*(void**)aDThis, N, (size_t)pn);
}

//--------- СверхНовые сигналы ---------------
void eAction::sendSignal_V() {    emit Signal_V(); }
extern "C" MSVC_API  void qteQAction_SendSignal_V(eAction* qw) { qw->sendSignal_V(); }

void eAction::sendSignal_VI(int n) {    emit Signal_VI(n); }
extern "C" MSVC_API  void qteQAction_SendSignal_VI(eAction* qw, int n) { qw->sendSignal_VI(n); }

void eAction::sendSignal_VS(QString* s) {    emit Signal_VS(*s); }
extern "C" MSVC_API  void qteQAction_SendSignal_VS(eAction* qw, QString* s) { qw->sendSignal_VS(s); }

// -------------------------------------------------------
extern "C" MSVC_API  void* qteQAction_create(QObject * parent) {  return new eAction(parent); }
extern "C" MSVC_API  void  qteQAction_delete(eAction* wd)      {
#ifdef debDelete
    printf("del eAction --> %p\n", wd->parent());
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void* qteQAction_getParent(eAction* qw) {
    return qw->parent();
}

extern "C" MSVC_API  void qteQAction_setXX1(eAction* qw, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   qw->setText(*qstr);       break;
    case 1:   qw->setToolTip(*qstr);    break;
    }
}
extern "C" MSVC_API  void qteQAction_setSlotN2(eAction* slot, void* adr, void* adrTh, int n) {
    slot->aSlotN = adr;
    slot->aDThis = adrTh;
    slot->N = n;
}

extern "C" MSVC_API  void qteQAction_setHotKey(eAction *act, int kl) {
    act->setShortcut( (const QKeySequence &)kl);
}
extern "C" MSVC_API  void qteQAction_setIcon(eAction *act, QIcon *ik) {
    act->setIcon(*ik);
}
extern "C" MSVC_API  void qteQAction_setEnabled(eAction *act, bool p, int pr) {
    switch ( pr ) {
    case 0:   act->setEnabled(p);       break;
    case 1:   act->setVisible(p);       break;
    case 2:   act->setCheckable(p);       break;
    case 3:   act->setChecked(p);       break;
    case 4:   act->setIconVisibleInMenu(p);       break;
    }

}


extern "C" MSVC_API  void qteQAction_setSlotN(eAction* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}

/*
extern "C" MSVC_API  void qte_Connect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const eAction*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
*/
// ================= QMenu ==================================
extern "C" MSVC_API   void* qteQMenu_create(QWidget * parent) {
     return new QMenu(parent);
}
extern "C" MSVC_API  void qteQMenu_delete(QMenu* wd) {
#ifdef debDelete
    printf("del QMenu --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API   void qteQMenu_addAction(QMenu* menu, QAction *ac) {
    menu->addAction(ac);
}
extern "C" MSVC_API   void qteQMenu_setTitle(QMenu* menu, QString *qstr) {
    menu->setTitle(*qstr);
}
extern "C" MSVC_API   void qteQMenu_addSeparator(QMenu* menu) {
    menu->addSeparator();
}
extern "C" MSVC_API   void qteQMenu_addMenu(QMenu* menu, QMenu* nmenu) {
    menu->addMenu(nmenu);
}
// ============ QMenuBar ====================================
extern "C" MSVC_API   void* qteQMenuBar_create(QWidget * parent) {
     return new QMenuBar(parent);
}
extern "C" MSVC_API  void qteQMenuBar_delete(QMenuBar* wd) {
#ifdef debDelete
    printf("del QMenuBar --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQMenuBar_addMenu(QMenuBar* wd, QMenu* mn) {
    wd->addMenu(mn);
}
// ============ QFont =======================================
extern "C" MSVC_API   void* qteQFont_create() {
     return new QFont();
}
extern "C" MSVC_API  void qteQFont_delete(QFont* wd) {
#ifdef debDelete
    printf("del QFont --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQFont_setPointSize(QFont* wd, int pr) {
    wd->setPointSize(pr);
}
extern "C" MSVC_API  void qteQFont_setFamily(QFont* wd, QString *qstr) {
    wd->setFamily(*qstr);
}
// 312
extern "C" MSVC_API  void qteQFont_setBoolXX1(QFont* wd, bool z, int pr) {
    switch ( pr ) {
    case 0:   wd->setBold(z);             break;
    case 1:   wd->setFixedPitch(z);       break;
    case 2:   wd->setItalic(z);           break;
    case 3:   wd->setKerning(z);          break;
    case 4:   wd->setOverline(z);         break;
    case 5:   wd->setStrikeOut(z);        break;
    case 6:   wd->setUnderline(z);        break;
    }
}
// 313
extern "C" MSVC_API  bool qteQFont_getBoolXX1(QFont* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->bold();             break;
    case 1:   rez = wd->fixedPitch();       break;
    case 2:   rez = wd->italic();           break;
    case 3:   rez = wd->kerning();          break;
    case 4:   rez = wd->overline();         break;
    case 5:   rez = wd->strikeOut();        break;
    case 6:   rez = wd->underline();        break;
    }
    return rez;
}

// ============ QIcon =======================================
extern "C" MSVC_API   void* qteQIcon_create() {
     return new QIcon();
}
extern "C" MSVC_API  void qteQIcon_delete(QIcon* wd) {
#ifdef debDelete
    printf("del QIcon --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQIcon_addFile(QIcon* wd, QString *qstr, QSize* qsize ) {
    if(qsize == NULL) {
        wd->addFile(*qstr);
    } else {
        wd->addFile(*qstr, *qsize);
    }
}
extern "C" MSVC_API  void qteQIcon_addFile2(QIcon* wd, QString *qstr, QSize* qsize, QIcon::Mode mode, QIcon::State state) {
    if(qsize == NULL) {
        wd->addFile(*qstr,QSize(),mode,state);
    } else {
        wd->addFile(*qstr, *qsize, mode,state);
    }
}
extern "C" MSVC_API  void qteQIcon_swap( QIcon* wd, QIcon* iconSwap ) {
    wd->swap(*iconSwap);
}
// ============ QToolBar ====================================
extern "C" MSVC_API   void* qteQToolBar_create() {
    return new QToolBar();
}
extern "C" MSVC_API  void qteQToolBar_delete(QToolBar* wd) {
#ifdef debDelete
    printf("del QToolBar --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQToolBar_setXX1(QToolBar* wd, void* q, int pr) {
    switch ( pr ) {
    case 0:   wd->addAction((QAction*)q);      break;
    case 1:   wd->addWidget((QWidget*)q);      break;
    }
}
extern "C" MSVC_API  void qteQToolBar_setAllowedAreas(QToolBar* wd, Qt::ToolBarArea pr) {
    wd->setAllowedAreas(pr);
}
extern "C" MSVC_API  void qteQToolBar_setToolButtonStyle(QToolBar* wd, Qt::ToolButtonStyle pr) {
    wd->setToolButtonStyle(pr);
}
extern "C" MSVC_API  void qteQToolBar_addSeparator(QToolBar* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->addSeparator();       break;
    case 1:   wd->clear();              break;
    }
}

// ============ QDialog ====================================
extern "C" MSVC_API  QDialog* qteQDialog_create(QWidget* parent, Qt::WindowFlags f) {
    return new QDialog(parent, f);
}
extern "C" MSVC_API  void qteQDialog_delete(QDialog* wd) {
#ifdef debDelete
    printf("del QDialog --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  int qteQDialog_exec(QDialog* wd) {
    return wd->exec();
}
// ============ QMessageBox ====================================
extern "C" MSVC_API  QMessageBox* qteQMessageBox_create(QWidget* parent) {
    return new QMessageBox(parent);
}
extern "C" MSVC_API  void qteQMessageBox_delete(QMessageBox* wd) {
#ifdef debDelete
    printf("del QMessageBox --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQMessageBox_setXX1(QMessageBox* wd, void* q, int pr) {
    switch ( pr ) {
    case 0:   wd->setText(*(QString*)q);                break;
    case 1:   wd->setWindowTitle(*(QString*)q);         break;
    case 2:   wd->setInformativeText(*(QString*)q);     break;
    }
}
extern "C" MSVC_API  void qteQMessageBox_setStandardButtons(QMessageBox* wd,
        QMessageBox::StandardButton kn, int pr) {
    switch ( pr ) {
    case 0:   wd->setStandardButtons(kn);               break;
    case 1:   wd->setDefaultButton(kn);                 break;
    case 2:   wd->setEscapeButton(kn);                  break;
    case 3:   wd->setIcon((QMessageBox::Icon)kn);   break;
    }
}
// ============ QProgressBar ====================================
extern "C" MSVC_API  QProgressBar* qteQProgressBar_create(QWidget* parent) {
    return new QProgressBar(parent);
}
extern "C" MSVC_API  void qteQProgressBar_delete(QProgressBar* wd) {
#ifdef debDelete
    printf("del QProgressBar --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQProgressBar_setPr(QProgressBar* wd, int arg, int pr) {
    switch ( pr ) {
    case 0:   wd->setMinimum(arg);               break;
    case 1:   wd->setMaximum(arg);                break;
    case 2:   wd->setValue(arg);                 break;
    }
}
// ============ QDate =======================================
extern "C" MSVC_API   void* qteQDate_create() {
    QDate* dd = new QDate(); *dd = dd->currentDate();
    return dd;
}
extern "C" MSVC_API  void qteQDate_delete(QDate* wd) {
#ifdef debDelete
    printf("del QDate --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  QString* qteQDate_toString(QDate* d, QString* rez, QString* shabl) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *rez = d->toString(*shabl);
    return rez;
}
extern "C" MSVC_API  void qteQDate_currentDate(QDate* d) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *d = d->currentDate();
}


// ============ QTime =======================================
extern "C" MSVC_API   void* qteQTime_create() {
    QTime* dd = new QTime(); *dd = dd->currentTime();
    return dd;
}
extern "C" MSVC_API  void qteQTime_delete(QTime* wd) {
#ifdef debDelete
    printf("del QTime --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  QString* qteQTime_toString(QTime* d, QString* rez, QString* shabl) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *rez = d->toString(*shabl);
    return rez;
}
extern "C" MSVC_API  void qteQTime_currentTime(QTime* d) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *d = d->currentTime();
}
// =========== QFileDialog ==========
extern "C" MSVC_API  QFileDialog* qteQFileDialog_create(QWidget* parent, Qt::WindowFlags f) {
    QFileDialog* fd = new QFileDialog(parent, f);
    // delete(fd);
    return fd;
}
extern "C" MSVC_API  void qteQFileDialog_delete(QFileDialog* wd) {
#ifdef debDelete
    printf("del QFileDialog --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQFileDialog_setNameFilter(QFileDialog* wd, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   wd->setNameFilter(*qstr);                 break;
    case 1:   wd->selectFile(*qstr);                    break;
    case 2:   wd->setDirectory(*qstr);                  break;
    case 3:   wd->setDefaultSuffix(*qstr);              break;
    }

}
extern "C" MSVC_API  void qteQFileDialog_setViewMode(QFileDialog* wd, QFileDialog::ViewMode f) {
    wd->setViewMode(f);
}
extern "C" MSVC_API  QString* qteQFileDialog_stGetOpenFileName(
        QWidget* parent,
        QString* rez,
        QString* caption,
        QString* dir,
        QString* filter,
        QString* selectedFilter,
        QFileDialog::Option f) {
    *rez = QFileDialog::getOpenFileName(parent,*caption,*dir,*filter,selectedFilter,f);
    return rez;
}
extern "C" MSVC_API  QString* qteQFileDialog_stGetSaveFileName(
        QWidget* parent,
        QString* rez,
        QString* caption,
        QString* dir,
        QString* filter,
        QString* selectedFilter,
        QFileDialog::Option f) {
    *rez = QFileDialog::getSaveFileName(parent,*caption,*dir,*filter,selectedFilter,f);
    return rez;
}

extern "C" MSVC_API  QString* qteQFileDialog_getOpenFileName(
        QFileDialog* wd,
        QWidget* parent,
        QString* rez,
        QString* caption,
        QString* dir,
        QString* filter,
        QString* selectedFilter,
        QFileDialog::Option f) {
    // *rez = wd->getOpenFileName(parent,*caption,*dir,*filter,selectedFilter,f);
    *rez = wd->getOpenFileName(parent,*caption,*dir,*filter,selectedFilter,f);
    return rez;
}
extern "C" MSVC_API  QString* qteQFileDialog_getSaveFileName(
        QFileDialog* wd,
        QWidget* parent,
        QString* rez,
        QString* caption,
        QString* dir,
        QString* filter,
        QString* selectedFilter,
        QFileDialog::Option f) {
    *rez = wd->getSaveFileName(parent,*caption,*dir,*filter,selectedFilter,f);
    return rez;
}
// =========== QAbstractScrollArea ==========
extern "C" MSVC_API  QAbstractScrollArea* qteQAbstractScrollArea_create(QWidget* parent) {
    return new QAbstractScrollArea(parent);
}
extern "C" MSVC_API  void qteQAbstractScrollArea_delete(QAbstractScrollArea* wd) {
#ifdef debDelete
    printf("del QAbstractScrollArea --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// =========== QMdiArea ==========
// 151
extern "C" MSVC_API  QMdiArea* qteQMdiArea_create(QWidget* parent) {
    return new QMdiArea(parent);
}
extern "C" MSVC_API  void qteQMdiArea_delete(QMdiArea* wd) {
#ifdef debDelete
    printf("del QMdiArea --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  QMdiSubWindow* qteQMdiArea_addSubWindow(QMdiArea* ma, QWidget* wd, Qt::WindowFlags windowFlags) {
    return ma->addSubWindow(wd, windowFlags);
}
extern "C" MSVC_API  QMdiSubWindow* qteQMdiArea_activeSubWindow(QMdiArea* ma) {
    return ma->activeSubWindow();
}
//431
extern "C" MSVC_API  bool qteQMdiArea_getN1(QMdiArea* ma, int pr) {
    int rez; rez = false;
    switch ( pr ) {
        case 0:   rez = ma->documentMode();                  break;
        case 1:   rez = ma->tabsClosable();                  break;
        case 2:   rez = ma->tabsMovable();                   break;
    }
    return rez;
}
//432
extern "C" MSVC_API  void qteQMdiArea_setN1(QMdiArea* ma, bool b, int pr) {
    switch ( pr ) {
        case 0:   ma->setDocumentMode(b);               break;
        case 1:   ma->setTabsClosable(b);               break;
        case 2:   ma->setTabsMovable(b);                break;
    }
}
//433
extern "C" MSVC_API  void qteQMdiArea_removeSubWin(QMdiArea* ma, QMdiSubWindow* wd) {
    ma->removeSubWindow(wd);
}
//434
extern "C" MSVC_API  void qteQMdiArea_setViewMode(QMdiArea* ma, QMdiArea::ViewMode r) {
    ma->setViewMode(r);
}

// =========== QMdiSubWindow ==========
extern "C" MSVC_API  QMdiSubWindow* qteQMdiSubWindow_create(QWidget* parent, Qt::WindowFlags f) {
    return new QMdiSubWindow(parent, f);
}
extern "C" MSVC_API  void qteQMdiSubWindow_delete(QMdiSubWindow* wd) {
#ifdef debDelete
    printf("del QMdiSubWindow --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQMdiSubWindow_addLayout(QMdiSubWindow* wd, QBoxLayout* ly ) {
    wd->setLayout(ly);
}
// =========== QAbstractItemView ==========
// =========== QTableView ==========
extern "C" MSVC_API  QTableView* qteQTableView_create(QWidget* parent) {
    return new QTableView(parent);
}
extern "C" MSVC_API  void qteQTableView_delete(QTableView* wd) {
#ifdef debDelete
    printf("del QTableView --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 174
extern "C" MSVC_API  void qteQTableView_setN1(QTableView* wd, int n, int p, int pr) {
    switch ( pr ) {
        case 0:   wd->setColumnWidth(n, p);                  break;
        case 1:   wd->setRowHeight(n, p);                    break;
    }
}
// 175
extern "C" MSVC_API  int qteQTableView_getN1(QTableView* wd, int n, int pr) {
    int rez; rez = 0;
    switch ( pr ) {
        case 0:   rez = wd->columnWidth(n);                  break;
        case 1:   rez = wd->rowHeight(n);                    break;
        case 2:   rez = wd->columnAt(n);                     break;
        case 3:   rez = wd->rowAt(n);                        break;
        case 4:   wd->showColumn(n);                   break;
        case 5:   wd->hideColumn(n);                   break;
        case 6:   wd->showRow(n);                      break;
        case 7:   wd->hideRow(n);                      break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQTableView_ResizeMode(QTableView* wd, int rc, QHeaderView::ResizeMode n, int pr) {
    switch ( pr ) {
    case 0:  wd->horizontalHeader()->setSectionResizeMode(rc, n); break;
    case 1:    wd->verticalHeader()->setSectionResizeMode(rc, n); break;
    }
}

// =========== QTableWidgetItem ==========
extern "C" MSVC_API  void* qteQTableWidgetItem_create(int t) {
    return new QTableWidgetItem(t);
}
extern "C" MSVC_API  void qteQTableWidgetItem_delete(QTableWidgetItem* wd) {
#ifdef debDelete
    printf("del QTableWidgetItem --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQTableWidgetItem_setXX(QTableWidgetItem* wd, QString *qstr, int pr) {
    switch ( pr ) {
        case 0:   wd->setText(*qstr);                  break;
        case 1:   wd->setToolTip(*qstr);                    break;
        case 2:   wd->setStatusTip(*qstr);                  break;
        case 3:   wd->setWhatsThis(*qstr);                  break;
    }
}
extern "C" MSVC_API  int qteQTableWidgetItem_setYY(QTableWidgetItem* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
        case 0:  rez = wd->column();                  break;
        case 1:  rez = wd->row();                     break;
        case 2:  rez = wd->textAlignment();           break;
        case 3:  rez = wd->type();                    break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQTableWidgetItem_text(QTableWidgetItem* wd, QString* qs) {
    *qs = wd->text();
}
extern "C" MSVC_API  void qteQTableWidgetItem_setAlignment(QTableWidgetItem* wd, int alig) {
    wd->setTextAlignment(alig);
}
extern "C" MSVC_API  void qteQTableWidgetItem_setBackground(QTableWidgetItem* wd, QBrush* qb, int pr) {
    switch ( pr ) {
        case 0:  wd->setBackground(*qb);                  break;
        case 1:  wd->setForeground(*qb);                  break;
    }
}
extern "C" MSVC_API  void qteQTableWidgetItem_setFlags(QTableWidgetItem* wd, Qt::ItemFlags fl) {
    wd->setFlags(fl);
}
extern "C" MSVC_API  int /*Qt::ItemFlags*/ qteQTableWidgetItem_flags(QTableWidgetItem* wd) {
    return wd->flags();
}
extern "C" MSVC_API  void qteQTableWidgetItem_setSelected(QTableWidgetItem* wd, bool select) {
    wd->setSelected(select);
}
extern "C" MSVC_API  bool qteQTableWidgetItem_isSelected(QTableWidgetItem* wd) {
    return wd->isSelected();
}
extern "C" MSVC_API  void qteQTableWidgetItem_setIcon(QTableWidgetItem* wd, const QIcon& icon) {
    wd->setIcon(icon);
}
// =========== QTableWidget ==========
extern "C" MSVC_API  QTableWidget* qteQTableWidget_create(QWidget* parent) {
    return new QTableWidget(parent);
}
extern "C" MSVC_API  void qteQTableWidget_delete(QTableWidget* wd) {
#ifdef debDelete
    printf("del QTableWidget --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQTableWidget_setRC(QTableWidget* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setColumnCount(n);                 break;
    case 1:   wd->setRowCount(n);                    break;
    case 2:   wd->insertColumn(n);                   break;
    case 3:   wd->insertRow(n);                      break;
    case 4:   wd->clear();                           break;
    case 5:   wd->clearContents();                   break;
    }
}
extern "C" MSVC_API  void qteQTableWidget_setItem(QTableWidget* wd,
                        QTableWidgetItem* tw, int r, int c) {
    wd->setItem(r, c, tw);
}
// 176
extern "C" MSVC_API  void qteQTableWidget_setHVheaderItem(QTableWidget* wd,
                                                QTableWidgetItem* item,
                                                int cr, int pr) {
    switch ( pr ) {
    case 0:   wd->setHorizontalHeaderItem(cr, item);  break;
    case 1:   wd->setVerticalHeaderItem(cr, item);    break;
    case 2: {
        QTableWidgetItem* twi = new QTableWidgetItem(0);
        twi->setText("Hello");
        wd->setVerticalHeaderItem(cr, twi);
            }   break;
    }
}
//241
extern "C" MSVC_API  void qteQTableWidget_setCurrentCell (QTableWidget* wd, int row, int column ) {
    wd->setCurrentCell(row, column);
}
// 369
extern "C" MSVC_API  int qteQTableWidget_getCurrent (QTableWidget* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->currentColumn();         break;
    case 1:   rez = wd->currentRow();            break;
    case 2:   rez = wd->colorCount();            break;
    }
    return rez;
}
// 370
extern "C" MSVC_API  QTableWidgetItem* qteQTableWidget_item (QTableWidget* wd, int row, int col) {
    return wd->item(row, col);
}
// 371
extern "C" MSVC_API  QTableWidgetItem* qteQTableWidget_takeItem (QTableWidget* wd, int row, int col) {
    return wd->takeItem(row, col);
}

// =========== QComboBox ==========
extern "C" MSVC_API  QComboBox* qteQComboBox_create(QWidget* parent) {
    return new QComboBox(parent);
}
extern "C" MSVC_API  void qteQComboBox_delete(QComboBox* wd) {
#ifdef debDelete
    printf("del QComboBox --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQComboBox_setXX(QComboBox* wd, QString *qstr, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->addItem(*qstr, n);       break;
    case 1:   wd->setItemText(n, *qstr);   break;
    case 2:   wd->setMaxCount(n);          break;
    case 3:   wd->setMaxVisibleItems(n);   break;
    }
}
extern "C" MSVC_API  int qteQComboBox_getXX(QComboBox* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->currentIndex();          break;
    case 1:   rez = wd->count();                 break;
    case 2:   rez = wd->maxCount();              break;
    case 3:   rez = wd->maxVisibleItems();       break;
    case 4:   rez = wd->currentData().toUInt();  break;
    case 5:   wd->clear();                 break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQComboBox_text(QComboBox* wd, QString* qs) {
    *qs = wd->currentText();
}
// =========== QPainter ==========
// 301
extern "C" MSVC_API  QPainter* qteQPainter_create(QPixmap* parent) {
    return new QPainter(parent);
}
// 390
extern "C" MSVC_API  bool qteQPainter_create3(QPainter* pm, QPaintDevice* uqpd) {
    return pm->begin(&(*uqpd));
}
//extern "C" MSVC_API  bool qteQPainter_create4(QPainter* pm, QWidget* uqpd) {
//    return pm->begin(&(*uqpd));
//}

// 302
extern "C" MSVC_API  void qteQPainter_delete(QPainter* wd) {
#ifdef debDelete
    printf("del QPainter --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQPainter_drawPoint(QPainter* qp, int x, int y, int pr) {
    switch ( pr ) {
    case 0:   qp->drawPoint(x, y);          break;
    case 1:   qp->setBrushOrigin(x, y);     break;
    }
}
extern "C" MSVC_API  void qteQPainter_drawLine(QPainter* qp, int x1, int y1, int x2, int y2) {
    qp->drawLine(x1, y1, x2, y2);
}
// 243
extern "C" MSVC_API  void qteQPainter_drawRect1(QPainter* qp, int x1, int y1, int w, int h) {
    qp->drawRect(x1, y1, w, h);
}
// 244
extern "C" MSVC_API  void qteQPainter_drawRect2(QPainter* qp, QRect* qr) {
    qp->drawRect(*qr);
}
// 245
extern "C" MSVC_API  void qteQPainter_fillRect2(QPainter* qp, QRect* qr, QColor* cl) {
    qp->fillRect(*qr, *cl);
}
// 246
extern "C" MSVC_API  void qteQPainter_fillRect3(QPainter* qp, QRect* qr, Qt::GlobalColor gc) {
    qp->fillRect(*qr, gc);
}

extern "C" MSVC_API  void qteQPainter_setXX1(QPainter* qp, void* ob, int pr) {
    switch ( pr ) {
    case 0:   qp->setBrush(*((QBrush*)ob)); break;
    case 1:   qp->setPen(*((QPen*)ob)); break;
    case 2:   qp->setFont(*((QFont*)ob)); break;
    }
}
extern "C" MSVC_API  void qteQPainter_setText(QPainter* qp, QString* ob, int x, int y) {
    qp->drawText(x, y, *ob);
}
extern "C" MSVC_API  bool qteQPainter_end(QPainter* qp) {
    return qp->end();
}
extern "C" MSVC_API  void qteQPainter_getFont(QPainter* qp, QFont* font) {
    *font = qp->font();
}
extern "C" MSVC_API  void qteQPainter_drawImage1(QPainter* qp, QPoint* point, QImage* im) {
   qp->drawImage(*point, *im);
}
extern "C" MSVC_API  void qteQPainter_drawImage2(QPainter* qp, QRect* rect, QImage* im) {
   qp->drawImage(*rect, *im);
}
extern "C" MSVC_API  void qteQPainter_drawPixmap1(QPainter* qp, QPixmap* pm, int x, int y, int w, int h) {
    qp->drawPixmap(x, y, w, h, *pm);
}

// =========== QLCDNumber ==========
extern "C" MSVC_API  QLCDNumber* qteQLCDNumber_create1(QWidget* parent) {
    return new QLCDNumber(parent);
}
extern "C" MSVC_API  QLCDNumber* qteQLCDNumber_create2(QWidget* parent, int n) {
    return new QLCDNumber(n, parent);
}
extern "C" MSVC_API  void qteQLCDNumber_delete1(QLCDNumber* wd) {
#ifdef debDelete
    printf("del QLCDNumber --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQLCDNumber_display(QLCDNumber* wd, int n) {
    wd->display(n);
}
// 202
extern "C" MSVC_API  void qteQLCDNumber_setSegmentStyle(QLCDNumber* wd, QLCDNumber::SegmentStyle n) {
    wd->setSegmentStyle(n);
}
// 203
extern "C" MSVC_API  void qteQLCDNumber_setDigitCount(QLCDNumber* wd, int n) {
    wd->setDigitCount(n);
}
extern "C" MSVC_API  void qteQLCDNumber_setMode(QLCDNumber* wd, QLCDNumber::Mode n) {
    wd->setMode(n);
}
// =========== QAbstractSlider ==========
extern "C" MSVC_API  void qteQAbstractSlider_setXX(QAbstractSlider* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setMaximum(n);          break;
    case 1:   wd->setMinimum(n);          break;
    case 2:   wd->setPageStep(n);         break;
    case 3:   wd->setSingleStep(n);       break;
    case 4:   wd->setSliderPosition(n);   break;
    }
}
extern "C" MSVC_API  int qteQAbstractSlider_getXX(QAbstractSlider* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->maximum();         break;
    case 1:   rez = wd->minimum();         break;
    case 2:   rez = wd->pageStep();        break;
    case 3:   rez = wd->singleStep();      break;
    case 4:   rez = wd->sliderPosition();  break;
    case 5:   rez = wd->value();           break;
    }
    return rez;
}
// =========== QSlider ==========
extern "C" MSVC_API  QSlider* qteQSlider_create1(QWidget* parent, Qt::Orientation n) {
    return new QSlider(n, parent);
}
extern "C" MSVC_API  void qteQSlider_delete1(QSlider* wd) {
#ifdef debDelete
    printf("del QSlider --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// =========== QGroupBox ==========
extern "C" MSVC_API  QGroupBox* qteQGroupBox_create(QWidget* parent) {
    return new QGroupBox(parent);
}
extern "C" MSVC_API  void qteQGroupBox_delete(QGroupBox* wd) {
#ifdef debDelete
    printf("del QGroupBox --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQGroupBox_setTitle(QGroupBox* wd, QString* str) {
    wd->setTitle(*str);
}
extern "C" MSVC_API  void qteQGroupBox_setAlignment(QGroupBox* wd, Qt::AlignmentFlag str) {
    wd->setAlignment(str);
}
// =========== QCheckBox ==========
extern "C" MSVC_API  QCheckBox* qteQCheckBox_create1(QWidget* parent, QString* name) {
    return  new QCheckBox(*name, parent);
}
extern "C" MSVC_API  void qteQCheckBox_delete(QCheckBox* wd) {
#ifdef debDelete
    printf("del QCheckBox --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  int qteQCheckBox_checkState(QCheckBox* qs) {
    return (int)qs->checkState();
}
extern "C" MSVC_API  void qteQCheckBox_setCheckState(QCheckBox* qs, Qt::CheckState st) {
    qs->setCheckState(st);
}
extern "C" MSVC_API  void qteQCheckBox_setTristate(QCheckBox* qs, bool st) {
    qs->setTristate(st);
}
extern "C" MSVC_API  bool qteQCheckBox_isTristate(QCheckBox* qs) {
    return qs->isTristate();
}
// =========== QRadioButton ==========
extern "C" MSVC_API  QRadioButton* qteQRadioButton_create1(QWidget* parent, QString* name) {
    return  new QRadioButton(*name, parent);
}
extern "C" MSVC_API  void qteQRadioButton_delete(QRadioButton* wd) {
#ifdef debDelete
    printf("del QRadioButton --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// =========== QTextCursor ==========
extern "C" MSVC_API  QTextCursor* qteQTextCursor_create1(QTextDocument * document) {
    return  new QTextCursor(document);
}
extern "C" MSVC_API  QTextCursor* qteQTextCursor_create2() {
    return  new QTextCursor();
}
extern "C" MSVC_API  void qteQTextCursor_delete(QTextCursor* wd) {
#ifdef debDelete
    printf("del QTextCursor --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 327
extern "C" MSVC_API  void qteQTextCursor_setPosition(QTextCursor* wd, int n, QTextCursor::MoveMode mode) {
    wd->setPosition(n, mode);
}

extern "C" MSVC_API  int qteQTextCursor_getXX1(QTextCursor* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->anchor();           break;
    case 1:   rez = wd->blockNumber();      break;
    case 2:   rez = wd->columnNumber();     break;
    case 3:   rez = wd->position();         break;
    case 4:   rez = wd->positionInBlock();  break;
    case 5:   rez = wd->selectionEnd();     break;
    case 6:   rez = wd->selectionStart();   break;
    case 7:   rez = wd->verticalMovementX();break;
    }
    return rez;
}
// 255
extern "C" MSVC_API  void qteQTextCursor_runXX(QTextCursor* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->beginEditBlock();   break;
    case 1:   wd->clearSelection();   break;
    case 2:   wd->deleteChar();       break;
    case 3:   wd->deletePreviousChar();  break;
    case 4:   wd->endEditBlock();     break;
    case 5:   wd->insertBlock();      break;
    case 6:   wd->removeSelectedText();   break;
    }
}
extern "C" MSVC_API  void qteQTextCursor_insertText1(QTextCursor* wd, QString* name) {
    wd->insertText(*name);
}

// 254
extern "C" MSVC_API  bool qteQTextCursor_movePosition(
                QTextCursor* wd,
                QTextCursor::MoveOperation op,
                QTextCursor::MoveMode mode,
                int n) {
    return wd->movePosition(op, mode, n);
}
// 286
extern "C" MSVC_API  void qteQTextCursor_select(QTextCursor* wd, QTextCursor::SelectionType type) {
    wd->select(type);
}

/*
// Выделим Hello и покрасим в зелёный цвет
QTextCursor cursor = edit.textCursor();
cursor.movePosition(QTextCursor::Right, QTextCursor::KeepAnchor, 5);
QTextCharFormat charFormat;
charFormat.setBackground(Qt::green);
cursor.setCharFormat(charFormat);
//edit.setTextCursor(cursor); не нужен, курсор редактора остаётся в начале
// Выделим World и покрасим в синий цвет
cursor = edit.textCursor();
cursor.movePosition(QTextCursor::Right, QTextCursor::MoveAnchor, 6);
cursor.movePosition(QTextCursor::Right, QTextCursor::KeepAnchor, 5);
charFormat.setBackground(Qt::blue);
cursor.setCharFormat(charFormat);
*/

// =========== QRect ==========
extern "C" MSVC_API  QRect* qteQRect_create1() {
    return  new QRect();
}
extern "C" MSVC_API  void qteQRect_delete(QRect* wd) {
#ifdef debDelete
    printf("del QRect --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  int qteQRect_setXX1(QRect* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->x();           break;
    case 1:   rez = wd->y();           break;
    case 2:   rez = wd->width();       break;
    case 3:   rez = wd->height();      break;
    case 4:   rez = wd->left();        break;
    case 5:   rez = wd->right();       break;
    case 6:   rez = wd->top();         break;
    case 7:   rez = wd->bottom();      break;
    }
    return rez;
}
extern "C" MSVC_API  void qteQRect_setXX2(QRect* wd, int x1, int y1, int x2, int y2, int pr) {
    switch ( pr ) {
    case 0:   wd->setCoords(x1, y1, x2, y2);           break;
    case 1:   wd->setRect(x1, y1, x2, y2);           break;
    }
}

// =========== QTextBlock ==========
// 240
extern "C" MSVC_API  QTextBlock* qteQTextBlock_create2(QTextCursor* tk) {
    QTextBlock* tb = new QTextBlock();
    *tb = tk->block();
    return tb;
}
// 238
extern "C" MSVC_API  QTextBlock* qteQTextBlock_create() {
    return new QTextBlock();
}
// 239
extern "C" MSVC_API  void qteQTextBlock_delete(QTextBlock* wd) {
#ifdef debDelete
    printf("del QTextBlock --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}

// 237
extern "C" MSVC_API  QString* qteQTextBlock_text(QTextBlock* tb, QString* rez) {
    *rez = tb->text();
    return rez;
}
// 283
extern "C" MSVC_API  int qteQTextBlock_blockNumber(QTextBlock* tb) {
    return tb->blockNumber();
}

extern "C" MSVC_API  void qteQTextBlock_next2(QTextBlock* tb, QTextBlock* ntb, int pr) {
    switch ( pr ) {
    case 0:   *ntb = tb->next();           break;
    case 1:   *ntb = tb->previous();       break;
    }
}
extern "C" MSVC_API  bool qteQTextBlock_isValid2(QTextBlock* tb, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = tb->isValid();           break;
    case 1:   rez = tb->isVisible();         break;
    }
    return rez;
}

// =========== QAbstractSpinBox ==========
// 252
extern "C" MSVC_API  void qteQAbstractSpinBox_setReadOnly(QAbstractSpinBox* wd, bool f) {
    wd->setReadOnly(f);
}
// =========== QSpinBox ==========
// 247
extern "C" MSVC_API  QSpinBox* qteQSpinBox_create(QWidget* parent) {
    return new QSpinBox(parent);
}
// 248
extern "C" MSVC_API  void qteQSpinBox_delete(QSpinBox* wd) {
#ifdef debDelete
    printf("del QSpinBox --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 249
extern "C" MSVC_API  void qteQSpinBox_setXX1(QSpinBox* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setMinimum(n);           break;
    case 1:   wd->setMaximum(n);           break;
    case 2:   wd->setSingleStep(n);        break;
    case 3:   wd->setValue(n);             break;
    case 4:   wd->selectAll();             break;
    }
}
// 250
extern "C" MSVC_API  int qteQSpinBox_getXX1(QSpinBox* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->minimum();           break;
    case 1:   rez = wd->maximum();           break;
    case 2:   rez = wd->singleStep();        break;
    case 3:   rez = wd->value();             break;
    }
    return rez;
}
// 251
extern "C" MSVC_API  void qteQSpinBox_setXX2(QSpinBox* wd, QString *str, int pr) {
    switch ( pr ) {
    case 0:   wd->setPrefix(*str);           break;
    case 1:   wd->setSuffix(*str);           break;
    }
}

// =========== Highlighter ==========
Highlighter::Highlighter(QTextDocument *parent) : QSyntaxHighlighter(parent) {
     HighlightingRule rule;

     //Numbers
     classFormat.setForeground(Qt::red);
     rule.pattern = QRegExp("\\b\\d+(\\.)?\\d*\\b");
     rule.format = classFormat;
     highlightingRules.append(rule);

     // keywordFormat.setFontWeight(QFont::Bold);
     keywordFormat.setForeground(Qt::darkBlue);
     QStringList keywordPatterns;
     keywordPatterns << "\\bchar\\b" << "\\bclass\\b" << "\\bconst\\b"
                     << "\\bdouble\\b" << "\\benum\\b" << "\\bexplicit\\b"
                     << "\\bfriend\\b" << "\\binline\\b" << "\\bint\\b"
                     << "\\blong\\b" << "\\bnamespace\\b" << "\\boperator\\b"
                     << "\\bprivate\\b" << "\\bprotected\\b" << "\\bpublic\\b"
                     << "\\bshort\\b" << "\\bsignals\\b" << "\\bsigned\\b"
                     << "\\bslots\\b" << "\\bstatic\\b" << "\\bstruct\\b"
                     << "\\btemplate\\b" << "\\balias\\b" << "\\btypename\\b"
                     << "\\bunion\\b" << "\\buchar\\b" << "\\bvirtual\\b"

                     << "\\bbool\\b" << "\\buint\\b" << "\\bnew\\b"
                     << "\\bthis\\b" << "\\b~this\\b" << "\\bdelete\\b"
                     << "\\belse\\b" << "\\bbreak\\b" << "\\bcontinue\\b"
                     << "\\bmodule\\b" << "\\bimport\\b" << "\\bimmutable\\b"
                     << "\\breturn\\b" <<  "\\bif\\b" << "\\bnull\\b"

                     << "\\bstring\\b" << "\\bvoid\\b" << "\\bvolatile\\b";
     foreach (const QString &pattern, keywordPatterns) {
         rule.pattern = QRegExp(pattern);
         rule.format = keywordFormat;
         highlightingRules.append(rule);
     }

     // classFormat.setFontWeight(QFont::Bold);
     classFormat.setForeground(Qt::darkMagenta);
     rule.pattern = QRegExp("\\bQ[A-Za-z()]+\\b");
     rule.format = classFormat;
     highlightingRules.append(rule);

     // functionFormat.setFontItalic(true);
     functionFormat.setForeground(Qt::blue);
     rule.pattern = QRegExp("\\b[A-Za-z0-9_]+(?=\\()");
     rule.format = functionFormat;
     highlightingRules.append(rule);

     multiLineCommentFormat.setForeground(Qt::gray);

     quotationFormat.setForeground(Qt::darkGreen);
     rule.pattern = QRegExp("\".*\"");
     rule.format = quotationFormat;
     highlightingRules.append(rule);

     singleLineCommentFormat.setForeground(Qt::gray);
     rule.pattern = QRegExp("//[^\n]*");
     rule.format = singleLineCommentFormat;
     highlightingRules.append(rule);

     singleLineCommentFormat2.setForeground(Qt::darkRed);
     rule.pattern = QRegExp("//==[^\n]*");
     rule.format = singleLineCommentFormat2;
     highlightingRules.append(rule);


     commentStartExpression = QRegExp("/\\*");
     commentEndExpression = QRegExp("\\*/");
}

void Highlighter::highlightBlock(const QString &text) {
     foreach (const HighlightingRule &rule, highlightingRules) {
         QRegExp expression(rule.pattern);
         int index = expression.indexIn(text);
         while (index >= 0) {
             int length = expression.matchedLength();
             setFormat(index, length, rule.format);
             index = expression.indexIn(text, index + length);
         }
     }
     setCurrentBlockState(0);

     int startIndex = 0;
     if (previousBlockState() != 1)
         startIndex = commentStartExpression.indexIn(text);

     while (startIndex >= 0) {
         int endIndex = commentEndExpression.indexIn(text, startIndex);
         int commentLength;
         if (endIndex == -1) {
             setCurrentBlockState(1);
             commentLength = text.length() - startIndex;
         } else {
             commentLength = endIndex - startIndex
                             + commentEndExpression.matchedLength();
         }
         setFormat(startIndex, commentLength, multiLineCommentFormat);
         startIndex = commentStartExpression.indexIn(text, startIndex + commentLength);
     }
}

extern "C" MSVC_API  Highlighter* qteHighlighter_create(QTextDocument* parent) {
    return new Highlighter(parent);
}
extern "C" MSVC_API  void qteHighlighter_delete(Highlighter* wd) {
#ifdef debDelete
    printf("del Highlighter --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// ===================== QTextEdit ====================

eQTextEdit::eQTextEdit(QWidget *parent): QTextEdit(parent) {
    aKeyPressEvent = NULL; aDThis = NULL; aKeyReleaseEvent = NULL;
}
eQTextEdit::~eQTextEdit() {
}
void eQTextEdit::keyPressEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyPressEvent == NULL) {QTextEdit::keyPressEvent(event); return; }
    if (aKeyPressEvent != NULL) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QTextEdit::keyPressEvent(otv); }
    }
}
void eQTextEdit::keyReleaseEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyReleaseEvent == NULL) {QTextEdit::keyReleaseEvent(event); return; }
    if (aKeyReleaseEvent != NULL) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyReleaseEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QTextEdit::keyReleaseEvent(otv); }
    }
}
extern "C" MSVC_API  eQTextEdit* qteQTextEdit_create1(QWidget* parent) {
    return new eQTextEdit(parent);
}
extern "C" MSVC_API  void qteQTextEdit_delete1(eQTextEdit* wd) {
#ifdef debDelete
    printf("del eQTextEdit --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API  void qteQTextEdit_setKeyPressEvent(eQTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" MSVC_API  void qteQTextEdit_setKeyReleaseEvent(eQTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyReleaseEvent = adr;
    wd->aDThis = aThis;
}
// extern "C" MSVC_API  void qteQTextEdit_appendPlainText(QTextEdit* wd, QtRefH str) {
//    wd->appendPlainText((const QString &)*str);
// }
// extern "C" MSVC_API  void qteQTextEdit_appendHtml(QTextEdit* wd, QtRefH str) {
//    wd->appendHtml((const QString &)*str);
// }

extern "C" MSVC_API  void qteQTextEdit_setFromString(QTextEdit* wd, QString* str, int pr) {
    switch ( pr ) {
    case 0:   wd->setPlainText(*str);    break;
    case 1:   wd->insertPlainText(*str); break;
    case 2:   wd->setHtml(*str);         break;
    case 3:   wd->insertHtml(*str);      break;
    }
}
extern "C" MSVC_API  QString* qteQTextEdit_toString(QTextEdit* wd, QString* rez, int pr) {
    switch ( pr ) {
    case 0:   *rez = wd->toPlainText();     break;
    case 1:   *rez = wd->toHtml();          break;
    }
    return rez;
}
// 345
extern "C" MSVC_API  void qteQTextEdit_setBool(QTextEdit* wd, bool r, int pr) {
    switch ( pr ) {
    case 0:   wd->setAcceptRichText(r);     break;
    case 1:   wd->setOverwriteMode(r);      break;
    case 2:   wd->setReadOnly(r);           break;
    case 3:   wd->setTabChangesFocus(r);    break;
    case 4:   wd->setUndoRedoEnabled(r);    break;
    }
}
// 346
extern "C" MSVC_API  bool qteQTextEdit_toBool(QTextEdit* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->acceptRichText();           break;
    case 1:   rez = wd->canPaste();                 break;
    case 2:   rez = wd->fontItalic();               break;
    case 3:   rez = wd->fontUnderline();            break;
    case 4:   rez = wd->isReadOnly();               break;
    case 5:   rez = wd->isUndoRedoEnabled();        break;
    case 6:   rez = wd->overwriteMode();            break;
    case 7:   rez = wd->tabChangesFocus();          break;
    }
    return rez;
}




/*
extern "C" MSVC_API  void qteQTextEdit_setPlainText(QTextEdit* wd, QtRefH str) {
    wd->setPlainText((const QString &)*str);
}
extern "C" MSVC_API  void qteQTextEdit_insertPlainText(QTextEdit* wd, QtRefH str) {
    wd->insertPlainText((const QString &)*str);
}
*/
extern "C" MSVC_API  void qteQTextEdit_cutn(QTextEdit* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->cut();    break;
    case 1:   wd->clear();  break;
    case 2:   wd->paste();  break;
    case 3:   wd->copy();   break;
    case 4:   wd->selectAll();   break;
    case 5:   wd->selectionChanged();  break;
    // case 6:   wd->centerCursor();  break;
    case 7:   wd->undo();  break;
    case 8:   wd->redo();  break;
    }
}
extern "C" MSVC_API  void qteQTextEdit_toPlainText(QTextEdit* wd, QtRefH qs) {
    *(QString*)qs = wd->toPlainText();
}
extern "C" MSVC_API  QTextDocument* qteQTextEdit_document(QTextEdit* wd) {
    return wd->document();
}
// 230
extern "C" MSVC_API  void qteQTextEdit_textCursor(QTextEdit* wd, QTextCursor* tk) {
    *tk = wd->textCursor();
}
// 253
extern "C" MSVC_API  void qteQTextEdit_setTextCursor(QTextEdit* wd, QTextCursor* tk) {
    wd->setTextCursor(*tk);
}
extern "C" MSVC_API  void qteQTextEdit_cursorRect(QTextEdit* wd, QRect* tk) {
    *tk = wd->cursorRect();
}
extern "C" MSVC_API  void qteQTextEdit_setTabStopWidth(QTextEdit* wd, int width) {
    wd->setTabStopWidth(width);
}
// ===================== QTimer ====================
// 262
extern "C" MSVC_API  QTimer* qteQTimer_create(QObject* parent) {
    return new QTimer(parent);
}
// 263
extern "C" MSVC_API  void qteQTimer_delete(QTimer* wd) {
#ifdef debDelete
    printf("del QTimer --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 264
extern "C" MSVC_API  void qteQTimer_setInterval(QTimer* wd, int msek) {
    wd->setInterval(msek);
}
extern "C" MSVC_API  void qteQTimer_setStartInterval(QTimer* wd, int msek) {
    wd->start(msek);
}
// 265
extern "C" MSVC_API  int qteQTimer_getXX1(QTimer* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->interval();          break;
    case 1:   rez = wd->remainingTime();     break;
    case 2:   rez = wd->timerId();           break;
    case 3:         wd->start();             break;
    case 4:         wd->stop();              break;
    }
    return rez;
}
// 266
extern "C" MSVC_API  bool qteQTimer_getXX2(QTimer* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->isActive();          break;
    case 1:   rez = wd->isSingleShot();      break;
    }
    return rez;
}
// 267
extern "C" MSVC_API  void qteQTimer_setTimerType(QTimer* wd, Qt::TimerType t) {
    wd->setTimerType(t);
}
// 268
extern "C" MSVC_API  void qteQTimer_setSingleShot(QTimer* wd, bool t) {
    wd->setSingleShot(t);
}
// 269
extern "C" MSVC_API  Qt::TimerType qteQTimer_timerType(QTimer* wd) {
    return wd->timerType();
}
// ===================== QTextOption ====================
// 291
extern "C" MSVC_API  QTextOption* QTextOption_create() {
    return new QTextOption();
}
// 292
extern "C" MSVC_API  void QTextOption_delete(QTextOption* wd) {
#ifdef debDelete
    printf("del QTextOption* --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 293
extern "C" MSVC_API  void QTextOption_setWrapMode(QTextOption* wd, QTextOption::WrapMode mode) {
    wd->setWrapMode(mode);
}
// ===================== QFontMetrics ====================
// 295
extern "C" MSVC_API  QFontMetrics* QFontMetrics_create(QFont* fn) {
    return new QFontMetrics(*fn);
}
// 296
extern "C" MSVC_API  void QFontMetrics_delete(QFontMetrics* wd) {
#ifdef debDelete
    printf("del QFontMetrics* --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 297
extern "C" MSVC_API  int QFontMetrics_getXX1(QFontMetrics* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->ascent();           break;        // Подъем шрифта
    case 1:   rez = wd->averageCharWidth(); break;
    case 2:   rez = wd->descent();          break;
    case 3:   rez = wd->height();           break;
    case 4:   rez = wd->leading();          break;
    case 5:   rez = wd->lineSpacing();      break;
    case 6:   rez = wd->lineWidth();        break;
    case 7:   rez = wd->maxWidth();         break;
    case 8:   rez = wd->minLeftBearing();   break;
    case 9:   rez = wd->minRightBearing();  break;
    case 10:  rez = wd->overlinePos();      break;
    case 11:  rez = wd->strikeOutPos();     break;
    case 12:  rez = wd->underlinePos();     break;
    case 13:  rez = wd->xHeight();          break;
    }
    return rez;
}
// ===================== QImage ====================
// 303
extern "C" MSVC_API  QImage* qteQImage_create1() {
    return new QImage();
}
// 315
extern "C" MSVC_API  QImage* qteQImage_create2(int w, int h, QImage::Format f) {
    return new QImage(w, h, f);
}
// 316
extern "C" MSVC_API  void qteQImage_fill1(QImage* wd, QColor* cl) {
    wd->fill(*cl);
}
// 317
extern "C" MSVC_API  void qteQImage_fill2(QImage* wd, Qt::GlobalColor gc) {
    wd->fill( gc);
}
// 318
extern "C" MSVC_API  void qteQImage_setPixel1(QImage* wd, int x, int y, uint rgb) {
    wd->setPixel(x, y, rgb);
}
// 319
extern "C" MSVC_API  int qteQImage_getXX1(QImage* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->width();           break;
    case 1:   rez = wd->height();          break;
    case 2:   rez = wd->bitPlaneCount();   break;
    case 3:   rez = wd->byteCount();       break;
    case 4:   rez = wd->bytesPerLine();    break;
    case 5:   rez = wd->colorCount();      break;
    case 6:   rez = wd->depth();           break;
    case 7:   rez = wd->dotsPerMeterX();   break;
    case 8:   rez = wd->dotsPerMeterY();   break;
    }
    return rez;
}
// 321
extern "C" MSVC_API  QRgb qteQImage_pixel(QImage* wd, int x, int y) {
    return wd->pixel(x, y);
}

// 304
extern "C" MSVC_API  void qteQImage_delete(QImage* wd) {
#ifdef debDelete
    printf("del QImage* --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 305
extern "C" MSVC_API  bool qteQImage_load(QImage* im, QString* str) {
    return im->load(*str);
}
// ===================== QPoint ====================
// 306
extern "C" MSVC_API  QPoint* qteQPoint_create1(int x, int y) {
    QPoint* wd = new QPoint(x, y);
    return wd;
}
// 307
extern "C" MSVC_API  void qteQPoint_delete(QPoint* wd) {
#ifdef debDelete
    printf("del QPoint* --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 308
extern "C" MSVC_API  void qteQPoint_setXX1(QPoint* wd, int zn, int pr) {
    switch ( pr ) {
    case 0:   wd->setX(zn);           break;
    case 1:   wd->setY(zn);           break;
    }
}
// 309
extern "C" MSVC_API  int qteQPoint_getXX1(QPoint* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->x();           break;
    case 1:   rez = wd->y();           break;
    }
    return rez;
}
// ===================== QScriptEngine ====================
// 351
extern "C" MSVC_API QScriptEngine* QScriptEngine_create1(QObject* parent) {
    QScriptEngine* se = new QScriptEngine(parent);
    return se;
}
// 352
extern "C" MSVC_API void QScriptEngine_delete1(QScriptEngine* wd) {
    if(wd->parent() == NULL) delete wd;
}
// 353
extern "C" MSVC_API  void QScriptEngine_evaluate(QScriptValue* sv, QScriptEngine* se, QString* program, QString* fileName, int lineNumer)
{
    *sv = se->evaluate(  (const QString &)*program, (const QString &)*fileName, lineNumer);
}
// ===================== QScriptValue ====================

// 367
extern "C" MSVC_API QScriptValue* QScriptValue_createBool(void* parent, bool b) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(b);
}

// 366
extern "C" MSVC_API QScriptValue* QScriptValue_createInteger(void* parent, int n) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(n);
}

// 365
extern "C" MSVC_API QScriptValue* QScriptValue_createQstring(void* parent, QString* qs) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue(*qs);
}

// 354
extern "C" MSVC_API QScriptValue* QScriptValue_create1(void* parent) {
    if(parent != NULL) {} // обман компилятора ... от unused var
    return new QScriptValue();
}
// 355
extern "C" MSVC_API void QScriptValue_delete1(QScriptValue* wd) {
    delete wd;
}
// 356
extern "C" MSVC_API int QScriptValue_toInt32(QScriptValue* sv) {
    return sv->toInt32();
}
// 357
extern "C" MSVC_API  void QScriptValue_toString(QScriptValue* sv, QString* qs) {
    *qs = sv->toString();
}
// 358
extern "C" MSVC_API  void QScriptEngine_newQObject(QScriptValue* sv, QScriptEngine* se, QObject* qob)
{
    *sv = se->newQObject(qob);
}
// 359
extern "C" MSVC_API  void QScriptEngine_globalObject(QScriptValue* sv, QScriptEngine* se)
{
    *sv = se->globalObject();
}
// 360
extern "C" MSVC_API  void QScriptValue_setProperty(QScriptValue* glob, QScriptValue* sv, QString* qs)
{
    glob->setProperty(*qs, *sv);
}

// [Указатель на объект], [указатель на QScriptContext], [указатель на QScriptValue]
extern "C" typedef void (*ExecZIM_v__vp_vp_vp)(void*, void*, void*);

static QScriptValue getSetFoo(QScriptContext *context, QScriptEngine *engine)
{
    //bool f = false;
    QScriptValue callee = context->callee();
    int nom = context->argument(0).toInteger();

    void* aMet;
    void* aObj;

    aMet = tabCallDlang[nom].adrMet;
    aObj = *(void**)tabCallDlang[nom].adrObj;
    // printf("qarg = %s   sig = %s\n", (const char*)qarg.toStdString().c_str(), tabCallDlang[i].sig);

    // QString qs = context->argument(1).toString();
    ((ExecZIM_v__vp_vp_vp)aMet)(aObj, context, &(callee));
    //callee.setProperty("value", QScriptValue(engine, *qsRez));
    return callee.property("value");
    if(engine == NULL) {}
}
// 361
extern "C" MSVC_API  void QScriptEngine_callFunDlang(QScriptEngine* engine)
{
//    QScriptValue object = engine->newObject();
    engine->globalObject().setProperty("callFunDlang", engine->newFunction(getSetFoo));
}
// 362
// Установить делегат (ссылка на метод объекта D) по номеру nom
extern "C" MSVC_API  void QScriptEngine_setFunDlang(void* adrObj, void* adrMet, int nom)
{
    tabCallDlang[nom].adrMet = adrMet;
    tabCallDlang[nom].adrObj = adrObj;
}
// ===================== QScriptContext ====================
// 363
// Установить делегат (ссылка на метод объекта D) по номеру nom
extern "C" MSVC_API  int QScriptContext_argumentCount(QScriptContext* sc)
{
    return sc->argumentCount();
}
// 364
extern "C" MSVC_API  void QScriptContext_argument(QScriptContext* sc, QScriptValue* sv, int nom)
{
    *sv = sc->argument(nom);
}
// ===================== QPaintDevice ====================
// 379
extern "C" MSVC_API  int QPaintDevice_hw(QtRefH pd, int type, int pr)  {
    int rez = 0;
    if(type == 0) {
        switch ( pr ) {
        case 0:   rez = ((QWidget*)pd)->height();         break;
        case 1:   rez = ((QWidget*)pd)->width();          break;
        case 2:   rez = ((QWidget*)pd)->colorCount();     break;
        case 3:   rez = ((QWidget*)pd)->depth();          break;
        case 4:   rez = ((QWidget*)pd)->devicePixelRatio();      break;
        case 5:   rez = ((QWidget*)pd)->heightMM();       break;
        case 6:   rez = ((QWidget*)pd)->widthMM();        break;
        case 7:   rez = ((QWidget*)pd)->logicalDpiX();    break;
        case 8:   rez = ((QWidget*)pd)->logicalDpiY();    break;
        case 9:   rez = ((QWidget*)pd)->physicalDpiX();   break;
        case 10:  rez = ((QWidget*)pd)->physicalDpiY();   break;
        }
    }
    if(type == 1) {
        switch ( pr ) {
        case 0:   rez = ((QImage*)pd)->height();          break;
        case 1:   rez = ((QImage*)pd)->width();           break;
        case 2:   rez = ((QImage*)pd)->colorCount();      break;
        case 3:   rez = ((QImage*)pd)->depth();           break;
        case 4:   rez = ((QImage*)pd)->devicePixelRatio();       break;
        case 5:   rez = ((QImage*)pd)->heightMM();       break;
        case 6:   rez = ((QImage*)pd)->widthMM();        break;
        case 7:   rez = ((QImage*)pd)->logicalDpiX();    break;
        case 8:   rez = ((QImage*)pd)->logicalDpiY();    break;
        case 9:   rez = ((QImage*)pd)->physicalDpiX();   break;
        case 10:  rez = ((QImage*)pd)->physicalDpiY();   break;
        }
    }
    if(type == 2) {
        switch ( pr ) {
        case 0:   rez = ((QPixmap*)pd)->height();          break;
        case 1:   rez = ((QPixmap*)pd)->width();           break;
        case 2:   rez = ((QPixmap*)pd)->colorCount();      break;
        case 3:   rez = ((QPixmap*)pd)->depth();           break;
        case 4:   rez = ((QPixmap*)pd)->devicePixelRatio();       break;
        case 5:   rez = ((QPixmap*)pd)->heightMM();       break;
        case 6:   rez = ((QPixmap*)pd)->widthMM();        break;
        case 7:   rez = ((QPixmap*)pd)->logicalDpiX();    break;
        case 8:   rez = ((QPixmap*)pd)->logicalDpiY();    break;
        case 9:   rez = ((QPixmap*)pd)->physicalDpiX();   break;
        case 10:  rez = ((QPixmap*)pd)->physicalDpiY();   break;
        }
    }
    return rez;
}
// 380
extern "C" MSVC_API  bool QPaintDevice_pa(QtRefH pd, int type)  {
    bool rez = false;
    if(type == 0) {
        rez = ((QWidget*)pd)->paintingActive();
    }
    if(type == 1) {
        rez = ((QImage*)pd)->paintingActive();
    }
    return rez;
}
// ===================== QPixmap ====================
// 384
extern "C" MSVC_API QPixmap* QPixmap_create1() {
    return new QPixmap();
}
// 385
extern "C" MSVC_API void QPixmap_delete1(QPixmap* wd) {
    delete wd;
}
// 386
extern "C" MSVC_API QPixmap* QPixmap_create2(int width, int height) {
    return new QPixmap(width, height);
}
// 387
extern "C" MSVC_API QPixmap* QPixmap_create3(const QSize* size) {
    return new QPixmap(*size);
}
// 388
extern "C" MSVC_API void QPixmap_load1(QPixmap* wd, QString* fileName, const char* format, Qt::ImageConversionFlags flags) {
    wd->load(*fileName, format, flags);
}
// 394
extern "C" MSVC_API void QPixmap_fill(QPixmap* wd, QColor* color) {
    if(color == NULL) {
        wd->fill();
    } else {
        wd->fill(*color);
    }
}
// 397
extern "C" MSVC_API void QPixmap_setMask(QPixmap* wd, QBitmap* bm) {
    wd->setMask(*bm);
}
// ===================== QBitmap ====================
// 392
extern "C" MSVC_API QBitmap* QBitmap_create1() {
    return new QBitmap();
}
// 395
extern "C" MSVC_API QPixmap* QBitmap_create2(const QSize* size) {
    return new QBitmap(*size);
}
// 393
extern "C" MSVC_API void QBitmap_delete1(QBitmap* wd) {
    delete wd;
}

// =========== QResource ==========
// 398
extern "C" MSVC_API QResource* QResource_create1() {
    return new QResource();
}
// 399
extern "C" MSVC_API void QResource_delete1(QResource* wd) {
    delete wd;
}
// 400
extern "C" MSVC_API bool QResource_registerResource(QResource* wd, QString* rccFileName, QString* mapRoot, int pr) {
    bool rez;
    if(mapRoot == NULL) {
        if(pr == 0)   rez = wd->registerResource(*rccFileName);
        else          rez = wd->unregisterResource(*rccFileName);
    } else {
        if(pr == 0)   rez = wd->registerResource(*rccFileName, *mapRoot);
        else          rez = wd->unregisterResource(*rccFileName, *mapRoot);
    }
    return rez;
}
extern "C" MSVC_API bool QResource_registerResource2(QResource* wd, uchar* rccData, QString* mapRoot, int pr) {
    bool rez;
    if(mapRoot == NULL) {
        if(pr == 0)   rez = wd->registerResource(rccData);
        else          rez = wd->unregisterResource(rccData);
    } else {
        if(pr == 0)   rez = wd->registerResource(rccData, *mapRoot);
        else          rez = wd->unregisterResource(rccData, *mapRoot);
    }
    return rez;
}


// ===================== QStackedWidget ====================
// 402
extern "C" MSVC_API  QtRefH QStackedWidget_create1(QWidget* parent) {
    return (QtRefH)new QStackedWidget(parent);
}
// 403
extern "C" MSVC_API  void QStackedWidget_delete1(QStackedWidget* wd) {
#ifdef debDelete
    printf("del QStackedWidget --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 404
extern "C" MSVC_API  int QStackedWidget_setXX1(QStackedWidget* wd, QWidget* w, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->addWidget(w);       break;
    case 1:   rez = wd->count();            break;
    case 2:   rez = wd->currentIndex();     break;
    case 3:   rez = wd->indexOf(w);         break;
    case 4:         wd->removeWidget(w);    break;
    case 5:         wd->setCurrentWidget(w);break;
    }
    return rez;
}
// 405
extern "C" MSVC_API  QWidget* QStackedWidget_setXX2(QStackedWidget* wd, int w, int pr) {
    QWidget* rez = NULL;
    switch ( pr ) {
    case 0:   rez = wd->currentWidget();    break;
    case 1:   rez = wd->widget(w);          break;
    case 2:   wd->setCurrentIndex(w);       break;
    }
    return rez;
}
// 406
extern "C" MSVC_API  int QStackedWidget_setXX3(QStackedWidget* wd, QWidget* w, int pr) {
    return wd->insertWidget(pr, w);
}

// ===================== QTabBar ====================
// 407
extern "C" MSVC_API  QtRefH QTabBar_create1(QWidget* parent) {
    return (QtRefH)new QTabBar(parent);
}
// 408
extern "C" MSVC_API  void QTabBar_delete1(QTabBar* wd) {
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
// 409
extern "C" MSVC_API  int QTabBar_setXX1(QTabBar* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->currentIndex();     break;
    case 1:   rez = wd->count();            break;
    }
    return rez;
}
// 410
extern "C" MSVC_API  int QTabBar_addTab1(QTabBar* wd, QString* qs) {
    return wd->addTab(*qs);
}
// 411
extern "C" MSVC_API  void QTabBar_tabTextX1(QTabBar* wd, QString* qs, int index, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->tabText(index);              break;
    case 1:   *qs = wd->tabToolTip(index);           break;
    case 2:   *qs = wd->tabWhatsThis(index);         break;
    case 3:   *qs = wd->accessibleDescription();     break;
    case 4:   *qs = wd->accessibleName();            break;
    }
}
// 412
extern "C" MSVC_API  bool QTabBar_tabBoolX1(QTabBar* wd, int index, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->autoHide();              break;
    case 1:   rez = wd->changeCurrentOnDrag();              break;
    case 2:   rez = wd->documentMode();              break;
    case 3:   rez = wd->drawBase();              break;
    case 4:   rez = wd->expanding();              break;
    case 5:   rez = wd->isMovable();              break;
    case 6:   rez = wd->isTabEnabled(index);              break;
    case 7:   rez = wd->tabsClosable();              break;
    case 8:   rez = wd->usesScrollButtons();              break;
    }
    return rez;
}
// 413
extern "C" MSVC_API  int QTabBar_addTab2(QTabBar* wd, QString* qs, QIcon* icon) {
    return wd->addTab(*icon, *qs);
}
// 414
extern "C" MSVC_API  Qt::TextElideMode QTabBar_ElideMode(QTabBar* wd) {
    return wd->elideMode();
}
// 415
extern "C" MSVC_API  void QTabBar_iconSize(QTabBar* wd, QSize* size) {
    *size = wd->iconSize();
}

// 416
extern "C" MSVC_API  int QTabBar_addTab3(QTabBar* wd, QString* qs, QIcon* icon, int ind, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->insertTab(ind, *qs);     break;
    case 1:   rez = wd->insertTab(ind, *icon, *qs);     break;
    }
    return rez;
}
// 417
extern "C" MSVC_API  void QTabBar_moveTab1(QTabBar* wd, int a, int b, int pr) {
    switch ( pr ) {
    case 0:   wd->moveTab(a, b);     break;
    case 1:   wd->removeTab(a);      break;
    case 2:   wd->setCurrentIndex(a); break;
    }
}
// 418
extern "C" MSVC_API QTabBar::SelectionBehavior QTabBar_selectionBehaviorOnRemove(QTabBar* wd) {
    return wd->selectionBehaviorOnRemove();
}
// 419
extern "C" MSVC_API void QTabBar_set3(QTabBar* wd, bool b, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoHide(b);               break;
    case 1:   wd->setChangeCurrentOnDrag(b);    break;
    case 2:   wd->setDocumentMode(b);           break;
    case 3:   wd->setDrawBase(b);               break;
    case 4:   wd->setExpanding(b);              break;
    case 5:   wd->setMovable(b);                break;
    case 6:   wd->setTabsClosable(b);           break;
    case 7:   wd->setUsesScrollButtons(b);      break;
    }
}
// 420
extern "C" MSVC_API void QTabBar_setElideMode(QTabBar* wd, Qt::TextElideMode mod) {
    wd->setElideMode(mod);
}
// 421
extern "C" MSVC_API void QTabBar_setIconSize(QTabBar* wd, QSize* size) {
    wd->setIconSize(*size);
}
// 422
extern "C" MSVC_API void QTabBar_setShape(QTabBar* wd, QTabBar::Shape shape) {
    wd->setShape(shape);
}
// 423
extern "C" MSVC_API void QTabBar_setTabEnabled(QTabBar* wd, bool b, int index) {
    wd->setTabEnabled(index, b);
}
// 424
extern "C" MSVC_API void QTabBar_setX5(QTabBar* wd, void* ob, int index, int pr) {
    switch ( pr ) {
    case 0:   wd->setTabIcon(index,*((QIcon*)ob));        break;
    case 1:   wd->setTabText(index,*((QString*)ob));        break;
    case 2:   wd->setTabTextColor(index,*((QColor*)ob));        break;
    case 3:   wd->setTabToolTip(index,*((QString*)ob));        break;
    case 4:   wd->setTabWhatsThis(index,*((QString*)ob));        break;
    }
}
// 429
extern "C" MSVC_API void QTabBar_setPoint(QTabBar* wd, void* uk, int ind) {
    QVariant v; v.setValue(uk);
    wd->setTabData(ind, v);
}
// 430
extern "C" MSVC_API void* QTabBar_tabPoint(QTabBar* wd, int ind) {
    return (wd->tabData(ind)).value<void*>();
}
// 426
//extern "C" MSVC_API  int QTabBar_addTab4(QTabBar* wd, QString* qs, QIcon* icon, int ind, int pr) {
//    int rez = 0;
//    switch ( pr ) {
//    case 0:   rez = wd->insertTab(ind, *qs);     break;
//    case 1:   rez = wd->insertTab(ind, *icon, *qs);     break;
//    }
//    return rez;
//}
// ===================== QCoreApplication ====================
// 426
extern "C" MSVC_API  QtRefH QCoreApplication_create1(int* argc, char *argv[], int AnParam3) {
    return (QtRefH)new QCoreApplication(*argc, argv, AnParam3);
}
// 427
extern "C" MSVC_API  void QCoreApplication_delete1(QApplication* app) {
#ifdef debDelete
    printf("del QCoreApplication --> \n");
#endif
#ifdef debDestr
    // delete (QCoreApplication*)app;
    if(app->parent() == NULL) delete (QApplication*)app;
#endif
#ifdef debDelete
    printf("------------> Ok\n");
#endif
}

// Пример возврата объекта из С++
// --------------------------------
// extern "C" MSVC_API  void* proverka(QString* qs)  {
    // void** u = (void**)&(*qs);
    // return (void*)(*u);
//    return *((void**)&(*qs));
// }
