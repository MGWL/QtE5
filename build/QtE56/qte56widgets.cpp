// For MSVC set __declspec(dllexport), for MinGW do not
#ifdef _MSC_VER
    #define MSVC_API __declspec(dllexport)
#else
    #define MSVC_API
#endif

#include "qte56widgets.h"


// =========== QPointer ==========
// set QPointer for calculate point with C++ widgets

// 700
extern "C" MSVC_API QtRefH qteQPointer_create(int tp) {
    if(tp == 0) return (QtRefH)(new QPointer<eQWidget>());
    if(tp == 1) return (QtRefH)(new QPointer<QBoxLayout>());
    if(tp == 2) return (QtRefH)(new QPointer<QVBoxLayout>());
    if(tp == 3) return (QtRefH)(new QPointer<QHBoxLayout>());
    if(tp == 4) return (QtRefH)(new QPointer<QFrame>());
    if(tp == 5) return (QtRefH)(new QPointer<QLabel>());
    if(tp == 6) return (QtRefH)(new QPointer<eQMainWindow>());
    if(tp == 7) return (QtRefH)(new QPointer<QStatusBar>());
    if(tp == 8) return (QtRefH)(new QPointer<QPushButton>());
    if(tp == 9) return (QtRefH)(new QPointer<eAction>());
    if(tp == 10) return (QtRefH)(new QPointer<QApplication>());
    if(tp == 11) return (QtRefH)(new QPointer<eQLineEdit>());
    if(tp == 12) return (QtRefH)(new QPointer<eQPlainTextEdit>());
    if(tp == 13) return (QtRefH)(new QPointer<QMenu>());
    if(tp == 14) return (QtRefH)(new QPointer<QMenuBar>());
    if(tp == 15) return (QtRefH)(new QPointer<QFont>());
    if(tp == 16) return (QtRefH)(new QPointer<QIcon>());
    if(tp == 17) return (QtRefH)(new QPointer<QToolBar>());
    if(tp == 18) return (QtRefH)(new QPointer<QDialog>());
    if(tp == 19) return (QtRefH)(new QPointer<QMessageBox>());
    if(tp == 20) return (QtRefH)(new QPointer<QProgressBar>());
    if(tp == 21) return (QtRefH)(new QPointer<QMdiArea>());
    if(tp == 22) return (QtRefH)(new QPointer<QMdiSubWindow>());
    if(tp == 23) return (QtRefH)(new QPointer<QComboBox>());
    if(tp == 24) return (QtRefH)(new QPointer<QSlider>());
    if(tp == 25) return (QtRefH)(new QPointer<QGroupBox>());
    //---------
    if(tp == 26) return (QtRefH)(new QPointer<QTabBar>());
    if(tp == 27) return (QtRefH)(new QPointer<QStackedWidget>());
    if(tp == 28) return (QtRefH)(new QPointer<QLCDNumber>());
	//---------
	if(tp == 29) return (QtRefH)(new QPointer<QCommandLinkButton>());
	if(tp == 30) return (QtRefH)(new QPointer<QDockWidget>());
	if(tp == 31) return (QtRefH)(new QPointer<QSplitter>());
	if(tp == 32) return (QtRefH)(new QPointer<QDateTimeEdit>());
	if(tp == 33) return (QtRefH)(new QPointer<QFormBuilder>());
    if(tp == 34) return (QtRefH)(new QPointer<QTabWidget>());
    if(tp == 35) return (QtRefH)(new QPointer<QSpinBox>());
    return nullptr;
}
// 701
extern "C" MSVC_API void qteQPointer_delete(QtRefH wd, int tp) {
    if(tp == 0) delete (QPointer<eQWidget>*)wd;
    if(tp == 1) delete (QPointer<QBoxLayout>*)wd;
    if(tp == 2) delete (QPointer<QVBoxLayout>*)wd;
    if(tp == 3) delete (QPointer<QHBoxLayout>*)wd;
    if(tp == 4) delete (QPointer<QFrame>*)wd;
    if(tp == 5) delete (QPointer<QLabel>*)wd;
    if(tp == 6) delete (QPointer<eQMainWindow>*)wd;
    if(tp == 7) delete (QPointer<QStatusBar>*)wd;
    if(tp == 8) delete (QPointer<QPushButton>*)wd;
    if(tp == 9) delete (QPointer<eAction>*)wd;
    if(tp == 10) delete (QPointer<QApplication>*)wd;
    if(tp == 11) delete (QPointer<eQLineEdit>*)wd;
    if(tp == 12) delete (QPointer<eQPlainTextEdit>*)wd;
    if(tp == 13) delete (QPointer<QMenu>*)wd;
    if(tp == 14) delete (QPointer<QMenuBar>*)wd;
    if(tp == 15) delete (QPointer<QFont>*)wd;
    if(tp == 16) delete (QPointer<QIcon>*)wd;
    if(tp == 17) delete (QPointer<QToolBar>*)wd;
    if(tp == 18) delete (QPointer<QDialog>*)wd;
    if(tp == 19) delete (QPointer<QMessageBox>*)wd;
    if(tp == 20) delete (QPointer<QProgressBar>*)wd;
    if(tp == 21) delete (QPointer<QMdiArea>*)wd;
    if(tp == 22) delete (QPointer<QMdiSubWindow>*)wd;
    if(tp == 23) delete (QPointer<QComboBox>*)wd;
    if(tp == 24) delete (QPointer<QSlider>*)wd;
    if(tp == 25) delete (QPointer<QGroupBox>*)wd;
    //---------
    if(tp == 26) delete (QPointer<QTabBar>*)wd;
    if(tp == 27) delete (QPointer<QStackedWidget>*)wd;
    if(tp == 28) delete (QPointer<QLCDNumber>*)wd;
	//---------
    if(tp == 29) delete (QPointer<QCommandLinkButton>*)wd;
	if(tp == 30) delete (QPointer<QDockWidget>*)wd;
	if(tp == 31) delete (QPointer<QSplitter>*)wd;
	if(tp == 32) delete (QPointer<QDateTimeEdit>*)wd;
	if(tp == 33) delete (QPointer<QFormBuilder>*)wd;
    if(tp == 34) delete (QPointer<QTabWidget>*)wd;
    if(tp == 35) delete (QPointer<QSpinBox>*)wd;
}
// 702
extern "C" MSVC_API bool qteQPointer_isNull(QtRefH wd, int tp) {
    if(tp == 0) return ((QPointer<eQWidget>*)wd)->isNull();
    if(tp == 1) return ((QPointer<QBoxLayout>*)wd)->isNull();
    if(tp == 2) return ((QPointer<QVBoxLayout>*)wd)->isNull();
    if(tp == 3) return ((QPointer<QHBoxLayout>*)wd)->isNull();
    if(tp == 4) return ((QPointer<QFrame>*)wd)->isNull();
    if(tp == 5) return ((QPointer<QLabel>*)wd)->isNull();
    if(tp == 6) return ((QPointer<eQMainWindow>*)wd)->isNull();
    if(tp == 7) return ((QPointer<QStatusBar>*)wd)->isNull();
    if(tp == 8) return ((QPointer<QPushButton>*)wd)->isNull();
    if(tp == 9) return ((QPointer<eAction>*)wd)->isNull();
    if(tp == 10) return ((QPointer<QApplication>*)wd)->isNull();
    if(tp == 11) return ((QPointer<eQLineEdit>*)wd)->isNull();
    if(tp == 12) return ((QPointer<eQPlainTextEdit>*)wd)->isNull();
    if(tp == 13) return ((QPointer<QMenu>*)wd)->isNull();
    if(tp == 14) return ((QPointer<QMenuBar>*)wd)->isNull();
    if(tp == 15) return ((QPointer<QFont>*)wd)->isNull();
    if(tp == 16) return ((QPointer<QIcon>*)wd)->isNull();
    if(tp == 17) return ((QPointer<QToolBar>*)wd)->isNull();
    if(tp == 18) return ((QPointer<QDialog>*)wd)->isNull();
    if(tp == 19) return ((QPointer<QMessageBox>*)wd)->isNull();
    if(tp == 20) return ((QPointer<QProgressBar>*)wd)->isNull();
    if(tp == 21) return ((QPointer<QMdiArea>*)wd)->isNull();
    if(tp == 22) return ((QPointer<QMdiSubWindow>*)wd)->isNull();
    if(tp == 23) return ((QPointer<QComboBox>*)wd)->isNull();
    if(tp == 24) return ((QPointer<QSlider>*)wd)->isNull();
    if(tp == 25) return ((QPointer<QGroupBox>*)wd)->isNull();
    //---------
    if(tp == 26) return ((QPointer<QTabBar>*)wd)->isNull();
    if(tp == 27) return ((QPointer<QStackedWidget>*)wd)->isNull();
    if(tp == 28) return ((QPointer<QLCDNumber>*)wd)->isNull();
    //---------
    if(tp == 29) return ((QPointer<QCommandLinkButton>*)wd)->isNull();
    if(tp == 30) return ((QPointer<QDockWidget>*)wd)->isNull();
    if(tp == 31) return ((QPointer<QSplitter>*)wd)->isNull();
    if(tp == 32) return ((QPointer<QDateTimeEdit>*)wd)->isNull();
    if(tp == 33) return ((QPointer<QFormBuilder>*)wd)->isNull();
    if(tp == 34) return ((QPointer<QTabWidget>*)wd)->isNull();
    if(tp == 35) return ((QPointer<QSpinBox>*)wd)->isNull();
    return false;
}

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
extern "C" MSVC_API  QObject* qteQObject_findChild(QObject* qobj, QtRefH qs) {
    return qobj->findChild<QObject*>(*(QString*)qs);
}


