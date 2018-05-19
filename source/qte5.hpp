//
//  qte5.hpp
//  test_cpp
//
//  Created by gena on 23.02.18.
//  Copyright © 2018 gena. All rights reserved.
//
#include <stdlib.h>

#ifndef qte5_hpp
    #define qte5_hpp

namespace QtE5_Const {
    
    enum WindowType {
        Widget = 0x00000000,
        Window = 0x00000001,
        Dialog = 0x00000002 | Window,
        Sheet = 0x00000004 | Window,
        Drawer = Sheet | Dialog,
        Popup = 0x00000008 | Window,
        Tool = Popup | Dialog,
        ToolTip = Popup | Sheet,
        SplashScreen = ToolTip | Dialog,
        Desktop = 0x00000010 | Window,
        SubWindow = 0x00000012,
        ForeignWindow = 0x00000020 | Window,
        CoverWindow = 0x00000040 | Window,
        CustomizeWindowHint = 0x02000000, // Turns off the default window title hints.
        WindowTitleHint = 0x00001000, // Gives the window a title bar.
        WindowSystemMenuHint = 0x00002000, // Adds a window system menu, and possibly a close button (for example on Mac). If you need to hide or show a close button, it is more portable to use WindowCloseButtonHint.
        WindowMinimizeButtonHint = 0x00004000, // Adds a minimize button. On some platforms this implies Qt::WindowSystemMenuHint for it to work.
        WindowMaximizeButtonHint = 0x00008000, // Adds a maximize button. On some platforms this implies Qt::WindowSystemMenuHint for it to work.
        WindowMinMaxButtonsHint = WindowMinimizeButtonHint | WindowMaximizeButtonHint, // Adds a minimize and a maximize button. On some platforms this implies Qt::WindowSystemMenuHint for it to work.
        WindowCloseButtonHint = 0x08000000, // Adds a close button. On some platforms this implies Qt::WindowSystemMenuHint for it to work.
        WindowContextHelpButtonHint = 0x00010000, // Adds a context help button to dialogs. On some platforms this implies Qt::WindowSystemMenuHint for it to work.
        MacWindowToolBarButtonHint = 0x10000000, // On OS X adds a tool bar button (i.e., the oblong button that is on the top right of windows that have toolbars).
        WindowFullscreenButtonHint = 0x80000000, // On OS X adds a fullscreen button.
        BypassGraphicsProxyWidget = 0x20000000, // Prevents the window and its children from automatically embedding themselves into a QGraphicsProxyWidget if the parent widget is already embedded. You can set this flag if you want your widget to always be a toplevel widget on the desktop, regardless of whether the parent widget is embedded in a scene or not.
        WindowShadeButtonHint = 0x00020000, // Adds a shade button in place of the minimize button if the underlying window manager supports it.
        WindowStaysOnTopHint = 0x00040000, // Informs the window system that the window should stay on top of all other windows. Note that on some window managers on X11 you also have to pass Qt::X11BypassWindowManagerHint for this flag to work correctly.
        WindowStaysOnBottomHint = 0x04000000 // Informs the window system that the window should stay on bottom of all other windows. Note that on X11 this hint will work only in window managers that support _NET_WM_STATE_BELOW atom. If a window always on the bottom has a parent, the parent will also be left on the bottom. This window hint is currently not impl
        // .... Qt5/QtCore/qnamespace.h
    };
    enum AlignmentFlag { //->
        AlignNone = 0,
        AlignLeft = 0x0001,
        AlignLeading = AlignLeft,
        AlignRight = 0x0002,
        AlignTrailing = AlignRight,
        AlignHCenter = 0x0004,
        AlignJustify = 0x0008,
        AlignAbsolute = 0x0010,
        AlignHorizontal_Mask = AlignLeft | AlignRight | AlignHCenter | AlignJustify | AlignAbsolute,
        
        AlignTop = 0x0020,
        AlignBottom = 0x0040,
        AlignVCenter = 0x0080,
        AlignVertical_Mask = AlignTop | AlignBottom | AlignVCenter,
        AlignCenter = AlignVCenter | AlignHCenter,
        AlignAuto = AlignLeft,
        AlignExpanding = AlignLeft & AlignTop
    };
} /* end namespace QtE5_Const */

