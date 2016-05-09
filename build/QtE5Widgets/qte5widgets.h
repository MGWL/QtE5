#ifndef QTE5WIDGETS_H
#define QTE5WIDGETS_H

#include "qte5widgets_global.h"

#include <QObject>
#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QHBoxLayout>
#include <QFrame>
#include <QLineEdit>
#include <QLabel>
#include <QResizeEvent>
#include <QSize>
#include <QKeyEvent>
#include <QAbstractScrollArea>
#include <QPlainTextEdit>
#include <QMainWindow>
#include <QStatusBar>
#include <QAction>
#include <QMenu>
#include <QMenuBar>
#include <QToolBar>
#include <QDialog>
#include <QMessageBox>
#include <QFont>
#include <QProgressBar>
#include <QDate>
#include <QTime>
#include <QFileDialog>
#include <QAbstractScrollArea>
#include <QMdiArea>
#include <QMdiSubWindow>
#include <QAbstractItemView>
#include <QTableView>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QBrush>
#include <QHeaderView>
#include <QComboBox>
#include <QPainter>
#include <QPen>
#include <QLCDNumber>
#include <QAbstractSlider>
#include <QSlider>
#include <QGroupBox>
#include <QCheckBox>
#include <QRadioButton>
#include <QTextCursor>
#include <QTextDocument>
#include <QTextBlock>
#include <QSpinBox>
#include <QSyntaxHighlighter>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QtRef__ { PTRINT dummy; } *QtRefH;

extern "C" typedef void (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__b)(bool);
extern "C" typedef void  (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__v)(void);

extern "C" typedef void  (*ExecZIM_v__vp_n_i)(void*, int, int);
extern "C" typedef void  (*ExecZIM_v__vp_n_b)(void*, int, bool);
extern "C" typedef void  (*ExecZIM_v__vp_n)(void*, int);


extern "C" typedef void  (*ExecZIM_v__vp)(void*);

extern "C" typedef void  (*ExecZIM_v__vp_vp)(void*, void*);
extern "C" typedef void  (*ExecZIM_v__vp_vp_vp)(void*, void*, void*);

extern "C" typedef bool  (*ExecZIM_b__vp)(void*);
extern "C" typedef void* (*ExecZIM_vp__vp_vp)(void*, void*);
extern "C" typedef void* (*ExecZIM_vp__vp)(void*);

//___________________________________________________
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
//    void Slot_v__A_N_i(int);
};
//___________________________________________________
class eAction : public QAction {
    Q_OBJECT

public:
    explicit eAction(QObject *parent);
    ~eAction();

    void* aSlotN;       // Хранит адрес D функции для вызова с параметром
    void* aDThis;       // Хранит адрес экземпляра объекта D
    int        N;       // параметр для aSlotN. Идея запомнить параметр при установке слота и выдать
                        // при срабатывании слота. А ля - диспечерезация

private slots:
    void Slot();
    void SlotN();
    void Slot_Bool(bool);
    void Slot_Int(int);
    void Slot_v__A_N_i(int);
    void Slot_v__A_N_b(bool);
    void Slot_v__A_N_v();
};

//___________________________________________________
class eQMainWindow : public QMainWindow {
    // Q_OBJECT

public:
    explicit eQMainWindow(QWidget* parent, Qt::WindowFlags f);
    ~eQMainWindow();

};
//___________________________________________________
class eQLineEdit : public QLineEdit {
    // Q_OBJECT

public:
    void* aDThis;       // Хранит адрес экземпляра объекта D
    void* aKeyPressEvent;
public:
    explicit eQLineEdit(QWidget* parent);
    ~eQLineEdit();
protected:
    void keyPressEvent(QKeyEvent* event);
};
//___________________________________________________
class eQWidget : public QWidget {
    // Q_OBJECT

public:
    void* aDThis;       // Хранит адрес экземпляра объекта D
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
//___________________________________________________
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
//___________________________________________________
class eQPlainTextEdit : public QPlainTextEdit {
    // Q_OBJECT
public:
    void* aDThis;       // Хранит адрес экземпляра объекта D
    void* aKeyPressEvent;
    void* aKeyReleaseEvent;
public:
    explicit eQPlainTextEdit(QWidget* parent);
    ~eQPlainTextEdit();
protected:
    void keyPressEvent(QKeyEvent* event);
    void keyReleaseEvent(QKeyEvent* event);
};
//___________________________________________________
class Highlighter : public QSyntaxHighlighter
{
    // Q_OBJECT
public:
    Highlighter(QTextDocument *parent = 0);

protected:
    void highlightBlock(const QString &text);

private:
    struct HighlightingRule
    {
        QRegExp pattern;
        QTextCharFormat format;
    };
    QVector<HighlightingRule> highlightingRules;

    QRegExp commentStartExpression;
    QRegExp commentEndExpression;

    QTextCharFormat keywordFormat;
    QTextCharFormat classFormat;
    QTextCharFormat singleLineCommentFormat;
    QTextCharFormat multiLineCommentFormat;
    QTextCharFormat quotationFormat;
    QTextCharFormat functionFormat;
};

#endif // QTE5WIDGETS_H