// =========== QApplication ==========
// 0
extern "C" MSVC_API QtRefH qteQApplication_create1(QtRefH wd, int* argc, char *argv[], int AnParam3) {
    *((QPointer<QApplication>*)wd) = new QApplication(*argc, argv, AnParam3);
    return (QtRefH)( ((QPointer<QApplication>*)wd)->data() );
}
// 3
extern "C" MSVC_API  void qteQApplication_delete1(QApplication* app) {
    delete (QApplication*)app;
}

extern "C" MSVC_API  void qteQApplication_exe(QtRefH app, int pr) {
    switch ( pr ) {
    case 0:   ((QApplication*)app)->exec();                         break;
    case 1:   ((QApplication*)app)->processEvents();                break;
    case 2:   ((QApplication*)app)->aboutQt();                      break;
    case 3:   ((QApplication*)app)->quit();                         break;
    }
}

// 276
extern "C" MSVC_API  void qteQApplication_exit(QtRefH app, int kod) {
    ((QApplication*)app)->exit(kod);
}
// 277
extern "C" MSVC_API  void qteQApplication_setStyleSheet(QtRefH app, QString* str) {
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

// 20
extern "C" MSVC_API  void qteQAppCore_returnStr(QApplication* wd, QString* qs, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->applicationDirPath();    	break;  // QCore
    case 1:   *qs = wd->applicationFilePath();    	break;  // QCore
    case 2:   *qs = wd->applicationName();    		break;  // QCore
    case 3:   *qs = wd->applicationVersion();    	break;  // QCore
    case 4:  *qs = wd->objectName();    			break;  // QCore
    case 5:  *qs = wd->organizationDomain();    	break;  // QCore
    case 6:  *qs = wd->organizationName();    		break;  // QCore
    case 7:  *qs = wd->libraryPaths().join("|");	break;  // QCore
    case 8:  *qs = wd->arguments().join("|");    	break;  // QCore
    }
}

// 21
extern "C" MSVC_API  void qteQApp_returnStr(QApplication* wd, QString* qs, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->applicationDisplayName();   break;  // QGui
    case 1:   *qs = wd->desktopFileName();    		break;  // QGui
    case 2:   *qs = wd->styleSheet();    			break;  // QGui
    case 3:   *qs = wd->sessionId();    			break;  // QGui
    case 4:   *qs = wd->sessionKey();    			break;  // QGui
    case 5:   *qs = wd->platformName();    			break;  // QGui
    }
}



// =========== QWidget ==========
eQWidget::eQWidget(QWidget *parent, Qt::WindowFlags f): QWidget(parent, f) {
    aDThis = NULL;       // Save exemplar adress of object DLang
    aKeyPressEvent = NULL;
    aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
    aMousePressEvent = NULL;
    aMouseReleaseEvent = NULL;
	aMouseWheelEvent = NULL;
}
eQWidget::~eQWidget() {
}

/*
size_t aBEG_KeyPressEvent;      1001 -- 2001
size_t aBEG_PaintEvent;			1002 -- 2002
size_t aBEG_MouseWheelEvent;    1003 -- 2003
size_t aBEG_MousePressEvent;    1004 -- 2004
size_t aBEG_MouseReleaseEvent;  1005 -- 2005
size_t aBEG_CloseEvent;         1006 -- 2006
size_t aBEG_ResizeEvent;
*/

// -------------------------------------------------
extern "C" MSVC_API  void qteQWidget_setKeyPressEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aBEG_KeyPressEvent = 1001;
    ((eQWidget*)wd)->aKeyPressEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
    ((eQWidget*)wd)->aEND_KeyPressEvent = 2001;
}
void eQWidget::keyPressEvent(QKeyEvent *event) {
    if (aKeyPressEvent == NULL) return;
    if( aBEG_KeyPressEvent != 1001 ) return;
    if( aEND_KeyPressEvent != 2001 ) return;
    if ((aKeyPressEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aKeyPressEvent)(*(void**)aDThis, (void*)&event);
    }
    if ((aKeyPressEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aKeyPressEvent)((QtRefH)event);
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
// -------------------------------------------------


extern "C" MSVC_API  void qteQWidget_contentsRect(QWidget* wd, QRect* tk) {
    *tk = wd->contentsRect();
}
extern "C" MSVC_API  void qteQWidget_setGeometry(QWidget* wd, int x, int y, int w, int h) {
    wd->setGeometry(x, y, w, h);
}
extern "C" MSVC_API  void qteQWidget_setSizePolicy(QWidget* wd, QSizePolicy::Policy w, QSizePolicy::Policy h) {
    wd->setSizePolicy(w,  h);
}


// 5 +
extern "C" MSVC_API QtRefH qteQWidget_create1(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<eQWidget>*)wd) = new eQWidget((eQWidget*)parent, f);
    return (QtRefH)( ((QPointer<eQWidget>*)wd)->data() );
}
// 7 +
extern "C" MSVC_API  void qteQWidget_delete1(eQWidget* wd) {
    delete wd;
}
// 87 +
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
    case 11:  wd->activateWindow();      break;
    case 12:  wd->adjustSize();          break;
    case 13:  wd->clearFocus();          break;
    case 14:  wd->clearMask();           break;
    case 15:  wd->ensurePolished();      break;
    case 16:  wd->grabKeyboard();        break;
    case 17:  wd->grabMouse();           break;
    case 18:  wd->releaseKeyboard();     break;
    case 19:  wd->releaseMouse();        break;
    case 20:  wd->updateGeometry();      break;
    case 21:  wd->unsetCursor();         break;
    case 22:  wd->unsetLayoutDirection(); break;
    case 23:  wd->unsetLocale();         break;
    case 24:  wd->deleteLater();         break;
    case 25:  wd->repaint();             break;
    }
}
// 79 +
extern "C" MSVC_API  void qteQWidget_setMax1(QWidget* wd, int pr, int r) {
    switch ( pr ) {
    case 0:   wd->setMaximumWidth(r);    break;
    case 1:   wd->setMinimumWidth(r);    break;
    case 2:   wd->setMaximumHeight(r);   break;
    case 3:   wd->setMinimumHeight(r);   break;
    case 4:   wd->setFixedHeight(r);     break;
    case 5:   wd->setFixedWidth(r);      break;
    case 6:   wd->setToolTipDuration(r); break;
    case 7:   wd->releaseShortcut(r);    break;
    }
}

// 1011
extern "C" MSVC_API int QWidget_setXX5(QWidget* wd, QtRefH arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   wd->resize( *((QSize*)arg) );              break;  // void|resize|QSize::tt%nm
        case 1:   wd->setBaseSize(*((QSize*)arg));           break;  // void|setBaseSize|QSize::tt%nm
        case 2:   wd->setFixedSize(*((QSize*)arg));          break;  // void|setFixedSize|QSize::tt%s
        case 3:   wd->setMaximumSize(*((QSize*)arg));        break;  // void|setMaximumSize|QSize::tt%nm
        case 4:   wd->setMinimumSize(*((QSize*)arg));        break;  // void|setMinimumSize|QSize::tt%nm
        case 5:   wd->setSizeIncrement(*((QSize*)arg));      break;  // void|setSizeIncrement|QSize::tt%nm
    }
    return rez;
}


// 94
extern "C" MSVC_API int qteQWidget_exWin2(QWidget* wd, int arg1, int arg2, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   wd->move(arg1, arg2);                	break;  // void|move|int%x|int%y
        case 1:   wd->resize(arg1, arg2);   			break;  // void|resize|int%w|int%h
        case 2:   wd->scroll(arg1, arg2);   			break;  // void|scroll|int%dx|int%dy
        case 3:   wd->setAttribute((Qt::WidgetAttribute)arg1, (bool)arg2);   break;  // void|setAttribute|Qt::WidgetAttribute%attribute|bool%on
        case 4:   wd->setBaseSize(arg1, arg2);   		break;  // void|setBaseSize|int%basew|int%baseh
        case 5:   wd->setFixedSize(arg1, arg2);   		break;  // void|setFixedSize|int%w|int%h
        case 6:   wd->setMaximumSize(arg1, arg2);   	break;  // void|setMaximumSize|int%maxw|int%maxh
        case 7:   wd->setMinimumSize(arg1, arg2);   	break;  // void|setMinimumSize|int%minw|int%minh
        case 8:   wd->setShortcutAutoRepeat(arg1, (bool)arg2);   break;  // void|setShortcutAutoRepeat|int%id|bool%enable
        case 9:   wd->setShortcutEnabled(arg1, (bool)arg2);   break;  // void|setShortcutEnabled|int%id|bool%enable
        case 10:  wd->setSizeIncrement(arg1, arg2);   	break;  // void|setSizeIncrement|int%w|int%h
        case 11:  wd->setSizePolicy((QSizePolicy::Policy)arg1, (QSizePolicy::Policy)arg2);   break;  // void|setSizePolicy|QSizePolicy::Policy%horizontal|QSizePolicy::Policy%vertical
        case 12:  wd->setWindowFlag((Qt::WindowType)arg1, (bool)arg2);   break;  // void|setWindowFlag|Qt::WindowType%flag|bool%on
    }
    return rez;
}

