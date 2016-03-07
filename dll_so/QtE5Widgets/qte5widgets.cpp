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
extern "C" void qteQWidget_setLayout(QtRefH wd, QtRefH la)
{
    ((QWidget*)wd)->setLayout((QLayout*)la);
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
QSlot::~QSlot()
{
}
// Вызов конструктора слота
extern "C" QtRefH qteQSlot_create(QtRefH parent) {
    return (QtRefH) new QSlot((QObject*)parent);
}
extern "C" void qteQSlot_delete(QtRefH parent) {
    delete (QSlot*)parent;
}
void QSlot::SlotN() // Вызвать глобальную функцию с параметром N (диспетчерезатор)
{
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(N);
}
void QSlot::Slot()
{
    if (aSlotN != NULL)  ((ExecZIM_v__v)aSlotN)();
}
extern "C" void QSlot_setSlotN(QSlot* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}
extern "C" void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
void QSlot::Slot_Bool(bool b) // Вызвать глобальную функцию с параметром b - булево
{
    if (aSlotN != NULL)  ((ExecZIM_v__b)aSlotN)(b);
}
void QSlot::Slot_Int(int i) // Вызвать глобальную функцию с параметром
{
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(i);
}
// ===================== QLyout ====================
extern "C" QtRefH qteQVBoxLayout(void)
{
    return  (QtRefH) new QVBoxLayout();
}
extern "C" QtRefH qteQHBoxLayout(void)
{
    return  (QtRefH) new QHBoxLayout();
}
extern "C" QtRefH qteQBoxLayout(QtRefH wd, QBoxLayout::Direction dir)
{
    return  (QtRefH) new QBoxLayout(dir, (QWidget*)wd);
}
extern "C" void qteQBoxLayout_delete(QtRefH parent) 
{
    delete (QBoxLayout*)parent;
}
extern "C" void qteQBoxLayout_addWidget(QtRefH BoxLyout, QtRefH widget, int stretch, int align)
{
    ((QBoxLayout*)BoxLyout)->addWidget((QWidget*)widget, stretch, (Qt::Alignment)align);
}
extern "C" void qteQBoxLayout_addLayout(QtRefH BoxLyout, QtRefH layout)
{
	((QBoxLayout*)BoxLyout)->addLayout((QBoxLayout*)layout);
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




/*
QSlot::~QSlot()
{
}
*/

/*
void eSlot::SlotN() // Вызвать глобальную функцию с параметром N (диспетчерезатор)
{
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(N);
}
void eSlot::Slot0()
{
    if (aSlot0 != NULL)  ((ExecZIM_0_0)aSlot0)();
}
void eSlot::Slot1(bool par1)
{
    if (aSlot1 != NULL) ((ExecZIM_1_0)aSlot1)((void*)par1);
}
void eSlot::Slot1(int par1)
{
    if (aSlot1 != NULL) ((ExecZIM_v__i)aSlot1)(par1);
}
void eSlot::Slot1(QAbstractSocket::SocketError par1)
{
    if (aSlot1 != NULL) ((ExecZIM_v__i)aSlot1)(par1);
}
void eSlot::Slot1_int(size_t par1)
{
    if (aSlot1 != NULL) ((ExecZIM_1_0)aSlot1)((void*)par1);
}
void eSlot::sendSignal0() {
    emit Signal0();
}
void eSlot::sendSignal1(void* par1) {
    emit Signal1(par1);
}

extern "C" void* qte_eSlot(QObject * parent) {
     return new eSlot(parent);
}
extern "C" void eSlot_setSlot(size_t n, eSlot* slot, void* adr) {
    if (n==0) slot->aSlot0 = adr;
    if (n==1) slot->aSlot1 = adr;
}
extern "C" void eSlot_setSlotN(eSlot* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}
extern "C" void eSlot_setSlot0(eSlot* slot, void* adr) {
     slot->aSlot0 = adr;
}
extern "C" void eSlot_setSlot1(eSlot* slot, void* adr) {
     slot->aSlot1 = adr;
}
extern "C" void eSlot_setSignal0(eSlot* slot) {
     slot->sendSignal0();
}
extern "C" void eSlot_setSignal1(eSlot* slot, void* par1) {
     slot->sendSignal1(par1);
}
*/
