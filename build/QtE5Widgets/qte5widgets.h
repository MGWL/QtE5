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
#include <QBitmap>
#include <QResource>
#include <QStackedWidget>
#include <QTextCodec>
#include <QTextStream>
#include <QCalendarWidget>
#include <QTranslator>
// #include <QtCore/qpointer.h>

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
class eAction : public QAction {
    Q_OBJECT

public:
    explicit eAction(QObject *parent);
    ~eAction();

    void* aSlotN;       // Хранит адрес D функции для вызова с параметром
    void* aDThis;       // Хранит адрес экземпляра объекта D
    int        N;       // параметр для aSlotN. Идея запомнить параметр при установке слота и выдать
                        // при срабатывании слота. А ля - диспечерезация
    int m_qint;
    QString m_qstr;

    void sendSignal_V();
    void sendSignal_VI(int n);
    void sendSignal_VS(QString* s);

    Q_INVOKABLE void Qml_Slot_AN() {   Slot_AN();    }
    Q_INVOKABLE void Qml_Slot_ANQ(QObject* ob) {   Slot_ANQ(ob);    }
    Q_INVOKABLE void Qml_Slot_ANI(int ob)      {   Slot_ANI(ob);    }

     Q_PROPERTY(QString qstr READ qstr WRITE setQstr NOTIFY qstrChange)
     Q_PROPERTY(int qint READ qint WRITE setQint NOTIFY qintChange)

    // Q_PROPERTY( int someProperty READ getSomeProperty WRITE setSomeProperty NOTIFY somePropertyChanged)

    QString qstr() const     { return m_qstr;    }
    int qint() const    {   return m_qint;    }

public slots:
    void setQint(int qint)   {
        m_qint = qint;  emit
        qintChange(m_qint);
        //if (aSlotN != NULL)  ((ExecZIM_v__vp_n)aSlotN)(*(void**)aDThis, N);
    }

    void setQstr(QString qstr)    {
        if (m_qstr == qstr)     return;
        m_qstr = qstr;
        emit qstrChange(m_qstr);
        //if (aSlotN != NULL)  ((ExecZIM_v__vp_n)aSlotN)(*(void**)aDThis, N);
    }

private slots:
    void Slot();
    void SlotN();
    void Slot_Bool(bool);
    void Slot_Int(int);
    void Slot_v__A_N_i(int);
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
    void qintChange(int qint);
    void qstrChange(QString qstr);
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

// Пока с событиямия не разобрался. Иногда событие происходит, когда его быть не должно.
// Возможно, это "цепочка событий". aBEG и aEND - это якоря, изменение которых, говорит
// что событие не моё и мне его надо пропустить.

public:
    size_t aBEG_KeyPressEvent;
    size_t aBEG_PaintEvent;
    size_t aBEG_CloseEvent;
    size_t aBEG_ResizeEvent;
    size_t aBEG_MousePressEvent;
    size_t aBEG_MouseReleaseEvent;
    size_t aBEG_MouseWheelEvent;
    //
    void* aDThis;       // Хранит адрес экземпляра объекта D
    void* aKeyPressEvent;
    void* aPaintEvent;
    void* aCloseEvent;
    void* aResizeEvent;
    void* aMousePressEvent;
    void* aMouseReleaseEvent;
    void* aMouseWheelEvent;
    //
    size_t aEND_MouseWheelEvent;
    size_t aEND_MouseReleaseEvent;
    size_t aEND_MousePressEvent;
    size_t aEND_ResizeEvent;
    size_t aEND_CloseEvent;
    size_t aEND_PaintEvent;
    size_t aEND_KeyPressEvent;

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
    void wheelEvent(QWheelEvent* event);
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
    QTextCharFormat singleLineCommentFormat2;
    QTextCharFormat multiLineCommentFormat;
    QTextCharFormat quotationFormat;
    QTextCharFormat functionFormat;
};
//___________________________________________________
class HighlighterM : public QSyntaxHighlighter
{
    // Q_OBJECT
public:
    HighlighterM(QTextDocument *parent = 0);

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
    QTextCharFormat singleLineCommentFormat2;
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