// 94 +
/*
extern "C" MSVC_API  void qteQWidget_exWin2(QWidget* wd, int pr, int w, int h) {
    switch ( pr ) {
    case 0:   wd->move(w, h);                   break;
    case 1:   wd->resize(w, h);                 break;
    case 2:   wd->scroll(w, h);                 break;
    case 3:   wd->setBaseSize(w, h);            break;
    case 4:   wd->setFixedSize(w, h);           break;
    case 5:   wd->setMaximumSize(w, h);         break;
    case 6:   wd->setMinimumSize(w, h);         break;
    case 7:   wd->setSizeIncrement(w, h);       break;
    }
}
*/
// 11 +
extern "C" MSVC_API  void qteQWidget_setStr(QWidget* wd, QString* qs, int pr) {
    switch ( pr ) {
    case 0:   wd->setWindowTitle(*qs);    				break;  // ++
    case 1:   wd->setStyleSheet(*qs);               	break;
    case 2:   wd->setToolTip(*qs);                      break;
    case 3:   wd->setStatusTip(*qs);                    break;
    case 4:   wd->setWhatsThis(*qs);                    break;
    case 5:   wd->setWindowRole(*qs);                   break;
    case 6:   wd->setWindowFilePath(*qs);               break;
    case 7:   wd->setAccessibleDescription(*qs);        break;
    case 8:   wd->setAccessibleName(*qs);               break;
    }
}
// 521 +
extern "C" MSVC_API  void qteQWidget_returnStr(QWidget* wd, QString* qs, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->styleSheet();    				break;
    case 1:   *qs = wd->accessibleDescription();    	break;
    case 2:   *qs = wd->accessibleName(); 			   	break;
    case 3:   *qs = wd->statusTip();	 			   	break;
    case 4:   *qs = wd->toolTip();		 			   	break;
    case 5:   *qs = wd->whatsThis();					break;
    case 6:   *qs = wd->windowFilePath(); 				break;
    case 7:   *qs = wd->windowRole(); 					break;
    case 8:   *qs = wd->windowTitle(); 					break; // ++
    }
}
// 259 +
extern "C" MSVC_API  bool qteQWidget_getBoolXX(QWidget* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->hasFocus();                     break;
    case 1:   rez = wd->acceptDrops();                  break;
    case 2:   rez = wd->autoFillBackground();           break;
    case 3:   rez = wd->hasMouseTracking();             break;
    case 4:   rez = wd->isActiveWindow();               break;
    case 5:   rez = wd->isEnabled();                    break;
    case 6:   rez = wd->isFullScreen();                 break;
    case 7:   rez = wd->isHidden();                     break;
    case 8:   rez = wd->isMaximized();                  break;
    case 9:   rez = wd->isMinimized();                  break;
    case 10:  rez = wd->isModal();                      break;
    case 11:  rez = wd->isWindow();                     break;
    case 12:  rez = wd->isWindowModified();             break;
    case 13:  rez = wd->underMouse();                   break;
    case 14:  rez = wd->updatesEnabled();               break;
    case 15:  rez = wd->isVisible();                    break;  // ++
    }
    return rez;
}
// 6 +
extern "C" MSVC_API  void qteQWidget_setBoolNN(QWidget* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setDisabled(p);                       break;
    case 1:   wd->setEnabled(p);                        break;
    case 2:   wd->setHidden(p);                         break;
    case 3:   wd->setVisible(p);                        break;
    case 4:   wd->setWindowModified(p);                 break;
    case 5:   wd->setUpdatesEnabled(p);                 break;
    case 6:   wd->setTabletTracking(p);                 break;
    case 7:   wd->setMouseTracking(p);                  break;
    // case 8:   wd->set  > setEditFocus(p);            break;
    case 9:   wd->setAutoFillBackground(p);             break;
    case 10:  wd->setAcceptDrops(p);                    break;
    }
}
// 40 +
extern "C" MSVC_API  void qteQWidget_setLayout(QtRefH wd, QtRefH la) {
    ((QWidget*)wd)->setLayout((QLayout*)la);
}
// =========== QFormBuilder =====
extern "C" MSVC_API  QtRefH qteQFormBuilder_create1() {
    // *((QPointer<QFormBuilder>*)wd) = new QFormBuilder();
    // return (QtRefH)( ((QPointer<QFormBuilder>*)wd)->data() );
	return (QtRefH)(new QFormBuilder());
}
extern "C" MSVC_API  QtRefH qteQFormBuilder_load(QtRefH builder, QtRefH qs, QtRefH parent) {
	QFile file(*(QString*)qs);
    file.open(QFile::ReadOnly);
    QWidget *myWidget = ((QFormBuilder*)builder)->load(&file, (QWidget*)parent);
    file.close();
	return (QtRefH)myWidget;
}
extern "C" MSVC_API  void qteQFormBuilder_delete(QFormBuilder* wd) {
    delete wd;
}

// =========== QString ==========
// 8
extern "C" MSVC_API  QtRefH qteQString_create1(void) {
    return (QtRefH)new QString();
}
// QString из wchar
extern "C" MSVC_API  QtRefH qteQString_create2(QChar* s, int size) {
    return (QtRefH) new QString(s, size);
}
extern "C" MSVC_API  void qteQString_delete(QString* wd) {
    delete wd;
}
extern "C" MSVC_API  QtRefH qteQString_data(QtRefH qs) {
    return (QtRefH)((QString*)qs)->data();
}
extern "C" MSVC_API  int qteQString_size(QtRefH qs) {
    return ((QString*)qs)->size();
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
    delete wd;
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
    delete wd;
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
    delete wd;
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
    delete wd;
}

// =========== QLayout ========== Abstract Class
// 33
extern "C" MSVC_API  void qteQLayout_setEnable2(QtRefH wd, bool p) {
    ((QLayout*)wd)->setEnabled(p);
}

// =========== QBoxLayout ==========
// 34
extern "C" MSVC_API  QtRefH qteQBoxLayout(QtRefH wd, QtRefH parent, QBoxLayout::Direction dir) {
    *((QPointer<QBoxLayout>*)wd) = new QBoxLayout(dir, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QBoxLayout>*)wd)->data() );
}
// 32
extern "C" MSVC_API  void qteQBoxLayout_delete(QtRefH* wd) {
    delete (QBoxLayout*)wd;
}
// 37
extern "C" MSVC_API  void qteQHBoxLayout_delete(QtRefH* wd) {
    delete (QHBoxLayout*)wd;
}
// 30
extern "C" MSVC_API  void qteQVBoxLayout_delete(QtRefH* wd) {
    delete (QVBoxLayout*)wd;
}

extern "C" MSVC_API  void qteQBoxLayout_addWidget(QtRefH BoxLyout, QtRefH widget, int stretch, int align) {
    ((QBoxLayout*)BoxLyout)->addWidget((QWidget*)widget, stretch, (Qt::Alignment)align);
}
// 35
extern "C" MSVC_API  QtRefH qteQVBoxLayout(QtRefH wd, QtRefH parent) {
    *((QPointer<QVBoxLayout>*)wd) = new QVBoxLayout((QWidget*)parent);
    return (QtRefH)( ((QPointer<QVBoxLayout>*)wd)->data() );
}
// 36
extern "C" MSVC_API  QtRefH qteQHBoxLayout(QtRefH wd, QtRefH parent) {
    *((QPointer<QHBoxLayout>*)wd) = new QHBoxLayout((QWidget*)parent);
    return (QtRefH)( ((QPointer<QHBoxLayout>*)wd)->data() );
}

extern "C" MSVC_API  void qteQBoxLayout_addLayout(QtRefH BoxLyout, QtRefH layout) {
	((QBoxLayout*)BoxLyout)->addLayout((QBoxLayout*)layout);
}
extern "C" MSVC_API  void qteQBoxLayout_setSpacing(QBoxLayout* BoxLyout, int sp, int pr) {
    switch ( pr ) {
    case 0:   BoxLyout->setSpacing(sp);    break;
	case 3:   BoxLyout->addSpacing(sp);    break;		// NEW23
    case 1:   BoxLyout->addStretch(sp);    break;
    case 2:   BoxLyout->addStrut(sp);      break;
    }
}
extern "C" MSVC_API  void qteQBoxLayout_setSpacing2(QBoxLayout* BoxLyout, int s1, int s2, int pr) { // NEW23
    switch ( pr ) {
    case 0:   BoxLyout->insertSpacing(s1, s2);    break;  // NEW23
	case 1:   BoxLyout->insertStretch(s1, s2);    break;  // NEW23
    case 2:   BoxLyout->setStretch(s1, s2);       break;  // NEW23
    }
}

extern "C" MSVC_API  int qteQBoxLayout_spacing(QBoxLayout* BoxLyout) {
    return BoxLyout->spacing();
}
extern "C" MSVC_API  void qteQBoxLayout_setMargin(QBoxLayout* BoxLyout, int sp) {
    // BoxLyout->setMargin(sp);
}
extern "C" MSVC_API  int qteQBoxLayout_margin(QBoxLayout* BoxLyout) {
    return 0; // BoxLyout->margin();
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
extern "C" MSVC_API  QtRefH qteQFrame_create1(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<eQFrame>*)wd) = new eQFrame((eQWidget*)parent, f);
    return (QtRefH)( ((QPointer<eQFrame>*)wd)->data() );
}

extern "C" MSVC_API  void qteQFrame_delete1(eQFrame* wd) {
    delete wd;
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
// 45
extern "C" MSVC_API int QFrame_set1(QFrame* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = wd->frameStyle();   break;  // int|frameStyle|
        case 1:   rez = wd->frameWidth();   break;  // int|frameWidth|
        case 2:   rez = wd->lineWidth();   break;  // int|lineWidth|
        case 3:   rez = wd->midLineWidth();   break;  // int|midLineWidth|
        case 4:   wd->setFrameStyle(arg);   break;  // void|setFrameStyle|int%style
        case 5:   wd->setLineWidth(arg);   break;  // void|setLineWidth|int%width
        case 6:   wd->setMidLineWidth(arg);   break;  // void|setMidLineWidth|int%width
    }
    return rez;
}

