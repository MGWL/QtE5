#ifndef QTE5WIDGETS_H
#define QTE5WIDGETS_H

#include "qte5widgets_global.h"

#include <QObject>
#include <QApplication>
#include <QWidget>
#include <QPushButton>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QtRef__ { PTRINT dummy; } *QtRefH;

class QSlot : public QObject {
    Q_OBJECT

public:
    void* aSlotN;       // Хранит адрес D функции для вызова с параметром
    int        N;       // параметр для aSlotN. Идея запомнить параметр при установке слота и выдать
                        // при срабатывании слота. А ля - диспечерезация
public:
    explicit QSlot(QObject* parent = 0);
    ~QSlot();
private slots:
    void SlotN();
    void Slot_Bool(bool);
    void Slot_Int(int);
};

/*
class gSlot : public QObject
{
    Q_OBJECT
public:
    void* aSlot0;       // Хранит адрес D функции
    void* aSlot1;       // Хранит адрес D функции
    void* aSlotN;       // Хранит адрес D функции для вызова с параметром
    int        N;       // параметр для aSlotN. Идея запомнить параметр при установке слота и выдать
                        // при срабатывании слота. А ля - диспечерезация
    // -----------------------------------
    gSlot(QObject* parent = 0);
    // ~Q_Slot();
};
*/

/*
    void sendSignal0();
    void sendSignal1(void*);
public slots:
    void SlotN();
    void Slot0();
    void Slot1(bool);
    void Slot1(int);
    void Slot1(QAbstractSocket::SocketError);
    void Slot1_int(size_t);
signals:
    void Signal0();
    void Signal1(void*);

};
*/




#endif // QTE5WIDGETS_H
