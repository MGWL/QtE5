#include "qte5widgets.h"
// #define debDelete 1
#define debDestr 1

// =========== QApplication ==========
extern "C" QtRefH qteQApplication_create1(int* argc, char *argv[], int AnParam3) {
    return (QtRefH)new QApplication(*argc, argv, AnParam3);
}
extern "C" void qteQApplication_delete1(QApplication* app) {
#ifdef debDelete
    printf("del QApplication --> \n");
#endif
#ifdef debDestr
    delete (QApplication*)app;
#endif
#ifdef debDelete
    printf("------------> Ok\n");
#endif
}
extern "C" int qteQApplication_sizeof(QtRefH app) {
    return sizeof(*(QApplication*)app);
}
extern "C" void qteQApplication_appDirPath(QtRefH app, QtRefH qs) {
    *(QString*)qs = ((QApplication*)app)->applicationDirPath();
}
extern "C" void qteQApplication_appFilePath(QtRefH app, QtRefH qs) {
    *(QString*)qs = ((QApplication*)app)->applicationFilePath();
}
extern "C" int qteQApplication_exec(QtRefH app) {
    return ((QApplication*)app)->exec();
}
extern "C" void qteQApplication_aboutQt(QtRefH app) {
    ((QApplication*)app)->aboutQt();
}
extern "C" void qteQApplication_quit(QtRefH app) {
    ((QApplication*)app)->quit();
}
// 276
extern "C" void qteQApplication_exit(QtRefH app, int kod) {
    ((QApplication*)app)->exit(kod);
}
// 277
extern "C" void qteQApplication_setStyleSheet(QtRefH app, QString* str) {
    ((QApplication*)app)->setStyleSheet(*str);
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
extern "C" void qteQLineEdit_setKeyPressEvent(eQLineEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" eQLineEdit* qteQLineEdit_create1(QWidget* parent) {
    return new eQLineEdit(parent);
}
extern "C" void qteQLineEdit_delete1(eQLineEdit* wd) {
#ifdef debDelete
    printf("del eQLineEdit --> n\n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
    delete wd;
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" void qteQLineEdit_set(eQLineEdit* qw, QString *qstr) {
    qw->setText(*qstr);
}
/*
extern "C" void qteQLineEdit_setfocus(eQLineEdit* qw) {
     qw->setFocus();
}
*/
extern "C" void qteQLineEdit_clear(eQLineEdit* qw) {
     qw->clear();
}
extern "C" void qteQLineEdit_text(eQLineEdit* wd, QString* qs) {
    *qs = wd->text();
}
// 287
extern "C" void qteQLineEdit_setX1(eQLineEdit* wd, bool r, int pr) {
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
extern "C" bool qteQLineEdit_getX1(eQLineEdit* wd, int pr) {
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

// =========== QStatusBar ==========
extern "C" QStatusBar* qteQStatusBar_create1(QWidget* parent) {
    return new QStatusBar(parent);
}
extern "C" void qteQStatusBar_delete1(QStatusBar* wd) {
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
extern "C" void qteQStatusBar_showMessage(QStatusBar* wd, QString* qs) {
    wd->showMessage(*qs);
}

// =========== QMainWinsow ==========
eQMainWindow::eQMainWindow(QWidget *parent, Qt::WindowFlags f): QMainWindow(parent, f) {
}
eQMainWindow::~eQMainWindow() {
}
extern "C" eQMainWindow* qteQMainWindow_create1(QWidget* parent, Qt::WindowFlags f) {
    return new eQMainWindow(parent, f);
}
extern "C" void qteQMainWindow_delete1(eQMainWindow* wd) {
#ifdef debDelete
    printf("del eQMainWindow --> \n");
#endif
#ifdef debDestr
    if(wd->parent() == NULL) delete wd;
#endif
#ifdef debDelete
    printf("Ok\n");
#endif
}
extern "C" void qteQMainWindow_setXX(QMainWindow* wd, QWidget* s, int pr) {
    switch ( pr ) {
        case 0:   wd->setCentralWidget(s);              break;
        case 1:   wd->setMenuBar((QMenuBar*)s);         break;
        case 2:   wd->setStatusBar((QStatusBar*)s);     break;
        case 3:   wd->addToolBar((QToolBar*)s);         break;
    }
}
extern "C" void qteQMainWindow_addToolBar(QMainWindow* wd, QToolBar* s, Qt::ToolBarArea pr) {
    wd->addToolBar(pr, s);
}

// =========== QWidget ==========
eQWidget::eQWidget(QWidget *parent, Qt::WindowFlags f): QWidget(parent, f) {
    aDThis = NULL;       // Хранит адрес экземпляра объекта D
    aKeyPressEvent = NULL;
    aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
}
eQWidget::~eQWidget() {
}
// -------------------------------------------------
extern "C" void qteQWidget_setKeyPressEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aKeyPressEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
}
void eQWidget::keyPressEvent(QKeyEvent *event) {
    // printf("eQWidget::keyPressEvent --event -> %p  aKeyPressEvent -> %p\n", event, aKeyPressEvent);
    if (aKeyPressEvent == NULL) return;
    if ((aKeyPressEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aKeyPressEvent)((QtRefH)event);
    }
    if ((aKeyPressEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
    }
}
// -------------------------------------------------

extern "C" void qteQWidget_setPaintEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aPaintEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
}
void eQWidget::paintEvent(QPaintEvent *event) {
    if (aPaintEvent == NULL) return;
    QPainter* qp = new QPainter(this);
    if (aDThis == NULL) {
        ((ExecZIM_v__vp_vp)aPaintEvent)((QtRefH)event, (QtRefH)qp);
    }
    else  {
        ((ExecZIM_v__vp_vp_vp)aPaintEvent)(*(void**)aDThis, (QtRefH)event, (QtRefH)qp);
    }
}

// -------------------------------------------------
extern "C" void qteQWidget_setCloseEvent(QtRefH wd, void* adr, void* dThis) {
    ((eQWidget*)wd)->aCloseEvent = adr;
    ((eQWidget*)wd)->aDThis = dThis;
}
void eQWidget::closeEvent(QCloseEvent *event) {
    if (aCloseEvent == NULL) return;
    if ((aCloseEvent != NULL) && (aDThis == NULL)) {
        ((ExecZIM_v__vp)aCloseEvent)((QtRefH)event);
    }
    if ((aCloseEvent != NULL) && (aDThis != NULL)) {
        ((ExecZIM_v__vp_vp)aCloseEvent)(*(void**)aDThis, (QtRefH)event);
    }
}
// -------------------------------------------------
extern "C" void qteQWidget_setResizeEvent(eQWidget* wd, void* adr, void* dThis) {
    wd->aResizeEvent = adr;
    wd->aDThis = dThis;
}
void eQWidget::resizeEvent(QResizeEvent *event) {
    if (aResizeEvent == NULL) return;
    if(aDThis == NULL) {
         ((ExecZIM_v__vp)aResizeEvent)(event);
    } else {
        ((ExecZIM_v__vp_vp)aResizeEvent)(*(void**)aDThis, event);
    }
}
extern "C" QtRefH qteQWidget_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new eQWidget((eQWidget*)parent, f);
}
extern "C" void qteQWidget_delete1(eQWidget* wd) {
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
extern "C" void qteQWidget_contentsRect(QWidget* wd, QRect* tk) {
    *tk = wd->contentsRect();
}
extern "C" void qteQWidget_setGeometry(QWidget* wd, int x, int y, int w, int h) {
    wd->setGeometry(x, y, w, h);
}
extern "C" void qteQWidget_setSizePolicy(QWidget* wd, QSizePolicy::Policy w, QSizePolicy::Policy h) {
    wd->setSizePolicy(w,  h);
}
extern "C" void qteQWidget_setVisible(QtRefH wd, bool f) {
    ((QWidget*)wd)->setVisible(f);
}
extern "C" bool qteQWidget_isVisible(QtRefH wd) {
    return (bool)((QWidget*)wd)->isVisible();
}
extern "C" void qteQWidget_setWindowTitle(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setWindowTitle(*(QString*)qs);
}
extern "C" void qteQWidget_setStyleSheet(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setStyleSheet(*(QString*)qs);
}
extern "C" void qteQWidget_setToolTip(QtRefH wd, QtRefH qs) {
    ((QWidget*)wd)->setToolTip(*(QString*)qs);
}
extern "C" void qteQWidget_setMMSize(QtRefH wd, bool mm, int w, int h) {
    if(mm) { ((QWidget*)wd)->setMinimumSize(w, h); }
    else   { ((QWidget*)wd)->setMaximumSize(w, h); }
}
extern "C" void qteQWidget_setEnabled(QtRefH wd, bool b) {
    ((QWidget*)wd)->setEnabled(b);
}
extern "C" void qteQWidget_setLayout(QtRefH wd, QtRefH la) {
    ((QWidget*)wd)->setLayout((QLayout*)la);
}
extern "C" void qteQWidget_setMax1(QWidget* wd, int pr, int r) {
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
extern "C" void qteQWidget_exWin1(QWidget* wd, int pr) {
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
extern "C" void qteQWidget_exWin2(QWidget* wd, int pr, int w, int h) {
    switch ( pr ) {
    case 0:   wd->move(w, h);            break;
    case 1:   wd->resize(w, h);          break;
    }
}
extern "C" void qteQWidget_setFont(QWidget* wd, QFont* fn) {
    wd->setFont(*fn);
}
extern "C" void* qteQWidget_winid(QWidget* wd) {
    return (void*)wd->winId();
}
extern "C" int qteQWidget_getPr(QWidget* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->x();            break;
    case 1:   rez = wd->y();            break;
    case 2:   rez = wd->width();        break;
    case 3:   rez = wd->height();       break;
    }
    return rez;
}
extern "C" bool qteQWidget_getBoolXX(QWidget* wd, int pr) {
    bool rez = false;
    switch ( pr ) {
    case 0:   rez = wd->hasFocus();     break;
    }
    return rez;
}

// =========== QString ==========
extern "C" QtRefH qteQString_create1(void) {
    return (QtRefH)new QString();
}
// QString из wchar
extern "C" QtRefH qteQString_create2(QChar* s, int size) {
    return (QtRefH)new QString(s, size);
}
extern "C" void qteQString_delete(QString* wd) {
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
extern "C" QtRefH qteQString_data(QtRefH qs) {
    return (QtRefH)((QString*)qs)->data();
}
extern "C" int qteQString_size(QtRefH qs) {
    return ((QString*)qs)->size();
}
extern "C" int qteQString_sizeOf(void) {
    // int a = 5;
    // printf("adr a = %d", (unsigned int)&a);
    QString s("ABCD");
    // printf("adr s = %d", (unsigned int)&s);
    // int b = 6;
    // printf("adr b = %d", (unsigned int)&b);
    return sizeof(s);
}

// =========== QColor ==========
extern "C" QtRefH qteQColor_create1(void) {
    return (QtRefH)new QColor();
}
extern "C" void qteQColor_delete(QColor* wd) {
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
extern "C" void qteQColor_setRgb(QtRefH wc, int r, int g, int b, int a) {
    ((QColor*)wc)->setRgb(r,g,b,a);
}
// =========== QBrush ==========
extern "C" QtRefH qteQBrush_create1(void) {
    return (QtRefH)new QBrush();
}
extern "C" void qteQBrush_delete(QBrush* wd) {
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
extern "C" void qteQBrush_setColor(QBrush* qs, QColor* qc) {
    qs->setColor(*qc);
}
extern "C" void qteQBrush_setStyle(QBrush* qs, Qt::BrushStyle bs) {
    qs->setStyle(bs);
}
// =========== QPen ==========
extern "C" QtRefH qteQPen_create1(void) {
    return (QtRefH)new QPen();
}
extern "C" void qteQPen_delete(QPen* wd) {
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
extern "C" void qteQPen_setColor(QPen* qs, QColor* qc) {
    qs->setColor(*qc);
}
extern "C" void qteQPen_setStyle(QPen* qs, Qt::PenStyle st) {
    qs->setStyle(st);
}
extern "C" void qteQPen_setWidth(QPen* qs, int w) {
    qs->setWidth(w);
}

// =========== QPalette ==========
extern "C" QtRefH qteQPalette_create1(void) {
    return (QtRefH)new QPalette();
}
extern "C" void qteQPalette_delete(QPalette* wd) {
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
extern "C" QtRefH qteQPushButton_create1(QtRefH parent, QtRefH name) {
    return  (QtRefH) new QPushButton((const QString &)*name, (QWidget*)parent);
}
extern "C" void qteQPushButton_delete(QPushButton* wd) {
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
extern "C" void qteQPushButton_setXX(QPushButton* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoDefault(p); break;
    case 1:   wd->setDefault(p);     break;
    case 2:   wd->setFlat(p);        break;
    }
}
// =========== QAbstractButton =========
extern "C" void qteQAbstractButton_setText(QtRefH wd, QtRefH qs) {
    ((QAbstractButton*)wd)->setText( (const QString &)*qs  );
}
extern "C" void qteQAbstractButton_text(QtRefH wd, QtRefH qs) {
    *(QString*)qs = ((QAbstractButton*)wd)->text();
}
extern "C" void qteQAbstractButton_setXX(QAbstractButton* wd, bool p, int pr) {
    switch ( pr ) {
    case 0:   wd->setAutoExclusive(p); break;
    case 1:   wd->setAutoRepeat(p);    break;
    case 2:   wd->setCheckable(p);     break;
    case 3:   wd->setDown(p);          break;
    case 4:   wd->setChecked(p);       break;
    }
}
extern "C" void qteQAbstractButton_setIcon(QAbstractButton* wd, QIcon* p) {
    wd->setIcon(*p);
}

extern "C" bool qteQAbstractButton_getXX(QAbstractButton* wd, int pr) {
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

extern "C" void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}

// ===================== QLyout ====================
extern "C" QtRefH qteQVBoxLayout(void) {
    return  (QtRefH) new QVBoxLayout();
}
extern "C" QtRefH qteQHBoxLayout(void) {
    return  (QtRefH) new QHBoxLayout();
}
extern "C" QtRefH qteQBoxLayout(QtRefH wd, QBoxLayout::Direction dir) {
    return  (QtRefH) new QBoxLayout(dir, (QWidget*)wd);
}
extern "C" void qteQBoxLayout_delete(QBoxLayout* wd) {
#ifdef debDelete
    printf("del QBoxLayout --> %p\n", wd->parent());
    // printf("%s", wd->objectName().Data);
#endif
#ifdef debDestr
    try {
        if(wd->parent() == NULL) delete wd;
    } catch(...) {
        printf("error del QBoxLayout --> \n");
    }
#endif
#ifdef debDelete
    printf("----------------> Ok\n");
#endif
}
extern "C" void qteQBoxLayout_addWidget(QtRefH BoxLyout, QtRefH widget, int stretch, int align) {
    ((QBoxLayout*)BoxLyout)->addWidget((QWidget*)widget, stretch, (Qt::Alignment)align);
}
extern "C" void qteQBoxLayout_addLayout(QtRefH BoxLyout, QtRefH layout) {
	((QBoxLayout*)BoxLyout)->addLayout((QBoxLayout*)layout);
}
extern "C" void qteQBoxLayout_setSpasing(QBoxLayout* BoxLyout, int sp) {
    BoxLyout->setSpacing(sp);
}
extern "C" int qteQBoxLayout_spasing(QBoxLayout* BoxLyout) {
    return BoxLyout->spacing();
}
extern "C" void qteQBoxLayout_setMargin(QBoxLayout* BoxLyout, int sp) {
    BoxLyout->setMargin(sp);
}
extern "C" int qteQBoxLayout_margin(QBoxLayout* BoxLyout) {
    return BoxLyout->margin();
}
// ===================== QFrame ====================
eQFrame::eQFrame(QWidget *parent, Qt::WindowFlags f): QFrame(parent, f) {
    aKeyPressEvent = NULL;
    aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
}
eQFrame::~eQFrame() {
}
extern "C" QtRefH qteQFrame_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new eQFrame((QWidget*)parent, f);
}
extern "C" void qteQFrame_delete1(eQFrame* wd) {
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
void eQFrame::paintEvent(QPaintEvent *event) {
    if(aPaintEvent != NULL) {
        ((ExecZIM_v__vp)aPaintEvent)((QtRefH)event);
    }
}
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
extern "C" void qteQFrame_setFrameShape(QtRefH fr, QFrame::Shape sh)
{
    ((eQFrame*)fr)->setFrameShape(sh);
}
extern "C" void qteQFrame_setFrameShadow(QtRefH fr, QFrame::Shadow sh)
{
    ((eQFrame*)fr)->setFrameShadow(sh);
}
extern "C" void qteQFrame_setLineWidth(QtRefH fr, int sh)
{
    ((eQFrame*)fr)->setLineWidth(sh);
}
extern "C" void qteFrame_listChildren(eQFrame* wd) {
    QObjectList list = wd->children();

    for(int i = 0; i != list.count(); i++) {
        printf("qt ==> %p\n", list[i]);
    }
}

// ===================== QLabel ====================
extern "C" QtRefH qteQLabel_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new QLabel((QWidget*)parent, f);
}
extern "C" void qteQLabel_delete1(QLabel* wd) {
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
extern "C" void qteQLabel_setText(QtRefH wd, QtRefH qs) {
    ((QLabel*)wd)->setText(*(QString*)qs);
}
// ===================== QEvent ====================
extern "C" int qteQEvent_type(QEvent* ev) {
    return ev->type();
}
extern "C" void qteQEvent_ia(QEvent* ev, int pr) {
    switch ( pr ) {
    case 0:   ev->ignore();    break;
    case 1:   ev->accept();  break;
    }
}

// ===================== QResizeEvent ====================
extern "C" QtRefH qteQResizeEvent_size(QResizeEvent* ev) {
    return (QtRefH)&ev->size();
}
extern "C" QtRefH qteQResizeEvent_oldSize(QResizeEvent* ev) {
    return (QtRefH)&ev->oldSize();
}
// ===================== QSize ====================
extern "C" QtRefH qteQSize_create1(int wd, int ht) {
    return (QtRefH)new QSize(wd, ht);
}
extern "C" void qteQSize_delete1(QSize* wd) {
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
extern "C" int qteQSize_width(QSize* ev) {
    return ev->width();
}
extern "C" int qteQSize_heigth(QSize* ev) {
    return ev->height();
}
extern "C" void qteQSize_setWidth(QSize* ev, int wd) {
    return ev->setWidth(wd);
}
extern "C" void qteQSize_setHeigth(QSize* ev, int ht) {
    return ev->setHeight(ht);
}
// ===================== QKeyEvent ====================
extern "C" int qteQKeyEvent_key(QKeyEvent* ev) {
    return ev->key();
}
extern "C" int qteQKeyEvent_count(QKeyEvent* ev) {
    return ev->count();
}
// 285
extern "C" unsigned int qteQKeyEvent_modifiers(QKeyEvent* ev) {
    return (unsigned int)ev->modifiers();
}

// ===================== QAbstractScrollArea ====================
extern "C" QtRefH qteQAbstractScrollArea_create1(QtRefH parent) {
    return (QtRefH)new QAbstractScrollArea((QWidget*)parent);
}
extern "C" void qteQAbstractScrollArea_delete1(QAbstractScrollArea* wd) {
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
}
eQPlainTextEdit::~eQPlainTextEdit() {
}

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
extern "C" int qteQPlainTextEdit_getXYWH(eQPlainTextEdit* wd, QTextBlock* tb, int pr) {
    return wd->getXYWH(tb, pr);
}

extern "C" void qteQPlainTextEdit_setViewportMargins(eQPlainTextEdit* wd,
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
extern "C" eQPlainTextEdit* qteQPlainTextEdit_create1(QWidget* parent) {
    return new eQPlainTextEdit(parent);
}
extern "C" void qteQPlainTextEdit_delete1(eQPlainTextEdit* wd) {
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
extern "C" void qteQPlainTextEdit_setKeyPressEvent(eQPlainTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" void qteQPlainTextEdit_setKeyReleaseEvent(eQPlainTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyReleaseEvent = adr;
    wd->aDThis = aThis;
}
extern "C" void qteQPlainTextEdit_appendPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->appendPlainText((const QString &)*str);
}
extern "C" void qteQPlainTextEdit_appendHtml(QPlainTextEdit* wd, QtRefH str) {
    wd->appendHtml((const QString &)*str);
}
extern "C" void qteQPlainTextEdit_setPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->setPlainText((const QString &)*str);
}
extern "C" void qteQPlainTextEdit_insertPlainText(QPlainTextEdit* wd, QtRefH str) {
    wd->insertPlainText((const QString &)*str);
}
extern "C" void qteQPlainTextEdit_cutn(QPlainTextEdit* wd, int pr) {
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
extern "C" void qteQPlainTextEdit_toPlainText(QPlainTextEdit* wd, QtRefH qs) {
    *(QString*)qs = wd->toPlainText();
}
extern "C" QTextDocument* qteQPlainTextEdit_document(QPlainTextEdit* wd) {
    return wd->document();
}
// 230
extern "C" void qteQPlainTextEdit_textCursor(QPlainTextEdit* wd, QTextCursor* tk) {
    *tk = wd->textCursor();
}
// 253
extern "C" void qteQPlainTextEdit_setTextCursor(QPlainTextEdit* wd, QTextCursor* tk) {
    wd->setTextCursor(*tk);
}
extern "C" void qteQPlainTextEdit_cursorRect(QPlainTextEdit* wd, QRect* tk) {
    *tk = wd->cursorRect();
}
extern "C" void qteQPlainTextEdit_setTabStopWidth(QPlainTextEdit* wd, int width) {
    wd->setTabStopWidth(width);
}
// 282
extern "C" void qteQPlainTextEdit_firstVisibleBlock(eQPlainTextEdit* wd, QTextBlock* tb) {
    wd->gfirstVisibleBlock(tb);
}
// 294
extern "C" void qteQPlainTextEdit_setWordWrapMode(eQPlainTextEdit* wd, QTextOption* tb) {
    wd->setWordWrapMode(tb->wrapMode());
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
    if (aSlotN != NULL)  ((ExecZIM_v__vp_n_i)aSlotN)(*(void**)aDThis, N, (int)pn);
}


// -------------------------------------------------------
extern "C" void* qteQAction_create(QObject * parent) {  return new eAction(parent); }
extern "C" void  qteQAction_delete(eAction* wd)      {
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
extern "C" void* qteQAction_getParent(eAction* qw) {
    return qw->parent();
}

extern "C" void qteQAction_setXX1(eAction* qw, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   qw->setText(*qstr);       break;
    case 1:   qw->setToolTip(*qstr);    break;
    }
}
extern "C" void qteQAction_setSlotN2(eAction* slot, void* adr, void* adrTh, int n) {
    slot->aSlotN = adr;
    slot->aDThis = adrTh;
    slot->N = n;
}

extern "C" void qteQAction_setHotKey(eAction *act, int kl) {
    act->setShortcut( (const QKeySequence &)kl);
}
extern "C" void qteQAction_setIcon(eAction *act, QIcon *ik) {
    act->setIcon(*ik);
}
extern "C" void qteQAction_setEnabled(eAction *act, bool p) {
    act->setEnabled(p);
}


extern "C" void qteQAction_setSlotN(eAction* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}

extern "C" void qte_Connect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const eAction*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}

// ================= QMenu ==================================
extern "C"  void* qteQMenu_create(QWidget * parent) {
     return new QMenu(parent);
}
extern "C" void qteQMenu_delete(QMenu* wd) {
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
extern "C"  void qteQMenu_addAction(QMenu* menu, QAction *ac) {
    menu->addAction(ac);
}
extern "C"  void qteQMenu_setTitle(QMenu* menu, QString *qstr) {
    menu->setTitle(*qstr);
}
extern "C"  void qteQMenu_addSeparator(QMenu* menu) {
    menu->addSeparator();
}
extern "C"  void qteQMenu_addMenu(QMenu* menu, QMenu* nmenu) {
    menu->addMenu(nmenu);
}
// ============ QMenuBar ====================================
extern "C"  void* qteQMenuBar_create(QWidget * parent) {
     return new QMenuBar(parent);
}
extern "C" void qteQMenuBar_delete(QMenuBar* wd) {
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
extern "C" void qteQMenuBar_addMenu(QMenuBar* wd, QMenu* mn) {
    wd->addMenu(mn);
}
// ============ QFont =======================================
extern "C"  void* qteQFont_create() {
     return new QFont();
}
extern "C" void qteQFont_delete(QFont* wd) {
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
extern "C" void qteQFont_setPointSize(QFont* wd, int pr) {
    wd->setPointSize(pr);
}
extern "C" void qteQFont_setFamily(QFont* wd, QString *qstr) {
    wd->setFamily(*qstr);
}
// ============ QIcon =======================================
extern "C"  void* qteQIcon_create() {
     return new QIcon();
}
extern "C" void qteQIcon_delete(QIcon* wd) {
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
extern "C" void qteQIcon_addFile(QIcon* wd, QString *qstr, QSize* qsize ) {
    if(qsize == NULL) {
        wd->addFile(*qstr);
    } else {
        wd->addFile(*qstr, *qsize);
    }
}
// ============ QToolBar ====================================
extern "C"  void* qteQToolBar_create() {
    return new QToolBar();
}
extern "C" void qteQToolBar_delete(QToolBar* wd) {
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
extern "C" void qteQToolBar_setXX1(QToolBar* wd, void* q, int pr) {
    switch ( pr ) {
    case 0:   wd->addAction((QAction*)q);      break;
    case 1:   wd->addWidget((QWidget*)q);      break;
    }
}
extern "C" void qteQToolBar_setAllowedAreas(QToolBar* wd, Qt::ToolBarArea pr) {
    wd->setAllowedAreas(pr);
}
extern "C" void qteQToolBar_setToolButtonStyle(QToolBar* wd, Qt::ToolButtonStyle pr) {
    wd->setToolButtonStyle(pr);
}
extern "C" void qteQToolBar_addSeparator(QToolBar* wd, int pr) {
    switch ( pr ) {
    case 0:   wd->addSeparator();       break;
    case 1:   wd->clear();              break;
    }
}

// ============ QDialog ====================================
extern "C" QDialog* qteQDialog_create(QWidget* parent, Qt::WindowFlags f) {
    return new QDialog(parent, f);
}
extern "C" void qteQDialog_delete(QDialog* wd) {
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
extern "C" int qteQDialog_exec(QDialog* wd) {
    return wd->exec();
}
// ============ QMessageBox ====================================
extern "C" QMessageBox* qteQMessageBox_create(QWidget* parent) {
    return new QMessageBox(parent);
}
extern "C" void qteQMessageBox_delete(QMessageBox* wd) {
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
extern "C" void qteQMessageBox_setXX1(QMessageBox* wd, void* q, int pr) {
    switch ( pr ) {
    case 0:   wd->setText(*(QString*)q);                break;
    case 1:   wd->setWindowTitle(*(QString*)q);         break;
    case 2:   wd->setInformativeText(*(QString*)q);     break;
    }
}
extern "C" void qteQMessageBox_setStandartButtons(QMessageBox* wd,
        QMessageBox::StandardButton kn, int pr) {
    switch ( pr ) {
    case 0:   wd->setStandardButtons(kn);               break;
    case 1:   wd->setDefaultButton(kn);                 break;
    case 2:   wd->setEscapeButton(kn);                  break;
    case 3:   wd->setIcon((QMessageBox::Icon)kn);   break;
    }
}
// ============ QProgressBar ====================================
extern "C" QProgressBar* qteQProgressBar_create(QWidget* parent) {
    return new QProgressBar(parent);
}
extern "C" void qteQProgressBar_delete(QProgressBar* wd) {
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
extern "C" void qteQProgressBar_setPr(QProgressBar* wd, int arg, int pr) {
    switch ( pr ) {
    case 0:   wd->setMinimum(arg);               break;
    case 1:   wd->setMaximum(arg);                break;
    case 2:   wd->setValue(arg);                 break;
    }
}
// ============ QDate =======================================
extern "C"  void* qteQDate_create() {
    QDate* dd = new QDate(); *dd = dd->currentDate();
    return dd;
}
extern "C" void qteQDate_delete(QDate* wd) {
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
extern "C" QString* qteQDate_toString(QDate* d, QString* rez, QString* shabl) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *rez = d->toString(*shabl);
    return rez;
}
extern "C" void qteQDate_currentDate(QDate* d) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *d = d->currentDate();
}

// ============ QTime =======================================
extern "C"  void* qteQTime_create() {
    QTime* dd = new QTime(); *dd = dd->currentTime();
    return dd;
}
extern "C" void qteQTime_delete(QTime* wd) {
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
extern "C" QString* qteQTime_toString(QTime* d, QString* rez, QString* shabl) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *rez = d->toString(*shabl);
    return rez;
}
extern "C" void qteQTime_currentTime(QTime* d) {
//    QMessageBox msgBox; msgBox.setText(*shabl);    msgBox.exec();
    *d = d->currentTime();
}
// =========== QFileDialog ==========
extern "C" QFileDialog* qteQFileDialog_create(QWidget* parent, Qt::WindowFlags f) {
    QFileDialog* fd = new QFileDialog(parent, f);
    // delete(fd);
    return fd;
}
extern "C" void qteQFileDialog_delete(QFileDialog* wd) {
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
extern "C" void qteQFileDialog_setNameFilter(QFileDialog* wd, QString *qstr, int pr) {
    switch ( pr ) {
    case 0:   wd->setNameFilter(*qstr);                 break;
    case 1:   wd->selectFile(*qstr);                    break;
    case 2:   wd->setDirectory(*qstr);                  break;
    case 3:   wd->setDefaultSuffix(*qstr);              break;
    }

}
extern "C" void qteQFileDialog_setViewMode(QFileDialog* wd, QFileDialog::ViewMode f) {
    wd->setViewMode(f);
}
extern "C" QString* qteQFileDialog_stGetOpenFileName(
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
extern "C" QString* qteQFileDialog_stGetSaveFileName(
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

extern "C" QString* qteQFileDialog_getOpenFileName(
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
extern "C" QString* qteQFileDialog_getSaveFileName(
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
extern "C" QAbstractScrollArea* qteQAbstractScrollArea_create(QWidget* parent) {
    return new QAbstractScrollArea(parent);
}
extern "C" void qteQAbstractScrollArea_delete(QAbstractScrollArea* wd) {
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
extern "C" QMdiArea* qteQMdiArea_create(QWidget* parent) {
    return new QMdiArea(parent);
}
extern "C" void qteQMdiArea_delete(QMdiArea* wd) {
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
extern "C" QMdiSubWindow* qteQMdiArea_addSubWindow(QMdiArea* ma, QWidget* wd, Qt::WindowFlags windowFlags) {
    return ma->addSubWindow(wd, windowFlags);
}

// =========== QMdiSubWindow ==========
extern "C" QMdiSubWindow* qteQMdiSubWindow_create(QWidget* parent, Qt::WindowFlags f) {
    return new QMdiSubWindow(parent, f);
}
extern "C" void qteQMdiSubWindow_delete(QMdiSubWindow* wd) {
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
extern "C" void qteQMdiSubWindow_addLayout(QMdiSubWindow* wd, QBoxLayout* ly ) {
    wd->setLayout(ly);
}
// =========== QAbstractItemView ==========
// =========== QTableView ==========
extern "C" QTableView* qteQTableView_create(QWidget* parent) {
    return new QTableView(parent);
}
extern "C" void qteQTableView_delete(QTableView* wd) {
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
extern "C" void qteQTableView_setN1(QTableView* wd, int n, int p, int pr) {
    switch ( pr ) {
        case 0:   wd->setColumnWidth(n, p);                  break;
        case 1:   wd->setRowHeight(n, p);                    break;
    }
}
// 175
extern "C" int qteQTableView_getN1(QTableView* wd, int n, int pr) {
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
extern "C" void qteQTableView_ResizeMode(QTableView* wd, int rc, QHeaderView::ResizeMode n, int pr) {
    switch ( pr ) {
    case 0:  wd->horizontalHeader()->setSectionResizeMode(rc, n); break;
    case 1:    wd->verticalHeader()->setSectionResizeMode(rc, n); break;
    }
}

// =========== QTableWidgetItem ==========
extern "C" void* qteQTableWidgetItem_create(int t) {
    return new QTableWidgetItem(t);
}
extern "C" void qteQTableWidgetItem_delete(QTableWidgetItem* wd) {
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
extern "C" void qteQTableWidgetItem_setXX(QTableWidgetItem* wd, QString *qstr, int pr) {
    switch ( pr ) {
        case 0:   wd->setText(*qstr);                  break;
        case 1:   wd->setToolTip(*qstr);                    break;
        case 2:   wd->setStatusTip(*qstr);                  break;
        case 3:   wd->setWhatsThis(*qstr);                  break;
    }
}
extern "C" int qteQTableWidgetItem_setYY(QTableWidgetItem* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
        case 0:  rez = wd->column();                  break;
        case 1:  rez = wd->row();                     break;
        case 2:  rez = wd->textAlignment();           break;
        case 3:  rez = wd->type();                    break;
    }
    return rez;
}
extern "C" void qteQTableWidgetItem_text(QTableWidgetItem* wd, QString* qs) {
    *qs = wd->text();
}
extern "C" void qteQTableWidgetItem_setAligment(QTableWidgetItem* wd, int alig) {
    wd->setTextAlignment(alig);
}
extern "C" void qteQTableWidgetItem_setBackground(QTableWidgetItem* wd, QBrush* qb, int pr) {
    switch ( pr ) {
        case 0:  wd->setBackground(*qb);                  break;
        case 1:  wd->setForeground(*qb);                  break;
    }
}

// =========== QTableWidget ==========
extern "C" QTableWidget* qteQTableWidget_create(QWidget* parent) {
    return new QTableWidget(parent);
}
extern "C" void qteQTableWidget_delete(QTableWidget* wd) {
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
extern "C" void qteQTableWidget_setRC(QTableWidget* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setColumnCount(n);                 break;
    case 1:   wd->setRowCount(n);                    break;
    case 2:   wd->insertColumn(n);                   break;
    case 3:   wd->insertRow(n);                      break;
    case 4:   wd->clear();                           break;
    case 5:   wd->clearContents();                   break;
    }
}
extern "C" void qteQTableWidget_setitem(QTableWidget* wd,
                        QTableWidgetItem* tw, int r, int c) {
    wd->setItem(r, c, tw);
}
extern "C" QTableWidgetItem* qteQTableWidget_item(QTableWidget* wd, int r, int c) {
    return wd->item(r, c);
}
// 176
extern "C" void qteQTableWidget_setHVheaderItem(QTableWidget* wd,
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
extern "C" void qteQTableWidget_setCurrentCell (QTableWidget* wd, int row, int column ) {
    wd->setCurrentCell(row, column);
}

// =========== QComboBox ==========
extern "C" QComboBox* qteQComboBox_create(QWidget* parent) {
    return new QComboBox(parent);
}
extern "C" void qteQComboBox_delete(QComboBox* wd) {
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
extern "C" void qteQComboBox_setXX(QComboBox* wd, QString *qstr, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->addItem(*qstr, n);       break;
    case 1:   wd->setItemText(n, *qstr);   break;
    case 2:   wd->setMaxCount(n);          break;
    case 3:   wd->setMaxVisibleItems(n);   break;
    }
}
extern "C" int qteQComboBox_getXX(QComboBox* wd, int pr) {
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
extern "C" void qteQComboBox_text(QComboBox* wd, QString* qs) {
    *qs = wd->currentText();
}
// =========== QPainter ==========
extern "C" void qteQPainter_drawPoint(QPainter* qp, int x, int y, int pr) {
    switch ( pr ) {
    case 0:   qp->drawPoint(x, y);          break;
    case 1:   qp->setBrushOrigin(x, y);     break;
    }
}
extern "C" void qteQPainter_drawLine(QPainter* qp, int x1, int y1, int x2, int y2) {
    qp->drawLine(x1, y1, x2, y2);
}
// 243
extern "C" void qteQPainter_drawRect1(QPainter* qp, int x1, int y1, int w, int h) {
    qp->drawRect(x1, y1, w, h);
}
// 244
extern "C" void qteQPainter_drawRect2(QPainter* qp, QRect* qr) {
    qp->drawRect(*qr);
}
// 245
extern "C" void qteQPainter_fillRect2(QPainter* qp, QRect* qr, QColor* cl) {
    qp->fillRect(*qr, *cl);
}
// 246
extern "C" void qteQPainter_fillRect3(QPainter* qp, QRect* qr, Qt::GlobalColor gc) {
    qp->fillRect(*qr, gc);
}

extern "C" void qteQPainter_setXX1(QPainter* qp, void* ob, int pr) {
    switch ( pr ) {
    case 0:   qp->setBrush(*((QBrush*)ob)); break;
    case 1:   qp->setPen(*((QPen*)ob)); break;
    }
}
extern "C" void qteQPainter_setText(QPainter* qp, QString* ob, int x, int y) {
    qp->drawText(x, y, *ob);
}
extern "C" bool qteQPainter_end(QPainter* qp) {
    return qp->end();
}
// =========== QLCDNumber ==========
extern "C" QLCDNumber* qteQLCDNumber_create1(QWidget* parent) {
    return new QLCDNumber(parent);
}
extern "C" QLCDNumber* qteQLCDNumber_create2(QWidget* parent, int n) {
    return new QLCDNumber(n, parent);
}
extern "C" void qteQLCDNumber_delete1(QLCDNumber* wd) {
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
extern "C" void qteQLCDNumber_display(QLCDNumber* wd, int n) {
    wd->display(n);
}
// 202
extern "C" void qteQLCDNumber_setSegmentStyle(QLCDNumber* wd, QLCDNumber::SegmentStyle n) {
    wd->setSegmentStyle(n);
}
// 203
extern "C" void qteQLCDNumber_setDigitCount(QLCDNumber* wd, int n) {
    wd->setDigitCount(n);
}
extern "C" void qteQLCDNumber_setMode(QLCDNumber* wd, QLCDNumber::Mode n) {
    wd->setMode(n);
}
// =========== QAbstractSlider ==========
extern "C" void qteQAbstractSlider_setXX(QAbstractSlider* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setMaximum(n);          break;
    case 1:   wd->setMinimum(n);          break;
    case 2:   wd->setPageStep(n);         break;
    case 3:   wd->setSingleStep(n);       break;
    case 4:   wd->setSliderPosition(n);   break;
    }
}
extern "C" int qteQAbstractSlider_getXX(QAbstractSlider* wd, int pr) {
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
extern "C" QSlider* qteQSlider_create1(QWidget* parent, Qt::Orientation n) {
    return new QSlider(n, parent);
}
extern "C" void qteQSlider_delete1(QSlider* wd) {
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
extern "C" QGroupBox* qteQGroupBox_create(QWidget* parent) {
    return new QGroupBox(parent);
}
extern "C" void qteQGroupBox_delete(QGroupBox* wd) {
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
extern "C" void qteQGroupBox_setTitle(QGroupBox* wd, QString* str) {
    wd->setTitle(*str);
}
extern "C" void qteQGroupBox_setAlignment(QGroupBox* wd, Qt::AlignmentFlag str) {
    wd->setAlignment(str);
}
// =========== QCheckBox ==========
extern "C" QCheckBox* qteQCheckBox_create1(QWidget* parent, QString* name) {
    return  new QCheckBox(*name, parent);
}
extern "C" void qteQCheckBox_delete(QCheckBox* wd) {
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
extern "C" int qteQCheckBox_checkState(QCheckBox* qs) {
    return (int)qs->checkState();
}
extern "C" void qteQCheckBox_setCheckState(QCheckBox* qs, Qt::CheckState st) {
    qs->setCheckState(st);
}
extern "C" void qteQCheckBox_setTristate(QCheckBox* qs, bool st) {
    qs->setTristate(st);
}
extern "C" bool qteQCheckBox_isTristate(QCheckBox* qs) {
    return qs->isTristate();
}
// =========== QRadioButton ==========
extern "C" QRadioButton* qteQRadioButton_create1(QWidget* parent, QString* name) {
    return  new QRadioButton(*name, parent);
}
extern "C" void qteQRadioButton_delete(QRadioButton* wd) {
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
extern "C" QTextCursor* qteQTextCursor_create1(QTextDocument * document) {
    return  new QTextCursor(document);
}
extern "C" QTextCursor* qteQTextCursor_create2() {
    return  new QTextCursor();
}
extern "C" void qteQTextCursor_delete(QTextCursor* wd) {
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
extern "C" int qteQTextCursor_getXX1(QTextCursor* wd, int pr) {
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
extern "C" void qteQTextCursor_runXX(QTextCursor* wd, int pr) {
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
extern "C" void qteQTextCursor_insertText1(QTextCursor* wd, QString* name) {
    wd->insertText(*name);
}

// 254
extern "C" bool qteQTextCursor_movePosition(
                QTextCursor* wd,
                QTextCursor::MoveOperation op,
                QTextCursor::MoveMode mode,
                int n) {
    return wd->movePosition(op, mode, n);
}
// 286
extern "C" void qteQTextCursor_select(QTextCursor* wd, QTextCursor::SelectionType type) {
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
extern "C" QRect* qteQRect_create1() {
    return  new QRect();
}
extern "C" void qteQRect_delete(QRect* wd) {
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
extern "C" int qteQRect_setXX1(QRect* wd, int pr) {
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
extern "C" void qteQRect_setXX2(QRect* wd, int x1, int y1, int x2, int y2, int pr) {
    switch ( pr ) {
    case 0:   wd->setCoords(x1, y1, x2, y2);           break;
    case 1:   wd->setRect(x1, y1, x2, y2);           break;
    }
}

// =========== QTextBlock ==========
// 240
extern "C" QTextBlock* qteQTextBlock_create2(QTextCursor* tk) {
    QTextBlock* tb = new QTextBlock();
    *tb = tk->block();
    return tb;
}
// 238
extern "C" QTextBlock* qteQTextBlock_create() {
    return new QTextBlock();
}
// 239
extern "C" void qteQTextBlock_delete(QTextBlock* wd) {
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
extern "C" QString* qteQTextBlock_text(QTextBlock* tb, QString* rez) {
    *rez = tb->text();
    return rez;
}
// 283
extern "C" int qteQTextBlock_blockNumber(QTextBlock* tb) {
    return tb->blockNumber();
}

// =========== QAbstractSpinBox ==========
// 252
extern "C" void qteQAbstractSpinBox_setReadOnly(QAbstractSpinBox* wd, bool f) {
    wd->setReadOnly(f);
}
// =========== QSpinBox ==========
// 247
extern "C" QSpinBox* qteQSpinBox_create(QWidget* parent) {
    return new QSpinBox(parent);
}
// 248
extern "C" void qteQSpinBox_delete(QSpinBox* wd) {
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
extern "C" void qteQSpinBox_setXX1(QSpinBox* wd, int n, int pr) {
    switch ( pr ) {
    case 0:   wd->setMinimum(n);           break;
    case 1:   wd->setMaximum(n);           break;
    case 2:   wd->setSingleStep(n);        break;
    }
}
// 250
extern "C" int qteQSpinBox_getXX1(QSpinBox* wd, int pr) {
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
extern "C" void qteQSpinBox_setXX2(QSpinBox* wd, QString *str, int pr) {
    switch ( pr ) {
    case 0:   wd->setPrefix(*str);           break;
    case 1:   wd->setSuffix(*str);           break;
    }
}

// =========== Highlighter ==========
Highlighter::Highlighter(QTextDocument *parent) : QSyntaxHighlighter(parent) {
     HighlightingRule rule;

     keywordFormat.setForeground(Qt::magenta);
     // keywordFormat.setFontWeight(QFont::Bold);
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

     singleLineCommentFormat.setForeground(Qt::darkGreen);
     rule.pattern = QRegExp("//[^\n]*");
     rule.format = singleLineCommentFormat;
     highlightingRules.append(rule);

     multiLineCommentFormat.setForeground(Qt::darkGreen);

     quotationFormat.setForeground(Qt::darkGreen);
     rule.pattern = QRegExp("\".*\"");
     rule.format = quotationFormat;
     highlightingRules.append(rule);

     // functionFormat.setFontItalic(true);
     functionFormat.setForeground(Qt::blue);
     rule.pattern = QRegExp("\\b[A-Za-z0-9_]+(?=\\()");
     rule.format = functionFormat;
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

extern "C" Highlighter* qteHighlighter_create(QTextDocument* parent) {
    return new Highlighter(parent);
}
extern "C" void qteHighlighter_delete(Highlighter* wd) {
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
extern "C" eQTextEdit* qteQTextEdit_create1(QWidget* parent) {
    return new eQTextEdit(parent);
}
extern "C" void qteQTextEdit_delete1(eQTextEdit* wd) {
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
extern "C" void qteQTextEdit_setKeyPressEvent(eQTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
    wd->aDThis = aThis;
}
extern "C" void qteQTextEdit_setKeyReleaseEvent(eQTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyReleaseEvent = adr;
    wd->aDThis = aThis;
}
// extern "C" void qteQTextEdit_appendPlainText(QTextEdit* wd, QtRefH str) {
//    wd->appendPlainText((const QString &)*str);
// }
// extern "C" void qteQTextEdit_appendHtml(QTextEdit* wd, QtRefH str) {
//    wd->appendHtml((const QString &)*str);
// }
extern "C" void qteQTextEdit_setPlainText(QTextEdit* wd, QtRefH str) {
    wd->setPlainText((const QString &)*str);
}
extern "C" void qteQTextEdit_insertPlainText(QTextEdit* wd, QtRefH str) {
    wd->insertPlainText((const QString &)*str);
}
extern "C" void qteQTextEdit_cutn(QTextEdit* wd, int pr) {
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
extern "C" void qteQTextEdit_toPlainText(QTextEdit* wd, QtRefH qs) {
    *(QString*)qs = wd->toPlainText();
}
extern "C" QTextDocument* qteQTextEdit_document(QTextEdit* wd) {
    return wd->document();
}
// 230
extern "C" void qteQTextEdit_textCursor(QTextEdit* wd, QTextCursor* tk) {
    *tk = wd->textCursor();
}
// 253
extern "C" void qteQTextEdit_setTextCursor(QTextEdit* wd, QTextCursor* tk) {
    wd->setTextCursor(*tk);
}
extern "C" void qteQTextEdit_cursorRect(QTextEdit* wd, QRect* tk) {
    *tk = wd->cursorRect();
}
extern "C" void qteQTextEdit_setTabStopWidth(QTextEdit* wd, int width) {
    wd->setTabStopWidth(width);
}
// ===================== QTimer ====================
// 262
extern "C" QTimer* qteQTimer_create(QObject* parent) {
    return new QTimer(parent);
}
// 263
extern "C" void qteQTimer_delete(QTimer* wd) {
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
extern "C" void qteQTimer_setInterval(QTimer* wd, int msek) {
    wd->setInterval(msek);
}
// 265
extern "C" int qteQTimer_getXX1(QTimer* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->interval();          break;
    case 1:   rez = wd->remainingTime();     break;
    case 2:   rez = wd->timerId();           break;
    }
    return rez;
}
// 266
extern "C" bool qteQTimer_getXX2(QTimer* wd, int pr) {
    int rez = 0;
    switch ( pr ) {
    case 0:   rez = wd->isActive();          break;
    case 1:   rez = wd->isSingleShot();      break;
    }
    return rez;
}
// 267
extern "C" void qteQTimer_setTimerType(QTimer* wd, Qt::TimerType t) {
    wd->setTimerType(t);
}
// 268
extern "C" void qteQTimer_setSingleShot(QTimer* wd, bool t) {
    wd->setSingleShot(t);
}
// 269
extern "C" Qt::TimerType qteQTimer_timerType(QTimer* wd) {
    return wd->timerType();
}
// ===================== QTextOption ====================
// 291
extern "C" QTextOption* QTextOption_create() {
    return new QTextOption();
}
// 292
extern "C" void QTextOption_delete(QTextOption* wd) {
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
extern "C" void QTextOption_setWrapMode(QTextOption* wd, QTextOption::WrapMode mode) {
    wd->setWrapMode(mode);
}