extern "C" MSVC_API  void qteQFrame_listChildren(eQFrame* wd) {
    QObjectList list = wd->children();

    for(int i = 0; i != list.count(); i++) {
        printf("qt ==> %p\n", list[i]);
    }
}
// ===================== QDockWidget ====================
extern "C" MSVC_API  QtRefH qteQDockWidget_create1(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<QDockWidget>*)wd) = new QDockWidget((QWidget*)parent, f);
    return (QtRefH)( ((QPointer<QDockWidget>*)wd)->data() );
}
extern "C" MSVC_API  void qteQDockWidget_delete1(QDockWidget* wd) {
    delete wd;
}
extern "C" MSVC_API  void qteQDockWidget_setAllowedAreas(QDockWidget* wd, Qt::DockWidgetAreas fl) {
    wd->setAllowedAreas(fl);
}
extern "C" MSVC_API  void qteQDockWidget_setXX(QDockWidget* wd, QWidget* s, int pr) {
    switch ( pr ) {
        case 0:   wd->setWidget(s);              	break;
        case 1:   wd->setTitleBarWidget(s);         break;
    }
}

// ===================== QSplitter ====================
extern "C" MSVC_API  QtRefH qteQSplitter_create1(QtRefH wd, QWidget *parent, Qt::Orientation orientation) {
    *((QPointer<QSplitter>*)wd) = new QSplitter(orientation, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QSplitter>*)wd)->data() );
}
extern "C" MSVC_API  void qteQSplitter_delete1(QSplitter* wd) {
    delete wd;
}
extern "C" MSVC_API  void qteQSplitter_addWidgetXX1(QSplitter* wd, QWidget* awd, int pr) {
    switch ( pr ) {
        case 0:   wd->addWidget(awd);         break;
        case 1:   wd->refresh();              break;
    }
}
// 273
extern "C" MSVC_API int QSplitter_set1(QSplitter* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->childrenCollapsible();   	break;  // bool|childrenCollapsible|
        case 1:   rez = wd->count();   						break;  // int|count|
        case 2:   rez = wd->handleWidth();   				break;  // int|handleWidth|
        case 3:   rez = (int)wd->isCollapsible(arg);   		break;  // bool|isCollapsible|int%index
        case 4:   rez = (int)wd->opaqueResize();   			break;  // bool|opaqueResize|
        case 5:   wd->refresh();   							break;  // void|refresh|
        case 6:   wd->setOpaqueResize((bool)arg);   		break;  // void|setOpaqueResize|bool%opaque
    }
    return rez;
}
// ===================== QTabWidget ====================
// 492
extern "C" MSVC_API  QtRefH QTabWidget_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<QTabWidget>*)wd) = new QTabWidget((QWidget *)parent);
    return (QtRefH)( ((QPointer<QTabWidget>*)wd)->data() );
}
// 493
extern "C" MSVC_API  void QTabWidget_delete1(QTabWidget* wd) {
    delete wd;
}
// 494
extern "C" MSVC_API int QTabWidget_addTab1(QtRefH wd, QtRefH page, QtRefH qs) {
	return ((QTabWidget*)wd)->addTab((QWidget*)page, *(QString*)qs);
}
// 495
extern "C" MSVC_API int QTabWidget_addTab2(QtRefH wd, QtRefH page, QtRefH icon, QtRefH qs) {
	return ((QTabWidget*)wd)->addTab((QWidget*)page, *(QIcon*)icon, *(QString*)qs);
}
// 496
extern "C" MSVC_API int QTabWidget_set1(QTabWidget* wd, int arg, int pr) {
	int rez = 0;
    switch ( pr ) {
        case 0:   wd->clear();                break;
        case 1:   rez = wd->count();          break;
        case 2:   rez = wd->currentIndex();   break;
		case 3:   if(wd->documentMode()) rez = 1; else rez = 0; break;
		case 4:   rez = wd->elideMode();      break;
		case 5:   if(wd->isMovable()) rez = 1; else rez = 0; break;
        case 6:   if(wd->isTabEnabled(arg)) rez = 1; else rez = 0; break;
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        case 7:   rez = 0; break;
#else
        case 7:   if(wd->isTabVisible(arg)) rez = 1; else rez = 0; break;
#endif
		case 8:   wd->removeTab(arg);         break;
		case 9:   wd->setDocumentMode(arg);   break; 
		case 10:  wd->setElideMode((Qt::TextElideMode)arg);  break; 
		case 11:  wd->setMovable(arg);        break;
		case 12:  wd->setTabBarAutoHide(arg); break;
		case 13:  wd->setTabsClosable(arg);   break;
		case 14:  wd->setUsesScrollButtons(arg);   break;
		case 15:  if(wd->tabBarAutoHide())  rez = 1; else rez = 0; break;
        case 16:  rez = wd->tabPosition();    break;
        case 17:  rez = wd->tabShape();       break;
		case 18:  if(wd->tabsClosable()) rez = 1; else rez = 0; break;
		case 19:  if(wd->usesScrollButtons()) rez = 1; else rez = 0; break;
		case 20:  wd->setCurrentIndex(arg);   break; 
		case 21:  wd->setTabPosition((QTabWidget::TabPosition)arg); break;
		case 22:  wd->setTabShape((QTabWidget::TabShape)arg); break;
    }
	return rez;
}
// 497
extern "C" MSVC_API int QTabWidget_set2(QTabWidget* wd, int arg1, int arg2, int pr) {
	int rez = 0;
    switch ( pr ) {
        case 0:   wd->setTabEnabled(arg1, (bool)arg2);                break;
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        case 7:   rez = 0; break;
#else
        case 1:   wd->setTabVisible(arg1, (bool)arg2);                break;
#endif
    }
	return rez;
}
// 498 +
extern "C" MSVC_API  void QTabWidget_set3(QTabWidget* wd, QString* qs, int arg, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->tabText(arg);    				break;
    case 1:   *qs = wd->tabToolTip(arg);             	break;
    case 2:   *qs = wd->tabWhatsThis(arg); 			   	break;
    }
}
extern "C" MSVC_API  void QTabWidget_set4(QTabWidget* wd, QString* qs, int arg, int pr) {
    switch ( pr ) {
    case 0:   wd->setTabText(arg, *(QString*)qs);		break;
    case 1:   wd->setTabToolTip(arg, *(QString*)qs);	break;
    case 2:   wd->setTabWhatsThis(arg, *(QString*)qs);	break;
    }
}

