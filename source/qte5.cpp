//
//  qte5.cpp
//  test_cpp
//
//  Created by gena on 23.02.18.
//  Copyright © 2018 gena. All rights reserved.
//
// Компиляция:
// Windows 32 dmc:  dmc main.cpp qte5.cpp
//         OSX 64:  g++ main.cpp qte5.cpp
//       Linux 64:  g++ main.cpp qte5.cpp -ldl

#include <stdio.h>
#include <string.h>

#ifdef _MSC_VER
	#include <windows.h>
#endif // _MSC_VER
#ifdef __DMC__
	#include <windows.h>
#endif // __DMC__ 
#ifdef __GNUG__
	#include <dlfcn.h>
#endif // __GNUG__ 

#include "qte5.hpp"

// Определяю собственное пространство имен для QtE5
namespace QtE5 {
    unsigned int maxValueInPFunQt;
    
    typedef void* (*t_vp__vp_vp_i)(void*, void*, int);
    typedef void* (*t_vp__vp)(void*);
    typedef void* (*t_vp__vp_vp)(void*, void*);
    typedef void* (*t_vp__vp_vp_i_i)(void*, void*, int, int);
    typedef void* (*t_vp__vp_i)(void*, int);
    typedef void  (*t_v__vp_vp_vp_i)(void*, void*, void*, int);
    typedef void  (*t_v__vp)(void*);
    typedef void  (*t_v__vp_vp)(void*, void*);
    typedef void  (*t_v__vp_vp_vp)(void*, void*, void*);
    typedef void  (*t_v__vp_i)(void*, int);
    typedef int   (*t_i__vp)(void*);
    typedef void* (*t_v__vp_i_i_i)(void*, int, int, int);
    typedef void  (*t_v__vp_vc_vp_vc_i)(void*, char*, void*, char*, int);
    typedef void  (*t_v__vp_vp_i_i)(void*, void*, int, int);
    
