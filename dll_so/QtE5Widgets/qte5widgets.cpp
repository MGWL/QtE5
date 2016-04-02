#include "qte5widgets.h"

// =========== QApplication ==========
extern "C" QtRefH qteQApplication_create1(int* argc, char *argv[], int AnParam3) {
    return (QtRefH)new QApplication(*argc, argv, AnParam3);
}
extern "C" void qteQApplication_delete1(QtRefH app) {
    delete (QApplication*)app;
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
// =========== QLineEdit ==========
eQLineEdit::eQLineEdit(QWidget *parent): QLineEdit(parent) {
}
eQLineEdit::~eQLineEdit() {
}
extern "C" eQLineEdit* qteQLineEdit_create1(QWidget* parent) {
    return new eQLineEdit(parent);
}
extern "C" void qteQLineEdit_delete1(eQLineEdit* wd) {
    delete wd;
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
// =========== QStatusBar ==========
extern "C" QStatusBar* qteQStatusBar_create1(QWidget* parent) {
    return new QStatusBar(parent);
}
extern "C" void qteQStatusBar_delete1(QStatusBar* wd) {
    delete wd;
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
    delete wd;
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

extern "C" void qteQWidget_setPaintEvent(QtRefH wd, void* adr) {
    ((eQWidget*)wd)->aPaintEvent = adr;
}
void eQWidget::paintEvent(QPaintEvent *event) {
    if(aPaintEvent != NULL) {
        ((ExecZIM_v__vp)aPaintEvent)((QtRefH)event);
    }
}
extern "C" void qteQWidget_setCloseEvent(QtRefH wd, void* adr) {
    ((eQWidget*)wd)->aCloseEvent = adr;
}
void eQWidget::closeEvent(QCloseEvent *event) {
    if(aCloseEvent != NULL) {
        ((ExecZIM_v__vp)aCloseEvent)((QtRefH)event);
    }
}
extern "C" void qteQWidget_setResizeEvent(eQWidget* wd, void* adr) {
    wd->aResizeEvent = adr;
}
void eQWidget::resizeEvent(QResizeEvent *event) {
    if(aResizeEvent != NULL) {
         ((ExecZIM_v__vp)aResizeEvent)(event);
    }
}
extern "C" QtRefH qteQWidget_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new eQWidget((eQWidget*)parent, f);
}
extern "C" void qteQWidget_delete1(QtRefH wd) {
    delete (eQWidget*)wd;
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

// =========== QString ==========
extern "C" QtRefH qteQString_create1(void) {
    return (QtRefH)new QString();
}
// QString из wchar
extern "C" QtRefH qteQString_create2(QChar* s, int size) {
    return (QtRefH)new QString(s, size);
}
extern "C" void qteQString_delete(QtRefH qs) {
    delete (QString*)qs;
}
extern "C" QtRefH qteQString_data(QtRefH qs) {
    return (QtRefH)((QString*)qs)->data();
}
extern "C" int qteQString_size(QtRefH qs) {
    return ((QString*)qs)->size();
}
// =========== QColor ==========
extern "C" QtRefH qteQColor_create1(void) {
    return (QtRefH)new QColor();
}
extern "C" void qteQColor_delete(QtRefH qs) {
    delete (QColor*)qs;
}
extern "C" void qteQColor_setRgb(QtRefH wc, int r, int g, int b, int a) {
    ((QColor*)wc)->setRgb(r,g,b,a);
}
// =========== QPalette ==========
extern "C" QtRefH qteQPalette_create1(void) {
    return (QtRefH)new QPalette();
}
extern "C" void qteQPalette_delete(QtRefH qs) {
    delete (QPalette*)qs;
}
// =========== QPushButton =========
extern "C" QtRefH qteQPushButton_create1(QtRefH parent, QtRefH name) {
    return  (QtRefH) new QPushButton((const QString &)*name, (QWidget*)parent);
}
extern "C" void qteQPushButton_delete(QtRefH qs) {
    delete (QPushButton*)qs;
}
// =========== QAbstractButton =========
extern "C" void qteQAbstractButton_setText(QtRefH wd, QtRefH qs) {
    ((QAbstractButton*)wd)->setText( (const QString &)*qs  );
}
extern "C" void qteQAbstractButton_text(QtRefH wd, QtRefH qs) {
    *(QString*)qs = ((QAbstractButton*)wd)->text();
}
// =========== QSlot ==========
QSlot::QSlot(QObject* parent) : QObject(parent) {
    aSlotN = NULL;
         N = 0;
}
QSlot::~QSlot() {
}
// Вызов конструктора слота
extern "C" QtRefH qteQSlot_create(QtRefH parent) {
    return (QtRefH) new QSlot((QObject*)parent);
}
extern "C" void qteQSlot_delete(QtRefH parent) {
    delete (QSlot*)parent;
}
void QSlot::SlotN() { // Вызвать глобальную функцию с параметром N (диспетчерезатор)
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(N);
}
void QSlot::Slot() {
    if ((aSlotN != NULL) && (aDThis == NULL)) { ((ExecZIM_v__v)aSlotN)(); }
    if ((aSlotN != NULL) && (aDThis != NULL)) { ((ExecZIM_v__vp)aSlotN)(*(void**)aDThis); }
}
extern "C" void QSlot_setSlotN(QSlot* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}
extern "C" void QSlot_setSlotN2(QSlot* slot, void* adr, void* adrTh, int n) {
    slot->aSlotN = adr;
    slot->aDThis = adrTh;
    slot->N = n;
}

extern "C" void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
void QSlot::Slot_Bool(bool b) { // Вызвать глобальную функцию с параметром b - булево
    if (aSlotN != NULL)  ((ExecZIM_v__b)aSlotN)(b);
}
void QSlot::Slot_Int(int i) { // Вызвать глобальную функцию с параметром
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(i);
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
extern "C" void qteQBoxLayout_delete(QtRefH parent) {
    delete (QBoxLayout*)parent;
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
extern "C" void qteQFrame_delete1(QtRefH wd) {
    delete (eQFrame*)wd;
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
// ===================== QLsbel ====================
extern "C" QtRefH qteQLabel_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new QLabel((QWidget*)parent, f);
}
extern "C" void qteQLabel_delete1(QtRefH wd) {
    delete (QLabel*)wd;
}
extern "C" void qteQLabel_setText(QtRefH wd, QtRefH qs) {
    ((QLabel*)wd)->setText(*(QString*)qs);
}
// ===================== QEvent ====================
extern "C" int qteQEvent_type(QEvent* ev) {
    return ev->type();
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
extern "C" void qteQSize_delete1(QtRefH wd) {
    delete (QSize*)wd;
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
// ===================== QAbstractScrollArea ====================
extern "C" QtRefH qteQAbstractScrollArea_create1(QtRefH parent) {
    return (QtRefH)new QAbstractScrollArea((QWidget*)parent);
}
extern "C" void qteQAbstractScrollArea_delete1(QtRefH wd) {
    delete (QAbstractScrollArea*)wd;
}
// ===================== QPlainTextEdit ====================

eQPlainTextEdit::eQPlainTextEdit(QWidget *parent): QPlainTextEdit(parent) {
    aKeyPressEvent = NULL; aDThis = NULL;
}
eQPlainTextEdit::~eQPlainTextEdit() {
}
void eQPlainTextEdit::keyPressEvent(QKeyEvent* event) {
    QKeyEvent* otv;
    // Если нет перехвата, отдай событие
    if (aKeyPressEvent == NULL) {
        QPlainTextEdit::keyPressEvent(event); return;
    }
    if ((aKeyPressEvent != NULL) && (aDThis == NULL)) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp)aKeyPressEvent)((QtRefH)event);
        if(otv != NULL) {  QPlainTextEdit::keyPressEvent(otv); }
        return;
    }
    if ((aKeyPressEvent != NULL) && (aDThis != NULL)) {
        otv = (QKeyEvent*)((ExecZIM_vp__vp_vp)aKeyPressEvent)(*(void**)aDThis, (QtRefH)event);
        if(otv != NULL) {  QPlainTextEdit::keyPressEvent(otv); }
    }
}

extern "C" eQPlainTextEdit* qteQPlainTextEdit_create1(QWidget* parent) {
    return new eQPlainTextEdit(parent);
}
extern "C" void qteQPlainTextEdit_delete1(eQPlainTextEdit* wd) {
    delete wd;
}
extern "C" void qteQPlainTextEdit_setKeyPressEvent(eQPlainTextEdit* wd, void* adr, void* aThis) {
    wd->aKeyPressEvent = adr;
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
// ===================== QAction ====================
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
// -------------------------------------------------------
extern "C" void* qteQAction_create(QObject * parent) {  return new eAction(parent); }
extern "C" void  qteQAction_delete(eAction* wd)      {  delete wd; }

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
    delete wd;
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
    delete wd;
}
extern "C" void qteQMenuBar_addMenu(QMenuBar* wd, QMenu* mn) {
    wd->addMenu(mn);
}
// ============ QFont =======================================
extern "C"  void* qteQFont_create() {
     return new QFont();
}
extern "C" void qteQFont_delete(QFont* wd) {
    delete wd;
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
    delete wd;
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
    delete wd;
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
    delete wd;
}
extern "C" int qteQDialog_exec(QDialog* wd) {
    return wd->exec();
}
// ============ QMessageBox ====================================
extern "C" QMessageBox* qteQMessageBox_create(QWidget* parent) {
    return new QMessageBox(parent);
}
extern "C" void qteQMessageBox_delete(QMessageBox* wd) {
    delete wd;
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
    delete wd;
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
    delete wd;
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
    delete wd;
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
    return new QFileDialog(parent, f);
}
extern "C" void qteQFileDialog_delete(QFileDialog* wd) {
    delete wd;
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
extern "C" QString* qteQFileDialog_getOpenFileName(
        QFileDialog* wd,
        QWidget* parent,
        QString* rez,
        QString* caption,
        QString* dir,
        QString* filter,
        QString* selectedFilter,
        QFileDialog::Option f) {
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
