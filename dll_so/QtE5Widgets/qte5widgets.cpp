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

// =========== QWidget ==========
extern "C" QtRefH qteQWidget_create1(QtRefH parent, Qt::WindowFlags f) {
    return (QtRefH)new QWidget((QWidget*)parent, f);
}
extern "C" void qteQWidget_delete1(QtRefH wd) {
    delete (QWidget*)wd;
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

typedef void (*ExecZIM_v__i)(int);
typedef void (*ExecZIM_v__b)(bool);
typedef void (*ExecZIM_v__i)(int);

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
extern "C" void QSlot_setSlotN(QSlot* slot, void* adr, int n) {
    slot->aSlotN = adr;
    slot->N = n;
}
extern "C" void qteConnect(QtRefH obj1, char* signal, QtRefH slot, char* sslot, int n) {
    QObject::connect((const QObject*)obj1, (const char*)signal, (const QObject*)slot,
                     (const char*)sslot, (Qt::ConnectionType)n);
}
void QSlot::Slot_Bool(bool b) // Вызвать глобальную функцию с параметром N (диспетчерезатор)
{
    if (aSlotN != NULL)  ((ExecZIM_v__b)aSlotN)(b);
}
void QSlot::Slot_Int(int i) // Вызвать глобальную функцию с параметром N (диспетчерезатор)
{
    if (aSlotN != NULL)  ((ExecZIM_v__i)aSlotN)(i);
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
