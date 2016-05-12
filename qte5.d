// Written in the D programming language.
// MGW Мохов Геннадий Владимирович 2016
// Версия v0.01 - 20.02.16 12:45

module qte5;

import std.conv; // Convert to string

// Отладка
import std.stdio;


int verQt5Eu = 0;
int verQt5El = 03;
string verQt5Ed = "25.04.16 07:53";

alias PTRINT = int;
alias PTRUINT = uint;

struct QtObj__ { PTRINT dummy; } alias QtObjH = QtObj__*;


private void*[400] pFunQt; /// Масив указателей на функции из DLL

immutable int QMETHOD = 0; // member type codes
immutable int QSLOT = 1;
immutable int QSIGNAL = 2;

// ----- Описание типов, фактически указание компилятору как вызывать -----
// ----- The description of types, actually instructions to the compiler how to call -----

// Give type Qt. There is an implicit transformation. cast (GetObjQt_t) Z == *Z on any type.
// alias GetObjQt_t = void**; // Дай тип Qt. Происходит неявное преобразование. cast(GetObjQt_t)Z == *Z на любой тип.

private extern (C) @nogc alias t_QObject_connect = void function(void*, char*, void*, char*, int);

private extern (C) @nogc alias t_v__i = void function(int);
private extern (C) @nogc alias t_v__qp = void function(QtObjH);
private extern (C) @nogc alias t_v__qp_qp = void function(QtObjH, QtObjH);
private extern (C) @nogc alias t_v__qp_vp = void function(QtObjH, void*);
private extern (C) @nogc alias t_v__qp_i = void function(QtObjH, int);
private extern (C) @nogc alias t_v__vp_c = void function(void*, char);

private extern (C) @nogc alias t_vp__qp = void* function(void*);
private extern (C) @nogc alias t_v__vp_vp_vp = void function(void*, void*, void*);
private extern (C) @nogc alias t_v__qp_i_i = void function(QtObjH, int, int);
private extern (C) @nogc alias t_v__qp_qp_i_i = void function(QtObjH, QtObjH, int, int);

private extern (C) @nogc alias t_b__qp = bool function(QtObjH);
private extern (C) @nogc alias t_b__qp_i = bool function(QtObjH, int);
private extern (C) @nogc alias t_b__qp_i_i_i = bool function(QtObjH, int, int, int);

private extern (C) @nogc alias t_v__qp_qp_i = void function(QtObjH, QtObjH, int);
private extern (C) @nogc alias t_v__qp_qp_qp_i = void function(QtObjH, QtObjH, QtObjH, int);
private extern (C) @nogc alias t_v__qp_qp_qp = void function(QtObjH, QtObjH, QtObjH);
private extern (C) @nogc alias t_v__qp_i_i_i_i_i = void function(QtObjH, int, int, int, int, int);



private extern (C) @nogc alias t_i__vp_vp_vp = int function(void*, void*, void*);
private extern (C) @nogc alias t_i__vp_i = int function(void*, int);
private extern (C) @nogc alias t_i__qp_i = int function(QtObjH, int);
private extern (C) @nogc alias t_i__qp_i_i = int function(QtObjH, int, int);
private extern (C) @nogc alias t_qp__qp_qp = QtObjH function(QtObjH, QtObjH);
private extern (C) @nogc alias t_vp__vp_c_i = void* function(void*, char, int);
private extern (C) @nogc alias t_vp__vp_cp_i = void* function(void*, char*, int);

private extern (C) @nogc alias t_vpp__vp = void** function(void*);
private extern (C) @nogc alias t_qp__qp = QtObjH function(QtObjH);
private extern (C) @nogc alias t_qp__vp = QtObjH function(void*);
private extern (C) @nogc alias t_c_vp__vp = const void* function(void*);

private extern (C) @nogc alias t_vp__vp_i_i = void* function(void*, int, int);
private extern (C) @nogc alias t_vp__vp_i_vp = void* function(void*, int, void*);

private extern (C) @nogc alias t_vp__vp_vp_i = void* function(void*, void*, int);
private extern (C) @nogc alias t_qp__qp_qp_i = QtObjH function(QtObjH, QtObjH, int);
private extern (C) @nogc alias t_vp__vp_i = void* function(void*, int);
private extern (C) @nogc alias t_qp__qp_i = QtObjH function(QtObjH, int);
private extern (C) @nogc alias t_qp__qp_i_i = QtObjH function(QtObjH, int, int);
private extern (C) @nogc alias t_vp__v = void* function();
private extern (C) @nogc alias t_qp__v = QtObjH function();
private extern (C) @nogc alias t_i__vp = int function(void*);
private extern (C) @nogc alias t_i__qp = int function(QtObjH);

private extern (C) @nogc alias t_v__qp_b_i_i = void function(QtObjH, bool, int, int);
private extern (C) @nogc alias t_v__qp_b_i = void function(QtObjH, bool, int);

private extern (C) @nogc alias t_vp__i_i = void* function(int, int);
private extern (C) @nogc alias t_qp__i_i = QtObjH function(int, int);
private extern (C) @nogc alias t_qp__i = QtObjH function(int);

private extern (C) @nogc alias t_vp__i_i_i_i = void* function(int, int, int, int);

private extern (C) @nogc alias t_v__vp_i_bool = void function(void*, int, bool);
private extern (C) @nogc alias t_v__vp_i_i_i_i = void function(void*, int, int, int, int);
private extern (C) @nogc alias t_v__qp_i_i_i_i = void function(QtObjH, int, int, int, int);
private extern (C) @nogc alias t_v__qp_i_i_i = void function(QtObjH, int, int, int);
private extern (C) @nogc alias t_v__vp_i_i_vp = void function(void*, int, int, void*);
private extern (C) @nogc alias t_v__i_vp_vp = void function(int, void*, void*);
private extern (C) @nogc alias t_vp__vp_vp_bool = void* function(void*, void*, bool);
private extern (C) @nogc alias t_vp__i_vp_bool = void* function(int, void*, bool);
private extern (C) @nogc alias t_i__v = int function();
private extern (C) @nogc alias t_i__vp_vbool_i = int function(void*, bool*, int);

private extern (C) @nogc alias t_vp__vp_i_vp_i = void* function(void*, int, void*, int);
private extern (C) @nogc alias t_vp__vp_i_i_vp = void* function(void*, int, int, void*);
private extern (C) @nogc alias t_vp__vp_vp_i_i = void* function(void*, void*, int, int);
private extern (C) @nogc alias t_i__vp_vp_i_i = int function(void*, void*, int, int);

private extern (C) @nogc alias t_vp__vp_vp_us_i = void* function(void*, void*, ushort, int);
private extern (C) @nogc alias t_v__vp_vp_us_i = void function(void*, void*, ushort, int);
private extern (C) @nogc alias t_bool__vp = bool function(void*);
private extern (C) @nogc alias t_bool__vp_c = bool function(void*, char);
private extern (C) @nogc alias t_bool__vp_vp = bool function(void*, void*);
private extern (C) @nogc alias t_v__qp_bool = void function(QtObjH, bool);
private extern (C) @nogc alias t_v__qp_b = void function(QtObjH, bool);
private extern (C) @nogc alias t_v__vp_i_vp_us_i = void function(void*, int, void*, ushort, int);
private extern (C) @nogc alias t_vp__vp_vp_vp = void* function(void*, void*, void*);

private extern (C) @nogc alias t_l__vp_vp_l = long function(void*, void*, long);
private extern (C) @nogc alias t_l__vp = long function(void*);

private extern (C) @nogc alias t_vp__vp_vp_vp_vp_vp_vp_vp = void* function(void*, void*, void*, void*, void*, void*, void*);
private extern (C) @nogc alias t_vp__vp_vp_vp_vp_vp_vp_vp_vp = void* function(void*, void*, void*, void*, void*, void*, void*, void*);

private extern (C) @nogc alias t_ub__qp = ubyte* function(QtObjH);

version (Windows) {
	private import core.sys.windows.windows: GetProcAddress;
}
version (linux) {
	private import core.sys.posix.dlfcn: dlopen, dlsym, RTLD_GLOBAL, RTLD_LAZY;
    // На Linux эти функции не определены в core.runtime, вот и пришлось дописать.
    // странно, почему их там нет... Похоже они в основном Windows крутят. 
	// On Linux these functions aren't defined in core.runtime, here and it was necessary to add.
	// It is strange why they aren't present there... 
	// Probably they in the main Windows twist.
    private extern (C) void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);  }
    private void* GetProcAddress(void* hLib, const char* nameFun) {  return dlsym(hLib, nameFun);    }
}
version (OSX) {
	private import core.sys.posix.dlfcn: dlopen, dlsym, RTLD_GLOBAL, RTLD_LAZY;
    // На Linux эти функции не определены в core.runtime, вот и пришлось дописать.
    // странно, почему их там нет... Похоже они в основном Windows крутят. 
	// On Linux these functions aren't defined in core.runtime, here and it was necessary to add.
	// It is strange why they aren't present there... 
	// Probably they in the main Windows twist.
    private extern (C) void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);  }
    private void* GetProcAddress(void* hLib, const char* nameFun) {  return dlsym(hLib, nameFun);    }
}
// Загрузить DLL. Load DLL (.so)
private void* GetHlib(T)(T name) { 
	import core.runtime;
	return Runtime.loadLibrary(name); 
}

// Найти адреса функций в DLL. To find addresses of executed out functions in DLL
private void* GetPrAddres(T)(bool isLoad, void* hLib, T nameFun) {
	// // Искать или не искать функцию. Find or not find function in library
	if (isLoad) return GetProcAddress(hLib, nameFun.ptr);
	return cast(void*) 1;
}
// Сообщить об ошибке загрузки. Message on error.
private void MessageErrorLoad(bool showError, string s, string nameDll = "" ) {
	if (showError) {
		if (!nameDll.length) writeln("Error load: " ~ s);
		else writeln("Error find function: " ~ nameDll ~ " ---> " ~ s);
	}
} /// Message on error. s - text error, sw=1 - error load dll and sw=2 - error find function

char* MSS(string s, int n) {
	if (n == QMETHOD)	return cast(char*)("0" ~ s ~ "\0").ptr;
	if (n == QSLOT) 	return cast(char*)("1" ~ s ~ "\0").ptr;
	if (n == QSIGNAL)	return cast(char*)("2" ~ s ~ "\0").ptr;
	return null;
} /// Моделирует макросы QT. Model macros Qt. For n=2->SIGNAL(), n=1->SLOT(), n=0->METHOD().

// Qt5Core & Qt5Gui & Qt5Widgets - Are loaded always
enum dll {
	QtE5Widgets = 0x1
} /// Загрузка DLL. Необходимо выбрать какие грузить. Load DLL, we mast change load

// Найти и сохранить адрес функции DLL
void funQt(int n, bool b, void* h, string s, string name, bool she) {
	pFunQt[n] = GetPrAddres(b, h, name); if (!pFunQt[n]) MessageErrorLoad(she, name, s);
}