// ===================== QLabel ====================
extern "C" MSVC_API  QtRefH qteQLabel_create1(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<QLabel>*)wd) = new QLabel((QLabel*)parent, f);
    return (QtRefH)( ((QPointer<QLabel>*)wd)->data() );
}
extern "C" MSVC_API  void qteQLabel_delete1(QLabel* wd) {
    delete wd;
}
extern "C" MSVC_API  void qteQLabel_setText(QtRefH wd, QtRefH qs) {
    ((QLabel*)wd)->setText(*(QString*)qs);
}
extern "C" MSVC_API  void qteQLabel_setPixmap(QLabel* wd, QPixmap* pm) {
    wd->setPixmap(*pm);
}
// 522
extern "C" MSVC_API  void qteQLabel_setAligment(QLabel* wd, Qt::Alignment alg) {
    wd->setAlignment(alg);
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
#if QT_VERSION == QT_VERSION_CHECK(5, 15, 2)
	if(QT_VERSION == QT_VERSION_CHECK(5, 15, 2)) {
		switch ( pr ) {
		case 0:   rez = ev->position().toPoint().x();    break;
		case 1:   rez = ev->position().toPoint().y();    break;
		case 2:   rez = ev->globalPosition().toPoint().x();    break;
		case 3:   rez = ev->globalPosition().toPoint().y();    break;
		}
	}
#endif
#if QT_VERSION == QT_VERSION_CHECK(5, 12, 7)
    if(QT_VERSION == QT_VERSION_CHECK(5, 12, 7)) {
		switch ( pr ) {
        case 0:   rez = ev->pos().x();    break;
        case 1:   rez = ev->pos().y();    break;
        case 2:   rez = ev->globalPos().x();    break;
        case 3:   rez = ev->globalPos().y();    break;
		}
	}
#endif
    return rez;
}
//437
extern "C" MSVC_API  void qteQMouseangleDelta(QWheelEvent* ev, QPoint* point, int pr) {
#if QT_VERSION == QT_VERSION_CHECK(5, 15, 2)
    switch ( pr ) {
    case 0:   *point = ev->angleDelta();    break;
    case 1:   *point = ev->globalPosition().toPoint();   break;
    case 2:   *point = ev->pixelDelta();    break;
    case 3:   *point = ev->position().toPoint();         break;
    }
#endif
#if QT_VERSION == QT_VERSION_CHECK(5, 12, 7)
    switch ( pr ) {
    case 0:   *point = ev->angleDelta();    break;
    case 1:   *point = ev->globalPos();   break;
    case 2:   *point = ev->pixelDelta();    break;
    case 3:   *point = ev->pos();         break;
    }
#endif

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
// ===================== QStringList ====================
// 680
extern "C" MSVC_API  QtRefH qteQStringList_create1() {
    return (QtRefH)new QStringList();
}
// 679
extern "C" MSVC_API  void qteQStringList_delete1(QStringList* wd) {
    delete wd;
}
// 678
extern "C" MSVC_API  void qteQStringList_set(QStringList* qw, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   qw->append(*qstr); break;
    case 1:   qw->prepend(*qstr);  break;
    case 2:   qw->clear();  break;
    }
}
// 677
extern "C" MSVC_API  int qteQStringList_getInt(QStringList* qw, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = qw->size(); break;
    case 1:   rez = qw->removeDuplicates();  break;
    }
    return rez;
}
// 676
extern "C" MSVC_API  void qteQStringList_getQStr1(QStringList* wd, QString* qs, int arg, int pr) {
    switch ( pr ) {
    case 0:   *qs = wd->at(arg);    				break;
    case 1:   *qs = wd->constFirst();    	break;
    case 2:   *qs = wd->constLast();    	break;
    case 3:   *qs = wd->join(QChar(arg));  	break;
    }
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
extern "C" MSVC_API QtRefH qteQPlainTextEdit_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<eQPlainTextEdit>*)wd) = new eQPlainTextEdit((eQWidget*)parent);
    return (QtRefH)( ((QPointer<eQPlainTextEdit>*)wd)->data() );
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
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
extern "C" MSVC_API bool qteQPlainTextEdit_find2(QPlainTextEdit* wd, QRegExp* qs, QTextDocument::FindFlags fl) {
#else
extern "C" MSVC_API bool qteQPlainTextEdit_find2(QPlainTextEdit* wd, QRegularExpression* qs, QTextDocument::FindFlags fl) {
#endif
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
    wd->setTabStopDistance(double(width));
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

// 95                           
extern "C" MSVC_API QtRefH qteQAction_create(QtRefH wd, QtRefH parent) {
    *((QPointer<eAction>*)wd) = new eAction((eQWidget*)parent);
    return (QtRefH)( ((QPointer<eAction>*)wd)->data() );
}
// 96
extern "C" MSVC_API  void  qteQAction_delete(eAction* wd)      {
	delete wd;
}
// 98
extern "C" MSVC_API  void qteQAction_setSlotN2(eAction* slot, void* adr, void* adrTh, int n) {
    slot->aSlotN = adr;
    slot->aDThis = adrTh;
    slot->N = n;
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
extern "C" typedef void  (*ExecZIM_ANQS)(void*, int, void*);
void eAction::Slot_ANQS(QString qs) {
    if (aSlotN != NULL)  ((ExecZIM_ANQS)aSlotN)(*(void**)aDThis, N, (void*)&qs);
}

//--------- СверхНовые сигналы ---------------
void eAction::sendSignal_V() {    emit Signal_V(); }
extern "C" MSVC_API  void qteQAction_SendSignal_V(eAction* qw) { qw->sendSignal_V(); }

void eAction::sendSignal_VI(int n) {    emit Signal_VI(n); }
extern "C" MSVC_API  void qteQAction_SendSignal_VI(eAction* qw, int n) { qw->sendSignal_VI(n); }

void eAction::sendSignal_VS(QString* s) {    emit Signal_VS(*s); }
extern "C" MSVC_API  void qteQAction_SendSignal_VS(eAction* qw, QString* s) { qw->sendSignal_VS(s); }

// -------------------------------------------------------
// 460
extern "C" MSVC_API  QString* qteQAction_getQStr(eAction* qw) {  return &qw->m_qstr; }
// 461
extern "C" MSVC_API  void qteQAction_setQStr(eAction* qw, QString* pqs) {  qw->setQstr(*pqs); }
// 462
extern "C" MSVC_API  int qteQAction_getInt(eAction* qw) {  return qw->m_qint; }
// 463
extern "C" MSVC_API  void qteQAction_setInt(eAction* qw, int pqs) {  qw->setQint(pqs); }

// -------------------------------------------------------

extern "C" MSVC_API  void* qteQAction_getParent(eAction* qw) {
    return qw->parent();
}

extern "C" MSVC_API  void qteQAction_setXX1(eAction* qw, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   qw->setText(*qstr);       break;
    case 1:   qw->setToolTip(*qstr);    break;
    }
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
//273
extern "C" MSVC_API  bool qteQAction_boolAll(eAction *act, int pr) {
	bool rez = false;
    switch ( pr ) {
    case 0:   rez = act->autoRepeat();       			break;
    case 1:   rez = act->isCheckable();       			break;
    case 2:   rez = act->isChecked();       			break;
    case 3:   rez = act->isEnabled();       			break;
    case 4:   rez = act->isIconVisibleInMenu();       	break;
    case 5:   rez = act->isSeparator();       			break;
    case 6:   rez = act->isShortcutVisibleInContextMenu();       break;
    case 7:   rez = act->isVisible();       			break;
	}
    return rez;
}
extern "C" MSVC_API  void qteQAction_setSlotN(eAction* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}





// =========== QPushButton =========
extern "C" MSVC_API  QtRefH qteQPushButton_create1(QtRefH wd, QtRefH parent, QtRefH name) {
    *((QPointer<QPushButton>*)wd) = new QPushButton((const QString &)*name, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QPushButton>*)wd)->data() );
}
extern "C" MSVC_API  void qteQPushButton_delete(QPushButton* wd) {
	delete wd;
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
// 209
/*
extern "C" MSVC_API  void qteQAbstractButton_setXX(QAbstractButton* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoExclusive(p); break;
    case 1:   wd->setAutoRepeat(p);    break;
    case 2:   wd->setCheckable(p);     break;
    case 3:   wd->setDown(p);          break;
    case 4:   wd->setChecked(p);       break;
    }
}
*/
// Новый вариант ...
// 209
extern "C" MSVC_API int qteQAbstractButton_setXX(QAbstractButton* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->autoExclusive();   break;  // bool|autoExclusive|
        case 1:   rez = (int)wd->autoRepeat();      break;  // bool|autoRepeat|
        case 2:   rez = wd->autoRepeatDelay();      break;  // int|autoRepeatDelay|
        case 3:   rez = wd->autoRepeatInterval();   break;  // int|autoRepeatInterval|
        case 4:   rez = (int)wd->isCheckable();     break;  // bool|isCheckable|
        case 5:   rez = (int)wd->isChecked();       break;  // bool|isChecked|
        case 6:   rez = (int)wd->isDown();          break;  // bool|isDown|
        case 7:   wd->setAutoExclusive((bool)arg);  break;  // void|setAutoExclusive|bool%xz
        case 8:   wd->setAutoRepeat((bool)arg);     break;  // void|setAutoRepeat|bool%xz
        case 9:   wd->setAutoRepeatDelay(arg);      break;  // void|setAutoRepeatDelay|int%xz
        case 10:   wd->setAutoRepeatInterval(arg);  break;  // void|setAutoRepeatInterval|int%xz
        case 11:   wd->setCheckable((bool)arg);     break;  // void|setCheckable|bool%xz
        case 12:   wd->setDown((bool)arg);          break;  // void|setDown|bool%xz
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        case 13:   wd->animateClick(arg);           break;  // void|animateClick|int%msec
#else
        case 13:              break;  // void|animateClick|int%msec
#endif		
        case 14:   wd->click();                     break;  // void|click|
        case 15:   wd->setChecked((bool)arg);       break;  // void|setChecked|bool%xz
        case 16:   wd->toggle();                    break;  // void|toggle|
    }
    return rez;
}




extern "C" MSVC_API  void qteQAbstractButton_setIcon(QAbstractButton* wd, QIcon* p) {
    wd->setIcon(*p);
}
// 224
/*
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
*/

// =========== QSlot ==========

// 27
extern "C" MSVC_API  void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
// 343
extern "C" MSVC_API  void qteDisconnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot) {
    QObject::disconnect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot);
}

// =========== QStatusBar ==========
extern "C" MSVC_API QtRefH qteQStatusBar_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<QStatusBar>*)wd) = new QStatusBar((QWidget*)parent);
    return (QtRefH)( ((QPointer<QStatusBar>*)wd)->data() );
}
extern "C" MSVC_API  void qteQStatusBar_delete1(QStatusBar* wd) {
    delete wd;
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
eQMainWindow::eQMainWindow(QWidget *parent, Qt::WindowFlags f): QMainWindow(parent, f) {}
eQMainWindow::~eQMainWindow() {}

extern "C" MSVC_API QtRefH qteQMainWindow_create1(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<eQMainWindow>*)wd) = new eQMainWindow((eQWidget*)parent, f);
    return (QtRefH)( ((QPointer<eQMainWindow>*)wd)->data() );
}

extern "C" MSVC_API  void qteQMainWindow_delete1(eQMainWindow* wd) {
    delete wd;
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
extern "C" MSVC_API  void qteQMainWindow_addDockWidget(QMainWindow* wd, QDockWidget* s, Qt::DockWidgetArea pr) {
    wd->addDockWidget(pr, s);
}

// =========== QLineEdit ==========
eQLineEdit::eQLineEdit(QWidget *parent): QLineEdit(parent) { aKeyPressEvent = NULL; aDThis = NULL; }
eQLineEdit::~eQLineEdit() {}

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
// extern "C" MSVC_API  eQLineEdit* qteQLineEdit_create1(QWidget* parent) {
//     return new eQLineEdit(parent);
// }

extern "C" MSVC_API QtRefH qteQLineEdit_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<eQLineEdit>*)wd) = new eQLineEdit((eQWidget*)parent);
    return (QtRefH)( ((QPointer<eQLineEdit>*)wd)->data() );
}



extern "C" MSVC_API  void qteQLineEdit_delete1(eQLineEdit* wd) {
	delete wd;
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
// ================= QMenu ==================================
extern "C" MSVC_API QtRefH qteQMenu_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QMenu>*)wd) = new QMenu((QWidget*)parent);
    return (QtRefH)( ((QPointer<QMenu>*)wd)->data() );
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
extern "C" MSVC_API QtRefH qteQMenuBar_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QMenuBar>*)wd) = new QMenuBar((QWidget*)parent);
    return (QtRefH)( ((QPointer<QMenuBar>*)wd)->data() );
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
extern "C" MSVC_API   QtRefH qteQFont_create() {
    return (QtRefH)(new QFont());
}
/*
extern "C" MSVC_API QtRefH qteQFont_create(QtRefH wd) {
    *((QPointer<QFont>*)wd) = new QFont();
    return (QtRefH)( ((QPointer<QFont>*)wd)->data() );
}
*/
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
extern "C" MSVC_API   QtRefH qteQIcon_create() {
    return (QtRefH)(new QIcon());
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
/*
extern "C" MSVC_API   void* qteQToolBar_create() {
    return new QToolBar();
}
*/
extern "C" MSVC_API QtRefH qteQToolBar_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QToolBar>*)wd) = new QToolBar((QWidget*)parent);
    return (QtRefH)( ((QPointer<QToolBar>*)wd)->data() );
}