//___________________________________________________________________
namespace QtE5 {
    
static void* pFunQt[1000]; 				/// Масив указателей на функции из DLL

enum dll {  // Загрузка DLL. Необходимо выбрать какие грузить. Load DLL, we mast change load
	QtE5Widgets = 1,
	QtE5Script  = 2,
	QtE5Web		= 4,
	QtE5WebEng	= 8
};

// void test();
int LoadQt(dll ldll, bool showError);  //  Загрузить DLL-ки Qt и QtE
// void run(int argc, char** argv);

class QByteArray;
//___________________________________________________________________
class QObject {
private:
	void* p_QObject; // Адрес самого объекта из C++ Qt
	unsigned int dlock;
	void* adrThis;    /// Адрес собственного экземпляра
public:
	QObject(char);
	QObject();
	~QObject();
	void dlockSet(int);
unsigned int dlockGet();
	void dlockAdd(int);
	void setQtObj(void*); //-> Заменить указатель в объекте на новый указатель
	void* QtObj(); //-> // Выдать указатель на реальный объект Qt C++
	void connect(void*, char*, void*, char*, int);
	void saveThis(void*);  //-> Запомнить указатель на собственный экземпляр
	void* aThis();  //-> Выдать указатель на p_QObject
};
//___________________________________________________________________
class QString : public QObject {
public:
	QString(char const*);
	QString(QByteArray*);
	~QString();
};
//___________________________________________________________________
class QApplication : public QObject {
public:
	QApplication(char);
	QApplication(int, const char**, int);
	~QApplication();
	void aboutQt();  		//-> Об Qt
	int exec(); 			//-> Выполнить
};
//___________________________________________________________________
class QWidget : public QObject {
public:
	QWidget(char ch);
	QWidget(QWidget* parent = NULL, QtE5_Const::WindowType fl = QtE5_Const::Widget);
	~QWidget();
	void setStyleSheet(QString* qstr); 
	void setWindowTitle(QString* qstr);   //-> // Установить заголовок окна
	void setStyleSheet(QString qstr); 
	void setWindowTitle(QString qstr);   //-> // Установить заголовок окна
	void show();
	void resize(int w, int h);
	void move(int x, int y);
};
//___________________________________________________________________
class QFrame : public QWidget {
public:
	enum Shape { //->
		NoFrame = 0, // no frame
		Box = 0x0001, // rectangular box
		Panel = 0x0002, // rectangular panel
		WinPanel = 0x0003, // rectangular panel (Windows)
		HLine = 0x0004, // horizontal line
		VLine = 0x0005, // vertical line
		StyledPanel = 0x0006 // rectangular panel depending on the GUI style
	};
	enum Shadow { //->
		Plain = 0x0010, // plain line
		Raised = 0x0020, // raised shadow effect
		Sunken = 0x0030 // sunken shadow effect
	};
	QFrame(char ch);
	QFrame(QWidget* parent = NULL, QtE5_Const::WindowType fl = QtE5_Const::Widget);
	~QFrame();
	void setFrameShape(Shape sh);
	void setFrameShadow(Shadow sh);
	void setLineWidth(int sh);
};
//___________________________________________________________________
class QLineEdit : public QWidget {
public:
enum EchoMode {
		Normal = 0, 				// Показывать символы при вводе. По умолчанию
		NoEcho = 1, 				// Ни чего не показывать, что бы длинна пароля была не понятной
		Password = 2, 				// Звездочки вместо символов
		PasswordEchoOnEdit = 3 		// Показывает только один символ, а остальные скрыты
	};
	QLineEdit(char ch);
	QLineEdit(QWidget*);
	~QLineEdit();
	void setText(QString*);
	void insert(QString*);
	void setInputMask(QString*);
	void clear();
	QString* text(QString*);      		// Забрать текст из LineEdit
};
//___________________________________________________________________
class QLabel : public QFrame {
public:
	QLabel(char ch);
	QLabel(QWidget* parent = NULL, QtE5_Const::WindowType fl = QtE5_Const::Widget);
	~QLabel();
	QLabel setText(QString qstr);
	
};
//___________________________________________________________________
class QAction : public QObject {
public:
	QAction(char ch);
	QAction(QWidget* parent, void* adr, void* adrThis, int n = 0);
	~QAction();
};
//___________________________________________________________________
class QBoxLayout : public QObject {
public:
	enum Direction { //-> enum Direction { LeftToRight, RightToLeft, TopToBottom, BottomToTop }
		LeftToRight = 0,
		RightToLeft = 1,
		TopToBottom = 2,
		BottomToTop = 3
	};
	QBoxLayout(char ch);
	QBoxLayout(QWidget*, Direction dir = TopToBottom);
	~QBoxLayout();
	void addWidget(QWidget* wd, int stretch = 0, QtE5_Const::AlignmentFlag alignment = QtE5_Const::AlignExpanding);
	
};
//___________________________________________________________________
class QAbstractButton : public QWidget {
public:
	QAbstractButton(char ch);
	QAbstractButton(QWidget* parent);
	~QAbstractButton();
	void setText(QString* str);
};
//___________________________________________________________________
class QPushButton : public QAbstractButton {
public:
	QPushButton(QString str, QWidget* parent = NULL);
	~QPushButton();
};
//___________________________________________________________________
class QTextCodec : public QObject {
public:
	QTextCodec(char* strNameCodec);
	QString toUnicode(char* str, QString qstr);
	char* fromUnicode(char* str, QString qstr);
};
//___________________________________________________________________
class QByteArray : public QObject {
public:
	QByteArray(char* str);
	QByteArray(QByteArray*);
	~QByteArray();
	int size();
	int length();
	char* data();
	const char* constData();
	char getChar(int n);
	void trimmed();	   					// Выкинуть пробелы с обоих концов строки (AllTrim())
	void clear();
	void simplified(); 					// выкинуть лишние пробелы внутри строки
	void prepend(char* str); 				// Приклеить строку спереди
	void append(char* str); 				// Добавить строку сзади
	void prepend(QByteArray* ba); 			// Приклеить строку спереди
	void append(QByteArray* ba); 			// Добавить строку сзади
	bool startsWith(QByteArray* ba); 		// Совпадение с началом
	bool endsWith(QByteArray* ba); 		// Совпадение с концом
};
//___________________________________________________________________
class QIODevice : public QObject {
public:
	enum OpenMode {
		NotOpen    = 0x0000,  // The device is not open.
		ReadOnly   = 0x0001,  // The device is open for reading.
		WriteOnly  = 0x0002,  // The device is open for writing.
		ReadWrite  = ReadOnly | WriteOnly,  //  The device is open for reading and writing.
		Append     = 0x0004,  // The device is opened in append mode, so that all data is written to the end of the file.
		Truncate   = 0x0008,  // If possible, the device is truncated before it is opened. All earlier contents of the device are lost.
		Text       = 0x0010,  // When reading, the end-of-line terminators are translated to '\n'. When writing, the end-of-line terminators are translated to the local encoding, for example '\r\n' for Win32.
		Unbuffered = 0x0020   // Any buffer in the device is bypassed.
	};

	QIODevice(char);
	~QIODevice();
	void readAll(QByteArray*);
};
//___________________________________________________________________
class QFileDevice : public QIODevice {
public:
	QFileDevice(char);
	~QFileDevice();
	void close();
};
//___________________________________________________________________
class QFile : public QFileDevice {
public:
	QFile(QObject*);
	QFile(QString*, QObject*);
	QFile(QString, QObject*);
	bool open(QIODevice::OpenMode);
	~QFile();
};
//___________________________________________________________________
class QTextStream : public QObject {
public:
	QTextStream(char);
	QTextStream(QIODevice*);
	~QTextStream();
	void codecName(char*);
	void LL(char*);
	void LL(QByteArray*);
	void LL(QString*);
	void readLine(QByteArray*, int);
	bool atEnd();
};
  

} /* end namespace QtE5 */
#endif /* qte5_h */