int LoadQt(dll ldll, bool showError) { ///  Загрузить DLL-ки Qt и QtE
	bool	bCore5, bGui5, bWidget5, bQtE5Widgets;
	string	sCore5, sGui5, sWidget5, sQtE5Widgets;
	void*	hCore5, hGui5, hWidget5, hQtE5Widgets;
	
	// Add path to directory with realy file Qt5 DLL
	version (Windows) {
		version (X86) {		// ... 32 bit code ...
			sCore5			= "Qt5Core.dll";
			sGui5			= "Qt5Gui.dll";
			sWidget5		= "Qt5Widgets.dll";
			sQtE5Widgets	= "QtE5Widgets32.dll";
		}
		version (X86_64) {	// ... 64 bit code 	
			sCore5			= "Qt5Core.dll";
			sGui5			= "Qt5Gui.dll";
			sWidget5		= "Qt5Widgets.dll";
			sQtE5Widgets	= "QtE5Widgets64.dll";
		}
	}
	// Use symlink for create link on realy file Qt5
	version (linux) {
		version (X86) {		// ... 32 bit code ...
			sCore5			= "libQt5Core.so";
			sGui5			= "libQt5Gui.so";
			sWidget5		= "libQt5Widgets.so";
			sQtE5Widgets	= "libQtE5Widgets32.so";
		}
		version (X86_64) {	// ... 64 bit code 	
			sCore5			= "libQt5Core.so";
			sGui5			= "libQt5Gui.so";
			sWidget5		= "libQt5Widgets.so";
			sQtE5Widgets	= "libQtE5Widgets64.so";
		}
	}
	// Use symlink for create link on realy file Qt5
	// Only 64 bit version Mac OS X (10.9.5 Maveric)
	version (OSX) {
		sCore5			= "libQt5Core.dylib";
		sGui5			= "libQt5Gui.dylib";
		sWidget5		= "libQt5Widgets.dylib";
		sQtE5Widgets	= "libQtE5Widgets64.dylib";
	}
	
	// Если на входе указана dll.QtE5Widgets то автоматом надо грузить и bCore5, bGui5, bWidget5
	// If on an input it is specified dll.QtE5Widgets then automatic loaded bCore5, bGui5, bWidget5
	bQtE5Widgets= ldll && dll.QtE5Widgets;
	if(bQtE5Widgets) { bCore5 = true; bGui5 = true; bWidget5 = true; }

	// Load library in memory
/* 	
 	if (bCore5) {
		hCore5 = GetHlib(sCore5); if (!hCore5) { MessageErrorLoad(showError, sCore5); return 1; }
	}
	if (bGui5) {
		hGui5 = GetHlib(sGui5);	if (!hGui5) { MessageErrorLoad(showError, sGui5); return 1; }
	}
	if (bWidget5) {
		hWidget5 = GetHlib(sWidget5); if (!hWidget5) { MessageErrorLoad(showError, sWidget5); return 1; }
	}
 */
	if (bQtE5Widgets) {
		hQtE5Widgets = GetHlib(sQtE5Widgets); if (!hQtE5Widgets) { MessageErrorLoad(showError, sQtE5Widgets); return 1; }
	}
	// Find name function in DLL

	// ------- QApplication -------
	funQt(0,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_create1",    showError);
	funQt(1,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_exec",       showError);
	funQt(2,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_aboutQt",    showError);
	funQt(3,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_delete1",    showError);
	funQt(4,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_sizeof",     showError);
	funQt(20, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_appDirPath", showError);
	funQt(21, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQApplication_appFilePath",showError);
	// ------- QWidget -------
	funQt(5,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_create1",         showError);
	funQt(6,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setVisible",      showError);
	funQt(7,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_delete1",         showError);
	funQt(11, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setWindowTitle",  showError);
	funQt(12, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_isVisible",       showError);
	funQt(30, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setStyleSheet",   showError);
	funQt(31, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setMMSize",       showError);
	funQt(32, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setEnabled",      showError);
	funQt(33, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setToolTip",      showError);
	funQt(40, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setLayout",       showError);
	funQt(78, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setSizePolicy",   showError);
	funQt(79, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setMax1",         showError);
	funQt(87, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_exWin1",          showError);
	funQt(94, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_exWin2",          showError);
	funQt(49, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setKeyPressEvent",showError);
	funQt(50, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setPaintEvent",   showError);
	funQt(51, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setCloseEvent",   showError);
	funQt(52, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setResizeEvent",  showError);
	funQt(131,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_setFont",         showError);
	funQt(148,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_winid",           showError);
	funQt(172,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_getPr",           showError);
	funQt(259,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQWidget_getBoolXX",       showError);
	
	// ------- QString -------
	funQt(8,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_create1",         showError);
	funQt(9,  bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_create2",         showError);
	funQt(10, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_delete",          showError);
	funQt(18, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_data",            showError);
	funQt(19, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQString_size",            showError);
	// ------- QColor -------
	funQt(13, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQColor_create1",          showError);
	funQt(14, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQColor_delete",           showError);
	funQt(15, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQColor_setRgb",           showError);
	// ------- QPalette -------
	funQt(16, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPalette_create1",        showError);
	funQt(17, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPalette_delete",         showError);
	// ------- QPushButton -------
	funQt(22, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPushButton_create1",     showError);
	funQt(23, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPushButton_delete",      showError);
	funQt(210,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPushButton_setXX",       showError);

	// ------- QSlot -------
	funQt(24, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlot_create",            showError);
	funQt(25, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "QSlot_setSlotN",             showError);
	funQt(26, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlot_delete",            showError);
	funQt(27, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteConnect",                 showError);
	funQt(81, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "QSlot_setSlotN2",            showError);
	// ------- QAbstractButton -------
	funQt(28, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_setText", showError);
	funQt(29, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_text",    showError);
	funQt(209,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_setXX",   showError);
	funQt(211,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_setIcon", showError);
	funQt(224,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractButton_getXX",   showError);

	// ------- QLayout -------
	funQt(34, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout",              showError);
	funQt(35, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQVBoxLayout",             showError);
	funQt(36, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQHBoxLayout",             showError);
	funQt(37, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_delete",       showError);
	funQt(38, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_addWidget",    showError);
	funQt(39, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_addLayout",    showError);
	funQt(74, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_setSpasing",   showError);
	funQt(75, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_spasing",      showError);
	funQt(76, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_setMargin",    showError);
	funQt(77, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_margin",       showError);
	// ------- QFrame -------
	funQt(41, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_create1",          showError);
	funQt(42, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_delete1",          showError);
	funQt(43, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setFrameShape",    showError);
	funQt(44, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setFrameShadow",   showError);
	funQt(45, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFrame_setLineWidth",     showError);
	// ------- QLabel --------
	funQt(46, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_create1",          showError);
	funQt(47, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_delete1",          showError);
	funQt(48, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLabel_setText",          showError);
	// ------- QEvent -------
	funQt(53, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQEvent_type",             showError);
	funQt(157,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQEvent_ia",				  showError);
	// ------- QResizeEvent -------
	funQt(54, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQResizeEvent_size",       showError);
	funQt(55, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQResizeEvent_oldSize",    showError);
	// ------- QSize -------
	funQt(56, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_create1",           showError);
	funQt(57, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_delete1",           showError);
	funQt(58, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_width",             showError);
	funQt(59, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_heigth",            showError);
	funQt(60, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_setWidth",          showError);
	funQt(61, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSize_setHeigth",         showError);
	// ------- QKeyEvent -------
	funQt(62, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQKeyEvent_key",           showError);
	funQt(63, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQKeyEvent_count",         showError);
	// ------- QAbstractScrollArea -------
	funQt(64, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractScrollArea_create1", showError);
	funQt(65, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractScrollArea_delete1", showError);
	// ------- QPlainTextEdit -------
	funQt(66, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_create1",         showError);
	funQt(67, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_delete1",         showError);
	funQt(68, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_appendPlainText", showError);
	funQt(69, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_appendHtml",      showError);
	funQt(70, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_setPlainText",    showError);
	funQt(71, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_insertPlainText", showError);
	funQt(72, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_cutn",            showError);
	funQt(73, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_toPlainText",     showError);
	funQt(80, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_setKeyPressEvent",showError);
	funQt(225,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_setKeyReleaseEvent",showError);
	funQt(226,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_document",		showError);
	funQt(230,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_textCursor",		showError);
	funQt(235,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_cursorRect",		showError);
	funQt(235,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_cursorRect",		showError);
	funQt(236,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_setTabStopWidth",showError);
	funQt(253,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPlainTextEdit_setTextCursor",	showError);
	//  ------- QLineEdit -------
	funQt(82, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_create1",				showError);
	funQt(83, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_delete1",				showError);
	funQt(84, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_set",					showError);
	funQt(85, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_clear",				showError);
	funQt(86, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_text",				showError);
	funQt(158,bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLineEdit_setKeyPressEvent",  showError);
	//  ------- QMainWindow -------
	funQt(88, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMainWindow_create1",			showError);
	funQt(89, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMainWindow_delete1",			showError);
	funQt(90, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMainWindow_setXX",				showError);
	funQt(126, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMainWindow_addToolBar",		showError);
	//  ------- QStatusBar -------
	funQt(91, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQStatusBar_create1",			showError);
	funQt(92, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQStatusBar_delete1",			showError);
	funQt(93, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQStatusBar_showMessage",		showError);
	//  ------- QAction -------
	funQt(95, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_create",				showError);
	funQt(96, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_delete",				showError);
	funQt(97, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_setXX1",				showError);
	funQt(98, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAction_setSlotN2",				showError);
	funQt(105, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"qteQAction_setHotKey",				showError);
	funQt(109, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"qteQAction_setEnabled",			showError);
	funQt(113, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,"qteQAction_setIcon",				showError);
	//  ------- QMenu -------
	funQt(99, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets,  "qteQMenu_create",					showError);
	funQt(100, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenu_delete",					showError);
	funQt(101, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenu_addAction",				showError);
	funQt(106, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenu_setTitle",				showError);
	funQt(107, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenu_addSeparator",			showError);
	funQt(108, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenu_addMenu",				showError);
	//  ------- QMenuBar -------
	funQt(102, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenuBar_create",				showError);
	funQt(103, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenuBar_delete",				showError);
	funQt(104, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMenuBar_addMenu",				showError);
	//  ------- QIcon -------
	funQt(110, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQIcon_create",					showError);
	funQt(111, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQIcon_delete",					showError);
	funQt(112, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQIcon_addFile",				showError);
	//  ------- QToolBar -------
	funQt(114, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_create",				showError);
	funQt(115, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_delete",				showError);
	funQt(116, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_setXX1",				showError);

	funQt(124, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_setAllowedAreas",		showError);
	funQt(125, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_setToolButtonStyle",	showError);

	funQt(132, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQToolBar_addSeparator",		showError);
	
	//  ------- QDialog -------
	funQt(117, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDialog_create",				showError);
	funQt(118, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDialog_delete",				showError);
	funQt(119, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDialog_exec",					showError);
	//  ------- QDialog -------
	funQt(120, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMessageBox_create",			showError);
	funQt(121, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMessageBox_delete",			showError);
	funQt(122, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMessageBox_setXX1",			showError);
	funQt(123, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMessageBox_setStandartButtons",	showError);
	//  ------- QFont -------
	funQt(127, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFont_create",					showError);
	funQt(128, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFont_delete",					showError);
	funQt(129, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFont_setPointSize",			showError);
	funQt(130, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFont_setFamily",				showError);
	//  ------- QProgressBar -------
	funQt(133, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQProgressBar_create",			showError);
	funQt(134, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQProgressBar_delete",			showError);
	funQt(135, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQProgressBar_setPr",  			showError);
	//  ------- QDate -------
	funQt(136, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDate_create",					showError);
	funQt(137, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDate_delete",					showError);
	funQt(140, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQDate_toString",				showError);

	//  ------- QTime -------
	funQt(138, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTime_create",					showError);
	funQt(139, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTime_delete",					showError);
	funQt(141, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTime_toString",				showError);
	
	//  ------- QFileDialog -------
	funQt(142, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_create",			showError);
	funQt(143, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_delete",			showError);
	funQt(144, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_setNameFilter",	showError);
	funQt(145, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_setViewMode",		showError);
	funQt(146, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_getOpenFileName",	showError);
	funQt(147, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQFileDialog_getSaveFileName",	showError);
	//  ------- QAbstractScrollArea -------
	funQt(149, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractScrollArea_create",	showError);
	funQt(150, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractScrollArea_delete",	showError);
	//  ------- QMdiArea -------
	funQt(151, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiArea_create",				showError);
	funQt(152, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiArea_delete",				showError);

	funQt(155, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiArea_addSubWindow",		showError);
	//  ------- QMdiSubWindow -------
	funQt(153, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiSubWindow_create",			showError);
	funQt(154, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiSubWindow_delete",			showError);
	funQt(156, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQMdiSubWindow_addLayout",		showError);
	//  ------- QTableView -------
	funQt(159, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_create",			showError);
	funQt(160, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_delete",			showError);

	funQt(174, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_setN1",				showError);
	funQt(175, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_getN1",				showError);
	funQt(182, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_ResizeMode",		showError);
	
	//  ------- QTableWidget -------
	funQt(161, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_create",			showError);
	funQt(162, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_delete",			showError);
	funQt(163, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_setRC",			showError);
	funQt(167, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_setitem",			showError);
	
	funQt(176, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_setHVheaderItem",	showError);
	funQt(241, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_setCurrentCell",	showError);
	
	//  ------- QTableWidgetItem -------
	funQt(164, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_create",		showError);
	funQt(165, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_delete",		showError);

	funQt(166, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_setXX",		showError);
	funQt(168, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_setYY",		showError);
	funQt(169, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidget_item",			showError);
	funQt(170, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_text",		showError);
	funQt(171, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_setAligment",	showError);
	funQt(180, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableWidgetItem_setBackground",	showError);

	//  ------- QBrush -------
	funQt(177, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_create1",				showError);
	funQt(178, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_delete",				showError);
	funQt(179, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_setColor",				showError);
	funQt(181, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_setStyle",				showError);

	//  ------- QComboBox -------
	funQt(183, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQComboBox_create",				showError);
	funQt(184, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQComboBox_delete",				showError);
	funQt(185, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQComboBox_setXX",				showError);
	funQt(186, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQComboBox_getXX",				showError);
	funQt(187, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQComboBox_text",				showError);
	//  ------- QPainter -------
	funQt(188, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_drawPoint",			showError);
	funQt(189, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_drawLine",			showError);
	funQt(190, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_setXX1",				showError);
	funQt(196, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_setText",				showError);
	funQt(197, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_end",					showError);
	funQt(243, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_drawRect1",			showError);
	funQt(244, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_drawRect2",			showError);
	funQt(245, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_fillRect2",			showError);
	funQt(246, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPainter_fillRect3",			showError);
	//  ------- QPen -------
	funQt(191, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPen_create1",					showError);
	funQt(192, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPen_delete",					showError);
	funQt(193, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPen_setColor",				showError);
	funQt(194, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPen_setStyle",				showError);
	funQt(195, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQPen_setWidth",				showError);
	//  ------- QLCDNumber -------
	funQt(198, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_create1",			showError);
	funQt(199, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_delete1",			showError);
	funQt(200, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_create2",			showError);
	funQt(201, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_display",			showError);
	funQt(202, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_setSegmentStyle",	showError);
	funQt(203, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_setDigitCount",		showError);
	funQt(204, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQLCDNumber_setMode",			showError);
	//  ------- QAbstractSlider -------
	funQt(205, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractSlider_setXX",		showError);
	funQt(208, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractSlider_getXX",		showError);
	//  ------- QSlider -------
	funQt(206, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlider_create1",				showError);
	funQt(207, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlider_delete1",				showError);
	//  ------- QGroupBox -------
	funQt(212, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQGroupBox_create",				showError);
	funQt(213, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQGroupBox_delete",				showError);
	funQt(214, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQGroupBox_setTitle",			showError);
	funQt(215, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQGroupBox_setAlignment",		showError);
	//  ------- QCheckBox -------
	funQt(216, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_create1",			showError);
	funQt(217, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_delete",				showError);
	funQt(218, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_checkState",			showError);
	funQt(219, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_setCheckState",		showError);
	funQt(220, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_setTristate",		showError);
	funQt(221, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQCheckBox_isTristate",			showError);
	//  ------- QRadioButton -------
	funQt(222, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRadioButton_create1",			showError);
	funQt(223, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRadioButton_delete",			showError);
	//  ------- QTextCursor -------
	funQt(227, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_create1",			showError);
	funQt(228, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_delete",			showError);
	funQt(229, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_create2",			showError);
	funQt(231, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_getXX1",			showError);
	funQt(254, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_movePosition",		showError);
	funQt(255, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_runXX",			showError);
	funQt(256, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextCursor_insertText1",		showError);
	//  ------- QRect -------
	funQt(232, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRect_create1",				showError);
	funQt(233, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRect_delete",					showError);
	funQt(234, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRect_setXX1",					showError);
	funQt(242, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQRect_setXX2",					showError);
	
	//  ------- QTextBlock -------
	funQt(237, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextBlock_text",				showError);
	funQt(238, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextBlock_create",			showError);
	funQt(239, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextBlock_delete",			showError);
	funQt(240, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextBlock_create2",			showError);

	//  ------- QSpinBox -------
	funQt(247, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSpinBox_create",				showError);
	funQt(248, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSpinBox_delete",				showError);
	funQt(249, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSpinBox_setXX1",				showError);
	funQt(250, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSpinBox_getXX1",				showError);
	funQt(251, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSpinBox_setXX2",				showError);

	//  ------- QAbstractSpinBox -------
	funQt(252, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQAbstractSpinBox_setReadOnly",	showError);

	//  ------- Highlighter -- Временный, подлежит в дальнейшем удалению -----
	funQt(257, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteHighlighter_create",			showError);
	funQt(258, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteHighlighter_delete",			showError);

	// ------- QTextEdit -------
	funQt(260, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextEdit_create1",			showError);
	funQt(261, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextEdit_delete1",			showError);
	funQt(270, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextEdit_setPlainText",		showError);
	funQt(271, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextEdit_insertPlainText",	showError);
	funQt(272, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTextEdit_cutn",           	 showError);

	// ------- QTimer -------
	funQt(262, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_create",				showError);
	funQt(263, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_delete",				showError);
	funQt(264, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_setInterval",			showError);
	funQt(265, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_getXX1",				showError);
	funQt(266, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_getXX2",				showError);
	funQt(267, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_setTimerType",			showError);
	funQt(268, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_setSingleShot",			showError);
	funQt(269, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTimer_timerType",				showError);
	
	// Последний = 270
	return 0;
} ///  Загрузить DLL-ки Qt и QtE. Найти в них адреса функций и заполнить ими таблицу

static void msgbox(string text = null, string caption = null,
	QMessageBox.Icon icon = QMessageBox.Icon.Information, QWidget parent = null) {
	string cap, titl;
	QMessageBox soob = new QMessageBox(parent);
	if (caption is null) soob.setWindowTitle("Внимание!"); else soob.setWindowTitle(caption);
	if (text    is null) soob.setText(". . . . .");        else soob.setText(text);
	soob.setIcon(icon).setStandardButtons(QMessageBox.StandardButton.Ok);
	try { soob.exec();	}	catch {}
}

/++
Класс констант. В нем кое что из Qt::
+/
class QtE {
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
	}
	enum KeyboardModifier {
		NoModifier           = 0x00000000,
		ShiftModifier        = 0x02000000,
		ControlModifier      = 0x04000000,
		AltModifier          = 0x08000000,
		MetaModifier         = 0x10000000,
		KeypadModifier       = 0x20000000,
		GroupSwitchModifier  = 0x40000000,
		// Do not extend the mask to include 0x01000000
		KeyboardModifierMask = 0xfe000000 	
	}
	// Политика контексного меню
	enum ContextMenuPolicy {
		NoContextMenu = 0, // нет контексного меню
		DefaultContextMenu = 1, //
		ActionsContextMenu = 2, //
		CustomContextMenu = 3, //
		PreventContextMenu = 4 //
	}
	enum Key {
		Key_ControlModifier = 0x04000000,
		Key_Escape = 0x01000000, // misc keys
		Key_Tab = 0x01000001,
		Key_Backtab = 0x01000002,
		Key_Backspace = 0x01000003,
		Key_Return = 0x01000004,
		Key_Enter = 0x01000005,
		Key_Insert = 0x01000006,
		Key_Delete = 0x01000007,
		Key_Pause = 0x01000008,
		Key_Print = 0x01000009,
		Key_SysReq = 0x0100000a,
		Key_Clear = 0x0100000b,
		Key_Home = 0x01000010, // cursor movement
		Key_End = 0x01000011,
		Key_Left = 0x01000012,
		Key_Up = 0x01000013,
		Key_Right = 0x01000014,
		Key_Down = 0x01000015,
		Key_PageUp = 0x01000016,
		Key_Shift = 0x01000020, // modifiers
		Key_Control = 0x01000021,
		Key_Meta = 0x01000022,
		Key_Alt = 0x01000023,
		Key_CapsLock = 0x01000024,
		Key_NumLock = 0x01000025,
		Key_ScrollLock = 0x01000026,
		Key_F1 = 0x01000030, // function keys
		Key_F2 = 0x01000031,
		Key_F3 = 0x01000032,
		Key_F4 = 0x01000033,
		Key_F5 = 0x01000034,
		Key_F6 = 0x01000035,
		Key_F7 = 0x01000036,
		Key_F8 = 0x01000037,
		Key_F9 = 0x01000038,
		Key_F10 = 0x01000039,
		Key_F11 = 0x0100003a,
		Key_F12 = 0x0100003b,
		Key_F13 = 0x0100003c,
		Key_F14 = 0x0100003d,
		Key_F15 = 0x0100003e,
		Key_F16 = 0x0100003f,
		Key_F17 = 0x01000040,
		Key_F18 = 0x01000041,
		Key_F19 = 0x01000042,
		Key_F20 = 0x01000043,
		Key_F21 = 0x01000044,
		Key_F22 = 0x01000045,
		Key_F23 = 0x01000046,
		Key_F24 = 0x01000047,
		Key_F25 = 0x01000048, // F25 .. F35 only on X11
		Key_F26 = 0x01000049,
		Key_F27 = 0x0100004a,
		Key_F28 = 0x0100004b,
		Key_F29 = 0x0100004c,
		Key_F30 = 0x0100004d,
		Key_F31 = 0x0100004e,
		Key_F32 = 0x0100004f,
		Key_F33 = 0x01000050,
		Key_F34 = 0x01000051,
		Key_F35 = 0x01000052,
		Key_Super_L = 0x01000053, // extra keys
		Key_Super_R = 0x01000054,
		Key_Menu = 0x01000055,
		Key_Hyper_L = 0x01000056,
		Key_Hyper_R = 0x01000057,
		Key_Help = 0x01000058,
		Key_Direction_L = 0x01000059,
		Key_Direction_R = 0x01000060,
		Key_Space = 0x20, // 7 bit printable ASCII
		Key_Any = Key_Space,
		Key_Exclam = 0x21,
		Key_QuoteDbl = 0x22,
		Key_NumberSign = 0x23,
		Key_Dollar = 0x24,
		Key_Percent = 0x25,
		Key_Ampersand = 0x26,
		Key_Apostrophe = 0x27,
		Key_ParenLeft = 0x28,
		Key_ParenRight = 0x29,
		Key_Asterisk = 0x2a,
		Key_Plus = 0x2b,
		Key_Comma = 0x2c,
		Key_Minus = 0x2d,
		Key_Period = 0x2e,
		Key_Slash = 0x2f,
		Key_0 = 0x30,Key_1 = 0x31,Key_2 = 0x32,Key_3 = 0x33,Key_4 = 0x34,Key_5 = 0x35,
		Key_6 = 0x36,Key_7 = 0x37,Key_8 = 0x38,Key_9 = 0x39,Key_Colon = 0x3a,
		Key_Semicolon = 0x3b,
		Key_Less = 0x3c,
		Key_Equal = 0x3d,
		Key_Greater = 0x3e,
		Key_Question = 0x3f,
		Key_At = 0x40,
		Key_A = 0x41,
		Key_B = 0x42,
		Key_C = 0x43,
		Key_D = 0x44,
		Key_E = 0x45,
		Key_F = 0x46,
		Key_G = 0x47,
		Key_H = 0x48,
		Key_I = 0x49,
		Key_J = 0x4a,
		Key_K = 0x4b,
		Key_L = 0x4c,
		Key_M = 0x4d,
		Key_N = 0x4e,
		Key_O = 0x4f,
		Key_P = 0x50,
		Key_Q = 0x51,
		Key_R = 0x52,
		Key_S = 0x53,
		Key_T = 0x54,
		Key_U = 0x55,
		Key_V = 0x56,
		Key_W = 0x57,
		Key_X = 0x58,
		Key_Y = 0x59,
		Key_Z = 0x5a,
		Key_BracketLeft = 0x5b,
		Key_Backslash = 0x5c,
		Key_BracketRight = 0x5d,
		Key_AsciiCircum = 0x5e,
		Key_Underscore = 0x5f,
		Key_QuoteLeft = 0x60,
		Key_BraceLeft = 0x7b,
		Key_Bar = 0x7c,
		Key_BraceRight = 0x7d,
		Key_AsciiTilde = 0x7e,
		Key_nobreakspace = 0x0a0,
		Key_exclamdown = 0x0a1,
		Key_cent = 0x0a2,
		Key_sterling = 0x0a3,
		Key_currency = 0x0a4,
		Key_yen = 0x0a5,
		Key_brokenbar = 0x0a6,
		Key_section = 0x0a7,
		Key_diaeresis = 0x0a8,
		Key_copyright = 0x0a9,
		Key_ordfeminine = 0x0aa,
		Key_guillemotleft = 0x0ab, // left angle quotation mark
		Key_notsign = 0x0ac,
		Key_hyphen = 0x0ad,
		Key_registered = 0x0ae,
		Key_macron = 0x0af,
		Key_degree = 0x0b0,
		Key_plusminus = 0x0b1,
		Key_twosuperior = 0x0b2,
		Key_threesuperior = 0x0b3,
		Key_acute = 0x0b4,
		Key_mu = 0x0b5,
		Key_paragraph = 0x0b6,
		Key_periodcentered = 0x0b7,
		Key_cedilla = 0x0b8,
		Key_onesuperior = 0x0b9,
		Key_masculine = 0x0ba,
		Key_guillemotright = 0x0bb, // right angle quotation mark
		Key_onequarter = 0x0bc,
		Key_onehalf = 0x0bd,
		Key_threequarters = 0x0be,
		Key_questiondown = 0x0bf,
		Key_Agrave = 0x0c0,
		Key_Aacute = 0x0c1,
		Key_Acircumflex = 0x0c2,
		Key_Atilde = 0x0c3,
		Key_Adiaeresis = 0x0c4,
		Key_Aring = 0x0c5,
		Key_AE = 0x0c6,
		Key_Ccedilla = 0x0c7,
		Key_Egrave = 0x0c8,
		Key_Eacute = 0x0c9,
		Key_Ecircumflex = 0x0ca,
		Key_Ediaeresis = 0x0cb,
		Key_Igrave = 0x0cc,
		Key_Iacute = 0x0cd,
		Key_Icircumflex = 0x0ce,
		Key_Idiaeresis = 0x0cf,
		Key_ETH = 0x0d0,
		Key_Ntilde = 0x0d1,
		Key_Ograve = 0x0d2,
		Key_Oacute = 0x0d3,
		Key_Ocircumflex = 0x0d4,
		Key_Otilde = 0x0d5,
		Key_Odiaeresis = 0x0d6,
		Key_multiply = 0x0d7,
		Key_Ooblique = 0x0d8,
		Key_Ugrave = 0x0d9,
		Key_Uacute = 0x0da,
		Key_Ucircumflex = 0x0db,
		Key_Udiaeresis = 0x0dc,
		Key_Yacute = 0x0dd,
		Key_THORN = 0x0de,
		Key_ssharp = 0x0df,
		Key_division = 0x0f7,
		Key_ydiaeresis = 0x0ff,
		Key_AltGr = 0x01001103,
		Key_Multi_key = 0x01001120, // Multi-key character compose
		Key_Codeinput = 0x01001137,
		Key_SingleCandidate = 0x0100113c,
		Key_MultipleCandidate = 0x0100113d,
		Key_PreviousCandidate = 0x0100113e,
		Key_unknown = 0x01ffffff
	}
	enum Orientation {
		Horizontal = 0x1,
		Vertical   = 0x2
	}
	enum AlignmentFlag {
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
	}
	enum GlobalColor {
		color0,
		color1,
		black,
		white,
		darkGray,
		gray,
		lightGray,
		red,
		green,
		blue,
		cyan,
		magenta,
		yellow,
		darkRed,
		darkGreen,
		darkBlue,
		darkCyan,
		darkMagenta,
		darkYellow,
		transparent
	}
 	enum PenStyle {
		NoPen			= 0,	// Запретить рисование
		SolidLine		= 1,	// Сплошная непрерывная линия
		DashLine		= 2,	// Штрихова, длинные штрихи
		DotLine			= 3,	// Пунктир, точки
		DashDotLine		= 4,	// Штрих пунктиреая, длинный штрих + точка
		DashDotDotLine	= 5,	// штрих 2 точки штрих 2 точки
		CustomDashLine	= 6		// A custom pattern defined using QPainterPathStroker::setDashPattern().
	}
	enum CheckState {
		Unchecked	= 0, 		// Не выбранный
		PartiallyChecked = 1,	// The item is partially checked. Items in hierarchical models may be partially checked if some, but not all, of their children are checked.
		Checked		= 2			// Выбран The item is checked.
	}
}
// ================ QObject ================
/++
Базовый класс.  Хранит в себе ссылку на реальный объект в Qt C++
Base class. Stores in itself the link to real object in Qt C ++
+/

// Две этих переменных служат для поиска ошибок связанных с ошибочным
// уничтожением объектов C++
// int allCreate;
// int balCreate;

class QObject {
	// Тип связи сигнал - слот
	enum ConnectionType {
		AutoConnection = 0,				// default. Если thred другой, то в очередь, иначе сразу выполнение
		DirectConnection = 1,			// Выполнить немедленно
		QueuedConnection = 2,			// Сигнал в очередь
		BlockingQueuedConnection = 4,	// Только для разных thred
		UniqueConnection = 0x80,		// Как AutoConnection, но обязательно уникальный
		AutoCompatConnection = 3 		// совместимость с Qt3
	}

	private QtObjH p_QObject; /// Адрес самого объекта из C++ Qt
	private bool  fNoDelete;  /// Если T - не вызывать деструктор
	private void* adrThis;    /// Адрес собственного экземпляра
	
	//int id;

	this() {
		// Для подсчета ссылок создания и удаления
		// allCreate++; balCreate++; id = allCreate;
		// printf("+[%d]-[%d] ", id, balCreate); stdout.flush();

	} /// спец Конструктор, что бы не делать реальный объект из Qt при наследовании
	~this() {
		// Для подсчета ссылок создания и удаления
		// balCreate--;
		// printf("-[%d]-[%d] ", id, balCreate); stdout.flush();
	}
	// Ни чего в голову не лезет ... Нужно сделать объект, записав в него пришедший
	// с наружи указатель. Дабы отличить нужный конструктор, специально делаю
	// этот конструктор "вычурным"
	// this(char ch, void* adr) {
	//	if(ch == '+') setQtObj(cast(QtObjH)adr);
	//}
	void setNoDelete(bool f) { fNoDelete = f; }
	@property bool NoDelete() { return fNoDelete; }
	
	void setQtObj(QtObjH adr) { p_QObject = adr; } /// Заменить указатель в объекте на новый указатель

	@property QtObjH QtObj() {
		return p_QObject;
	} /// Выдать указатель на реальный объект Qt C++
	@property void* aQtObj() {
		return &p_QObject;
	} /// Выдать указатель на p_QObject
	QObject connect(void* obj1, char* ssignal, void* obj2, char* sslot, 
			QObject.ConnectionType type = QObject.ConnectionType.AutoConnection) {
		(cast(t_QObject_connect) pFunQt[27])(obj1, ssignal, obj2, sslot, cast(int)type);
		return this;
	}
	QObject connects(QObject obj1, string ssignal, QObject obj2, string sslot) {
		(cast(t_QObject_connect) pFunQt[27])(
			(cast(QObject)obj1).QtObj, MSS(ssignal, QSIGNAL), 
			(cast(QObject)obj2).QtObj, MSS(sslot, QSLOT), 
		cast(int)QObject.ConnectionType.AutoConnection);
		return this;
	}
	/// Запомнить указатель на собственный экземпляр
	void saveThis(void* adr) {
		adrThis = adr;
	}
	@property void* aThis() {
		return &adrThis;
	} /// Выдать указатель на p_QObject
}
// ================ gSlot ================
/++
gSlot - это набор слотов, хранящих в себе адрес вызываемой функции из D.
<br>В D нет возможности создать слот, по этому в QtE.dll создан класс, который есть набор слотов
с разными типами вызовов функции на D. Без аргументов, с одним аргументом с двумя и т.д.
для реакции на события.
gSlot - is a set of the slots storing in the address of called function from D.
In D there is no possibility to create the slot, on it in QtE.dll the class which
set of slots with different types of calls of function on D is is created.
Without arguments, with one argument with two etc.
"SlotN()" --> call(n) где n есть запомненный параметр (n save parametr)
"Slot_Bool(bool b)" --> call(b) где b есть параметрр сигнала (b signal parametr)
"Slot_Int(int i)" --> call(i) где i есть параметрр сигнала (i signal parametr)

Example:
connect(xxx, "send(n)", QSlot, "Slot_Int(int)"); for integet argument signal
connect(xxx, "send(b)", QSlot, "Slot_Bool(bool)"); for bool argument signal
+/
class QSlot : QObject {
	this() { setQtObj((cast(t_qp__qp)pFunQt[24])(null));
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[26])(QtObj); setQtObj(null); }
	} /// Деструктор
	this(void* adr, int n = 0) {
		setQtObj((cast(t_qp__qp)pFunQt[24])(null));
		(cast(t_v__qp_qp_i)pFunQt[25])(QtObj, cast(QtObjH)adr, n);
	} /// Установить слот с параметром
	
	// Эксперементаьный, попытка вызвать метод, не используя Extern "C"
	this(void* adr, void* adrThis, int n = 0) {
		setQtObj((cast(t_qp__qp)pFunQt[24])(null));
		(cast(t_v__qp_qp_qp_i)pFunQt[81])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis, n);
	} /// Установить слот с параметром

	
	// При установке setSlotN устанавливается адрес callback и параметр n
	// который будет возвращен при срабатывании слота и позволит идентифицировать того, кто
	// вызвал callback
	// At installation setSlotN callback address and parametre n which
	// is established will be returned at operation of the slot and will
	// allow to identify the one who has called callback
	QSlot setSlotN(void* adr, int n = 0) {
		(cast(t_v__qp_qp_i)pFunQt[25])(QtObj, cast(QtObjH)adr, n); return this;
	} /// Установить слот с параметром
	
	
	
/* 	
	void emitSignal0() {
		(cast(t_eSlot_setSignal0) pFunQt[25])(p_QObject);
	} /// Послать сигнал "Signal0()"без аргументов
 */
}

// ================ QPalette ================
/++
QPalette - Палитры цветов
+/
class QPalette : QObject {

	enum ColorGroup {
		Active,
		Disabled,
		Inactive,
		NColorGroups,
		Current,
		All,
		Normal = Active
	}

	enum ColorRole {
		WindowText,
		Button,
		Light,
		Midlight,
		Dark,
		Mid,
		Text,
		BrightText,
		ButtonText,
		Base,
		Window,
		Shadow,
		Highlight,
		HighlightedText,
		Link,
		LinkVisited, // ### Qt 5: remove
		AlternateBase,
		NoRole, // ### Qt 5: value should be 0 or -1
		ToolTipBase,
		ToolTipText,
		NColorRoles = ToolTipText + 1,
		Foreground = WindowText,
		Background = Window // ### Qt 5: remove
	}
	
	this() {
		setQtObj((cast(t_qp__v) pFunQt[16])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[17])(QtObj); setQtObj(null); }
	} /// Деструктор
}

// ================ QColor ================
/++
QColor - Цвет
+/
class QColor : QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[13])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[14])(QtObj); setQtObj(null); }
	} /// Деструктор
	void setRgb(int r, int g, int b, int a = 255) {
		(cast(t_v__qp_i_i_i_i) pFunQt[15])(QtObj, r, g, b, a);
	} /// Sets the RGB value to r, g, b and the alpha value to a. All the values must be in the range 0-255.
}
// ================ QBrush ================
/++
QBrush - Оформление
+/
class QBrush : QObject {

	enum BrushStyle {
		NoBrush	=		0,			// No brush pattern.
		SolidPattern =	1,			// Однообразный
		Dense1Pattern =	2,			// Исключительно плотный
		Dense2Pattern =	3,			// Довольно плотный
		Dense3Pattern =	4,			// Somewhat dense brush pattern.
		Dense4Pattern =	5,			// Half dense brush pattern.
		Dense5Pattern =	6,			// Somewhat sparse brush pattern.
		Dense6Pattern =	7,			// Very sparse brush pattern.
		Dense7Pattern =	8,			// Extremely sparse brush pattern.
		HorPattern	=	9,			// Горизонтальная штриховка
		VerPattern =	10,			// Вертикальная штриховка
		CrossPattern =	11,			// Сетка
		BDiagPattern =	12,			// Backward diagonal lines.
		FDiagPattern =	13,			// Forward diagonal lines.
		DiagCrossPattern =	14,		// Crossing diagonal lines.
		LinearGradientPattern =	15,	// Linear gradient (set using a dedicated QBrush constructor).
		ConicalGradientPattern=	17,	// Conical gradient (set using a dedicated QBrush constructor).
		RadialGradientPattern=	16,	// Radial gradient (set using a dedicated QBrush constructor).
		TexturePattern =24			// Custom pattern (see QBrush::setTexture()).
	}

	this() {
		setQtObj((cast(t_qp__v) pFunQt[177])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[178])(QtObj); setQtObj(null); }
	} /// Деструктор
	QBrush setColor(QColor color) {
		(cast(t_v__qp_qp) pFunQt[179])(QtObj, color.QtObj);
		return this;
	}
	QBrush setStyle(BrushStyle style = BrushStyle.SolidPattern) {
		(cast(t_v__qp_i) pFunQt[181])(QtObj, style);
		return this;
	}
}

/* 	//  ------- QBrush -------
	funQt(177, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_create1",				showError);
	funQt(178, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_delete",				showError);
	funQt(179, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_setColor",				showError);
 */



// ================ QPaintDevice ================
class QPaintDevice: QObject  {
	this(){}
}

// ================ gWidget ================
/++
	QWidget (Окно), но немного модифицированный в QtE.DLL. 
	<br>Хранит в себе ссылку на реальный С++ класс gWidget из QtE.dll
	<br>Добавлены свойства хранящие адреса для вызова обратных функций
	для реакции на события.
+/		
class QWidget: QPaintDevice {
	enum PolicyFlag {
		GrowFlag = 1,
		ExpandFlag = 2,
		ShrinkFlag = 4,
		IgnoreFlag = 8
	}
	enum Policy {
		Fixed = 0,
		Minimum = PolicyFlag.GrowFlag,
		Maximum = PolicyFlag.ShrinkFlag,
		Preferred = PolicyFlag.GrowFlag | PolicyFlag.ShrinkFlag,
		MinimumExpanding = PolicyFlag.GrowFlag | PolicyFlag.ExpandFlag,
		Expanding = PolicyFlag.GrowFlag | PolicyFlag.ShrinkFlag | PolicyFlag.ExpandFlag,
		Ignored = PolicyFlag.ShrinkFlag | PolicyFlag.GrowFlag | PolicyFlag.IgnoreFlag
	}

	// Жуткое откровение dmd. Оказывается, выходя за границы блока объект
	// не разрушается, а продолжает существовать, по GC его не прикончит.
	// В связи с этим надо вызывать ~this() если надо явно разрушить объект.
	
	// Qt - тоже ещё тот "подарок". При указании родителя (того самого parent)
	// происходит связывание в дерево. При удалении родительского объекта Qt
	// удаляются каскадно все вложенные в него подобъекты. Однако dmd об этом
	// ни чего не знает. По этому пришлось вставить fNoDelete, который надо
	// установить в T если объект подвергся вставке и значит будет удален каскадно. 
	this(){}
	~this() {
		if(!fNoDelete && (QtObj != null)) { 
			// printf("+[%d]-[%d]-QW ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[7])(QtObj); setQtObj(null); 
			// printf("-[%d]-[%d]-QW ", id, balCreate); stdout.flush();
		}
	}

	
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(null, cast(int)fl));
		}
	} /// QWidget::QWidget(QWidget * parent = 0, Qt::WindowFlags f = 0)
	bool isVisible() {
		return (cast(t_bool__vp)pFunQt[12])(QtObj);
	} /// QWidget::isVisible();
	QWidget setVisible(bool f) {					// Скрыть, Показать виджет
		(cast(t_v__qp_bool)pFunQt[6])(QtObj, f); return this;
	} /// On/Off - это реальный setVisible from QtWidget.dll
	//QWidget show() { setVisible(true); return this; } /// Показать виджет
	//QWidget hide() { setVisible(false); return this; } /// Скрыть виджет
	QWidget setWindowTitle(QString qstr) { // Установить заголовок окна
		(cast(t_v__qp_qp) pFunQt[11])(QtObj, qstr.QtObj); return this; 
	} /// Установить заголовок окна
	QWidget setWindowTitle(T)(T str) {
		return setWindowTitle(new QString(to!string(str)));
	} /// Установить текст Заголовка
	QWidget setStyleSheet(QString str) {
		(cast(t_v__qp_qp)pFunQt[30])(QtObj, str.QtObj); return this; 
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setStyleSheet(T)(T str) {
		(cast(t_v__qp_qp)pFunQt[30])(QtObj, (new QString(to!string(str))).QtObj); return this; 
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setToolTip(QString str) {
		(cast(t_v__qp_qp)pFunQt[33])(QtObj, str.QtObj); return this; 
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setToolTip(T)(T str) {
		(cast(t_v__qp_qp)pFunQt[33])(QtObj, (new QString(to!string(str))).QtObj); return this; 
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setMinimumSize(int w, int h) {
		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, true, w, h); return this; 
	} /// Минимальный размер в лайоутах
	QWidget setMaximumSize(int w, int h) {
		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, false, w, h); return this; 
	} /// Максимальный размер в лайоутах
	QWidget setEnabled(bool fl) {
		(cast(t_v__qp_bool) pFunQt[32])(QtObj, fl); return this; 
	} /// Доступен или нет
	QWidget setLayout(QBoxLayout layout) {
		layout.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
		(cast(t_v__qp_qp) pFunQt[40])(QtObj, layout.QtObj); return this; 
	} /// Вставить в виджет выравниватель
/++ Установить обработчик на событие ResizeWidget. Здесь <u>adr</u> - адрес на функцию D
+ обрабатывающую событие.  Обработчик получает аргумент. См. док. Qt
+ Пример:
	<code>
	+ <br>. . .
	+ <br>void ОбработкаСобытия(void* adrQResizeEvent) {
		+ <br>    writeln("Изменен размер виджета");
		+ <br>
	}
	+  <br>. . .
	+  <br>gWidget w = new gWidget(null, 0);
	w.setOnClick(&ОбработкаСобытия);
	+  <br>. . .
	+ </code>
+/
	QWidget  setResizeEvent(void* adr) { 
		(cast(t_v__qp_vp) pFunQt[52])(QtObj, adr); 
		return this; 
	} /// Установить обработчик на событие ResizeWidget
	
	QWidget setKeyReleaseEvent(void* adr, void* adrThis = null) {
		(cast(t_v__qp_qp_qp) pFunQt[225])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); 
		return this; 
	}

	QWidget setKeyPressEvent(void* adr, void* adrThis = null) {
		//(cast(t_v__qp_qp_qp) pFunQt[80])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); 
		return this; 
		// (cast(t_v__qp_qp) pFunQt[49])(QtObj, cast(QtObjH)adr); return this; 
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setPaintEvent(void* adr, void* adrThis = null) { 
		(cast(t_v__qp_qp_qp) pFunQt[50])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this; 
	} /// Установить обработчик на событие PaintEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setCloseEvent(void* adr, void* adrThis = null) { 
		(cast(t_v__qp_qp_qp) pFunQt[51])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this; 
	} /// Установить обработчик на событие CloseEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget setSizePolicy(int w, int h) { 
		(cast(t_v__qp_i_i) pFunQt[78])(QtObj, w, h); return this; 
	} /// Установить обработчик на событие CloseEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget setMaximumWidth(int w) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 0, w); return this; 
	} /// setMaximumWidth();
	QWidget setMinimumWidth(int w) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 1, w); return this; 
	} /// setMinimumWidth();
	QWidget setFixedWidth(int w) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 5, w); return this; 
	} /// setFixedWidth();
	QWidget setMaximumHeight(int h) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 2, h); return this; 
	} /// setMaximumHeight();
	QWidget setMinimumHeight(int h) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 3, h); return this; 
	} /// setMinimumHeight();
	QWidget setFixedHeight(int h) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 4, h); return this; 
	} /// setFixedHeight();
	QWidget setToolTipDuration(int msek) { 
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 6, msek); return this; 
	} /// Время показа в МилиСекундах
	QWidget setFocus() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 0); return this; } /// Установить фокус
	QWidget close()    { (cast(t_v__qp_i) pFunQt[87])(QtObj, 1); return this; } /// Закрыть окно
	QWidget hide() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 2); return this; 	}
	QWidget show() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 3); return this; 	}
	QWidget showFullScreen()  { (cast(t_v__qp_i) pFunQt[87])(QtObj, 4); return this; 	}
	QWidget showMaximized() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 5); return this; 	}
	QWidget showMinimized() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 6); return this; 	}
	QWidget showNormal() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 7); return this; } ///
	QWidget update() { 	(cast(t_v__qp_i) pFunQt[87])(QtObj, 8); return this;  } ///
	QWidget raise() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 9); return this; 	} /// Показать окно на вершине
	QWidget lower() { (cast(t_v__qp_i) pFunQt[87])(QtObj, 10); return this; 	} /// Скрыть в стеке

	QWidget move(int x, int y) { 
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 0, x, y); return this; 
	} /// This property holds the size of the widget excluding any window frame
	QWidget resize(int w, int h) {
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 1, w, h); return this; 
	} /// This property holds the size of the widget excluding any window frame
	QWidget setFont(QFont font) {
		(cast(t_v__qp_qp) pFunQt[131])(QtObj, font.QtObj); return this; 
	}
	void* winid() {
		return (cast(t_vp__qp) pFunQt[148])(QtObj); 
	}
	int x() {
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 0); 
	}
	int y() {
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 1); 
	}
	int width() {
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 2); 
	}
	int height() {
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 3); 
	}
	bool hasFocus() { //-> Виджет имеет фокус
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 0); 
	}
	
}
// ============ QAbstractButton =======================================
class QAbstractButton : QWidget {
	this() {  }
	this(QWidget parent) {	 }
	~this() { if (QtObj) setQtObj(null); }
	
	QAbstractButton setText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[28])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QAbstractButton setText(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[28])(QtObj, (new QString(to!string(str))).QtObj);
		return this;
	} /// Установить текст на кнопке
	T text(T: QString)() {
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[29])(QtObj, qs.QtObj);
		return qs;
	}
	T text(T)() { return to!T(text!QString().String);
	}
	QAbstractButton setAutoExclusive(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 0); return this;
	} /// 
	QAbstractButton setAutoRepeat(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 1); return this;
	} /// 
	QAbstractButton setCheckable(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 2); return this;
	} /// 
	QAbstractButton setDown(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 3); return this;
	} /// 
	QAbstractButton setChecked(bool pr) { //-> Включить кнопку
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 4); return this;
	} /// 
	QAbstractButton setIcon(QIcon ik) {
		(cast(t_v__qp_qp) pFunQt[211])(QtObj, ik.QtObj); return this;
	} /// 
	bool autoExclusive() { //-> T - Эксклюзивное использование
		return (cast(t_b__qp_i) pFunQt[224])(QtObj, 0);
	}
	bool autoRepeat() { //-> T - Повторяющеяся
		return (cast(t_b__qp_i) pFunQt[224])(QtObj, 1);
	}
	bool isCheckable() { //-> T - Может нажиматься
		return (cast(t_b__qp_i) pFunQt[224])(QtObj, 2);
	}
	bool isChecked() { //-> T - Нажата
		return (cast(t_b__qp_i) pFunQt[224])(QtObj, 3);
	}
	bool isDown() { //-> T - Нажата
		return (cast(t_b__qp_i) pFunQt[224])(QtObj, 4);
	}
	
	
	
	/*
	bool isChecked() {
		return (cast(t_b__vp) pFunQt[265])(QtObj);
	} /// T = нажата
*/	
}

// ================ QPushButton ================
/++
QPushButton (Нажимаемая кнопка), но немного модифицированный в QtE.DLL.
<br>Хранит в себе ссылку на реальный С++ класс QPushButtong из QtGui.dll
<br>Добавлены свойства хранящие адреса для вызова обратных функций
для реакции на события.
+/
class QPushButton : QAbstractButton {
	this(){}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(null, str.QtObj));
		}
	} /// Создать кнопку.
    ~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[23])(QtObj); setQtObj(null); }
		// write("B- "); stdout.flush();
    }
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(parent.QtObj, (new QString(to!string(str))).QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(null, (new QString(to!string(str))).QtObj));
		}
	}
	QPushButton setAutoDefault(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 0); return this;
	} /// 
	QPushButton setDefault(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 1); return this;
	} /// 
	QPushButton setFlat(bool pr) {
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 2); return this;
	} /// 
	
}

// ================ QApplication ================
/++
Класс приложения. <b>Внимание:</b>
+/
private struct stQApplication {
	void* rref;
	int   alloc;
	int   size;
	char* data;      // Вот собственно за чем нам это нужно, указатель на массив байтов
	// char  array[1];
}
class QApplication : QObject {
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
	} /// QApplication::QApplication(argc, argv, param);
	~this() {
		if(!fNoDelete) { 
			// printf("+[%d]-[%d]-app ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[3])(QtObj); setQtObj(null); 
			// printf("-[%d]-[%d]-app ", id, balCreate); stdout.flush();
		}
	} ///  QApplication::~QApplication();
	int exec() {
		return (cast(t_i__qp) pFunQt[1])(QtObj);
	} /// QApplication::exec()
	void aboutQt() {
		(cast(t_v__qp) pFunQt[2])(QtObj);
	} /// QApplication::aboutQt()
	int sizeOfQtObj() {
		return (cast(t_i__vp) pFunQt[4])(QtObj);
	} /// Размер объекта QApplicatin. Size of QApplicatin
	T appDirPath(T)() {
		QString qs = new QString();
		(cast(t_v__qp_qp)pFunQt[20])(QtObj, qs.QtObj);
		return qs;
	}
	T appDirPath(T)() { return to!T((appDirPath!QString()).String);
	}
	T appFilePath(T: QString)() {
		QString qs = new QString();
		(cast(t_v__qp_qp)pFunQt[21])(QtObj, qs.QtObj);
		return qs;
	}
	T appFilePath(T)() { return to!T((appFilePath!QString()).String);
	}
}

// ================ QString ================
class QString: QObject {
	import std.utf:  toUTF16, toUTF8;

	this() {
		setQtObj((cast(t_qp__v)pFunQt[8])());
	} /// Конструктор пустого QString
	this(T)(T s) {
		wstring ps = toUTF16(to!string(s));
		setQtObj((cast(t_qp__qp_i)pFunQt[9])(cast(QtObjH)ps.ptr, cast(int)ps.length));
	} /// Конструктор где s - Utf-8. Пример: QString qs = new QString("Привет!");
	this(QtObjH adr) { setQtObj(adr);
	} /// Изготовить QString из пришедшего из вне указателя на C++ QString
	~this() {
		if(!fNoDelete) { 
			// write("-[1]-Qs = ", QtObj); stdout.flush();
			(cast(t_v__qp) pFunQt[10])(QtObj); setQtObj(null); 
			// writeln("  -[2]-Qs = ", QtObj); stdout.flush();
			
			
			
		}
	}
	int size() { return (cast(t_i__qp) pFunQt[19])(QtObj);
	} /// Размер в UNICODE символах
	ubyte* data() { return (cast(t_ub__qp) pFunQt[18])(QtObj);
	} /// Указатель на UNICODE
	string toUtf8() {
		wchar[] wss; wchar* wc = cast(wchar*) data();
		for (int i; i != size(); i++) wss ~= *(wc + i);
		return toUTF8(wss);
	} /// Конвертировать внутреннее представление в wstring
	@property string String() { return toUtf8();
	} /// return string D from QString
}
// ================ QBoxLayout ================
/++
QBoxLayout - это класс выравнивателей. Они управляют размещением
элементов на форме.
+/
class QBoxLayout : QObject {
	enum Direction {
		LeftToRight = 0,
		RightToLeft = 1,
		TopToBottom = 2,
		BottomToTop = 3
	} /// enum Direction { LeftToRight, RightToLeft, TopToBottom, BottomToTop }
	this() { }
	this(QWidget parent, QBoxLayout.Direction dir = QBoxLayout.Direction.TopToBottom) {
		// super();
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[34])(parent.QtObj, dir));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[34])(null, dir));
		}
	} /// Создаёт выравниватель, типа dir и вставляет в parent
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[37])(QtObj); setQtObj(null); }
	}
	QBoxLayout addWidget(QWidget wd, int stretch = 0, QtE.AlignmentFlag alignment = QtE.AlignmentFlag.AlignExpanding) {
		wd.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
		(cast(t_v__qp_qp_i_i) pFunQt[38])(QtObj, wd.QtObj, cast(int)stretch, cast(int)alignment);
		return this;
	} /// Добавить виджет в выравниватель
	QBoxLayout addLayout(QBoxLayout layout) {
		layout.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
		(cast(t_v__qp_qp) pFunQt[39])(QtObj, layout.QtObj);
		return this;
	} /// Добавить выравниватель в выравниватель
	QBoxLayout setSpasing(int spasing) {
		(cast(t_v__qp_i) pFunQt[74])(QtObj, spasing); return this;
	} /// Это расстояние между элементами в выравнивателе, например расстояние меж кнопками
	int spasing() {
		return (cast(t_i__qp) pFunQt[75])(QtObj);
	} /// 
	QBoxLayout setMargin(int spasing) {
		(cast(t_v__qp_i) pFunQt[76])(QtObj, spasing); return this;
	} /// Это расстояние вокруг всех элементов данного выравнивателя
	int margin() {
		return (cast(t_i__qp) pFunQt[77])(QtObj);
	} /// 
	
/* 	funQt(74, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_setSpasing",   showError);
	funQt(75, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBoxLayout_spasing",      showError);
 */	
	
	
}
class QVBoxLayout : QBoxLayout {
	this() {
		setQtObj((cast(t_qp__v)pFunQt[35])());
	}
}
class QHBoxLayout : QBoxLayout {
	this() {
		setQtObj((cast(t_qp__v)pFunQt[36])());
	}
}
// ================ QFrame ================
class QFrame : QWidget {
	enum Shape {
		NoFrame = 0, // no frame
		Box = 0x0001, // rectangular box
		Panel = 0x0002, // rectangular panel
		WinPanel = 0x0003, // rectangular panel (Windows)
		HLine = 0x0004, // horizontal line
		VLine = 0x0005, // vertical line
		StyledPanel = 0x0006 // rectangular panel depending on the GUI style
	}
	enum Shadow {
		Plain = 0x0010, // plain line
		Raised = 0x0020, // raised shadow effect
		Sunken = 0x0030 // sunken shadow effect
	}
	this() {	}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[42])(QtObj); setQtObj(null); }
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[41])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[41])(null, fl));
		}
	} /// Конструктор
	QFrame setFrameShape(Shape sh) {
		(cast(t_v__qp_i) pFunQt[43])(QtObj, sh);
		return this;
	}
	QFrame setFrameShadow(Shadow sh) {
		(cast(t_v__qp_i) pFunQt[44])(QtObj, sh);
		return this;
	}
	QFrame setLineWidth(int sh) {
		if (sh > 3) sh = 3; (cast(t_v__qp_i) pFunQt[45])(QtObj, sh);
		return this;
	} /// Установить толщину окантовки в пикселах от 0 до 3
}
// ============ QLabel =======================================
class QLabel : QFrame {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[47])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[46])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[46])(null, fl));
		}
	} /// Конструктор
	QWidget setText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QWidget setText(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, (new QString(to!string(str))).QtObj);
		return this;
	} /// Установить текст на кнопке
}
// ============ QSize =======================================
class QSize : QObject {
	this(int width, int heigth) {
		setQtObj((cast(t_qp__i_i) pFunQt[56])(width, heigth));
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[57])(QtObj); setQtObj(null); }
	}
	@property int width() {
		return (cast(t_i__qp) pFunQt[58])(QtObj);
	} /// QSize::wieth();
	@property int heigth() {
		return (cast(t_i__qp) pFunQt[59])(QtObj);
	} /// QSize::heigth();
	QSize setWidth(int width) {
		(cast(t_v__qp_i) pFunQt[60])(QtObj, width); return this;
	} /// QSize::setWidth();
	QSize setHeigth(int heigth) {
		(cast(t_v__qp_i) pFunQt[61])(QtObj, width); return this;
	} /// QSize::setHeigth();
}
// ============ QPainter =======================================
class QPainter : QObject {
	this() {	}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QPainter пришедшее из Qt
	~this() {
	}
	QPainter drawPoint(int x, int y) {
		(cast(t_v__qp_i_i_i) pFunQt[188])(QtObj, x, y, 0); return this;
	}
	QPainter setBrushOrigin(int x, int y) {
		(cast(t_v__qp_i_i_i) pFunQt[188])(QtObj, x, y, 1); return this;
	}
	QPainter drawLine(int x1, int y1, int x2, int y2) {
		(cast(t_v__qp_i_i_i_i) pFunQt[189])(QtObj, x1, y1, x2, y2); return this;
	}
	
	QPainter drawRect(int x1, int y1, int w, int h) { //-> Четырехугольник
		(cast(t_v__qp_i_i_i_i) pFunQt[243])(QtObj, x1, y1, w, h); return this;
	}
	QPainter drawRect(QRect qr) { //-> Четырехугольник
		(cast(t_v__qp_qp) pFunQt[244])(QtObj, qr.QtObj); return this;
	}
	QPainter fillRect(QRect qr, QColor cl) { //-> Четырехугольник заполнить цветом
		(cast(t_v__qp_qp_qp) pFunQt[245])(QtObj, qr.QtObj, cl.QtObj); return this;
	}
	QPainter fillRect(QRect qr, QtE.GlobalColor gc) { //-> Четырехугольник заполнить цветом
		(cast(t_v__qp_qp_i) pFunQt[246])(QtObj, qr.QtObj, gc); return this;
	}
	
	
	
	QPainter setBrush(QBrush qb) {
		(cast(t_v__qp_qp_i) pFunQt[190])(QtObj, qb.QtObj, 0); return this;
	}
	QPainter setPen(QPen qp) {
		(cast(t_v__qp_qp_i) pFunQt[190])(QtObj, qp.QtObj, 1); return this;
	}
	QPainter setText(int x, int y, QString qs) {
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, qs.QtObj, x, y); return this;
	}
	QPainter setText(int x, int y, string s) {
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, (new QString(s)).QtObj, x, y); return this;
	}
	bool end() {
		return (cast(t_b__qp) pFunQt[197])(QtObj);
	}
/* 	@property int type() {
		return (cast(t_i__qp) pFunQt[53])(QtObj);
	} /// QPainter::type(); Вернуть тип события
	void ignore() {
		(cast(t_v__qp_i) pFunQt[157])(QtObj, 0);
	} /// Игнорировать событие
	void accept() {
		(cast(t_v__qp_i) pFunQt[157])(QtObj, 1);
	} /// Игнорировать событие
 */
}

// ============ QEvent =======================================
class QEvent : QObject {
	this() {	}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	@property int type() {
		return (cast(t_i__qp) pFunQt[53])(QtObj);
	} /// QEvent::type(); Вернуть тип события
	void ignore() {
		(cast(t_v__qp_i) pFunQt[157])(QtObj, 0);
	} /// Игнорировать событие
	void accept() {
		(cast(t_v__qp_i) pFunQt[157])(QtObj, 1);
	} /// Игнорировать событие
}
// ============ QResizeEvent =======================================
/*
// Test event события QResizeEvent
extern (C) void onQResizeEvent(void* ev) {
	// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
	// Catch event from Qt and save it in my class D
	QResizeEvent qe = new QResizeEvent('+', ev); 
	// 2 - Выдать тип события. Show type event
	writeln(toCON("Событие: ширина: "), qe.size().width, toCON("  высота: "), qe.size().heigth);
}
*/
class QResizeEvent : QEvent {
	this() {}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	QSize size() {
		return new QSize('+', (cast(t_qp__qp)pFunQt[54])(QtObj));
	} /// QResizeEvent::size();
	QSize oldSize() {
		return new QSize('+', (cast(t_qp__qp)pFunQt[55])(QtObj));
	} /// QResizeEvent::oldSize();
}
// ============ QKeyEvent =======================================
class QKeyEvent : QEvent {
	this() {}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	@property uint key() {
		return cast(uint)(cast(t_qp__qp)pFunQt[62])(QtObj);
	} /// QKeyEvent::key();
	@property uint count() {
		return cast(uint)(cast(t_qp__qp)pFunQt[63])(QtObj);
	} /// QKeyEvent::counte();
}
// ================ QAbstractScrollArea ================
class QAbstractScrollArea : QFrame {
	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[65])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[64])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[64])(null));
		}
	} /// Конструктор
}
// ================ QPlainTextEdit ================
/++
Чистый QPlainTextEdit (ТекстовыйРедактор).
+/

class QPlainTextEdit : QAbstractScrollArea {
	this(){}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[67])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[66])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[66])(null));
		}
	} /// Конструктор

	override QPlainTextEdit setKeyPressEvent(void* adr, void* adrThis = null) {
		(cast(t_v__qp_qp_qp) pFunQt[80])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this; 
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	
	QPlainTextEdit appendPlainText(T: QString)(T str) { //-> Добавить текст в конец
		(cast(t_v__qp_qp) pFunQt[68])(QtObj, str.QtObj); return this;
	} /// Добавать текст в конец
	QPlainTextEdit appendPlainText(T)(T str) { //-> Добавить текст в конец
		(cast(t_v__qp_qp) pFunQt[68])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Добавать текст в конец
	QPlainTextEdit appendHtml(T: QString)(T str) { //-> Добавать html в конец
		(cast(t_v__qp_qp) pFunQt[69])(QtObj, str.QtObj); return this;
	} /// Добавать html в конец
	QPlainTextEdit appendHtml(T)(T str) { //-> Добавать html в конец
		(cast(t_v__qp_qp) pFunQt[69])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Добавать html в конец
	QPlainTextEdit setPlainText(T: QString)(T str) {  //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[70])(QtObj, str.QtObj); return this;
	} /// Удалить всё и вставить с начала
	QPlainTextEdit setPlainText(T)(T str) { //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[70])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Удалить всё и вставить с начала
	QPlainTextEdit insertPlainText(T: QString)(T str) { //-> Вставить сразу за курсором
		(cast(t_v__qp_qp) pFunQt[71])(QtObj, str.QtObj); return this;
	} /// Вставить сразу за курсором
	QPlainTextEdit insertPlainText(T)(T str) { //-> Вставить сразу за курсором
		(cast(t_v__qp_qp) pFunQt[71])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Вставить сразу за курсором
	QPlainTextEdit cut() { //-> Вырезать кусок
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 0); return this;
	} /// cut()
	QPlainTextEdit clear() { //-> Очистить всё
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 1); return this;
	} /// clear()
	QPlainTextEdit paste() { //-> Вставить из буфера
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 2); return this;
	} /// paste()
	QPlainTextEdit copy() { //-> Скопировать в буфер
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 3); return this;
	} /// copy()
	QPlainTextEdit selectAll() {
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 4); return this;
	} /// selectAll()
	QPlainTextEdit selectionChanged() {
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 5); return this;
	} /// selectionChanged()
	QPlainTextEdit centerCursor() {
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 6); return this;
	} /// centerCursor()
	QPlainTextEdit undo() {
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 7); return this;
	} /// undo()
	QPlainTextEdit redo() {
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 8); return this;
	} /// redo()
	T toPlainText(T: QString)() {
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[73])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T toPlainText(T)() { return to!T(toPlainText!QString().String);
	} /// Выдать всё содержимое в String
	void* document() { //-> Вернуть указатель на QTextDocument
		return (cast(t_qp__qp) pFunQt[226])(QtObj);
	}
	QTextCursor textCursor(QTextCursor tk) {
		(cast(t_v__qp_qp) pFunQt[230])(QtObj, tk.QtObj);
		return tk;
	}
	QPlainTextEdit setTextCursor(QTextCursor tk) {
		(cast(t_v__qp_qp) pFunQt[253])(QtObj, tk.QtObj);
		return this;
	}
	QRect cursorRect(QRect tk) {
		(cast(t_v__qp_qp) pFunQt[235])(QtObj, tk.QtObj);
		return tk;
	}
	QPlainTextEdit setTabStopWidth(int width) { //-> Размер табуляции в пикселах
		(cast(t_v__qp_i) pFunQt[236])(QtObj, width); return this;
	}
}
// ================ QLineEdit ================
/++
QLineEdit (Строка ввода с редактором), но немного модифицированный в QtE.DLL.
<br>Хранит в себе ссылку на реальный С++ класс QLineEdit из QtGui.dll
<br>Добавлены свойства хранящие адреса для вызова обратных функций
для реакции на события.
+/
class QLineEdit : QWidget {
	enum EchoMode {
		Normal = 0, 				// Показывать символы при вводе. По умолчанию
		NoEcho = 1, 				// Ни чего не показывать, что бы длинна пароля была не понятной
		Password = 2, 				// Звездочки вместо символов
		PasswordEchoOnEdit = 3 		// Показывает только один символ, а остальные скрыты
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		writeln("");
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if(parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			p_QObject = (cast(t_qp__qp) pFunQt[82])(parent.QtObj);
		} else {
			p_QObject = (cast(t_qp__qp) pFunQt[82])(null);
		}
	} /// Создать LineEdit.
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[83])(QtObj); setQtObj(null); }
	}
	QLineEdit setText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QLineEdit setText(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, (new QString(to!string(str))).QtObj);
		return this;
	} /// Установить текст на кнопке
	QLineEdit clear() {
		(cast(t_v__qp) pFunQt[85])(QtObj);
		return this;
	} /// Очистить строку
	T text(T: QString)() {
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[86])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	override QLineEdit setKeyPressEvent(void* adr, void* adrThis = null) {
		(cast(t_v__qp_qp_qp) pFunQt[158])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this; 
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	
}
// ===================== QMainWindow =====================
	/++
QMainWindow - основное окно приложения
+/
class QMainWindow : QWidget {
	// this(){ super(); }
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[89])(QtObj); setQtObj(null); }
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i)pFunQt[88])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[88])(null, cast(int)fl));
		}
	} /// QMainWindow::QMainWindow(QWidget * parent = 0, Qt::WindowFlags f = 0)
	QMainWindow setCentralWidget(QWidget wd) {
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 0);
		return this;
	} /// 
	QMainWindow setStatusBar(QStatusBar wd) {
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 2);
		 return this;
	} /// 
	QMainWindow setMenuBar(QMenuBar wd) {
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 1);
		 return this;
	} /// 
	QMainWindow addToolBar(QToolBar wd) {
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 3);
		 return this;
	} /// 
	QMainWindow setToolBar(QToolBar wd) {
		addToolBar(wd);
		return this;
	} /// 
	QMainWindow addToolBar(QToolBar.ToolBarArea st, QToolBar wd) {
		(cast(t_v__qp_qp_i) pFunQt[126])(QtObj, wd.QtObj, st);
		 return this;
	} /// добавить ToolBar используя рамещение внизу,вверху т т.д.

}
// ================ QStatusBar ================
/++
QStatusBar - строка сообщений
+/
class QStatusBar : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[92])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		// super(); 
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp)pFunQt[91])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[91])(null));
		}
	} /// QStatusBar::QStatusBar(QWidget * parent)
	QStatusBar showMessage(T: QString)(T str, int timeout = 0) {
		(cast(t_v__qp_qp_i) pFunQt[93])(QtObj, str.QtObj, timeout);
		return this;
	} /// Установить текст на кнопке
	QStatusBar showMessage(T)(T str, int timeout = 0) {
		showMessage!QString(new QString(to!string(str)), timeout);
		return this;
	} /// Установить текст на кнопке
}

// ================ QAction ================
/++
QAction - это класс выполнителей (действий). Объеденяют в себе
различные формы вызовов:
из меню, из горячих кнопок, их панели с кнопками
и т.д. Реально представляет собой строку меню в вертикальном боксе.
+/
class QAction : QObject {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[96])(QtObj); setQtObj(null); }
	}
	// Эксперементаьный, попытка вызвать метод, не используя Extern "C"
	// Любой слот всегда! передаёт в обработчик D два параметра,
	// 1 - Адрес объекта и 2 - N установленный при инициадизации

	// Специализированные слоты для обработки сообщений с параметрами
	// всегда передают Адрес и N (см выше) и дальше сами параметры
	this(QWidget parent, void* adr, void* adrThis, int n = 0) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp)pFunQt[95])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[95])(null));
		}
		(cast(t_v__qp_qp_qp_i)pFunQt[98])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis, n);
	} /// Установить слот с параметром

// ----------------------------------------------------
	QAction setText(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QAction setText(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, (new QString(to!string(str))).QtObj, 0);
		return this;
	} /// Установить текст
	QAction setToolTip(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QAction setToolTip(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, (new QString(to!string(str))).QtObj, 1);
		return this;
	} /// Установить текст
	QAction setHotKey(QtE.Key key) {
		(cast(t_v__qp_i) pFunQt[105])(p_QObject, cast(int) key);
		return this;
	} /// Определить горячую кнопку
// ----------------------------------------------------
	QAction setEnabled(bool f) {
		(cast(t_v__qp_bool) pFunQt[109])(QtObj, f);
		return this;
	} /// Включить/выключить пункт меню
 	QAction setIcon(QIcon ico) {
		(cast(t_v__qp_qp) pFunQt[113])(QtObj, ico.QtObj);
		return this;
	} /// Добавить иконку
 	QAction setIcon(string fileIco) {
		QIcon ico = new QIcon(); ico.addFile(fileIco); setIcon(ico);
		return this;
	} /// Добавить иконку используя имя файла и неявное создание
}
// ============ QMenu =======================================
/++
QMenu - колонка меню. Вертикальная.
+/
class QMenu : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[100])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[99])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[99])(null));
		}
	} /// QMenu::QMenu(QWidget* parent)
 	QMenu addAction(QAction act) {
		(cast(t_v__qp_qp) pFunQt[101])(QtObj, act.QtObj);
		return this;
	} /// Вставить вертикальное меню
	QMenu setTitle(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[106])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QMenu setTitle(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[106])(QtObj, (new QString(to!string(str))).QtObj, 1);
		return this;
	} /// Установить текст
	QMenu addSeparator() {
		(cast(t_v__qp) pFunQt[107])(QtObj);
		return this;
	}
	QMenu addMenu(QMenu menu) {
		(cast(t_v__qp_qp) pFunQt[108])(QtObj, menu.QtObj);
		return this;
	}
	
/*	
	void addSeparator() {
		(cast(t_v__vp) pFunQt[85])(p_QObject);
	} /// Добавить сепаратор
	void setTitle(QString str) {
		(cast(t_v__vp_vp) pFunQt[86])(p_QObject, cast(void*) str.QtObj);
	}

	void setTitle(string str) {
		(cast(t_v__vp_vp) pFunQt[86])(QtObj, (new QString(str)).QtObj);
	} /// Установить текст
 */

}

// ============ QMenuBar =======================================
/++
QMenuBar - строка меню самого верхнего уровня. Горизонтальная.
+/
class QMenuBar : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[103])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[102])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[102])(null));
		}
	} /// QMenuBar::QMenuBar(QWidget* parent)
 	QMenuBar addMenu(QMenu mn) {
		(cast(t_v__qp_qp) pFunQt[104])(QtObj, mn.QtObj);
		return this;
	} /// Вставить вертикальное меню
}
// ================ QFont ================
class QFont : QObject {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[128])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[127])());
	}
	QFont setPointSize(int size) {
		(cast(t_v__qp_i) pFunQt[129])(QtObj, size);
		return this;
	} /// Установить размер шрифта в поинтах
	QFont setFamily(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[130])(QtObj, str.QtObj);
		return this;
	} /// Наименование шрифта Например: "True Times"
	QFont setFamily(T)(T str) {
		setFamily((new QString(to!string(str))).QtObj);
		return this;
	} /// Наименование шрифта Например: "True Times"
}

// ================ QIcon ================
class QIcon : QObject {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[111])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[110])());
	}
	QIcon addFile(T: QString)(T str, QSize qs = null) {
		if(qs is null) {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, str.QtObj, null);
		} else {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, str.QtObj, qs.QtObj);
		}
		return this;
	}
	QIcon addFile(T)(T str, QSize qs = null) {
		if(qs is null) {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, (new QString(to!string(str))).QtObj, null);
		} else {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, (new QString(to!string(str))).QtObj, qs.QtObj);
		}
		return this;
	}
}
// ================ QToolBar ================
class QToolBar : QWidget {
	enum ToolButtonStyle {
		ToolButtonIconOnly = 0,				// Only display the icon.
		ToolButtonTextOnly = 1,				// Only display the text.
		ToolButtonTextBesideIcon = 2,		// The text appears beside the icon.
		ToolButtonTextUnderIcon = 3,		// The text appears under the icon.
		ToolButtonFollowStyle = 4			// Follow the style.
	}
	enum ToolBarArea {
		LeftToolBarArea	= 0x1,
		RightToolBarArea = 0x2,
		TopToolBarArea = 0x4,
		BottomToolBarArea = 0x8,
		NoToolBarArea =	0
	}

	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[115])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[114])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[114])(null));
		}
	} /// QToolBar::QToolBar(QWidget* parent)
	QToolBar addAction(QAction ac) {
		(cast(t_v__qp_qp_i) pFunQt[116])(QtObj, ac.QtObj, 0);
		return this;
	} /// Вставить Action
	QToolBar addWidget(QWidget wd) {
		(cast(t_v__qp_qp_i) pFunQt[116])(QtObj, wd.QtObj, 1);
		return this;
	} /// Добавить виджет в QToolBar
	
	QToolBar setToolButtonStyle(QToolBar.ToolButtonStyle st) {
		(cast(t_v__qp_i) pFunQt[125])(QtObj, st);
		return this;
	} /// Установить стиль кнопок в ToolBar
	QToolBar setAllowedAreas(QToolBar.ToolBarArea st) {
		(cast(t_v__qp_i) pFunQt[124])(QtObj, st);
		return this;
	} /// Где возможно размещение ToolBar, а не где он будет размещён
	QToolBar addSeparator() {
		(cast(t_v__qp_i) pFunQt[132])(QtObj, 0);
		return this;
	} /// 
	QToolBar clear() {
		(cast(t_v__qp_i) pFunQt[132])(QtObj, 1);
		return this;
	} /// 
}
// ================ QDialog ================
class QDialog : QWidget {
	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[118])(QtObj); setQtObj(null); }
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[117])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[117])(null, fl));
		}
	} /// Конструктор
	int exec() {
		return (cast(t_i__qp) pFunQt[119])(QtObj);
	} /// Обычный QDialog::exec()
}
// ================ QMessageBox ================
/++
QMessageBox - это стандартный класс сообщений.
+/
class QMessageBox : QDialog {
	enum Icon {
		NoIcon = 0,
		Information = 1,
		Warning = 2,
		Critical = 3,
		Question = 4
	}

	enum ButtonRole {
		// keep this in sync with QDialogButtonBox::ButtonRole
		InvalidRole = -1,
		AcceptRole,
		RejectRole,
		DestructiveRole,
		ActionRole,
		HelpRole,
		YesRole,
		NoRole,
		ResetRole,
		ApplyRole,

		NRoles
	}

	enum StandardButton {
		// keep this in sync with QDialogButtonBox::StandardButton
		NoButton = 0x00000000,
		Ok = 0x00000400,
		Save = 0x00000800,
		SaveAll = 0x00001000,
		Open = 0x00002000,
		Yes = 0x00004000,
		YesToAll = 0x00008000,
		No = 0x00010000,
		NoToAll = 0x00020000,
		Abort = 0x00040000,
		Retry = 0x00080000,
		Ignore = 0x00100000,
		Close = 0x00200000,
		Cancel = 0x00400000,
		Discard = 0x00800000,
		Help = 0x01000000,
		Apply = 0x02000000,
		Reset = 0x04000000,
		RestoreDefaults = 0x08000000,

		FirstButton = Ok, // internal
		LastButton = RestoreDefaults, // internal

		YesAll = YesToAll, // obsolete
		NoAll = NoToAll, // obsolete

		Default = 0x00000100, // obsolete
		Escape = 0x00000200, // obsolete
		FlagMask = 0x00000300, // obsolete
		ButtonMask = ~FlagMask // obsolete
	}

	alias Button = StandardButton;

	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[121])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[120])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[120])(null));
		}
	} /// Конструктор
	QMessageBox setText(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QMessageBox setText(T)(T str) {
		QMessageBox.setText(new QString(to!string(str)));
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T)(T str) {
		QMessageBox.setWindowTitle(new QString(to!string(str)));
		return this;
	} /// Установить текст
	QMessageBox setInformativeText(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 2);
		return this;
	} /// Установить текст
	QMessageBox setInformativeText(T)(T str) {
		QMessageBox.setInformativeText(new QString(to!string(str)));
		return this;
	} /// Установить текст
	QMessageBox setStandardButtons(QMessageBox.StandardButton buttons) {
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 0);
		return this;
	} /// Установить стандартный набор кнопок
	QMessageBox setDefaultButton(QMessageBox.StandardButton buttons) {
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 1);
		return this;
	} /// Установить кнопку по умолчанию
	QMessageBox setEscapeButton(QMessageBox.StandardButton buttons) {
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 2);
		return this;
	} /// Установить кнопку отмены
	QMessageBox setIcon(QMessageBox.Icon icon) {
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)icon, 3);
		return this;
	} /// Установить стандартную иконку из числа QMessage.Icon. (NoIcon, Information, Warning, Critical, Question)
}

// ================ QProgressBar ================
/++
QProgressBar - это ....
+/
class QProgressBar : QWidget {
	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[134])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[133])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[133])(null));
		}
	} /// Конструктор
	QProgressBar setMinimum(int n) {
		(cast(t_v__qp_i_i) pFunQt[135])(QtObj, n, 0); return this;
	} /// Установить нижнию границу
	QProgressBar setMaximum(int n) {
		(cast(t_v__qp_i_i) pFunQt[135])(QtObj, n, 1); return this;
	} /// Установить верхнию границу
	QProgressBar setValue(int n) {
		(cast(t_v__qp_i_i) pFunQt[135])(QtObj, n, 2); return this;
	} /// Установить текущее положение
	
}
// ============ QDate ===============
/*
d		the day as number without a leading zero (1 to 31)
dd		the day as number with a leading zero (01 to 31)
ddd		the abbreviated localized day name (e.g. 'Mon' to 'Sun'). Uses the system locale to localize the name, i.e. QLocale::system().
dddd	the long localized day name (e.g. 'Monday' to 'Sunday'). Uses the system locale to localize the name, i.e. QLocale::system().
M		the month as number without a leading zero (1 to 12)
MM		the month as number with a leading zero (01 to 12)
MMM		the abbreviated localized month name (e.g. 'Jan' to 'Dec'). Uses the system locale to localize the name, i.e. QLocale::system().
MMMM	the long localized month name (e.g. 'January' to 'December'). Uses the system locale to localize the name, i.e. QLocale::system().
yy		the year as two digit number (00 to 99)
yyyy	the year as four digit number. If the year is negative, a minus sign is prepended in addition.
*/
class QDate : QObject {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[137])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[136])());
	}
	QString toQString(QString shabl) {
		QString qs = new QString(); 
		(cast(t_v__qp_qp_qp)pFunQt[140])(QtObj, qs.QtObj, shabl.QtObj); 
		return qs;
	} /// Выдать содержимое в QString
	string toString(T1)(T1 shabl) { 
		QString qs = toQString(new QString(to!string(shabl)));
		return to!string(qs.String);
	} /// Выдать всё содержимое в String
	
}
// ============ QTime ===============
/*
h		the hour without a leading zero (0 to 23 or 1 to 12 if AM/PM display)
hh		the hour with a leading zero (00 to 23 or 01 to 12 if AM/PM display)
H		the hour without a leading zero (0 to 23, even with AM/PM display)
HH		the hour with a leading zero (00 to 23, even with AM/PM display)
m		the minute without a leading zero (0 to 59)
mm		the minute with a leading zero (00 to 59)
s		the second without a leading zero (0 to 59)
ss		the second with a leading zero (00 to 59)
z		the milliseconds without leading zeroes (0 to 999)
zzz		the milliseconds with leading zeroes (000 to 999)
AP or A	use AM/PM display. A/AP will be replaced by either "AM" or "PM".
ap or a	use am/pm display. a/ap will be replaced by either "am" or "pm".
t		the timezone (for example "CEST")
*/
class QTime : QObject {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[139])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[138])());
	}
	QString toQString(QString shabl) {
		QString qs = new QString(); 
		(cast(t_v__qp_qp_qp)pFunQt[141])(QtObj, qs.QtObj, shabl.QtObj); 
		return qs;
	} /// Выдать содержимое в QString
	string toString(T1)(T1 shabl) { 
		QString qs = toQString(new QString(to!string(shabl)));
		return to!string(qs.String);
	} /// Выдать всё содержимое в String
}
// ================ QFileDialog ================
class QFileDialog : QDialog {
	enum ViewMode {
		Detail = 0,	// Displays an icon, a name, and details for each item in the directory.
		List = 1 	// Displays only an icon and a name for each item in the directory.
	} /// На сколько детаьно паказывать имена файлов

	enum Option {
		Null = 0,
		ShowDirsOnly = 0x00000001,  //	Only show directories in the file dialog. By default both files and directories are shown. (Valid only in the Directory file mode.)
		DontResolveSymlinks = 0x00000002, //	Don't resolve symlinks in the file dialog. By default symlinks are resolved.
		DontConfirmOverwrite = 0x00000004, //	Don't ask for confirmation if an existing file is selected. By default confirmation is requested.
		DontUseNativeDialog = 0x00000010, //	Don't use the native file dialog. By default, the native file dialog is used unless you use a subclass of QFileDialog that contains the Q_OBJECT macro, or the platform does not have a native dialog of the type that you require.
		ReadOnly = 0x00000020, // 	Indicates that the model is readonly.
		HideNameFilterDetails = 0x00000040,	//Indicates if the file name filter details are hidden or not.
		DontUseSheet = 0x00000008,	// In previous versions of Qt, the static functions would create a sheet by default if the static function was given a parent. This is no longer supported and does nothing in Qt 4.5, The static functions will always be an application modal dialog. If you want to use sheets, use QFileDialog::open() instead.
		DontUseCustomDirectoryIcons = 0x00000080	//Always use the default directory icon. Some platforms allow the user to set a different icon. Custom icon lookup cause a big performance impact over network or removable drives. Setting this will enable the QFileIconProvider::DontUseCustomDirectoryIcons option in the icon provider. This enum value was added in Qt 5.2.
	}
	private extern (C) @nogc alias 
	t_v__qp_qp_qp_qp_qp_qp_qp_i = 
		void function(QtObjH, QtObjH, QtObjH, QtObjH, QtObjH, QtObjH, QtObjH, int);

	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[143])(QtObj); setQtObj(null); }
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[142])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[142])(null, fl));
		}
	} /// Конструктор
	QFileDialog setNameFilter(QString shabl) {
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 0); 
		return this;
	} /// Установить фильтр для выбираемых файлов
	QFileDialog setNameFilter(T1)(T1 shabl) { 
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Установить фильтр для выбираемых файлов
	QFileDialog selectFile(QString shabl) {
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 1); 
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog selectFile(T1)(T1 shabl) { 
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog setDirectory(QString shabl) {
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 2); 
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDirectory(T1)(T1 shabl) { 
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDefaultSuffix(QString shabl) {
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 3); 
		return this;
	} /// "txt" - добавит эту строку к имени файла, если нет расширения
	QFileDialog setDefaultSuffix(T1)(T1 shabl) { 
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// "txt" - добавит эту строку к имени файла, если нет расширения
	QFileDialog setViewMode(QFileDialog.ViewMode pr) { 
		(cast(t_v__qp_i)pFunQt[145])(QtObj, pr); 
		return this;
	}
	
	// Выбор файла для открытия
	string getOpenFileName(
			string caption = "",				// Заголовок
			string dir = "",					// Начальный каталог
			string filter = "*",				// Фильтр "*.d;;*.f"
			string selectedFilter = "",
			Option options = Option.Null) {
		QString qrez = new QString();
		QString qcaption = new QString(caption);
		QString qdir = new QString(dir);
		QString qfilter = new QString(filter);
		QString qselectedFilter = new QString(selectedFilter);
		
		(cast(t_v__qp_qp_qp_qp_qp_qp_qp_i)pFunQt[146])
			(QtObj, QtObj, qrez.QtObj,
			qcaption.QtObj, qdir.QtObj, qfilter.QtObj,
			qselectedFilter.QtObj, options); 
		return qrez.String;
	}
	// Выбор файла для сохранения. Позволяет выбрать не существующий файл
	string getSaveFileName(
			string caption = "",				// Заголовок
			string dir = "",					// Начальный каталог
			string filter = "*",				// Фильтр "*.d;;*.f"
			string selectedFilter = "",
			Option options = Option.Null) {
		QString qrez = new QString();
		QString qcaption = new QString(caption);
		QString qdir = new QString(dir);
		QString qfilter = new QString(filter);
		QString qselectedFilter = new QString(selectedFilter);
		
		(cast(t_v__qp_qp_qp_qp_qp_qp_qp_i)pFunQt[147])
			(QtObj, QtObj, qrez.QtObj,
			qcaption.QtObj, qdir.QtObj, qfilter.QtObj,
			qselectedFilter.QtObj, options); 
		return qrez.String;
	}
}
// ================ QMdiArea ================
class QMdiArea : QAbstractScrollArea {
	~this() {
		if(!fNoDelete) { 
			// printf("+[%d]-[%d]-MdiSrea ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[152])(QtObj); setQtObj(null); 
			// printf("-[%d]-[%d]-MdiSrea ", id, balCreate); stdout.flush();
		}
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[151])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[151])(null));
		}
	} /// Конструктор
	void addSubWindow(QWidget wd, QtE.WindowType fl = QtE.WindowType.Widget) {
		(cast(t_v__qp_qp_i)pFunQt[155])(QtObj, wd.QtObj, cast(int)fl); 
	}
}
// ================ QMdiSubWindow ================
class QMdiSubWindow : QWidget {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[154])(QtObj); setQtObj(null); }
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[153])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[153])(null, fl));
		}
	} /// Конструктор
}
// ============ QAbstractItemView ==================
class QAbstractItemView : QAbstractScrollArea {
	this(){}
	~this() {
		// if(!fNoDelete) { (cast(t_v__qp) pFunQt[67])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
/* 		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[66])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[66])(null));
		}
 */	} /// Конструктор
} 
// ============ QHeaderView =================
class QHeaderView : QAbstractItemView {
	enum ResizeMode {
		Interactive = 0,
		Fixed =	2,
		Stretch	 = 1,
		ResizeToContents = 3
	}
	this(){}
//	~this() {
//		if(!fNoDelete) { (cast(t_v__qp) pFunQt[160])(QtObj); setQtObj(null); }
//	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
/* 	this(QWidget parent) {
		this.setNoDelete(true);
		setQtObj((cast(t_qp__qp) pFunQt[159])(parent ? parent.QtObj : null));
 	} /// Конструктор
 */
}
// ============ QTableView ==================
class QTableView : QAbstractItemView {
	this(){}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[160])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		this.setNoDelete(true);
		setQtObj((cast(t_qp__qp) pFunQt[159])(parent ? parent.QtObj : null));
 	} /// Конструктор
	QTableView setColumnWidth(int column, int width) {
		(cast(t_v__qp_i_i_i) pFunQt[174])(QtObj, column, width, 0); return this;
	}
	int columnWidth(int column) {
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, column, 0);
	}
	QTableView setRowHeight(int row, int height) {
		(cast(t_v__qp_i_i_i) pFunQt[174])(QtObj, row, height, 1); return this;
	}
	int rowHeight(int row) {
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, row, 1);
	}
	int columnAt(int column) {
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, column, 2);
	}
	int rowAt(int row) {
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, row, 3);
	}
	QTableView showColumn(int column) {
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, column, 4); return this;
	}
	QTableView hideColumn(int column) {
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, column, 5); return this;
	}
	QTableView showRow(int row) {
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, row, 6); return this;
	}
	QTableView hideRow(int row) {
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, row, 7); return this;
	}
 	QTableView ResizeModeColumn(int column, QHeaderView.ResizeMode rm = QHeaderView.ResizeMode.Stretch) {
		(cast(t_v__qp_i_i_i) pFunQt[182])(QtObj, column, rm, 0); return this;
	}
	QTableView ResizeModeRow(int row, QHeaderView.ResizeMode rm = QHeaderView.ResizeMode.Stretch) {
		(cast(t_v__qp_i_i_i) pFunQt[182])(QtObj, row, rm, 1); return this;
	}

//	funQt(182, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_ResizeMode",		showError);
	
} 
// ============ QTableWidget ==================
class QTableWidget : QTableView {
	this(){}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[162])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		this.setNoDelete(true);
		setQtObj((cast(t_qp__qp) pFunQt[161])(parent ? parent.QtObj : null));
 	} /// Конструктор
	QTableWidget setRowCount(int row) {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, row, 1); return this;
	}
	QTableWidget setColumnCount(int col) {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, col, 0); return this;
	}
	QTableWidget insertRow(int row) {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, row, 3); return this;
	}
	QTableWidget insertColumn(int col) {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, col, 2); return this;
	}
	QTableWidget clear() {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, 0, 4); return this;
	}
	QTableWidget clearContents() {
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, 0, 5); return this;
	} /// Удалено содержание, но заголовки и прочее остаётся
	
	QTableWidget setItem(int r, int c, QTableWidgetItem twi) {
		twi.setNoDelete(true);
		(cast(t_v__qp_qp_i_i) pFunQt[167])(QtObj, twi.QtObj, r, c); return this;
	}
	QTableWidget setHorizontalHeaderItem(int c, QTableWidgetItem twi) {
		(cast(t_v__qp_qp_i_i) pFunQt[176])(QtObj, twi.QtObj, c, 0); return this;
	}
	QTableWidget setVerticalHeaderItem(int row, QTableWidgetItem twi) {
		(cast(t_v__qp_qp_i_i) pFunQt[176])(QtObj, twi.QtObj, row, 1); return this;
	}
	QTableWidget setCurrentCell(int row, int column) {
		(cast(t_v__qp_i_i) pFunQt[241])(QtObj, row, column); return this;
	}
	
	
/* 	QString toQString(QString shabl) {
		QString qs = new QString(); 
		(cast(t_v__qp_qp_qp)pFunQt[141])(QtObj, qs.QtObj, shabl.QtObj); 
		return qs;
	}
 */}
 
// =========== QTableWidgetItem ========
class QTableWidgetItem : QObject {
	~this() {
		if(!fNoDelete) { 
			// printf("+[%d]-[%d]-Item ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[165])(QtObj); setQtObj(null); 
			// printf("-[%d]-[%d]-Item ", id, balCreate); stdout.flush();
		}
	}
	this(QTableWidget tw, int row, int col) {
		setQtObj((cast(t_qp__qp_i_i)pFunQt[169])(tw.QtObj, row, col));
	} /// Создать item забрав его по координатам
	this(int Type) {
		setQtObj((cast(t_qp__i)pFunQt[164])(Type));
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	QTableWidgetItem setText(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст в ячейке
	QTableWidgetItem setText(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, (new QString(to!string(str))).QtObj, 0);
		return this;
	} /// Установить текст в ячейке
	QTableWidgetItem setToolTip(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 1);
		return this;
	}
	QTableWidgetItem setToolTip(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, (new QString(to!string(str))).QtObj, 1);
		return this;
	}
	QTableWidgetItem setStatusTip(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 2);
		return this;
	}
	QTableWidgetItem setStatusTip(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, (new QString(to!string(str))).QtObj, 2);
		return this;
	}
	QTableWidgetItem setWhatsThis(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 3);
		return this;
	}
	QTableWidgetItem setWhatsThis(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, (new QString(to!string(str))).QtObj, 3);
		return this;
	}
	int column() {
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 0);
	}
	int row() {
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 1);
	}
	int textAlignment() {
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 2);
	}
	int type() {
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 3);
	}
	T text(T: QString)() {
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[170])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	
 	QTableWidgetItem setTextAlignment(QtE.AlignmentFlag alig = QtE.AlignmentFlag.AlignLeft) {
		(cast(t_v__qp_i)pFunQt[171])(QtObj, alig);
		return this;
	}
 	QTableWidgetItem setBackground(QBrush brush) {
		(cast(t_v__qp_qp_i)pFunQt[180])(QtObj, brush.QtObj, 0);
		return this;
	}
 	QTableWidgetItem setForeground(QBrush brush) {
		(cast(t_v__qp_qp_i)pFunQt[180])(QtObj, brush.QtObj, 1);
		return this;
	}
}
// ================ QComboBox ================
/++
QComboBox (Выподающий список), но немного модифицированный в QtE.DLL.
+/
class QComboBox : QWidget {
	this() {}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[184])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[183])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[183])(null));
		}
	} /// Конструктор
	QComboBox addItem(QString str, int i) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, str.QtObj, i, 0); return this;
	} /// Добавить строку str с значением i
	QComboBox addItem(string s, int i) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, (new QString(s)).QtObj, i, 0); return this;
	}
	QComboBox setItemText(QString str, int n) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, str.QtObj, n, 1); return this;
	} /// Заменить строку, значение i не меняется
	QComboBox setItemText(string s, int n) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, (new QString(s)).QtObj, n, 1); return this;
	}
	QComboBox setMaxCount(int n) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 2); return this;
	}
	QComboBox setMaxVisibleItems(int n) {
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 3); return this;
	}
	int currentIndex() {
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 0);
	}
	int count() {
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 1);
	}
	int maxCount() {
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 2);
	}
	int maxVisibleItems() {
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 3);
	}
	int currentData() {
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 4);
	}
	QComboBox clear() {
		(cast(t_i__qp_i) pFunQt[186])(QtObj, 5); return this;
	}
	T text(T: QString)() {
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[187])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	
//		setQtObj((cast(t_qp__qp) pFunQt[161])(parent ? parent.QtObj : null));
}
// ================ QPen ================
class QPen : QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[191])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[192])(QtObj); setQtObj(null); }
	} /// Деструктор
	QPen setColor(QColor color) {
		(cast(t_v__qp_qp) pFunQt[193])(QtObj, color.QtObj);
		return this;
	}
	QPen setStyle(QtE.PenStyle ps = QtE.PenStyle.SolidLine) {
		(cast(t_v__qp_i) pFunQt[194])(QtObj, ps);
		return this;
	}
	QPen setWidth(int w) {
		(cast(t_v__qp_i) pFunQt[195])(QtObj, w);
		return this;
	}
}
// ============ QLCDNumber =======================================
class QLCDNumber : QFrame {
	enum Mode { Hex, Dec, Oct, Bin }
	enum SegmentStyle {
		Outline,			// Выпуклый Цвета фона - а именно прозрачноБесцветный
		Filled,				// Выпуклый Цвета текста
		Flat				// Плоский
	}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[199])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		super();
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp) pFunQt[198])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[198])(null));
		}
	} /// Конструктор
	this(QWidget parent, int kolNumber) {
		super();
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[200])(parent.QtObj, kolNumber));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[200])(null, kolNumber));
		}
	} /// Конструктор
	QLCDNumber display(int n) {
		(cast(t_v__qp_i) pFunQt[201])(QtObj, n); return this;
	} /// Отобразить число
	QLCDNumber setSegmentStyle(QLCDNumber.SegmentStyle style) {
		(cast(t_v__qp_i) pFunQt[202])(QtObj, cast(int)style);  return this;
	} /// Способ изображения сегментов
	QLCDNumber setDigitCount(int kolNumber) {
		(cast(t_v__qp_i) pFunQt[203])(QtObj, kolNumber); return this;
	} /// Установить количество показываемых цифр
	QLCDNumber setMode(QLCDNumber.Mode mode) {
		(cast(t_v__qp_i) pFunQt[204])(QtObj, cast(int)mode);  return this;
	} /// Способ изображения сегментов
	
}
// ============ QAbstractSlider =======================================
class QAbstractSlider : QWidget {
	this() {}
	this(QWidget parent) {}
	~this() {
		if(!fNoDelete) {}
	}
	QAbstractSlider setMaximum( int n ) {
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 0); return this;
	}
	QAbstractSlider setMinimum( int n ) {
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 1); return this;
	}
	QAbstractSlider setPageStep( int n ) {
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 2); return this;
	}
	QAbstractSlider setSingleStep( int n ) {
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 3); return this;
	}
	QAbstractSlider setSliderPosition( int n ) {
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 4); return this;
	}
	int maximum() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 0); }
	int minimum() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 1); }
	int pageStep() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 2); }
	int singleStep() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 3); }
	int sliderPosition() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 4); }
	int value() { return (cast(t_i__qp_i) pFunQt[208])(QtObj, 5); }
}
// ============ QSlider =======================================
class QSlider : QAbstractSlider {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[207])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent, QtE.Orientation n = QtE.Orientation.Horizontal) {
		super();
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_i) pFunQt[206])(parent.QtObj, cast(int)n));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[206])(null, cast(int)n));
		}
	} /// Конструктор
}
// ================ QGroupBox ================
class QGroupBox : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[213])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[212])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[212])(null));
		}
	}
	QGroupBox setText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[214])(QtObj, str.QtObj);
		return this;
	} /// Установить текст
	QGroupBox setText(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[214])(QtObj, (new QString(to!string(str))).QtObj);
		return this;
	} /// Установить текст
	QGroupBox setAlignment(QtE.AlignmentFlag fl) {
		(cast(t_v__qp_i) pFunQt[215])(QtObj, fl);
		return this;
	} /// Выровнять текст
	
}
// ================ QCheckBox ================
class QCheckBox : QAbstractButton { //=> Кнопки CheckBox независимые
	this(){}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(null, str.QtObj));
		}
	} /// Создать кнопку.
    ~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[217])(QtObj); setQtObj(null); }
		// write("B- "); stdout.flush();
    }
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(parent.QtObj, (new QString(to!string(str))).QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(null, (new QString(to!string(str))).QtObj));
		}
	}
	QtE.CheckState checkState() {  //-> Состояние переключателя/кнопки
		return cast(QtE.CheckState)(cast(t_i__qp) pFunQt[218])(QtObj);
	}
	QCheckBox setCheckState(QtE.CheckState st = QtE.CheckState.Unchecked) { //-> Установить состояние переключателя/кнопки
		(cast(t_v__qp_i) pFunQt[219])(QtObj, st); return this;
	}
	bool isTristate() { //-> Есть в третичном состоянии?
		return (cast(t_b__qp) pFunQt[221])(QtObj);
	}
	QCheckBox setTristate(bool state = true) { //-> Установить/отменить третичное состояние
		(cast(t_v__qp_bool)pFunQt[220])(QtObj, state); return this;
	}
}
// ================ QRadioButton ================
class QRadioButton : QAbstractButton { //=> Кнопки РадиоБатоны зависимые
	this(){}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			this.setNoDelete(true);	// Не удалять текущий экземпляр, при условии, что он вставлен в другой
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(null, str.QtObj));
		}
	} /// Создать кнопку.
    ~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[223])(QtObj); setQtObj(null); }
		// write("B- "); stdout.flush();
    }
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(parent.QtObj, (new QString(to!string(str))).QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(null, (new QString(to!string(str))).QtObj));
		}
	}
}
// ================ QTextCursor ================
class QTextCursor : QObject {