extern "C" MSVC_API  void qteQToolBar_delete(QToolBar* wd) {
	delete wd;
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
/*
extern "C" MSVC_API  QDialog* qteQDialog_create(QWidget* parent, Qt::WindowFlags f) {
    return new QDialog(parent, f);
}
*/
extern "C" MSVC_API QtRefH qteQDialog_create(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<QDialog>*)wd) = new QDialog((QWidget*)parent, f);
    return (QtRefH)( ((QPointer<QDialog>*)wd)->data() );
}


extern "C" MSVC_API  void qteQDialog_delete(QDialog* wd) {
	delete wd;
}
/*
extern "C" MSVC_API  int qteQDialog_exec(QDialog* wd) {
    return wd->exec();
}
*/
// 306
extern "C" MSVC_API int QDialog_setXX1(QDialog* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->isSizeGripEnabled();   break;  // bool|isSizeGripEnabled|
        case 1:   rez = wd->result();                   break;  // int|result|
        case 2:   wd->setModal((bool)arg);              break;  // void|setModal|bool%modal
        case 3:   wd->setResult(arg);                   break;  // void|setResult|int%i
        case 4:   wd->setSizeGripEnabled((bool)arg);    break;  // void|setSizeGripEnabled|bool%xz
        case 5:   wd->setVisible((bool)arg);            break;  // void|setVisible|bool%visible
        case 6:   wd->accept();                         break;  // void|accept|
        case 7:   wd->done(arg);                        break;  // void|done|int%r
        case 8:   rez = wd->exec();                     break;  // int|exec|
        case 9:   wd->open();                           break;  // void|open|
        case 10:  wd->reject();                         break;  // void|reject|
    }
    return rez;
}




// ============ QMessageBox ====================================
/*
extern "C" MSVC_API  QMessageBox* qteQMessageBox_create(QWidget* parent) {
    return new QMessageBox(parent);
}
*/
extern "C" MSVC_API QtRefH qteQMessageBox_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QMessageBox>*)wd) = new QMessageBox((QWidget*)parent);
    return (QtRefH)( ((QPointer<QMessageBox>*)wd)->data() );
}

extern "C" MSVC_API  void qteQMessageBox_delete(QMessageBox* wd) {
	delete wd;
}
// 122
extern "C" MSVC_API int QMessageBox_setXX1(QMessageBox* wd, int arg, QString* qsOut, QString* qsIn, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   *qsOut = wd->detailedText();       break;  // QString|detailedText|
        case 1:   *qsOut = wd->informativeText();    break;  // QString|informativeText|
        case 2:   wd->setDetailedText(*qsIn);        break;  // void|setDetailedText|QString%text
        case 3:   wd->setInformativeText(*qsIn);     break;  // void|setInformativeText|QString%text
        case 4:   wd->setText(*qsIn);                break;  // void|setText|QString%text
        case 5:   wd->setWindowTitle(*qsIn);         break;  // void|setWindowTitle|QString%title
        case 6:   *qsOut = wd->text();               break;  // QString|text|
    }
    return rez;
}
/*
extern "C" MSVC_API  void qteQMessageBox_setXX1(QMessageBox* wd, void* q, int pr) {
    switch ( pr ) {
++    case 0:   wd->setText(*(QString*)q);                break;
++    case 1:   wd->setWindowTitle(*(QString*)q);         break;
++    case 2:   wd->setInformativeText(*(QString*)q);     break;
    }
}
*/

// 123
extern "C" MSVC_API int QMessageBox_setXX2(QMessageBox* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->icon();                                        break;  // QMessageBox::Icon|icon|
        case 1:   wd->setDefaultButton((QMessageBox::StandardButton)arg);       break;  // void|setDefaultButton|QMessageBox::StandardButton%button
        case 2:   wd->setEscapeButton((QMessageBox::StandardButton)arg);        break;  // void|setEscapeButton|QMessageBox::StandardButton%button
        case 3:   wd->setIcon((QMessageBox::Icon)arg);                          break;  // void|setIcon|QMessageBox::Icon%xz
        case 4:   wd->setStandardButtons((QMessageBox::StandardButtons)arg);    break;  // void|setStandardButtons|QMessageBox::StandardButtons%buttons
        case 5:   wd->setTextFormat((Qt::TextFormat)arg);                       break;  // void|setTextFormat|Qt::TextFormat%format
        case 6:   wd->setTextInteractionFlags((Qt::TextInteractionFlags)arg);   break;  // void|setTextInteractionFlags|Qt::TextInteractionFlags%flags
        case 7:   wd->setWindowModality((Qt::WindowModality)arg);               break;  // void|setWindowModality|Qt::WindowModality%windowModality
        case 8:   rez = (int)wd->standardButtons();                             break;  // QMessageBox::StandardButtons|standardButtons|
        case 9:   rez = (int)wd->textFormat();                                  break;  // Qt::TextFormat|textFormat|
        case 10:   rez = (int)wd->textInteractionFlags();                       break;  // Qt::TextInteractionFlags|textInteractionFlags|
        case 11:   rez = wd->exec();                                            break;  // int|exec|
    }
    return rez;
}
/*
// 123
extern "C" MSVC_API  void qteQMessageBox_setStandardButtons(QMessageBox* wd, QMessageBox::StandardButton kn, int pr) {
    switch ( pr ) {
++    case 0:   wd->setStandardButtons(kn);               break;
++    case 1:   wd->setDefaultButton(kn);                 break;
++    case 2:   wd->setEscapeButton(kn);                  break;
++    case 3:   wd->setIcon((QMessageBox::Icon)kn);   break;
    }
}
*/
// ============ QProgressBar ====================================
/*
extern "C" MSVC_API  QProgressBar* qteQProgressBar_create(QWidget* parent) {
    return new QProgressBar(parent);
}
*/
extern "C" MSVC_API QtRefH qteQProgressBar_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QProgressBar>*)wd) = new QProgressBar((QWidget*)parent);
    return (QtRefH)( ((QPointer<QProgressBar>*)wd)->data() );
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
extern "C" MSVC_API  QtRefH qteQMdiArea_create(QtRefH wd, QWidget* parent) {
    *((QPointer<QMdiArea>*)wd) = new QMdiArea((QWidget*)parent);
    return (QtRefH)( ((QPointer<QMdiArea>*)wd)->data() );
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
extern "C" MSVC_API QtRefH qteQMdiSubWindow_create(QtRefH wd, QtRefH parent, Qt::WindowFlags f) {
    *((QPointer<QMdiSubWindow>*)wd) = new QMdiSubWindow((QWidget*)parent, f);
    return (QtRefH)( ((QPointer<QMdiSubWindow>*)wd)->data() );
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
extern "C" MSVC_API QtRefH qteQComboBox_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QComboBox>*)wd) = new QComboBox((QWidget*)parent);
    return (QtRefH)( ((QPointer<QComboBox>*)wd)->data() );
}

extern "C" MSVC_API  void qteQComboBox_delete(QComboBox* wd) {
    delete wd;
}
extern "C" MSVC_API  void qteQComboBox_setXX(QComboBox* wd, QString *qstr, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->addItem(*qstr, n);       break;
    case 1:   wd->setItemText(n, *qstr);   break;
    case 2:   wd->setMaxCount(n);          break;
    case 3:   wd->setMaxVisibleItems(n);   break;
	case 4:   wd->setCurrentIndex(n);      break;
	
	case 5:   wd->insertSeparator(n);      break;
	case 6:   wd->removeItem(n);      	   break;
	case 7:   wd->setMinimumContentsLength(n); break;
	case 8:   wd->setModelColumn(n);           break;
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
    delete wd;
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
extern "C" MSVC_API QtRefH qteQLCDNumber_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<QLCDNumber>*)wd) = new QLCDNumber((QWidget*)parent);
    return (QtRefH)( ((QPointer<QLCDNumber>*)wd)->data() );
}

