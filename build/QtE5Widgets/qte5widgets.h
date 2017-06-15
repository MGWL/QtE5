#ifndef QTE5WIDGETS_H
#define QTE5WIDGETS_H

#include "qte5widgets_global.h"

#include <QObject>
#include <QTimer>
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
#include <QTextEdit>

#include <QtScript>

typedef int PTRINT;
typedef unsigned int PTRUINT;

typedef struct QtRef__ { PTRINT dummy; } *QtRefH;

extern "C" typedef void (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__b)(bool);
extern "C" typedef void  (*ExecZIM_v__i)(int);
extern "C" typedef void  (*ExecZIM_v__v)(void);

extern "C" typedef void  (*ExecZIM_v__vp_n_i)(void*, int, int);
extern "C" typedef void  (*ExecZIM_v__vp_n_i_i)(void*, int, int, int);

extern "C" typedef void  (*ExecZIM_v__vp_n_b)(void*, int, bool);
extern "C" typedef void  (*ExecZIM_v__vp_n)(void*, int);


extern "C" typedef void  (*ExecZIM_v__vp)(void*);

extern "C" typedef void  (*ExecZIM_v__vp_vp)(void*, void*);
extern "C" typedef void  (*ExecZIM_v__vp_vp_vp)(void*, void*, void*);

extern "C" typedef bool  (*ExecZIM_b__vp)(void*);
extern "C" typedef void* (*ExecZIM_vp__vp_vp)(void*, void*);
extern "C" typedef void* (*ExecZIM_vp__vp)(void*);

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

    void sendSignal_V();
    void sendSignal_VI(int n);
    void sendSignal_VS(QString* s);

private slots:
    void Slot();
    void SlotN();
    void Slot_Bool(bool);
    void Slot_Int(int);
    void Slot_v__A_N_i(int);
    void Slot_v__A_N_i_i(int, int);
    void Slot_v__A_N_b(bool);
    void Slot_v__A_N_v();
    void Slot_v__A_N_QObject(QObject*);

    void Slot_AN();                     // void call(Aдркласса, Nчисло);
    void Slot_ANI(int);                 // void call(Aдркласса, Nчисло, int);
    void Slot_ANB(bool);                // void call(Aдркласса, Nчисло, bool);
    void Slot_ANII(int, int);           // void call(Aдркласса, Nчисло, int, int);
    void Slot_ANQ(QObject*);            // void call(Aдркласса, Nчисло, QObject*);
    void Slot_ANQ(QMdiSubWindow*);      // void call(Aдркласса, Nчисло, QObject*);

signals:
    void Signal_V();          // Сигнал без параметра
    void Signal_VI(int);      // Сигнал с int
    void Signal_VS(QString);  // Сигнал с QString
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
    void* aMousePressEvent;
    void* aMouseReleaseEvent;

public:
    explicit eQWidget(QWidget* parent, Qt::WindowFlags f);
    ~eQWidget();

protected:
    void keyPressEvent(QKeyEvent* event);
    void paintEvent(QPaintEvent* event);
    void closeEvent(QCloseEvent* event);
    void resizeEvent(QResizeEvent* event);
    void mousePressEvent(QMouseEvent* event);
    void mouseReleaseEvent(QMouseEvent* event);
};
//___________________________________________________
class eQFrame : public QFrame {
    // Q_OBJECT
public:
    void* aKeyPressEvent;
    // void* aPaintEvent;
    void* aCloseEvent;
    void* aResizeEvent;
public:
    explicit eQFrame(QWidget* parent, Qt::WindowFlags f);
    ~eQFrame();
protected:
    void keyPressEvent(QKeyEvent* event);
    // void paintEvent(QPaintEvent* event);
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
    void* aPaintEvent;
public:
    explicit eQPlainTextEdit(QWidget* parent);
public:
    void gsetViewportMargins(int left, int top, int right, int bottom);
    void gfirstVisibleBlock(QTextBlock* tb);
    int  getXYWH(QTextBlock* tb, int pr);
    ~eQPlainTextEdit();
protected:
    void keyPressEvent(QKeyEvent* event);
    void keyReleaseEvent(QKeyEvent* event);
    void paintEvent(QPaintEvent* event);
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
//___________________________________________________
class eQTextEdit : public QTextEdit {
    // Q_OBJECT
public:
    void* aDThis;       // Хранит адрес экземпляра объекта D
    void* aKeyPressEvent;
    void* aKeyReleaseEvent;
public:
    explicit eQTextEdit(QWidget* parent);
    ~eQTextEdit();
protected:
    void keyPressEvent(QKeyEvent* event);
    void keyReleaseEvent(QKeyEvent* event);
};

#endif // QTE5WIDGETS_H