	enum MoveMode {
		MoveAnchor	= 0,	// Moves the anchor to the same position as the cursor itself.
		KeepAnchor	= 1		// Keeps the anchor where it is.
	}
	enum MoveOperation {
		NoMove		= 0,	// Keep the cursor where it is
		Start		= 1,	// Move to the start of the document.
		StartOfLine	= 3,	// Move to the start of the current line.
		StartOfBlock= 4,	// Move to the start of the current block.
		StartOfWord	= 5,	// Move to the start of the current word.
		PreviousBlock=6,	// Move to the start of the previous block.
		PreviousCharacter=7,// Move to the previous character.
		PreviousWord= 8,	// Move to the beginning of the previous word.
		Up			= 2,	// Move up one line.
		Left		= 9,	// Move left one character.
		WordLeft	= 10,	// Move left one word.
		End			= 11,	// Move to the end of the document.
		EndOfLine	= 13,	// Move to the end of the current line.
		EndOfWord	= 14,	// Move to the end of the current word.
		EndOfBlock	= 15,	// Move to the end of the current block.
		NextBlock	= 16,	// Move to the beginning of the next block.
		NextCharacter=17,	// Move to the next character.
		NextWord	= 18,	// Move to the next word.
		Down		= 12,	// Move down one line.
		Right		= 19,	// Move right one character.
		WordRight	= 20,	// Move right one word.
		NextCell	= 21,	// Move to the beginning of the next table cell inside the current table. If the current cell is the last cell in the row, the cursor will move to the first cell in the next row.
		PreviousCell= 22,	// Move to the beginning of the previous table cell inside the current table. If the current cell is the first cell in the row, the cursor will move to the last cell in the previous row.
		NextRow		= 23,	// Move to the first new cell of the next row in the current table.
		PreviousRow	= 24	// Move to the last cell of the previous row in the current table.	
	}



	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[228])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(void* ukDocument) {
		setQtObj((cast(t_qp__qp)pFunQt[227])(cast(QtObj__*)ukDocument));
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[229])());
	}
	int anchor() {
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 0);
	}
	int blockNumber() {
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 1);
	}
	int columnNumber() { //-> Позиция (с 0) в видимой строке. Перен стр считается снова
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 2);
	}
	int position() { //-> Позиция (с 0) в тексте, начиная с начала. Счит. печ симв
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 3);
	}
	int positionInBlock() { //-> Позиция (с 0) в текушей строке
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 4);
	}
	int selectionEnd() {
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 5);
	}
	int selectionStart() {
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 6);
	}
	int verticalMovementX() { //-> Количество пикселей с левого края
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 7);
	}
	bool movePosition(
		QTextCursor.MoveOperation operation, 
		QTextCursor.MoveMode mode = QTextCursor.MoveMode.MoveAnchor,
		int n = 1) { //-> Передвинуть текстовый курсор
		return (cast(t_b__qp_i_i_i) pFunQt[254])(QtObj, operation, mode, n);
	}
	// 255
	QTextCursor beginEditBlock() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 0); return this;
	}
	QTextCursor endEditBlock() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 4); return this;
	}
	QTextCursor clearSelection() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 1); return this;
	}
	QTextCursor deleteChar() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 2); return this;
	}
	QTextCursor deletePreviousChar() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 3); return this;
	}
	QTextCursor insertBlock() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 5); return this;
	}
	QTextCursor removeSelectedText() {
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 6); return this;
	}
	
	QTextCursor insertText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[256])(QtObj, str.QtObj);
		return this;
	} /// Установить текст
	QTextCursor insertText(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[256])(QtObj, (new QString(to!string(str))).QtObj);
		return this;
	} /// Установить текст
	
	
}
// ================ QRect ================
class QRect : QObject {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[233])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this() {
		setQtObj((cast(t_qp__v)pFunQt[232])());
	}
	int x() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 0);
	}
	int y() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 1);
	}
	int width() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 2);
	}
	int height() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 3);
	}
	int left() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 4);
	}
	int right() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 5);
	}
	int top() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 6);
	}
	int bottom() {
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 7);
	}
	QRect setCoords(int x1, int y1, int x2, int y2) { //-> Задать координаты
		(cast(t_v__qp_i_i_i_i_i) pFunQt[242])(QtObj, x1, y1, x2, y2, 0); return this;
	}
	QRect setRect(int x1, int y1, int width, int height) { //-> Задать верх лев угол и длину + ширину
		(cast(t_v__qp_i_i_i_i_i) pFunQt[242])(QtObj, x1, y1, width, height, 1); return this;
	}
}
// ================ QTextBlock ================
class QTextBlock : QObject {
	this() {
		setQtObj((cast(t_qp__v)pFunQt[238])());
	}
	this(QTextCursor tk) {
		setQtObj((cast(t_qp__qp)pFunQt[240])(tk.QtObj));
	}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[239])(QtObj); setQtObj(null); }
	}
	T text(T: QString)() { //-> Содержимое блока в QString
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[237])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String

}
// ============ QAbstractSpinBox =======================================
class QAbstractSpinBox : QWidget {
	this() {}
	this(QWidget parent) {}
	~this() {
		if(!fNoDelete) {}
	}
	void setReadOnly(bool f) { //-> T - только чтать, изменять нельзя
		(cast(t_v__qp_bool)pFunQt[252])(QtObj, f);
	}
}
// ============ QSpinBox =======================================
class QSpinBox : QAbstractSpinBox {
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[248])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent) {
		super();
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[247])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[247])(null));
		}
	} /// Конструктор
	QSpinBox setMinimum(int n) { //-> Установить минимум
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 0); return this;
	}
	QSpinBox setMaximum(int n) { //-> Установить максимум
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 1); return this;
	}
	QSpinBox setSingleStep(int n) { //-> Установить приращение
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 2); return this;
	}
	int minimum() { //-> Получить минимальное
		return (cast(t_i__qp_i) pFunQt[250])(QtObj, 0);
	}
	int maximum() { //-> Получить максимальное
		return (cast(t_i__qp_i) pFunQt[250])(QtObj, 1);
	}
	int singleStep() { //-> Получить приращение
		return (cast(t_i__qp_i) pFunQt[250])(QtObj, 2);
	}
	int value() { //-> Получить значение
		return (cast(t_i__qp_i) pFunQt[250])(QtObj, 3);
	}
	QSpinBox setPrefix(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QSpinBox setPrefix(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, (new QString(to!string(str))).QtObj, 0);
		return this;
	} /// Установить текст
	QSpinBox setSuffix(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QSpinBox setSuffix(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, (new QString(to!string(str))).QtObj, 1);
		return this;
	} /// Установить текст

	
}
// ============ Highlighter =======================================
class Highlighter : QObject {
	~this() {
		if(!fNoDelete) { 
			// printf("+[%d]-[%d]-Hig ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[258])(QtObj); setQtObj(null);
			// printf("-[%d]-[%d]-Hig ", id, balCreate); stdout.flush();
		}
		
		
		
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(void* parent) {
		super();
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__vp) pFunQt[257])(parent));
		} else {
			setQtObj((cast(t_qp__vp) pFunQt[257])(null));
		}
	} /// Конструктор
}

