/**
 *  Authors: MGW *Мохов Геннадий Владимирович*, mgw@yandex.ru
 *  Date: 28.08.2021 9:48
 *  ___
 *  Description: Это библиотека привязки Qt к D
 *  ___
 */

/**
 *  Slots:
 *   1. void Slot_AN();             --> "Slot_AN()" 				$(GREEN // void call(Aдркласса, Nчисло);)
 *   2. void Slot_ANI(int);         --> "Slot_ANI(int)" 			$(GREEN // void call(Aдркласса, Nчисло, int);)
 *   3. void Slot_ANII(int, int);   --> "Slot_ANII(int, int)"		$(GREEN // void call(Aдркласса, Nчисло, int, int);)
 *   4. void Slot_ANII(int, int, int);--> "Slot_ANIII(int, int, int)"	$(GREEN // void call(Aдркласса, Nчисло, int, int, int);)
 *   5. void Slot_ANB(bool);        --> "Slot_ANB(bool)"			$(GREEN // void call(Aдркласса, Nчисло, bool);)
 *   6. void Slot_ANQ(QObject*);    --> "Slot_ANQ(QObject*)"		$(GREEN // void call(Aдркласса, Nчисло, QObject*);)
 *  Signals:
 *   1. void Signal_V();          	--> "Signal_V()"				$(GREEN // Сигнал без параметра)
 *   2. void Signal_VI(int);      	--> "Signal_VI(int)"			$(GREEN // Сигнал с int)
 *   3. void Signal_VS(QString);  	--> "Signal_VS(QString)"		$(GREEN // Сигнал с QString)
 */

module qte56;

import std.conv; // Convert to string
import std.utf: encode;

// Отладка
import std.stdio;

/// Версия библиотеки, старший номер
int verQt56Eu = 1;
/// Версия библиотеки, младший номер
int verQt56El = 0;
/// Дата начала работы над библиотекой -- Добавлен QSpinBox
string verQt56Ed = "17.11.21 11:26";

// Отладка - выдать имя по номеру для удаления элементами
string genNameClass(int tp) {
	string rez;
    if(tp == 0) return "eQWidget";
    if(tp == 1) return "QBoxLayout";
    if(tp == 2) return "QVBoxLayout";
    if(tp == 3) return "QHBoxLayout";
    if(tp == 4) return "QFrame";
    if(tp == 5) return "QLabel";
    if(tp == 6) return "eQMainWindow";
    if(tp == 7) return "QStatusBar";
    if(tp == 8) return "QPushButton";
    if(tp == 9) return "eAction";
    if(tp == 10) return "QApplication";
    if(tp == 11) return "eQLineEdit";
    if(tp == 12) return "eQPlainTextEdit";
    if(tp == 13) return "QMenu";
    if(tp == 14) return "QMenuBar";
    if(tp == 15) return "QFont";
    if(tp == 16) return "QIcon";
    if(tp == 17) return "QToolBar";
    if(tp == 18) return "QDialog";
    if(tp == 19) return "QMessageBox";
    if(tp == 20) return "QProgressBar";
    if(tp == 21) return "QMdiArea";
    if(tp == 22) return "QMdiSubWindow";
    if(tp == 23) return "QComboBox";
    if(tp == 24) return "QSlider";
    if(tp == 25) return "QGroupBox";
    //---------
    if(tp == 26) return "QTabBar";
    if(tp == 27) return "QStackedWidget";
    if(tp == 28) return "QLCDNumber";
	//---------
	if(tp == 29) return "QCommandLinkButton";
    if(tp == 30) return "QDockWidget";
    if(tp == 31) return "QSplitter";
    if(tp == 32) return "QDateTimeEdit";
    if(tp == 33) return "QFormBuilder";
    if(tp == 34) return "QTabWidget";
    if(tp == 35) return "QSpinBox";
	return rez;
}

/// Выдать строку с версией библиотеки.
string verQtE56() {
    import std.string : format;
    return format("QtE56 [%d] ver: %s.%s %s", size_t.sizeof * 8, verQt56Eu, verQt56El, verQt56Ed);
}

alias PTRINT = int;
alias PTRUINT = uint;
struct QtObj__ { PTRINT dummy; } alias QtObjH = QtObj__*;

/***********************************
 * Block: Блок для описания массива адресов функций из DLL
 */
/// Максимальное количество (размерность) массива с загруженными функциями из DLL
enum maxLength_pFunQt = 2000;
/// Масив указателей на функции из DLL
private void*[maxLength_pFunQt] pFunQt;
/// Указатель (верхняя граница) занятых элементов в массиве функций
private uint maxValueInPFunQt;

/// Список ссылок на сами DLL
static void* hCore5, hGui5, hWidget5, hQtE6Widgets, hQtE6core, hQtE6Script, hQtE6Web, hQtE6WebEng, hQtE6Qml, hQtE6Qscintilla;

immutable int QMETHOD = 0;
immutable int QSLOT = 1;
immutable int QSIGNAL = 2;

/**
 *  Section: Описание внутренних типов и аргументов вызова для функций из DLL
 *  ___
 */
private {
	import std.string : split;
	static mesNoThisWitoutPar = " without parameters is forbidden!";
	// Generate alias for types call function Qt
	string generateAlias(string ind) {
		string rez;
		string[string] v;
		v["v"]="void";v[""]="";v["t"]="t";v["qp"]="QtObjH";v["i"]="int";
		v["ui"]="uint";v["c"]="char";v["vp"]="void*";v["b"]="bool";v["cp"]="char*";
		v["ip"]="int*";v["vpp"]="void**";v["bool"]="bool";v["us"]="ushort";v["l"]="long";
		auto mas = split(ind, '_');
		rez = "alias " ~ ind ~ " = extern (C) nothrow @nogc " ~ v[mas[1]] ~ " function(";
		foreach(i, el; mas) if(i > 2) rez ~= v[el] ~ ", ";
		rez = rez[0 .. $-2];	rez ~= ");";
		return rez;
	}
	//in: n = nomer function (12), name = name func in library (funCreateQWidget), nameAliasLib = short name DLL/SO (Script)
	//out: funQt(12,bQtE6Script,hQtE6Script,sQtE6Script,"funCreateQWidget", showError);
	string generateFunQt(int n, string name, string nameAliasLib) {
		enum s = "QtE6";
		return "funQt("~to!string(n)~",b"~s~nameAliasLib~",h"~s~ nameAliasLib~",s"~s~nameAliasLib~`,"`~name~`"`~",showError);";
	}

	alias t_QObject_connect = extern (C) @nogc void function(void*, char*, void*, char*, int);
	alias t_QObject_disconnect = extern (C) @nogc void function(void*, char*, void*, char*);

	mixin(generateAlias("t_v__i"));
	mixin(generateAlias("t_v__qp"));
	mixin(generateAlias("t_v__qp_qp"));
	mixin(generateAlias("t_v__qp_vp"));
	mixin(generateAlias("t_v__qp_i"));
	mixin(generateAlias("t_v__qp_i_i_ui"));
	mixin(generateAlias("t_v__vp_c"));
	mixin(generateAlias("t_v__qp_ui"));

	mixin(generateAlias("t_vp__qp"));
	mixin(generateAlias("t_v__vp_vp_vp"));
	mixin(generateAlias("t_v__vp_vp_vp_vp"));
	mixin(generateAlias("t_v__qp_i_i"));
	mixin(generateAlias("t_v__qp_qp_i_i"));
	mixin(generateAlias("t_v__qp_qp_i_i_i"));
	mixin(generateAlias("t_v__qp_qp_i_i_i_i"));
	mixin(generateAlias("t_v__qp_qp_i_i_i_i_i"));

	mixin(generateAlias("t_b__vp"));
	mixin(generateAlias("t_b__qp"));
	mixin(generateAlias("t_b__qp_qp"));
	mixin(generateAlias("t_b__qp_qp_qp"));
	mixin(generateAlias("t_b__qp_qp_qp_i"));
	mixin(generateAlias("t_b__qp_qp_i"));
	mixin(generateAlias("t_b__qp_i"));
	mixin(generateAlias("t_b__qp_i_i_i"));
	mixin(generateAlias("t_b__qp_i_i"));
	mixin(generateAlias("t_b__qp_qp_i_i"));

	mixin(generateAlias("t_v__qp_qp_i"));
	mixin(generateAlias("t_v__qp_qp_qp_i"));
	mixin(generateAlias("t_v__qp_qp_qp_i_i"));
	mixin(generateAlias("t_v__qp_qp_qp"));
	mixin(generateAlias("t_v__qp_qp_qp_qp_i"));
	mixin(generateAlias("t_i__qp_qp_qp"));
	mixin(generateAlias("t_i__qp_qp_qp_qp"));

	mixin(generateAlias("t_v__qp_i_i_i_i_i"));
	mixin(generateAlias("t_v__qp_ip_ip_ip_ip"));

	mixin(generateAlias("t_v__vp_vp_i"));
	mixin(generateAlias("t_i__vp_vp_vp"));
	mixin(generateAlias("t_i__vp_i"));
	mixin(generateAlias("t_i__qp_i"));
	mixin(generateAlias("t_i__qp_qp"));
	mixin(generateAlias("t_i__qp_i_i"));
	mixin(generateAlias("t_i__qp_i_qp_qp_i"));
	mixin(generateAlias("t_i__qp_i_i_i"));
	mixin(generateAlias("t_i__qp_qp_i"));
	mixin(generateAlias("t_qp__qp_qp"));
	mixin(generateAlias("t_qp__qp_qp_qp"));
	mixin(generateAlias("t_vp__vp_c_i"));
	mixin(generateAlias("t_vp__vp_cp_i"));
	mixin(generateAlias("t_i__qp_qp_qp_i_i"));
	mixin(generateAlias("t_qp__qp_qp_qp_i"));
	mixin(generateAlias("t_qp__qp_qp_qp_qp"));

	mixin(generateAlias("t_vpp__vp"));
	mixin(generateAlias("t_qp__qp"));
	mixin(generateAlias("t_qp__ui"));
	mixin(generateAlias("t_qp__vp"));

	mixin(generateAlias("t_vp__vp"));
	mixin(generateAlias("t_vp__vp_i_i"));
	mixin(generateAlias("t_vp__vp_i_vp"));

	mixin(generateAlias("t_vp__vp_vp_i"));
	mixin(generateAlias("t_qp__qp_qp_i"));
	mixin(generateAlias("t_vp__vp_i"));
	mixin(generateAlias("t_qp__qp_i"));
	mixin(generateAlias("t_qp__qp_b"));
	mixin(generateAlias("t_ui__qp_i_i"));
	mixin(generateAlias("t_ui__qp"));
	mixin(generateAlias("t_qp__qp_i_i"));
	mixin(generateAlias("t_qp__qp_i_i_i"));
	alias t_vp__v = extern (C) @nogc void* function();
	alias t_qp__v = extern (C) @nogc QtObjH function();
	mixin(generateAlias("t_i__vp"));
	mixin(generateAlias("t_i__qp"));

	mixin(generateAlias("t_v__qp_b_i_i"));
	mixin(generateAlias("t_v__qp_b_i"));

	mixin(generateAlias("t_vp__i_i"));
	mixin(generateAlias("t_qp__i_i"));
	mixin(generateAlias("t_qp__i_i_i"));
	mixin(generateAlias("t_qp__i_i_i_i"));
	mixin(generateAlias("t_qp__i"));

	mixin(generateAlias("t_vp__i_i_i_i"));

	// mixin(generateAlias("t_v__vp_i_bool"));
	mixin(generateAlias("t_v__vp_i_i_i_i"));
	mixin(generateAlias("t_v__qp_i_i_i_i"));
	mixin(generateAlias("t_v__qp_i_i_i"));
	mixin(generateAlias("t_v__vp_i_i_vp"));
	mixin(generateAlias("t_v__i_vp_vp"));
	// mixin(generateAlias("t_vp__vp_vp_bool"));
	// mixin(generateAlias("t_vp__i_vp_bool"));
	alias t_i__v = extern (C) @nogc int function();
	// mixin(generateAlias("t_i__vp_vbool_i"));

	mixin(generateAlias("t_vp__vp_i_vp_i"));
	mixin(generateAlias("t_vp__vp_i_i_vp"));
	mixin(generateAlias("t_vp__vp_vp_i_i"));
	mixin(generateAlias("t_i__vp_vp_i_i"));

	mixin(generateAlias("t_vp__vp_vp_us_i"));
	mixin(generateAlias("t_v__vp_vp_us_i"));
	mixin(generateAlias("t_bool__vp"));
	mixin(generateAlias("t_bool__vp_c"));
	mixin(generateAlias("t_bool__vp_vp"));
	mixin(generateAlias("t_v__qp_bool"));
	mixin(generateAlias("t_v__qp_bool_i"));
	mixin(generateAlias("t_v__qp_b"));
	mixin(generateAlias("t_v__vp_i_vp_us_i"));
	mixin(generateAlias("t_vp__vp_vp_vp"));

	mixin(generateAlias("t_l__vp_vp_l"));
	mixin(generateAlias("t_l__vp"));

	mixin(generateAlias("t_vp__vp_vp_vp_vp_vp_vp_vp"));
	mixin(generateAlias("t_vp__vp_vp_vp_vp_vp_vp_vp_vp"));

	alias t_ub__qp = extern (C) @nogc ubyte* function(QtObjH);
	alias t_uwc__qp = extern (C) @nogc wchar* function(QtObjH);
}

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
private void* GetPrAddress(T)(bool isLoad, void* hLib, T nameFun) {
	if(!hLib) writeln(nameFun, " -- ", hLib);
	if(!hLib) return null;
	// // Искать или не искать функцию. Find or not find function in library
	if (isLoad) return GetProcAddress(hLib, nameFun.ptr);
	return cast(void*) 1;
}
// Сообщить об ошибке загрузки. Message on error.
private void MessageErrorLoad(bool showError, string s, string nameDll = "" ) {
	if (showError) {
		if (!nameDll.length) writeln("Error load: " ~ s);
		else writeln("Error find function: " ~ nameDll ~ " ---> " ~ s);
	} else {
		if (!nameDll.length) writeln("Load: " ~ s);
		else writeln("Find function: " ~ nameDll ~ " ---> " ~ s);
	}
} /// Message on error. s - text error, sw=1 - error load dll and sw=2 - error find function

/// Моделирует макросы QT.
/// s - Name slot, signal; n - 2->SIGNAL(), 1->SLOT(), 0->METHOD().
char* MSS(string s, int n) {
	if (n == QMETHOD)	return cast(char*)("0" ~ s ~ "\0").ptr;
	if (n == QSLOT) 	return cast(char*)("1" ~ s ~ "\0").ptr;
	if (n == QSIGNAL)	return cast(char*)("2" ~ s ~ "\0").ptr;
	return null;
}

// Qt6Core & Qt6Gui & Qt6Widgets - Are loaded always
enum dll {
	QtE6Widgets  		=  1,
	QtE6Script   		=  2,
	QtE6Web		 		=  4,
	QtE6WebEng	 		=  8,
	QtEQml				= 16,
	QtE6Qscintilla   	= 32,
	QtE6core           = 64
} /// Загрузка DLL. Необходимо выбрать какие грузить. Load DLL, we mast change load
/++
 + Пример загрузки только QtE6Widgets
 +
 + Example:
 + ---
 + bool fDebug = true; // full info for errors of load
 + if (1 == LoadQt(dll.QtE6Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
 + ---
 +/

// Найти и сохранить адрес функции DLL
void funQt(int n, bool b, void* h, string s, string name, bool she) {
	if(!h) return; // { MessageErrorLoad(she, s, "no DLL/SO for function " ~ name); writeln("add in LoadQt(... + "~ s ~" + ...)"); return; }
	pFunQt[n] = GetPrAddress(b, h, name); 
	if (!pFunQt[n]) MessageErrorLoad(she, name, s);
	maxValueInPFunQt = n;
	// writeln(name, " ", pFunQt[n]);
}

int LoadQt(dll ldll, bool showError) { ///  Загрузить DLL-ки Qt и QtE
	bool	bCore5, bGui5, bWidget5, bQtE6Widgets, bQtE6Script, bQtE6Web, bQtE6WebEng, bQtE6Qml, bQtE6Qscintilla, bQtE6core;
	string	sCore5, sGui5, sWidget5, sQtE6Widgets, sQtE6Script, sQtE6Web, sQtE6WebEng, sQtE6Qml, sQtE6Qscintilla, sQtE6core;
// 	void*	hCore5, hGui5, hWidget5, hQtE6Widgets, hQtE6Script, hQtE6Web, hQtE6WebEng, hQtE6Qml, hQtE6Qscintilla;

	// Add path to directory with real file Qt6 DLL
	version (Windows) {
		version (X86) {		// ... 32 bit code ...
			sCore5			= "Qt6Core.dll";
			sGui5			= "Qt6Gui.dll";
			sWidget5		= "Qt6Widgets.dll";
			sQtE6Widgets	= "QtE56Widgets32.dll";
			sQtE6Script		= "QtE6Script32.dll";
			sQtE6Web		= "QtE6Web32.dll";
			sQtE6WebEng		= "QtE6WebEng32.so";
			sQtE6Qml		= "QtE6Qml32.dll";
			sQtE6Qscintilla = "QtE6Qscintilla32.dll";
			sQtE6core       = "QtE56core32.dll";
		}
		version (X86_64) {	// ... 64 bit code
			sCore5			= "Qt6Core.dll";
			sGui5			= "Qt6Gui.dll";
			sWidget5		= "Qt6Widgets.dll";
			sQtE6Widgets	= "QtE56Widgets64.dll";
			sQtE6Script		= "QtE6Script64.dll";
			sQtE6Web		= "QtE6Web64.dll";
			sQtE6WebEng		= "QtE6WebEng64.so";
			sQtE6Qml		= "QtE6Qml64.dll";
			sQtE6Qscintilla = "QtE6Qscintilla64.dll";
			sQtE6core       = "QtE56core64.dll";
		}
	}
	// Use symlink for create link on real file Qt6
	version (linux) {
		version (X86) {		// ... 32 bit code ...
			sCore5			= "libQt6Core.so";
			sGui5			= "libQt6Gui.so";
			sWidget5		= "libQt6Widgets.so";
			sQtE6Widgets	= "libQtE56Widgets32.so";
			sQtE6Script		= "libQtE6Script32.so";
			sQtE6Web		= "libQtE6Web32.so";
			sQtE6WebEng		= "libQtE6WebEng32.so";
			sQtE6Qml		= "libQtE6Qml64.so";
			sQtE6Qscintilla = "libQtE6Qscintilla64.so";
			sQtE6core       = "libQtE56core32.so";
		}
		version (X86_64) {	// ... 64 bit code
			sCore5			= "libQt5Core.so";
			sGui5			= "libQt5Gui.so";
			sWidget5		= "libQt5Widgets.so";
			sQtE6Widgets	= "libQtE56Widgets64.so";
			sQtE6Script		= "libQtE5Script64.so";
			sQtE6Web		= "libQtE5Web64.so";
			sQtE6WebEng		= "libQtE5WebEng64.so";
			sQtE6Qml		= "libQtE5Qml64.so";
			sQtE6Qscintilla = "libQtE5Qscintilla64.so";
			// эксперементальная разноска
			sQtE6core       = "libQtE56core64.so";
		}
	}
	// Use symlink for create link on real file Qt6
	// Only 64 bit version Mac OS X (10.9.5 Maveric)
	version (OSX) {
		string[] libs = ["QtCore", "QtGui", "QtWidgets", "QtDBus" , "QtPrintSupport" /*  ,"libqcocoa.dylib" */ ];
		foreach(l; libs) {
			void* h = GetHlib(l);
		}
    	// sCore5			= "QtCore";
		// sGui5			= "QtGui";
		// sWidget5		= "QtWidgets";
		sQtE6Widgets	= "libQtE6Widgets64.dylib";
		sQtE6Script		= "libQtE6Script64.dylib";
		sQtE6Web		= "libQtE6Web64.dylib";
		sQtE6WebEng		= "libQtE6WebEng64.dylib";
		sQtE6Qml		= "libQtE6Qml64.dylib";
		sQtE6Qscintilla = "libQtE6Qscintilla64.dylib";
	}

	// Если на входе указана dll.QtE6Widgets то автоматом надо грузить и bCore5, bGui5, bWidget5
	// If on an input it is specified dll.QtE6Widgets then automatic loaded bCore5, bGui5, bWidget5
	bQtE6Widgets	= cast(bool)(ldll & dll.QtE6Widgets);
	if(bQtE6Widgets) { bCore5 = true; bGui5 = true; bWidget5 = true; }
	bQtE6Script 	= cast(bool)(ldll & dll.QtE6Script);
	bQtE6Web 		= cast(bool)(ldll & dll.QtE6Web);
	bQtE6Web 		= cast(bool)(ldll & dll.QtE6Web);
	bQtE6WebEng		= cast(bool)(ldll & dll.QtE6WebEng);
	bQtE6Qscintilla	= cast(bool)(ldll & dll.QtE6Qscintilla);
	// ----
	bQtE6core	    = cast(bool)(ldll & dll.QtE6core);


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
	if (bQtE6Widgets) {
		hQtE6Widgets = GetHlib(sQtE6Widgets); if (!hQtE6Widgets) { MessageErrorLoad(showError, sQtE6Widgets); return 1; }
	}
	if (bQtE6core) {
		hQtE6core = GetHlib(sQtE6core); if (!hQtE6core) { MessageErrorLoad(showError, sQtE6core); return 1; }
	}
	if (bQtE6Script) {
		hQtE6Script = GetHlib(sQtE6Script); if (!hQtE6Script) { MessageErrorLoad(showError, sQtE6Script); return 1; }
	}
	if (bQtE6Web) {
		hQtE6Web = GetHlib(sQtE6Web); if (!hQtE6Web) { MessageErrorLoad(showError, sQtE6Web); return 1; }
	}
	if (bQtE6WebEng) {
		hQtE6WebEng = GetHlib(sQtE6WebEng); if (!hQtE6WebEng) { MessageErrorLoad(showError, sQtE6WebEng); return 1; }
	}
	if (bQtE6Qml) {
		hQtE6Qml = GetHlib(sQtE6Qml); if (!hQtE6Qml) { MessageErrorLoad(showError, sQtE6Qml); return 1; }
	}
	if (bQtE6Qscintilla) {
		hQtE6Qscintilla = GetHlib(sQtE6Qscintilla); if (!hQtE6Qscintilla) { MessageErrorLoad(showError, sQtE6Qscintilla); return 1; }
	}
	// Find name function in DLL

	// ------- QObject -------
	mixin(generateFunQt(344, "qteQObject_parent","Widgets"));

	mixin(generateFunQt(700, "qteQPointer_create",     "Widgets"));
	mixin(generateFunQt(701, "qteQPointer_delete",     "Widgets"));
	mixin(generateFunQt(702, "qteQPointer_isNull",     "Widgets"));
	mixin(generateFunQt(490, "qteQObject_findChild",     "Widgets"));
	

	// ------- QApplication -------
	mixin(generateFunQt(	0,   	"qteQApplication_create1"			,"Widgets"));
	
	mixin(generateFunQt(	1,   	"qteQApplication_exe"				,"Widgets"));
	
	
	// mixin(generateFunQt(	1,   	"qteQApplication_exec"				,"Widgets"));
	// mixin(generateFunQt(	2,   	"qteQApplication_aboutQt"			,"Widgets"));
	
	mixin(generateFunQt(	3,   	"qteQApplication_delete1"			,"Widgets"));
	mixin(generateFunQt(	4,   	"qteQApplication_sizeof"			,"Widgets"));
	
	
	mixin(generateFunQt(   382,  	"QCoreApplication_setXX3"  			,"core"));
	mixin(generateFunQt(	20,  	"qteQAppCore_returnStr"  			,"Widgets"));
	
	
	
	mixin(generateFunQt(	21,  	"qteQApp_returnStr"					,"Widgets"));
	// mixin(generateFunQt(	273,  	"qteQApplication_quit"				,"Widgets"));
	// mixin(generateFunQt(	368,  	"qteQApplication_processEvents"		,"Widgets"));
	mixin(generateFunQt(	276,  	"qteQApplication_exit"				,"Widgets"));
	mixin(generateFunQt(	277,  	"qteQApplication_setStyleSheet"		,"Widgets"));

	// ------- QWidget -------
	mixin(generateFunQt(	5,   	"qteQWidget_create1"				,"Widgets"));
	mixin(generateFunQt(	6,   	"qteQWidget_setBoolNN"				,"Widgets"));
	mixin(generateFunQt(	7,   	"qteQWidget_delete1"				,"Widgets"));
	mixin(generateFunQt(	11,  	"qteQWidget_setStr"	   				,"Widgets"));

	mixin(generateFunQt(  1011,  	"QWidget_setXX5"	   				,"Widgets"));
	
	mixin(generateFunQt(	12,  	"qteQWidget_isVisible"				,"Widgets"));
	mixin(generateFunQt(	31,  	"qteQWidget_setMMSize"				,"Widgets"));
	mixin(generateFunQt(	33,  	"qteQLayout_setEnable2"				,"Widgets"));
	// mixin(generateFunQt(	33,  	"qteQWidget_setToolTip"				,"Widgets"));
	mixin(generateFunQt(	40,  	"qteQWidget_setLayout"				,"Widgets"));
	mixin(generateFunQt(	78,  	"qteQWidget_setSizePolicy"			,"Widgets"));
	mixin(generateFunQt(	79,  	"qteQWidget_setMax1"				,"Widgets"));
	mixin(generateFunQt(	87,  	"qteQWidget_exWin1"					,"Widgets"));
	mixin(generateFunQt(	94,  	"qteQWidget_exWin2"					,"Widgets"));
	mixin(generateFunQt(	49,  	"qteQWidget_setKeyPressEvent"		,"Widgets"));
	mixin(generateFunQt(	50,  	"qteQWidget_setPaintEvent"			,"Widgets"));
	mixin(generateFunQt(	51,  	"qteQWidget_setCloseEvent"			,"Widgets"));
	mixin(generateFunQt(	52,  	"qteQWidget_setResizeEvent"			,"Widgets"));
	mixin(generateFunQt(	131, 	"qteQWidget_setFont"				,"Widgets"));
	mixin(generateFunQt(	148, 	"qteQWidget_winId"					,"Widgets"));
	mixin(generateFunQt(	172, 	"qteQWidget_getPr"					,"Widgets"));
	mixin(generateFunQt(	259, 	"qteQWidget_getBoolXX"				,"Widgets"));
	mixin(generateFunQt(	279, 	"qteQWidget_setGeometry"			,"Widgets"));
	mixin(generateFunQt(	280, 	"qteQWidget_contentsRect"			,"Widgets"));
    mixin(generateFunQt(   	521, 	"qteQWidget_returnStr"				,"Widgets"));

	// ------- QString -------
	mixin(generateFunQt(	8,   	"qteQString_create1"				,"Widgets"));
	mixin(generateFunQt(	9,   	"qteQString_create2"				,"Widgets"));
	mixin(generateFunQt(	10,  	"qteQString_delete"					,"Widgets"));
	mixin(generateFunQt(	18,  	"qteQString_data"					,"Widgets"));
	mixin(generateFunQt(	19,  	"qteQString_size"					,"Widgets"));
	mixin(generateFunQt(	281, 	"qteQString_sizeOf"					,"Widgets"));

	// ------- QColor -------
	mixin(generateFunQt(	13,  	"qteQColor_create1"					,"Widgets"));
	mixin(generateFunQt(	14,  	"qteQColor_delete"					,"Widgets"));
	mixin(generateFunQt(	15,  	"qteQColor_setRgb"					,"Widgets"));
	mixin(generateFunQt(	320, 	"qteQColor_getRgb"					,"Widgets"));
	mixin(generateFunQt(	322, 	"qteQColor_rgb"						,"Widgets"));
	mixin(generateFunQt(	323, 	"qteQColor_setRgb2"					,"Widgets"));
	mixin(generateFunQt(	324, 	"qteQColor_create2"					,"Widgets"));

	// ------- QPalette -------
	mixin(generateFunQt(	16,  	"qteQPalette_create1"				,"Widgets"));
	mixin(generateFunQt(	17,  	"qteQPalette_delete"				,"Widgets"));

	// ------- QPushButton -------
	mixin(generateFunQt(	22,  	"qteQPushButton_create1"			,"Widgets"));
	mixin(generateFunQt(	23,  	"qteQPushButton_delete"				,"Widgets"));
	mixin(generateFunQt(	210, 	"qteQPushButton_setXX"				,"Widgets"));

	// ------- QWebView -------
	mixin(generateFunQt(	24,  	"qteQWebView_create"				,"Web"));
	mixin(generateFunQt(	25,  	"qteQWebView_delete"				,"Web"));
	mixin(generateFunQt(	26,  	"qteQWebView_load"					,"Web"));

	// ------- QUrl -------
	mixin(generateFunQt(	81,  	"qteQUrl_create"					,"Widgets"));
	mixin(generateFunQt(   173,  	"qteQUrl_delete"					,"Widgets"));
	mixin(generateFunQt(   444,  	"qteQUrl_setUrl"					,"Widgets"));
	
	// ------- QSlot -------
//	funQt(xx, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQSlot_create",            showError);
//	funQt(xx, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "QSlot_setSlotN",             showError);
//	funQt(xx, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQSlot_delete",            showError);
	mixin(generateFunQt(	27,  	"qteConnect"						,"Widgets"));
	mixin(generateFunQt(	343, 	"qteDisconnect"						,"Widgets"));
//	funQt(xx, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "QSlot_setSlotN2",            showError);

	// ------- QStringList -------
	mixin(generateFunQt(	680,  	"qteQStringList_create1"	    	,"Widgets"));
	mixin(generateFunQt(	679, 	"qteQStringList_delete1"     		,"Widgets"));
	mixin(generateFunQt(	678, 	"qteQStringList_set"        		,"Widgets"));
	mixin(generateFunQt(	677, 	"qteQStringList_getInt"        		,"Widgets"));
	mixin(generateFunQt(	676, 	"qteQStringList_getQStr1"        	,"Widgets"));
	
	// ------- QAbstractButton -------
	mixin(generateFunQt(	28,  	"qteQAbstractButton_setText"		,"Widgets"));
	mixin(generateFunQt(	29,  	"qteQAbstractButton_text"			,"Widgets"));
	mixin(generateFunQt(	209, 	"qteQAbstractButton_setXX"			,"Widgets"));
	mixin(generateFunQt(	211, 	"qteQAbstractButton_setIcon"		,"Widgets"));
	// mixin(generateFunQt(	224, 	"qteQAbstractButton_getXX"			,"Widgets")); // 224 ОСВОБОЖДЕНО

	// ------- QCommandLinkButton -------
	mixin(generateFunQt(	694,    "qteQCommandLinkButton_create2"		,"Widgets"));
	mixin(generateFunQt(	695,    "qteQCommandLinkButton_create1"		,"Widgets"));
	mixin(generateFunQt(	697, 	"qteQCommandLinkButton_create"		,"Widgets"));
	mixin(generateFunQt(	696, 	"qteQCommandLinkButton_delete"		,"Widgets"));
	mixin(generateFunQt(	693, 	"qteQCommandLinkButton_setDiscript" ,"Widgets"));

	// ------- QLayout -------
	mixin(generateFunQt(	34,  	"qteQBoxLayout"						,"Widgets"));
	mixin(generateFunQt(	35,  	"qteQVBoxLayout"					,"Widgets"));
	mixin(generateFunQt(	36,  	"qteQHBoxLayout"					,"Widgets"));
	mixin(generateFunQt(	37,  	"qteQHBoxLayout_delete"				,"Widgets"));
	mixin(generateFunQt(	30,  	"qteQVBoxLayout_delete"				,"Widgets"));
	
	mixin(generateFunQt(	32,  	"qteQBoxLayout_delete"				,"Widgets"));
	mixin(generateFunQt(	38,  	"qteQBoxLayout_addWidget"			,"Widgets"));
	mixin(generateFunQt(	39,  	"qteQBoxLayout_addLayout"			,"Widgets"));
	mixin(generateFunQt(	74,  	"qteQBoxLayout_setSpacing"			,"Widgets"));
	mixin(generateFunQt(	474,  	"qteQBoxLayout_setSpacing2"			,"Widgets"));
	
	mixin(generateFunQt(	75,  	"qteQBoxLayout_spacing"				,"Widgets"));
	mixin(generateFunQt(	76,  	"qteQBoxLayout_setMargin"			,"Widgets"));
	mixin(generateFunQt(	77,  	"qteQBoxLayout_margin"				,"Widgets"));

	// ------- QFrame -------
	mixin(generateFunQt(	41,  	"qteQFrame_create1"					,"Widgets"));
	mixin(generateFunQt(	42,  	"qteQFrame_delete1"					,"Widgets"));
	mixin(generateFunQt(	43,  	"qteQFrame_setFrameShape"			,"Widgets"));
	mixin(generateFunQt(	44,  	"qteQFrame_setFrameShadow"			,"Widgets"));
	mixin(generateFunQt(	45,  	"QFrame_set1"						,"Widgets"));
	mixin(generateFunQt(	290, 	"qteQFrame_listChildren"			,"Widgets"));

	// ------- QLabel --------
	mixin(generateFunQt(	46,  	"qteQLabel_create1"					,"Widgets"));
	mixin(generateFunQt(	47,  	"qteQLabel_delete1"					,"Widgets"));
	mixin(generateFunQt(	48,  	"qteQLabel_setText"					,"Widgets"));
	mixin(generateFunQt(   522,  	"qteQLabel_setAligment"				,"Widgets"));

	// ------- QTabWidget --------
	mixin(generateFunQt(	492,  	"QTabWidget_create1"				,"Widgets"));
	mixin(generateFunQt(	493,  	"QTabWidget_delete1"				,"Widgets"));
	mixin(generateFunQt(	494,  	"QTabWidget_addTab1"				,"Widgets"));
	mixin(generateFunQt(	495,  	"QTabWidget_addTab2"				,"Widgets"));
	mixin(generateFunQt(	496,  	"QTabWidget_set1"					,"Widgets"));
	mixin(generateFunQt(	497,  	"QTabWidget_set2"					,"Widgets"));
	mixin(generateFunQt(	498,  	"QTabWidget_set3"					,"Widgets"));
	mixin(generateFunQt(	499,  	"QTabWidget_set4"					,"Widgets"));

	// ------- QSplitter --------
	mixin(generateFunQt(	480,  	"qteQSplitter_create1"				,"Widgets"));
	mixin(generateFunQt(	481,  	"qteQSplitter_delete1"				,"Widgets"));
	mixin(generateFunQt(	482,  	"qteQSplitter_addWidgetXX1"			,"Widgets"));
	mixin(generateFunQt(	273,  	"QSplitter_set1"					,"Widgets"));

	// ------- QDockWidget --------
	mixin(generateFunQt(	475,  	"qteQDockWidget_create1"			,"Widgets"));
	mixin(generateFunQt(	476,  	"qteQDockWidget_delete1"			,"Widgets"));
	mixin(generateFunQt(	478,  	"qteQDockWidget_setAllowedAreas"	,"Widgets"));
	mixin(generateFunQt(	479, 	"qteQDockWidget_setXX"				,"Widgets"));

	// ------- QEvent -------
	mixin(generateFunQt(	53,  	"qteQEvent_type"					,"Widgets"));
	mixin(generateFunQt(	157, 	"qteQEvent_ia"						,"Widgets"));

	// ------- QResizeEvent -------
	mixin(generateFunQt(	54,  	"qteQResizeEvent_size"				,"Widgets"));
	mixin(generateFunQt(	55,  	"qteQResizeEvent_oldSize"			,"Widgets"));

	// ------- QSize -------
	mixin(generateFunQt(  1056,  	"qteQSize_create1"					,"core"));
	mixin(generateFunQt(  1057,  	"qteQSize_delete1"					,"core"));
	mixin(generateFunQt(  1058,  	"QSize_setXX2"					    ,"core"));
/*
	mixin(generateFunQt(	58,  	"qteQSize_width"					,"Widgets"));
	mixin(generateFunQt(	59,  	"qteQSize_height"					,"Widgets"));
	mixin(generateFunQt(	60,  	"qteQSize_setWidth"					,"Widgets"));
	mixin(generateFunQt(	61,  	"qteQSize_setHeight"				,"Widgets"));
*/
	// ------- QKeyEvent -------
	mixin(generateFunQt(	62,  	"qteQKeyEvent_key"					,"Widgets"));
	mixin(generateFunQt(	63, 	"qteQKeyEvent_count"				,"Widgets"));
	mixin(generateFunQt(	285,	"qteQKeyEvent_modifiers"			,"Widgets"));

	// ------- QAbstractScrollArea -------
	mixin(generateFunQt(	64, 	"qteQAbstractScrollArea_create1"	,"Widgets"));
	mixin(generateFunQt(	65, 	"qteQAbstractScrollArea_delete1"	,"Widgets"));

	// ------- QPlainTextEdit -------
	mixin(generateFunQt(	66, 	"qteQPlainTextEdit_create1"			,"Widgets"));
	mixin(generateFunQt(	67, 	"qteQPlainTextEdit_delete1"			,"Widgets"));
	mixin(generateFunQt(	68, 	"qteQPlainTextEdit_appendPlainText"	,"Widgets"));
	mixin(generateFunQt(	69, 	"qteQPlainTextEdit_appendHtml"		,"Widgets"));
	mixin(generateFunQt(	70, 	"qteQPlainTextEdit_setPlainText"	,"Widgets"));
	mixin(generateFunQt(	71, 	"qteQPlainTextEdit_insertPlainText"	,"Widgets"));
	mixin(generateFunQt(	72, 	"qteQPlainTextEdit_cutn"			,"Widgets"));
	mixin(generateFunQt(	73, 	"qteQPlainTextEdit_toPlainText"		,"Widgets"));
	mixin(generateFunQt(	80, 	"qteQPlainTextEdit_setKeyPressEvent","Widgets"));
	mixin(generateFunQt(	225,	"qteQPlainTextEdit_setKeyReleaseEvent","Widgets"));
	mixin(generateFunQt(	226,	"qteQPlainTextEdit_document"		,"Widgets"));
	mixin(generateFunQt(	230,	"qteQPlainTextEdit_textCursor"		,"Widgets"));
	mixin(generateFunQt(	235,	"qteQPlainTextEdit_cursorRect"		,"Widgets"));
	mixin(generateFunQt(	235,	"qteQPlainTextEdit_cursorRect"		,"Widgets"));
	mixin(generateFunQt(	236,	"qteQPlainTextEdit_setTabStopWidth"	,"Widgets"));
	mixin(generateFunQt(	253,	"qteQPlainTextEdit_setTextCursor"	,"Widgets"));
	mixin(generateFunQt(	278,	"qteQPlainTextEdit_setViewportMargins","Widgets"));
	mixin(generateFunQt(	282,	"qteQPlainTextEdit_firstVisibleBlock","Widgets"));
	mixin(generateFunQt(	284,	"qteQPlainTextEdit_getXYWH"			,"Widgets"));
	mixin(generateFunQt(	294,	"qteQPlainTextEdit_setWordWrapMode"	,"Widgets"));
	mixin(generateFunQt(	325,	"eQPlainTextEdit_setPaintEvent"		,"Widgets"));
	mixin(generateFunQt(	326,	"qteQPlainTextEdit_getXX1"			,"Widgets"));
	mixin(generateFunQt(	328,	"qteQPlainTextEdit_setCursorPosition","Widgets"));
	mixin(generateFunQt(	329,	"qteQPlainTextEdit_find1"			,"Widgets"));
	mixin(generateFunQt(	330,	"qteQPlainTextEdit_find2"			,"Widgets"));

	//  ------- QLineEdit -------
	mixin(generateFunQt(	82, 	"qteQLineEdit_create1"				,"Widgets"));
	mixin(generateFunQt(	83, 	"qteQLineEdit_delete1"				,"Widgets"));
	mixin(generateFunQt(	84, 	"qteQLineEdit_set"					,"Widgets"));
	mixin(generateFunQt(	85, 	"qteQLineEdit_clear"				,"Widgets"));
	mixin(generateFunQt(	86, 	"qteQLineEdit_text"					,"Widgets"));
	mixin(generateFunQt(	158,	"qteQLineEdit_setKeyPressEvent"		,"Widgets"));
	mixin(generateFunQt(	287,	"qteQLineEdit_setX1"				,"Widgets"));
	mixin(generateFunQt(	288,	"qteQLineEdit_getX1"				,"Widgets"));

	//  ------- QMainWindow -------
	mixin(generateFunQt(	88, 	"qteQMainWindow_create1"			,"Widgets"));
	mixin(generateFunQt(	89, 	"qteQMainWindow_delete1"			,"Widgets"));
	mixin(generateFunQt(	90, 	"qteQMainWindow_setXX"				,"Widgets"));
	mixin(generateFunQt(	126, 	"qteQMainWindow_addToolBar"			,"Widgets"));
	mixin(generateFunQt(	477, 	"qteQMainWindow_addDockWidget"		,"Widgets"));

	//  ------- QStatusBar -------
	mixin(generateFunQt(	91, 	"qteQStatusBar_create1"				,"Widgets"));
	mixin(generateFunQt(	92, 	"qteQStatusBar_delete1"				,"Widgets"));
	mixin(generateFunQt(	93, 	"qteQStatusBar_showMessage"			,"Widgets"));
	mixin(generateFunQt(	314,	"qteQStatusBar_addWidgetXX1"		,"Widgets"));

	//  ------- QAction -------
	mixin(generateFunQt(	95, 	"qteQAction_create"					,"Widgets"));
	mixin(generateFunQt(	96, 	"qteQAction_delete"					,"Widgets"));
	mixin(generateFunQt(	289,	"qteQAction_getParent"				,"Widgets"));
	mixin(generateFunQt(	97, 	"qteQAction_setXX1"					,"Widgets"));
	mixin(generateFunQt(	98, 	"qteQAction_setSlotN2"				,"Widgets"));

	mixin(generateFunQt(	105,  	"qteQAction_setHotKey"				,"Widgets"));
	mixin(generateFunQt(	109,  	"qteQAction_setEnabled"				,"Widgets"));
	mixin(generateFunQt(	113,  	"qteQAction_setIcon"				,"Widgets"));
	mixin(generateFunQt(	339,  	"qteQAction_SendSignal_V"			,"Widgets"));
	mixin(generateFunQt(	340,  	"qteQAction_SendSignal_VI"			,"Widgets"));
	mixin(generateFunQt(	341,  	"qteQAction_SendSignal_VS"			,"Widgets"));
	mixin(generateFunQt(	473,  	"qteQAction_boolAll"				,"Widgets"));

	//  ------- QMenu -------
	mixin(generateFunQt(	99,   	"qteQMenu_create"					,"Widgets"));
	mixin(generateFunQt(	100,  	"qteQMenu_delete"					,"Widgets"));
	mixin(generateFunQt(	101,  	"qteQMenu_addAction"				,"Widgets"));
	mixin(generateFunQt(	106,  	"qteQMenu_setTitle"					,"Widgets"));
	mixin(generateFunQt(	107,  	"qteQMenu_addSeparator"				,"Widgets"));
	mixin(generateFunQt(	108,  	"qteQMenu_addMenu"					,"Widgets"));

	//  ------- QMenuBar -------
	mixin(generateFunQt(	102,  	"qteQMenuBar_create"				,"Widgets"));
	mixin(generateFunQt(	103,  	"qteQMenuBar_delete"				,"Widgets"));
	mixin(generateFunQt(	104,  	"qteQMenuBar_addMenu"				,"Widgets"));

	//  ------- QIcon -------
	mixin(generateFunQt(	110,  	"qteQIcon_create"					,"Widgets"));
	mixin(generateFunQt(	111,  	"qteQIcon_delete"					,"Widgets"));
	mixin(generateFunQt(	112,  	"qteQIcon_addFile"					,"Widgets"));
	mixin(generateFunQt(	377,  	"qteQIcon_addFile2"					,"Widgets"));
	mixin(generateFunQt(	378,  	"qteQIcon_swap"						,"Widgets"));

	//  ------- QToolBar -------
	mixin(generateFunQt(	114,  	"qteQToolBar_create"				,"Widgets"));
	mixin(generateFunQt(	115,  	"qteQToolBar_delete"				,"Widgets"));
	mixin(generateFunQt(	116,  	"qteQToolBar_setXX1"				,"Widgets"));
	mixin(generateFunQt(	124,  	"qteQToolBar_setAllowedAreas"		,"Widgets"));
	mixin(generateFunQt(	125,  	"qteQToolBar_setToolButtonStyle"	,"Widgets"));
	mixin(generateFunQt(	132,  	"qteQToolBar_addSeparator"			,"Widgets"));

	//  ------- QDialog -------
	mixin(generateFunQt(	117, 	"qteQDialog_create"					,"Widgets"));
	mixin(generateFunQt(	118, 	"qteQDialog_delete"					,"Widgets"));
	mixin(generateFunQt(	306, 	"QDialog_setXX1"					,"Widgets"));

	//  ------- QDialog -------
	mixin(generateFunQt(	120, 	"qteQMessageBox_create"				,"Widgets"));
	mixin(generateFunQt(	121, 	"qteQMessageBox_delete"				,"Widgets"));
	mixin(generateFunQt(	122, 	"QMessageBox_setXX1"				,"Widgets"));
	mixin(generateFunQt(	123, 	"QMessageBox_setXX2"				,"Widgets"));

	//  ------- QFont -------
	mixin(generateFunQt(	127, 	"qteQFont_create"					,"Widgets"));
	mixin(generateFunQt(	128, 	"qteQFont_delete"					,"Widgets"));
	mixin(generateFunQt(	129, 	"qteQFont_setPointSize"				,"Widgets"));
	mixin(generateFunQt(	130, 	"qteQFont_setFamily"				,"Widgets"));
	mixin(generateFunQt(	312, 	"qteQFont_setBoolXX1"				,"Widgets"));
	mixin(generateFunQt(	313, 	"qteQFont_getBoolXX1"				,"Widgets"));

	//  ------- QProgressBar -------
	mixin(generateFunQt(	133, 	"qteQProgressBar_create"			,"Widgets"));
	mixin(generateFunQt(	134, 	"qteQProgressBar_delete"			,"Widgets"));
	mixin(generateFunQt(	135, 	"qteQProgressBar_setPr"				,"Widgets"));

	//  ------- QDate -------
	mixin(generateFunQt(	136, 	"qteQDate_create"					,"Widgets"));
	mixin(generateFunQt(	137, 	"qteQDate_delete"					,"Widgets"));
	mixin(generateFunQt(	140, 	"qteQDate_toString"					,"Widgets"));

	//  ------- QTime -------
	mixin(generateFunQt(	138, 	"qteQTime_create"					,"Widgets"));
	mixin(generateFunQt(	139, 	"qteQTime_delete"					,"Widgets"));
	mixin(generateFunQt(	141, 	"qteQTime_toString"					,"Widgets"));

	//  ------- QFileDialog -------
	mixin(generateFunQt(	142, 	"qteQFileDialog_create"				,"Widgets"));
	mixin(generateFunQt(	143, 	"qteQFileDialog_delete"				,"Widgets"));
	mixin(generateFunQt(	144, 	"qteQFileDialog_setNameFilter"		,"Widgets"));
	mixin(generateFunQt(	145, 	"qteQFileDialog_setViewMode"		,"Widgets"));
	mixin(generateFunQt(	146, 	"qteQFileDialog_getOpenFileName"	,"Widgets"));
	mixin(generateFunQt(	147, 	"qteQFileDialog_getSaveFileName"	,"Widgets"));
	mixin(generateFunQt(	274, 	"qteQFileDialog_stGetOpenFileName"	,"Widgets"));
	mixin(generateFunQt(	275, 	"qteQFileDialog_stGetSaveFileName"	,"Widgets"));

	//  ------- QAbstractScrollArea -------
	mixin(generateFunQt(	149, 	"qteQAbstractScrollArea_create"		,"Widgets"));
	mixin(generateFunQt(	150, 	"qteQAbstractScrollArea_delete"		,"Widgets"));

	//  ------- QMdiArea -------
	mixin(generateFunQt(	151, 	"qteQMdiArea_create"				,"Widgets"));
	mixin(generateFunQt(	152, 	"qteQMdiArea_delete"				,"Widgets"));
	mixin(generateFunQt(	155, 	"qteQMdiArea_addSubWindow"			,"Widgets"));
	mixin(generateFunQt(	338, 	"qteQMdiArea_activeSubWindow"		,"Widgets"));

	//  ------- QMdiSubWindow -------
	mixin(generateFunQt(	153, 	"qteQMdiSubWindow_create"			,"Widgets"));
	mixin(generateFunQt(	154, 	"qteQMdiSubWindow_delete"			,"Widgets"));
	mixin(generateFunQt(	156, 	"qteQMdiSubWindow_addLayout"		,"Widgets"));

	//  ------- QTableView -------
	mixin(generateFunQt(	159, 	"qteQTableView_create"				,"Widgets"));
	mixin(generateFunQt(	160, 	"qteQTableView_delete"				,"Widgets"));
	mixin(generateFunQt(	174, 	"qteQTableView_setN1"				,"Widgets"));
	mixin(generateFunQt(	175, 	"qteQTableView_getN1"				,"Widgets"));
	mixin(generateFunQt(	182, 	"qteQTableView_ResizeMode"			,"Widgets"));

	//  ------- QTableWidget -------
	mixin(generateFunQt(	161, 	"qteQTableWidget_create"			,"Widgets"));
	mixin(generateFunQt(	162, 	"qteQTableWidget_delete"			,"Widgets"));
	mixin(generateFunQt(	163, 	"qteQTableWidget_setRC"				,"Widgets"));
	mixin(generateFunQt(	167, 	"qteQTableWidget_setItem"			,"Widgets"));
	mixin(generateFunQt(	176, 	"qteQTableWidget_setHVheaderItem"	,"Widgets"));
	mixin(generateFunQt(	241, 	"qteQTableWidget_setCurrentCell"	,"Widgets"));
	mixin(generateFunQt(	369, 	"qteQTableWidget_getCurrent"		,"Widgets"));
	mixin(generateFunQt(	370, 	"qteQTableWidget_item"				,"Widgets"));
	mixin(generateFunQt(	371, 	"qteQTableWidget_takeItem"			,"Widgets"));

	//  ------- QTableWidgetItem -------
	mixin(generateFunQt(	164, 	"qteQTableWidgetItem_create"		,"Widgets"));
	mixin(generateFunQt(	165, 	"qteQTableWidgetItem_delete"		,"Widgets"));
	mixin(generateFunQt(	166, 	"qteQTableWidgetItem_setXX"			,"Widgets"));
	mixin(generateFunQt(	168, 	"qteQTableWidgetItem_setYY"			,"Widgets"));
	mixin(generateFunQt(	169, 	"qteQTableWidget_item"				,"Widgets"));
	mixin(generateFunQt(	170, 	"qteQTableWidgetItem_text"			,"Widgets"));
	mixin(generateFunQt(	171, 	"qteQTableWidgetItem_setAlignment"	,"Widgets"));
	mixin(generateFunQt(	180, 	"qteQTableWidgetItem_setBackground"	,"Widgets"));
	mixin(generateFunQt(	372, 	"qteQTableWidgetItem_setFlags"		,"Widgets"));
	mixin(generateFunQt(	373, 	"qteQTableWidgetItem_flags"			,"Widgets"));
	mixin(generateFunQt(	374, 	"qteQTableWidgetItem_setSelected"	,"Widgets"));
	mixin(generateFunQt(	375, 	"qteQTableWidgetItem_isSelected"	,"Widgets"));
	mixin(generateFunQt(	376, 	"qteQTableWidgetItem_setIcon"		,"Widgets"));

	//  ------- QBrush -------
	mixin(generateFunQt(	177, 	"qteQBrush_create1"					,"Widgets"));
	mixin(generateFunQt(	178, 	"qteQBrush_delete"					,"Widgets"));
	mixin(generateFunQt(	179, 	"qteQBrush_setColor"				,"Widgets"));
	mixin(generateFunQt(	181, 	"qteQBrush_setStyle"				,"Widgets"));

	//  ------- QComboBox -------
	mixin(generateFunQt(	183, 	"qteQComboBox_create"				,"Widgets"));
	mixin(generateFunQt(	184, 	"qteQComboBox_delete"				,"Widgets"));
	mixin(generateFunQt(	185, 	"qteQComboBox_setXX"				,"Widgets"));
	mixin(generateFunQt(	186, 	"qteQComboBox_getXX"				,"Widgets"));
	mixin(generateFunQt(	187, 	"qteQComboBox_text"					,"Widgets"));

	//  ------- QPainter -------
	mixin(generateFunQt(	301, 	"qteQPainter_create"				,"Widgets"));
	mixin(generateFunQt(	302, 	"qteQPainter_delete"				,"Widgets"));
	mixin(generateFunQt(	188, 	"qteQPainter_drawPoint"				,"Widgets"));
	mixin(generateFunQt(	189, 	"qteQPainter_drawLine"				,"Widgets"));
	mixin(generateFunQt(	190, 	"qteQPainter_setXX1"				,"Widgets"));
	mixin(generateFunQt(	196, 	"qteQPainter_setText"				,"Widgets"));
	mixin(generateFunQt(	197, 	"qteQPainter_end"					,"Widgets"));
	mixin(generateFunQt(	243, 	"qteQPainter_drawRect1"				,"Widgets"));
	mixin(generateFunQt(	244, 	"qteQPainter_drawRect2"				,"Widgets"));
	mixin(generateFunQt(	245, 	"qteQPainter_fillRect2"				,"Widgets"));
	mixin(generateFunQt(	246, 	"qteQPainter_fillRect3"				,"Widgets"));
	mixin(generateFunQt(	298, 	"qteQPainter_getFont"				,"Widgets"));
	mixin(generateFunQt(	310, 	"qteQPainter_drawImage1"			,"Widgets"));
	mixin(generateFunQt(	311, 	"qteQPainter_drawImage2"			,"Widgets"));

	//  ------- QPen -------
	mixin(generateFunQt(	191, 	"qteQPen_create1"					,"Widgets"));
	mixin(generateFunQt(	192, 	"qteQPen_delete"					,"Widgets"));
	mixin(generateFunQt(	193, 	"qteQPen_setColor"					,"Widgets"));
	mixin(generateFunQt(	194, 	"qteQPen_setStyle"					,"Widgets"));
	mixin(generateFunQt(	195, 	"qteQPen_setWidth"					,"Widgets"));

	//  ------- QLCDNumber -------
	mixin(generateFunQt(	198, 	"qteQLCDNumber_create1"				,"Widgets"));
	mixin(generateFunQt(	199, 	"qteQLCDNumber_delete1"				,"Widgets"));
	mixin(generateFunQt(	200, 	"qteQLCDNumber_create2"				,"Widgets"));
	mixin(generateFunQt(	201, 	"qteQLCDNumber_display"				,"Widgets"));
	mixin(generateFunQt(	202, 	"qteQLCDNumber_setSegmentStyle"		,"Widgets"));
	mixin(generateFunQt(	203, 	"qteQLCDNumber_setDigitCount"		,"Widgets"));
	mixin(generateFunQt(	204, 	"qteQLCDNumber_setMode"				,"Widgets"));

	//  ------- QAbstractSlider -------
	mixin(generateFunQt(	205, 	"qteQAbstractSlider_setXX"			,"Widgets"));
	mixin(generateFunQt(	208, 	"qteQAbstractSlider_getXX"			,"Widgets"));

	//  ------- QSlider -------
	mixin(generateFunQt(	206, 	"qteQSlider_create1"				,"Widgets"));
	mixin(generateFunQt(	207, 	"qteQSlider_delete1"				,"Widgets"));

	//  ------- QGroupBox -------
	mixin(generateFunQt(	212, 	"qteQGroupBox_create"				,"Widgets"));
	mixin(generateFunQt(	213, 	"qteQGroupBox_delete"				,"Widgets"));
	mixin(generateFunQt(	214, 	"qteQGroupBox_setTitle"				,"Widgets"));
	mixin(generateFunQt(	215, 	"qteQGroupBox_setAlignment"			,"Widgets"));

	//  ------- QCheckBox -------
	mixin(generateFunQt(	216, 	"qteQCheckBox_create1"				,"Widgets"));
	mixin(generateFunQt(	217, 	"qteQCheckBox_delete"				,"Widgets"));
	mixin(generateFunQt(	218, 	"qteQCheckBox_checkState"			,"Widgets"));
	mixin(generateFunQt(	219, 	"qteQCheckBox_setCheckState"		,"Widgets"));
	mixin(generateFunQt(	220, 	"qteQCheckBox_setTristate"			,"Widgets"));
	mixin(generateFunQt(	221, 	"qteQCheckBox_isTristate"			,"Widgets"));

	//  ------- QRadioButton -------
	mixin(generateFunQt(	222, 	"qteQRadioButton_create1"			,"Widgets"));
	mixin(generateFunQt(	223, 	"qteQRadioButton_delete"			,"Widgets"));

	//  ------- QTextCursor -------
	mixin(generateFunQt(	227, 	"qteQTextCursor_create1"			,"Widgets"));
	mixin(generateFunQt(	228, 	"qteQTextCursor_delete"				,"Widgets"));
	mixin(generateFunQt(	229, 	"qteQTextCursor_create2"			,"Widgets"));
	mixin(generateFunQt(	231, 	"qteQTextCursor_getXX1"				,"Widgets"));
	mixin(generateFunQt(	254, 	"qteQTextCursor_movePosition"		,"Widgets"));
	mixin(generateFunQt(	255, 	"qteQTextCursor_runXX"				,"Widgets"));
	mixin(generateFunQt(	256, 	"qteQTextCursor_insertText1"		,"Widgets"));
	mixin(generateFunQt(	286, 	"qteQTextCursor_select"				,"Widgets"));
	mixin(generateFunQt(	327, 	"qteQTextCursor_setPosition"		,"Widgets"));

	//  ------- QRect -------
	mixin(generateFunQt(	232, 	"qteQRect_create1"					,"core"));
	mixin(generateFunQt(	233, 	"qteQRect_delete"					,"core"));
	// mixin(generateFunQt(	234, 	"qteQRect_setXX1"					,"Widgets")); // Свободен 234
	mixin(generateFunQt(	242, 	"qteQRect_setXX2"					,"core"));
	// -------------------
	mixin(generateFunQt(   1234, 	"QRect_setXX1"						,"core"));
	mixin(generateFunQt(   1235, 	"qteQRect_create2"					,"core"));

	//  ------- QTextBlock -------
	mixin(generateFunQt(	237, 	"qteQTextBlock_text"				,"Widgets"));
	mixin(generateFunQt(	238, 	"qteQTextBlock_create"				,"Widgets"));
	mixin(generateFunQt(	239, 	"qteQTextBlock_delete"				,"Widgets"));
	mixin(generateFunQt(	240, 	"qteQTextBlock_create2"				,"Widgets"));
	mixin(generateFunQt(	283, 	"qteQTextBlock_blockNumber"			,"Widgets"));
	mixin(generateFunQt(	299, 	"qteQTextBlock_next2"				,"Widgets"));
	mixin(generateFunQt(	300, 	"qteQTextBlock_isValid2"			,"Widgets"));

	//  ------- QSpinBox -------
	mixin(generateFunQt(	247, 	"qteQSpinBox_create"				,"Widgets"));
	mixin(generateFunQt(	248, 	"qteQSpinBox_delete"				,"Widgets"));
	mixin(generateFunQt(	249, 	"qteQSpinBox_setXX1"				,"Widgets"));
	mixin(generateFunQt(	250, 	"qteQSpinBox_getXX1"				,"Widgets"));
	mixin(generateFunQt(	251, 	"qteQSpinBox_setXX2"				,"Widgets"));

	//  ------- QAbstractSpinBox -------
	mixin(generateFunQt(	252, 	"QAbstractSpinBox_setXX1"			,"Widgets"));
	mixin(generateFunQt(	119, 	"QAbstractSpinBox_setXX2"			,"Widgets"));

	//  ------- QDateTimeEdit -------
	mixin(generateFunQt(	483, 	"qteQDateTimeEdit_create"			,"Widgets"));
	mixin(generateFunQt(	485, 	"qteQDateTimeEdit_create2"			,"Widgets"));
	mixin(generateFunQt(	484, 	"qteQDateTimeEdit_delete"			,"Widgets"));
	mixin(generateFunQt(	486, 	"qteQDateTimeEdit_toString"			,"Widgets"));
	mixin(generateFunQt(	491, 	"qteQDateTimeEdit_fromString"		,"Widgets"));

	//  ------- QFormBuilder -------
	mixin(generateFunQt(	487, 	"qteQFormBuilder_create1"			,"Widgets"));
	mixin(generateFunQt(	488, 	"qteQFormBuilder_delete"			,"Widgets"));
	mixin(generateFunQt(	489, 	"qteQFormBuilder_load"				,"Widgets"));

	//  ------- Highlighter -- Временный, подлежит в дальнейшем удалению -----
	mixin(generateFunQt(	257, 	"qteHighlighter_create"				,"Widgets"));
	mixin(generateFunQt(	258, 	"qteHighlighter_delete"				,"Widgets"));
	
	//  ------- HighlighterM -- Временный, подлежит в дальнейшем удалению -----
	mixin(generateFunQt(	442, 	"qteHighlighterM_create"				,"Widgets"));
	mixin(generateFunQt(	443, 	"qteHighlighterM_delete"				,"Widgets"));

	// ------- QTextEdit -------
	mixin(generateFunQt(	260, 	"qteQTextEdit_create1"				,"Widgets"));
	mixin(generateFunQt(	261, 	"qteQTextEdit_delete1"				,"Widgets"));
	mixin(generateFunQt(	270, 	"qteQTextEdit_setFromString"		,"Widgets"));
	mixin(generateFunQt(	271, 	"qteQTextEdit_toString"				,"Widgets"));
	mixin(generateFunQt(	272, 	"qteQTextEdit_cutn"					,"Widgets"));
	mixin(generateFunQt(	345, 	"qteQTextEdit_setBool"				,"Widgets"));
	mixin(generateFunQt(	346, 	"qteQTextEdit_toBool"				,"Widgets"));

	// ------- QTimer -------
	mixin(generateFunQt(	262, 	"qteQTimer_create"					,"Widgets"));
	mixin(generateFunQt(	263, 	"qteQTimer_delete"					,"Widgets"));
	mixin(generateFunQt(	264, 	"qteQTimer_setInterval"				,"Widgets"));
	mixin(generateFunQt(	265, 	"qteQTimer_getXX1"					,"Widgets"));
	mixin(generateFunQt(	266, 	"qteQTimer_getXX2"					,"Widgets"));
	mixin(generateFunQt(	267, 	"qteQTimer_setTimerType"			,"Widgets"));
	mixin(generateFunQt(	268, 	"qteQTimer_setSingleShot"			,"Widgets"));
	mixin(generateFunQt(	269, 	"qteQTimer_timerType"				,"Widgets"));
	mixin(generateFunQt(	342, 	"qteQTimer_setStartInterval"		,"Widgets"));

	// ------- QTextOption -------
	mixin(generateFunQt(	291, 	"QTextOption_create"				,"Widgets"));
	mixin(generateFunQt(	292, 	"QTextOption_delete"				,"Widgets"));
	mixin(generateFunQt(	293, 	"QTextOption_setWrapMode"			,"Widgets"));

	// ------- QFontMetrics -------
	mixin(generateFunQt(	295, 	"QFontMetrics_create"				,"Widgets"));
	mixin(generateFunQt(	296, 	"QFontMetrics_delete"				,"Widgets"));
	mixin(generateFunQt(	297, 	"QFontMetrics_getXX1"				,"Widgets"));

	// ------- QImage -------
	mixin(generateFunQt(	303, 	"qteQImage_create1"					,"Widgets"));
	mixin(generateFunQt(	304, 	"qteQImage_delete"					,"Widgets"));
	mixin(generateFunQt(	305, 	"qteQImage_load"					,"Widgets"));
	mixin(generateFunQt(	315, 	"qteQImage_create2"					,"Widgets"));

	mixin(generateFunQt(	316, 	"qteQImage_fill1"					,"Widgets"));
	mixin(generateFunQt(	317, 	"qteQImage_fill2"					,"Widgets"));
	mixin(generateFunQt(	318, 	"qteQImage_setPixel1"				,"Widgets"));
	mixin(generateFunQt(	319, 	"qteQImage_getXX1"					,"Widgets"));
	mixin(generateFunQt(	321, 	"qteQImage_pixel"					,"Widgets"));

	// ------- QPoint -------
	// mixin(generateFunQt(	306, 	"qteQPoint_create1"					,"Widgets"));
	// mixin(generateFunQt(	307, 	"qteQPoint_delete"					,"Widgets"));
	// // 308
	// mixin(generateFunQt(	309, 	"qteQPoint_getXX1"					,"Widgets"));
	
	mixin(generateFunQt(   1306, 	"qteQPoint_create1"					,"core"));
	mixin(generateFunQt(   1307, 	"qteQPoint_delete1"					,"core"));
	mixin(generateFunQt(   1308, 	"QPoint_setXX1"						,"core"));
	mixin(generateFunQt(   1309, 	"QPoint_setXX3"						,"core"));

	// ------- QGridLayout -------
	mixin(generateFunQt(	330, 	"qteQGridLayout_create1"			,"Widgets"));
	mixin(generateFunQt(	331, 	"qteQGridLayout_delete"				,"Widgets"));
	mixin(generateFunQt(	332, 	"qteQGridLayout_getXX1"				,"Widgets"));
	mixin(generateFunQt(	333, 	"qteQGridLayout_addWidget1"			,"Widgets"));
	mixin(generateFunQt(	334, 	"qteQGridLayout_addWidget2"			,"Widgets"));
	mixin(generateFunQt(	335, 	"qteQGridLayout_setXX1"				,"Widgets"));
	mixin(generateFunQt(	336, 	"qteQGridLayout_setXX2"				,"Widgets"));
	mixin(generateFunQt(	337, 	"qteQGridLayout_addLayout1"			,"Widgets"));

	// ------- QMouseEvent -------
	mixin(generateFunQt(	347, 	"qteQMouseEvent1"					,"Widgets"));
	mixin(generateFunQt(	348, 	"qteQWidget_setMousePressEvent"		,"Widgets"));
	mixin(generateFunQt(	349, 	"qteQWidget_setMouseReleaseEvent"	,"Widgets"));
	mixin(generateFunQt(	350, 	"qteQMouse_button"					,"Widgets"));

	// ------- QScriptEngine -------
	mixin(generateFunQt(	351, 	"QScriptEngine_create1"				,"Script"));
	mixin(generateFunQt(	352, 	"QScriptEngine_delete1"				,"Script"));
	mixin(generateFunQt(	353, 	"QScriptEngine_evaluate"			,"Script"));
	mixin(generateFunQt(	358, 	"QScriptEngine_newQObject"			,"Script"));
	mixin(generateFunQt(	359, 	"QScriptEngine_globalObject"		,"Script"));
	mixin(generateFunQt(	361, 	"QScriptEngine_callFunDlang"		,"Script"));
	mixin(generateFunQt(	362, 	"QScriptEngine_setFunDlang"			,"Script"));

	// ------- QScriptValue -------
	mixin(generateFunQt(	354, 	"QScriptValue_create1"				,"Script"));
	mixin(generateFunQt(	355, 	"QScriptValue_delete1"				,"Script"));
	mixin(generateFunQt(	356, 	"QScriptValue_toInt32"				,"Script"));
	mixin(generateFunQt(	357, 	"QScriptValue_toString"				,"Script"));
	mixin(generateFunQt(	360, 	"QScriptValue_setProperty"			,"Script"));

	mixin(generateFunQt(	365, 	"QScriptValue_createQstring"		,"Script"));
	mixin(generateFunQt(	366, 	"QScriptValue_createInteger"		,"Script"));
	mixin(generateFunQt(	367, 	"QScriptValue_createBool"			,"Script"));

	// ------- QScriptContext -------
	mixin(generateFunQt(	363, 	"QScriptContext_argumentCount"		,"Script"));
	mixin(generateFunQt(	364, 	"QScriptContext_argument"			,"Script"));

	// ------- QPaintDevice -------
	mixin(generateFunQt(	379, 	"QPaintDevice_hw"					,"Widgets"));
	mixin(generateFunQt(	380, 	"QPaintDevice_pa"					,"Widgets"));

	//mixin(generateFunQt(	381, 	"QObject_setObjectName"				,"Widgets"));
	// mixin(generateFunQt(	382, 	"QObject_objectName"				,"Widgets"));  382 -- ПУСТ
	mixin(generateFunQt(	381, 	"qteQObject_setName"				,"core"));
	
	mixin(generateFunQt(	383, 	"QObject_dumpObjectInfo"			,"Widgets"));

	// ------- QPixmap -------
	mixin(generateFunQt(	384, 	"QPixmap_create1"					,"Widgets"));
	mixin(generateFunQt(	385, 	"QPixmap_delete1"					,"Widgets"));
	mixin(generateFunQt(	386, 	"QPixmap_create2"					,"Widgets"));
	mixin(generateFunQt(	387, 	"QPixmap_create3"					,"Widgets"));
	mixin(generateFunQt(	388, 	"QPixmap_load1"						,"Widgets"));
	mixin(generateFunQt(	394, 	"QPixmap_fill"						,"Widgets"));
	mixin(generateFunQt(	389, 	"qteQLabel_setPixmap"				,"Widgets"));
	mixin(generateFunQt(	391, 	"qteQPainter_drawPixmap1"			,"Widgets"));
	// ------- QBitmap -------
	mixin(generateFunQt(	392, 	"QBitmap_create1"					,"Widgets"));
	mixin(generateFunQt(	395, 	"QBitmap_create2"					,"Widgets"));
	mixin(generateFunQt(	390, 	"qteQPainter_create3"				,"Widgets"));
	mixin(generateFunQt(	396, 	"qteQPen_create2"					,"Widgets"));
	mixin(generateFunQt(	397, 	"QPixmap_setMask"					,"Widgets"));
	// ------- QResource -------
	mixin(generateFunQt(	398, 	"QResource_create1"					,"Widgets"));
	mixin(generateFunQt(	399, 	"QResource_delete1"					,"Widgets"));
	mixin(generateFunQt(	400, 	"QResource_registerResource"		,"Widgets"));
	mixin(generateFunQt(	401, 	"QResource_registerResource2"		,"Widgets"));
	// ------- QStackedWidget -------
	mixin(generateFunQt(	402, 	"QStackedWidget_create1"			,"Widgets"));
	mixin(generateFunQt(	403, 	"QStackedWidget_delete1"			,"Widgets"));
	mixin(generateFunQt(	404, 	"QStackedWidget_setXX1"				,"Widgets"));
	mixin(generateFunQt(	405, 	"QStackedWidget_setXX2"				,"Widgets"));
	mixin(generateFunQt(	406, 	"QStackedWidget_setXX3"				,"Widgets"));
	// ------- QTabBar -------
	mixin(generateFunQt(	407, 	"QTabBar_create1"					,"Widgets"));
	mixin(generateFunQt(	408, 	"QTabBar_delete1"					,"Widgets"));
	mixin(generateFunQt(	409, 	"QTabBar_setXX1"					,"Widgets"));
	mixin(generateFunQt(	410, 	"QTabBar_addTab1"					,"Widgets"));
	mixin(generateFunQt(	411, 	"QTabBar_tabTextX1"					,"Widgets"));
	mixin(generateFunQt(	412, 	"QTabBar_tabBoolX1"					,"Widgets"));
	mixin(generateFunQt(	413, 	"QTabBar_addTab2"					,"Widgets"));
	mixin(generateFunQt(	414, 	"QTabBar_ElideMode"					,"Widgets"));
	mixin(generateFunQt(	415, 	"QTabBar_iconSize"					,"Widgets"));
	mixin(generateFunQt(	416, 	"QTabBar_addTab3"					,"Widgets"));
	mixin(generateFunQt(	417, 	"QTabBar_moveTab1"					,"Widgets"));
	mixin(generateFunQt(	418, 	"QTabBar_selectionBehaviorOnRemove"	,"Widgets"));
	mixin(generateFunQt(	419, 	"QTabBar_set3"						,"Widgets"));
	mixin(generateFunQt(	420, 	"QTabBar_setElideMode"				,"Widgets"));
	mixin(generateFunQt(	421, 	"QTabBar_setIconSize"				,"Widgets"));
	mixin(generateFunQt(	422, 	"QTabBar_setShape"					,"Widgets"));
	mixin(generateFunQt(	423, 	"QTabBar_setTabEnabled"				,"Widgets"));
	mixin(generateFunQt(	424, 	"QTabBar_setX5"						,"Widgets"));
	mixin(generateFunQt(	425, 	"qteQColor_create3"					,"Widgets"));
	// ------- QCoreApplication -------
	mixin(generateFunQt(	426, 	"QCoreApplication_create1"			,"Widgets"));
	mixin(generateFunQt(	427, 	"QCoreApplication_delete1"			,"Widgets"));
	mixin(generateFunQt(	470, 	"QCoreApplication_installTranslator","Widgets"));
	// ------- QGuiApplication -------
	mixin(generateFunQt(	428, 	"qteQApplication_setX1"				,"Widgets"));
	mixin(generateFunQt(	429, 	"QTabBar_setPoint"					,"Widgets"));
	mixin(generateFunQt(	430, 	"QTabBar_tabPoint"					,"Widgets"));
	// ------- QMdiArea -------
	mixin(generateFunQt(	431, 	"qteQMdiArea_getN1"					,"Widgets"));
	mixin(generateFunQt(	432, 	"qteQMdiArea_setN1"					,"Widgets"));
	mixin(generateFunQt(	433, 	"qteQMdiArea_removeSubWin"			,"Widgets"));
	mixin(generateFunQt(	434, 	"qteQMdiArea_setViewMode"			,"Widgets"));
	// ------- Колесико мыша -------
	mixin(generateFunQt(	435, 	"qteQWidget_setaMouseWheelEvent"	,"Widgets"));
	mixin(generateFunQt(	436, 	"qteQMouseEvent2"	                ,"Widgets"));
	mixin(generateFunQt(	437, 	"qteQMouseangleDelta"	            ,"Widgets"));
	// ------- QLineEdit -------
	mixin(generateFunQt(	438, 	"qteQLineEdit_setAlignment"	        ,"Widgets"));
	mixin(generateFunQt(	439, 	"qteQLineEdit_getInt"	        	,"Widgets"));
	mixin(generateFunQt(	440, 	"qteQLineEdit_setX2"	        	,"Widgets"));
	mixin(generateFunQt(	441, 	"qteQLineEdit_setX3"	        	,"Widgets"));
	// ------- QWebEng ----------
	mixin(generateFunQt(	446, 	"qteQWebEngView_create"				,"WebEng"));
	mixin(generateFunQt(	445, 	"qteQWebEngView_delete"				,"WebEng"));
	mixin(generateFunQt(	447, 	"qteQWebEngView_load"				,"WebEng"));
	// ------- QTextCodec ----------
	mixin(generateFunQt(	448, 	"p_QTextCodec"						,"Widgets"));
	mixin(generateFunQt(	449, 	"QT_QTextCodec_toUnicode"			,"Widgets"));
	mixin(generateFunQt(	450, 	"QT_QTextCodec_fromUnicode"			,"Widgets"));
// ------- QJSEngine ----------
	mixin(generateFunQt(	454, 	"QJSEngine_create1"					,"Qml"));
	mixin(generateFunQt(	455, 	"QJSEngine_delete1"					,"Qml"));
	mixin(generateFunQt(	458, 	"QJSEngine_evaluate"					,"Qml"));
	// ------- QQmlEngine ----------
	mixin(generateFunQt(	456, 	"QQmlEngine_create1"				,"Qml"));
	mixin(generateFunQt(	457, 	"QQmlEngine_delete1"				,"Qml"));
	// ------- QQmlApplicationEngine ----------
	mixin(generateFunQt(	451, 	"QQmlApplicationEngine_create1"		,"Qml"));
	mixin(generateFunQt(	452, 	"QQmlApplicationEngine_delete1"		,"Qml"));
	mixin(generateFunQt(	453, 	"QQmlApplicationEngine_load1"		,"Qml"));
		
	mixin(generateFunQt(	459, 	"QQmlApplicationEngine_setContextProperty1"		,"Qml"));
	mixin(generateFunQt(	460, 	"qteQAction_getQStr"				,"Widgets"));
	mixin(generateFunQt(	461, 	"qteQAction_setQStr"				,"Widgets"));
	mixin(generateFunQt(	462, 	"qteQAction_getInt"					,"Widgets"));
	mixin(generateFunQt(	463, 	"qteQAction_setInt"					,"Widgets"));
	
	// ------- QByteArray ----------
	mixin(generateFunQt(	500, 	"new_QByteArray_vc"					,"Widgets"));
	mixin(generateFunQt(	501, 	"delete_QByteArray"					,"Widgets"));
	mixin(generateFunQt(	502, 	"QByteArray_size"					,"Widgets"));
	mixin(generateFunQt(	503, 	"new_QByteArray_data"				,"Widgets"));
	mixin(generateFunQt(	504, 	"QByteArray_trimmed"				,"Widgets"));
	mixin(generateFunQt(	505, 	"QByteArray_app1"					,"Widgets"));
	mixin(generateFunQt(	506, 	"QByteArray_app2"					,"Widgets"));
	mixin(generateFunQt(	507, 	"new_QByteArray_2"					,"Widgets"));
	mixin(generateFunQt(	508, 	"new_QByteArray_data2"				,"Widgets"));
	mixin(generateFunQt(	509, 	"QByteArray_app3"					,"Widgets"));
	// ------- QFile ----------
	mixin(generateFunQt(	510, 	"QT_QFile_new"						,"Widgets"));
	mixin(generateFunQt(	511, 	"QT_QFile_new1"						,"Widgets"));
	mixin(generateFunQt(	516, 	"QT_QFile_del"						,"Widgets"));
	mixin(generateFunQt(	512, 	"QT_QFile_open"						,"Widgets"));
	// ------- QIODevice ----------
	mixin(generateFunQt(	514, 	"QT_QIODevice_read1"				,"Widgets"));
	mixin(generateFunQt(	519, 	"QT_QTextStream_atEnd"				,"Widgets"));
	// ------- QFileDevice ----------
	mixin(generateFunQt(	520, 	"QT_QFileDevice_close"				,"Widgets"));
	// ------- QTextStream ----------
	mixin(generateFunQt(	513, 	"QT_QTextStream_new1"				,"Widgets"));
	mixin(generateFunQt(	515, 	"QT_QTextStream_del"				,"Widgets"));
	mixin(generateFunQt(	516, 	"QT_QTextStream_LL1"				,"Widgets"));
	mixin(generateFunQt(	517, 	"QT_QTextStream_setCodec"			,"Widgets"));
	mixin(generateFunQt(	518, 	"QT_QTextStream_readLine"			,"Widgets"));
	// ------- QCalendarWidget ----------
	mixin(generateFunQt(	464, 	"qteQCalendarWidget_create1"		,"Widgets"));
	mixin(generateFunQt(	465, 	"qteQCalendarWidget_delete1"		,"Widgets"));
	mixin(generateFunQt(	466, 	"qteQCalendarWidget_selectedDate"	,"Widgets"));
	mixin(generateFunQt(	471, 	"qteQCalendarWidget_getBool1"		,"Widgets"));
	mixin(generateFunQt(	472, 	"qteQCalendarWidget_setBool1"		,"Widgets"));
	// ------- QTranslator --------
	mixin(generateFunQt(	467, 	"qteQTranslator_create1"			,"Widgets"));
	mixin(generateFunQt(	468, 	"qteQTranslator_delete1"			,"Widgets"));
	mixin(generateFunQt(	469, 	"qteQTranslator_load"				,"Widgets"));
	// ------- qscintilla ----------
	mixin(generateFunQt(	600, 	"qteQScin_create"			        ,"Qscintilla"));
	mixin(generateFunQt(	601, 	"qteQScin_delete"			        ,"Qscintilla"));
	mixin(generateFunQt(	602, 	"qteQScin_setColor"			        ,"Qscintilla"));
	mixin(generateFunQt(	603, 	"qteQScin_overwriteMode"            ,"Qscintilla"));
	mixin(generateFunQt(	604, 	"qteQScin_setOverwriteMode"	        ,"Qscintilla"));
	mixin(generateFunQt(	605, 	"qteQScin_color"			        ,"Qscintilla"));
	mixin(generateFunQt(	606, 	"qteQScin_setPaper"			        ,"Qscintilla"));
	mixin(generateFunQt(	607, 	"qteQScin_paper"			        ,"Qscintilla"));

	mixin(generateFunQt(	608, 	"qteQScin_setFont"			        ,"Qscintilla"));
	mixin(generateFunQt(	609, 	"qteQScin_setAutoIndent"	        ,"Qscintilla"));
	mixin(generateFunQt(	610, 	"qteQScin_isReadOnly"	            ,"Qscintilla"));
	mixin(generateFunQt(	611, 	"qteQScin_setReadOnly"	            ,"Qscintilla"));

	mixin(generateFunQt(	612, 	"qteQScin_setMarginWidth"           ,"Qscintilla"));
	mixin(generateFunQt(	613, 	"qteQScin_setMarginMarkerMask"	    ,"Qscintilla"));
	mixin(generateFunQt(	614, 	"qteQScin_markerDefine"	            ,"Qscintilla"));
	mixin(generateFunQt(	615, 	"qteQScin_markerAdd"	            ,"Qscintilla"));

	// Дополнительная проверка на загрузку функций, при условии, что включена диагностика
	if(showError) {
		write("The numbers in pFunQt[] is null: ");
		for(int i; i != maxValueInPFunQt; i++) if(!pFunQt[i])	write(i,", ");
		writeln();
	}

	// Последний = 492
	// -+-+-+-+- = 500
	return 0;
} ///  Загрузить DLL-ки Qt и QtE. Найти в них адреса функций и заполнить ими таблицу

static void msgbox(string text = null, string caption = null,
	QMessageBox.Icon icon = QMessageBox.Icon.Information, QWidget parent = null) {
	string cap, titl;
	QMessageBox soob = new QMessageBox(parent);
	if (caption is null) soob.setWindowTitle("Внимание!"); else soob.setWindowTitle(caption);
	if (text    is null) soob.setText(". . . . .");        else soob.setText(text);
	soob.setIcon(icon).setStandardButtons(QMessageBox.StandardButton.Ok);
	try { soob.exec();	}	catch(Throwable) {}
	soob.destroy();
}

// Отладчик
void deb(ubyte* uk) {
	writeln(cast(ubyte)*(uk + 0), "=", cast(ubyte)*(uk + 1), "=",
		cast(ubyte)*(uk + 2), "=", cast(ubyte)*(uk + 3), "=",
		cast(ubyte)*(uk + 4), "=", cast(ubyte)*(uk + 5), "=",
		cast(ubyte)*(uk + 6), "=", cast(ubyte)*(uk + 7), "=",
		cast(ubyte)*(uk + 8), "=", cast(ubyte)*(uk + 9), "=",
		cast(ubyte)*(uk + 10), "=", cast(ubyte)*(uk + 11), "=",
		cast(ubyte)*(uk + 12), "=", cast(ubyte)*(uk + 13), "=",
		cast(ubyte)*(uk + 14), "=", cast(ubyte)*(uk + 15), "=",
		cast(ubyte)*(uk + 16), "=", cast(ubyte)*(uk + 17), "=",
		cast(ubyte)*(uk + 18), "=", cast(ubyte)*(uk + 19), "=",
		cast(ubyte)*(uk + 20), "=", cast(ubyte)*(uk + 21), "=",
		cast(ubyte)*(uk + 22), "=", cast(ubyte)*(uk + 23));
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
	// .... Qt6/QtCore/qnamespace.h
	}
	enum KeyboardModifier { //->
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
	enum ContextMenuPolicy { //->
		NoContextMenu = 0, // нет контексного меню
		DefaultContextMenu = 1, //
		ActionsContextMenu = 2, //
		CustomContextMenu = 3, //
		PreventContextMenu = 4 //
	}
	// Кнопки мыша
	enum MouseButton {
		NoButton		=	0x00000000,	//	The button state does not refer to any button (see QMouseEvent::button()).
		AllButtons		=	0x07ffffff,	//	This value corresponds to a mask of all possible mouse buttons. Use to set the 'acceptedButtons' property of a MouseArea to accept ALL mouse buttons.
		LeftButton		=	0x00000001,	//	The left button is pressed, or an event refers to the left button. (The left button may be the right button on left-handed mice.)
		RightButton	=	0x00000002,	//	The right button.
		MidButton		=	0x00000004		//	The middle button.
	}

	enum Key { //->
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
	enum Orientation { //->
		Horizontal = 0x1,
		Vertical   = 0x2
	}
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
	}
	enum GlobalColor { //->
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
 	enum PenStyle { //->
		NoPen			= 0,	// Запретить рисование
		SolidLine		= 1,	// Сплошная непрерывная линия
		DashLine		= 2,	// Штрихова, длинные штрихи
		DotLine			= 3,	// Пунктир, точки
		DashDotLine		= 4,	// Штрих пунктиреая, длинный штрих + точка
		DashDotDotLine	= 5,	// штрих 2 точки штрих 2 точки
		CustomDashLine	= 6		// A custom pattern defined using QPainterPathStroker::setDashPattern().
	}
	enum TextFormat {
		PlainText		= 0,    // The text string is interpreted as a plain text string.
		RichText		= 1,	// The text string is interpreted as a rich text string. See Supported HTML Subset for the definition of rich text.
		AutoText		= 2,	// The text string is interpreted as for Qt::RichText if Qt::mightBeRichText() returns true, otherwise as Qt::PlainText.
		MarkdownText    = 3		// The text string is interpreted as Markdown-formatted text. This enum value was added in 5.14
	}
	enum TextInteractionFlag {
		NoTextInteraction			= 0,	// No interaction with the text is possible.
		TextSelectableByMouse		= 1,	// Text can be selected with the mouse and copied to the clipboard using a context menu or standard keyboard shortcuts.
		TextSelectableByKeyboard	= 2,	// Text can be selected with the cursor keys on the keyboard. A text cursor is shown.
		LinksAccessibleByMouse		= 4, 	// Links can be highlighted and activated with the mouse.
		LinksAccessibleByKeyboard	= 8,	// Links can be focused using tab and activated with enter.
		TextEditable				= 16,	// The text is fully editable.
		TextEditorInteraction		= TextSelectableByMouse | TextSelectableByKeyboard | TextEditable,	// The default for a text editor.
		TextBrowserInteraction		= TextSelectableByMouse | LinksAccessibleByMouse | LinksAccessibleByKeyboard	//The default for QTextBrowser.	
	}
	enum CheckState { //->
		Unchecked	= 0, 		// Не выбранный
		PartiallyChecked = 1,	// The item is partially checked. Items in hierarchical models may be partially checked if some, but not all, of their children are checked.
		Checked		= 2			// Выбран The item is checked.
	}
	enum ItemFlag {
        NoItemFlags = 0,
        ItemIsSelectable = 1,			// Он может быть выделен.
        ItemIsEditable = 2,				// Он может быть отредактирован.
        ItemIsDragEnabled = 4,			// Он может перетаскиваться.
        ItemIsDropEnabled = 8,			// Он может быть использован, как цель перетаскивания.
        ItemIsUserCheckable = 16,		// Он может быть отмечен пользователем или наоборот.
        ItemIsEnabled = 32,				// Пользователь может взаимодействовать с элементом.
        ItemIsAutoTristate = 64,		// Отмечаемый элемент с тремя различными состояниями.
        ItemNeverHasChildren = 128,
        ItemIsUserTristate = 256
    }
    enum ImageConversionFlag {
        ColorMode_Mask          = 0x00000003,
        AutoColor               = 0x00000000,
        ColorOnly               = 0x00000003,
        MonoOnly                = 0x00000002,
        // Reserved             = 0x00000001,

        AlphaDither_Mask        = 0x0000000c,
        ThresholdAlphaDither    = 0x00000000,
        OrderedAlphaDither      = 0x00000004,
        DiffuseAlphaDither      = 0x00000008,
        NoAlpha                 = 0x0000000c, // Not supported

        Dither_Mask             = 0x00000030,
        DiffuseDither           = 0x00000000,
        OrderedDither           = 0x00000010,
        ThresholdDither         = 0x00000020,
        // ReservedDither       = 0x00000030,

        DitherMode_Mask         = 0x000000c0,
        AutoDither              = 0x00000000,
        PreferDither            = 0x00000040,
        AvoidDither             = 0x00000080,

        NoOpaqueDetection       = 0x00000100,
        NoFormatConversion      = 0x00000200
    }
    enum TextElideMode {
		ElideLeft	= 0,		//	The ellipsis should appear at the beginning of the text.
		ElideRight	= 1,		//	The ellipsis should appear at the end of the text.
		ElideMiddle	= 2,		//	The ellipsis should appear in the middle of the text.
		ElideNone	= 3			//  Ellipsis should NOT appear in the text.
	}
    enum DockWidgetArea {
        LeftDockWidgetArea = 0x1,
        RightDockWidgetArea = 0x2,
        TopDockWidgetArea = 0x4,
        BottomDockWidgetArea = 0x8,

        DockWidgetArea_Mask = 0xf,
        AllDockWidgetAreas = DockWidgetArea_Mask,
        NoDockWidgetArea = 0
    }
	
	enum WindowModality {
		NonModal			= 0,		//	The window is not modal and does not block input to other windows.
		WindowModal			= 1,		//	The window is modal to a single window hierarchy and blocks input to its parent window, all grandparent windows, and all siblings of its parent and grandparent windows.
		ApplicationModal	= 2			// 	The window is modal to the application and blocks input to all windows.	
	}
    enum WidgetAttribute {
        WA_Disabled = 0,
        WA_UnderMouse = 1,
        WA_MouseTracking = 2,
        WA_OpaquePaintEvent = 4,
        WA_StaticContents = 5,
        WA_LaidOut = 7,
        WA_PaintOnScreen = 8,
        WA_NoSystemBackground = 9,
        WA_UpdatesDisabled = 10,
        WA_Mapped = 11,
        WA_InputMethodEnabled = 14,
        WA_WState_Visible = 15,
        WA_WState_Hidden = 16,

        WA_ForceDisabled = 32,
        WA_KeyCompression = 33,
        WA_PendingMoveEvent = 34,
        WA_PendingResizeEvent = 35,
        WA_SetPalette = 36,
        WA_SetFont = 37,
        WA_SetCursor = 38,
        WA_NoChildEventsFromChildren = 39,
        WA_WindowModified = 41,
        WA_Resized = 42,
        WA_Moved = 43,
        WA_PendingUpdate = 44,
        WA_InvalidSize = 45,
        WA_CustomWhatsThis = 47,
        WA_LayoutOnEntireRect = 48,
        WA_OutsideWSRange = 49,
        WA_GrabbedShortcut = 50,
        WA_TransparentForMouseEvents = 51,
        WA_PaintUnclipped = 52,
        WA_SetWindowIcon = 53,
        WA_NoMouseReplay = 54,
        WA_DeleteOnClose = 55,
        WA_RightToLeft = 56,
        WA_SetLayoutDirection = 57,
        WA_NoChildEventsForParent = 58,
        WA_ForceUpdatesDisabled = 59,

        WA_WState_Created = 60,
        WA_WState_CompressKeys = 61,
        WA_WState_InPaintEvent = 62,
        WA_WState_Reparented = 63,
        WA_WState_ConfigPending = 64,
        WA_WState_Polished = 66,
        WA_WState_OwnSizePolicy = 68,
        WA_WState_ExplicitShowHide = 69,

        WA_ShowModal = 70, // ## deprecated since since 4.5.1 but still in use :-(
        WA_MouseNoMask = 71,
        WA_GroupLeader = 72, // ## deprecated since since 4.5.1 but still in use :-(
        WA_NoMousePropagation = 73, // for now, might go away.
        WA_Hover = 74,
        WA_InputMethodTransparent = 75, // Don't reset IM when user clicks on this (for virtual keyboards on embedded)
        WA_QuitOnClose = 76,

        WA_KeyboardFocusChange = 77,

        WA_AcceptDrops = 78,
        WA_DropSiteRegistered = 79, // internal

        WA_WindowPropagation = 80,

        WA_NoX11EventCompression = 81,
        WA_TintedBackground = 82,
        WA_X11OpenGLOverlay = 83,
        WA_AlwaysShowToolTips = 84,
        WA_MacOpaqueSizeGrip = 85,
        WA_SetStyle = 86,

        WA_SetLocale = 87,
        WA_MacShowFocusRect = 88,

        WA_MacNormalSize = 89,  // Mac only
        WA_MacSmallSize = 90,   // Mac only
        WA_MacMiniSize = 91,    // Mac only

        WA_LayoutUsesWidgetRect = 92,
        WA_StyledBackground = 93, // internal
        WA_CanHostQMdiSubWindowTitleBar = 95, // Internal

        WA_MacAlwaysShowToolWindow = 96, // Mac only

        WA_StyleSheet = 97, // internal

        WA_ShowWithoutActivating = 98,

        WA_X11BypassTransientForHint = 99,

        WA_NativeWindow = 100,
        WA_DontCreateNativeAncestors = 101,

        WA_MacVariableSize = 102,    // Mac only

        WA_DontShowOnScreen = 103,

        // window types from http://standards.freedesktop.org/wm-spec/
        WA_X11NetWmWindowTypeDesktop = 104,
        WA_X11NetWmWindowTypeDock = 105,
        WA_X11NetWmWindowTypeToolBar = 106,
        WA_X11NetWmWindowTypeMenu = 107,
        WA_X11NetWmWindowTypeUtility = 108,
        WA_X11NetWmWindowTypeSplash = 109,
        WA_X11NetWmWindowTypeDialog = 110,
        WA_X11NetWmWindowTypeDropDownMenu = 111,
        WA_X11NetWmWindowTypePopupMenu = 112,
        WA_X11NetWmWindowTypeToolTip = 113,
        WA_X11NetWmWindowTypeNotification = 114,
        WA_X11NetWmWindowTypeCombo = 115,
        WA_X11NetWmWindowTypeDND = 116,
        WA_SetWindowModality = 118,
        WA_WState_WindowOpacitySet = 119, // internal
        WA_TranslucentBackground = 120,

        WA_AcceptTouchEvents = 121,
        WA_WState_AcceptedTouchBeginEvent = 122,
        WA_TouchPadAcceptSingleTouchEvents = 123,

        WA_X11DoNotAcceptFocus = 126,
        WA_MacNoShadow = 127,

        WA_AlwaysStackOnTop = 128,

        WA_TabletTracking = 129,

        WA_ContentsMarginsRespectsSafeArea = 130,

        WA_StyleSheetTarget = 131,

        // Add new attributes before this line
        WA_AttributeCount
    }
	
	
}
// ================ QObject ================
/++
Базовый класс.  Хранит в себе ссылку на реальный объект в Qt C++
Base class. Stores in itself the link to real object in Qt C ++
+/

// Две этих переменных служат для поиска ошибок связанных с ошибочным
// уничтожением объектов C++
// static ulong allCreate;
static ulong balCreate;
// Переменная для анализа распределения памяти
// static int id;
static QtObjH saveAppPtrQt;

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

	private QtObjH p_QObject; 			/// Адрес самого объекта из C++ Qt
	private QtObjH p_QPointer;			/// Адрес QPointer - защищенный указатель на C++ Qt
	private bool  fNoDelete;  			/// Если T - не вызывать деструктор
	private void* adrThis;    			/// Адрес собственного экземпляра

	// int id;

	this() {
		// Для подсчета ссылок создания и удаления
		balCreate++;
	} /// спец Конструктор, что бы не делать реальный объект из Qt при наследовании
	~this() {
		// Для подсчета ссылок создания и удаления
		balCreate--;
		if(balCreate == 0) {
			if( !(saveAppPtrQt is null) ) delForPoint(10, 3); // delete app
		}
	}
	// Ни чего в голову не лезет ... Нужно сделать объект, записав в него пришедший
	// с наружи указатель. Дабы отличить нужный конструктор, специально делаю
	// этот конструктор "вычурным"
	// this(char ch, void* adr) {
	//	if(ch == '+') setQtObj(cast(QtObjH)adr);
	//}
	void setNoDelete(bool f) { //->
		fNoDelete = f;
	}
	@property bool NoDelete() { //->
		return fNoDelete; }

	// Функция удаления C++ экземпляра. Шаблон для ускорения
	void delForPoint(int nomCase, int nomMasDel) {
		// writeln("1 - delForPoint  nomCase = ", genNameClass(nomCase), "   nomMasDel = ", nomMasDel, "  QtObj = ", QtObj, "  QtPointer = ", QtPointer);
		if( (QtObj !is null) && (QtPointer !is null) ) {
			if( !((cast(t_b__qp_i)pFunQt[702])(QtPointer, nomCase)) ) {
				(cast(t_v__qp) pFunQt[nomMasDel])(QtObj); 
				setQtObj(null); 
				setQtPointer(null);
			}
		}	
	}
	// p_QPointer - хранит указатель на защищённый указатель C++ (QPoint<...>), что позволяет узнать
	// удалён объект на который он ссылается
	void setQtPointer(QtObjH adr)	{ p_QPointer = adr; }
	@property QtObjH QtPointer()  	{ return p_QPointer;} /// Выдать указатель на реальный объект Qt C++
	
	void setQtObj(QtObjH adr) 		{ p_QObject = adr;  } /// Заменить указатель в объекте на новый указатель
	@property QtObjH QtObj() 		{ return p_QObject;	} /// Выдать указатель на реальный объект Qt C++
	
	@property void* aQtObj() { //->
		return &p_QObject;
	} /// Выдать указатель на p_QObject

	QObject connect(void* obj1, char* ssignal, void* obj2, char* sslot,	QObject.ConnectionType type = QObject.ConnectionType.AutoConnection) { //->
		(cast(t_QObject_connect) pFunQt[27])(obj1, ssignal, obj2, sslot, cast(int)type);
		return this;
	}
	QObject connects(QObject obj1, string ssignal, QObject obj2, string sslot) { //->
		(cast(t_QObject_connect) pFunQt[27])(
			(cast(QObject)obj1).QtObj, MSS(ssignal, QSIGNAL),
			(cast(QObject)obj2).QtObj, MSS(sslot, QSLOT),
		cast(int)QObject.ConnectionType.AutoConnection);
		return this;
	}

	QObject connects(QObject obj1, string ssignal, void* obj2, string sslot) { //->
		(cast(t_QObject_connect) pFunQt[27])(
			(cast(QObject)obj1).QtObj, MSS(ssignal, QSIGNAL),
			obj2, MSS(sslot, QSLOT),
		cast(int)QObject.ConnectionType.AutoConnection);
		return this;
	}

	QObject connects(void* obj1, string ssignal, QObject obj2, string sslot) { //->
		(cast(t_QObject_connect) pFunQt[27])(
			obj1, MSS(ssignal, QSIGNAL),
			(cast(QObject)obj2).QtObj, MSS(sslot, QSLOT),
		cast(int)QObject.ConnectionType.AutoConnection);
		return this;
	}

	QObject disconnects(QObject obj1, string ssignal, QObject obj2, string sslot) { //->
		(cast(t_QObject_disconnect) pFunQt[343])(
			(cast(QObject)obj1).QtObj, MSS(ssignal, QSIGNAL),
			(cast(QObject)obj2).QtObj, MSS(sslot, QSLOT));
		return this;
	}
	/// Запомнить указатель на собственный экземпляр
	@property QWidget saveThis(void* adr) { //-> Запомнить указатель на собственный экземпляр
		adrThis = cast(void*)adr; return cast(QWidget)this;
	}
	@property void* aThis() { //-> Выдать указатель на p_QObject
		return &adrThis;
	} /// Выдать указатель на p_QObject
	void* parentQtObj() { //-> выдать указатель на собственного родителя в Qt
		return (cast(t_qp__qp)pFunQt[344])(QtObj);
	}
	
/*	
	void setObjectName(T)(T name) { //-> Задать имя объекту
		wstring ps = to!wstring(name);
		(cast(t_v__qp_qp) pFunQt[381])(QtObj, (cast(t_qp__qp_i)pFunQt[9])(cast(QtObjH)ps.ptr, cast(int)ps.length));
	}
	T objectName(T)() { //-> Получить имя объекта
		QString qs = new QString();	(cast(t_qp__qp_qp)pFunQt[382])(QtObj, qs.QtObj);
		return cast(T)qs.String();
	}
*/	
	// _________________________ 0 -- QString|objectName|
	@property T objectName(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return to!T(qsOut.String);
	}
	@property string objectName() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return qsOut.String;
	}
	@property T objectName(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return qsOut;
	}
	// _________________________ 1 -- void|setObjectName|QString%name
	QObject setObjectName(T)(T name) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(name)).QtObj, 1);
		return this;
	}
	QObject setObjectName(string name) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, sQString(name).QtObj, 1);
		return this;
	}
	QObject setObjectName(QString name) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 381 ])(QtObj, 0, qsOut.QtObj, name.QtObj, 1);
		return this;
	}	
	
	
	
	void dumpObjectInfo() {
		(cast(t_qp__qp_i)pFunQt[383])(QtObj, 0);
	}
	void dumpObjectTree() {
		(cast(t_qp__qp_i)pFunQt[383])(QtObj, 1);
	}
	void* findChild(T)(T str) { //-> выдать указатель на собственного родителя в Qt
		return (cast(t_qp__qp_qp)pFunQt[490])(QtObj, sQString(to!string(str)).QtObj);
	}
}

// ================ QPalette ================
/++
QPalette - Палитры цветов
+/
class QPalette : QObject {

	enum ColorGroup { //->
		Active,
		Disabled,
		Inactive,
		NColorGroups,
		Current,
		All,
		Normal = Active
	}

	enum ColorRole { //->
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
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[17])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		setQtObj((cast(t_qp__v) pFunQt[16])());
	} /// Конструктор
}

// ================ QRgb ================
struct QRgb {
	int data;
	int set(uint r, uint g, uint b, uint a = 255) {
		int rez;
		rez = r | (g << 8) | (b << 16) | (a << 24);
		data = rez;
		return rez;
	}
	@property int qRed() {               				// get red part of RGB
		return ((data >> 16) & 0xff);
	}
	@property int qGreen() {               				// get green part of RGB
		return ((data >> 8) & 0xff);
	}
	@property int qBlue() {               				// get blue part of RGB
		return (data & 0xff);
	}
	@property int qAlpha() {               				// get alpha part of RGB
		return data >> 24;
	}
	@property int toGray() {               				// get alpha part of RGB
		int rez = ((qRed*11) + (qGreen*16) + (qBlue*5)) / 32;
		write(rez, "  ");
		return ((qRed*11) + (qGreen*16) + (qBlue*5)) / 32;
	}
	@property int toGrayRealy() {               				// get alpha part of RGB
		int rez = ((qRed*11) + (qGreen*16) + (qBlue*5)) / 32;
		set(rez, rez, rez, rez);
		return data;
	}
	int qGray(int r, int g, int b) {
		return (r*11+g*16+b*5)/32;
	}
	int qGray(QRgb rgb) {
		return qGray(rgb.qRed(), rgb.qGreen(), rgb.qBlue());
	}
	bool iqIsGray(QRgb rgb) {
		return rgb.qRed() == rgb.qGreen() && rgb.qRed() == rgb.qBlue();
	}
}
// ================ QFormBuilder ================
class QFormBuilder : QObject {
protected:
	QWidget thisForm;
	QWidget[string] dict;
public:
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		delForPoint(33, 488);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		// setQtPointer((cast(t_qp__i)pFunQt[700])(33));
		setQtObj((cast(t_qp__v) pFunQt[487])());
	}
	/*
	@property void* load(T)(T str, QWidget parent = null) {
		return (cast(t_qp__qp_qp_qp) pFunQt[489])(QtObj, sQString(to!string(str)).QtObj, parent.QtObj);
	}
	*/	
	QWidget load(T)(T str, QWidget parent = null) {
		if(!parent) {
			thisForm = new QWidget('+', (cast(t_qp__qp_qp_qp) pFunQt[489])(QtObj, sQString(to!string(str)).QtObj, null));
		} else {
			thisForm = new QWidget('+', (cast(t_qp__qp_qp_qp) pFunQt[489])(QtObj, sQString(to!string(str)).QtObj, parent.QtObj));
		}
		return thisForm;
	}
	void* loadAdr(T)(T str, QWidget parent = null) {
		if(!parent) {
			return (cast(t_qp__qp_qp_qp) pFunQt[489])(QtObj, sQString(to!string(str)).QtObj, null);
		} else {
			return (cast(t_qp__qp_qp_qp) pFunQt[489])(QtObj, sQString(to!string(str)).QtObj, parent.QtObj);
		}
	}
	QWidget* findChildQWidget(T)(T str) {
		string name = to!string(str);
		if(thisForm) {
			if(name !in dict) {
				dict[name] = new QWidget('+', (cast(t_qp__qp_qp)pFunQt[490])(thisForm.QtObj, sQString(name).QtObj));
			}
		}
		return &dict[name];
	}
	void* findChildAdr(T)(T str, void* adr = null) {
		string name = to!string(str);
		if(!adr) {
			return (cast(t_qp__qp_qp)pFunQt[490])(thisForm.QtObj, sQString(name).QtObj);
		} else {
			return (cast(t_qp__qp_qp)pFunQt[490])(cast(QtObjH)adr, sQString(name).QtObj);
		}
	}

}

// ================ QColor ================
/++
QColor - Цвет
+/
class QColor : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[14])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		setQtObj((cast(t_qp__v) pFunQt[13])());
	} /// Конструктор
	this(uint color) {
		setQtObj((cast(t_qp__ui) pFunQt[324])(color));
	}
	this(QtE.GlobalColor color) {
		setQtObj((cast(t_qp__ui) pFunQt[425])(color));
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	QColor setRgb(int r, int g, int b, int a = 255) { //->
		(cast(t_v__qp_i_i_i_i) pFunQt[15])(QtObj, r, g, b, a);
		return this;
	} /// Sets the RGB value to r, g, b and the alpha value to a. All the values must be in the range 0-255.
	QColor setRgb(QRgb rgb) { //->
		(cast(t_v__qp_i_i_i_i) pFunQt[15])(QtObj, rgb.qRed, rgb.qGreen, rgb.qBlue, rgb.qAlpha);
		return this;
	} /// Sets the RGB value to r, g, b and the alpha value to a. All the values must be in the range 0-255.
	QColor getRgb(int* r, int* g, int* b, int* a) { //->
		(cast(t_v__qp_ip_ip_ip_ip) pFunQt[320])(QtObj, r, g, b, a);
		return this;
	} /// Sets the RGB value to r, g, b and the alpha value to a. All the values must be in the range 0-255.
	QColor setRgba(uint r) { //-> Установить цвет (QRgb Qt)
		(cast(t_v__qp_ui) pFunQt[323])(QtObj, r);
		return this;
	}
	uint rgb() { //-> Получить цвет (QRgb Qt)
		return (cast(t_ui__qp) pFunQt[322])(QtObj);
	}
}
// ================ QBrush ================
/++
QBrush - Оформление
+/
class QBrush : QObject {

	enum BrushStyle { //->
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
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[178])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		setQtObj((cast(t_qp__v) pFunQt[177])());
	} /// Конструктор
	QBrush setColor(QColor color) { //->
		(cast(t_v__qp_qp) pFunQt[179])(QtObj, color.QtObj);
		return this;
	}
	QBrush setStyle(BrushStyle style = BrushStyle.SolidPattern) { //->
		(cast(t_v__qp_i) pFunQt[181])(QtObj, style);
		return this;
	}
}

/* 	//  ------- QBrush -------
	funQt(177, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQBrush_create1",				showError);
	funQt(178, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQBrush_delete",				showError);
	funQt(179, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQBrush_setColor",				showError);
 */



// ================ QPaintDevice ================
class QPaintDevice: QObject  {
	int typePD;  // 0=QWidget, 1=QImage
	this(){}
	
	int height() {
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 0);
	}
	int width() {
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 1);
	}
	int colorCount() { //-> Выдать доступное для рисования количество цветов
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 2); // pFunQt[369])(QtObj, 2);
	}
	int depth() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 3);
	}
	int devicePixelRatio() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 4);
	}
	int heightMM() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 5);
	}
	int widthMM() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 6);
	}
	int logicalDpiX() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 7);
	}
	int logicalDpiY() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 8);
	}
	int physicalDpiX() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 9);
	}
	int physicalDpiY() { //->
		return (cast(t_i__qp_i_i) pFunQt[379])(QtObj, typePD, 10);
	}
	bool paintingActive() { //-> F .. paintBegin .. T .. paintEnd F
		return (cast(t_b__qp_i) pFunQt[380])(QtObj, typePD);
	}
}

// ================ gWidget ================

struct sQWidget {
	//____________________________
private:
	QtObjH adrCppObj;
	//____________________________
public:
	@disable this();
	@property QtObjH QtObj()	{ 	return adrCppObj;	}
	void setQtObj(QtObjH adr)	{ 	adrCppObj = adr; 	}
	//____________________________
	~this() { //-> +
		(cast(t_v__qp) pFunQt[7])(QtObj); setQtObj(null);
	}
	this(int ptr) {
	}
	this(sQWidget* parent, QtE.WindowType fl = QtE.WindowType.Widget) { //-> +
		if (parent) {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(null, cast(int)fl));
		}
	}
	void init(sQWidget* parent = null, QtE.WindowType fl = QtE.WindowType.Widget) { //-> +
		if (parent) {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(null, cast(int)fl));
		}
	}
	void show() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 3);
	}
}

/++
	QWidget (Окно), но немного модифицированный в QtE.DLL.
	<br>Хранит в себе ссылку на реальный С++ класс gWidget из QtE.dll
	<br>Добавлены свойства хранящие адреса для вызова обратных функций
	для реакции на события.
+/
class QWidget: QPaintDevice {
	QString[] masQString;
	enum PolicyFlag { //->
		GrowFlag = 1,
		ExpandFlag = 2,
		ShrinkFlag = 4,
		IgnoreFlag = 8
	}
	enum Policy { //->
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
	this() { /*assert(false, mesNoThisWitoutPar ~ to!string(__LINE__) ~ " : " ~ to!string(__FILE__)); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() { 	
		foreach(el; masQString) el.destroy();
		// Новый вариант удаления C++ объектов, через QPointer
		delForPoint(0, 7);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(0));
		typePD = 0;
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp_i)pFunQt[5])(QtPointer, parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i)pFunQt[5])(QtPointer, null, cast(int)fl));
		}
	} /// QWidget::QWidget(QWidget * parent = 0, Qt::WindowFlags f = 0)
	
	QWidget setDisabled(bool f)         { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 0); return this;	}	//-> +
	QWidget setEnabled(bool f)          { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 1); return this;	}	//-> +
	QWidget setHidden(bool f)           { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 2); return this;	}	//-> +

	QWidget setVisible(bool f)          { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 3); return this;	}	//-> +
	QWidget setWindowModified(bool f)   { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 4); return this;	}	//-> +
	QWidget setUpdatesEnabled(bool f)   { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 5); return this;	}	//-> +
	QWidget setTabletTracking(bool f)   { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 6); return this;	}	//-> +
	QWidget setMouseTracking(bool f)    { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 7); return this;	}	//-> +
	QWidget setAutoFillBackground(bool f){(cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 9); return this;	}	//-> +
	QWidget setAcceptDrops(bool f)      { (cast(t_v__qp_bool_i)pFunQt[6])(QtObj, f, 10); return this;	}	//-> +
	
	bool isVisible() { 	return (cast(t_b__qp_i) pFunQt[259])(QtObj, 15); } //-> + /// QWidget::isVisible();
	//QWidget show() { setVisible(true); return this; } /// Показать виджет
	//QWidget hide() { setVisible(false); return this; } /// Скрыть виджет

	@property T windowTitle(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 8); return to!T(qs.String);
	}
	@property T windowTitle(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 8); return qs;
	}
	QWidget setWindowTitle(QString qstr) {  //-> + // Установить заголовок окна
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, qstr.QtObj, 0); return this;
	} /// Установить заголовок окна
	QWidget setWindowTitle(T)(T str) { //-> +
		// Было: return setWindowTitle(new QString(to!string(str)));
		// Однако, при таком вызове остается висеть в памяти D объект и C++ QString,
		// по этому, здесь, я явно удаляю этот объект из памяти и также удаляется C++ QString
		// -- QString qs = new QString(to!string(str)); setWindowTitle(qs);  delete qs;  return this;
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 0); return this;
	}  /// Установить заголовок окна

	QWidget setStyleSheet(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 1); return this;
		// (cast(t_v__qp_qp)pFunQt[30])(QtObj, str.QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setStyleSheet(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 1); return this;
		// (cast(t_v__qp_qp)pFunQt[30])(QtObj, sQString(to!string(str)).QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.

	QWidget setToolTip(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 2); return this;
	}
	QWidget setToolTip(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 2); return this;
	}
	QWidget setStatusTip(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 3); return this;
	}
	QWidget setStatusTip(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 3); return this;
	}
	QWidget setWhatsThis(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 4); return this;
	}
	QWidget setWhatsThis(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 4); return this;
	}
	QWidget setWindowRole(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 5); return this;
	}
	QWidget setWindowRole(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 5); return this;
	}
	QWidget setWindowFilePath(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 6); return this;
	}
	QWidget setWindowFilePath(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 6); return this;
	}
	QWidget setAccessibleDescription(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 7); return this;
	}
	QWidget setAccessibleDescription(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 7); return this;
	}
	QWidget setAccessibleName(QString str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, str.QtObj, 8); return this;
	}
	QWidget setAccessibleName(T)(T str) { //-> +
		(cast(t_v__qp_qp_i) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj, 8); return this;
	}
	
//	QWidget setMinimumSize(int w, int h) { //->
//		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, true, w, h); return this;
//	} /// Минимальный размер в лайоутах
//	QWidget setMaximumSize(int w, int h) { //->
//		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, false, w, h); return this;
//	} /// Максимальный размер в лайоутах
	// QWidget setEnabled(bool fl) { //->
	// 	(cast(t_v__qp_bool) pFunQt[32])(QtObj, fl); return this;
	// } /// Доступен или нет
	QWidget setLayout(QBoxLayout layout) { //->
		layout.setNoDelete(true);
		(cast(t_v__qp_qp) pFunQt[40])(QtObj, layout.QtObj); return this;
	} /// Вставить в виджет выравниватель
	QWidget setLayout(QGridLayout layout) { //->
		layout.setNoDelete(true);
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
	QWidget  setResizeEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[52])(QtObj, cast(QtObj__*)adr, cast(QtObj__*)adrThis);
		return this;
	} /// Установить обработчик на событие ResizeWidget

	QWidget setKeyReleaseEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[225])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis);
		return this;
	}

	QWidget setKeyPressEvent(void* adr, void* adrThis = null) { //->
		writeln("1- setKeyPressEvent()  adr = ", adr, "   adrThis = ", adrThis, "   pFunQt[49] = ", pFunQt[49]);
		(cast(t_v__qp_qp_qp) pFunQt[49])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); 
		writeln("2- setKeyPressEvent()  adr = ", adr, "   adrThis = ", adrThis);
		return this;
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setPaintEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[50])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие PaintEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setCloseEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[51])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие CloseEvent. Здесь <u>adr</u> - адрес на функцию D +/

	QWidget  setMousePressEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[348])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие MousePressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setMouseReleaseEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[349])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие MouseReleaseEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget  setMouseWheelEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[435])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	}

	QWidget setSizePolicy(int w, int h) { //->
		(cast(t_v__qp_i_i) pFunQt[78])(QtObj, w, h); return this;
	} /// Установить обработчик на событие CloseEvent. Здесь <u>adr</u> - адрес на функцию D +/
	
	QWidget setMaximumWidth(int w) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 0, w); return this;
	} /// setMaximumWidth();
	QWidget setMinimumWidth(int w) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 1, w); return this;
	} /// setMinimumWidth();
	QWidget setFixedWidth(int w) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 5, w); return this;
	} /// setFixedWidth();
	QWidget setMaximumHeight(int h) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 2, h); return this;
	} /// setMaximumHeight();
	QWidget setMinimumHeight(int h) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 3, h); return this;
	} /// setMinimumHeight();
	QWidget setFixedHeight(int h) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 4, h); return this;
	} /// setFixedHeight();
	QWidget setToolTipDuration(int msek) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 6, msek); return this;
	} /// Время показа в МилиСекундах
	QWidget releaseShortcut(int id) { //-> +
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 7, id); return this;
	}
	
	QWidget setFocus() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 0); return this; } /// Установить фокус
	QWidget close()    {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 1); return this; } /// Закрыть окно
	QWidget hide() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 2); return this; 	}
	QWidget show() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 3); return this; 	}
	QWidget showFullScreen()  {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 4); return this; 	}
	QWidget showMaximized() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 5); return this; 	}
	QWidget showMinimized() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 6); return this; 	}
	QWidget showNormal() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 7); return this; } ///
	QWidget update() { 	 //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 8); return this;  } ///
	QWidget raise() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 9); return this; 	} /// Показать окно на вершине
	QWidget lower() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 10); return this; 	} /// Скрыть в стеке
	QWidget activateWindow() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 11); return this; 	} /// Попытка сделать окно активным
	QWidget adjustSize() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 12); return this; 	} /// Подстроить размер окна
	QWidget clearFocus() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 13); return this; 	}
	QWidget clearMask() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 14); return this; 	}
	QWidget ensurePolished() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 15); return this; 	} /// Окончательная полир вн вида
	QWidget grabKeyboard() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 16); return this; 	} /// Захват клавиатуры
	QWidget grabMouse() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 17); return this; 	} /// Захват мыша
	QWidget releaseKeyboard() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 18); return this; 	} /// Отпустить клавиатуру
	QWidget releaseMouse() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 19); return this; 	} /// Отпустить мышь
	QWidget updateGeometry() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 20); return this; 	}
	QWidget unsetCursor() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 21); return this; 	}
	QWidget unsetLayoutDirection() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 22); return this; 	}
	QWidget unsetLocale() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 23); return this; 	}
	QWidget deleteLater() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 24); return this; 	}
	QWidget repaint() {  //-> +
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 25); return this; 	}
	
	// _________________________ 0 -- void|move|int%x|int%y
	QWidget move(int x, int y) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, x, y, 0);
		return this;
	}
	// _________________________ 1 -- void|resize|int%w|int%h
	QWidget resize(int w, int h) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, w, h, 1);
		return this;
	}
	// _________________________ 2 -- void|scroll|int%dx|int%dy
	QWidget scroll(int dx, int dy) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, dx, dy, 2);
		return this;
	}
	// _________________________ 3 -- void|setAttribute|Qt::WidgetAttribute%attribute|bool%on
	QWidget setAttribute(QtE.WidgetAttribute attribute, bool on) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, cast(int)attribute, cast(int)on, 3);
		return this;
	}
	// _________________________ 4 -- void|setBaseSize|int%basew|int%baseh
	QWidget setBaseSize(int basew, int baseh) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, basew, baseh, 4);
		return this;
	}
	// _________________________ 5 -- void|setFixedSize|int%w|int%h
	QWidget setFixedSize(int w, int h) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, w, h, 5);
		return this;
	}
	// _________________________ 6 -- void|setMaximumSize|int%maxw|int%maxh
	QWidget setMaximumSize(int maxw, int maxh) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, maxw, maxh, 6);
		return this;
	}
	// _________________________ 7 -- void|setMinimumSize|int%minw|int%minh
	QWidget setMinimumSize(int minw, int minh) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, minw, minh, 7);
		return this;
	}
	// _________________________ 8 -- void|setShortcutAutoRepeat|int%id|bool%enable
	QWidget setShortcutAutoRepeat(int id, bool enable) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, id, cast(int)enable, 8);
		return this;
	}
	// _________________________ 9 -- void|setShortcutEnabled|int%id|bool%enable
	QWidget setShortcutEnabled(int id, bool enable) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, id, cast(int)enable, 9);
		return this;
	}
	// _________________________ 10 -- void|setSizeIncrement|int%w|int%h
	QWidget setSizeIncrement(int w, int h) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, w, h, 10);
		return this;
	}
	// _________________________ 11 -- void|setSizePolicy|QSizePolicy::Policy%horizontal|QSizePolicy::Policy%vertical
	QWidget setSizePolicy(QWidget.Policy horizontal, QWidget.Policy vertical) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, cast(int)horizontal, cast(int)vertical, 11);
		return this;
	}
	// _________________________ 12 -- void|setWindowFlag|Qt::WindowType%flag|bool%on
	QWidget setWindowFlag(QtE.WindowType flag, bool on) {
		(cast(t_i__qp_i_i_i) pFunQt[ 94 ])(QtObj, cast(int)flag, cast(int)on, 12);
		return this;
	}



/*	
	QWidget move(int x, int y) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 0, x, y); return this;
	}
	QWidget resize(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 1, w, h); return this;
	}
	QWidget scroll(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 2, w, h); return this;
	}
	QWidget setBaseSize(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 3, w, h); return this;
	}
	QWidget setFixedSize(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 4, w, h); return this;
	}
	QWidget setMaximumSize(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 5, w, h); return this;
	}
	QWidget setMinimumSize(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 6, w, h); return this;
	}
	QWidget setSizeIncrement(int w, int h) { //-> +
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 7, w, h); return this;
	}
*/
	
	QWidget setFont(QFont font) { //->
		(cast(t_v__qp_qp) pFunQt[131])(QtObj, font.QtObj); return this;
	}
	void* winId() { //->
		return (cast(t_vp__qp) pFunQt[148])(QtObj);
	}
	int x() { //->
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 0);
	}
	int y() { //->
		return (cast(t_i__qp_i) pFunQt[172])(QtObj, 1);
	}
	bool hasFocus() { //-> + Виджет имеет фокус
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 0);
	}
	bool acceptDrops() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 1);
	}
	bool autoFillBackground() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 2);
	}
	bool hasMouseTracking() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 3);
	}
	bool isActiveWindow() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 4);
	}
	bool isEnabled() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 5);
	}
	bool isFullScreen() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 6);
	}
	bool isHidden() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 7);
	}
	bool isMaximized() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 8);
	}
	bool isMinimized() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 9);
	}
	bool isModal() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 10);
	}
	bool isWindow() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 11);
	}
	bool isWindowModified() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 12);
	}
	bool underMouse() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 13);
	}
	bool updatesEnabled() { //-> +
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 14);
	}
	QWidget setGeometry(int x, int y, int w, int h) { //-> Установить геометрию виджета
		(cast(t_v__qp_i_i_i_i) pFunQt[279])(QtObj, x, y, w, h); return this;
	}
	QRect contentsRect(QRect tk) { //-> Вернуть QRect дочерней области
		(cast(t_v__qp_qp) pFunQt[280])(QtObj, tk.QtObj);	return tk;
	}
	@property T styleSheet(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 0); return qs;
	}
	@property T styleSheet(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 0); return to!T(qs.String);
	}
	@property T accessibleDescription(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 1); return qs;
	}
	@property T accessibleDescription(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 1); return to!T(qs.String);
	}
	@property T accessibleName(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 2); return qs;
	}
	@property T accessibleName(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 2); return to!T(qs.String);
	}
	@property T statusTip(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 3); return qs;
	}
	@property T statusTip(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 3); return to!T(qs.String);
	}
	@property T toolTip(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 4); return qs;
	}
	@property T toolTip(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 4); return to!T(qs.String);
	}
	@property T whatsThis(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 5); return qs;
	}
	@property T whatsThis(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 5); return to!T(qs.String);
	}
	@property T windowFilePath(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 6); return qs;
	}
	@property T windowFilePath(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 6); return to!T(qs.String);
	}
	@property T windowRole(T: QString)() { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 7); return qs;
	}
	@property T windowRole(T)() {  //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[521])(QtObj, qs.QtObj, 7); return to!T(qs.String);
	}

	// _________________________ 0 -- void|resize|QSize::tt%nm
	QWidget resize(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 0);
		return this;
	}
	// _________________________ 1 -- void|setBaseSize|QSize::tt%nm
	QWidget setBaseSize(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 1);
		return this;
	}
	// _________________________ 2 -- void|setFixedSize|QSize::tt%s
	QWidget setFixedSize(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 2);
		return this;
	}
	// _________________________ 3 -- void|setMaximumSize|QSize::tt%nm
	QWidget setMaximumSize(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 3);
		return this;
	}
	// _________________________ 4 -- void|setMinimumSize|QSize::tt%nm
	QWidget setMinimumSize(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 4);
		return this;
	}
	// _________________________ 5 -- void|setSizeIncrement|QSize::tt%nm
	QWidget setSizeIncrement(QSize nm) {
		(cast(t_i__qp_qp_i) pFunQt[ 1011 ])(QtObj, nm.QtObj, 5);
		return this;
	}
}
// ============ QAbstractButton =======================================
class QAbstractButton : QWidget {
	this() { /* msgbox( "new QAbstractButton(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	this(QWidget parent) {	 }
	~this() { if (QtObj) setQtObj(null); }

	QAbstractButton setText(T: QString)(T str) {
		(cast(t_v__qp_qp) pFunQt[28])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QAbstractButton setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[28])(QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на кнопке
	T text(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[29])(QtObj, qs.QtObj);
		(cast(t_v__qp_qp)pFunQt[29])(QtObj, qs.QtObj);
		return qs;
	}
	T text(T)() { 
		// return to!T(text!QString().String);  /// MGW
		sQString qs = sQString(""); (cast(t_v__qp_qp)pFunQt[29])(QtObj, qs.QtObj); return qs.String;
	}
	
	// Освобождено 224
	
	// _________________________ 0 -- bool|autoExclusive|
	@property bool autoExclusive() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 0);
	}	
	// _________________________ 1 -- bool|autoRepeat|
	@property bool autoRepeat() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 1);
	}	
	// _________________________ 2 -- int|autoRepeatDelay|
	@property int autoRepeatDelay() {
		return (cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 2);
	}	
	// _________________________ 3 -- int|autoRepeatInterval|
	@property int autoRepeatInterval() {
		return (cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 3);
	}
	// _________________________ 4 -- bool|isCheckable|
	@property bool isCheckable() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 4);
	}
	// _________________________ 5 -- bool|isChecked|
	@property bool isChecked() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 5);
	}
	// _________________________ 6 -- bool|isDown|
	@property bool isDown() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 6);
	}
	// _________________________ 7 -- void|setAutoExclusive|bool%xz
	QAbstractButton setAutoExclusive(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, cast(int)xz, 7);
		return this;
	}	
	// _________________________ 8 -- void|setAutoRepeat|bool%xz
	QAbstractButton setAutoRepeat(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, cast(int)xz, 8);
		return this;
	}	
	// _________________________ 9 -- void|setAutoRepeatDelay|int%xz
	QAbstractButton setAutoRepeatDelay(int xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, xz, 9);
		return this;
	}
	// _________________________ 10 -- void|setAutoRepeatInterval|int%xz
	QAbstractButton setAutoRepeatInterval(int xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, xz, 10);
		return this;
	}	
	// _________________________ 11 -- void|setCheckable|bool%xz
	QAbstractButton setCheckable(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, cast(int)xz, 11);
		return this;
	}	
	// _________________________ 12 -- void|setDown|bool%xz
	QAbstractButton setDown(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, cast(int)xz, 12);
		return this;
	}	
	// _________________________ 13 -- void|animateClick|int%msec
	QAbstractButton animateClick(int msec) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, msec, 13);
		return this;
	}
	// _________________________ 14 -- void|click|
	QAbstractButton click() {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 14);
		return this;
	}
	// _________________________ 15 -- void|setChecked|bool%xz
	QAbstractButton setChecked(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, cast(int)xz, 15);
		return this;
	}
	// _________________________ 16 -- void|toggle|
	QAbstractButton toggle() {
		(cast(t_i__qp_i_i) pFunQt[ 209 ])(QtObj, 0, 16);
		return this;
	}

	
	//QAbstractButton setAutoExclusive(bool pr) { //->
	//	(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 0); return this;
	//} ///
	// QAbstractButton setAutoRepeat(bool pr) { //->
		// (cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 1); return this;
	// } ///
	// QAbstractButton setCheckable(bool pr) { //->
		// (cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 2); return this;
	// } ///
	// QAbstractButton setDown(bool pr) { //->
		// (cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 3); return this;
	// } ///
	// QAbstractButton setChecked(bool pr) { //-> Включить кнопку
		// (cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 4); return this;
	// } ///
	QAbstractButton setIcon(QIcon ik) { //->
		(cast(t_v__qp_qp) pFunQt[211])(QtObj, ik.QtObj); return this;
	} ///
	// bool autoExclusive() { //-> T - Эксклюзивное использование
	// 	return (cast(t_b__qp_i) pFunQt[224])(QtObj, 0);
	//}
	// bool autoRepeat() { //-> T - Повторяющеяся
	// 	return (cast(t_b__qp_i) pFunQt[224])(QtObj, 1);
	// }
	// bool isCheckable() { //-> T - Может нажиматься
	// 	return (cast(t_b__qp_i) pFunQt[224])(QtObj, 2);
	//}
	// @property bool isChecked() { //-> T - Нажата
	// 	return (cast(t_b__qp_i) pFunQt[224])(QtObj, 3);
	//}
	//@property bool isDown() { //-> T - Нажата
	//	return (cast(t_b__qp_i) pFunQt[224])(QtObj, 4);
	//}



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
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(8, 23);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		setQtPointer((cast(t_qp__i)pFunQt[700])(8));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[22])(QtPointer, parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[22])(QtPointer, null, str.QtObj));
		}
	} /// Создать кнопку.
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		setQtPointer((cast(t_qp__i)pFunQt[700])(8));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[22])(QtPointer, parent.QtObj, sQString(to!string(str)).QtObj ));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[22])(QtPointer, null, sQString(to!string(str)).QtObj ));
		}
	}
	QPushButton setAutoDefault(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 0); return this;
	} ///
	QPushButton setDefault(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 1); return this;
	} ///
	QPushButton setFlat(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[210])(QtObj, pr, 2); return this;
	} ///

}

// ================ QCommandLinkButton ================
class QCommandLinkButton : QPushButton {
	this(){}
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(29, 696);
	}
	
	this(QWidget parent = null) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(29));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[697])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[697])(QtPointer, null));
		}
	}
	
	this(T: QString)(T text, QWidget parent = null) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(29));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[695])(QtPointer, parent.QtObj, text.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[695])(QtPointer, null, text.QtObj));
		}
	}
	
	this(T)(T text, QWidget parent = null) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(29));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[695])(QtPointer, parent.QtObj, sQString(to!string(text)).QtObj ));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp) pFunQt[695])(QtPointer, null, sQString(to!string(text)).QtObj ));
		}
	}

	this(T)(T text, T description, QWidget parent = null) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(29));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp_qp) pFunQt[694])(QtPointer, parent.QtObj, sQString(to!string(text)).QtObj, sQString(to!string(description)).QtObj ));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp_qp) pFunQt[694])(QtPointer, null, sQString(to!string(text)).QtObj, sQString(to!string(description)).QtObj ));
		}
	}
	
	QCommandLinkButton setDescription(T)(T description) {
		(cast(t_v__qp_qp) pFunQt[693])(QtObj, sQString(to!string(description)).QtObj);
		return this;
	} /// Установить описание на кнопке
	
}

// ================ QEndApplication ================
// Идея: D уничтожает объеты в порядке FIFO, а Qt в порядке LIFO и к тому же
// Qt имеетт каскадное удаление объектов типа QWidget.
// В связи с этим, все каскадные объекты (дети) получают признак setNoDelete(true); в QtE6.
// Сам QApplication удаляется первым (первым создан), но его нужно удалить последним
// Для этого создаётся класс QEndApplication, задача которого вызвать деструктор
// Qt-шного QApplication воследним в программе.
// QEndApplication должен быть определен непосредственно перед выходом из процедуры main()
// для того, что бы гарантировать что будет создан последним и соответственно удален
// последним при завершениии программы
/*
class QEndApplication : QObject {
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	~this() {
		// printf("DELETE app fro QEndApplication ... %d \n"); stdout.flush();
		// delete app;
		(cast(t_v__qp) pFunQt[3])(QtObj); setQtObj(null);

	}
}
*/
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

// Проверка идеи с структурами = С++ объектам
struct sQApplication {
	//____________________________
private:
	QtObjH adrCppObj;
	//____________________________
public:
	@disable this();
	@property QtObjH QtObj()		{ 	return adrCppObj;	}
	void setQtObj(QtObjH adr)	{ 	adrCppObj = adr; 	}
	//____________________________
	~this() {
		(cast(t_v__qp)pFunQt[3])(QtObj); setQtObj(null);
	}
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
	}
	void init(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
	}
	int exec() { //-> Выполнить
		return (cast(t_i__qp_i) pFunQt[1])(QtObj, 0);
	}
	void aboutQt() { //-> Об Qt
		(cast(t_i__qp_i) pFunQt[1])(QtObj, 2);
	}

}
// ================ QCoreApplication ================
/**
Содержит методы для консольной обработки приложения Qt.
*/
class QCoreApplication : QObject {
	///  $(B)Явно не вызывается! Обязателен для всех наследованных при определении нового класса.
	this() {}
	/// Косвенный вызов деструк C++ обязателен
	~this() { del(); }
	/// Функция, возможно устаревшая
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[427])(QtObj); setQtObj(null); }
	}
	/// Правильный вызов. Стандартный.
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[426])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		saveAppPtrQt = QtObj;
	}
	/// Загрузить файл локализации.
	bool installTranslator(QTranslator qtr) {
		return (cast(t_b__qp_qp) pFunQt[470])(QtObj, qtr.QtObj);
	}

/*
        case 0:   wd->addLibraryPath(*qsIn);   break;  // void|addLibraryPath|QString%path
+++ applicationDirPath();   break;  // QString|applicationDirPath|
+++ applicationFilePath();   break;  // QString|applicationFilePath|
+++ applicationName();   break;  // QString|applicationName|
+++ applicationVersion();   break;  // QString|applicationVersion|
+++ organizationDomain();   break;  // QString|organizationDomain|
+++ organizationName();   break;  // QString|organizationName|
        case 7:   wd->removeLibraryPath(*qsIn);   break;  // void|removeLibraryPath|QString%path
        case 8:   wd->setApplicationName(*qsIn);   break;  // void|setApplicationName|QString%application
        case 9:   wd->setApplicationVersion(*qsIn);   break;  // void|setApplicationVersion|QString%version
        case 10:   wd->setOrganizationDomain(*qsIn);   break;  // void|setOrganizationDomain|QString%orgDomain
        case 11:   wd->setOrganizationName(*qsIn);   break;  // void|setOrganizationName|QString%orgName
  
*/

	// _________________________ 0 -- void|addLibraryPath|QString%path
	QCoreApplication addLibraryPath(T)(T path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(path)).QtObj, 0);
		return this;
	}
	QCoreApplication addLibraryPath(string path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(path).QtObj, 0);
		return this;
	}
	QCoreApplication addLibraryPath(QString path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, path.QtObj, 0);
		return this;
	}
	// _________________________ 1 -- QString|applicationDirPath|
	@property T applicationDirPath(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return to!T(qsOut.String);
	}
	@property string applicationDirPath() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return qsOut.String;
	}
	@property T applicationDirPath(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return qsOut;
	}
	// _________________________ 2 -- QString|applicationFilePath|
	@property T applicationFilePath(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return to!T(qsOut.String);
	}
	@property string applicationFilePath() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return qsOut.String;
	}
	@property T applicationFilePath(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return qsOut;
	}
	// _________________________ 3 -- QString|applicationName|
	@property T applicationName(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return to!T(qsOut.String);
	}
	@property string applicationName() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return qsOut.String;
	}
	@property T applicationName(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return qsOut;
	}
	// _________________________ 4 -- QString|applicationVersion|
	@property T applicationVersion(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 4);
		return to!T(qsOut.String);
	}
	@property string applicationVersion() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 4);
		return qsOut.String;
	}
	@property T applicationVersion(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 4);
		return qsOut;
	}
	// _________________________ 5 -- QString|organizationDomain|
	@property T organizationDomain(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 5);
		return to!T(qsOut.String);
	}
	@property string organizationDomain() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 5);
		return qsOut.String;
	}
	@property T organizationDomain(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 5);
		return qsOut;
	}
	// _________________________ 6 -- QString|organizationName|
	@property T organizationName(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return to!T(qsOut.String);
	}
	@property string organizationName() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return qsOut.String;
	}
	@property T organizationName(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return qsOut;
	}
	// _________________________ 7 -- void|removeLibraryPath|QString%path
	QCoreApplication removeLibraryPath(T)(T path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(path)).QtObj, 7);
		return this;
	}
	QCoreApplication removeLibraryPath(string path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(path).QtObj, 7);
		return this;
	}
	QCoreApplication removeLibraryPath(QString path) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, path.QtObj, 7);
		return this;
	}
	// _________________________ 8 -- void|setApplicationName|QString%application
	QCoreApplication setApplicationName(T)(T application) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(application)).QtObj, 8);
		return this;
	}
	QCoreApplication setApplicationName(string application) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(application).QtObj, 8);
		return this;
	}
	QCoreApplication setApplicationName(QString application) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, application.QtObj, 8);
		return this;
	}
	// _________________________ 9 -- void|setApplicationVersion|QString%version
	QCoreApplication setApplicationVersion(T)(T vers) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(vers)).QtObj, 9);
		return this;
	}
	QCoreApplication setApplicationVersion(string vers) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(vers).QtObj, 9);
		return this;
	}
	QCoreApplication setApplicationVersion(QString vers) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, vers.QtObj, 9);
		return this;
	}
	// _________________________ 10 -- void|setOrganizationDomain|QString%orgDomain
	QCoreApplication setOrganizationDomain(T)(T orgDomain) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(orgDomain)).QtObj, 10);
		return this;
	}
	QCoreApplication setOrganizationDomain(string orgDomain) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(orgDomain).QtObj, 10);
		return this;
	}
	QCoreApplication setOrganizationDomain(QString orgDomain) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, orgDomain.QtObj, 10);
		return this;
	}
	// _________________________ 11 -- void|setOrganizationName|QString%orgName
	QCoreApplication setOrganizationName(T)(T orgName) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(orgName)).QtObj, 11);
		return this;
	}
	QCoreApplication setOrganizationName(string orgName) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, sQString(orgName).QtObj, 11);
		return this;
	}
	QCoreApplication setOrganizationName(QString orgName) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 382 ])(QtObj, 0, qsOut.QtObj, orgName.QtObj, 11);
		return this;
	}


/*
	// ----------------------------
	T applicationDirPath(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 0); return qs;
	}
	@property T applicationDirPath(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 0); return to!T(qs.String);
	}
	T applicationFilePath(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 1); return qs;
	}
	@property T applicationFilePath(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 1); return to!T(qs.String);
	}
	
	T applicationName(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 2); return qs;
	}
	@property T applicationName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 2); return to!T(qs.String);
	}
	
	T applicationVersion(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 3); return qs;
	}
	@property T applicationVersion(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 3); return to!T(qs.String);
	}
	T objectName(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 4); return qs;
	}
	@property T objectName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 4); return to!T(qs.String);
	}
	
	T organizationDomain(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 5); return qs;
	}
	@property T organizationDomain(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 5); return to!T(qs.String);
	}
	T organizationName(T: QString)()  { //-> +
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 6); return qs;
	}
	@property T organizationName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 6); return to!T(qs.String);
	}
*/
	
	
	string[] libraryPaths() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 7); auto sl = split(qs.String, '|');
		return sl;
	}
	string[] arguments() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[20])(QtObj, qs.QtObj, 8);	auto sl = split(qs.String, '|');
		return sl;
	}
	
	// ----------------------------

/*
	T appDirPath(T: QString)() { //-> Путь до приложения
		QString qs = new QString();
		(cast(t_v__qp_qp)pFunQt[20])(QtObj, qs.QtObj);
		return qs;
	}
	T appDirPath(T)() { //-> Путь до приложения
		return to!T((appDirPath!QString()).String);
	}



	T appFilePath(T: QString)() {  //-> Путь до приложения
		QString qs = new QString();
		(cast(t_v__qp_qp)pFunQt[21])(QtObj, qs.QtObj);
		return qs;
	}
	T appFilePath(T)() {  //-> Путь до приложения
		return to!T((appFilePath!QString()).String);
	}
*/	
	
	int exec() { //-> Выполнить
		return (cast(t_i__qp_i) pFunQt[1])(QtObj, 0);
	} /// QApplication::exec()
	void processEvents() { //-> Передать цикл выполнения в ОС
		(cast(t_i__qp_i) pFunQt[1])(QtObj, 1);
	}
	void exit(int kod) { //->
		(cast(t_v__qp_i) pFunQt[276])(QtObj, kod);
	}
}
// ================ QGuiApplication ================
class QGuiApplication : QCoreApplication {
	this() {}
	~this() {}
	void restoreOverrideCursor() {
		(cast(t_v__qp_qp_i) pFunQt[428])(QtObj, null, 0);
	}
	void setApplicationDisplayName(T)(T str) {
		sQString sqs = sQString(to!string(str)); (cast(t_v__qp_qp_i) pFunQt[428])(QtObj, sqs.QtObj, 1);
	}
	void setDesktopFileName(T)(T str) {
		sQString sqs = sQString(to!string(str)); (cast(t_v__qp_qp_i) pFunQt[428])(QtObj, sqs.QtObj, 2);
	}
	void setDesktopSettingsAware(bool on) {
		(cast(t_v__qp_qp_i) pFunQt[428])(QtObj, cast(QtObjH)on, 3);
	}
	void setFallbackSessionManagementEnabled(bool on) {
		(cast(t_v__qp_qp_i) pFunQt[428])(QtObj, cast(QtObjH)on, 4);
	}
	void setFont(QFont font) {
		(cast(t_v__qp_qp_i) pFunQt[428])(QtObj, font.QtObj, 5);
	}
	void setWindowIcon(QIcon icon) {
		(cast(t_v__qp_qp_i) pFunQt[428])(QtObj, icon.QtObj, 6);
	}
	void setStyleSheet(T)(T str) {
	 	sQString sqs = sQString(to!string(str)); (cast(t_v__qp_qp_i) pFunQt[428])(QtObj, sqs.QtObj, 7);
	}

}
class QApplication : QGuiApplication {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// delForPoint(10, 3);
	}
	this(int* m_argc, char** m_argv, int gui) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(10));
		setQtObj((cast(t_qp__qp_qp_qp_i) pFunQt[0])(QtPointer, cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		saveAppPtrQt = QtObj;
		setNoDelete(true);
	} /// QApplication::QApplication(argc, argv, param);
	void aboutQt() { //-> Об Qt
		(cast(t_i__qp_i) pFunQt[1])(QtObj, 2);
	} /// QApplication::aboutQt()
	void aboutQtE56() { //->
				msgbox(
"
<H3>QtE56 - is a D wrapper for Qt-5 and Qt-6</H3>
<H4>" ~ format("MGW 2016 .. 2021 ver %s.%s -- %s", verQt56Eu, verQt56El, verQt56Ed) ~ "</H4>
<a href='https://github.com/MGWL/QtE6'>https://github.com/MGWL/QtE6</a>
<BR>
<a href='http://mgw.narod.ru/about.htm'>http://mgw.narod.ru/about.htm</a>
<BR>
<BR>
<IMG src='ICONS/qte5.png'>
<BR>
", "About QtE56");
	}
	
	@property T applicationDisplayName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 0); return to!T(qs.String);
	}	
	@property T desktopFileName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 1); return to!T(qs.String);
	}	
	@property T styleSheet(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 2); return to!T(qs.String);
	}	
	@property T sessionId(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 3); return to!T(qs.String);
	}	
	@property T sessionKey(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 4); return to!T(qs.String);
	}	
	@property T platformName(T)() { //-> +
		sQString qs = sQString("");	(cast(t_v__qp_qp_i)pFunQt[21])(QtObj, qs.QtObj, 5); return to!T(qs.String);
	}	
	
	
	void quit() { //-> Выход
		(cast(t_i__qp_i) pFunQt[1])(QtObj, 3);
	}
	int sizeOfQtObj() { //-> Размер объекта QApplicatin. Size of QApplicatin
		return (cast(t_i__vp) pFunQt[4])(QtObj);
	} /// Размер объекта QApplicatin. Size of QApplicatin
/*
	void setStyleSheet(T: QString)(T str) { //-> Установить оформление
		(cast(t_v__qp_qp) pFunQt[277])(QtObj, str.QtObj);
	}
	void setStyleSheet(T)(T str) { //-> Установить оформление
		(cast(t_v__qp_qp) pFunQt[277])(QtObj, (new QString(to!string(str))).QtObj);
	}
*/
}



// =============== sQString ================
private {
	QtObjH f_9(wstring ps) {
		return (cast(t_qp__qp_i)pFunQt[9])(cast(QtObjH)ps.ptr, cast(int)ps.length);
	}
	string f_18_19(QtObjH qp) {
		wchar* wc = (cast(t_uwc__qp) pFunQt[18])(qp);
		int  size = (cast(t_i__qp) pFunQt[19]) (qp);
		char[] buf; for (int i; i != size; i++) { encode(buf, *(wc + i)); }
		return  to!string(buf);
	}
}
// ================ QByteArray ================
class QByteArray : QObject {
	this(){}
	this(char* buf)   {	setQtObj((cast(t_qp__qp)pFunQt[500])(cast(QtObjH)buf)); }
	this(string strD) {	setQtObj((cast(t_qp__qp)pFunQt[500])(cast(QtObjH)strD.ptr)); }
	~this() {	(cast(t_v__qp)pFunQt[501])(cast(QtObjH)QtObj);	}
	@property int size() { return (cast(t_i__qp) pFunQt[502])(cast(QtObjH)QtObj); }
	@property int length() {	return size();	}
	@property char* data() {	return cast(char*)(cast(t_qp__qp)pFunQt[503])(QtObj);	}
	char getChar(int n) { return *(n + (cast(char*) data()));	}
	QByteArray trimmed() {	(cast(t_v__qp_i)pFunQt[504])(cast(QtObjH)QtObj, 0);	return this;
	} /// Выкинуть пробелы с обоих концов строки (AllTrim())
	QByteArray simplified() {	(cast(t_v__qp_i)pFunQt[504])(cast(QtObjH)QtObj, 1);	return this;
	} /// выкинуть лишние пробелы внутри строки
}
// ================ sQString ================
struct sQString {
	//____________________________
private:
	QtObjH adrCppObj;
	//____________________________
public:
	@disable this();
	@property QtObjH QtObj()	{ 	return adrCppObj;	}
	void setQtObj(QtObjH adr)	{ 	adrCppObj = adr; 	}
	//____________________________
	~this() { (cast(t_v__qp) pFunQt[10])(QtObj);  }
	this(T)(T s) {
		setQtObj(f_9(to!wstring(s)));
	} /// Конструктор где s - Utf-8. Пример: QString qs = new QString("Привет!");
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr); // fNoDelete = true;
	}
	int size() { //-> Размер в UNICODE символах
		return (cast(t_i__qp) pFunQt[19])(QtObj);
	} /// Размер в UNICODE символах
	ubyte* data() { //-> Указатель на UNICODE
		return (cast(t_ub__qp) pFunQt[18])(QtObj);
	} /// Указатель на UNICODE
	string toUtf8() { //-> Конвертировать внутреннее представление в wstring
		return f_18_19(QtObj);
	} /// Конвертировать внутреннее представление в wstring
	@property string String() { //-> return string D from QString
		return toUtf8();
	} /// return string D from QString
}
// ================ QString ================
class QString: QObject {
	// this() - допустим, если тет наследования C++
	this()  { setQtObj((cast(t_qp__v)pFunQt[8])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[10])(QtObj); setQtObj(null); }	
		// (cast(t_v__qp)pFunQt[10])(QtObj); setQtObj(null);
	}
	this(T)(T s) {
		setQtObj(f_9(to!wstring(s)));
	} /// Конструктор где s - Utf-8. Пример: QString qs = new QString("Привет!");
	this(QtObjH adr) { setQtObj(adr);
	} /// Изготовить QString из пришедшего из вне указателя на C++ QString
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr); fNoDelete = true;
	}
	int size() { //-> Размер в UNICODE символах
		return (cast(t_i__qp) pFunQt[19])(QtObj);
	} /// Размер в UNICODE символах
	ubyte* data() { //-> Указатель на UNICODE
		return (cast(t_ub__qp) pFunQt[18])(QtObj);
	} /// Указатель на UNICODE
	string toUtf8() { //-> Конвертировать внутреннее представление в wstring
		return f_18_19(QtObj);
	} /// Конвертировать внутреннее представление в wstring
	@property string String() { //-> return string D from QString
		return toUtf8();
	} /// return string D from QString
	int sizeOfQString() { //->
		return (cast(t_i__v) pFunQt[281])();
	}
}

// ================ QGridLayout ================
class QGridLayout : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[331])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[330])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[330])(null));
		}
	}
	int columnCount() { //->
		return (cast(t_i__qp_i) pFunQt[332])(QtObj, 0);
	}
	int horizontalSpacing() { //->
		return (cast(t_i__qp_i) pFunQt[332])(QtObj, 1);
	}
	int rowCount() { //->
		return (cast(t_i__qp_i) pFunQt[332])(QtObj, 2);
	}
	int spacing() { //->
		return (cast(t_i__qp_i) pFunQt[332])(QtObj, 3);
	}
	int verticalSpacing() { //->
		return (cast(t_i__qp_i) pFunQt[332])(QtObj, 4);
	}
	int columnMinimumWidth(int column) { //->
		return (cast(t_i__qp_i_i) pFunQt[335])(QtObj, column, 0);
	}
	int columnStretch(int column) { //->
		return (cast(t_i__qp_i_i) pFunQt[335])(QtObj, column, 1);
	}
	int rowMinimumHeight(int row) { //->
		return (cast(t_i__qp_i_i) pFunQt[335])(QtObj, row, 2);
	}
	int rowStretch(int row) { //->
		return (cast(t_i__qp_i_i) pFunQt[335])(QtObj, row, 3);
	}
	QGridLayout setColumnMinimumWidth(int column, int minSize) { //->
		(cast(t_v__qp_i_i_i) pFunQt[336])(QtObj, column, minSize, 0); return this;
	}
	QGridLayout setColumnStretch(int column, int stretch) { //->
		(cast(t_v__qp_i_i_i) pFunQt[336])(QtObj, column, stretch, 1); return this;
	}
	QGridLayout setRowMinimumHeight(int row, int minSize) { //->
		(cast(t_v__qp_i_i_i) pFunQt[336])(QtObj, row, minSize, 2); return this;
	}
	QGridLayout setRowStretch(int row, int stretch) { //->
		(cast(t_v__qp_i_i_i) pFunQt[336])(QtObj, row, stretch, 3); return this;
	}
/*
QWidget * widget — указатель на виджет, который устанавливается в ячейку менеджера компоновки.
int row — номер ряда, в который устанавливается виджет. Нумерация рядов начинается с нуля.
int column — номер столбца, в который устанавливается виджет. Нумерация столбцов начинается с нуля.
Qt::Alignment alignment = 0 ) — способ выравнивания виджета в ячейке. Параметр имеет значение по-умолчанию и может не указываться явно.
int fromRow — номер ряда, в который устанавливается верхняя левая часть виджета. Используется для случая, когда виджет необходимо разместить на несколько смежных ячеек.
int fromColumn — номер столбца, в который устанавливается верхняя левая часть виджета. Используется для случая, когда виджет необходимо разместить на несколько смежных ячеек.
int rowSpan — количество рядов, ячейки которых следует объединить для размещения виджета начиная с ряда fromRow.
int columnSpan — количество столбцов, ячейки которых следует объединить для размещения виджета начиная со столбца fromColumn.
*/
	QGridLayout addWidget(QWidget wd, int row, int column, QtE.AlignmentFlag ali = QtE.AlignmentFlag.AlignNone) { //->
        wd.setNoDelete(true);
		(cast(t_v__qp_qp_i_i_i)pFunQt[333])(QtObj, wd.QtObj, row, column, ali); return this;
	}
	QGridLayout addWidget(QWidget wd, int fromRow, int fromColumn, int rowSpan, int colSpan, QtE.AlignmentFlag ali = QtE.AlignmentFlag.AlignNone) { //->
        wd.setNoDelete(true);
		(cast(t_v__qp_qp_i_i_i_i_i)pFunQt[334])(QtObj, wd.QtObj, fromRow, fromColumn, rowSpan, colSpan, ali); return this;
	}
	QGridLayout addLayout(T)(T wd, int row, int column, QtE.AlignmentFlag ali = QtE.AlignmentFlag.AlignNone) { //->
		(cast(t_v__qp_qp_i_i_i)pFunQt[337])(QtObj, wd.QtObj, row, column, ali); return this;
	}
	QGridLayout setSpacing(int spacing) { //-> расстояние между элементами в выравнивателе, например расстояние меж кнопками
		(cast(t_v__qp_i_i) pFunQt[74])(QtObj, spacing, 0); return this;
	} /// Это расстояние между элементами в выравнивателе, например расстояние меж кнопками
	
}
// ================ QLayout ================ AbstractClass
/++
QLayout - родительский класс выравнивателей. С++ экземпляр не создаётся.
+/
class QLayout : QObject {
	this() {}				// Обязателен
	~this() {  }			// Косвенный вызов деструк C++ обязателен
	QLayout setEnabled(bool f) {  
		(cast(t_v__qp_b)pFunQt[33])(QtObj, f);  	
		return this;	
	}	//-> +
}

// ================ QBoxLayout ================
/++
QBoxLayout - это класс выравнивателей. Они управляют размещением
элементов на форме.
+/
class QBoxLayout : QLayout {
	enum Direction { //->
		LeftToRight = 0,
		RightToLeft = 1,
		TopToBottom = 2,
		BottomToTop = 3
	} /// enum Direction { LeftToRight, RightToLeft, TopToBottom, BottomToTop }
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		delForPoint(1, 32);
	}
    this(QWidget parent = null, QBoxLayout.Direction dir = QBoxLayout.Direction.TopToBottom) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(1));
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[34])(QtPointer, parent.QtObj, dir));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[34])(QtPointer, null, dir));
		}
	} /// Создаёт выравниватель, типа dir и вставляет в parent
	QBoxLayout addWidget(QWidget wd, int stretch = 0, QtE.AlignmentFlag alignment = QtE.AlignmentFlag.AlignExpanding) { //-> Добавить виджет
                // wd.setNoDelete(true);
		(cast(t_v__qp_qp_i_i) pFunQt[38])(QtObj, wd.QtObj, cast(int)stretch, cast(int)alignment);
		return this;
	} /// Добавить виджет в выравниватель
	QBoxLayout addLayout(QBoxLayout layout) { //-> Добавить выравниватель в выравниватель
		layout.setNoDelete(true);
		(cast(t_v__qp_qp) pFunQt[39])(QtObj, layout.QtObj);
		return this;
	} /// Добавить выравниватель в выравниватель
	QBoxLayout addLayout(QGridLayout layout) { //-> Добавить выравниватель в выравниватель
		layout.setNoDelete(true);
		(cast(t_v__qp_qp) pFunQt[39])(QtObj, layout.QtObj);
		return this;
	} /// Добавить выравниватель в выравниватель
	QBoxLayout addStrut(int size) {
		(cast(t_v__qp_i_i) pFunQt[74])(QtObj, size, 2); return this;
	}
	QBoxLayout addStretch(int stretch = 0) {
		(cast(t_v__qp_i_i) pFunQt[74])(QtObj, stretch, 1); return this;
	}
	QBoxLayout setSpacing(int spacing) { //-> расстояние между элементами в выравнивателе, например расстояние меж кнопками
		(cast(t_v__qp_i_i) pFunQt[74])(QtObj, spacing, 0); return this;
	} /// Это расстояние между элементами в выравнивателе, например расстояние меж кнопками
	QBoxLayout addSpacing(int size) {
		(cast(t_v__qp_i_i) pFunQt[74])(QtObj, size, 3); return this;
	}
	QBoxLayout insertSpacing(int index, int size) {
		(cast(t_v__qp_i_i_i) pFunQt[474])(QtObj, index, size, 0); return this;
	}
	QBoxLayout insertStretch(int index, int stretch = 0) {
		(cast(t_v__qp_i_i_i) pFunQt[474])(QtObj, index, stretch, 1); return this;
	}
	QBoxLayout setStretch(int index, int stretch) {
		(cast(t_v__qp_i_i_i) pFunQt[474])(QtObj, index, stretch, 2); return this;
	}
	int spacing() { //-> Это расстояние между элементами в выравнивателе, например расстояние меж кнопками
		return (cast(t_i__qp) pFunQt[75])(QtObj);
	} ///
	QBoxLayout setMargin(int spacing) { //-> установить расстояние вокруг всех элементов данного выравнивателя
		(cast(t_v__qp_i) pFunQt[76])(QtObj, spacing); return this;
	} /// Это расстояние вокруг всех элементов данного выравнивателя
	int margin() { //-> Это расстояние вокруг всех элементов данного выравнивателя
		return (cast(t_i__qp) pFunQt[77])(QtObj);
	} ///

}
class QVBoxLayout : QBoxLayout {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(2, 37);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(2));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[35])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[35])(QtPointer, null));
		}
	}
}
class QHBoxLayout : QBoxLayout {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(3, 37);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(3));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[36])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[36])(QtPointer, null));
		}
	}
}
// ================ QFrame ================
class QFrame : QWidget {
	enum Shape { //->
		NoFrame = 0, // no frame
		Box = 0x0001, // rectangular box
		Panel = 0x0002, // rectangular panel
		WinPanel = 0x0003, // rectangular panel (Windows)
		HLine = 0x0004, // horizontal line
		VLine = 0x0005, // vertical line
		StyledPanel = 0x0006 // rectangular panel depending on the GUI style
	}
	enum Shadow { //->
		Plain = 0x0010, // plain line
		Raised = 0x0020, // raised shadow effect
		Sunken = 0x0030 // sunken shadow effect
	}
	
	this() { /* msgbox( "new QFrame(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// Новый вариант удаления C++ объектов, через QPointer
		delForPoint(4, 42);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(4));
		if (parent !is null) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[41])(QtPointer, parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[41])(QtPointer, null, fl));
		}
	} /// Конструктор
	QFrame setFrameShape(Shape sh) { //-> Установить
		(cast(t_v__qp_i) pFunQt[43])(QtObj, sh);
		return this;
	}
	QFrame setFrameShadow(Shadow sh) { //->
		(cast(t_v__qp_i) pFunQt[44])(QtObj, sh);
		return this;
	}
	/*
	QFrame setLineWidth(int sh) { //->
		if (sh > 3) sh = 3; (cast(t_v__qp_i) pFunQt[45])(QtObj, sh);
		return this;
	} /// Установить толщину окантовки в пикселах от 0 до 3
	*/
	
	// _________________________ 0 -- int|frameStyle|
	@property int frameStyle() {
		return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- int|frameWidth|
	@property int frameWidth() {
		return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- int|lineWidth|
	@property int lineWidth() {
		return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, 0, 2);
	}
	// _________________________ 3 -- int|midLineWidth|
	@property int midLineWidth() {
		return (cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, 0, 3);
	}
	// _________________________ 4 -- void|setFrameStyle|int%style
	QFrame setFrameStyle(int style) {
		(cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, style, 4);
		return this;
	}
	// _________________________ 5 -- void|setLineWidth|int%width
	QFrame setLineWidth(int width) {
		(cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, width, 5);
		return this;
	}
	// _________________________ 6 -- void|setMidLineWidth|int%width
	QFrame setMidLineWidth(int width) {
		(cast(t_i__qp_i_i) pFunQt[ 45 ])(QtObj, width, 6);
		return this;
	}
	QFrame listChildren() { //->
		(cast(t_v__qp) pFunQt[290])(QtObj);
		return this;
	}
}
// ============ QSplitter =======================================
class QSplitter : QFrame {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(31, 481);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QtE.Orientation orient, QWidget parent = null) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(31));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[480])(QtPointer, parent.QtObj, orient));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[480])(QtPointer, null, orient));
		}
	} /// Конструктор
	QSplitter addWidget(QWidget wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[482])(QtObj, wd.QtObj, 0);
		return this;
	}
	// _________________________ 0 -- bool|childrenCollapsible|
	@property bool childrenCollapsible() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- int|count|
	@property int count() {
		return (cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- int|handleWidth|
	@property int handleWidth() {
		return (cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, 0, 2);
	}
	// _________________________ 3 -- bool|isCollapsible|int%index
	@property bool isCollapsible(int index) {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, index, 3);
	}
	// _________________________ 4 -- bool|opaqueResize|
	@property bool opaqueResize() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, 0, 4);
	}
	// _________________________ 5 -- void|refresh|
	QSplitter refresh() {
		(cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, 0, 5);
		return this;
	}
	// _________________________ 6 -- void|setOpaqueResize|bool%opaque
	QSplitter setOpaqueResize(bool opaque) {
		(cast(t_i__qp_i_i) pFunQt[ 273 ])(QtObj, cast(int)opaque, 6);
		return this;
	}
	
	
}
// ============ QTabWidget ===================================
class QTabWidget : QWidget {
	enum TabPosition {
		North	= 0,			//	The tabs are drawn above the pages.
		South	= 1, 			//	The tabs are drawn below the pages.
		West	= 2, 			//	The tabs are drawn to the left of the pages.
		East	= 3 			//	The tabs are drawn to the right of the pages.
	}
	enum TabShape {
		Rounded	= 0,			// The tabs are drawn with a rounded look. This is the default shape.
		Triangular = 1			// The tabs are drawn with a triangular look.	
	}

	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(34, 493);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(34));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[492])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[492])(QtPointer, null));
		}
	} /// Конструктор
	QTabWidget addTab(T)(QWidget page, T str) { //->
		(cast(t_i__qp_qp_qp) pFunQt[494])(QtObj, page.QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на вкладке
	QTabWidget addTab(T)(QWidget page, QIcon icon, T str) {
		(cast(t_i__qp_qp_qp_qp) pFunQt[495])(QtObj, page.QtObj, icon.QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на вкладке
	QTabWidget clear()  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 0); return this; }
	int        count()         { return (cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 1); }
	int        currentIndex()  { return (cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 2); }
	bool       documentMode() { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 3)); 	}
	QtE.TextElideMode elideMode()  { return cast(QtE.TextElideMode)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 4)); }
	bool       isMovable()    { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 5)); 	}
	bool       isTabEnabled(int index) { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, index, 6)); 	}
	bool       isTabVisible(int index) { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, index, 7)); 	}

	QTabWidget removeTab(int index)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, index, 8); return this; }
	QTabWidget setDocumentMode(bool set)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, set, 9); return this; }
	QTabWidget setElideMode(QtE.TextElideMode set)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, set, 10); return this; }
	QTabWidget setMovable(bool movable)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, movable, 11); return this; }

	QTabWidget setTabBarAutoHide(bool enabled)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, enabled, 12); return this; }
	QTabWidget setTabsClosable(bool closeable)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, closeable, 13); return this; }
	QTabWidget setUsesScrollButtons(bool useButtons)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, useButtons, 14); return this; }
	bool       tabBarAutoHide() { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 15)); 	}

	QTabWidget.TabPosition tabPosition() { return cast(QTabWidget.TabPosition)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 16)); 	}
	QTabWidget.TabShape    tabShape() { return cast(QTabWidget.TabShape)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 17)); 	}
	bool       absClosable() { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 18)); 	}
	bool       usesScrollButtons() { return cast(bool)((cast(t_i__qp_i_i) pFunQt[496])(QtObj, 0, 19)); 	}
	QTabWidget setCurrentIndex(int index)  { (cast(t_i__qp_i_i) pFunQt[496])(QtObj, index, 20); return this; }
	
	QTabWidget setTabPosition(QTabWidget.TabPosition position)  { 
		(cast(t_i__qp_i_i) pFunQt[496])(QtObj, cast(int)position, 21); return this; 
	}
	QTabWidget setTabShape(QTabWidget.TabShape shape)  { 
		(cast(t_i__qp_i_i) pFunQt[496])(QtObj, cast(int)shape, 22); return this; 
	}
	QTabWidget setTabEnabled(int index, bool enable)  { 
		(cast(t_i__qp_i_i_i) pFunQt[497])(QtObj, index, enable, 0); return this; 
	}
	QTabWidget setTabVisible(int index, bool visible)  { 
		(cast(t_i__qp_i_i_i) pFunQt[497])(QtObj, index, visible, 0); return this; 
	}
	T tabText(T)(int index) {
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[498])(QtObj, qs.QtObj, index, 0); return to!T(qs.String);
	}
	T tabToolTip(T)(int index) {
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[498])(QtObj, qs.QtObj, index, 1); return to!T(qs.String);
	}
	T tabWhatsThis(T)(int index) {
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[498])(QtObj, qs.QtObj, index, 2); return to!T(qs.String);
	}
	
	// 499
	QTabWidget setTabText(T)(int index, T str)  { 
		(cast(t_v__qp_qp_i_i) pFunQt[499])(QtObj, sQString(to!string(str)).QtObj, index, 0); return this; 
	}
	QTabWidget setTabToolTip(T)(int index, T str)  { 
		(cast(t_v__qp_qp_i_i) pFunQt[499])(QtObj, sQString(to!string(str)).QtObj, index, 1); return this; 
	}
	QTabWidget setTabWhatsThis(T)(int index, T str)  { 
		(cast(t_v__qp_qp_i_i) pFunQt[499])(QtObj, sQString(to!string(str)).QtObj, index, 2); return this; 
	}
	

	
}
// ============ QLabel =======================================
class QLabel : QFrame {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(5, 47);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(5));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[46])(QtPointer, parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[46])(QtPointer, null, fl));
		}
	} /// Конструктор
	QLabel setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QLabel setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на кнопке
	QLabel setPixmap(QPixmap pm) { //-> Отобразить изображение на QLabel
		(cast(t_v__qp_qp) pFunQt[389])(QtObj, pm.QtObj);
		return this;
	} /// Установить текст на кнопке
	QLabel setAlignment(QtE.AlignmentFlag fl) {
		(cast(t_v__qp_i)pFunQt[522])(QtObj,  fl);
		return this;
	}
	
}
// ============ QDockWidget =======================================
class QDockWidget : QWidget {
	this() {}
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// Новый вариант удаления C++ объектов, через QPointer
		delForPoint(30, 476);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(30));
		if (parent !is null) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[475])(QtPointer, parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[475])(QtPointer, null, fl));
		}
	} /// Конструктор
	QDockWidget setAllowedAreas(QtE.DockWidgetArea fl) {
		(cast(t_v__qp_i)pFunQt[478])(QtObj,  fl);
		return this;
	}
	QDockWidget setWidget(QWidget wd) {
		(cast(t_v__qp_qp_i) pFunQt[479])(QtObj, wd.QtObj, 0);
		wd.setNoDelete(true);
		return this;
	} ///
	QDockWidget setTitleBarWidget(QWidget wd) {
		(cast(t_v__qp_qp_i) pFunQt[479])(QtObj, wd.QtObj, 1);
		wd.setNoDelete(true);
		return this;
	} ///
	
}

// ============ QStringList =======================================
class QStringList : QObject {
	this()  {}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[679])(QtObj); setQtObj(null); }	
	}
	this(QWidget parent = null) {
		setQtObj((cast(t_qp__v) pFunQt[680])());
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Вылавливает экземпляр QStringList с другой функции
	QStringList clear() { //->
		(cast(t_v__qp_qp_i) pFunQt[678])(QtObj, null, 2);	return this;
	}
	QStringList append(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[678])(QtObj, sQString(str).QtObj, 0);	return this;
	}
	QStringList prepend(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[678])(QtObj, sQString(str).QtObj, 1);	return this;
	}
	@property int size() {
		return (cast(t_i__qp_i) pFunQt[677])(QtObj, 0);
	}
	@property int length() {
		return (cast(t_i__qp_i) pFunQt[677])(QtObj, 0);
	}
	int removeDuplicates() {
		return (cast(t_i__qp_i) pFunQt[677])(QtObj, 1);
	}
	string at(int pos) { //->
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[676])(QtObj, qs.QtObj, pos, 0); return (qs.String);
	}
	@property T first(T)() { //->
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[676])(QtObj, qs.QtObj, 0, 1); return to!T(qs.String);
	}
	@property T last(T)() { //->
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[676])(QtObj, qs.QtObj, 0, 2); return to!T(qs.String);
	}
	string join(char rz) { //->
		sQString qs = sQString("");	(cast(t_v__qp_qp_i_i)pFunQt[676])(QtObj, qs.QtObj, rz, 3); return (qs.String);
	}
}

// ============ QSize =======================================
class QSize : QObject {
	this()  {}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[1057])(QtObj); setQtObj(null); }	
	}
	this(int width, int height) {
		setQtObj((cast(t_qp__i_i) pFunQt[1056])(width, height));
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	
	
	// _________________________ 0 -- int|height|
	@property int height() {
		return (cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- bool|isEmpty|
	@property bool isEmpty() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- bool|isNull|
	@property bool isNull() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 2);
	}
	// _________________________ 3 -- bool|isValid|
	@property bool isValid() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 3);
	}
	// _________________________ 4 -- void|setHeight|int%height
	QSize setHeight(int height) {
		(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, height, 4);
		return this;
	}
	// _________________________ 5 -- void|setWidth|int%width
	QSize setWidth(int width) {
		(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, width, 5);
		return this;
	}
	// _________________________ 6 -- void|transpose|
	QSize transpose() {
		(cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 6);
		return this;
	}
	// _________________________ 7 -- int|width|
	@property int width() {
		return (cast(t_i__qp_i_i) pFunQt[ 1058 ])(QtObj, 0, 7);
	}	
}
// ============ QPainter =======================================
class QPainter : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[302])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		super();
		if (parent) {
			// msgbox("Создаю QPainter()", "Внимание!", QMessageBox.Icon.Critical);
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[301])(parent.QtObj));
		} else {
			msgbox("Запрещено создание QPainter сродителем NULL", "Внимание!", QMessageBox.Icon.Critical);
		}
	} /// Конструктор
	this(QPixmap pm) {
		setQtObj((cast(t_qp__qp) pFunQt[301])(pm.QtObj));
	}
 	this(char ch, void* adr) {
		if(ch == '+') { setQtObj( cast(QtObjH)adr); setNoDelete(true); }
	} /// При создании своего объекта сохраняет в себе объект событие QPainter пришедшее из Qt
	QPainter drawPoint(int x, int y) { //->
		(cast(t_v__qp_i_i_i) pFunQt[188])(QtObj, x, y, 0); return this;
	}
	QPainter setBrushOrigin(int x, int y) { //->
		(cast(t_v__qp_i_i_i) pFunQt[188])(QtObj, x, y, 1); return this;
	}
	QPainter drawLine(int x1, int y1, int x2, int y2) { //->
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



	QPainter setBrush(QBrush qb) { //->
		(cast(t_v__qp_qp_i) pFunQt[190])(QtObj, qb.QtObj, 0); return this;
	}
	QPainter setPen(QPen qp) { //->
		(cast(t_v__qp_qp_i) pFunQt[190])(QtObj, qp.QtObj, 1); return this;
	}
	QPainter setFont(QFont qp) { //->
		(cast(t_v__qp_qp_i) pFunQt[190])(QtObj, qp.QtObj, 2); return this;
	}
	QPainter setText(int x, int y, QString qs) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, qs.QtObj, x, y); return this;
	}
	QPainter setText(int x, int y, string s) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, sQString(s).QtObj, x, y); return this;
	}
	QPainter drawText(int x, int y, QString qs) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, qs.QtObj, x, y); return this;
	}
	QPainter drawText(int x, int y, string s) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[196])(QtObj, sQString(s).QtObj, x, y); return this;
	}
	bool begin(QPaintDevice dev) { //->
		return (cast(t_b__qp_qp) pFunQt[390])(QtObj, dev.QtObj);
	}
	bool end() { //->
		return (cast(t_b__qp) pFunQt[197])(QtObj);
	}
	QFont font(QFont fn) { //-> Выдать шрифт
		(cast(t_v__qp_qp) pFunQt[298])(QtObj, fn.QtObj); return fn;
	}
	QPainter drawImage(QPoint point, QImage image) { //-> Изображение на точку
		(cast(t_v__qp_qp_qp) pFunQt[310])(QtObj, point.QtObj, image.QtObj); return this;
	}
	QPainter drawImage(QRect rect, QImage image) { //-> Изображение в прямоугольник
		(cast(t_v__qp_qp_qp) pFunQt[311])(QtObj, rect.QtObj, image.QtObj); return this;
	}
	QPainter drawPixmap(QPixmap pm, int x, int y, int w, int h) { //-> Изображение в прямоугольник
		(cast(t_v__qp_qp_i_i_i_i) pFunQt[391])(QtObj, pm.QtObj, x, y, w, h); return this;
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
	@property int type() { //->
		return (cast(t_i__qp) pFunQt[53])(QtObj);
	} /// QEvent::type(); Вернуть тип события
	void ignore() { //->
		(cast(t_v__qp_i) pFunQt[157])(QtObj, 0);
	} /// Игнорировать событие
	void accept() { //->
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
	writeln(toCON("Событие: ширина: "), qe.size().width, toCON("  высота: "), qe.size().height);
}
*/
class QResizeEvent : QEvent {
	this() {}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	QSize size() { //->
		return new QSize('+', (cast(t_qp__qp)pFunQt[54])(QtObj));
	} /// QResizeEvent::size();
	QSize oldSize() { //->
		return new QSize('+', (cast(t_qp__qp)pFunQt[55])(QtObj));
	} /// QResizeEvent::oldSize();
}
// ============ QKeyEvent =======================================
struct sQKeyEvent {
	//____________________________
private:
	QtObjH adrCppObj;
	//____________________________
public:
	@disable this();
	@property QtObjH QtObj()	{ 	return adrCppObj;	}
	void setQtObj(QtObjH adr)	{ 	adrCppObj = adr; 	}
	//____________________________
	~this() {}
	this(void* adr) { setQtObj(cast(QtObjH)adr); }
	
	@property int type() { return (cast(t_i__qp) pFunQt[53])(QtObj); } /// QEvent::type(); Вернуть тип события
	void ignore() { (cast(t_v__qp_i) pFunQt[157])(QtObj, 0); } /// Игнорировать событие
	void accept() { (cast(t_v__qp_i) pFunQt[157])(QtObj, 1); } /// Принять событие
	@property uint   key() { return cast(uint)(cast(t_qp__qp)pFunQt[62])(QtObj); }
	@property uint count() { return cast(uint)(cast(t_qp__qp)pFunQt[63])(QtObj); }
	@property QtE.KeyboardModifier modifiers() { //-> Признак модификатора кнопки (Ctrl, Alt ...)
		return cast(QtE.KeyboardModifier)(cast(t_qp__qp)pFunQt[285])(QtObj);
	}
}

class QKeyEvent : QEvent {
	this() {}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	@property uint key() { //->
		return cast(uint)(cast(t_qp__qp)pFunQt[62])(QtObj);
	} /// QKeyEvent::key();
	@property uint count() { //->
		return cast(uint)(cast(t_qp__qp)pFunQt[63])(QtObj);
	} /// QKeyEvent::count();
	@property QtE.KeyboardModifier modifiers() { //-> Признак модификатора кнопки (Ctrl, Alt ...)
		return cast(QtE.KeyboardModifier)(cast(t_qp__qp)pFunQt[285])(QtObj);
	}
}
// ============ QWheelEvent =======================================
class QWheelEvent : QEvent {
	this() {}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	~this() {
	}
	@property int x() { //->
		return (cast(t_i__qp_i)pFunQt[436])(QtObj, 0);
	}
	@property int y() { //->
		return (cast(t_i__qp_i)pFunQt[436])(QtObj, 1);
	}
	@property int globalX() { //->
		return (cast(t_i__qp_i)pFunQt[436])(QtObj, 2);
	}
	@property int globalY() { //->
		return (cast(t_i__qp_i)pFunQt[436])(QtObj, 3);
	}
	QPoint angleDelta() {
		QPoint point = new QPoint(0,0);
		(cast(t_v__qp_qp_i)pFunQt[437])(QtObj, point.QtObj, 0);
		return point;
	}
	QPoint globalPos() {
		QPoint point = new QPoint(0,0);
		(cast(t_v__qp_qp_i)pFunQt[437])(QtObj, point.QtObj, 1);
		return point;
	}
	QPoint pixelDelta() {
		QPoint point = new QPoint(0,0);
		(cast(t_v__qp_qp_i)pFunQt[437])(QtObj, point.QtObj, 2);
		return point;
	}
	QPoint pos() {
		QPoint point = new QPoint(0,0);
		(cast(t_v__qp_qp_i)pFunQt[437])(QtObj, point.QtObj, 3);
		return point;
	}
	
}

// ============ QMouseEvent =======================================
class QMouseEvent : QEvent {
	this() {}
 	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
	}
	@property int x() { //->
		return (cast(t_i__qp_i)pFunQt[347])(QtObj, 0);
	}
	@property int y() { //->
		return (cast(t_i__qp_i)pFunQt[347])(QtObj, 1);
	}
	@property int globalX() { //->
		return (cast(t_i__qp_i)pFunQt[347])(QtObj, 2);
	}
	@property int globalY() { //->
		return (cast(t_i__qp_i)pFunQt[347])(QtObj, 3);
	}
	QtE.MouseButton button() { //->
		return cast(QtE.MouseButton)(cast(t_i__qp)pFunQt[350])(QtObj);
	}
/*
	@property uint count() { //->
		return cast(uint)(cast(t_qp__qp)pFunQt[63])(QtObj);
	} /// QKeyEvent::count();
	@property QtE.KeyboardModifier modifiers() { //-> Признак модификатора кнопки (Ctrl, Alt ...)
		return cast(QtE.KeyboardModifier)(cast(t_qp__qp)pFunQt[285])(QtObj);
	}
*/
}
// ================ QAbstractScrollArea ================
class QAbstractScrollArea : QFrame {
	this() {  /* msgbox( "new QAbstractScrollArea(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[65])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[64])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[64])(null));
		}
	} /// Конструктор
}
// ================ QTextDocument ================
alias int FindFlags;
class QTextDocument : QObject {
	enum FindFlag { //->
		FindBackward		= 0x00001,	// Search backwards instead of forwards.
		FindCaseSensitively	= 0x00002,	// By default find works case insensitive.
		FindWholeWords		= 0x00004	// Makes find match only complete words.
	}
}
// ================ QPlainTextEdit ================
/++
Чистый QPlainTextEdit (ТекстовыйРедактор).
+/

class QPlainTextEdit : QAbstractScrollArea {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(12, 67);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(12));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[66])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[66])(QtPointer, null));
		}
	} /// Конструктор

	override QPlainTextEdit setPaintEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[325])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие PaintEvent. Здесь <u>adr</u> - адрес на функцию D +/

	override QPlainTextEdit setKeyPressEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[80])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/

	QPlainTextEdit setViewportMargins(int left, int top, int right, int bottom) { //-> Установить отступы слева, вверхуЮ справа и внизу
		(cast(t_v__qp_i_i_i_i) pFunQt[278])(QtObj, left, top, right, bottom); return this;
	}

	QPlainTextEdit appendPlainText(T: QString)(T str) { //-> Добавить текст в конец
		(cast(t_v__qp_qp) pFunQt[68])(QtObj, str.QtObj); return this;
	} /// Добавать текст в конец
	QPlainTextEdit appendPlainText(T)(T str) { //-> Добавить текст в конец
		(cast(t_v__qp_qp) pFunQt[68])(QtObj, sQString(str).QtObj); return this;
	} /// Добавать текст в конец
	QPlainTextEdit appendHtml(T: QString)(T str) { //-> Добавать html в конец
		(cast(t_v__qp_qp) pFunQt[69])(QtObj, str.QtObj); return this;
	} /// Добавать html в конец
	QPlainTextEdit appendHtml(T)(T str) { //-> Добавать html в конец
		(cast(t_v__qp_qp) pFunQt[69])(QtObj, sQString(str).QtObj); return this;
	} /// Добавать html в конец
	QPlainTextEdit setPlainText(T: QString)(T str) {  //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[70])(QtObj, str.QtObj); return this;
	} /// Удалить всё и вставить с начала
	QPlainTextEdit setPlainText(T)(T str) { //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp) pFunQt[70])(QtObj, sQString(str).QtObj); return this;
	} /// Удалить всё и вставить с начала
	QPlainTextEdit insertPlainText(T: QString)(T str) { //-> Вставить сразу за курсором
		(cast(t_v__qp_qp) pFunQt[71])(QtObj, str.QtObj); return this;
	} /// Вставить сразу за курсором
	QPlainTextEdit insertPlainText(T)(T str) { //-> Вставить сразу за курсором
		(cast(t_v__qp_qp) pFunQt[71])(QtObj, sQString(str).QtObj); return this;
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
	QPlainTextEdit selectAll() { //->
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 4); return this;
	} /// selectAll()
	QPlainTextEdit selectionChanged() { //->
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 5); return this;
	} /// selectionChanged()
	QPlainTextEdit centerCursor() { //->
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 6); return this;
	} /// centerCursor()
	QPlainTextEdit undo() { //->
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 7); return this;
	} /// undo()
	QPlainTextEdit redo() { //->
		(cast(t_v__qp_i) pFunQt[72])(QtObj, 8); return this;
	} /// redo()
	T toPlainText(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[73])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T toPlainText(T)() {  //->
		return to!T(toPlainText!QString().String);
	} /// Выдать всё содержимое в String
	void* document() { //-> Вернуть указатель на QTextDocument
		return (cast(t_qp__qp) pFunQt[226])(QtObj);
	}
	QTextCursor textCursor(QTextCursor tk) { //->
		(cast(t_v__qp_qp) pFunQt[230])(QtObj, tk.QtObj);
		return tk;
	}
	QPlainTextEdit setTextCursor(QTextCursor tk) { //->
		(cast(t_v__qp_qp) pFunQt[253])(QtObj, tk.QtObj);
		return this;
	}
	QRect cursorRect(QRect tk) { //->
		(cast(t_v__qp_qp) pFunQt[235])(QtObj, tk.QtObj);
		return tk;
	}
	QPlainTextEdit setTabStopWidth(int width) { //-> Размер табуляции в пикселах
		(cast(t_v__qp_i) pFunQt[236])(QtObj, width); return this;
	}
	QPlainTextEdit firstVisibleBlock(QTextBlock tb) { //-> Поучить первый блок (строку)
		(cast(t_v__qp_qp) pFunQt[282])(QtObj, tb.QtObj); return this;
	}
	int topTextBlock(QTextBlock tb) { //-> Поучить верхнию коорд в viewPort
		return (cast(t_i__qp_qp_i) pFunQt[284])(QtObj, tb.QtObj, 0);
	}
	int bottomTextBlock(QTextBlock tb) { //-> Поучить нижнию коорд в viewPort
		return (cast(t_i__qp_qp_i) pFunQt[284])(QtObj, tb.QtObj, 1);
	}
	QPlainTextEdit setWordWrapMode(QTextOption option) { //-> Установить режим переноса текста
		(cast(t_v__qp_qp) pFunQt[294])(QtObj, option.QtObj); return this;
	}
	int blockCount() { //-> Количество строчек
		return (cast(t_i__qp_i) pFunQt[326])(QtObj, 0);
	}
	int maximumBlockCount() { //-> Макс кол строчек возможных в документе
		return (cast(t_i__qp_i) pFunQt[326])(QtObj, 1);
	}
	int cursorWidth() { //-> Толщина курсора в пикселах
		return (cast(t_i__qp_i) pFunQt[326])(QtObj, 1);
	}
	QPlainTextEdit setCursorPosition(int line, int col) { //-> Переставить визуальный курсор
		(cast(t_v__qp_i_i) pFunQt[328])(QtObj, line, col); return this;
	}
	bool find(T: QString)(T str, FindFlags flags) { //-> Найти в тексте
		return (cast(t_b__qp_qp_i) pFunQt[329])(QtObj, str.QtObj, flags);
	}
	bool find(T)(T str, FindFlags flags) { //-> Найти в тексте
		return (cast(t_b__qp_qp_i) pFunQt[329])(QtObj, sQString(str).QtObj, flags);
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
	QString[] masQString;
	enum EchoMode {
		Normal = 0, 				// Показывать символы при вводе. По умолчанию
		NoEcho = 1, 				// Ни чего не показывать, что бы длинна пароля была не понятной
		Password = 2, 				// Звездочки вместо символов
		PasswordEchoOnEdit = 3 		// Показывает только один символ, а остальные скрыты
	}
	this() { /* msgbox( "new QLineEdit(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		foreach(el; masQString) el.destroy();
		delForPoint(11, 702);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(11));
		if(parent) {
			p_QObject = (cast(t_qp__qp_qp) pFunQt[82])(QtPointer, parent.QtObj);
		} else {
			p_QObject = (cast(t_qp__qp_qp) pFunQt[82])(QtPointer, null);
		}
	} /// Создать LineEdit.
	QLineEdit setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[84])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст на кнопке
	QLineEdit setText(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[84])(QtObj, sQString(str).QtObj, 0);
		return this;
	} /// Установить текст на кнопке
	
	QLineEdit insert(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[84])(QtObj, str.QtObj, 1);
		return this;
	}
	QLineEdit insert(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, sQString(str).QtObj, 1);
		return this;
	}
	QLineEdit setInputMask(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[84])(QtObj, str.QtObj, 2);
		return this;
	}
	QLineEdit setInputMask(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, sQString(str).QtObj, 2);
		return this;
	}
	QLineEdit clear() { //->
		(cast(t_v__qp) pFunQt[85])(QtObj);
		return this;
	} /// Очистить строку
	@property T text(T: QString)() { //->
		QString qs = new QString(); masQString ~= qs; (cast(t_v__qp_qp)pFunQt[86])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	@property T text(T)() {  //->
		sQString qs = sQString("");	(cast(t_v__qp_qp)pFunQt[86])(QtObj, qs.QtObj); return to!T(qs.String);
		// return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	override QLineEdit setKeyPressEvent(void* adr, void* adrThis = null) { //->
		(cast(t_v__qp_qp_qp) pFunQt[158])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis); return this;
	} /// Установить обработчик на событие KeyPressEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QLineEdit cursorWordBackward(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 0); return this;
	}
	QLineEdit cursorWordForward(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 1); return this;
	}
	QLineEdit end(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 2); return this;
	}
	QLineEdit home(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 3); return this;
	}
	QLineEdit setClearButtonEnabled(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 4); return this;
	}
	QLineEdit setDragEnabled(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 5); return this;
	}
	QLineEdit setFrame(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 6); return this;
	}
	QLineEdit setModified(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 7); return this;
	}
	QLineEdit setReadOnly(bool t) { //->
		(cast(t_v__qp_b_i) pFunQt[287])(QtObj, t, 8); return this;
	}
	bool dragEnabled() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 0);
	}
	bool hasAcceptableInput() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 1);
	}
	bool hasFrame() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 2);
	}
	bool hasSelectedText() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 3);
	}
	bool isClearButtonEnabled() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 4);
	}
	bool isModified() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 5);
	}
	bool isReadOnly() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 6);
	}
	bool isRedoAvailable() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 7);
	}
	bool isUndoAvailable() { //->
		return (cast(t_b__qp_i) pFunQt[288])(QtObj, 8);
	}
	void setAlignment(QtE.AlignmentFlag flags) {
		(cast(t_v__qp_i) pFunQt[438])(QtObj, flags);
	}
	int cursorPosition() {
		return (cast(t_i__qp_i) pFunQt[439])(QtObj, 0);
	}
	int maxLength() {
		return (cast(t_i__qp_i) pFunQt[439])(QtObj, 1);
	}
	int selectionStart() {
		return (cast(t_i__qp_i) pFunQt[439])(QtObj, 2);
	}
	void delet() { //-> удаляет либо один символ, либо выделенный текст
		(cast(t_v__qp_i) pFunQt[440])(QtObj, 0);
	}
	void deselect() {
		(cast(t_v__qp_i) pFunQt[440])(QtObj, 1);
	}
	void backspace() {
		(cast(t_v__qp_i) pFunQt[440])(QtObj, 2);
	}
	void setSelection(int start, int length) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, start, length, 0);
	}
	void setMaxLength(int length) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, 0, length, 1);
	}
	void setCursorPosition(int poz) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, 0, poz, 2);
	}
	void cursorBackward(bool mark, int steps = 1) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, mark ? 1 : 0, steps, 3);
	}
	void cursorForward(bool mark, int steps = 1) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, mark ? 1 : 0, steps, 4);
	}
	void setAllSelection() {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, 0, 0, 5);
	}
	void setEchoMode(QLineEdit.EchoMode echoMode) {
		(cast(t_v__qp_i_i_i) pFunQt[441])(QtObj, echoMode, 0, 6);
	}
}
// ===================== QMainWindow =====================
	/++
QMainWindow - основное окно приложения
+/
class QMainWindow : QWidget {
	this() { /* msgbox( "new QMainWindow(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(6, 89);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	/***
	* Конструктор без явного параметра 'parent' не допускается
	*/
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(6));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i)pFunQt[88])(QtPointer, parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i)pFunQt[88])(QtPointer, null, cast(int)fl));
		}
	} /// QMainWindow::QMainWindow(QWidget * parent = 0, Qt::WindowFlags f = 0)
	QMainWindow setCentralWidget(QWidget wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 0);
		wd.setNoDelete(true);
		return this;
	} ///
	QMainWindow setStatusBar(QStatusBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 2);
		wd.setNoDelete(true);
		 return this;
	} ///
	QMainWindow setMenuBar(QMenuBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 1);
		 return this;
	} ///
	QMainWindow addToolBar(QToolBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 3);
		wd.setNoDelete(true);
		 return this;
	} ///
	QMainWindow setToolBar(QToolBar wd) { //->
		addToolBar(wd);
		wd.setNoDelete(true);
		return this;
	} ///
	QMainWindow addToolBar(QToolBar.ToolBarArea st, QToolBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[126])(QtObj, wd.QtObj, st);
		wd.setNoDelete(true);
		return this;
	} /// добавить ToolBar используя рамещение внизу,вверху т т.д.
	QMainWindow addDockWidget(QtE.DockWidgetArea st, QDockWidget wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[477])(QtObj, wd.QtObj, st);
		wd.setNoDelete(true);
		return this;
	} /// добавить ToolBar используя рамещение внизу,вверху т т.д.

}
// ================ QStatusBar ================
/++
QStatusBar - строка сообщений
+/
class QStatusBar : QWidget {
	QString[] masQString;
	this() { /* msgbox( "new QStatusBar(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		foreach(el; masQString) el.destroy();
		delForPoint(7, 92);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(7));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[91])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[91])(QtPointer, null));
		}
	} /// QStatusBar::QStatusBar(QWidget * parent)
	QStatusBar showMessage(T: QString)(T str, int timeout = 0) { //->
		(cast(t_v__qp_qp_i) pFunQt[93])(QtObj, str.QtObj, timeout);
		return this;
	} /// Установить текст на кнопке
	QStatusBar showMessage(T)(T str, int timeout = 0) { //->
		// QString qs = new QString(to!string(str)); masQString ~= qs;
		// showMessage!QString(qs, timeout);
		(cast(t_v__qp_qp_i) pFunQt[93])(QtObj, sQString(to!string(str)).QtObj, timeout);
		return this;
	} /// Установить текст на кнопке
	QStatusBar addPermanentWidget(QWidget wd, int stretch = 0) { //-> Установить закрепленный справа виджет
		wd.setNoDelete(true);
		(cast(t_v__qp_qp_i_i)pFunQt[314])(QtObj, wd.QtObj, stretch, 0);	return this;
	} /// Установить закрепленный справа виджет
	QStatusBar addWidget(QWidget wd, int stretch = 0) { //-> Установить закрепленный справа виджет
		wd.setNoDelete(true);
		(cast(t_v__qp_qp_i_i)pFunQt[314])(QtObj, wd.QtObj, stretch, 1);	return this;
	} /// Установить закрепленный справа виджет
}

// ================ QAction ================
/++
QAction - это класс выполнителей (действий). Объеденяют в себе
различные формы вызовов:
из меню, из горячих кнопок, их панели с кнопками
и т.д. Реально представляет собой строку меню в вертикальном боксе.
+/
class QAction : QObject {
	QIcon[] masIcon;
	void*   adrActionQt;
	
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		foreach(el; masIcon) el.destroy();
		delForPoint(9, 96);
	}
	// Эксперементаьный, попытка вызвать метод, не используя Extern "C"
	// Любой слот всегда! передаёт в обработчик D два параметра,
	// 1 - Адрес объекта и 2 - N установленный при инициадизации
	this(char ch, void* adrObQt, QWidget parent, void* adr, void* adrThis, int n = 0) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(9));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[95])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[95])(QtPointer, null));
		}
		(cast(t_v__qp_qp_qp_i)pFunQt[98])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis, n);
		if(ch == '+') adrActionQt = adrObQt;
	}
	// Для перехвата Action из QDesigner
	@property void* getAdrActionQt() { return adrActionQt; }
	// Поменять местами eQAction <> QAction
	void swap() {
		void* z = QtObj; 
		setQtObj(cast(QtObjH)adrActionQt); 
		adrActionQt = z;
	}

	// Специализированные слоты для обработки сообщений с параметрами
	// всегда передают Адрес и N (см выше) и дальше сами параметры
	this(QWidget parent, void* adr, void* adrThis, int n = 0) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(9));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[95])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[95])(QtPointer, null));
		}
		(cast(t_v__qp_qp_qp_i)pFunQt[98])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis, n);
	} /// Установить слот с параметром

// ----------------------------------------------------
	void* parent() { //->
		return (cast(t_vp__qp) pFunQt[289])(QtObj);
	}
	QAction setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QAction setText(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, sQString(str).QtObj, 0);
		return this;
	} /// Установить текст
	QAction setToolTip(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QAction setToolTip(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[97])(QtObj, sQString(str).QtObj, 1);
		return this;
	} /// Установить текст
	QAction setHotKey(QtE.Key key) { //->
		(cast(t_v__qp_i) pFunQt[105])(QtObj, cast(int) key);
		return this;
	} /// Определить горячую кнопку
	QAction setHotKey(int key) { //->
		(cast(t_v__qp_i) pFunQt[105])(QtObj, key);
		return this;
	} /// Определить горячую кнопку
// ----------------------------------------------------
	QAction setEnabled(bool f) { //->
		(cast(t_v__qp_b_i) pFunQt[109])(QtObj, f, 0);	return this;
	} /// Включить/выключить пункт меню
	QAction setVisible(bool f) { //->
		(cast(t_v__qp_b_i) pFunQt[109])(QtObj, f, 1);	return this;
	}
	QAction setCheckable(bool f) { //->
		(cast(t_v__qp_b_i) pFunQt[109])(QtObj, f, 2);	return this;
	}
	QAction setChecked(bool f) { //->
		(cast(t_v__qp_b_i) pFunQt[109])(QtObj, f, 3);	return this;
	}
	QAction setIconVisibleInMenu(bool f) { //->
		(cast(t_v__qp_b_i) pFunQt[109])(QtObj, f, 4);	return this;
	}
 	QAction setIcon(QIcon ico) { //->
		(cast(t_v__qp_qp) pFunQt[113])(QtObj, ico.QtObj);
		return this;
	} /// Добавить иконку
 	QAction setIcon(string fileIco) { //->
		QIcon ico = new QIcon(); masIcon ~= ico;
		ico.addFile(fileIco); setIcon(ico); 
		return this;
	} /// Добавить иконку используя имя файла и неявное создание
 	QAction setIcon(string fileIco, QIcon ico) { //->
		ico.addFile(fileIco); setIcon(ico);
		return this;
	} /// Добавить иконку используя имя файла и неявное создание
	QAction Signal_V() { //-> Послать сигнал с QAction "Signal_V()"
		(cast(t_v__qp) pFunQt[339])(QtObj);
		return this;
	}
	QAction Signal_VI(int n) { //-> Послать сигнал с QAction "Signal_V(int)"
		(cast(t_v__qp_i) pFunQt[340])(QtObj, n);
		return this;
	}
	
	QAction Signal_VS(T)(T str) { //-> Послать сигнал с QAction "Signal_VS(string)"
		(cast(t_v__qp_qp) pFunQt[341])(QtObj, sQString(str).QtObj);
		return this;
	}
	@property string fromQmlString() {  //-> return from QML Qstring 
		QString qs = new QString('+', (cast(t_qp__qp) pFunQt[460])(QtObj) );
		return qs.String();
	}
	void toQmlString(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[461])(QtObj, sQString(str).QtObj);
	}
	@property int fromQmlInt() {  //-> return from QML Int 
		return (cast(t_i__qp) pFunQt[462]) (QtObj);
	}
	void toQmlInt(int str) {
		(cast(t_v__qp_i) pFunQt[463])(QtObj, str);
	}	
	@property bool autoRepeat() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 0);
	}
	@property bool isCheckable() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 1);
	}
	@property bool isChecked() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 2);
	}
	@property bool isEnabled() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 3);
	}
	@property bool isIconVisibleInMenu() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 4);
	}
	@property bool isSeparator() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 5);
	}
	@property bool isShortcutVisibleInContextMenu() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 6);
	}
	@property bool isVisible() {
		return (cast(t_b__qp_i) pFunQt[473])(QtObj, 7);
	}
}
// ============ QMenu =======================================
/++
QMenu - колонка меню. Вертикальная.
+/
class QMenu : QWidget {
	this() { /* msgbox( "new QMenu(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(13, 100);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(13));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[99])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[99])(QtPointer, null));
		}
	} /// QMenu::QMenu(QWidget* parent)
 	QMenu addAction(QAction act) { //->
		(cast(t_v__qp_qp) pFunQt[101])(QtObj, act.QtObj);
		return this;
	} /// Вставить вертикальное меню
	QMenu setTitle(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[106])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QMenu setTitle(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[106])(QtObj, sQString(str).QtObj, 1);
		return this;
	} /// Установить текст
	QMenu addSeparator() { //->
		(cast(t_v__qp) pFunQt[107])(QtObj);
		return this;
	}
	QMenu addMenu(QMenu menu) { //->
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
	this() { /* msgbox( "new QMenuBar(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(14, 103);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(14));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[102])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[102])(QtPointer, null));
		}
	} /// QMenuBar::QMenuBar(QWidget* parent)
 	QMenuBar addMenu(QMenu mn) { //->
		(cast(t_v__qp_qp) pFunQt[104])(QtObj, mn.QtObj);
		return this;
	} /// Вставить вертикальное меню
}
// ================ QFont ================
class QFont : QObject {
	this()  { setQtObj((cast(t_qp__v)pFunQt[127])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[128])(QtObj); setQtObj(null); }	
	}
	QFont setPointSize(int size) { //->
		(cast(t_v__qp_i) pFunQt[129])(QtObj, size);
		return this;
	} /// Установить размер шрифта в поинтах
	QFont setFamily(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[130])(QtObj, str.QtObj);
		return this;
	} /// Наименование шрифта Например: "True Times"
	QFont setFamily(T)(T str) { //->
		// setFamily((new QString(to!string(str))));
		(cast(t_v__qp_qp) pFunQt[130])(QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Наименование шрифта Например: "True Times"
	QFont setBold(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 0);	return this;
	}
	QFont setFixedPitch(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 1);	return this;
	}
	QFont setItalic(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 2);	return this;
	}
	QFont setKerning(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 3);	return this;
	}
	QFont setOverline(bool enable) { //-> Верхнее подчеркивание
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 4);	return this;
	}
	QFont setStrikeOut(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 5);	return this;
	}
	QFont setUnderline(bool enable) { //->
		(cast(t_v__qp_b_i) pFunQt[312])(QtObj, enable, 6);	return this;
	}
	bool bold() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 0);
	}
	bool fixedPitch() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 1);
	}
	bool italic() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 2);
	}
	bool kerning() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 3);
	}
	bool overline() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 4);
	}
	bool strikeOut() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 5);
	}
	bool underline() { //->
		return (cast(t_b__qp_i) pFunQt[313])(QtObj, 6);
	}


}

// ================ QIcon ================

/* Пример установки различных иконок в зависимости от состояния (disable/enable)
	QIcon icoAbout = new QIcon();
	icoAbout.addFile("ICONS/doc_error.ico",  null, QIcon.Mode.Disabled, QIcon.State.On);
	icoAbout.addFile("ICONS/about_icon.png", null, QIcon.Mode.Normal,   QIcon.State.On);
	acAbout.setIcon(icoAbout);
*/
class QIcon : QObject {
	enum Mode {
		Normal			= 0,	// Выводит изобр, когда польз не взаимод с пиктограммой, но доступна функциональность, предоставляемая пиктограммой.
		Disabled		= 1,	// Выводит изобр, когда функциональность, предоставляемая пиктограммой, не доступна.
		Active			= 2,	// Выделена (щелкает по ней)
		Selected		= 3		// Выводимое на экран растровое изображение когда пиктограмма выделена.
	}
	enum State {
		On				= 0,	//
		Off				= 1		//
	}
	this()  { setQtObj((cast(t_qp__v)pFunQt[110])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[111])(QtObj); setQtObj(null); }	
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	QIcon addFile(T: QString)(T str, QSize qs = null) { //->
		if(qs is null) {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, str.QtObj, null);
		} else {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, str.QtObj, qs.QtObj);
		}
		return this;
	}
	QIcon addFile(T)(T str, QSize qs = null) { //->
		if(qs is null) {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, sQString(str).QtObj, null);
		} else {
			(cast(t_v__qp_qp_qp) pFunQt[112])(QtObj, sQString(str).QtObj, qs.QtObj);
		}
		return this;
	}
	QIcon addFile(T)(T str, QSize qs, QIcon.Mode mode, QIcon.State state) { //-> Добавить состояние на иконку
		if(qs is null) {
			(cast(t_v__qp_qp_qp_i_i) pFunQt[377])(QtObj, sQString(str).QtObj, null, mode, state);
		} else {
			(cast(t_v__qp_qp_qp_i_i) pFunQt[377])(QtObj, sQString(str).QtObj, qs.QtObj, mode, state);
		}
		return this;
	}
	void swap(QIcon iconSwap) { //-> Заменить иконку на другую
		(cast(t_v__qp_qp) pFunQt[378])(QtObj, iconSwap.QtObj);
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

	this() { /* msgbox( "new QToolBar(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(17, 115);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(17));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp)pFunQt[114])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[114])(QtPointer, null));
		}
	} /// QToolBar::QToolBar(QWidget* parent)
	QToolBar addAction(QAction ac) { //->
		(cast(t_v__qp_qp_i) pFunQt[116])(QtObj, ac.QtObj, 0);
		return this;
	} /// Вставить Action
	QToolBar addWidget(QWidget wd) { //->
		wd.setNoDelete(true);
		(cast(t_v__qp_qp_i) pFunQt[116])(QtObj, wd.QtObj, 1);
		return this;
	} /// Добавить виджет в QToolBar

	QToolBar setToolButtonStyle(QToolBar.ToolButtonStyle st) { //->
		(cast(t_v__qp_i) pFunQt[125])(QtObj, st);
		return this;
	} /// Установить стиль кнопок в ToolBar
	QToolBar setAllowedAreas(QToolBar.ToolBarArea st) {
		(cast(t_v__qp_i) pFunQt[124])(QtObj, st);
		return this;
	} /// Где возможно размещение ToolBar, а не где он будет размещён
	QToolBar addSeparator() { //->
		(cast(t_v__qp_i) pFunQt[132])(QtObj, 0);
		return this;
	} ///
	QToolBar clear() { //->
		(cast(t_v__qp_i) pFunQt[132])(QtObj, 1);
		return this;
	} ///
}
// ================ QDialog ================
class QDialog : QWidget {
	this() { /* msgbox( "new QDialog(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(18, 118);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) { //->
		setQtPointer((cast(t_qp__i)pFunQt[700])(18));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[117])(QtPointer, parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[117])(QtPointer, null, fl));
		}
	} /// Конструктор
	// _________________________ 0 -- bool|isSizeGripEnabled|
	@property bool isSizeGripEnabled() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- int|result|
	@property int result() {
		return (cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- void|setModal|bool%modal
	QDialog setModal(bool modal) {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, cast(int)modal, 2);
		return this;
	}
	// _________________________ 3 -- void|setResult|int%i
	QDialog setResult(int i) {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, i, 3);
		return this;
	}
	// _________________________ 4 -- void|setSizeGripEnabled|bool%xz
	QDialog setSizeGripEnabled(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, cast(int)xz, 4);
		return this;
	}
	// _________________________ 5 -- void|setVisible|bool%visible
	override QDialog setVisible(bool visible) {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, cast(int)visible, 5);
		return this;
	}
	// _________________________ 6 -- void|accept|
	QDialog accept() {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 6);
		return this;
	}
	// _________________________ 7 -- void|done|int%r
	QDialog done(int r) {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, r, 7);
		return this;
	}
	// _________________________ 8 -- int|exec|
	@property int exec() {
		return (cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 8);
	}
	// _________________________ 9 -- void|open|
	QDialog open() {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 9);
		return this;
	}
	// _________________________ 10 -- void|reject|
	QDialog reject() {
		(cast(t_i__qp_i_i) pFunQt[ 306 ])(QtObj, 0, 10);
		return this;
	}
	
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

	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(19, 121);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(19));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[120])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[120])(QtPointer, null));
		}
	} /// Конструктор
	
	// _________________________ 0 -- QString|detailedText|
	@property T detailedText(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return to!T(qsOut.String);
	}
	@property string detailedText() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return qsOut.String;
	}
	@property T detailedText(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 0);
		return qsOut;
	}
	// _________________________ 1 -- QString|informativeText|
	@property T informativeText(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return to!T(qsOut.String);
	}
	@property string informativeText() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return qsOut.String;
	}
	@property T informativeText(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 1);
		return qsOut;
	}
	// _________________________ 2 -- void|setDetailedText|QString%text
	QMessageBox setDetailedText(T)(T text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(text)).QtObj, 2);
		return this;
	}
	QMessageBox setDetailedText(string text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(text).QtObj, 2);
		return this;
	}
	QMessageBox setDetailedText(QString text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, text.QtObj, 2);
		return this;
	}
	// _________________________ 3 -- void|setInformativeText|QString%text
	QMessageBox setInformativeText(T)(T text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(text)).QtObj, 3);
		return this;
	}
	QMessageBox setInformativeText(string text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(text).QtObj, 3);
		return this;
	}
	QMessageBox setInformativeText(QString text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, text.QtObj, 3);
		return this;
	}
	// _________________________ 4 -- void|setText|QString%text
	QMessageBox setText(T)(T text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(text)).QtObj, 4);
		return this;
	}
	QMessageBox setText(string text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(text).QtObj, 4);
		return this;
	}
	QMessageBox setText(QString text) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, text.QtObj, 4);
		return this;
	}
	// _________________________ 5 -- void|setWindowTitle|QString%title
	QMessageBox setWindowTitle(T)(T title) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(title)).QtObj, 5);
		return this;
	}
	QMessageBox setWindowTitle(string title) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, sQString(title).QtObj, 5);
		return this;
	}
	override QMessageBox setWindowTitle(QString title) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, title.QtObj, 5);
		return this;
	}
	// _________________________ 6 -- QString|text|
	@property T text(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return to!T(qsOut.String);
	}
	@property string text() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return qsOut.String;
	}
	@property T text(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 122 ])(QtObj, 0, qsOut.QtObj, null, 6);
		return qsOut;
	}	
	
	// _________________________ 0 -- QMessageBox::Icon|icon|
	@property QMessageBox.Icon icon() {
		return cast(QMessageBox.Icon)(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- void|setDefaultButton|QMessageBox::StandardButton%button
	QMessageBox setDefaultButton(QMessageBox.StandardButton button) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)button, 1);
		return this;
	}
	// _________________________ 2 -- void|setEscapeButton|QMessageBox::StandardButton%button
	QMessageBox setEscapeButton(QMessageBox.StandardButton button) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)button, 2);
		return this;
	}
	// _________________________ 3 -- void|setIcon|QMessageBox::Icon%xz
	QMessageBox setIcon(QMessageBox.Icon xz) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)xz, 3);
		return this;
	}
	// _________________________ 4 -- void|setStandardButtons|QMessageBox::StandardButtons%buttons
	QMessageBox setStandardButtons(QMessageBox.StandardButton buttons) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)buttons, 4);
		return this;
	}
	// _________________________ 5 -- void|setTextFormat|Qt::TextFormat%format
	QMessageBox setTextFormat(QtE.TextFormat format) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)format, 5);
		return this;
	}
	// _________________________ 6 -- void|setTextInteractionFlags|Qt::TextInteractionFlags%flags
	QMessageBox setTextInteractionFlags(QtE.TextInteractionFlag flags) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)flags, 6);
		return this;
	}
	// _________________________ 7 -- void|setWindowModality|Qt::WindowModality%windowModality
	QMessageBox setWindowModality(QtE.WindowModality windowModality) {
		(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, cast(int)windowModality, 7);
		return this;
	}
	// _________________________ 8 -- QMessageBox::StandardButtons|standardButtons|
	@property QMessageBox.StandardButton standardButtons() {
		return cast(QMessageBox.StandardButton)(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, 0, 8);
	}
	// _________________________ 9 -- Qt::TextFormat|textFormat|
	@property QtE.TextFormat textFormat() {
		return cast(QtE.TextFormat)(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, 0, 9);
	}
	// _________________________ 10 -- Qt::TextInteractionFlags|textInteractionFlags|
	@property QtE.TextInteractionFlag textInteractionFlags() {
		return cast(QtE.TextInteractionFlag)(cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, 0, 10);
	}
	// _________________________ 11 -- int|exec|
	override @property int exec() {
		return (cast(t_i__qp_i_i) pFunQt[ 123 ])(QtObj, 0, 11);
	}	
	
	
/*	
	QMessageBox setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QMessageBox setText(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, sQString(to!string(str)).QtObj, 0); return this;
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T: QString)(T str) { //-> 
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T)(T str) { //-> 
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, sQString(to!string(str)).QtObj, 1); return this;
	} /// Установить текст
	QMessageBox setInformativeText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 2);
		return this;
	} /// Установить текст
	QMessageBox setInformativeText(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, sQString(to!string(str)).QtObj, 2);
		return this;
	} /// Установить текст
	QMessageBox setStandardButtons(QMessageBox.StandardButton buttons) { //->
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 0);
		return this;
	} /// Установить стандартный набор кнопок
	QMessageBox setDefaultButton(QMessageBox.StandardButton buttons) { //->
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 1);
		return this;
	} /// Установить кнопку по умолчанию
	QMessageBox setEscapeButton(QMessageBox.StandardButton buttons) { //->
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)buttons, 2);
		return this;
	} /// Установить кнопку отмены
	QMessageBox setIcon(QMessageBox.Icon icon) { //->
		(cast(t_v__qp_qp_i) pFunQt[123])(QtObj, cast(QtObjH)icon, 3);
		return this;
	} /// Установить стандартную иконку из числа QMessage.Icon. (NoIcon, Information, Warning, Critical, Question)
*/
}

// ================ QProgressBar ================
/++
QProgressBar - это ....
+/
class QProgressBar : QWidget {
	this() { /* msgbox( "new QProgressBar(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(20, 134);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(20));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[133])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[133])(QtPointer, null));
		}
	} /// Конструктор
	QProgressBar setMinimum(int n) { //->
		(cast(t_v__qp_i_i) pFunQt[135])(QtObj, n, 0); return this;
	} /// Установить нижнию границу
	QProgressBar setMaximum(int n) { //->
		(cast(t_v__qp_i_i) pFunQt[135])(QtObj, n, 1); return this;
	} /// Установить верхнию границу
	QProgressBar setValue(int n) { //->
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
	this()  { setQtObj((cast(t_qp__v)pFunQt[136])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[137])(QtObj); setQtObj(null); }	
	}
	
	QString toQString(QString shabl) { //->
		QString qs = new QString();
		(cast(t_v__qp_qp_qp)pFunQt[140])(QtObj, qs.QtObj, shabl.QtObj);
		return qs;
	} /// Выдать содержимое в QString
	string toString(T1)(T1 shabl) { //->
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
	this()  { setQtObj((cast(t_qp__v)pFunQt[138])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[139])(QtObj); setQtObj(null); }	
	}

	QString toQString(QString shabl) { //->
		QString qs = new QString();
		(cast(t_v__qp_qp_qp)pFunQt[141])(QtObj, qs.QtObj, shabl.QtObj);
		return qs;
	} /// Выдать содержимое в QString
	string toString(T1)(T1 shabl) { //->
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
	private extern (C) @nogc alias
	t_v__qp_qp_qp_qp_qp_qp_i =
		void function(QtObjH, QtObjH, QtObjH, QtObjH, QtObjH, QtObjH, int);

	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[143])(QtObj); setQtObj(null); }
	}
	
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[142])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[142])(null, fl));
		}
	} /// Конструктор
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	QFileDialog setNameFilter(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 0);
		return this;
	} /// Установить фильтр для выбираемых файлов
	QFileDialog setNameFilter(T1)(T1 shabl) { //->
		// setNameFilter(new QString(to!string(shabl)));
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, sQString(to!string(shabl)).QtObj, 0);
		return this;
	} /// Установить фильтр для выбираемых файлов
	QFileDialog selectFile(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 1);
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog selectFile(T1)(T1 shabl) { //->
		// setNameFilter(new QString(to!string(shabl)));
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, sQString(to!string(shabl)).QtObj, 1);
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog setDirectory(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 2);
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDirectory(T1)(T1 shabl) { //->
		// setNameFilter(new QString(to!string(shabl)));
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, sQString(to!string(shabl)).QtObj, 2);
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDefaultSuffix(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 3);
		return this;
	} /// "txt" - добавит эту строку к имени файла, если нет расширения
	QFileDialog setDefaultSuffix(T1)(T1 shabl) { //->
		// setNameFilter(new QString(to!string(shabl)));
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, sQString(to!string(shabl)).QtObj, 3);
		return this;
	} /// "txt" - добавит эту строку к имени файла, если нет расширения
	QFileDialog setViewMode(QFileDialog.ViewMode pr) { //->
		(cast(t_v__qp_i)pFunQt[145])(QtObj, pr);
		return this;
	}

	// Выбор файла для открытия
	string getOpenFileNameSt( //->
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

		(cast(t_v__qp_qp_qp_qp_qp_qp_i)pFunQt[274])
			(QtObj, qrez.QtObj,
			qcaption.QtObj, qdir.QtObj, qfilter.QtObj,
			qselectedFilter.QtObj, options);
		return qrez.String;
	}

	// Выбор файла для открытия
	string getOpenFileName( //->
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
	string getSaveFileNameSt( //->
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

		(cast(t_v__qp_qp_qp_qp_qp_qp_i)pFunQt[275])
			(QtObj, qrez.QtObj,
			qcaption.QtObj, qdir.QtObj, qfilter.QtObj,
			qselectedFilter.QtObj, options);
		return qrez.String;
	}

	// Выбор файла для сохранения. Позволяет выбрать не существующий файл
	string getSaveFileName( //->
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

	enum ViewMode {
		SubWindowView	= 0,	// Display sub-windows with window frames (default).
		TabbedView		= 1		// Display sub-windows with tabs in a tab bar.
	}
	
	this() { /* msgbox( "new QMdiArea(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[152])(QtObj); setQtObj(null); }
		delForPoint(21, 152);
	}
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(21));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[151])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[151])(QtPointer, null));
		}
	} /// Конструктор
	void* addSubWindow(QWidget wd, QtE.WindowType fl = QtE.WindowType.Widget) { //->
		return (cast(t_qp__qp_qp_i)pFunQt[155])(QtObj, wd.QtObj, cast(int)fl);
	}
	void* activeSubWindow() { //-> Указатель на активное в данный момент окно
		return (cast(t_qp__qp)pFunQt[338])(QtObj);
	}
	@property bool documentMode() {
		return (cast(t_b__qp_i)pFunQt[431])(QtObj, 0);
	}
	@property bool tabsClosable() {
		return (cast(t_b__qp_i)pFunQt[431])(QtObj, 1);
	}
	@property bool tabsMovable() {
		return (cast(t_b__qp_i)pFunQt[431])(QtObj, 2);
	}

	void setDocumentMode(bool b) {
		(cast(t_v__qp_b_i)pFunQt[432])(QtObj, b, 0);
	}
	void setTabsClosable(bool b) {
		(cast(t_v__qp_b_i)pFunQt[432])(QtObj, b, 1);
	}
	void setTabsMovable(bool b) {
		(cast(t_v__qp_b_i)pFunQt[432])(QtObj, b, 2);
	}
	void removeSubWindow(QWidget wd) {
		(cast(t_v__qp_qp)pFunQt[433])(QtObj, wd.QtObj);
	}
	void setViewMode( QMdiArea.ViewMode mode) {
		(cast(t_v__qp_i)pFunQt[434])(QtObj, mode);
	}
}
// ================ QMdiSubWindow ================
class QMdiSubWindow : QWidget {
	this() { /* msgbox( "new QMdiSubWindow(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(21, 134);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(21));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[153])(QtPointer, parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[153])(QtPointer, null, fl));
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
		setQtObj((cast(t_qp__qp) pFunQt[159])(parent ? parent.QtObj : null));
 	} /// Конструктор
 */
}
// ============ QTableView ==================
class QTableView : QAbstractItemView {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[160])(QtObj); setQtObj(null); }
	}
	
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if(parent !is null) setNoDelete(true);
		setQtObj((cast(t_qp__qp) pFunQt[159])(parent ? parent.QtObj : null));
 	} /// Конструктор
	QTableView setColumnWidth(int column, int width) { //->
		(cast(t_v__qp_i_i_i) pFunQt[174])(QtObj, column, width, 0); return this;
	}
	int columnWidth(int column) { //->
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, column, 0);
	}
	QTableView setRowHeight(int row, int height) { //->
		(cast(t_v__qp_i_i_i) pFunQt[174])(QtObj, row, height, 1); return this;
	}
	int rowHeight(int row) { //->
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, row, 1);
	}
	int columnAt(int column) { //->
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, column, 2);
	}
	int rowAt(int row) { //->
		return (cast(t_i__qp_i_i) pFunQt[175])(QtObj, row, 3);
	}
	QTableView showColumn(int column) { //->
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, column, 4); return this;
	}
	QTableView hideColumn(int column) { //->
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, column, 5); return this;
	}
	QTableView showRow(int row) { //->
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, row, 6); return this;
	}
	QTableView hideRow(int row) { //->
		(cast(t_v__qp_i_i) pFunQt[175])(QtObj, row, 7); return this;
	}
 	QTableView ResizeModeColumn(int column, QHeaderView.ResizeMode rm = QHeaderView.ResizeMode.Stretch) { //->
		(cast(t_v__qp_i_i_i) pFunQt[182])(QtObj, column, rm, 0); return this;
	}
	QTableView ResizeModeRow(int row, QHeaderView.ResizeMode rm = QHeaderView.ResizeMode.Stretch) { //->
		(cast(t_v__qp_i_i_i) pFunQt[182])(QtObj, row, rm, 1); return this;
	}

//	funQt(182, bQtE6Widgets, hQtE6Widgets, sQtE6Widgets, "qteQTableView_ResizeMode",		showError);

}
// ============ QTableWidget ==================
class QTableWidget : QTableView {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[162])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if(parent !is null) setNoDelete(true);
		setQtObj((cast(t_qp__qp) pFunQt[161])(parent ? parent.QtObj : null));
 	} /// Конструктор
	QTableWidget setRowCount(int row) { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, row, 1); return this;
	}
	QTableWidget setColumnCount(int col) { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, col, 0); return this;
	}
	QTableWidget insertRow(int row) { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, row, 3); return this;
	}
	QTableWidget insertColumn(int col) { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, col, 2); return this;
	}
	QTableWidget clear() { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, 0, 4); return this;
	}
	QTableWidget clearContents() { //->
		(cast(t_v__qp_i_i) pFunQt[163])(QtObj, 0, 5); return this;
	} /// Удалено содержание, но заголовки и прочее остаётся

	QTableWidget setItem(int r, int c, QTableWidgetItem twi) { //->
		twi.setNoDelete(true);
		(cast(t_v__qp_qp_i_i) pFunQt[167])(QtObj, twi.QtObj, r, c); return this;
	}
	QTableWidget setHorizontalHeaderItem(int c, QTableWidgetItem twi) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[176])(QtObj, twi.QtObj, c, 0); return this;
	}
	QTableWidget setVerticalHeaderItem(int row, QTableWidgetItem twi) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[176])(QtObj, twi.QtObj, row, 1); return this;
	}
	QTableWidget setCurrentCell(int row, int column) { //->
		(cast(t_v__qp_i_i) pFunQt[241])(QtObj, row, column); return this;
	}
	int currentColumn() { //-> Выдать текущую колонку
		return (cast(t_i__qp_i) pFunQt[369])(QtObj, 0);
	}
	int currentRow() { //-> Выдать текущую строку
		return (cast(t_i__qp_i) pFunQt[369])(QtObj, 1);
	}
	override int colorCount() { //-> Выдать доступное для рисования количество цветов
		return (cast(t_i__qp_i) pFunQt[369])(QtObj, 2);
	}
	QTableWidgetItem item(int row, int col) { //-> Выдать указатеь на QTableItem для дальнейшей обработки
		QTableWidgetItem twi = new QTableWidgetItem('+', (cast(t_qp__qp_i_i) pFunQt[370])(QtObj, row, col));
		twi.setNoDelete(true);
		return twi;
	}
	QTableWidgetItem takeItem(int row, int col) { //-> Выдать указатеь на QTableItem для дальнейшей обработки
		return new QTableWidgetItem('+', (cast(t_qp__qp_i_i) pFunQt[371])(QtObj, row, col));
	}


/* 	QString toQString(QString shabl) {
		QString qs = new QString();
		(cast(t_v__qp_qp_qp)pFunQt[141])(QtObj, qs.QtObj, shabl.QtObj);
		return qs;
	}
 */}

// =========== QTableWidgetItem ========
class QTableWidgetItem : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[165])(QtObj); setQtObj(null); }
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
	QTableWidgetItem setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст в ячейке
	QTableWidgetItem setText(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, sQString(str).QtObj, 0);
		return this;
	} /// Установить текст в ячейке
	QTableWidgetItem setToolTip(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 1);
		return this;
	}
	QTableWidgetItem setToolTip(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, sQString(str).QtObj, 1);
		return this;
	}
	QTableWidgetItem setStatusTip(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 2);
		return this;
	}
	QTableWidgetItem setStatusTip(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, sQString(str).QtObj, 2);
		return this;
	}
	QTableWidgetItem setWhatsThis(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, str.QtObj, 3);
		return this;
	}
	QTableWidgetItem setWhatsThis(T)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[166])(QtObj, sQString(str).QtObj, 3);
		return this;
	}
	int column() { //->
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 0);
	}
	int row() { //->
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 1);
	}
	int textAlignment() { //->
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 2);
	}
	int type() { //->
		return (cast(t_i__qp_i) pFunQt[168])(QtObj, 3);
	}
	T text(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[170])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String

 	QTableWidgetItem setTextAlignment(QtE.AlignmentFlag alig = QtE.AlignmentFlag.AlignLeft) { //->
		(cast(t_v__qp_i)pFunQt[171])(QtObj, alig);
		return this;
	}
 	QTableWidgetItem setBackground(QBrush brush) { //->
		(cast(t_v__qp_qp_i)pFunQt[180])(QtObj, brush.QtObj, 0);
		return this;
	}
 	QTableWidgetItem setForeground(QBrush brush) { //->
		(cast(t_v__qp_qp_i)pFunQt[180])(QtObj, brush.QtObj, 1);
		return this;
	}
 	QTableWidgetItem setFlags(QtE.ItemFlag flags) { //-> Установить флаги на ячейку. Выбирать, редактировать и т.д.
		(cast(t_v__qp_i)pFunQt[372])(QtObj, flags);
		return this;
	}
 	QtE.ItemFlag flags() { //-> Прочитать флаги на ячейку.
		return cast(QtE.ItemFlag)(cast(t_i__qp)pFunQt[373])(QtObj);
	}
 	QTableWidgetItem setSelected(bool select) { //-> Установить признак "выбран"
		(cast(t_v__qp_b)pFunQt[374])(QtObj, select);
		return this;
	}
 	bool isSelected() { //->
		return (cast(t_b__qp)pFunQt[375])(QtObj);
	}
	QTableWidgetItem  setIcon(QIcon ik) { //->
		(cast(t_v__qp_qp) pFunQt[376])(QtObj, ik.QtObj); return this;
	} ///
}
// ================ QComboBox ================
/++
QComboBox (Выподающий список), но немного модифицированный в QtE.DLL.
+/
class QComboBox : QWidget {
	this() { /* msgbox( "new QComboBox(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[184])(QtObj); setQtObj(null); }
		delForPoint(23, 184);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(23));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[183])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[183])(QtPointer, null));
		}
	} /// Конструктор
	QComboBox addItem(QString str, int i) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, str.QtObj, i, 0); return this;
	} /// Добавить строку str с значением i
	QComboBox addItem(string s, int i) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, sQString(s).QtObj, i, 0); return this;
	}
	QComboBox setItemText(QString str, int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, str.QtObj, n, 1); return this;
	} /// Заменить строку, значение i не меняется
	QComboBox setItemText(string s, int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, sQString(s).QtObj, n, 1); return this;
	}
	QComboBox setMaxCount(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 2); return this;
	}
	QComboBox setMaxVisibleItems(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 3); return this;
	}
	QComboBox setCurrentIndex(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 4); return this;
	}
	QComboBox insertSeparator(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 5); return this;
	}
	QComboBox removeItem(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 6); return this;
	}
	QComboBox setMinimumContentsLength(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 7); return this;
	}
	QComboBox setModelColumn(int n) { //->
		(cast(t_v__qp_qp_i_i) pFunQt[185])(QtObj, null, n, 8); return this;
	}
	int currentIndex() { //->
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 0);
	}
	int count() { //->
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 1);
	}
	int maxCount() { //->
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 2);
	}
	int maxVisibleItems() { //->
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 3);
	}
	int currentData() { //->
		return (cast(t_i__qp_i) pFunQt[186])(QtObj, 4);
	}
	QComboBox clear() { //->
		(cast(t_i__qp_i) pFunQt[186])(QtObj, 5); return this;
	}
	T text(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[187])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() {  //->
		return to!T(text!QString().String);
	} /// Выдать всё содержимое в String

//		setQtObj((cast(t_qp__qp) pFunQt[161])(parent ? parent.QtObj : null));
}
// ================ QPen ================
class QPen : QObject {
	this()  { setQtObj((cast(t_qp__v) pFunQt[191])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[192])(QtObj); setQtObj(null); }	
	}
	this(QColor color) {
		setQtObj((cast(t_qp__qp) pFunQt[396])(color.QtObj));
	} /// Конструктор
	QPen setColor(QColor color) { //->
		(cast(t_v__qp_qp) pFunQt[193])(QtObj, color.QtObj);
		return this;
	}
	QPen setStyle(QtE.PenStyle ps = QtE.PenStyle.SolidLine) { //->
		(cast(t_v__qp_i) pFunQt[194])(QtObj, ps);
		return this;
	}
	QPen setWidth(int w) { //->
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
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[199])(QtObj); setQtObj(null); }
		delForPoint(28, 199);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		// super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(28));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[198])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[198])(QtPointer, null));
		}
	} /// Конструктор
	this(int kolNumber, QWidget parent = null) {
		// super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(28));
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[200])(QtPointer, parent.QtObj, kolNumber));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[200])(QtPointer, null, kolNumber));
		}
	} /// Конструктор
	QLCDNumber display(int n) { //->
		(cast(t_v__qp_i) pFunQt[201])(QtObj, n); return this;
	} /// Отобразить число
	QLCDNumber setSegmentStyle(QLCDNumber.SegmentStyle style) { //->
		(cast(t_v__qp_i) pFunQt[202])(QtObj, cast(int)style);  return this;
	} /// Способ изображения сегментов
	QLCDNumber setDigitCount(int kolNumber) { //->
		(cast(t_v__qp_i) pFunQt[203])(QtObj, kolNumber); return this;
	} /// Установить количество показываемых цифр
	QLCDNumber setMode(QLCDNumber.Mode mode) { //->
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
	QAbstractSlider setMaximum( int n ) { //->
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 0); return this;
	}
	QAbstractSlider setMinimum( int n ) { //->
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 1); return this;
	}
	QAbstractSlider setPageStep( int n ) { //->
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 2); return this;
	}
	QAbstractSlider setSingleStep( int n ) { //->
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 3); return this;
	}
	QAbstractSlider setSliderPosition( int n ) { //->
		(cast(t_v__qp_i_i) pFunQt[205])(QtObj, n, 4); return this;
	}
	int maximum() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 0); }
	int minimum() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 1); }
	int pageStep() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 2); }
	int singleStep() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 3); }
	int sliderPosition() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 4); }
	int value() {  //->
		return (cast(t_i__qp_i) pFunQt[208])(QtObj, 5); }
}
// ============ QSlider =======================================
class QSlider : QAbstractSlider {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[207])(QtObj); setQtObj(null); }
		delForPoint(24, 207);
	}
	
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent = null, QtE.Orientation n = QtE.Orientation.Horizontal) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(24));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[206])(QtPointer, parent.QtObj, cast(int)n));
		} else {
			setQtObj((cast(t_qp__qp_qp_i) pFunQt[206])(QtPointer, null, cast(int)n));
		}
	} /// Конструктор
}
// ================ QGroupBox ================
class QGroupBox : QWidget {
	this() { /* msgbox( "new QGroupBox(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[213])(QtObj); setQtObj(null); }
		delForPoint(25, 213);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent) {
		setQtPointer((cast(t_qp__i)pFunQt[700])(25));
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp)pFunQt[212])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp)pFunQt[212])(QtPointer, null));
		}
	}
	QGroupBox setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[214])(QtObj, str.QtObj);
		return this;
	} /// Установить текст
	QGroupBox setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[214])(QtObj, sQString(str).QtObj);
		return this;
	} /// Установить текст
	QGroupBox setAlignment(QtE.AlignmentFlag fl) { //->
		(cast(t_v__qp_i) pFunQt[215])(QtObj, fl);
		return this;
	} /// Выровнять текст

}
// ================ QCheckBox ================
class QCheckBox : QAbstractButton { //=> Кнопки CheckBox независимые
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[217])(QtObj); setQtObj(null); }
	}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(null, str.QtObj));
		}
	} /// Создать кнопку.
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(parent.QtObj, sQString(str).QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[216])(null, sQString(str).QtObj));
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
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[223])(QtObj); setQtObj(null); }
	}
	this(T: QString)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(parent.QtObj, str.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(null, str.QtObj));
		}
	} /// Создать кнопку.
	this(T)(T str, QWidget parent = null) {
		// super(); // Это фактически заглушка, что бы сделать наследование,
		// не создавая промежуточного экземпляра в Qt
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(parent.QtObj, sQString(str).QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[222])(null, sQString(str).QtObj));
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
	enum SelectionType {
		Document	= 3,	// Selects the entire document.
		BlockUnderCursor	= 2,	// Selects the block of text under the cursor.
		LineUnderCursor		= 1,	// Selects the line of text under the cursor.
		WordUnderCursor		= 0		// Selects the word under the cursor.
		// If the cursor is not positioned within a string of selectable characters, no text is selected.
	}
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[228])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(void* ukDocument) {
		setQtObj((cast(t_qp__qp)pFunQt[227])(cast(QtObj__*)ukDocument));
	}
	this(QWidget* pr) {
		setQtObj((cast(t_qp__v)pFunQt[229])());
	}
	int anchor() { //->
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 0);
	}
	int blockNumber() { //->
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
	int selectionEnd() { //->
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 5);
	}
	int selectionStart() { //->
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 6);
	}
	int verticalMovementX() { //-> Количество пикселей с левого края
		return (cast(t_i__qp_i) pFunQt[231])(QtObj, 7);
	}
	QTextCursor setPosition(int pos, QTextCursor.MoveMode mode = QTextCursor.MoveMode.MoveAnchor) { //->
		(cast(t_v__qp_i_i) pFunQt[327])(QtObj, pos, mode); return this;
	}
	bool movePosition( //->
		QTextCursor.MoveOperation operation,
		QTextCursor.MoveMode mode = QTextCursor.MoveMode.MoveAnchor,
		int n = 1) { //-> Передвинуть текстовый курсор
		return (cast(t_b__qp_i_i_i) pFunQt[254])(QtObj, operation, mode, n);
	}
	// 255
	QTextCursor beginEditBlock() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 0); return this;
	}
	QTextCursor endEditBlock() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 4); return this;
	}
	QTextCursor clearSelection() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 1); return this;
	}
	QTextCursor deleteChar() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 2); return this;
	}
	QTextCursor deletePreviousChar() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 3); return this;
	}
	QTextCursor insertBlock() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 5); return this;
	}
	QTextCursor removeSelectedText() { //->
		(cast(t_v__qp_i) pFunQt[255])(QtObj, 6); return this;
	}

	QTextCursor insertText(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[256])(QtObj, str.QtObj);
		return this;
	} /// Установить текст
	QTextCursor insertText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[256])(QtObj, sQString(str).QtObj);
		return this;
	} /// Установить текст
	QTextCursor select(SelectionType type) { //-> Установить выделение
		(cast(t_v__qp_i) pFunQt[286])(QtObj, type); return this;
	}


}
// ================ QRect ================
class QRect : QObject {
	this()  { setQtObj((cast(t_qp__v)pFunQt[232])()); }
	this(int x, int y, int width, int height)  { 
		setQtObj((cast(t_qp__i_i_i_i)pFunQt[1235])(x, y, width, height));	
	}
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[233])(QtObj); setQtObj(null); }	
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	QRect setCoords(int x1, int y1, int x2, int y2) { //-> Задать координаты
		writeln(QtObj, " -- ", x1, " -- ", x2);
		(cast(t_v__qp_i_i_i_i_i) pFunQt[242])(QtObj, x1, y1, x2, y2, 0); return this;
	}
	QRect setRect(int x1, int y1, int width, int height) { //-> Задать верх лев угол и длину + ширину
		(cast(t_v__qp_i_i_i_i_i) pFunQt[242])(QtObj, x1, y1, width, height, 1); return this;
	}
	// _________________________ 0 -- int|bottom|
	@property int bottom() {
		writeln(" pFunQt[ 1234 ] = ", pFunQt[ 1234 ]);
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- int|height|
	@property int height() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- bool|isEmpty|
	@property bool isEmpty() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 2);
	}
	// _________________________ 3 -- bool|isNull|
	@property bool isNull() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 3);
	}
	// _________________________ 4 -- bool|isValid|
	@property bool isValid() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 4);
	}
	// _________________________ 5 -- int|left|
	@property int left() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 5);
	}
	// _________________________ 6 -- void|moveBottom|int%y
	QRect moveBottom(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, y, 6);
		return this;
	}
	// _________________________ 7 -- void|moveLeft|int%x
	QRect moveLeft(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, x, 7);
		return this;
	}
	// _________________________ 8 -- void|moveRight|int%x
	QRect moveRight(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, x, 8);
		return this;
	}
	// _________________________ 9 -- void|moveTop|int%y
	QRect moveTop(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, y, 9);
		return this;
	}
	// _________________________ 10 -- int|right|
	@property int right() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 10);
	}
	// _________________________ 11 -- void|setBottom|int%y
	QRect setBottom(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, y, 11);
		return this;
	}
	// _________________________ 12 -- void|setHeight|int%height
	QRect setHeight(int height) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, height, 12);
		return this;
	}
	// _________________________ 13 -- void|setLeft|int%x
	QRect setLeft(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, x, 13);
		return this;
	}
	// _________________________ 14 -- void|setRight|int%x
	QRect setRight(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, x, 14);
		return this;
	}
	// _________________________ 15 -- void|setTop|int%y
	QRect setTop(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, y, 15);
		return this;
	}
	// _________________________ 16 -- void|setWidth|int%width
	QRect setWidth(int width) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, width, 16);
		return this;
	}
	// _________________________ 17 -- void|setX|int%x
	QRect setX(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, x, 17);
		return this;
	}
	// _________________________ 18 -- void|setY|int%y
	QRect setY(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, y, 18);
		return this;
	}
	// _________________________ 19 -- int|top|
	@property int top() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 19);
	}
	// _________________________ 20 -- int|width|
	@property int width() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 20);
	}
	// _________________________ 21 -- int|x|
	@property int x() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 21);
	}
	// _________________________ 22 -- int|y|
	@property int y() {
		return (cast(t_i__qp_i_i) pFunQt[ 1234 ])(QtObj, 0, 22);
	}	
	
	
}
// ================ QTextBlock ================
struct sQTextBlock {
	//____________________________
private:
	QtObjH adrCppObj;
	//____________________________
public:
	@disable this();
	@property QtObjH QtObj()	{ 	return adrCppObj;	}
	void setQtObj(QtObjH adr)	{ 	adrCppObj = adr; 	}
	//____________________________
	~this() { del(); }
	// this()  { setQtObj((cast(t_qp__v)pFunQt[238])());	}
	void del() { 
		(cast(t_v__qp)pFunQt[239])(QtObj); setQtObj(null);	
	}
	this(QTextCursor tk) {	setQtObj((cast(t_qp__qp)pFunQt[240])(tk.QtObj));	}
	T text(T: QString)() { //-> Содержимое блока в QString
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[237])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	@property int blockNumber() { //->
		return (cast(t_i__qp)pFunQt[283])(QtObj);
	}
	void next(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 0);
	}
	void previous(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 1);
	}
	@property bool isValid() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 0);
	}
	@property bool isVisible() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 1);
	}
}

class QTextBlock : QObject {
	this()  { setQtObj((cast(t_qp__v)pFunQt[238])());	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[239])(QtObj); setQtObj(null); }	
	}
	this(QTextCursor tk) {
		setQtObj((cast(t_qp__qp)pFunQt[240])(tk.QtObj));
	}
	T text(T: QString)() { //-> Содержимое блока в QString
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[237])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	@property int blockNumber() { //->
		return (cast(t_i__qp)pFunQt[283])(QtObj);
	}
	void next(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 0);
	}
	void previous(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 1);
	}
	@property bool isValid() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 0);
	}
	@property bool isVisible() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 1);
	}

}
// ============ QAbstractSpinBox =======================================
class QAbstractSpinBox : QWidget {
	enum ButtonSymbols {
		UpDownArrows	= 0,	//	Little arrows in the classic style.
		PlusMinus		= 1,	//	+ and - symbols.
		NoButtons		= 2		//	Don't display buttons.	
	}
	enum CorrectionMode {
		CorrectToPreviousValue	= 0, 	// The spinbox will revert to the last valid value.
		CorrectToNearestValue	= 1		// The spinbox will revert to the nearest valid value.
	}

	this() {}
	this(QWidget parent) {}
	~this() {
	}
	// _________________________ 0 -- Qt::Alignment|alignment|
	@property QtE.AlignmentFlag alignment() {
		return cast(QtE.AlignmentFlag)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- QAbstractSpinBox::ButtonSymbols|buttonSymbols|
	@property QAbstractSpinBox.ButtonSymbols buttonSymbols() {
		return cast(QAbstractSpinBox.ButtonSymbols)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- QAbstractSpinBox::CorrectionMode|correctionMode|
	@property QAbstractSpinBox.CorrectionMode correctionMode() {
		return cast(QAbstractSpinBox.CorrectionMode)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 2);
	}
	// _________________________ 3 -- bool|hasAcceptableInput|
	@property bool hasAcceptableInput() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 3);
	}
	// _________________________ 4 -- bool|hasFrame|
	@property bool hasFrame() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 4);
	}
	// _________________________ 5 -- void|interpretText|
	QAbstractSpinBox interpretText() {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 5);
		return this;
	}
	// _________________________ 6 -- bool|isAccelerated|
	@property bool isAccelerated() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 6);
	}
	// _________________________ 7 -- bool|isGroupSeparatorShown|
	@property bool isGroupSeparatorShown() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 7);
	}
	// _________________________ 8 -- bool|isReadOnly|
	@property bool isReadOnly() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 8);
	}
	// _________________________ 9 -- bool|keyboardTracking|
	@property bool keyboardTracking() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 9);
	}
	// _________________________ 10 -- void|setAccelerated|bool%on
	QAbstractSpinBox setAccelerated(bool on) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)on, 10);
		return this;
	}
	// _________________________ 11 -- void|setAlignment|Qt::Alignment%flag
	QAbstractSpinBox setAlignment(QtE.AlignmentFlag flag) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)flag, 11);
		return this;
	}
	// _________________________ 12 -- void|setButtonSymbols|QAbstractSpinBox::ButtonSymbols%bs
	QAbstractSpinBox setButtonSymbols(QAbstractSpinBox.ButtonSymbols bs) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)bs, 12);
		return this;
	}
	// _________________________ 13 -- void|setCorrectionMode|QAbstractSpinBox::CorrectionMode%cm
	QAbstractSpinBox setCorrectionMode(QAbstractSpinBox.CorrectionMode cm) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)cm, 13);
		return this;
	}
	// _________________________ 14 -- void|setFrame|bool%xz
	QAbstractSpinBox setFrame(bool xz) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)xz, 14);
		return this;
	}
	// _________________________ 15 -- void|setGroupSeparatorShown|bool%shown
	QAbstractSpinBox setGroupSeparatorShown(bool shown) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)shown, 15);
		return this;
	}
	// _________________________ 16 -- void|setKeyboardTracking|bool%kt
	QAbstractSpinBox setKeyboardTracking(bool kt) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)kt, 16);
		return this;
	}
	// _________________________ 17 -- void|setReadOnly|bool%r
	QAbstractSpinBox setReadOnly(bool r) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)r, 17);
		return this;
	}
	// _________________________ 18 -- void|setWrapping|bool%w
	QAbstractSpinBox setWrapping(bool w) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, cast(int)w, 18);
		return this;
	}
	// _________________________ 19 -- void|stepBy|int%steps
	QAbstractSpinBox stepBy(int steps) {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, steps, 19);
		return this;
	}
	// _________________________ 20 -- bool|wrapping|
	@property bool wrapping() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 20);
	}
	// _________________________ 21 -- void|clear|
	QAbstractSpinBox clear() {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 21);
		return this;
	}
	// _________________________ 22 -- void|selectAll|
	QAbstractSpinBox selectAll() {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 22);
		return this;
	}
	// _________________________ 23 -- void|stepDown|
	QAbstractSpinBox stepDown() {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 23);
		return this;
	}
	// _________________________ 24 -- void|stepUp|
	QAbstractSpinBox stepUp() {
		(cast(t_i__qp_i_i) pFunQt[ 252 ])(QtObj, 0, 24);
		return this;
	}
	// _________________________ 0 -- void|fixup|QString%input
	QAbstractSpinBox fixup(T)(T input) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(input)).QtObj, 0);
		return this;
	}
	QAbstractSpinBox fixup(string input) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, sQString(input).QtObj, 0);
		return this;
	}
	QAbstractSpinBox fixup(QString input) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, input.QtObj, 0);
		return this;
	}
	// _________________________ 1 -- void|setSpecialValueText|QString%txt
	QAbstractSpinBox setSpecialValueText(T)(T txt) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, sQString(to!string(txt)).QtObj, 1);
		return this;
	}
	QAbstractSpinBox setSpecialValueText(string txt) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, sQString(txt).QtObj, 1);
		return this;
	}
	QAbstractSpinBox setSpecialValueText(QString txt) {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, txt.QtObj, 1);
		return this;
	}
	// _________________________ 2 -- QString|specialValueText|
	@property T specialValueText(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return to!T(qsOut.String);
	}
	@property string specialValueText() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return qsOut.String;
	}
	@property T specialValueText(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 2);
		return qsOut;
	}
	// _________________________ 3 -- QString|text|
	@property T text(T)() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return to!T(qsOut.String);
	}
	@property string text() {
		sQString qsOut = sQString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return qsOut.String;
	}
	@property T text(T: QString)() {
		QString qsOut = new QString("");
		(cast(t_i__qp_i_qp_qp_i) pFunQt[ 119 ])(QtObj, 0, qsOut.QtObj, null, 3);
		return qsOut;
	}	
	
	/*
	void setReadOnly(bool f) { //-> T - только чтать, изменять нельзя
		(cast(t_v__qp_bool)pFunQt[252])(QtObj, f);
	}
	*/
}
// ============ QDateTimeEdit =======================================
class QDateTimeEdit : QAbstractSpinBox {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(32, 484);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(32));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[483])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[483])(QtPointer, null));
		}
	} /// Конструктор
	
	
	this(T: QString)(T strDateTime, T strFormat, QWidget parent) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(32));
		setQtObj((cast(t_qp__qp_qp_qp_qp)pFunQt[485])(QtPointer, strDateTime.QtObj, strFormat.QtObj, parent.QtObj));
	}

	this(T)(T strDateTime, T strFormat, QWidget parent) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(32));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp_qp_qp) pFunQt[485])(QtPointer, sQString(strDateTime).QtObj, sQString(strFormat).QtObj, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp_qp_qp) pFunQt[485])(QtPointer, sQString(strDateTime).QtObj, sQString(strFormat).QtObj, null));
		}
	}

	@property T toString(T)(T strFormat) { //->
		sQString qs = sQString("");	
		(cast(t_v__qp_qp_qp)pFunQt[486])(QtObj, qs.QtObj, sQString(strFormat).QtObj); 
		return to!T(qs.String);
	} /// Вернуть строчное представление ДатыВремени по шаблону
	
	void fromString(T)(T strDateTime, T strFormat) {
		(cast(t_v__qp_qp_qp)pFunQt[491])(QtObj, sQString(strDateTime).QtObj, sQString(strFormat).QtObj);
	}
}
// ============ QSpinBox =======================================
class QSpinBox : QAbstractSpinBox {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		delForPoint(35, 248);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(35));
		if (parent) {
			setQtObj((cast(t_qp__qp_qp) pFunQt[247])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[247])(QtPointer, null));
		}
	} /// Конструктор
	
	// QSpinBox selectAll() { //-> Выбрать всё
		// (cast(t_v__qp_i_i) pFunQt[249])(QtObj, 0, 4); return this;
	// }
	QSpinBox setMinimum(int n) { //-> Установить минимум
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 0); return this;
	}
	QSpinBox setMaximum(int n) { //-> Установить максимум
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 1); return this;
	}
	QSpinBox setSingleStep(int n) { //-> Установить приращение
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 2); return this;
	}
	QSpinBox setValue(int n) { //-> Установить значение
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, n, 3); return this;
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
	@property int value() { //-> Получить значение
		return (cast(t_i__qp_i) pFunQt[250])(QtObj, 3);
	}
	QSpinBox setPrefix(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QSpinBox setPrefix(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, sQString(str).QtObj, 0);
		return this;
	} /// Установить текст
	QSpinBox setSuffix(T: QString)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QSpinBox setSuffix(T)(T str) {
		(cast(t_v__qp_qp_i) pFunQt[251])(QtObj, sQString(str).QtObj, 1);
		return this;
	} /// Установить текст


}
// ============ Highlighter =======================================
class Highlighter : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[258])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(void* parent) {
		super();
		if (parent) {
			setQtObj((cast(t_qp__vp) pFunQt[257])(parent));
		} else {
			setQtObj((cast(t_qp__vp) pFunQt[257])(null));
		}
	} /// Конструктор
}
// ============ HighlighterM =======================================
class HighlighterM : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[443])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(void* parent) {
		super();
		if (parent) {
			setQtObj((cast(t_qp__vp) pFunQt[442])(parent));
		} else {
			setQtObj((cast(t_qp__vp) pFunQt[442])(null));
		}
	} /// Конструктор
}

// ================ QTextEdit ================
/++
Продвинутый редактор
+/
class QTextEdit : QAbstractScrollArea {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[261])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[260])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[260])(null));
		}
	} /// Конструктор

	QTextEdit setPlainText(T: QString)(T str) {  //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, str.QtObj, 0); return this;
	} /// Удалить всё и вставить с начала
	QTextEdit setPlainText(T)(T str) { //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, sQString(str).QtObj, 0); return this;
	} /// Удалить всё и вставить с начала
	QTextEdit insertPlainText(T: QString)(T str) {  //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, str.QtObj, 1); return this;
	} /// Вставить текст в месте курсора
	QTextEdit insertPlainText(T)(T str) { //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, sQString(str).QtObj, 1); return this;
	} /// Вставить текст в месте курсора

	QTextEdit setHtml(T: QString)(T str) {  //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, str.QtObj, 2); return this;
	} /// Удалить всё и вставить с начала
	QTextEdit setHtml(T)(T str) { //-> Удалить всё и вставить с начала
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, sQString(str).QtObj, 2); return this;
	} /// Удалить всё и вставить с начала

	QTextEdit append(T: QString)(T str) {  //-> Дописать в конец
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, str.QtObj, 4); return this;
	}
	QTextEdit append(T)(T str) { //-> Дописать в конец
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, sQString(str).QtObj, 4); return this;
	}


	QTextEdit insertHtml(T: QString)(T str) {  //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, str.QtObj, 3); return this;
	} /// Вставить текст в месте курсора
	QTextEdit insertHtml(T)(T str) { //-> Вставить текст в месте курсора
		(cast(t_v__qp_qp_i) pFunQt[270])(QtObj, sQString(str).QtObj, 3); return this;
	} /// Вставить текст в месте курсора
	T toPlainText(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[271])(QtObj, qs.QtObj, 0); return qs;
	} /// Выдать содержимое в QString
	T toPlainText(T)() {  //->
		return to!T(toPlainText!QString().String);
	} /// Выдать всё содержимое в String
	T toHtml(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp_i)pFunQt[271])(QtObj, qs.QtObj, 1); return qs;
	} /// Выдать содержимое в QString
	T toHtml(T)() {  //->
		return to!T(toHtml!QString().String);
	} /// Выдать всё содержимое в String

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
	QTextEdit selectAll() { //->
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 4); return this;
	} /// selectAll()
	QTextEdit selectionChanged() { //->
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 5); return this;
	} /// selectionChanged()
	QTextEdit undo() { //->
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 7); return this;
	} /// undo()
	QTextEdit redo() { //->
		(cast(t_v__qp_i) pFunQt[272])(QtObj, 8); return this;
	} /// redo()
	bool acceptRichText() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 0);
	}
	bool canPaste() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 1);
	}
	bool fontItalic() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 2);
	}
	bool fontUnderline() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 3);
	}
	bool isReadOnly() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 4);
	}
	bool isUndoRedoEnabled() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 5);
	}
	bool overwriteMode() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 6);
	}
	bool tabChangesFocus() { //->
		return (cast(t_b__qp_i) pFunQt[346])(QtObj, 7);
	}
	QTextEdit setAcceptRichText(bool b) { //->
		(cast(t_v__qp_b_i) pFunQt[345])(QtObj, b, 0); return this;
	}
	QTextEdit setOverwriteMode(bool b) { //->
		(cast(t_v__qp_b_i) pFunQt[345])(QtObj, b, 1); return this;
	}
	QTextEdit setReadOnly(bool b) { //->
		(cast(t_v__qp_b_i) pFunQt[345])(QtObj, b, 2); return this;
	}
	QTextEdit setTabChangesFocus(bool b) { //->
		(cast(t_v__qp_b_i) pFunQt[345])(QtObj, b, 3); return this;
	}
	QTextEdit setUndoRedoEnabled(bool b) { //->
		(cast(t_v__qp_b_i) pFunQt[345])(QtObj, b, 4); return this;
	}
}
// ================ QTimer ================
class QTimer : QObject {
	enum TimerType {
		PreciseTimer	= 0,	// Precise timers try to keep millisecond accuracy
		CoarseTimer		= 1,	// Coarse timers try to keep accuracy within 5% of the desired interval
		VeryCoarseTimer	= 2		// Very coarse timers only keep full second accuracy
	}

	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[263])(QtObj); setQtObj(null); }
	}
	this(QObject parent) {
		setQtObj((cast(t_qp__qp)pFunQt[262])(parent.QtObj));
	}
	// Установить интервал срабатывания в милисекундах
	QTimer setInterval(int msek) { //-> интервал в милисек
		(cast(t_v__qp_i) pFunQt[264])(QtObj, msek); return this;
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
	QTimer setTimerType(QTimer.TimerType t) { //-> Задать тип таймера
		(cast(t_v__qp_i) pFunQt[267])(QtObj, t); return this;
	}
	QTimer setSingleShot(bool t) { //-> Задать тип срабатывания. T - один раз
		(cast(t_v__qp_b) pFunQt[268])(QtObj, t); return this;
	}
	TimerType timerType() { //-> Получить тип таймера
		return cast(TimerType)(cast(t_i__qp) pFunQt[269])(QtObj);
	}
	QTimer start(int msek = 0) { //-> Запуск таймера
		if(msek > 0) {
			(cast(t_v__qp_i) pFunQt[342])(QtObj, msek);
		} else {
			(cast(t_i__qp_i) pFunQt[265])(QtObj, 3);
		}
		return this;
	}
	QTimer stop() { //->
		(cast(t_i__qp_i) pFunQt[265])(QtObj, 4);
		return this;
	}
}
// ================ QTextOption ================
class QTextOption : QObject {
	enum	WrapMode {
		NoWrap,
		WordWrap,
		ManualWrap,
		WrapAnywhere,
		WrapAtWordBoundaryOrAnywhere
	}
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[292])(QtObj); setQtObj(null); }
	}
	
	this(void* pr) {
		setQtObj((cast(t_qp__v)pFunQt[291])());
	}	
	QTextOption setWrapMode(QTextOption.WrapMode wrap) { //-> Перенос текста в редакторах
		(cast(t_v__qp_qp) pFunQt[293])(QtObj, cast(QtObjH)wrap);
		return this;
	}


}

// ================ QFontMetrics ================
class QFontMetrics : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[296])(QtObj); setQtObj(null); }
	}
	this(QFont fn) {
		setQtObj((cast(t_qp__qp)pFunQt[295])(fn.QtObj));
	}
	int ascent() { //-> Подъём шрифта. Расстояние от базовой линии до самых высоких символов.
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 0));
	}
	int averageCharWidth() { //-> Возвращает среднюю ширину глифов в шрифте.
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 1));
	}
	int descent() { //-> Расстояние от базовой линии до самых нижних точек
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 2));
	}
	int height() { //-> Высота шрифта. = ascent + descent
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 3));
	}
	int leading() { //-> Интерлиньяж - расстояние между базовыми линиями двух строк
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 4));
	}
	int lineSpacing() { //-> Межстроковый интервал = leading()+height().
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 5));
	}
	int lineWidth() { //-> Возвращает ширину подчеркивания и зачеркнутых строк.
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 6));
	}
	int maxWidth() { //-> Ширина самго широкого символа
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 7));
	}
	int minLeftBearing() { //-> Минимальный левый перенос шрифта
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 8));
	}
	int minRightBearing() { //-> Минимальный правый перенос шрифта
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 9));
	}
	int overlinePos() { //-> От базовой линии до overLine
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 10));
	}
	int strikeOutPos() { //-> От базы до зачеркнутой линии
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 11));
	}
	int underlinePos() { //-> От базовой линии до underline
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 12));
	}
	int xHeight() { //-> Высота символа 'x'
		return ((cast(t_i__qp_i)pFunQt[297])(QtObj, 13));
	}

}

// ================ QImage ================
class QImage: QPaintDevice {

	enum	Format {
		Format_Invalid		= 0,	// The image is invalid.
		Format_Mono			= 1,	// The image is stored using 1-bit per pixel. Bytes are packed with the most significant bit (MSB) first.
		Format_MonoLSB		= 2,	// The image is stored using 1-bit per pixel. Bytes are packed with the less significant bit (LSB) first.
		Format_Indexed8		= 3,	// The image is stored using 8-bit indexes into a colormap.
		Format_RGB32		= 4,	// The image is stored using a 32-bit RGB format (0xffRRGGBB).
		Format_ARGB32		= 5,	// The image is stored using a 32-bit ARGB format (0xAARRGGBB).
		Format_ARGB32_Premultiplied		= 6,	// The image is stored using a premultiplied 32-bit ARGB format (0xAARRGGBB), i.e. the red, green, and blue channels are multiplied by the alpha component divided by 255. (If RR, GG, or BB has a higher value than the alpha channel, the results are undefined.) Certain operations (such as image composition using alpha blending) are faster using premultiplied ARGB32 than with plain ARGB32.
		Format_RGB16		= 7,	// The image is stored using a 16-bit RGB format (5-6-5).
		Format_ARGB8565_Premultiplied	= 8,	// The image is stored using a premultiplied 24-bit ARGB format (8-5-6-5).
		Format_RGB666		= 9,	// The image is stored using a 24-bit RGB format (6-6-6). The unused most significant bits is always zero.
		Format_ARGB6666_Premultiplied	= 10,	// The image is stored using a premultiplied 24-bit ARGB format (6-6-6-6).
		Format_RGB555		= 11,	// The image is stored using a 16-bit RGB format (5-5-5). The unused most significant bit is always zero.
		Format_ARGB8555_Premultiplied	= 12,	// The image is stored using a premultiplied 24-bit ARGB format (8-5-5-5).
		Format_RGB888		= 13,	// The image is stored using a 24-bit RGB format (8-8-8).
		Format_RGB444		= 14,	// The image is stored using a 16-bit RGB format (4-4-4). The unused bits are always zero.
		Format_ARGB4444_Premultiplied	= 15,	// The image is stored using a premultiplied 16-bit ARGB format (4-4-4-4).
		Format_RGBX8888		= 16,	// The image is stored using a 32-bit byte-ordered RGB(x) format (8-8-8-8). This is the same as the Format_RGBA8888 except alpha must always be 255.
		Format_RGBA8888		= 17,	// The image is stored using a 32-bit byte-ordered RGBA format (8-8-8-8). Unlike ARGB32 this is a byte-ordered format, which means the 32bit encoding differs between big endian and little endian architectures, being respectively (0xRRGGBBAA) and (0xAABBGGRR). The order of the colors is the same on any architecture if read as bytes 0xRR,0xGG,0xBB,0xAA.
		Format_RGBA8888_Premultiplied	= 18,	// The image is stored using a premultiplied 32-bit byte-ordered RGBA format (8-8-8-8).
		Format_BGR30		= 19,	// The image is stored using a 32-bit BGR format (x-10-10-10).
		Format_A2BGR30_Premultiplied	= 20,	// The image is stored using a 32-bit premultiplied ABGR format (2-10-10-10).
		Format_RGB30		= 21,	// The image is stored using a 32-bit RGB format (x-10-10-10).
		Format_A2RGB30_Premultiplied	= 22,	// The image is stored using a 32-bit premultiplied ARGB format (2-10-10-10).
		Format_Alpha8		= 23,	// The image is stored using an 8-bit alpha only format.
		Format_Grayscale8	= 24	// The image is stored using an 8-bit grayscale format.
	}
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(QtObj != null) { (cast(t_v__qp) pFunQt[304])(QtObj); setQtObj(null); }
	}
	this() {
		typePD = 1;
		setQtObj((cast(t_qp__v)pFunQt[303])());
	}
	// Warning: This will create a QImage with uninitialized data.
	// Call fill() to fill the image with an appropriate pixel value before drawing onto it with QPainter.
	this(int width, int height, QImage.Format format) {
		typePD = 1;
		setQtObj((cast(t_qp__i_i_i)pFunQt[315])(width, height, format));
	}
	bool load(T: QString)(T str) { //-> Загрузить картинку
		return (cast(t_b__qp_qp) pFunQt[305])(QtObj, str.QtObj);
	}
	bool load(T)(T str) { //-> Загрузить картинку
		return (cast(t_b__qp_qp) pFunQt[305])(QtObj, sQString(str).QtObj);
	}

	QImage fill(QColor cl) { //-> заполнить цветом
		(cast(t_v__qp_qp) pFunQt[316])(QtObj, cl.QtObj); return this;
	}
	QImage fill(QtE.GlobalColor gc) { //-> заполнить цветом
		(cast(t_v__qp_i) pFunQt[317])(QtObj, gc); return this;
	}
	QImage setPixel(int x, int y, uint index_or_rgb) { //->
		(cast(t_v__qp_i_i_ui) pFunQt[318])(QtObj, x, y, index_or_rgb); return this;
	}
	int bitPlaneCount() { //-> Похоже, что глубина цвета
		return (cast(t_i__qp_i) pFunQt[319])(QtObj, 2);
	}
	int byteCount() { //-> Общее количество байтов в IMage (4 байта на пиксел для 24 глубины)
		return (cast(t_i__qp_i) pFunQt[319])(QtObj, 3);
	}
	int bytesPerLine() { //-> Количество байт на строку изображения
		return (cast(t_i__qp_i) pFunQt[319])(QtObj, 4);
	}
	int dotsPerMeterX() { //->
		return (cast(t_i__qp_i) pFunQt[319])(QtObj, 7);
	}
	int dotsPerMeterY() { //->
		return (cast(t_i__qp_i) pFunQt[319])(QtObj, 8);
	}
	uint pixel(int x, int y) { //-> Вернуть uint (QRgb Qt) quadruplet on the format #AARRGGBB, equivalent to an unsigned int.
		return (cast(t_ui__qp_i_i) pFunQt[321])(QtObj, x, y);
	}
}
// ================ QPoint ================
class QPoint : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[1307])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(int x, int y) {
		setQtObj((cast(t_qp__i_i)pFunQt[1306])(x, y));
	}
	
// a.opOpAssign!("op")(b)	
	// !!! Очень важное дополнение. Это операции
    void opOpAssign(string op : "+", QPoint)(QPoint arg)     {
		(cast(t_i__qp_qp_i)pFunQt[1309])(QtObj, arg.QtObj, 0);   // QPopint += QPoint
		// return this;
	}
    void opOpAssign(string op : "-", QPoint)(QPoint arg)     {
		(cast(t_i__qp_qp_i)pFunQt[1309])(QtObj, arg.QtObj, 1);   // QPopint -= QPoint
		// return this;
	}

    QPoint opBinary(string op : "+", QPoint)(QPoint arg)     {
		// writeln("Операция '+'  x=", this.x(), " y=", this.y(), "  arg.x=", arg.x, "   arg.y=", arg.y);
		return new QPoint(x + arg.x, y + arg.y);                 // QPopint3 = QPoint1 + QPoint2
	}
    QPoint opBinary(string op : "-", QPoint)(QPoint arg)     {
		return new QPoint(x - arg.x, y - arg.y);                 // QPopint3 = QPoint1 - QPoint2
	}

// a.opBinary!("op")(b)
// b.opBinaryRight!("op")(a)
	
	// _________________________ 0 -- bool|isNull|
	@property bool isNull() {
		return cast(bool)(cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, 0, 0);
	}
	// _________________________ 1 -- int|manhattanLength|
	@property int manhattanLength() {
		return (cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, 0, 1);
	}
	// _________________________ 2 -- void|setX|int%x
	QPoint setX(int x) {
		(cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, x, 2);
		return this;
	}
	// _________________________ 3 -- void|setY|int%y
	QPoint setY(int y) {
		(cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, y, 3);
		return this;
	}
	// _________________________ 4 -- int|x|
	@property int x() {
		return (cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, 0, 4);
	}
	// _________________________ 5 -- int|y|
	@property int y() {
		return (cast(t_i__qp_i_i) pFunQt[ 1308 ])(QtObj, 0, 5);
	}	
	
	
	
}
// ================ QJSEngine ================
class QJSEngine : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	 void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[455])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QObject parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[454])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[454])(null));
		}
	}
	// -----------
	void evaluate(T: QString)(T sourceLine) {
		(cast(t_v__qp_qp_qp_i) pFunQt[458])(QtObj, sourceLine.QtObj, null, 1);
	}
	void evaluate(T)(T sourceLine) {
		(cast(t_v__qp_qp_qp_i) pFunQt[458])(QtObj, sQString(sourceLine).QtObj, null, 1);
	}
}
// ================ QQmlEngine ================
class QQmlEngine : QJSEngine {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[457])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QObject parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[456])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[456])(null));
		}
	}
}
// ================ QQmlApplicationEngine ================
class QQmlApplicationEngine : QQmlEngine {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[452])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[451])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[451])(null));
		}
	} /// Загрузить файл qml
	void load(T: QString)(T nameFile) {
		(cast(t_v__qp_qp) pFunQt[453])(QtObj, nameFile.QtObj);
	}
	void load(T)(T nameFile) {
		(cast(t_v__qp_qp) pFunQt[453])(QtObj, sQString(to!string(nameFile)).QtObj);
	}
	void setContextProperty(T: QString)(T nameProperty, QAction ac) {
		(cast(t_v__qp_qp_qp) pFunQt[459])(QtObj, nameProperty.QtObj, ac.QtObj);
	}
	void setContextProperty(T)(T nameProperty, QAction ac) {
		(cast(t_v__qp_qp_qp) pFunQt[459])(QtObj, sQString(to!string(nameProperty)).QtObj, ac.QtObj);
	}
}
// ================ QScriptEngine ================
class QScriptEngine : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[352])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[351])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[351])(null));
		}
	} /// Конструктор

	void evaluate(T: QString)(QScriptValue sv, T program, T nameFile = null, int lineNumber = 1) {
		if(nameFile is null) {
			(cast(t_v__qp_qp_qp_qp_i) pFunQt[353])(sv.QtObj, QtObj, program.QtObj, (new QString("")).QtObj, lineNumber);
		} else {
			(cast(t_v__qp_qp_qp_qp_i) pFunQt[353])(sv.QtObj, QtObj, program.QtObj, nameFile.QtObj, lineNumber);
		}
	}
	void evaluate(T)(QScriptValue sv, T program, T nameFile = null, int lineNumber = 1) {
		if(nameFile is null) {
			(cast(t_v__qp_qp_qp_qp_i) pFunQt[353])(sv.QtObj, QtObj, sQString(program).QtObj, (new QString("")).QtObj, lineNumber);
		} else {
			(cast(t_v__qp_qp_qp_qp_i) pFunQt[353])(sv.QtObj, QtObj, sQString(program).QtObj, sQString(nameFile).QtObj, lineNumber);
		}
	}
	void newQObject(QScriptValue sv, QObject ob) {
		(cast(t_v__qp_qp_qp) pFunQt[358])(sv.QtObj, QtObj, ob.QtObj);
	}
	void globalObject(QScriptValue sv) {
		(cast(t_v__qp_qp) pFunQt[359])(sv.QtObj, QtObj);
	}
	// Создать в скрипте функцию callFunDlang(nom, ...);
	void createFunDlang() {
		(cast(t_v__qp) pFunQt[361])(QtObj);
	}
	// Установить "делегат" в массив в ячейку nom
	void setFunDlang(void* adrObj, void* adrMet, int nom) {
		(cast(t_v__vp_vp_i) pFunQt[362])(adrObj, adrMet, nom);
	}

}

// ================ QScriptValue ================
class QScriptValue : QObject {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[355])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[354])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[354])(null));
		}
	} /// Конструктор
	this(QWidget parent, QString qs) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[365])(parent.QtObj, qs.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[365])(null, qs.QtObj));
		}
	} /// Конструктор
	this(QWidget parent, string str) {
		QString qs = new QString(str);
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[365])(parent.QtObj, qs.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[365])(null, qs.QtObj));
		}
	} /// Конструктор

	this(QWidget parent, int n) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[366])(parent.QtObj, n));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[366])(null, n));
		}
	} /// Конструктор
	this(QWidget parent, bool b) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_b) pFunQt[367])(parent.QtObj, b));
		} else {
			setQtObj((cast(t_qp__qp_b) pFunQt[367])(null, b));
		}
	} /// Конструктор

	int toInt32() {
		return (cast(t_i__qp)pFunQt[356])(QtObj);
	}
	T toString(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[357])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T toString(T: string)() {  //->
		return to!string(toString!QString().String);
	} /// Выдать всё содержимое в String
	T toString(T)() {  //->
		return to!T(toString!QString().String);
	} /// Выдать всё содержимое в String
	void setProperty(QScriptValue ob, string name) {
		(cast(t_v__qp_qp_qp) pFunQt[360])(QtObj, ob.QtObj, sQString(name).QtObj);
	}
}

// ================ QScriptContext ================
class QScriptContext : QObject {
	this(){}
	this(char ch, void* adr) {
		if(ch == '+') { setQtObj(cast(QtObjH)adr); setNoDelete(true); }
	}
	int argumentCount() {
		return (cast(t_i__qp)pFunQt[363])(QtObj);
	}
	QScriptValue argument(int nom, QScriptValue sv) {
		(cast(t_i__qp_qp_i)pFunQt[364])(QtObj, sv.QtObj, nom);
		return sv;
	}
}

// ---- автор Олег Бахарев 2016 -- https://vk.com/vk_dlang Роберт Брайтс-Грей ----
//
// 	Код включает набор классов для продвинутой работы с графикой: черепашья графика,
//	математическая графика и L-системы.
//
// --------------------------------------------------------------------------------
private
{
	import std.algorithm;
	import std.math;
	import std.meta : allSatisfy;
	import std.random;
	import std.range;
	import std.string;
	import std.traits : isIntegral, isFloatingPoint, Unqual;

	import qte56;

	// все ли типы арифметические ?
	template allArithmetic(T...)
		if (T.length >= 1)
	{
		template isNumberType(T)
		{
			enum bool isNumberType = isIntegral!(Unqual!T) || isFloatingPoint!(Unqual!T);

		}

		enum bool allArithmetic = allSatisfy!(isNumberType, T);
	}

	// добавление автоматически типизированного свойства
	template addTypedGetter(string propertyVariableName, string propertyName)
	{
		import std.string : format;

		enum string addTypedGetter = format(
			`
			@property
			{
				T %2$s(T)() const
				{
					alias typeof(return) returnType;
					return cast(returnType) %1$s;
				}
			}`,
			propertyVariableName,
			propertyName
			);
	}
}

template QtE6EntryPoint(alias mainFormName)
{
	import std.string : format;

	enum QtE6EntryPoint = format(
		`
			import core.runtime;
			import std.stdio;

			auto QtEDebugInfo(bool debugFlag)
			{
			    if (LoadQt(dll.QtE6Widgets, debugFlag)) 
			    {
			        return 1;
			    }
			    else
			    {
			        return 0;
			    }
			}

			int main(string[] args) 
			{
			    %1$s mainForm;

			    QtEDebugInfo(true);
			    
			    QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
			    
			    with (mainForm = new %1$s(null, QtE.WindowType.Window))
			    {
			        show;
			        saveThis(&mainForm);
			    }
			    
			    return app.exec;
			}
		`,
		mainFormName.stringof
		);
}

class QLagrangeInterpolator
{
	private
	{
		float[] xs_Floats;
		float[] ys_Floats;

		float basePolynom(float x, size_t N)
		{
			float product = 1.0f;

			for (size_t i = 0; i < xs_Floats.length; i++)
			{
				if (i != N)
				{
					product *= (x - xs_Floats[i]) / (xs_Floats[N] - xs_Floats[i]);
				}
			}

			return product;
		}
	}

	public
	{
		this(QPoint[] points...)
		{
			foreach (point; points)
			{
				xs_Floats ~= point.x;
				ys_Floats ~= point.y;
			}
		}

		QPoint interpolate(QPoint point)
		{
			float sum = 0.0f;

			for (size_t i = 0; i < ys_Floats.length; i++)
			{
				sum += ys_Floats[i] * basePolynom(point.x, i);
			}
			
			return new QPoint(point.x, cast(int) sum);
		}

		QPoint[] interval(int a, int b, int step = 1)
		{
			QPoint[] points;

			for (int x = a; x < b; x += step)
			{
				points ~= interpolate(new QPoint(x, 0));
			}

			return points;
		}
	}
}

/*
	Класс математической графики QMathGraphics

	Пример применения:

		// Задание цвета
		QColor color = new QColor;
        color.setRgb(0, 250, 120, 200);

		// Создаем объект класса, помещая в него QPainter и объект нужного цвета
		QMathGraphics maths = new QMathGraphics(painter, color);

        auto x = iota(-250, 350, 0.1);

        // рисование дискретной последовательности
        maths.drawDiscrete(x, x);

        // рисование некоторой функции f
        maths.drawFunctional!f(x);

        // параметрическое рисование: в качестве параметров функции g, h
        maths.drawParametrical!(g, h)(iota(0, 360, 0.1));

        // рисование некоторой функции t в полярных координатах (угол в радианах)
        maths.drawPolarInRadians!t(iota(0, 360, 0.1));

        // рисование некоторой функции t в полярных координатах (угол в градусах)
        maths.drawPolarInDegrees!t(iota(0, 360, 0.1));

        // рисование точки
        maths.drawPoint(400, 409.123);

        // рисование линии методом DDA
        maths.drawDDALine(400, 400, 506.2, 109.0);

        // рисование окружности
        maths.drawCircle(600, 600, 20);

        // рисование конического сечения
        maths.drawConicSection(10, 10, 20, 0.6);

        // рисование прямоугольника
        maths.drawRectangle(410, 410, 20, 50);

        // рисование заполненной окружности
        maths.drawFilledCircle(520, 520, 60);

        // установка цвета
        maths.setColor(color);

        // рисование заполненного прямоугольника
        maths.drawFilledRectangle(650, 650, 50, 50);
*/
class QMathGraphics
{
	private
	{
		QPainter painter;
		QColor color;

		// Отрисовка любых числовых последовательностей
		// Аргументы: first - первый диапазон, second - второй диапазон
		auto drawTwoRanges(First, Second)(First first, Second second)
		if (allArithmetic!(ElementType!First, ElementType!Second))
		{
			assert(!first.empty);
			assert(!second.empty);

			QPen pen = new QPen;
			pen.setColor(color);

			painter.setPen(pen);

			foreach (xy; zip(first, second))
			{
				painter.drawPoint(cast(int) xy[0], cast(int) xy[1]);
			}
		}
	}

	this(QPainter painter, QColor color)
	{
		this.painter = painter;
		this.color = color;
	}

	// установка цвета
	auto setColor(QColor color)
	{
		QPen pen = new QPen;
		pen.setColor(color);

		painter.setPen(pen);
	}

	// рисование последовательностей
	alias drawDiscrete = drawTwoRanges;

	// график некоторой функции на непрерывном диапазоне
	auto drawFunctional(alias Functional, Range)(Range r)
		if (isInputRange!(Unqual!Range) && allArithmetic!(ElementType!Range))
	{
		assert(!r.empty);

		auto ys = map!(a => Functional(a))(r);

		drawTwoRanges(r, ys);
	}

	// график параметрической функции
	auto drawParametrical(alias FunctionalX, alias FunctionalY, Range)(Range r)
		if (isInputRange!(Unqual!Range) && allArithmetic!(ElementType!Range))
	{

		auto xs = map!(a => FunctionalX(a))(r);
		auto ys = map!(a => FunctionalY(a))(r);

		drawTwoRanges(xs, ys);
	}

	// рисование функции в полярных координатах (углы в градусах)
	auto drawPolarInDegrees(alias Functional, Range)(Range r)
		if (isInputRange!(Unqual!Range) && allArithmetic!(ElementType!Range))
	{
		assert(!r.empty);

		auto phi = map!(a => a * (PI / 180.0))(r).array;
		auto xs = map!(a =>	Functional(a) * cos(a))(phi);
		auto ys = map!(a => Functional(a) * sin(a))(phi);

		drawTwoRanges(xs, ys);
	}

	// рисование функции в полярных координатах (углы в радианах)
	auto drawPolarInRadians(alias Functional, Range)(Range r)
		if (isInputRange!(Unqual!Range) && allArithmetic!(ElementType!Range))
	{
		assert(!r.empty);

		auto xs = map!(a => Functional(a) * cos(a))(r);
		auto ys = map!(a => Functional(a) * sin(a))(r);

		drawTwoRanges(xs, ys);
	}

	// рисование точки
	auto drawPoint(T, S)(T x, S y)
		if (allArithmetic!(T, S))
	{
		painter.drawPoint(cast(int) x, cast(int) y);
	}

	// рисование линии с помощью цифрового дифференциального анализатора
	auto drawDDALine(T, U, V, W)(T x1, U y1, V x2, W y2)
		if (allArithmetic!(T, U, V, W))
	{
		auto X1 = cast(float) x1;
		auto Y1 = cast(float) y1;
		auto X2 = cast(float) x2;
		auto Y2 = cast(float) y2;

		auto deltaX = abs(X1 - X2);
		auto deltaY = abs(Y1 - Y2);
		auto L = max(deltaX, deltaY);

		if (L == 0)
		{
			painter.drawPoint(cast(int) x1, cast(int) y1);
		}

		auto dx = (X2 - X1) / L;
		auto dy = (Y2 - Y1) / L;
		float x = X1;
		float y = Y1;

		L++;
		while(L--)
		{
			x += dx;
			y += dy;
			painter.drawPoint(cast(int) x, cast(int) y);
		}
	}

	// рисование окружности
	void drawCircle(T, U, V)(T x, U y, V r)
		if (allArithmetic!(T, U, V))
	{
		assert (r >= 0);

		auto a = cast(float) x;
		auto b = cast(float) y;
		auto c = cast(float) r;

		for (float i = 0.0; i < 360.0; i += 0.01)
		{
			auto X = cast(int) (a + c * cos(i * PI / 180.0));
			auto Y = cast(int) (b + c * sin(i * PI / 180.0));
			painter.drawPoint(X, Y);
		}
	}

	// рисование конических сечений
	void drawConicSection(T, U, V, W)(T x, U y, V l, W e)
		if (allArithmetic!(T, U, V, W))
	{
		auto a = cast(float) x;
		auto b = cast(float) y;
		auto c = cast(float) l;
		auto d = cast(float) e;

		for (float i = 0.0; i < 360.0; i += 0.01)
		{
			auto r = c / (1.0 - d * cos(i * PI / 180.0));
			auto X = cast(int) (a + c * cos(i * PI / 180.0));
			auto Y = cast(int) (b + c * sin(i * PI / 180.0));
			painter.drawPoint(X, Y);
		}
	}

	// рисование прямоугольника
	void drawRectangle(T, U, V, W)(T x, U y, V w, W h)
		if (allArithmetic!(T, U, V, W))
	{
		assert(w >= 0);
		assert(h >= 0);

		auto X = cast(int) x;
		auto Y = cast(int) y;
		auto WW = cast(int) w;
		auto HH = cast(int) h;

		for (int a = 0; a < HH; a++)
		{
			painter.drawPoint(X, Y + a);
		}

		for (uint b = 0; b < WW; b++)
		{
			painter.drawPoint(X + b, Y + HH);
		}

		for (uint c = 0; c < HH; c++)
		{
			painter.drawPoint(X + WW, Y + c);
		}

		for (uint d = 0; d < WW; d++)
		{
			painter.drawPoint(X + d, Y);
		}
	}

	// окружность с заливкой
	void drawFilledCircle(T, U, V)(T x, U y, V r)
		if (allArithmetic!(T, U, V))
	{
		auto a = cast(float) x;
		auto b = cast(float) y;
		auto c = cast(float) r;

		for (float i = 0.0; i < 360.0; i += 0.01)
		{
			for (float j = 0; j < c; j++)
			{
				auto X = cast(int) (a + j * cos(i * PI / 180.0));
				auto Y = cast(int) (b + j * sin(i * PI / 180.0));
				painter.drawPoint(X, Y);
			}
		}
	}

	// прямоугольник с заливкой
	void drawFilledRectangle(T, U, V, W)(T x, U y, V w, W h)
		if (allArithmetic!(T, U, V, W))
	{
		assert(w >= 0);
		assert(h >= 0);

		auto X = cast(int) x;
		auto Y = cast(int) y;
		auto WW = cast(int) w;
		auto HH = cast(int) h;

		for (int i = 0; i < WW; i++)
		{
			for (int j = 0; j < HH; j++)
			{
				painter.drawPoint(X + i, Y + j);
			}
		}
	}
}

/*
	Состояние исполнителя "Черепаха".

	Пример использования:

		// Размещаем исполнителя в точке (250; 250) и начальный угол равен 0
		QTurtleState turtleState = new QTurtleState(250, 250, (0 * 3.1415926) / 180.0);

*/
class QTurtleState
{
	private
	{
		float x;
		float y;
		float angle;
	}

	// конструктор, принимающий любые числовые типы
	this(T, U, V)(T x, U y, V angle)
		if (allArithmetic!(T, U, V))
	{
		this.x = cast(float) x;
		this.y = cast(float) y;
		this.angle = cast(float) angle;
	}

	// получение координаты X (метод getX)
	mixin(addTypedGetter!("x", "getX"));

	// получение координаты Y (метод getY)
	mixin(addTypedGetter!("y", "getY"));

	// получение начального угла (метод getAngle)
	mixin(addTypedGetter!("angle", "getAngle"));

	// установка координаты X
	void setX(T)(T x)
		if (allArithmetic!T)
	{
		this.x = cast(float) x;
	}

	// установка координаты Y
	void setY(T)(T y)
		if (allArithmetic!T)
	{
		this.y = cast(float) y;
	}

	// установка начального угла
	void setAngle(T)(T angle)
		if (allArithmetic!T)
	{
		this.angle = cast(float) angle;
	}

	// строковое отображение
	override string toString()
	{
		return format("QTurtleState(%f, %f, %f)", x, y, angle);
	}
}

/*
	Исполнитель "Черепаха".

	Данный класс позволяет управлять исполнителем и рисовать с его помощью различные
	кривые.

	Команды исполнителя:
		F   шаг исполнителя с прорисовкой следа
		f   шаг исполнителя без прорисовки следа
		+   поворот вправо на заданное приращение
		- 	поворот влево на заданное приращение
		?   поворот на случайный угол
		[   сохранить текущее состояние
		]   восстановить текущее состояние

	Пример использования:

		// установка цвета
		QColor color = new QColor;
        color.setRgb(0, 250, 120, 200);

		// задание начального состояния исполнителя
        QTurtleState turtleState = new QTurtleState(250, 250, (0 * 3.1415926) / 180.0);

        // создание объекта исполнителя
        // входные данные: QPainter, цвет, исходное состояние черепахи, длина шага исполнителя, приращение по углу
        QTurtle turtle = new QTurtle(painter, color, turtleState, 200, (144 * 3.1415926) / 180.0);

		// выполнить команды, отданные исполнителю
        turtle.execute("F+F+F+F+F+");

*/
class QTurtle
{
	private
	{
		QPainter painter;
		QColor color;

		QTurtleState[] stateStack;
		QTurtleState state;

		float stepIncrement;
		float angleIncrement;
	}

	// входные данные: QPainter, цвет, исходное состояние черепахи, длина шага исполнителя, приращение по углу
	this(T, U)(QPainter painter, QColor color, QTurtleState state, T stepIncrement, U angleIncrement)
		if (allArithmetic!(T, U))
	{
		this.painter = painter;
		this.color = color;
		this.state = state;
		this.stepIncrement = cast(float) stepIncrement;
		this.angleIncrement = cast(float) angleIncrement;
	}

	// шаг вперед с отрисовкой следа
	QTurtleState drawStep()
	{
		float newX, newY;

		newX = state.getX!float + cos(state.getAngle!float) * stepIncrement;
		newY = state.getY!float - sin(state.getAngle!float) * stepIncrement;

		QPen pen = new QPen;
		pen.setColor(color);

		painter.setPen(pen);

		painter.drawLine(
			cast(int) state.getX!float,
			cast(int) state.getY!float,
			cast(int) newX,
			cast(int) newY
			);

		state.setX(newX);
		state.setY(newY);

		return state;
	}

	// шаг вперед без отрисовки следа
	QTurtleState moveStep()
	{
		float newX, newY;

		newX = state.getX!float + cos(state.getAngle!float) * stepIncrement;
		newY = state.getY!float - sin(state.getAngle!float) * stepIncrement;

		state.setX(newX);
		state.setY(newY);

		return state;
	}

	// поворот влево
	QTurtleState rotateLeft()
	{
		float newAngle;

		newAngle = state.getAngle!float + angleIncrement;

		state.setAngle(newAngle);

		return state;
	}

	// поворот вправо
	QTurtleState rotateRight()
	{
		float newAngle;

		newAngle = state.getAngle!float - angleIncrement;

		state.setAngle(newAngle);

		return state;
	}

	// поворот на случайный угол
	QTurtleState rotateRandom()
	{
		float newAngle;

		auto rndGenerator = new Random(unpredictableSeed);
		newAngle = uniform(-2 * PI, 2 * PI, rndGenerator);

		state.setAngle(newAngle);

		return state;
	}

	// сохранить состояние черепахи
	QTurtleState saveState()
	{
		QTurtleState newState = new QTurtleState(
			state.getX!float,
			state.getY!float,
			state.getAngle!float,
		);

		stateStack ~= newState;

		return newState;
	}

	// восстановить состояние черепахи
	QTurtleState restoreState()
	{
		QTurtleState newState = new QTurtleState(
			stateStack[$-1].getX!float,
			stateStack[$-1].getY!float,
			stateStack[$-1].getAngle!float,
		);

		stateStack = stateStack[0 .. $-1];
		state = newState;

		return newState;
	}

	// выполнить команду с помощью черепахи
	QTurtleState execute(string s)
	{
		QTurtleState currentState;

		for (int i = 0; i < s.length; i++)
		{
			switch(s[i])
			{
				case 'F':
					currentState = drawStep();
					break;
				case 'f':
					currentState = moveStep();
					break;
				case '+':
					currentState = rotateRight();
					break;
				case '-':
					currentState = rotateLeft();
					break;
				case '?':
					currentState = rotateRandom();
					break;
				case '[':
					currentState = saveState();
					break;
				case ']':
					currentState = restoreState();
					break;
				default:
					break;
			}
		}

		return currentState;
	}
}

/*
	Набор правил для переписывания строки в L-системе.

	Ключ соответствует строке, которая будет переписываться.
	Значение соответствует тому, на что ключ будет заменен.

	Пример использования:

		 QRewritingRules rules = [
            "X" : "F[+X][-X]FX",
            "F" : "FF"
        ];

*/
alias QRewritingRules = string[string];

/*
	Параметры L-системы

	Пример использования:

		// Входные данные: X, Y, начальный угол, длина шага, приращение по углу, количество поколений
		QLSystemParameters parameters = new QLSystemParameters(350, 700, (90 * 3.1415926) / 180.0, 5, (25.7 * 3.1415926) / 180.0, 6);

*/
class QLSystemParameters
{
	private
	{
		float x;
		float y;
		float angle;

		float stepIncrement;
		float angleIncrement;
		ulong numberOfGeneration;
	}

	this(R, S, T, U, V, W)(R x, S y, T angle, U stepIncrement, V angleIncrement, W numberOfGeneration)
		if (allArithmetic!(R, S, T, U, V, W))
	{
		this.x = cast(float) x;
		this.y = cast(float) y;
		this.angle = cast(float) angle;

		this.stepIncrement = cast(float) stepIncrement;
		this.angleIncrement = cast(float) angleIncrement;
		this.numberOfGeneration = cast(uint) abs(numberOfGeneration);
	}

	// получение координаты X (метод getX)
	mixin(addTypedGetter!("x", "getX"));

	// получение координаты Y (метод getY)
	mixin(addTypedGetter!("y", "getY"));

	// получение начального угла (метод getInitialAngle)
	mixin(addTypedGetter!("angle", "getInitialAngle"));

	// получение длины шага (метод getStep)
	mixin(addTypedGetter!("stepIncrement", "getStep"));

	// получение приращения по углу (метод getAngle)
	mixin(addTypedGetter!("angleIncrement", "getAngle"));

	// получение количества поколений (метод getGeneration)
	mixin(addTypedGetter!("numberOfGeneration", "getGeneration"));

	// установка координаты X
	void setX(T)(T x)
		if (allArithmetic!T)
	{
		this.x = cast(float) x;
	}

	// установка координаты Y
	void setY(T)(T y)
		if (allArithmetic!T)
	{
		this.y = cast(float) y;
	}

	// установка начального угла
	void setInitialAngle(T)(T angle)
		if (allArithmetic!T)
	{
		this.angle = cast(float) angle;
	}

	// установка длины шага
	void setStep(T)(T angle)
		if (allArithmetic!T)
	{
		this.stepIncrement = cast(float) stepIncrement;
	}

	// установка приращения по углу
	void setAngle(T)(T angle)
		if (allArithmetic!T)
	{
		this.angleIncrement = cast(float) angleIncrement;
	}

	// установка количества поколений
	void setGeneration(T)(T angle)
		if (allArithmetic!T)
	{
		this.numberOfGeneration = cast(uint) numberOfGeneration;
	}
}

/*
	L-система

	Позволяет генерировать биоморфные формы с помощью задания простых правил.

		// задание цвета
		QColor color = new QColor;
        color.setRgb(0, 250, 120, 200);

        // параметры L-системы
        QLSystemParameters parameters = new QLSystemParameters(350, 700, (90 * 3.1415926) / 180.0, 5, (25.7 * 3.1415926) / 180.0, 6);

        // правила переписывания
        QRewritingRules rules = [
            "X" : "F[+X][-X]FX",
            "F" : "FF"
        ];

		// создание объекта L-системы
		// входные данные: QPainter, цвет, параметры L-системы, аксиома, правила переписывания
        QLSystem lSystem = new QLSystem(painter, color, parameters, "X", rules);
        lSystem.execute();
*/
class QLSystem
{
	private
	{
		QPainter painter;
		QColor color;

		QLSystemParameters parameters;
		QRewritingRules rules;
		string axiom;

		// процедура переписывания строки
		string rewrite(string sourceTerm, string termForRewrite, string newTerm)
		{
			auto acc = "";
			auto search = 0;

			for (uint i = 0; i < sourceTerm.length; i++)
			{
				auto index = indexOf(sourceTerm[search .. search + termForRewrite.length], termForRewrite);

				if (index != -1)
				{
					search += termForRewrite.length;
					acc ~= newTerm;
				}
				else
				{
					search++;
					acc ~= sourceTerm[search-1];
				}
			}

			return acc;
		}
	}

	this(QPainter painter, QColor color, QLSystemParameters parameters,
		string axiom, QRewritingRules rules)
	{
		this.painter = painter;
		this.color = color;
		this.parameters = parameters;
		this.axiom = axiom;
		this.rules = rules;
	}

	QLSystemParameters execute()
	{
		QPen pen = new QPen;
		pen.setColor(color);

		painter.setPen(pen);

		// новое состояние черепахи
		auto turtleState = new QTurtleState(
			parameters.getX!float,
			parameters.getY!float,
			parameters.getInitialAngle!float
			);

		// новая черепаха
		auto turtle = new QTurtle(painter, color, turtleState,
			parameters.getStep!float,
			parameters.getAngle!float
			);

		// команды L-системы
		auto lSystemCmd = axiom;

		// запуск процедуры переписывания
		for (ulong i = 1; i < parameters.getGeneration!ulong; i++)
		{
			foreach (rule; rules.keys)
			{
				lSystemCmd = rewrite(lSystemCmd.idup, rule, rules[rule]);
			}
		}

		turtle.execute(lSystemCmd);

		return parameters;
	}
}

// ================ QPixmap ================
class QPixmap: QPaintDevice {
	this() {
		typePD = 2;
		setQtObj((cast(t_qp__v) pFunQt[384])());
	}
	// Обязателен косвенный вызов (баг D)
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[385])(QtObj); setQtObj(null); }	
	}
	this(int width, int height) {
		typePD = 2;
		setQtObj((cast(t_qp__i_i) pFunQt[386])(width, height));
	}
	this(QSize size) {
		typePD = 2;
		setQtObj((cast(t_qp__qp) pFunQt[387])(size.QtObj));
	}
	void fill(QColor color = null) {
		typePD = 2;
		if(color is null) {
			(cast(t_v__qp_qp) pFunQt[394])(QtObj, null);
		} else {
			(cast(t_v__qp_qp) pFunQt[394])(QtObj, color.QtObj);
		}
	}
	void setMask(QBitmap bm) {
		(cast(t_v__qp_qp) pFunQt[397])(QtObj, bm.QtObj);
	}
	void load(string fileName, string format = "", QtE.ImageConversionFlag flags = QtE.ImageConversionFlag.AutoColor) {
		typePD = 2;
		if(format == "") {
			(cast(t_v__qp_qp_qp_i) pFunQt[388])(
				QtObj
				,sQString(fileName).QtObj
				,null
				,cast(int)flags
			);
		} else {
			(cast(t_v__qp_qp_qp_i) pFunQt[388])(
				QtObj
				,sQString(fileName).QtObj
				,cast(QtObjH)format.ptr
				,cast(int)flags
			);
		}
	}
}

// ================ QBitmap ================
class QBitmap: QPixmap {
	this() {
		typePD = 2;
		setQtObj((cast(t_qp__v) pFunQt[392])());
	}
	this(QSize size) {
		typePD = 2;
		setQtObj((cast(t_qp__qp) pFunQt[395])(size.QtObj));
	}
	~this() { del(); }
	override void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[393])(QtObj); setQtObj(null); }	
	}
}

// ================ QResource ================
class QResource: QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[398])());
	}
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[399])(QtObj); setQtObj(null); }	
	}
	bool registerResource(string rccFileName, string mapRoot = "") {
		bool rez;
		if(mapRoot == "")
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[400])(QtObj, sQString(rccFileName).QtObj, sQString(mapRoot).QtObj, 0);
		else
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[400])(QtObj, sQString(rccFileName).QtObj, null, 0);
		return rez;
	}
	bool unregisterResource(string rccFileName, string mapRoot = "") {
		bool rez;
		if(mapRoot == "")
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[400])(QtObj, sQString(rccFileName).QtObj, sQString(mapRoot).QtObj, 1);
		else
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[400])(QtObj, sQString(rccFileName).QtObj, null, 1);
		return rez;
	}
	bool registerResource(ubyte* rccData, string mapRoot = "") {
		bool rez;
		if(mapRoot == "")
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[401])(QtObj, cast(QtObjH)rccData, sQString(mapRoot).QtObj, 0);
		else
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[401])(QtObj, cast(QtObjH)rccData, null, 0);
		return rez;
	}
	bool unregisterResource(ubyte* rccData, string mapRoot = "") {
		bool rez;
		if(mapRoot == "")
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[401])(QtObj, cast(QtObjH)rccData, sQString(mapRoot).QtObj, 0);
		else
			rez = (cast(t_b__qp_qp_qp_i)pFunQt[401])(QtObj, cast(QtObjH)rccData, null, 0);
		return rez;
	}
}
// ============ QStackedWidget =======================================
class QStackedWidget : QFrame {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[403])(QtObj); setQtObj(null); }
		delForPoint(27, 403);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(27));
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[402])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[402])(QtPointer, null));
		}
	} /// Конструктор
	int addWidget(QWidget wd) {
		return (cast(t_i__qp_qp_i) pFunQt[404])(QtObj, wd.QtObj, 0);
	}
	@property int count() { //-> Количество сохраненных виджетов
		return (cast(t_i__qp_qp_i) pFunQt[404])(QtObj, null, 1);
	}
	@property int currentIndex() { //-> Индекс -1=нет, 0=1 сохраненный, 1=2 сохраненых
		return (cast(t_i__qp_qp_i) pFunQt[404])(QtObj, null, 2);
	}
	int indexOf(QWidget wd) {
		return (cast(t_i__qp_qp_i) pFunQt[404])(QtObj, wd.QtObj, 3);
	}
	QStackedWidget removeWidget(QWidget wd) {
		(cast(t_i__qp_qp_i) pFunQt[404])(QtObj, wd.QtObj, 4); return this;
	}
	QWidget currentWidget() {
		QWidget rez = new QWidget('+', (cast(t_qp__qp_i_i) pFunQt[405])(QtObj, 0, 0));
		rez.setNoDelete(true);
		return rez;
	}
	QWidget widget(int n) {
		QWidget rez = new QWidget('+', (cast(t_qp__qp_i_i) pFunQt[405])(QtObj, n, 1));
		rez.setNoDelete(true);
		return rez;
	}
	int insertWidget(int index, QWidget wd) {
		return (cast(t_i__qp_qp_i) pFunQt[406])(QtObj, wd.QtObj, index);
	}
	QStackedWidget setCurrentIndex(int index) {
		(cast(t_qp__qp_i_i) pFunQt[405])(QtObj, index, 2); return this;
	}
	QStackedWidget setCurrentWidget(QWidget wd) {
		(cast(t_i__qp_qp_i) pFunQt[404])(QtObj, wd.QtObj, 5); return this;
	}
}

// ============ QWebView =======================================
class QWebView : QWidget {
	this() {  }				// Обязателен
	this(QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[24])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[24])(null));
		}
	} /// Конструктор
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[25])(QtObj); setQtObj(null); }
	}
	void load(QUrl qu) {
		(cast(t_v__qp_qp) pFunQt[26])(QtObj, qu.QtObj);
	}
}
// ============ QWebEngView =======================================
class QWebEngView : QWidget {
	this() {  }				// Обязателен
	this(QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[446])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[446])(null));
		}
	} /// Конструктор
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[445])(QtObj); setQtObj(null); }
	}
	void load(QUrl qu) {
		(cast(t_v__qp_qp) pFunQt[447])(QtObj, qu.QtObj);
	}
}



// ============ QUrl =======================================
class QUrl : QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[81])());
	}
	~this() { del(); }
	void del() { 
		if(!fNoDelete && (QtObj !is null)) { (cast(t_v__qp)pFunQt[173])(QtObj); setQtObj(null); }	
	}
	void setUrl(QString* qs) {
		(cast(t_v__qp_qp) pFunQt[444])(QtObj, qs.QtObj);
	}
	void setUrl(T)(T str) {
		(cast(t_v__qp_qp) pFunQt[444])(QtObj, sQString(str).QtObj);
	}
	
}


// ============ QTabBar =======================================
class QTabBar : QWidget {

	enum ButtonPosition {
		LeftSide 	= 0,
		RightSide 	= 1
	}
	enum SelectionBehavior {
		SelectLeftTab 		= 0,
		SelectRightTab 		= 1,
		SelectPreviousTab 	= 2
	}
	enum Shape {
		RoundedNorth	= 	0,	// The normal rounded look above the pages
		RoundedSouth	= 	1,	// The normal rounded look below the pages
		RoundedWest		= 	2,	// The normal rounded look on the left side of the pages
		RoundedEast		= 	3,	// The normal rounded look on the right side the pages
		TriangularNorth	= 	4,	// Triangular tabs above the pages.
		TriangularSouth	= 	5,	// Triangular tabs similar to those used in the Excel spreadsheet, for example
		TriangularWest	= 	6,	// Triangular tabs on the left of the pages.
		TriangularEast	= 	7	// Triangular tabs on the right of the pages.
	}

	this() { /* msgbox( "new QTabBar(); -- " ~ mesNoThisWitoutPar ); */ }				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		// if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[408])(QtObj); setQtObj(null); }
		delForPoint(26, 408);
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		super();
		setQtPointer((cast(t_qp__i)pFunQt[700])(26));
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[407])(QtPointer, parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[407])(QtPointer, null));
		}
	} /// Конструктор
	@property int count() { //-> Количество сохраненных виджетов
		return (cast(t_i__qp_i) pFunQt[409])(QtObj, 1);
	}
	@property int currentIndex() { //-> Индекс -1=нет, 0=1 сохраненный, 1=2 сохраненых
		return (cast(t_i__qp_i) pFunQt[409])(QtObj, 0);
	}
	int addTab(T: QString)(T str) { //->
		return (cast(t_i__qp_qp) pFunQt[410])(QtObj, str.QtObj);
	}
	int addTab(T)(T str) { //->
		return (cast(t_i__qp_qp) pFunQt[410])(QtObj, sQString(to!string(str)).QtObj);
	}
	int addTab(T0: QIcon, T: QString)(T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp) pFunQt[413])(QtObj, str.QtObj, icon.QtObj);
	}
	int addTab(T0: QIcon, T)(T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp) pFunQt[413])(QtObj, sQString(to!string(str)).QtObj, icon.QtObj);
	}
	
	
	
	int insertTab(T: QString)(int index, T str) { //->
		return (cast(t_i__qp_qp_qp_i_i) pFunQt[416])(QtObj, sQString(to!string(str)).QtObj, null, index, 0);
	}
	int insertTab(T)(int index, T str) { //->
		return insertTab(index, (new QString(to!string(str))));
		return (cast(t_i__qp_qp_qp_i_i) pFunQt[416])(QtObj, sQString(to!string(str)).QtObj, null, index, 0);
	}

	int insertTab(T0: QIcon, T: QString)(int index, T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp_i_i) pFunQt[416])(QtObj, sQString(to!string(str)).QtObj, icon.QtObj, index, 1);
	}
	int insertTab(T0: QIcon, T)(int index, T0 icon, T str) { //->
		return insertTab(index, icon, sQString(to!string(str)).QtObj);
	}
	T tabText(T: QString)(int index) {
		QString qs = new QString();	(cast(t_v__qp_qp_i_i) pFunQt[411])(QtObj, qs.QtObj, index, 0);
		return qs;
	}
	T tabText(T)(int index) {
		return to!T(tabText!QString(index).String);
	}
	T tabToolTip(T: QString)(int index) {
		QString qs = new QString();	(cast(t_v__qp_qp_i_i) pFunQt[411])(QtObj, qs.QtObj, index, 1);
		return qs;
	}
	T tabToolTip(T)(int index) {
		return to!T(tabToolTip!QString(index).String);
	}
	T tabWhatsThis(T: QString)(int index) {
		QString qs = new QString();	(cast(t_v__qp_qp_i_i) pFunQt[411])(QtObj, qs.QtObj, index, 2);
		return qs;
	}
	T tabWhatsThis(T)(int index) {
		return to!T(tabWhatsThis!QString(index).String);
	}
	T accessibleDescription(T: QString)() {
		QString qs = new QString();	(cast(t_v__qp_qp_i_i) pFunQt[411])(QtObj, qs.QtObj, 0, 3);
		return qs;
	}
	T accessibleDescription(T)() {
		return to!T(accessibleDescription!QString(index).String);
	}
	T accessibleName(T: QString)() {
		QString qs = new QString();	(cast(t_v__qp_qp_i_i) pFunQt[411])(QtObj, qs.QtObj, 0, 3);
		return qs;
	}
	T accessibleName(T)() {
		return to!T(accessibleName!QString(index).String);
	}
	@property bool autoHide() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 0);
	}
	@property bool changeCurrentOnDrag() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 1);
	}
	@property bool documentMode() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 2);
	}
	@property bool drawBase() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 3);
	}
	@property bool expanding() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 4);
	}
	@property bool isMovable() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 5);
	}
	@property bool isTabEnabled(int index) {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, index, 6);
	}
	@property bool tabsClosable() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 7);
	}
	@property bool usesScrollButtons() {
		return (cast(t_b__qp_i_i) pFunQt[412])(QtObj, 0, 8);
	}
	QtE.TextElideMode elideMode() { //-> С какой стороны скроются вкдадки, при недостатке места
		return cast(QtE.TextElideMode)((cast(t_i__qp) pFunQt[414])(QtObj));
	}
	QSize iconSize() {
		QSize isize = new QSize(0,0); (cast(t_v__qp_qp) pFunQt[415])(QtObj, isize.QtObj);	return isize;
	}
	QTabBar moveTab(int from, int to) {
		(cast(t_v__qp_i_i_i) pFunQt[417])(QtObj, from, to, 0); return this;
	}
	QTabBar removeTab(int index) {
		(cast(t_v__qp_i_i_i) pFunQt[417])(QtObj, index, 0, 1); return this;
	}
	QTabBar setCurrentIndex(int index) {
		(cast(t_v__qp_i_i_i) pFunQt[417])(QtObj, index, 0, 2); return this;
	}
	SelectionBehavior selectionBehaviorOnRemove() {
		return cast(SelectionBehavior)(cast(t_i__qp) pFunQt[418])(QtObj);
	}
	QTabBar setAutoHide(bool hide) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, hide, 0); return this;
	}
	QTabBar setChangeCurrentOnDrag(bool change) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, change, 1); return this;
	}
	QTabBar setDocumentMode(bool set) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, set, 2); return this;
	}
	QTabBar setDrawBase(bool drawTheBase) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, drawTheBase, 3); return this;
	}
	QTabBar setExpanding(bool enabled) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, enabled, 4); return this;
	}
	QTabBar setMovable(bool movable) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, movable, 5); return this;
	}
	QTabBar setTabsClosable(bool closable) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, closable, 6); return this;
	}
	QTabBar setUsesScrollButtons(bool useButtons) {
		(cast(t_v__qp_b_i) pFunQt[419])(QtObj, useButtons, 7); return this;
	}
	QTabBar setElideMode(QtE.TextElideMode mode) {
		(cast(t_v__qp_i) pFunQt[420])(QtObj, mode); return this;
	}
	QTabBar setIconSize(QSize size) {
		(cast(t_v__qp_qp) pFunQt[421])(QtObj, size.QtObj); return this;
	}
	QTabBar setShape(QTabBar.Shape shape) {
		(cast(t_v__qp_i) pFunQt[422])(QtObj, shape); return this;
	}
	QTabBar setTabEnabled(int index, bool enabled) {
		(cast(t_v__qp_b_i) pFunQt[423])(QtObj, enabled, index); return this;
	}
	QTabBar setTabIcon(int index, QIcon icon) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, icon.QtObj, index, 0); return this;
	}
	QTabBar setTabText(T: QString)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, text.QtObj, index, 1); return this;
	}
	QTabBar setTabText(T: string)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, sQString(to!string(text)).QtObj, index, 1); return this;
		// return setTabText(index, (new QString(to!string(text))));
	}
	QTabBar setTabTextColor(int index, QColor color) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, color.QtObj, index, 2); return this;
	}
	QTabBar setTabToolTip(T: QString)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, text.QtObj, index, 3); return this;
	}
	QTabBar setTabToolTip(T: string)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, sQString(to!string(text)).QtObj, index, 3); return this;
		// return setTabToolTip(index, (new QString(to!string(text))));
	}
	QTabBar setTabWhatsThis(T: QString)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, text.QtObj, index, 4); return this;
	}
	QTabBar setTabWhatsThis(T: string)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, sQString(to!string(text)).QtObj, index, 4); return this;
		// return setTabWhatsThis(index, (new QString(to!string(text))));
	}
	QTabBar setTabData(int index, void* uk) {
		(cast(t_v__qp_qp_i) pFunQt[429])(QtObj, cast(QtObjH)uk, index);	return this;
	}
	void* tabData(int index) {
		return cast(void*)((cast(t_qp__qp_i) pFunQt[430])(QtObj, index));
	}
}
// ============ QScintilla ===========================================
class QScintilla : QWidget {
    //! Этот перечисление определяет различные стили автоиндентификации.
    enum lineIdent {
        //! Линия автоматически сгибается в соответствии с предыдущей линией.
        AiMaintain = 0x01,
        // Если язык, поддерживаемый текущим лексиконом, имеет специфический старт 
		// блочного символа (например, '{' в Си++), затем строка, начинающаяся с 
		// что символ имеет отступы, а также линии, из которых состоят блок.
        // Логически это может быть логически связано с закрытием AiClosing.
        AiOpening = 0x02,
        //! If the language supported by the current lexer has a specific end
        //! of block character (e.g. } in C++), then a line that begins with
        //! that character is indented as well as the lines that make up the
        //! block.  It may be logically ored with AiOpening.
        AiClosing = 0x04
    } 
    //! Этот список определяет различные стили отображения аннотаций.
    enum AnnotationDisplay {
        //!  Аннотации не отображаются.
        AnnotationHidden,
        //!  Примечания нарисованы слева, без украшения
        AnnotationStandard,
        //! Аннотации окружены рамкой.
        AnnotationBoxed,
        //! Аннотации снабжены отступом в соответствии с текстом
        AnnotationIndented
    } 
    enum MarkerSymbol {
        Circle 						= 0,	// Кпуг.
        Rectangle 					= 1,	// Квадрат.
        RightTriangle 				= 2,	// Треугольник вправо.
        SmallRectangle 				= 3,	// Прямоугольник поменьше.
        RightArrow 					= 4,	// Стрелка указывающая направо 
        Invisible 					= 5,	// Невидимый маркер, позволяющий коду отслеживать движение линий
        DownTriangle 				= 6,	// Треугольник напрвленный вниз
        Minus 	 					= 7,	// SC_MARK_MINUS,
        Plus  						= 8, 	// A drawn plus sign.
        VerticalLine 				= 9,	// Вертикальная линия, нарисованная цветом фона
        BottomLeftCorner 			= 10,	// Нижний левый угол, нарисованный фоновым цветом
        LeftSideSplitter 			= 11,	// Вертикальная линия с центральной правой горизонтальной линией, нарисованной справа
        BoxedPlus 					= 12,	// Нарисованный знак плюс в квадрате
        BoxedPlusConnected 			= 13,	// Нарисованный знак плюс в подключенной коробке
        BoxedMinus 					= 14,	// A drawn minus sign in a box.
        BoxedMinusConnected 		= 15,	// Нарисованный знак минус в подключенной коробке
        RoundedBottomLeftCorner 	= 16,	// Закругленный левый нижний угол, нарисованный фоновым цветом.
        LeftSideRoundedSplitter 	= 17,	// Вертикальная линия с центральной правой изогнутой линией, нарисованной в фоновый цвет 
        CircledPlus 				= 18,	// Нарисованный знак плюс в виде круга

        //! A drawn plus sign in a connected box.
        CircledPlusConnected = 19,
        //! A drawn minus sign in a circle.
        CircledMinus = 20,
        //! A drawn minus sign in a connected circle.
        CircledMinusConnected = 21,
        //! No symbol is drawn but the line is drawn with the same background
        //! color as the marker's.
        Background = 22,
        ThreeDots 					= 23,	// Три нарисованные точки
        //! Three drawn arrows pointing right.
        ThreeRightArrows = 24,
        //! A full rectangle (ie. the margin background) using the marker's
        //! background color.
        FullRectangle = 25,
        //! A left rectangle (ie. the left part of the margin background) using
        //! the marker's background color.
        LeftRectangle = 26,
        //! No symbol is drawn but the line is drawn underlined using the
        //! marker's background color.
        Underline 					= 27,	// Цвет фона маркера
        Bookmark 					= 28	// Закладка
    }; 	

	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[601])(QtObj); setQtObj(null); }
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[600])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[600])(null));
		}
	} /// Конструктор
	// Установить цвет основного шрифта в окне редактора
	void setColor( QColor color ) {
		(cast(t_v__qp_qp)pFunQt[602])( QtObj, color.QtObj );
	}
	// Вернуть цвет основного шрафта
	QColor color() {
		return new QColor('+', (cast(t_qp__qp) pFunQt[605])(QtObj) );
	}
	// 603
	bool overwriteMode() {
		return (cast(t_b__qp)pFunQt[603])( QtObj );
	}
	// 604
	void setOverwriteMode(bool mode) {(cast(t_v__qp_b)pFunQt[604])( QtObj, mode );}
	// 606 Установить цвет foreground (paper) 
	void setPaper( QColor color ) {(cast(t_v__qp_qp)pFunQt[606])( QtObj, color.QtObj );}
	// 607
	// Вернуть цвет foreground (paper) 
	QColor paper() {return new QColor('+', (cast(t_qp__qp) pFunQt[607])(QtObj) );}
	// 608
	void setFontEdit(QFont font) {(cast(t_v__qp_qp)pFunQt[608])( QtObj, font.QtObj );}
	// 609
	void setAutoIndent(bool mode) {(cast(t_v__qp_b)pFunQt[609])( QtObj, mode );}
	// 610
	bool isReadOnly() { return (cast(t_b__qp)pFunQt[610])( QtObj );}
	// 611
	void setReadOnly(bool ro) {(cast(t_v__qp_b)pFunQt[611])( QtObj, ro );}
	// 612  Ширина скрытого столбца номер его
	void setMarginWidth(int	margin, int width) {(cast(t_v__qp_i_i)pFunQt[612])( QtObj, margin, width );	}
	// 613  Установить маску на отоброжение столбца
	void setMarginMarkerMask(int margin, int mask) {(cast(t_v__qp_i_i)pFunQt[613])( QtObj, margin, mask );	}
	// 614  тип маркера отображаемого в столбце nm
	int markerDefine(MarkerSymbol ms, int nomKol) {
		return (cast(t_i__qp_i_i)pFunQt[614])( QtObj, ms, nomKol );
	}
	// 615  Добавить маркер на строку в колонку
	int markerAdd(int liner, int marerNum) {
		return (cast(t_i__qp_i_i)pFunQt[615])( QtObj, liner, marerNum );
	}
	
	
	
}
// ============ QCalendarWidget =======================================
class QCalendarWidget : QWidget {
	this() {}				// Обязателен
	~this() { del(); }		// Косвенный вызов деструк C++ обязателен
	override void del() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[465])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[464])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[464])(null));
		}
	} /// Конструктор
	QDate selectedDate() {
		QDate tkd = new QDate(); 
		(cast(t_qp__qp_qp) pFunQt[466])(QtObj, tkd.QtObj);
		return tkd;
	}
	@property bool isDateEditEnabled() {	return (cast(t_b__qp_i) pFunQt[471])(QtObj, 0);	}
	@property bool isGridVisible() {	return (cast(t_b__qp_i) pFunQt[471])(QtObj, 1);	}
	@property bool isNavigationBarVisible() {	return (cast(t_b__qp_i) pFunQt[471])(QtObj, 2);	}
	QCalendarWidget setGridVisible(bool b) {	(cast(t_v__qp_b_i) pFunQt[472])(QtObj, b, 0);	return this; 	}
	QCalendarWidget setNavigationBarVisible(bool b) {	(cast(t_v__qp_b_i) pFunQt[472])(QtObj, b, 1);	return this; 	}
	QCalendarWidget showNextMonth() { (cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 2);	return this; 	}
	QCalendarWidget showNextYear() {(cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 3); return this; }
	QCalendarWidget showPreviousMonth() {	(cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 4);	return this; 	}
	QCalendarWidget showPreviousYear() { (cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 5);	return this; 	}
	QCalendarWidget showSelectedDate() { (cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 6);	return this; 	}
	QCalendarWidget showToday() {	(cast(t_v__qp_b_i) pFunQt[472])(QtObj, true, 7);	return this; 	}
	QCalendarWidget setDateEditAcceptDelay(bool b) {(cast(t_v__qp_b_i) pFunQt[472])(QtObj, b, 8);	return this; 	}
	QCalendarWidget setDateEditEnabled(bool b) { (cast(t_v__qp_b_i) pFunQt[472])(QtObj, b, 9);	return this; 	}
}
// ============ QTranslator =======================================
class QTranslator  : QObject {
	this(){}
	~this() { (cast(t_v__qp) pFunQt[468])(QtObj); }
	this(QWidget parent) { // Only null !!!
		super();
		setQtObj((cast(t_qp__v) pFunQt[467])());
	}
	bool load(T: QString)(T str) { //-> Загрузить файл локализации
		return (cast(t_b__qp_qp) pFunQt[469])(QtObj, str.QtObj);
	}
	bool load(T)(T str) { //-> Загрузить файл локализации
		return (cast(t_b__qp_qp) pFunQt[469])(QtObj, sQString(str).QtObj);
	}
}
// ================ QTextCodec ==================
/++
Преобразование в - из кодовых страниц в unicod
+/
class QTextCodec  : QObject {
	this(){}
	this(string strNameCodec) {
		setQtObj((cast(t_qp__qp)pFunQt[448])(cast(QtObjH)strNameCodec.ptr));
	}
	QString toUnicode(string str, QString qstr) {
		(cast(t_v__qp_qp_qp) pFunQt[449])(QtObj, qstr.QtObj, cast(QtObjH)str.ptr);
		return qstr;
	}
	char* fromUnicode(char* str, QString qstr) {
		(cast(t_v__qp_qp_qp) pFunQt[450])(QtObj, qstr.QtObj, cast(QtObjH)str); return str;
	}
}


/*
	string toStringD() {
		return to!string(cast(char*) data());
	} /// Convert QByteArray --> strinng Dlang
	bool arrIsEquals(QByteArray ab) {
		return (cast(t_bool__vp_vp) pFunQt4[140])(QtObj, ab.QtObj);
	}
	// Забить массив символом ch и если указан resize изменить размер
	void* fill(char ch, int resize = -1) {
		return (cast(t_vp__vp_c_i) pFunQt4[143])(QtObj, ch, resize);
	}
	// Создать массив из сырых байтов без NULL в конце из s размером n
	void* fromRawData(char* s, int n) {
		return (cast(t_vp__vp_cp_i) pFunQt4[144])(QtObj, s, n);
	}
	// Искать позицию вхождения подстроки в массиве
	int indexOf(QByteArray str, int poz = 0) {
		return (cast(t_i__vp_vp_vp) pFunQt4[145])(QtObj, str.QtObj, cast(void*) poz);
	}
	// Искать позицию вхождения подстроки в массиве
	int indexOf(char* str, int poz = 0) {
		return (cast(t_i__vp_vp_vp) pFunQt4[146])(QtObj, cast(void*) str, cast(void*) poz);
	}
	// Искать позицию вхождения подстроки в массиве
	int indexOf(char ch, int poz = 0) {
		return (cast(t_i__vp_vp_vp) pFunQt4[147])(QtObj, cast(void*) ch, cast(void*) poz);
	}

	void* operator1(QByteArray mas) {
		return (cast(t_vp__vp_vp) pFunQt4[148])(QtObj, mas.QtObj);
	}
	// Вынимает левые n байт и запихивает их в QByteArray arr
	void* left(QByteArray arr, int n) {
		return (cast(t_vp__vp_vp_i) pFunQt4[149])(QtObj, arr.QtObj, n);
	} /// Вынимает левые n байт и запихивает их в QByteArray arr

	void clear() {
		(cast(t_v__vp) pFunQt4[153])(QtObj);
	} /// Очищает массив и сбрасывает его длину в 0
	void resize(int rez) {
		(cast(t_v__vp_i) pFunQt4[156])(QtObj, rez);
	} /// Очищает массив и сбрасывает его длину в 0
	void* mid(QByteArray arr, int pos, int len = -1) {
		return (cast(t_vp__vp_vp_i_i) pFunQt4[150])(QtObj, arr.QtObj, pos, len);
	} /// Вынимает левые len байт с позиции pos и запихивает их в QByteArray arr
	void* prepend(char* str) {
		return (cast(t_vp__vp_vp) pFunQt4[237])(QtObj, str);
	} /// дописывает строку в начало
	void* prepend(string strD) {
		return (cast(t_vp__vp_vp) pFunQt4[237])(QtObj, cast(char*) strD.ptr);
	} /// дописывает строку в начало
	void* prepend(char s) {
		return (cast(t_vp__vp_i) pFunQt4[239])(QtObj, cast(int) s);
	} /// дописывает char в начало

	void* append(char* str, int len) {
		return (cast(t_vp__vp_vp_i) pFunQt4[151])(QtObj, str, len);
	} /// дописывает строку длиной n в конец
	void* append(char* str) {
		return (cast(t_vp__vp_vp) pFunQt4[152])(QtObj, str);
	} /// дописывает строку в конец
	void* append(char s) {
		return (cast(t_vp__vp_i) pFunQt4[154])(QtObj, cast(int) s);
	} /// дописывает char в конец
	void* append(QByteArray arr) {
		return (cast(t_vp__vp_vp) pFunQt4[155])(QtObj, arr.QtObj);
	} /// дописывает QByteArray
	void* append(string strD) {
		return (cast(t_vp__vp_vp) pFunQt4[152])(QtObj, cast(char*) strD.ptr);
	} /// дописывает stringD  в конец
	void* remove(int pos, int len) {
		return (cast(t_vp__vp_i_i) pFunQt4[157])(QtObj, pos, len);
	} /// дописывает char в конец
	int toInt(bool* b = null, int base = 10) {
		return (cast(t_i__vp_vbool_i) pFunQt4[158])(QtObj, b, base);
	}

	void add0() {
		int dl = size();
		append('\0');
		resize(dl);
	} /// Дописать в конец масива 0

	void opAssign(void* mas) {
		(cast(t_vp__vp_vp) pFunQt4[148])(QtObj, mas);
	}
	// Brrrrrrrr ....
	override bool opEquals(Object o) {
		string s_this;
		string s_o;
		bool rez;
		rez = false;
		s_this = this.toString();
		s_o = o.toString();
		if (s_this == s_o) {
			rez = (cast(t_bool__vp_vp) pFunQt4[140])(QtObj, (cast(QByteArray) o).QtObj);
		} else { // Ещё будем сравнивать с другими типами например char*
		}
		writeln("!!!!!!!! ==== opEquals =======!!!!!!!");
		writeln("   o = [", o.toString(), "]");
		writeln("this = [", this.toString(), "]");
		writeln(this, "  =  ", o);
		return rez;
	} /// Перегрузка операторов == и !=
*/

// -------------------- Бахарев Олег ----------------------------

__EOF__

// Читать файл, strip и в string[]
string[] m = stdin.byLineCopy.map!strip.array;


// Пример возврата объекта из С++ и подхвата его в объект D
QString proverka(QString qs) {
	static void* adr;	adr = (cast(t_vp__qp) pFunQt[381])(qs.QtObj); return new QString('+', &adr );
}
// Пример возврата объекта из С++
extern "C" MSVC_API  void* QImage_pixelColor(QImage* qi, int x, int y)  {
    return *((void**)&( Объект_C++ ));
}
// синтаксический сахар
alias ubyte[] arr;
// встраивание картинок
auto f = cast (arr[]) [
             cast(ubyte[]) import(`image0.jpg`),
             cast(ubyte[]) import(`image1.jpg`),
             cast(ubyte[]) import(`image2.jpg`),
             cast(ubyte[]) import(`image3.jpg`),
             cast(ubyte[]) import(`image4.jpg`),
             cast(ubyte[]) import(`image5.jpg`),
             cast(ubyte[]) import(`image6.jpg`),
             cast(ubyte[]) import(`image7.jpg`),
             cast(ubyte[]) import(`image8.jpg`),
             cast(ubyte[]) import(`image9.jpg`),
             cast(ubyte[]) import(`image10.jpg`),
             cast(ubyte[]) import(`image11.jpg`),
             cast(ubyte[]) import(`image12.jpg`),
             cast(ubyte[]) import(`image13.jpg`),
             cast(ubyte[]) import(`image14.jpg`),
             cast(ubyte[]) import(`image15.jpg`),
             cast(ubyte[]) import(`image16.jpg`),
             cast(ubyte[]) import(`image17.jpg`)
         ];

// встраивание музыки
ubyte[] mp3data = cast(ubyte[]) import(`this_love.mp3`);
