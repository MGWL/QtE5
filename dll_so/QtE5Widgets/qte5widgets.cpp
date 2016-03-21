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
extern "C" void qteQStatusBar_showMessage(QStatusBar* wd, QString* qs, int ms) {
    ((QWidget*)wd)->setStyleSheet(*(QString*)qs);
    wd->showMessage(*qs, ms);
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
    }
}

// =========== QWidget ==========
eQWidget::eQWidget(QWidget *parent, Qt::WindowFlags f): QWidget(parent, f) {
    aKeyPressEvent = NULL;
    aPaintEvent = NULL;
    aCloseEvent = NULL;
    aResizeEvent = NULL;
}
eQWidget::~eQWidget() {
}
extern "C" void qteQWidget_setKeyPressEvent(QtRefH wd, void* adr) {
    ((eQWidget*)wd)->aKeyPressEvent = adr;
}
void eQWidget::keyPressEvent(QKeyEvent *event) {
    if(aKeyPressEvent != NULL) {
        ((ExecZIM_v__vp)aKeyPressEvent)((QtRefH)event);
    }
}
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
    aKeyPressEvent = NULL;
}
eQPlainTextEdit::~eQPlainTextEdit() {
}
void eQPlainTextEdit::keyPressEvent(QKeyEvent *event) {
    if(aKeyPressEvent != NULL) {
        if(((ExecZIM_b__vp)aKeyPressEvent)((QtRefH)event)) {
            QPlainTextEdit::keyPressEvent(event);
        }
    }
    else {
        QPlainTextEdit::keyPressEvent(event);
    }
}

extern "C" eQPlainTextEdit* qteQPlainTextEdit_create1(QWidget* parent) {
    return new eQPlainTextEdit(parent);
}
extern "C" void qteQPlainTextEdit_delete1(eQPlainTextEdit* wd) {
    delete wd;
}
extern "C" void qteQPlainTextEdit_setKeyPressEvent(eQPlainTextEdit* wd, void* adr) {
    wd->aKeyPressEvent = adr;
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