extern "C" MSVC_API QtRefH qteQLCDNumber_create2(QtRefH wd, QtRefH parent, int n) {
    *((QPointer<QLCDNumber>*)wd) = new QLCDNumber(n, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QLCDNumber>*)wd)->data() );
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
extern "C" MSVC_API QtRefH qteQSlider_create1(QtRefH wd, QtRefH parent, Qt::Orientation n) {
    *((QPointer<QSlider>*)wd) = new QSlider(n,  (QWidget*)parent);
    return (QtRefH)( ((QPointer<QSlider>*)wd)->data() );
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
extern "C" MSVC_API QtRefH qteQGroupBox_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QGroupBox>*)wd) = new QGroupBox((QWidget*)parent);
    return (QtRefH)( ((QPointer<QGroupBox>*)wd)->data() );
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
// =========== QCommandLinkButton ==========
// 694
extern "C" MSVC_API  QtRefH qteQCommandLinkButton_create2(QtRefH wd, QtRefH parent, QtRefH name, QtRefH description) {
    *((QPointer<QCommandLinkButton>*)wd) = new QCommandLinkButton((const QString &)*name, (const QString &)*description, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QCommandLinkButton>*)wd)->data() );
}
// 695
extern "C" MSVC_API  QtRefH qteQCommandLinkButton_create1(QtRefH wd, QtRefH parent, QtRefH name) {
    *((QPointer<QCommandLinkButton>*)wd) = new QCommandLinkButton((const QString &)*name, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QCommandLinkButton>*)wd)->data() );
}
// 697
extern "C" MSVC_API QtRefH qteQCommandLinkButton_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QCommandLinkButton>*)wd) = new QCommandLinkButton((QWidget*)parent);
    return (QtRefH)( ((QPointer<QCommandLinkButton>*)wd)->data() );
}
// 696
extern "C" MSVC_API  void qteQCommandLinkButton_delete(QCommandLinkButton* wd) {
	printf("1 -- QCommandLinkButton_delete\n");
    if(wd->parent() == NULL) {
		printf("3 -- %p -- QCommandLinkButton_delete\n", wd);
		delete wd;
	}
	printf("2 -- QCommandLinkButton_delete\n");
}
// 693
extern "C" MSVC_API  void qteQCommandLinkButton_setDiscript(QtRefH wd, QtRefH qs) {
    ((QCommandLinkButton*)wd)->setDescription( (const QString &)*qs  );
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
extern "C" MSVC_API int QAbstractSpinBox_setXX1(QAbstractSpinBox* wd, int arg, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   rez = (int)wd->alignment();            break;  // Qt::Alignment|alignment|
        case 1:   rez = (int)wd->buttonSymbols();        break;  // QAbstractSpinBox::ButtonSymbols|buttonSymbols|
        case 2:   rez = (int)wd->correctionMode();       break;  // QAbstractSpinBox::CorrectionMode|correctionMode|
        case 3:   rez = (int)wd->hasAcceptableInput();   break;  // bool|hasAcceptableInput|
        case 4:   rez = (int)wd->hasFrame();             break;  // bool|hasFrame|
        case 5:   wd->interpretText();                   break;  // void|interpretText|
        case 6:   rez = (int)wd->isAccelerated();        break;  // bool|isAccelerated|
        case 7:   rez = (int)wd->isGroupSeparatorShown();break;  // bool|isGroupSeparatorShown|
        case 8:   rez = (int)wd->isReadOnly();           break;  // bool|isReadOnly|
        case 9:   rez = (int)wd->keyboardTracking();     break;  // bool|keyboardTracking|
        case 10:   wd->setAccelerated((bool)arg);        break;  // void|setAccelerated|bool%on
        case 11:   wd->setAlignment((Qt::Alignment)arg); break;  // void|setAlignment|Qt::Alignment%flag
        case 12:   wd->setButtonSymbols((QAbstractSpinBox::ButtonSymbols)arg);   break;  // void|setButtonSymbols|QAbstractSpinBox::ButtonSymbols%bs
        case 13:   wd->setCorrectionMode((QAbstractSpinBox::CorrectionMode)arg);   break;  // void|setCorrectionMode|QAbstractSpinBox::CorrectionMode%cm
        case 14:   wd->setFrame((bool)arg);              break;  // void|setFrame|bool%xz
        case 15:   wd->setGroupSeparatorShown((bool)arg);break;  // void|setGroupSeparatorShown|bool%shown
        case 16:   wd->setKeyboardTracking((bool)arg);   break;  // void|setKeyboardTracking|bool%kt
        case 17:   wd->setReadOnly((bool)arg);           break;  // void|setReadOnly|bool%r
        case 18:   wd->setWrapping((bool)arg);           break;  // void|setWrapping|bool%w
        case 19:   wd->stepBy(arg);                      break;  // void|stepBy|int%steps
        case 20:   rez = (int)wd->wrapping();            break;  // bool|wrapping|
        case 21:   wd->clear();                          break;  // void|clear|
        case 22:   wd->selectAll();                      break;  // void|selectAll|
        case 23:   wd->stepDown();                       break;  // void|stepDown|
        case 24:   wd->stepUp();                         break;  // void|stepUp|
    }
    return rez;
}
// 119
extern "C" MSVC_API int QAbstractSpinBox_setXX2(QAbstractSpinBox* wd, int arg, QString* qsOut, QString* qsIn, int pr) {
int rez = 0;
    switch ( pr ) {
        case 0:   wd->fixup(*qsIn);                      break;  // void|fixup|QString%input
        case 1:   wd->setSpecialValueText(*qsIn);        break;  // void|setSpecialValueText|QString%txt
        case 2:   *qsOut = wd->specialValueText();       break;  // QString|specialValueText|
        case 3:   *qsOut = wd->text();                   break;  // QString|text|
    }
    return rez;
}
/*  --------------- ПОДЛЕЖИТ ЗАМЕНЕ ---------------
extern "C" MSVC_API  void qteQAbstractSpinBox_setReadOnly(QAbstractSpinBox* wd, bool f) {
    wd->setReadOnly(f);
}
*/
// =========== QDateTimeEdit ==========
// 483
extern "C" MSVC_API  QtRefH qteQDateTimeEdit_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QDateTimeEdit>*)wd) = new QDateTimeEdit((QWidget*)parent);
    return (QtRefH)( ((QPointer<QDateTimeEdit>*)wd)->data() );
}
// 485
extern "C" MSVC_API  QtRefH qteQDateTimeEdit_create2(QtRefH wd, QtRefH str, QtRefH format, QtRefH parent) {
	QDateTime qdt = QDateTime::fromString(*(QString*)str, *(QString*)format);
    *((QPointer<QDateTimeEdit>*)wd) = new QDateTimeEdit(qdt, (QWidget*)parent);
    return (QtRefH)( ((QPointer<QDateTimeEdit>*)wd)->data() );
}
// 486
extern "C" MSVC_API  void qteQDateTimeEdit_toString(QtRefH wd, QString* qs, QtRefH format) {
	*qs = ((QDateTimeEdit*)wd)->dateTime().toString(*(QString*)format);
}

// 484
extern "C" MSVC_API  void qteQDateTimeEdit_delete(QDateTimeEdit* wd) {
	delete wd;
}
// 491
extern "C" MSVC_API  void qteQDateTimeEdit_fromString(QtRefH wd, QtRefH str, QtRefH format) {
	QDateTime qdt = QDateTime::fromString(*(QString*)str, *(QString*)format);
	((QDateTimeEdit*)wd)->setDateTime(qdt);
}

