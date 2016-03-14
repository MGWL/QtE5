#ifndef QTE5WIDGETS_H
#define QTE5WIDGETS_H

#include "qte5widgets_global.h"

#include <QObject>
#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QHBoxLayout>
#include <QFrame>
#include <QLabel>
#include <QResizeEvent>
#include <QSize>
#include <QKeyEvent>
#include <QAbstractScrollArea>
#include <QPlainTextEdit>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QtRef__ { PTRINT dummy; } *QtRefH;

extern "C" typedef void (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__b)(bool);
extern "C" typedef void  (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__v)(void);

extern "C" typedef void  (*ExecZIM_v__vp)(void*);
extern "C" typedef bool  (*ExecZIM_b__vp)(void*);

class QSlot : public QObject {
    Q_OBJECT

public:
    void* aSlotN;       // Хранит адрес D функции для вызова с параметром
    void* aDThis;       // Хранит адрес экземпляра объекта D
    int        N;       // параметр для aSlotN. Идея запомнить параметр при установке слота и выдать
                        // при срабатывании слота. А ля - диспечерезация
public:
    explicit QSlot(QObject* parent = 0);
    ~QSlot();
private slots:
    void Slot();
    void SlotN();
    void Slot_Bool(bool);
    void Slot_Int(int);
};

class eQWidget : public QWidget {
    // Q_OBJECT

public:
    void* aKeyPressEvent;
    void* aPaintEvent;
    void* aCloseEvent;
    void* aResizeEvent;

public:
    explicit eQWidget(QWidget* parent, Qt::WindowFlags f);
    ~eQWidget();

protected:
    void keyPressEvent(QKeyEvent* event);
    void paintEvent(QPaintEvent* event);
    void closeEvent(QCloseEvent* event);
    void resizeEvent(QResizeEvent* event);
};

class eQFrame : public QFrame {
    // Q_OBJECT
public:
    void* aKeyPressEvent;
    void* aPaintEvent;
    void* aCloseEvent;
    void* aResizeEvent;
public:
    explicit eQFrame(QWidget* parent, Qt::WindowFlags f);
    ~eQFrame();
protected:
    void keyPressEvent(QKeyEvent* event);
    void paintEvent(QPaintEvent* event);
    void closeEvent(QCloseEvent* event);
    void resizeEvent(QResizeEvent* event);
};


class eQPlainTextEdit : public QPlainTextEdit {
    // Q_OBJECT
public:
    void* aKeyPressEvent;
public:
    explicit eQPlainTextEdit(QWidget* parent);
    ~eQPlainTextEdit();
protected:
    void keyPressEvent(QKeyEvent* event);
};


#endif // QTE5WIDGETS_H