    //___________________________________________________________________
    void dumpString(char* str) {
        for(int i=0; i != 10; i++) printf(" %d ", (unsigned char)*(str+i));
        printf("\n");
    }
    //___________________________________________________________________
#ifdef __GNUG__
    void* GetProcAddress(void* hLib, const char* nameFun) {  return dlsym(hLib, nameFun);    }
#endif // __GNUG__ 
    //___________________________________________________________________
    // Сообщить об ошибке загрузки. Message on error.
    // Message on error. s - text error, sw=1 - error load dll and sw=2 - error find function
    void MessageErrorLoad(bool showError, char const* s, char const* nameDll = "" ) {
        if (showError) {
            if (!strlen(nameDll)) printf("Error load: %s\n", s);
            else printf("Error find function: %s ---> %s\n", nameDll, s);
        } else {
            if (!strlen(nameDll)) printf("Load: %s\n", s);
            else printf("Find function: %s ---> %s\n", nameDll, s);
        }
    }
    //___________________________________________________________________
    // Найти адреса функций в DLL. To find addresses of executed out functions in DLL
    void* GetPrAddress(bool isLoad, void* hLib, char const* nameFun) {
        if(!hLib) return NULL;
        // // Искать или не искать функцию. Find or not find function in library
#ifdef _MSC_VER
        if (isLoad) return GetProcAddress((HMODULE)hLib, nameFun);
#else		
        if (isLoad) return GetProcAddress(hLib, nameFun);
#endif // _MSC_VER
        return (void*) 1;
    }
    //___________________________________________________________________
    // Загрузить DLL. Load DLL (.so)
    void* GetHlib(char const* name) {
#ifdef _MSC_VER
        return LoadLibrary(name);
#endif // _MSC_VER
#ifdef __DMC__
        return LoadLibrary(name);
#endif // __DMC__ 
#ifdef __GNUG__
        return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);
#endif // __GNUG__
		return NULL;
    }
    //___________________________________________________________________
    // Найти и сохранить адрес функции DLL
    void funQt(int n, bool b, void* h, char const* s, char const* name, bool she) {
        if(!h) return;
        pFunQt[n] = GetPrAddress(b, h, name); if (!pFunQt[n]) MessageErrorLoad(she, name, s);
        maxValueInPFunQt = n;
    }
	//___________________________________________________________________
	int LoadQt(dll ldll, bool showError) { //  Загрузить DLL-ки Qt и QtE
		bool	bCore5, bGui5, bWidget5, bQtE5Widgets, bQtE5Script, bQtE5Web, bQtE5WebEng;
		char const* sCore5;char const* sGui5;char const* sWidget5;char const* sQtE5Widgets;
		char const* sQtE5Script;char const* sQtE5Web;char const* sQtE5WebEng;
		void*	hCore5; void* hGui5; void* hWidget5; void* hQtE5Widgets; void* hQtE5Script; void* hQtE5Web; void* hQtE5WebEng;
#if defined (__DMC__) || defined (_MSC_VER) 
		sCore5			= "Qt5Core.dll";
		sGui5			= "Qt5Gui.dll";
		sWidget5		= "Qt5Widgets.dll";
		sQtE5Widgets	= "QtE5Widgets32.dll";
		sQtE5Script		= "QtE5Script32.dll";
		sQtE5Web		= "QtE5Web32.dll";
		sQtE5WebEng		= "QtE5WebEng32.dll";
#endif /* __DMC__ */
#ifdef __GNUG__
	#ifdef __x86_64__
		#ifdef __MACH__
			sCore5			= "libQt5Core.dylib";
			sGui5			= "libQt5Gui.dylib";
			sWidget5		= "libQt5Widgets.dylib";
			sQtE5Widgets	= "libQtE5Widgets64.dylib";
			sQtE5Script		= "libQtE5Script64.dylib";
			sQtE5Web		= "libQtE5Web64.dylib";
			sQtE5WebEng		= "libQtE5WebEng64.dylib";
		#endif
		#ifdef __linux__
			sCore5			= "libQt5Core.so";
			sGui5			= "libQt5Gui.so";
			sWidget5		= "libQt5Widgets.so";
			sQtE5Widgets	= "libQtE5Widgets64.so";
			sQtE5Script		= "libQtE5Script64.so";
			sQtE5Web		= "libQtE5Web64.so";
			sQtE5WebEng		= "libQtE5WebEng64.so";
		#endif // __linux__
	#else
		#ifdef __MACH__
			sCore5			= "libQt5Core.dylib";
			sGui5			= "libQt5Gui.dylib";
			sWidget5		= "libQt5Widgets.dylib";
			sQtE5Widgets	= "libQtE5Widgets64.dylib";
			sQtE5Script		= "libQtE5Script64.dylib";
			sQtE5Web		= "libQtE5Web64.dylib";
			sQtE5WebEng		= "libQtE5WebEng64.dylib";
		#endif
		#ifdef __linux__
			sCore5			= "libQt5Core.so";
			sGui5			= "libQt5Gui.so";
			sWidget5		= "libQt5Widgets.so";
			sQtE5Widgets	= "libQtE5Widgets32.so";
			sQtE5Script		= "libQtE5Script32.so";
			sQtE5Web		= "libQtE5Web32.so";
			sQtE5WebEng		= "libQtE5WebEng32.so";
		#endif // __linux__


	#endif /* __x86_64__ */
		
#endif /* __GNUG__ */
		// Если на входе указана dll.QtE5Widgets то автоматом надо грузить и bCore5, bGui5, bWidget5
		// If on an input it is specified dll.QtE5Widgets then automatic loaded bCore5, bGui5, bWidget5
		bQtE5Widgets= (ldll & QtE5Widgets);
		if(bQtE5Widgets) { bCore5 = true; bGui5 = true; bWidget5 = true; }
		bQtE5Script = (ldll & QtE5Script);
		bQtE5Web 	= (ldll & QtE5Web);
		bQtE5Web 	= (ldll & QtE5Web);
		bQtE5WebEng	= (ldll & QtE5WebEng);

		// Load library in memory
		if (bCore5) {
			// hCore5 = GetHlib(sCore5); if (!hCore5) { MessageErrorLoad(showError, sCore5); return 1; }
		}
		if (bGui5) {
			// hGui5 = GetHlib(sGui5);	if (!hGui5) { MessageErrorLoad(showError, sGui5); return 1; }
		}
		if (bWidget5) {
			// hWidget5 = GetHlib(sWidget5); if (!hWidget5) { MessageErrorLoad(showError, sWidget5); return 1; }
		}
		if (bQtE5Widgets) {
			hQtE5Widgets = GetHlib(sQtE5Widgets); if (!hQtE5Widgets) { MessageErrorLoad(showError, sQtE5Widgets); return 1; }
		}
		if (bQtE5Script) {
			hQtE5Script = GetHlib(sQtE5Script); if (!hQtE5Script) { MessageErrorLoad(showError, sQtE5Script); return 1; }
		}
		if (bQtE5Web) {
			hQtE5Web = GetHlib(sQtE5Web); if (!hQtE5Web) { MessageErrorLoad(showError, sQtE5Web); return 1; }
		}
		if (bQtE5WebEng) {
			hQtE5WebEng = GetHlib(sQtE5WebEng); if (!hQtE5WebEng) { MessageErrorLoad(showError, sQtE5WebEng); return 1; }
		}

		funQt(0, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_create1",     showError);
		funQt(1, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_exec",        showError);
		funQt(2, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_aboutQt",     showError);
		funQt(3, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_delete1",     showError);
		funQt(27,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteConnect",                  showError);

		// ------- QWidget -------
		funQt(5, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_create1",          showError);
		funQt(6, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setVisible",       showError);
		funQt(7, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_delete1",          showError);
		funQt(11,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setWindowTitle",   showError);
		funQt(30,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setStyleSheet",    showError);
		funQt(87,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_exWin1",           showError);
		funQt(94,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_exWin2",           showError);
		// ------- QString -------
		funQt(10,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_delete",           showError);
		funQt(9, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_create2",          showError);
		// ------- QLabel -------
		funQt(46,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_create1",           showError);
		funQt(47,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_delete1",           showError);
		funQt(48,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_setText",           showError);
		// ------- QFrame -------
		funQt(41,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_create1",           showError);
		funQt(42,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_delete1",           showError);
		funQt(43,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setFrameShape",     showError);
		funQt(44,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setFrameShadow",    showError);
		funQt(45,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setLineWidth",      showError);
		//  ------- QAction -------
		funQt(95,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_create",           showError);
		funQt(96,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_delete",           showError);
		funQt(98,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_setSlotN2",        showError);
		// ------- QPushButton -------
		funQt(22,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPushButton_create1",      showError);
		funQt(23,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPushButton_delete",       showError);
		// ------- QLayout -------
		funQt(34,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout",      		  showError);
		funQt(37,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_delete",        showError);
		funQt(38,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_addWidget",     showError);
		// ------- QAbstractButton -------
		funQt(28,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_setText",  showError);
	// ------- QTextCodec ----------
		funQt(448,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"p_QTextCodec",  			  showError);
		funQt(449,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"QT_QTextCodec_toUnicode",  	  showError);
		funQt(450,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"QT_QTextCodec_fromUnicode",   showError);

		return 0;
	}
//___________________________________________________________________
QObject::QObject(char ch) {
	// printf("+++ QObject ZERRO [ %c ]\n", ch);
};
QObject::QObject() {
	// Для подсчета ссылок создания и удаления
	// balCreate++; allCreate++; id = allCreate;
	dlock = 1;
	//// printf("+++ QObject [%d]\n", dlock);
};
QObject::~QObject() {
	// dlock--;
	//// printf("--- QObject [%d]\n", dlock);
};
void QObject::dlockSet(int sm) {
	dlock += sm;
};
unsigned int QObject::dlockGet() {
	return dlock;
};
void QObject::setQtObj(void* adr) { //-> Заменить указатель в объекте на новый указатель
	p_QObject = adr; 
};
void* QObject::QtObj() { //-> // Выдать указатель на реальный объект Qt C++
	return p_QObject;
};
// Моделирует макросы QT. Model macros Qt. For n=2->SIGNAL(), n=1->SLOT(), n=0->METHOD().
const int QMETHOD = 0; // member type codes
const int QSLOT = 1;
const int QSIGNAL = 2;
char* MSS(char* s, int n) {
	if (n == QMETHOD)	{ *s = '0';	return s; }
	if (n == QSLOT) 	{ *s = '1';	return s; }
	if (n == QSIGNAL)	{ *s = '2';	return s; }
	return NULL;
};
void QObject::connect(void* obj1, char* ssignal, void* obj2, char* sslot, int type) {
	size_t szStrSg = strlen(ssignal) + 2;
	size_t szStrSl = strlen(sslot)   + 2;
	char* uBufSg   = (char*)malloc( szStrSg );
	char* uBufSl   = (char*)malloc( szStrSl );
	memcpy(uBufSg, ssignal, szStrSg - 1); 
	memcpy(uBufSl, sslot,   szStrSl - 1); 
	((t_v__vp_vc_vp_vc_i)pFunQt[27])(obj1, MSS(uBufSg, QSIGNAL), obj2, MSS(uBufSl, QSLOT), type);
	// printf("+++ connect Run %p  %s,  %p,  %s, %d\n", obj1, uBufSg, obj2, uBufSl, type);
	free(uBufSg);
	free(uBufSl);
};
	/// Запомнить указатель на собственный экземпляр
void QObject::saveThis(void* adr) { //-> Запомнить указатель на собственный экземпляр
	adrThis = adr;
};
void* QObject::aThis() { //-> Выдать указатель на p_QObject
	return &adrThis;
};
//____________________________________________________________________
QString::QString(char const* str) :  QObject('S')  {
	char buf[100];
	setQtObj(((t_vp__vp_i)pFunQt[9])(buf, 80));
	QTextCodec cUtf8((char*)"UTF-8");
	((t_v__vp_vp_vp)pFunQt[449])(cUtf8.QtObj(), QtObj(), (char*)str);

	/*
	int sizeBuf = 2 * strlen(str);
	char* buf = (char*)malloc( sizeBuf ); 
	MultiByteToWideChar(CP_UTF8, (DWORD)0,  str, -1, (wchar_t*)buf,  sizeBuf-1  );
	setQtObj(((t_vp__vp_i)pFunQt[9])(buf, wcslen( (wchar_t*)buf )));
	free(buf);
	*/
};
QString::~QString() {
	// printf("--- QString = [%d]  %p\n", dlockGet(), QtObj());
	dlockSet(-1);
	if(!dlockGet()) {
		// // printf("--- QString!!!! delete = [%d]  %p\n", dlockGet(), QtObj());
		((t_v__vp)pFunQt[10])(QtObj()); setQtObj(NULL);
	}
};
//___________________________________________________________________
QApplication::QApplication(char ch) : QObject('A') {
	// printf("+++ QApplication ZERRO \n");
};
QApplication::QApplication(int argc, const char** argv, int gui) : QObject('a') {
	// printf("+++ QApplication %p\n", QtObj());
	setQtObj(((t_vp__vp_vp_i)pFunQt[0])((void*)&argc, (void*)argv, gui));
};
void QApplication::aboutQt() { //-> Об Qt
	((t_v__vp)pFunQt[2])(QtObj());
};
QApplication::~QApplication() {
	// printf("--- QApplication %p\n", QtObj());
	((t_v__vp)pFunQt[3])(QtObj());
};
int QApplication::exec() { //-> Выполнить
	return ((t_i__vp)pFunQt[1])(QtObj());
};
//___________________________________________________________________
// Это хитрый конструктор. Его задача не дать возможности изготовить Qt объект,
// при условии, что вызван наследником. Наследник уже изготовил Qt объект, и нам нет
// надобности что либо делать ...
QWidget::QWidget(char ch) {
	// printf("+++ QWidget ZERRO \n");
};
QWidget::QWidget(QWidget* parent, QtE5_Const::WindowType fl) : QObject('W') {
	// printf("++1+ QWidget  %p\n", QtObj());
	if (parent) {
		setQtObj(((t_vp__vp_i)pFunQt[5])(parent->QtObj(), (int)fl));
	} else {
		setQtObj(((t_vp__vp_i)pFunQt[5])(NULL, (int)fl));
	}
	// printf("++2+ QWidget  %p\n", QtObj());
};
QWidget::~QWidget() {
	// printf("--1- QWidget %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[7])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QWidget %p\n", QtObj());
};
void QWidget::setStyleSheet(QString qstr) {  //-> Изменить оформление виджета
	((t_v__vp_vp)pFunQt[30])(QtObj(), qstr.QtObj()); qstr.dlockSet(1);
	qstr.QtObj();
};
void QWidget::setWindowTitle(QString qstr) {  //-> Установить заголовок окна
	((t_v__vp_vp)pFunQt[11])(QtObj(), qstr.QtObj()); qstr.dlockSet(1);
};
void QWidget::show() {
	((t_v__vp_i)pFunQt[87])(QtObj(), 3);
};
void QWidget::resize(int w, int h) {
	((t_v__vp_i_i_i)pFunQt[94])(QtObj(), 1, w, h);
};
void QWidget::move(int x, int y) {
	((t_v__vp_i_i_i)pFunQt[94])(QtObj(), 0, x, y);
};
//____________________________________________________________________
QFrame::QFrame(char ch) {
	// printf("+++ QFrame ZERRO \n");
};
QFrame::QFrame(QWidget* parent, QtE5_Const::WindowType fl) : QWidget('F')  {
	// printf("++1+ QFrame  %p\n", parent);
	if (parent) {
		setQtObj(((t_vp__vp_i)pFunQt[41])(parent->QtObj(), (int)fl));
	} else {
		setQtObj(((t_vp__vp_i)pFunQt[41])(NULL, (int)fl));
	}
	// printf("++2+ QFrame  %p\n", QtObj());
};
QFrame::~QFrame() {
	// printf("--1- QFrame %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[42])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QFrame %p\n", QtObj());
};
void QFrame::setFrameShape(Shape sh) 	{	((t_v__vp_i)pFunQt[43])(QtObj(), sh); }
void QFrame::setFrameShadow(Shadow sh) 	{	((t_v__vp_i)pFunQt[44])(QtObj(), sh); }
void QFrame::setLineWidth(int sh) 	{ if (sh > 3) sh = 3; ((t_v__vp_i)pFunQt[45])(QtObj(), sh); }
//____________________________________________________________________
QLabel::QLabel(char ch) {
	// printf("+++ QLabel ZERRO \n");
};
QLabel::QLabel(QWidget* parent, QtE5_Const::WindowType fl) : QFrame('L')  {
	// printf("++1+ QLabel  %p\n", parent);
	if (parent) {
		setQtObj(((t_vp__vp_i)pFunQt[46])(parent->QtObj(), (int)fl));
	} else {
		setQtObj(((t_vp__vp_i)pFunQt[46])(NULL, (int)fl));
	}
	// printf("++2+ QLabel  %p\n", QtObj());
};
QLabel::~QLabel() {
	// printf("--1- QLabel %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[47])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QLabel %p\n", QtObj());
};
QLabel QLabel::setText(QString qstr) { //->
	((t_v__vp_vp)pFunQt[48])(QtObj(), qstr.QtObj()); qstr.dlockSet(1);
	return this;
}; /// Установить текст на кнопке
//____________________________________________________________________
QAction::QAction(char ch) {
	// printf("+++ QAction ZERRO \n");
};
QAction::QAction(QWidget* parent, void* adr, void* adrThis, int n) : QObject('A') {
	// printf("++1+ QAction %p \n", QtObj());
	if (parent) {
		// setNoDelete(true);
		setQtObj(((t_vp__vp)pFunQt[95])(parent->QtObj()));
	} else {
		setQtObj(((t_vp__vp)pFunQt[95])(NULL));
	}
	((t_v__vp_vp_vp_i)pFunQt[98])(QtObj(), adr, adrThis, n);
	// printf("++2+ QAction %p\n", QtObj());
}
QAction::~QAction() {
	// printf("--1- QAction %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[96])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QAction %p\n", QtObj());
};
//____________________________________________________________________
QAbstractButton::QAbstractButton(char ch) {
	// printf("+++ QBoxLayout ZERRO \n");
};
QAbstractButton::QAbstractButton(QWidget* parent) {
};
QAbstractButton::~QAbstractButton() {
};
void QAbstractButton::setText(QString* str) { //-> // Установить текст на кнопке
	((t_v__vp_vp)pFunQt[28])(QtObj(), str->QtObj());
};
//____________________________________________________________________
QPushButton::QPushButton(QString str, QWidget* parent) : QAbstractButton('Z') {
	if (parent) {
		setQtObj(((t_vp__vp_vp)pFunQt[22])(parent->QtObj(), str.QtObj()));
	// printf("++1+ QPushButton %p\n", QtObj());
	} else {
		setQtObj(((t_vp__vp_vp)pFunQt[22])(NULL, str.QtObj()));
	// printf("++2+ QPushButton %p\n", QtObj());
	}
};
QPushButton::~QPushButton() {
	// printf("--1- QPushButton %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[23])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QPushButton %p\n", QtObj());
};
//____________________________________________________________________
QBoxLayout::QBoxLayout(char ch) {
	// printf("+++ QBoxLayout ZERRO \n");
};
QBoxLayout::QBoxLayout(QWidget* parent, QBoxLayout::Direction dir) : QObject('X') {
	if (parent) {
	// printf("++1+ QBoxLayout %p\n", QtObj());
		setQtObj(((t_vp__vp_i)pFunQt[34])(parent->QtObj(), dir));
	// printf("++2+ QBoxLayout dir = %p\n", QtObj());
	} else {
	// printf("++11+ QBoxLayout %p\n", QtObj());
		setQtObj(((t_vp__vp_i)pFunQt[34])(NULL, dir));
	// printf("++12+ QBoxLayout %p\n", QtObj());
	}
};
QBoxLayout::~QBoxLayout() {
	// printf("--1- QBoxLayout %p\n", QtObj());
	if(QtObj()) { ((t_v__vp)pFunQt[37])(QtObj()); setQtObj(NULL);  }
	// printf("--2- QBoxLayout %p\n", QtObj());
};
// Добавить виджет в выравниватель
void QBoxLayout::addWidget(QWidget* wd, int stretch, QtE5_Const::AlignmentFlag alignment) {
	// printf("++1+ addWidget %p добавил виджет %p\n", QtObj(), wd->QtObj() );
	((t_v__vp_vp_i_i) pFunQt[38])(QtObj(), wd->QtObj(), stretch, alignment);
	// printf("++1+ addWidget %p добавил виджет %p\n", QtObj(), wd->QtObj() );
};
//____________________________________________________________________
QTextCodec::QTextCodec(char* strNameCodec) : QObject('A') {
	setQtObj(((t_vp__vp)pFunQt[448])(strNameCodec));
};
QString QTextCodec::toUnicode(char* str, QString qstr) {
	((t_v__vp_vp_vp)pFunQt[449])(QtObj(), qstr.QtObj(), str);
	return qstr;
};
char* QTextCodec::fromUnicode(char* str, QString qstr) {
	((t_v__vp_vp_vp)pFunQt[450])(QtObj(), qstr.QtObj(), str); return str;
};
	
    
} /* end namespace QtE5 */