// =========== QSpinBox ==========
// 247
extern "C" MSVC_API  QtRefH qteQSpinBox_create(QtRefH wd, QtRefH parent) {
    *((QPointer<QSpinBox>*)wd) = new QSpinBox((QSpinBox*)parent);
    return (QtRefH)( ((QPointer<QSpinBox>*)wd)->data() );
}
// 248
extern "C" MSVC_API  void qteQSpinBox_delete(QSpinBox* wd) {
    delete wd;
}
// 249
extern "C" MSVC_API  void qteQSpinBox_setXX1(QSpinBox* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setMinimum(n);           break;  // QSpinBox
    case 1:   wd->setMaximum(n);           break;  // QSpinBox
    case 2:   wd->setSingleStep(n);        break;  // QSpinBox
    case 3:   wd->setValue(n);             break;  // QSpinBox
    case 4:   wd->selectAll();             break; // Это не отсюда ... а родителя
    }
}
// 250
extern "C" MSVC_API  int qteQSpinBox_getXX1(QSpinBox* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->minimum();           break;  // QSpinBox
    case 1:   rez = wd->maximum();           break;  // QSpinBox
    case 2:   rez = wd->singleStep();        break;  // QSpinBox
    case 3:   rez = wd->value();             break;  // QSpinBox
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
// =========== HighlighterM ==========
HighlighterM::HighlighterM(QTextDocument *parent) : QSyntaxHighlighter(parent) {
     HighlightingRule rule;

     //Numbers
     classFormat.setForeground(Qt::red);
     rule.pattern = QRegExp("\\b[0-9]+(\\.)?\\d*\\b");
     rule.format = classFormat;
     highlightingRules.append(rule);

     // keywordFormat.setFontWeight(QFont::Bold);
     keywordFormat.setForeground(Qt::blue);
     QStringList keywordPatterns;
     keywordPatterns
                     << "\\b[s,S]{1,1}\\b" << "\\b[w,W]{1,1}\\b"
                     << "\\b[f,F]{1,1}\\b" << "\\b[i,I]{1,1}\\b"
                     << "\\b[d,D]{1,1}\\b" << "\\b[e,E]{1,1}\\b"
                     << "\\b[g,G]{1,1}\\b" << "\\b[h,H]{1,1}\\b"
                     << "\\b[k,K]{1,1}\\b" << "\\b[ks,KS]{1,1}\\b"
                     << "\\b[kv,KV]{1,1}\\b" << "\\b[l,L]{1,1}\\b"
                     << "\\b[m,M]{1,1}\\b" << "\\b[n,N]{1,1}\\b"
                     << "\\b[o,O]{1,1}\\b" << "\\b[q,Q]{1,1}\\b"
                     << "\\b[r,R]{1,1}\\b" << "\\b[tc,TC]{1,1}\\b"
                     << "\\b[tr,TR]{1,1}\\b" << "\\b[ts,TS]{1,1}\\b"
                     << "\\b[u,U]{1,1}\\b" << "\\b[x,X]{1,1}\\b"
                     << "\\b[znew,ZNEW]{1,1}\\b" << "\\b[zn,ZN]{1,1}\\b"
                     << "\\b[zp,ZP]{1,1}\\b" << "\\b[zsync,ZSYNC]{1,1}\\b"

                     << "\\b[c,C]{1,1}\\b";
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
     rule.pattern = QRegExp("\"[^\"]*\"");
     rule.format = quotationFormat;
     highlightingRules.append(rule);

     singleLineCommentFormat.setForeground(Qt::gray);
     rule.pattern = QRegExp(";[^\n]*");
     rule.format = singleLineCommentFormat;
     highlightingRules.append(rule);

     singleLineCommentFormat2.setForeground(Qt::darkRed);
     rule.pattern = QRegExp("//==[^\n]*");
     rule.format = singleLineCommentFormat2;
     highlightingRules.append(rule);


     commentStartExpression = QRegExp("/\\*");
     commentEndExpression = QRegExp("\\*/");
}

void HighlighterM::highlightBlock(const QString &text) {
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

extern "C" MSVC_API  HighlighterM* qteHighlighterM_create(QTextDocument* parent) {
    return new HighlighterM(parent);
}
extern "C" MSVC_API  void qteHighlighterM_delete(HighlighterM* wd) {
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
     rule.pattern = QRegExp("\"[^\"]*\"");
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
// 270
extern "C" MSVC_API  void qteQTextEdit_setFromString(QTextEdit* wd, QString* str, int pr) {
    switch ( pr ) {
    case 0:   wd->setPlainText(*str);    break;
    case 1:   wd->insertPlainText(*str); break;
    case 2:   wd->setHtml(*str);         break;
    case 3:   wd->insertHtml(*str);      break;
    case 4:   wd->append(*str);          break;
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
    wd->setTabStopDistance(double(width));
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
extern "C" MSVC_API  QtRefH qteQImage_create1() {
	return (QtRefH)(new QImage());
}
// 315
extern "C" MSVC_API  QtRefH qteQImage_create2(int w, int h, QImage::Format f) {
	return (QtRefH)(new QImage(w, h, f));
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
    case 3:   rez = wd->sizeInBytes();     break;
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
    delete wd;
}
// 305
extern "C" MSVC_API  bool qteQImage_load(QImage* im, QString* str) {
    return im->load(*str);
}
// ===================== QPoint ====================
/*
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
*/
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
extern "C" MSVC_API QtRefH QStackedWidget_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<QStackedWidget>*)wd) = new QStackedWidget((QWidget*)parent);
    return (QtRefH)( ((QPointer<QStackedWidget>*)wd)->data() );
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
extern "C" MSVC_API QtRefH QTabBar_create1(QtRefH wd, QtRefH parent) {
    *((QPointer<QTabBar>*)wd) = new QTabBar((QWidget*)parent);
    return (QtRefH)( ((QPointer<QTabBar>*)wd)->data() );
}

// 408
extern "C" MSVC_API  void QTabBar_delete1(QTabBar* wd) {
    delete wd;
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
// 470
extern "C" MSVC_API  bool QCoreApplication_installTranslator(QApplication* app, QTranslator* tr) {
    return app->installTranslator(tr);
}
// 427
extern "C" MSVC_API  void QCoreApplication_delete1(QApplication* app) {
    delete (QApplication*)app;
}
// ============ QUrl =======================================
// 81
extern "C" MSVC_API void* qteQUrl_create() {
     return new QUrl();
}
// 173
extern "C" MSVC_API  void qteQUrl_delete(QUrl* wd) {
    if(!wd) return;
#ifdef debDelete
    printf("del QTabBar --> \n");
#endif
#ifdef debDestr
    delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
// 444
extern "C" MSVC_API void qteQUrl_setUrl(QUrl* url, QString *qstr) {
    url->setUrl(*qstr);
}
// ============ QTextCodec =======================================
extern "C" MSVC_API QTextCodec* p_QTextCodec(char* strNameCodec) {
    return QTextCodec::codecForName(strNameCodec);
}
// Переприсваивание QString
extern "C" MSVC_API void QT_QTextCodec_toUnicode(QTextCodec *codec, QString *qstr, char *strz) {
    *qstr = codec->toUnicode(strz);
}
extern "C" MSVC_API void QT_QTextCodec_fromUnicode(QTextCodec *codec, QString *qstr, char *strz) {
    sprintf(strz, "%s", codec->fromUnicode(*qstr).data());
}

// ============ QByteArray =======================================
extern "C" MSVC_API QByteArray* new_QByteArray_vc(char* buf) {  return new QByteArray(buf); }
extern "C" MSVC_API QByteArray* new_QByteArray_2(QByteArray* other) {
    return new QByteArray(*other);
}
extern "C" MSVC_API void delete_QByteArray(QByteArray* buf) {
    delete buf;
}
extern "C" MSVC_API int QByteArray_size(QByteArray* s) { return s->size(); }
extern "C" MSVC_API char* new_QByteArray_data(QByteArray* buf) { return buf->data(); }
extern "C" MSVC_API const char* new_QByteArray_data2(QByteArray* buf) { return buf->constData(); }
extern "C" MSVC_API void QByteArray_trimmed(QByteArray* s1, int pr) {
    switch ( pr ) {
        case 0:   *s1 = s1->trimmed();        break;
        case 1:   *s1 = s1->simplified();     break;
        case 2:   s1->clear();          break;
    }
}
extern "C" MSVC_API void QByteArray_app1(QByteArray* s1, char* str, int pr) {
    switch ( pr ) {
        case 0:   *s1 = s1->prepend(str);        break;
        case 1:   *s1 = s1->append(str);     break;
    }
}
extern "C" MSVC_API void QByteArray_app2(QByteArray* s1, QByteArray* s2, int pr) {
    switch ( pr ) {
        case 0:   *s1 = s1->prepend(*s2);        break;
        case 1:   *s1 = s1->append(*s2);         break;
    }
}
extern "C" MSVC_API bool QByteArray_app3(QByteArray* s1, QByteArray* s2, int pr) {
    bool rez = false;
    switch ( pr ) {
        case 0:   rez = s1->startsWith(*s2);        break;
        case 1:   rez = s1->endsWith(*s2);         break;
    }
    return rez;
}

// ============ QIODEvice ===================
extern "C" MSVC_API void QT_QIODevice_read1(QIODevice* dev, QByteArray* ba) {
    ba->clear();
    ba->append(dev->readAll());
}
// ============ QFile ===================
extern "C" MSVC_API void *QT_QFile_new(QObject* parent) { return new QFile(parent); }
extern "C" MSVC_API void *QT_QFile_new1(QString* str, QObject* parent) { return new QFile(*str, parent); }
extern "C" MSVC_API bool  QT_QFile_open(QFile* f, QIODevice::OpenMode flag) { return f->open(flag); }
extern "C" MSVC_API void  QT_QFile_del(QFile* ts) {
    if(!ts) return;
#ifdef debDelete
    printf("del QFile --> \n");
#endif
#ifdef debDestr
    delete ts;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API void QT_QFileDevice_close(QFileDevice* dev) { dev->close(); }

// ============ QTextStream ===================
extern "C" MSVC_API void *QT_QTextStream_new1(QIODevice* dev) { return new QTextStream(dev); }
extern "C" MSVC_API void  QT_QTextStream_del(QTextStream* ts) {
    if(!ts) return;
#ifdef debDelete
    printf("del QTextStream --> \n");
#endif
#ifdef debDestr
    delete ts;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" MSVC_API void  QT_QTextStream_LL1(QTextStream* ts, void* adr, int pr) {
    switch ( pr ) {
        case 0:  *ts << (const char*)adr;         break;
        case 1:  *ts << (QByteArray*)adr;         break;
        case 2:  *ts << *(QString*)adr;            break;
    }
}
extern "C" MSVC_API void  QT_QTextStream_setCodec(QTextStream* ts, const char *codecName) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    ts->setCodec(codecName);
#else
#endif

}
extern "C" MSVC_API void  QT_QTextStream_readLine(QTextStream* ts, QByteArray* ba, int maxLen) {
    ba->clear();
    ba->append( ts->readLine(maxLen).toUtf8() );
}
extern "C" MSVC_API bool QT_QTextStream_atEnd(QTextStream* dev) {
    return dev->atEnd();
}
// Пример возврата объекта из С++
// --------------------------------
// extern "C" MSVC_API  void* proverka(QString* qs)  {
    // void** u = (void**)&(*qs);
    // return (void*)(*u);
//    return *((void**)&(*qs));
// }

// =============== QCalendarWidget ================
// 464
extern "C" MSVC_API  QCalendarWidget* qteQCalendarWidget_create1(QWidget* parent) {
    return new QCalendarWidget(parent);
}
// 465
extern "C" MSVC_API  void qteQCalendarWidget_delete1(QCalendarWidget* wd) {
    delete wd;
}
extern "C" MSVC_API void* qteQCalendarWidget_selectedDate(QCalendarWidget* dev, QDate* dt) {
    *dt = dev->selectedDate();
    return dt;
}
// 471
extern "C" MSVC_API bool qteQCalendarWidget_getBool1(QCalendarWidget* s1, int pr) {
    bool rez = false;
    switch ( pr ) {
        case 0:   rez = s1->isDateEditEnabled();     break;
        case 1:   rez = s1->isGridVisible();         break;
        case 2:   rez = s1->isNavigationBarVisible(); break;
    }
    return rez;
}
// 472
extern "C" MSVC_API void qteQCalendarWidget_setBool1(QCalendarWidget* s1, bool b, int pr) {
    switch ( pr ) {
        case 0:   s1->setGridVisible(b);                break;
        case 1:   s1->setNavigationBarVisible(b);       break;
        case 2:   s1->showNextMonth();       break;
        case 3:   s1->showNextYear();       break;
        case 4:   s1->showPreviousMonth();       break;
        case 5:   s1->showPreviousYear();       break;
        case 6:   s1->showSelectedDate();       break;
        case 7:   s1->showToday();       break;
        case 8:   s1->setDateEditAcceptDelay(b);    break;
        case 9:   s1->setDateEditEnabled(b);       break;
    }
}

// =============== QTranslator ================
// 467
extern "C" MSVC_API  QTranslator* qteQTranslator_create1() {
    return new QTranslator();
}
// 468
extern "C" MSVC_API  void qteQTranslator_delete1(QTranslator* wd) {
    delete wd;
}
// 469
extern "C" MSVC_API  bool qteQTranslator_load(QTranslator* wd, QString* file) {
    return wd->load(*file);
}