// ================ QTextEdit ================
/++
Продвинутый редактор
+/
class QTextEdit : QAbstractScrollArea {
	this(){}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[261])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if (parent) {
			this.setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[260])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[260])(null));
		}
	} /// Конструктор
	QTextEdit setPlainText(T: QString)(T str) {  //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[270])(QtObj, str.QtObj); return this;
	} /// Удалить всё и вставить с начала
	QTextEdit setPlainText(T)(T str) { //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[270])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Удалить всё и вставить с начала
	QTextEdit insertPlainText(T: QString)(T str) {  //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp) pFunQt[271])(QtObj, str.QtObj); return this;
	} /// Вставить текст в месте курсора
	QTextEdit insertPlainText(T)(T str) { //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp) pFunQt[271])(QtObj, (new QString(to!string(str))).QtObj); return this;
	} /// Вставить текст в месте курсора
	QTextEdit cut() { //-> Вырезать кусок
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 0); return this;
	} /// cut()
	QTextEdit clear() { //-> Очистить всё
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 1); return this;
	} /// clear()
	QTextEdit paste() { //-> Вставить из буфера
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 2); return this;
	} /// paste()
	QTextEdit copy() { //-> Скопировать в буфер
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 3); return this;
	} /// copy()
	QTextEdit selectAll() {
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 4); return this;
	} /// selectAll()
	QTextEdit selectionChanged() {
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 5); return this;
	} /// selectionChanged()
	QTextEdit undo() {
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 7); return this;
	} /// undo()
	QTextEdit redo() {
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 8); return this;
	} /// redo()

	
}
// ================ QTimer ================
class QTimer : QObject {
	enum TimerType {
		PreciseTimer	= 0,	// Precise timers try to keep millisecond accuracy
		CoarseTimer		= 1,	// Coarse timers try to keep accuracy within 5% of the desired interval
		VeryCoarseTimer	= 2		// Very coarse timers only keep full second accuracy
	}

	this(){}
	this(QObject parent) {
		setQtObj((cast(t_qp__qp)pFunQt[262])(parent.QtObj));
	}
	~this() {
		if(!fNoDelete) { (cast(t_v__qp) pFunQt[263])(QtObj); setQtObj(null); }
	}
	// Установить интервал срабатывания в милисекундах
	void setInterval(int msek) { //-> интервал в милисек
		(cast(t_v__qp_i) pFunQt[264])(QtObj, msek);
	}
	int interval() { //-> Вернуть интервал срабатывания
		return (cast(t_i__qp_i) pFunQt[265])(QtObj, 0);
	}
	int remainingTime() { //-> Вернуть оставшиеся время. -1=не активен, 0=время закончилось
		return (cast(t_i__qp_i) pFunQt[265])(QtObj, 1);
	}
	int timerId() { //-> Id если работает, -1=не работает
		return (cast(t_i__qp_i) pFunQt[265])(QtObj, 2);
	}
	bool isActive() { //-> Активен?
		return (cast(t_b__qp_i) pFunQt[266])(QtObj, 0);
	}
	bool isSingleShot() { //-> Разового срабатывания?
		return (cast(t_b__qp_i) pFunQt[266])(QtObj, 1);
	}
	void setTimerType(QTimer.TimerType t) { //-> Задать тип таймера
		return (cast(t_v__qp_i) pFunQt[267])(QtObj, t);
	}
	void setSingleShot(bool t) { //-> Задать тип срабатывания. T - один раз
		return (cast(t_v__qp_b) pFunQt[268])(QtObj, t);
	}
	TimerType timerType() { //-> Получить тип таймера
		return cast(TimerType)(cast(t_i__qp) pFunQt[269])(QtObj);
	}
}





