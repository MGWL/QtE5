// Written in the D programming language.
// MGW Мохов Геннадий Владимирович 2016

/*
Slots:
    void Slot_AN();             --> "Slot_AN()" 				// void call(Aдркласса, Nчисло);
    void Slot_ANI(int);         --> "Slot_ANI(int)" 			// void call(Aдркласса, Nчисло, int);
    void Slot_ANII(int, int);   --> "Slot_ANII(int, int)"		// void call(Aдркласса, Nчисло, int, int);
    void Slot_ANB(bool);        --> "Slot_ANB(bool)"			// void call(Aдркласса, Nчисло, bool);
    void Slot_ANQ(QObject*);    --> "Slot_ANQ(QObject*)"		// void call(Aдркласса, Nчисло, QObject*);
Signals:
    void Signal_V();          	--> "Signal_V()"				// Сигнал без параметра
    void Signal_VI(int);      	--> "Signal_VI(int)"			// Сигнал с int
    void Signal_VS(QString);  	--> "Signal_VS(QString)"		// Сигнал с QString
*/

module qte5;

import std.conv; // Convert to string
import std.utf: encode;

// Отладка
import std.stdio;

int verQt5Eu = 0;
int verQt5El = 09;
string verQt5Ed = "06.10.17 11:02";

alias PTRINT = int;
alias PTRUINT = uint;

struct QtObj__ { PTRINT dummy; } alias QtObjH = QtObj__*;


private void*[500] pFunQt; /// Масив указателей на функции из DLL

immutable int QMETHOD = 0; // member type codes
immutable int QSLOT = 1;
immutable int QSIGNAL = 2;

// ----- Описание типов, фактически указание компилятору как вызывать -----
// ----- The description of types, actually instructions to the compiler how to call -----

// Give type Qt. There is an implicit transformation. cast (GetObjQt_t) Z == *Z on any type.
// alias GetObjQt_t = void**; // Дай тип Qt. Происходит неявное преобразование. cast(GetObjQt_t)Z == *Z на любой тип.
private {
	// Generate alias for types call function Qt 
	string generateAlias(string ind) {
		string rez;	
		string[string] v;
		v["v"]="void";v[""]="";v["t"]="t";v["qp"]="QtObjH";v["i"]="int";
		v["ui"]="uint";v["c"]="char";v["vp"]="void*";v["b"]="bool";v["cp"]="char*";
		v["ip"]="int*";v["vpp"]="void**";v["bool"]="bool";v["us"]="ushort";v["l"]="long";
		auto mas = split(ind, '_');
		rez = "alias " ~ ind ~ " = extern (C) @nogc " ~ v[mas[1]] ~ " function(";
		foreach(i, el; mas) if(i > 2) rez ~= v[el] ~ ", ";
		rez = rez[0 .. $-2];	rez ~= ");"; 
		return rez;
	}
	string generateFunQt(int n, string name) {
		return "funQt(" ~ to!string(n) ~ `,bQtE5Widgets,hQtE5Widgets,sQtE5Widgets,r"` ~ name ~ `",showError);`;
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

	mixin(generateAlias("t_v__qp_i_i_i_i_i"));
	mixin(generateAlias("t_v__qp_ip_ip_ip_ip"));

	mixin(generateAlias("t_v__vp_vp_i"));
	mixin(generateAlias("t_i__vp_vp_vp"));
	mixin(generateAlias("t_i__vp_i"));
	mixin(generateAlias("t_i__qp_i"));
	mixin(generateAlias("t_i__qp_qp"));
	mixin(generateAlias("t_i__qp_i_i"));
	mixin(generateAlias("t_i__qp_qp_i"));
	mixin(generateAlias("t_qp__qp_qp"));
	mixin(generateAlias("t_vp__vp_c_i"));
	mixin(generateAlias("t_vp__vp_cp_i"));
	mixin(generateAlias("t_i__qp_qp_qp_i_i"));

	mixin(generateAlias("t_vpp__vp"));
	mixin(generateAlias("t_qp__qp"));
	mixin(generateAlias("t_qp__ui"));
	mixin(generateAlias("t_qp__vp"));

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
	alias t_vp__v = extern (C) @nogc void* function();
	alias t_qp__v = extern (C) @nogc QtObjH function();
	mixin(generateAlias("t_i__vp"));
	mixin(generateAlias("t_i__qp"));

	mixin(generateAlias("t_v__qp_b_i_i"));
	mixin(generateAlias("t_v__qp_b_i"));

	mixin(generateAlias("t_vp__i_i"));
	mixin(generateAlias("t_qp__i_i"));
	mixin(generateAlias("t_qp__i_i_i"));
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
	pFunQt[n] = GetPrAddress(b, h, name); if (!pFunQt[n]) MessageErrorLoad(she, name, s);
	// writeln(name, " ", pFunQt[n]);
}

int LoadQt(dll ldll, bool showError) { ///  Загрузить DLL-ки Qt и QtE
	bool	bCore5, bGui5, bWidget5, bQtE5Widgets;
	string	sCore5, sGui5, sWidget5, sQtE5Widgets;
	void*	hCore5, hGui5, hWidget5, hQtE5Widgets;

	// Add path to directory with real file Qt5 DLL
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
	// Use symlink for create link on real file Qt5
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
	// Use symlink for create link on real file Qt5
	// Only 64 bit version Mac OS X (10.9.5 Maveric)
	version (OSX) {
		string[] libs = ["QtCore", "QtGui", "QtWidgets", "QtDBus" , "QtPrintSupport" /*  ,"libqcocoa.dylib" */ ];
		foreach(l; libs) {
			void* h = GetHlib(l);
		}
    	// sCore5			= "QtCore";
		// sGui5			= "QtGui";
		// sWidget5		= "QtWidgets";
		sQtE5Widgets	= "libQtE5Widgets64.dylib";
	}

	// Если на входе указана dll.QtE5Widgets то автоматом надо грузить и bCore5, bGui5, bWidget5
	// If on an input it is specified dll.QtE5Widgets then automatic loaded bCore5, bGui5, bWidget5
	bQtE5Widgets= ldll && dll.QtE5Widgets;
	if(bQtE5Widgets) { bCore5 = true; bGui5 = true; bWidget5 = true; }

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
	// Find name function in DLL
	
	// ------- QObject -------
	mixin(generateFunQt(344, "qteQObject_parent"));

	// ------- QApplication -------
	mixin(generateFunQt(	0,   	"qteQApplication_create1"			));
	mixin(generateFunQt(	1,   	"qteQApplication_exec"				));
	mixin(generateFunQt(	2,   	"qteQApplication_aboutQt"			));
	mixin(generateFunQt(	3,   	"qteQApplication_delete1"			));
	mixin(generateFunQt(	4,   	"qteQApplication_sizeof"			));
	mixin(generateFunQt(	20,  	"qteQApplication_appDirPath"		));
	mixin(generateFunQt(	21,  	"qteQApplication_appFilePath"		));
	mixin(generateFunQt(	273,  	"qteQApplication_quit"				));
	mixin(generateFunQt(	368,  	"qteQApplication_processEvents"		));
	mixin(generateFunQt(	276,  	"qteQApplication_exit"				));
	mixin(generateFunQt(	277,  	"qteQApplication_setStyleSheet"		));

	// ------- QWidget -------
	mixin(generateFunQt(	5,   	"qteQWidget_create1"				));
	mixin(generateFunQt(	6,   	"qteQWidget_setVisible"				));
	mixin(generateFunQt(	7,   	"qteQWidget_delete1"				));
	mixin(generateFunQt(	11,  	"qteQWidget_setWindowTitle"			));
	mixin(generateFunQt(	12,  	"qteQWidget_isVisible"				));
	mixin(generateFunQt(	30,  	"qteQWidget_setStyleSheet"			));
	mixin(generateFunQt(	31,  	"qteQWidget_setMMSize"				));
	mixin(generateFunQt(	32,  	"qteQWidget_setEnabled"				));
	mixin(generateFunQt(	33,  	"qteQWidget_setToolTip"				));
	mixin(generateFunQt(	40,  	"qteQWidget_setLayout"				));
	mixin(generateFunQt(	78,  	"qteQWidget_setSizePolicy"			));
	mixin(generateFunQt(	79,  	"qteQWidget_setMax1"				));
	mixin(generateFunQt(	87,  	"qteQWidget_exWin1"					));
	mixin(generateFunQt(	94,  	"qteQWidget_exWin2"					));
	mixin(generateFunQt(	49,  	"qteQWidget_setKeyPressEvent"		));
	mixin(generateFunQt(	50,  	"qteQWidget_setPaintEvent"			));
	mixin(generateFunQt(	51,  	"qteQWidget_setCloseEvent"			));
	mixin(generateFunQt(	52,  	"qteQWidget_setResizeEvent"			));
	mixin(generateFunQt(	131, 	"qteQWidget_setFont"				));
	mixin(generateFunQt(	148, 	"qteQWidget_winId"					));
	mixin(generateFunQt(	172, 	"qteQWidget_getPr"					));
	mixin(generateFunQt(	259, 	"qteQWidget_getBoolXX"				));
	mixin(generateFunQt(	279, 	"qteQWidget_setGeometry"			));
	mixin(generateFunQt(	280, 	"qteQWidget_contentsRect"			));

	// ------- QString -------
	mixin(generateFunQt(	8,   	"qteQString_create1"				));
	mixin(generateFunQt(	9,   	"qteQString_create2"				));
	mixin(generateFunQt(	10,  	"qteQString_delete"					));
	mixin(generateFunQt(	18,  	"qteQString_data"					));
	mixin(generateFunQt(	19,  	"qteQString_size"					));
	mixin(generateFunQt(	281, 	"qteQString_sizeOf"					));
	
	// ------- QColor -------
	mixin(generateFunQt(	13,  	"qteQColor_create1"					));
	mixin(generateFunQt(	14,  	"qteQColor_delete"					));
	mixin(generateFunQt(	15,  	"qteQColor_setRgb"					));
	mixin(generateFunQt(	320, 	"qteQColor_getRgb"					));
	mixin(generateFunQt(	322, 	"qteQColor_rgb"						));
	mixin(generateFunQt(	323, 	"qteQColor_setRgb2"					));
	mixin(generateFunQt(	324, 	"qteQColor_create2"					));

	// ------- QPalette -------
	mixin(generateFunQt(	16,  	"qteQPalette_create1"				));
	mixin(generateFunQt(	17,  	"qteQPalette_delete"				));
	
	// ------- QPushButton -------
	mixin(generateFunQt(	22,  	"qteQPushButton_create1"			));
	mixin(generateFunQt(	23,  	"qteQPushButton_delete"				));
	mixin(generateFunQt(	210, 	"qteQPushButton_setXX"				));

	// ------- QSlot -------
//	funQt(24, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlot_create",            showError);
//	funQt(25, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "QSlot_setSlotN",             showError);
//	funQt(26, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQSlot_delete",            showError);
	mixin(generateFunQt(	27,  	"qteConnect"						));
	mixin(generateFunQt(	343, 	"qteDisconnect"						));
//	funQt(81, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "QSlot_setSlotN2",            showError);

	// ------- QAbstractButton -------
	mixin(generateFunQt(	28,  	"qteQAbstractButton_setText"		));
	mixin(generateFunQt(	29,  	"qteQAbstractButton_text"			));
	mixin(generateFunQt(	209, 	"qteQAbstractButton_setXX"			));
	mixin(generateFunQt(	211, 	"qteQAbstractButton_setIcon"		));
	mixin(generateFunQt(	224, 	"qteQAbstractButton_getXX"			));

	// ------- QLayout -------
	mixin(generateFunQt(	34,  	"qteQBoxLayout"						));
	mixin(generateFunQt(	35,  	"qteQVBoxLayout"					));
	mixin(generateFunQt(	36,  	"qteQHBoxLayout"					));
	mixin(generateFunQt(	37,  	"qteQBoxLayout_delete"				));
	mixin(generateFunQt(	38,  	"qteQBoxLayout_addWidget"			));
	mixin(generateFunQt(	39,  	"qteQBoxLayout_addLayout"			));
	mixin(generateFunQt(	74,  	"qteQBoxLayout_setSpacing"			));
	mixin(generateFunQt(	75,  	"qteQBoxLayout_spacing"				));
	mixin(generateFunQt(	76,  	"qteQBoxLayout_setMargin"			));
	mixin(generateFunQt(	77,  	"qteQBoxLayout_margin"				));

	// ------- QFrame -------
	mixin(generateFunQt(	41,  	"qteQFrame_create1"					));
	mixin(generateFunQt(	42,  	"qteQFrame_delete1"					));
	mixin(generateFunQt(	43,  	"qteQFrame_setFrameShape"			));
	mixin(generateFunQt(	44,  	"qteQFrame_setFrameShadow"			));
	mixin(generateFunQt(	45,  	"qteQFrame_setLineWidth"			));
	mixin(generateFunQt(	290, 	"qteQFrame_listChildren"			));

	// ------- QLabel --------
	mixin(generateFunQt(	46,  	"qteQLabel_create1"					));
	mixin(generateFunQt(	47,  	"qteQLabel_delete1"					));
	mixin(generateFunQt(	48,  	"qteQLabel_setText"					));
	
	// ------- QEvent -------
	mixin(generateFunQt(	53,  	"qteQEvent_type"					));
	mixin(generateFunQt(	157, 	"qteQEvent_ia"						));
	
	// ------- QResizeEvent -------
	mixin(generateFunQt(	54,  	"qteQResizeEvent_size"				));
	mixin(generateFunQt(	55,  	"qteQResizeEvent_oldSize"			));
	
	// ------- QSize -------
	mixin(generateFunQt(	56,  	"qteQSize_create1"					));
	mixin(generateFunQt(	57,  	"qteQSize_delete1"					));
	mixin(generateFunQt(	58,  	"qteQSize_width"					));
	mixin(generateFunQt(	59,  	"qteQSize_height"					));
	mixin(generateFunQt(	60,  	"qteQSize_setWidth"					));
	mixin(generateFunQt(	61,  	"qteQSize_setHeight"				));
	
	// ------- QKeyEvent -------
	mixin(generateFunQt(	62,  	"qteQKeyEvent_key"					));
	mixin(generateFunQt(	63, 	"qteQKeyEvent_count"				));
	mixin(generateFunQt(	285,	"qteQKeyEvent_modifiers"			));

	// ------- QAbstractScrollArea -------
	mixin(generateFunQt(	64, 	"qteQAbstractScrollArea_create1"	));
	mixin(generateFunQt(	65, 	"qteQAbstractScrollArea_delete1"	));
	
	// ------- QPlainTextEdit -------
	mixin(generateFunQt(	66, 	"qteQPlainTextEdit_create1"			));
	mixin(generateFunQt(	67, 	"qteQPlainTextEdit_delete1"			));
	mixin(generateFunQt(	68, 	"qteQPlainTextEdit_appendPlainText"	));
	mixin(generateFunQt(	69, 	"qteQPlainTextEdit_appendHtml"		));
	mixin(generateFunQt(	70, 	"qteQPlainTextEdit_setPlainText"	));
	mixin(generateFunQt(	71, 	"qteQPlainTextEdit_insertPlainText"	));
	mixin(generateFunQt(	72, 	"qteQPlainTextEdit_cutn"			));
	mixin(generateFunQt(	73, 	"qteQPlainTextEdit_toPlainText"		));
	mixin(generateFunQt(	80, 	"qteQPlainTextEdit_setKeyPressEvent"));
	mixin(generateFunQt(	225,	"qteQPlainTextEdit_setKeyReleaseEvent"));
	mixin(generateFunQt(	226,	"qteQPlainTextEdit_document"		));
	mixin(generateFunQt(	230,	"qteQPlainTextEdit_textCursor"		));
	mixin(generateFunQt(	235,	"qteQPlainTextEdit_cursorRect"		));
	mixin(generateFunQt(	235,	"qteQPlainTextEdit_cursorRect"		));
	mixin(generateFunQt(	236,	"qteQPlainTextEdit_setTabStopWidth"	));
	mixin(generateFunQt(	253,	"qteQPlainTextEdit_setTextCursor"	));
	mixin(generateFunQt(	278,	"qteQPlainTextEdit_setViewportMargins"));
	mixin(generateFunQt(	282,	"qteQPlainTextEdit_firstVisibleBlock"));
	mixin(generateFunQt(	284,	"qteQPlainTextEdit_getXYWH"			));
	mixin(generateFunQt(	294,	"qteQPlainTextEdit_setWordWrapMode"	));
	mixin(generateFunQt(	325,	"eQPlainTextEdit_setPaintEvent"		));
	mixin(generateFunQt(	326,	"qteQPlainTextEdit_getXX1"			));
	mixin(generateFunQt(	328,	"qteQPlainTextEdit_setCursorPosition"));
	mixin(generateFunQt(	329,	"qteQPlainTextEdit_find1"			));
	mixin(generateFunQt(	330,	"qteQPlainTextEdit_find2"			));

	//  ------- QLineEdit -------
	mixin(generateFunQt(	82, 	"qteQLineEdit_create1"				));
	mixin(generateFunQt(	83, 	"qteQLineEdit_delete1"				));
	mixin(generateFunQt(	84, 	"qteQLineEdit_set"					));
	mixin(generateFunQt(	85, 	"qteQLineEdit_clear"				));
	mixin(generateFunQt(	86, 	"qteQLineEdit_text"					));
	mixin(generateFunQt(	158,	"qteQLineEdit_setKeyPressEvent"		));
	mixin(generateFunQt(	287,	"qteQLineEdit_setX1"				));
	mixin(generateFunQt(	288,	"qteQLineEdit_getX1"				));

	//  ------- QMainWindow -------
	mixin(generateFunQt(	88, 	"qteQMainWindow_create1"			));
	mixin(generateFunQt(	89, 	"qteQMainWindow_delete1"			));
	mixin(generateFunQt(	90, 	"qteQMainWindow_setXX"				));
	mixin(generateFunQt(	126, 	"qteQMainWindow_addToolBar"			));

	//  ------- QStatusBar -------
	mixin(generateFunQt(	91, 	"qteQStatusBar_create1"				));
	mixin(generateFunQt(	92, 	"qteQStatusBar_delete1"				));
	mixin(generateFunQt(	93, 	"qteQStatusBar_showMessage"			));
	mixin(generateFunQt(	314,	"qteQStatusBar_addWidgetXX1"		));

	//  ------- QAction -------
	mixin(generateFunQt(	95, 	"qteQAction_create"					));
	mixin(generateFunQt(	96, 	"qteQAction_delete"					));
	mixin(generateFunQt(	289,	"qteQAction_getParent"				));
	mixin(generateFunQt(	97, 	"qteQAction_setXX1"					));
	mixin(generateFunQt(	98, 	"qteQAction_setSlotN2"				));
	
	mixin(generateFunQt(	105,  	"qteQAction_setHotKey"				));
	mixin(generateFunQt(	109,  	"qteQAction_setEnabled"				));
	mixin(generateFunQt(	113,  	"qteQAction_setIcon"				));
	mixin(generateFunQt(	339,  	"qteQAction_SendSignal_V"			));
	mixin(generateFunQt(	340,  	"qteQAction_SendSignal_VI"			));
	mixin(generateFunQt(	341,  	"qteQAction_SendSignal_VS"			));

	//  ------- QMenu -------
	mixin(generateFunQt(	99,   	"qteQMenu_create"					));
	mixin(generateFunQt(	100,  	"qteQMenu_delete"					));
	mixin(generateFunQt(	101,  	"qteQMenu_addAction"				));
	mixin(generateFunQt(	106,  	"qteQMenu_setTitle"					));
	mixin(generateFunQt(	107,  	"qteQMenu_addSeparator"				));
	mixin(generateFunQt(	108,  	"qteQMenu_addMenu"					));

	//  ------- QMenuBar -------
	mixin(generateFunQt(	102,  	"qteQMenuBar_create"				));
	mixin(generateFunQt(	103,  	"qteQMenuBar_delete"				));
	mixin(generateFunQt(	104,  	"qteQMenuBar_addMenu"				));
	
	//  ------- QIcon -------
	mixin(generateFunQt(	110,  	"qteQIcon_create"					));
	mixin(generateFunQt(	111,  	"qteQIcon_delete"					));
	mixin(generateFunQt(	112,  	"qteQIcon_addFile"					));
	mixin(generateFunQt(	377,  	"qteQIcon_addFile2"					));
	mixin(generateFunQt(	378,  	"qteQIcon_swap"						));
	
	//  ------- QToolBar -------
	mixin(generateFunQt(	114,  	"qteQToolBar_create"				));
	mixin(generateFunQt(	115,  	"qteQToolBar_delete"				));
	mixin(generateFunQt(	116,  	"qteQToolBar_setXX1"				));
	mixin(generateFunQt(	124,  	"qteQToolBar_setAllowedAreas"		));
	mixin(generateFunQt(	125,  	"qteQToolBar_setToolButtonStyle"	));
	mixin(generateFunQt(	132,  	"qteQToolBar_addSeparator"			));

	//  ------- QDialog -------
	mixin(generateFunQt(	117, 	"qteQDialog_create"					));
	mixin(generateFunQt(	118, 	"qteQDialog_delete"					));
	mixin(generateFunQt(	119, 	"qteQDialog_exec"					));
	
	//  ------- QDialog -------
	mixin(generateFunQt(	120, 	"qteQMessageBox_create"				));
	mixin(generateFunQt(	121, 	"qteQMessageBox_delete"				));
	mixin(generateFunQt(	122, 	"qteQMessageBox_setXX1"				));
	mixin(generateFunQt(	123, 	"qteQMessageBox_setStandardButtons"	));
	
	//  ------- QFont -------
	mixin(generateFunQt(	127, 	"qteQFont_create"					));
	mixin(generateFunQt(	128, 	"qteQFont_delete"					));
	mixin(generateFunQt(	129, 	"qteQFont_setPointSize"				));
	mixin(generateFunQt(	130, 	"qteQFont_setFamily"				));
	mixin(generateFunQt(	312, 	"qteQFont_setBoolXX1"				));
	mixin(generateFunQt(	313, 	"qteQFont_getBoolXX1"				));
	
	//  ------- QProgressBar -------
	mixin(generateFunQt(	133, 	"qteQProgressBar_create"			));
	mixin(generateFunQt(	134, 	"qteQProgressBar_delete"			));
	mixin(generateFunQt(	135, 	"qteQProgressBar_setPr"				));
	
	//  ------- QDate -------
	mixin(generateFunQt(	136, 	"qteQDate_create"					));
	mixin(generateFunQt(	137, 	"qteQDate_delete"					));
	mixin(generateFunQt(	140, 	"qteQDate_toString"					));

	//  ------- QTime -------
	mixin(generateFunQt(	138, 	"qteQTime_create"					));
	mixin(generateFunQt(	139, 	"qteQTime_delete"					));
	mixin(generateFunQt(	141, 	"qteQTime_toString"					));

	//  ------- QFileDialog -------
	mixin(generateFunQt(	142, 	"qteQFileDialog_create"				));
	mixin(generateFunQt(	143, 	"qteQFileDialog_delete"				));
	mixin(generateFunQt(	144, 	"qteQFileDialog_setNameFilter"		));
	mixin(generateFunQt(	145, 	"qteQFileDialog_setViewMode"		));
	mixin(generateFunQt(	146, 	"qteQFileDialog_getOpenFileName"	));
	mixin(generateFunQt(	147, 	"qteQFileDialog_getSaveFileName"	));
	mixin(generateFunQt(	274, 	"qteQFileDialog_stGetOpenFileName"	));
	mixin(generateFunQt(	275, 	"qteQFileDialog_stGetSaveFileName"	));
	
	//  ------- QAbstractScrollArea -------
	mixin(generateFunQt(	149, 	"qteQAbstractScrollArea_create"		));
	mixin(generateFunQt(	150, 	"qteQAbstractScrollArea_delete"		));
	
	//  ------- QMdiArea -------
	mixin(generateFunQt(	151, 	"qteQMdiArea_create"				));
	mixin(generateFunQt(	152, 	"qteQMdiArea_delete"				));
	mixin(generateFunQt(	155, 	"qteQMdiArea_addSubWindow"			));
	mixin(generateFunQt(	338, 	"qteQMdiArea_activeSubWindow"		));

	//  ------- QMdiSubWindow -------
	mixin(generateFunQt(	153, 	"qteQMdiSubWindow_create"			));
	mixin(generateFunQt(	154, 	"qteQMdiSubWindow_delete"			));
	mixin(generateFunQt(	156, 	"qteQMdiSubWindow_addLayout"		));

	//  ------- QTableView -------
	mixin(generateFunQt(	159, 	"qteQTableView_create"				));
	mixin(generateFunQt(	160, 	"qteQTableView_delete"				));
	mixin(generateFunQt(	174, 	"qteQTableView_setN1"				));
	mixin(generateFunQt(	175, 	"qteQTableView_getN1"				));
	mixin(generateFunQt(	182, 	"qteQTableView_ResizeMode"			));

	//  ------- QTableWidget -------
	mixin(generateFunQt(	161, 	"qteQTableWidget_create"			));
	mixin(generateFunQt(	162, 	"qteQTableWidget_delete"			));
	mixin(generateFunQt(	163, 	"qteQTableWidget_setRC"				));
	mixin(generateFunQt(	167, 	"qteQTableWidget_setItem"			));
	mixin(generateFunQt(	176, 	"qteQTableWidget_setHVheaderItem"	));
	mixin(generateFunQt(	241, 	"qteQTableWidget_setCurrentCell"	));
	mixin(generateFunQt(	369, 	"qteQTableWidget_getCurrent"		));
	mixin(generateFunQt(	370, 	"qteQTableWidget_item"				));
	mixin(generateFunQt(	371, 	"qteQTableWidget_takeItem"			));

	//  ------- QTableWidgetItem -------
	mixin(generateFunQt(	164, 	"qteQTableWidgetItem_create"		));
	mixin(generateFunQt(	165, 	"qteQTableWidgetItem_delete"		));
	mixin(generateFunQt(	166, 	"qteQTableWidgetItem_setXX"			));
	mixin(generateFunQt(	168, 	"qteQTableWidgetItem_setYY"			));
	mixin(generateFunQt(	169, 	"qteQTableWidget_item"				));
	mixin(generateFunQt(	170, 	"qteQTableWidgetItem_text"			));
	mixin(generateFunQt(	171, 	"qteQTableWidgetItem_setAlignment"	));
	mixin(generateFunQt(	180, 	"qteQTableWidgetItem_setBackground"	));
	mixin(generateFunQt(	372, 	"qteQTableWidgetItem_setFlags"		));
	mixin(generateFunQt(	373, 	"qteQTableWidgetItem_flags"			));
	mixin(generateFunQt(	374, 	"qteQTableWidgetItem_setSelected"	));
	mixin(generateFunQt(	375, 	"qteQTableWidgetItem_isSelected"	));
	mixin(generateFunQt(	376, 	"qteQTableWidgetItem_setIcon"		));

	//  ------- QBrush -------
	mixin(generateFunQt(	177, 	"qteQBrush_create1"					));
	mixin(generateFunQt(	178, 	"qteQBrush_delete"					));
	mixin(generateFunQt(	179, 	"qteQBrush_setColor"				));
	mixin(generateFunQt(	181, 	"qteQBrush_setStyle"				));

	//  ------- QComboBox -------
	mixin(generateFunQt(	183, 	"qteQComboBox_create"				));
	mixin(generateFunQt(	184, 	"qteQComboBox_delete"				));
	mixin(generateFunQt(	185, 	"qteQComboBox_setXX"				));
	mixin(generateFunQt(	186, 	"qteQComboBox_getXX"				));
	mixin(generateFunQt(	187, 	"qteQComboBox_text"					));

	//  ------- QPainter -------
	mixin(generateFunQt(	301, 	"qteQPainter_create"				));
	mixin(generateFunQt(	302, 	"qteQPainter_delete"				));
	mixin(generateFunQt(	188, 	"qteQPainter_drawPoint"				));
	mixin(generateFunQt(	189, 	"qteQPainter_drawLine"				));
	mixin(generateFunQt(	190, 	"qteQPainter_setXX1"				));
	mixin(generateFunQt(	196, 	"qteQPainter_setText"				));
	mixin(generateFunQt(	197, 	"qteQPainter_end"					));
	mixin(generateFunQt(	243, 	"qteQPainter_drawRect1"				));
	mixin(generateFunQt(	244, 	"qteQPainter_drawRect2"				));
	mixin(generateFunQt(	245, 	"qteQPainter_fillRect2"				));
	mixin(generateFunQt(	246, 	"qteQPainter_fillRect3"				));
	mixin(generateFunQt(	298, 	"qteQPainter_getFont"				));
	mixin(generateFunQt(	310, 	"qteQPainter_drawImage1"			));
	mixin(generateFunQt(	311, 	"qteQPainter_drawImage2"			));

	//  ------- QPen -------
	mixin(generateFunQt(	191, 	"qteQPen_create1"					));
	mixin(generateFunQt(	192, 	"qteQPen_delete"					));
	mixin(generateFunQt(	193, 	"qteQPen_setColor"					));
	mixin(generateFunQt(	194, 	"qteQPen_setStyle"					));
	mixin(generateFunQt(	195, 	"qteQPen_setWidth"					));

	//  ------- QLCDNumber -------
	mixin(generateFunQt(	198, 	"qteQLCDNumber_create1"				));
	mixin(generateFunQt(	199, 	"qteQLCDNumber_delete1"				));
	mixin(generateFunQt(	200, 	"qteQLCDNumber_create2"				));
	mixin(generateFunQt(	201, 	"qteQLCDNumber_display"				));
	mixin(generateFunQt(	202, 	"qteQLCDNumber_setSegmentStyle"		));
	mixin(generateFunQt(	203, 	"qteQLCDNumber_setDigitCount"		));
	mixin(generateFunQt(	204, 	"qteQLCDNumber_setMode"				));

	//  ------- QAbstractSlider -------
	mixin(generateFunQt(	205, 	"qteQAbstractSlider_setXX"			));
	mixin(generateFunQt(	208, 	"qteQAbstractSlider_getXX"			));

	//  ------- QSlider -------
	mixin(generateFunQt(	206, 	"qteQSlider_create1"				));
	mixin(generateFunQt(	207, 	"qteQSlider_delete1"				));

	//  ------- QGroupBox -------
	mixin(generateFunQt(	212, 	"qteQGroupBox_create"				));
	mixin(generateFunQt(	213, 	"qteQGroupBox_delete"				));
	mixin(generateFunQt(	214, 	"qteQGroupBox_setTitle"				));
	mixin(generateFunQt(	215, 	"qteQGroupBox_setAlignment"			));

	//  ------- QCheckBox -------
	mixin(generateFunQt(	216, 	"qteQCheckBox_create1"				));
	mixin(generateFunQt(	217, 	"qteQCheckBox_delete"				));
	mixin(generateFunQt(	218, 	"qteQCheckBox_checkState"			));
	mixin(generateFunQt(	219, 	"qteQCheckBox_setCheckState"		));
	mixin(generateFunQt(	220, 	"qteQCheckBox_setTristate"			));
	mixin(generateFunQt(	221, 	"qteQCheckBox_isTristate"			));

	//  ------- QRadioButton -------
	mixin(generateFunQt(	222, 	"qteQRadioButton_create1"			));
	mixin(generateFunQt(	223, 	"qteQRadioButton_delete"			));

	//  ------- QTextCursor -------
	mixin(generateFunQt(	227, 	"qteQTextCursor_create1"			));
	mixin(generateFunQt(	228, 	"qteQTextCursor_delete"				));
	mixin(generateFunQt(	229, 	"qteQTextCursor_create2"			));
	mixin(generateFunQt(	231, 	"qteQTextCursor_getXX1"				));
	mixin(generateFunQt(	254, 	"qteQTextCursor_movePosition"		));
	mixin(generateFunQt(	255, 	"qteQTextCursor_runXX"				));
	mixin(generateFunQt(	256, 	"qteQTextCursor_insertText1"		));
	mixin(generateFunQt(	286, 	"qteQTextCursor_select"				));
	mixin(generateFunQt(	327, 	"qteQTextCursor_setPosition"		));

	//  ------- QRect -------
	mixin(generateFunQt(	232, 	"qteQRect_create1"					));
	mixin(generateFunQt(	233, 	"qteQRect_delete"					));
	mixin(generateFunQt(	234, 	"qteQRect_setXX1"					));
	mixin(generateFunQt(	242, 	"qteQRect_setXX2"					));

	//  ------- QTextBlock -------
	mixin(generateFunQt(	237, 	"qteQTextBlock_text"				));
	mixin(generateFunQt(	238, 	"qteQTextBlock_create"				));
	mixin(generateFunQt(	239, 	"qteQTextBlock_delete"				));
	mixin(generateFunQt(	240, 	"qteQTextBlock_create2"				));
	mixin(generateFunQt(	283, 	"qteQTextBlock_blockNumber"			));
	mixin(generateFunQt(	299, 	"qteQTextBlock_next2"				));
	mixin(generateFunQt(	300, 	"qteQTextBlock_isValid2"			));

	//  ------- QSpinBox -------
	mixin(generateFunQt(	247, 	"qteQSpinBox_create"				));
	mixin(generateFunQt(	248, 	"qteQSpinBox_delete"				));
	mixin(generateFunQt(	249, 	"qteQSpinBox_setXX1"				));
	mixin(generateFunQt(	250, 	"qteQSpinBox_getXX1"				));
	mixin(generateFunQt(	251, 	"qteQSpinBox_setXX2"				));

	//  ------- QAbstractSpinBox -------
	mixin(generateFunQt(	252, 	"qteQAbstractSpinBox_setReadOnly"	));

	//  ------- Highlighter -- Временный, подлежит в дальнейшем удалению -----
	mixin(generateFunQt(	257, 	"qteHighlighter_create"				));
	mixin(generateFunQt(	258, 	"qteHighlighter_delete"				));

	// ------- QTextEdit -------
	mixin(generateFunQt(	260, 	"qteQTextEdit_create1"				));
	mixin(generateFunQt(	261, 	"qteQTextEdit_delete1"				));
	mixin(generateFunQt(	270, 	"qteQTextEdit_setFromString"		));
	mixin(generateFunQt(	271, 	"qteQTextEdit_toString"				));
	mixin(generateFunQt(	272, 	"qteQTextEdit_cutn"					));
	mixin(generateFunQt(	345, 	"qteQTextEdit_setBool"				));
	mixin(generateFunQt(	346, 	"qteQTextEdit_toBool"				));

	// ------- QTimer -------
	mixin(generateFunQt(	262, 	"qteQTimer_create"					));
	mixin(generateFunQt(	263, 	"qteQTimer_delete"					));
	mixin(generateFunQt(	264, 	"qteQTimer_setInterval"				));
	mixin(generateFunQt(	265, 	"qteQTimer_getXX1"					));
	mixin(generateFunQt(	266, 	"qteQTimer_getXX2"					));
	mixin(generateFunQt(	267, 	"qteQTimer_setTimerType"			));
	mixin(generateFunQt(	268, 	"qteQTimer_setSingleShot"			));
	mixin(generateFunQt(	269, 	"qteQTimer_timerType"				));
	mixin(generateFunQt(	342, 	"qteQTimer_setStartInterval"		));

	// ------- QTextOption -------
	mixin(generateFunQt(	291, 	"QTextOption_create"				));
	mixin(generateFunQt(	292, 	"QTextOption_delete"				));
	mixin(generateFunQt(	293, 	"QTextOption_setWrapMode"			));

	// ------- QFontMetrics -------
	mixin(generateFunQt(	295, 	"QFontMetrics_create"				));
	mixin(generateFunQt(	296, 	"QFontMetrics_delete"				));
	mixin(generateFunQt(	297, 	"QFontMetrics_getXX1"				));

	// ------- QImage -------
	mixin(generateFunQt(	303, 	"qteQImage_create1"					));
	mixin(generateFunQt(	304, 	"qteQImage_delete"					));
	mixin(generateFunQt(	305, 	"qteQImage_load"					));
	mixin(generateFunQt(	315, 	"qteQImage_create2"					));

	mixin(generateFunQt(	316, 	"qteQImage_fill1"					));
	mixin(generateFunQt(	317, 	"qteQImage_fill2"					));
	mixin(generateFunQt(	318, 	"qteQImage_setPixel1"				));
	mixin(generateFunQt(	319, 	"qteQImage_getXX1"					));
	mixin(generateFunQt(	321, 	"qteQImage_pixel"					));

	// ------- QPoint -------
	mixin(generateFunQt(	306, 	"qteQPoint_create1"					));
	mixin(generateFunQt(	307, 	"qteQPoint_delete"					));
	mixin(generateFunQt(	308, 	"qteQPoint_setXX1"					));
	mixin(generateFunQt(	309, 	"qteQPoint_getXX1"					));

	// ------- QGridLayout -------
	mixin(generateFunQt(	330, 	"qteQGridLayout_create1"			));
	mixin(generateFunQt(	331, 	"qteQGridLayout_delete"				));
	mixin(generateFunQt(	332, 	"qteQGridLayout_getXX1"				));
	mixin(generateFunQt(	333, 	"qteQGridLayout_addWidget1"			));
	mixin(generateFunQt(	334, 	"qteQGridLayout_addWidget2"			));
	mixin(generateFunQt(	335, 	"qteQGridLayout_setXX1"				));
	mixin(generateFunQt(	336, 	"qteQGridLayout_setXX2"				));
	mixin(generateFunQt(	337, 	"qteQGridLayout_addLayout1"			));

	// ------- QMouseEvent -------
	mixin(generateFunQt(	347, 	"qteQMouseEvent1"					));
	mixin(generateFunQt(	348, 	"qteQWidget_setMousePressEvent"		));
	mixin(generateFunQt(	349, 	"qteQWidget_setMouseReleaseEvent"	));
	mixin(generateFunQt(	350, 	"qteQMouse_button"					));

	// ------- QScriptEngine -------
	mixin(generateFunQt(	351, 	"QScriptEngine_create1"				));
	mixin(generateFunQt(	352, 	"QScriptEngine_delete1"				));
	mixin(generateFunQt(	353, 	"QScriptEngine_evaluate"			));
	mixin(generateFunQt(	358, 	"QScriptEngine_newQObject"			));
	mixin(generateFunQt(	359, 	"QScriptEngine_globalObject"		));
	mixin(generateFunQt(	361, 	"QScriptEngine_callFunDlang"		));
	mixin(generateFunQt(	362, 	"QScriptEngine_setFunDlang"			));

	// ------- QScriptValue -------
	mixin(generateFunQt(	354, 	"QScriptValue_create1"				));
	mixin(generateFunQt(	355, 	"QScriptValue_delete1"				));
	mixin(generateFunQt(	356, 	"QScriptValue_toInt32"				));
	mixin(generateFunQt(	357, 	"QScriptValue_toString"				));
	mixin(generateFunQt(	360, 	"QScriptValue_setProperty"			));

	mixin(generateFunQt(	365, 	"QScriptValue_createQstring"		));
	mixin(generateFunQt(	366, 	"QScriptValue_createInteger"		));
	mixin(generateFunQt(	367, 	"QScriptValue_createBool"			));

	// ------- QScriptContext -------
	mixin(generateFunQt(	363, 	"QScriptContext_argumentCount"		));
	mixin(generateFunQt(	364, 	"QScriptContext_argument"			));

	// ------- QPaintDevice -------
	mixin(generateFunQt(	379, 	"QPaintDevice_hw"					));
	mixin(generateFunQt(	380, 	"QPaintDevice_pa"					));

	mixin(generateFunQt(	381, 	"QObject_setObjectName"				));
	mixin(generateFunQt(	382, 	"QObject_objectName"				));
	mixin(generateFunQt(	383, 	"QObject_dumpObjectInfo"			));
	
	// ------- QPixmap -------
	mixin(generateFunQt(	384, 	"QPixmap_create1"					));
	mixin(generateFunQt(	385, 	"QPixmap_delete1"					));
	mixin(generateFunQt(	386, 	"QPixmap_create2"					));
	mixin(generateFunQt(	387, 	"QPixmap_create3"					));
	mixin(generateFunQt(	388, 	"QPixmap_load1"						));
	mixin(generateFunQt(	394, 	"QPixmap_fill"						));
	mixin(generateFunQt(	389, 	"qteQLabel_setPixmap"				));
	mixin(generateFunQt(	391, 	"qteQPainter_drawPixmap1"			));

	// ------- QBitmap -------
	mixin(generateFunQt(	392, 	"QBitmap_create1"					));
	mixin(generateFunQt(	395, 	"QBitmap_create2"					));
	mixin(generateFunQt(	390, 	"qteQPainter_create3"				));

	mixin(generateFunQt(	396, 	"qteQPen_create2"					));
	mixin(generateFunQt(	397, 	"QPixmap_setMask"					));

	// ------- QResource -------
	mixin(generateFunQt(	398, 	"QResource_create1"					));
	mixin(generateFunQt(	399, 	"QResource_delete1"					));
	mixin(generateFunQt(	400, 	"QResource_registerResource"		));
	mixin(generateFunQt(	401, 	"QResource_registerResource2"		));
	
	// ------- QStackedWidget -------
	mixin(generateFunQt(	402, 	"QStackedWidget_create1"			));
	mixin(generateFunQt(	403, 	"QStackedWidget_delete1"			));
	mixin(generateFunQt(	404, 	"QStackedWidget_setXX1"				));
	mixin(generateFunQt(	405, 	"QStackedWidget_setXX2"				));
	mixin(generateFunQt(	406, 	"QStackedWidget_setXX3"				));

	// ------- QTabBar -------
	mixin(generateFunQt(	407, 	"QTabBar_create1"					));
	mixin(generateFunQt(	408, 	"QTabBar_delete1"					));
	mixin(generateFunQt(	409, 	"QTabBar_setXX1"					));
	mixin(generateFunQt(	410, 	"QTabBar_addTab1"					));
	mixin(generateFunQt(	411, 	"QTabBar_tabTextX1"					));
	mixin(generateFunQt(	412, 	"QTabBar_tabBoolX1"					));
	mixin(generateFunQt(	413, 	"QTabBar_addTab2"					));
	mixin(generateFunQt(	414, 	"QTabBar_ElideMode"					));
	mixin(generateFunQt(	415, 	"QTabBar_iconSize"					));
	mixin(generateFunQt(	416, 	"QTabBar_addTab3"					));
	mixin(generateFunQt(	417, 	"QTabBar_moveTab1"					));
	mixin(generateFunQt(	418, 	"QTabBar_selectionBehaviorOnRemove"	));
	mixin(generateFunQt(	419, 	"QTabBar_set3"						));
	mixin(generateFunQt(	420, 	"QTabBar_setElideMode"				));
	mixin(generateFunQt(	421, 	"QTabBar_setIconSize"				));
	mixin(generateFunQt(	422, 	"QTabBar_setShape"					));
	mixin(generateFunQt(	423, 	"QTabBar_setTabEnabled"				));
	mixin(generateFunQt(	424, 	"QTabBar_setX5"						));
	
	mixin(generateFunQt(	425, 	"qteQColor_create3"					));
	
	// ------- QCoreApplication -------
	mixin(generateFunQt(	426, 	"QCoreApplication_create1"			));
	mixin(generateFunQt(	427, 	"QCoreApplication_delete1"			));
	// ------- QGuiApplication -------
	mixin(generateFunQt(	428, 	"qteQApplication_setX1"				));

	mixin(generateFunQt(	429, 	"QTabBar_setPoint"					));
	mixin(generateFunQt(	430, 	"QTabBar_tabPoint"					));

	// Последний = 418
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
	// .... Qt5/QtCore/qnamespace.h
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
	
}
// ================ QObject ================
/++
Базовый класс.  Хранит в себе ссылку на реальный объект в Qt C++
Base class. Stores in itself the link to real object in Qt C ++
+/

// Две этих переменных служат для поиска ошибок связанных с ошибочным
// уничтожением объектов C++
static int allCreate;
static int balCreate;
// Переменная для анализа распределения памяти
static int id;
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

	private QtObjH p_QObject; /// Адрес самого объекта из C++ Qt
	private bool  fNoDelete;  /// Если T - не вызывать деструктор
	private void* adrThis;    /// Адрес собственного экземпляра

	// int id;

	this() {
		// Для подсчета ссылок создания и удаления
		balCreate++;
		// allCreate++; id = allCreate;
		//if(balCreate < 10)
		//	 { printf("+[%d]-[%d]-[%p]->[%p] ", id, balCreate, this, fNoDelete, QtObj); writeln(this);  stdout.flush(); }

	} /// спец Конструктор, что бы не делать реальный объект из Qt при наследовании
	~this() {
		// Для подсчета ссылок создания и удаления
		balCreate--;
		// if(balCreate < 10)
		// 	{ printf("-[%d]-[%d]-[%p] %d ->[%p] ", id, balCreate, this, fNoDelete, QtObj); writeln(this);   stdout.flush(); }
		
		if(balCreate == 0) {
		 	//writeln("    delete app ... ", QtObj, "  ", this);  stdout.flush();
		 	(cast(t_v__qp) pFunQt[3])(saveAppPtrQt); // setQtObj(null);
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

	void setQtObj(QtObjH adr) { //->
		p_QObject = adr; } /// Заменить указатель в объекте на новый указатель

	@property QtObjH QtObj() { //->
		return p_QObject;
	} /// Выдать указатель на реальный объект Qt C++
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
	QObject disconnects(QObject obj1, string ssignal, QObject obj2, string sslot) { //->
		(cast(t_QObject_disconnect) pFunQt[343])(
			(cast(QObject)obj1).QtObj, MSS(ssignal, QSIGNAL),
			(cast(QObject)obj2).QtObj, MSS(sslot, QSLOT));
		return this;
	}
	/// Запомнить указатель на собственный экземпляр
	void saveThis(void* adr) { //-> Запомнить указатель на собственный экземпляр
		adrThis = adr;
	}
	@property void* aThis() { //-> Выдать указатель на p_QObject
		return &adrThis;
	} /// Выдать указатель на p_QObject
	void* parentQtObj() { //-> выдать указатель на собственного родителя в Qt
		return (cast(t_qp__qp)pFunQt[344])(QtObj);
	}
	void setObjectName(T)(T name) { //-> Задать имя объекту
		wstring ps = to!wstring(name);
		(cast(t_v__qp_qp) pFunQt[381])(QtObj, (cast(t_qp__qp_i)pFunQt[9])(cast(QtObjH)ps.ptr, cast(int)ps.length));
	}
	T objectName(T)() { //-> Получить имя объекта
		QString qs = new QString();	(cast(t_qp__qp_qp)pFunQt[382])(QtObj, qs.QtObj);
		return cast(T)qs.String();
	}
	void dumpObjectInfo() {
		(cast(t_qp__qp_i)pFunQt[383])(QtObj, 0);
	}
	void dumpObjectTree() {
		(cast(t_qp__qp_i)pFunQt[383])(QtObj, 1);
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

	this() {
		setQtObj((cast(t_qp__v) pFunQt[16])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[17])(QtObj); setQtObj(null); }
	} /// Деструктор
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

// ================ QColor ================
/++
QColor - Цвет
+/
class QColor : QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[13])());
	} /// Конструктор
	this(uint color) {
		setQtObj((cast(t_qp__ui) pFunQt[324])(color));
	}
	this(QtE.GlobalColor color) {
		setQtObj((cast(t_qp__ui) pFunQt[425])(color));
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[14])(QtObj); setQtObj(null); }
	} /// Деструктор
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

	this() {
		setQtObj((cast(t_qp__v) pFunQt[177])());
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[178])(QtObj); setQtObj(null); }
	} /// Деструктор
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
	funQt(177, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_create1",				showError);
	funQt(178, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_delete",				showError);
	funQt(179, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQBrush_setColor",				showError);
 */



// ================ QPaintDevice ================
class QPaintDevice: QObject  {
	int typePD;  // 0=QWidget, 1=QImage
	this(){
		// writeln("qpd+", this);
	}
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
	~this() {
		(cast(t_v__qp) pFunQt[7])(QtObj); setQtObj(null);
		writeln("--Удалила QWidget");
	}
	this(int ptr) {
	}
	this(sQWidget* parent, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			// setNoDelete(true);
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(null, cast(int)fl));
		}
	}
	void init(sQWidget* parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			// setNoDelete(true);
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
//	this(){}
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			// printf("+[%d]-[%d]-QW ", id, balCreate); stdout.flush();
			(cast(t_v__qp) pFunQt[7])(QtObj); setQtObj(null);
			// printf("-[%d]-[%d]-QW ", id, balCreate); stdout.flush();
		}
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		typePD = 0;
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[5])(null, cast(int)fl));
		}
	} /// QWidget::QWidget(QWidget * parent = 0, Qt::WindowFlags f = 0)
	bool isVisible() { //->
		return (cast(t_bool__vp)pFunQt[12])(QtObj);
	} /// QWidget::isVisible();
	QWidget setVisible(bool f) { //-> 					// Скрыть, Показать виджет
		(cast(t_v__qp_bool)pFunQt[6])(QtObj, f); return this;
	} /// On/Off - это реальный setVisible from QtWidget.dll
	//QWidget show() { setVisible(true); return this; } /// Показать виджет
	//QWidget hide() { setVisible(false); return this; } /// Скрыть виджет
	QWidget setWindowTitle(QString qstr) {  //-> // Установить заголовок окна
		(cast(t_v__qp_qp) pFunQt[11])(QtObj, qstr.QtObj); return this;
	} /// Установить заголовок окна
	QWidget setWindowTitle(T)(T str) { //->
		// Было: return setWindowTitle(new QString(to!string(str)));
		// Однако, при таком вызове остается висеть в памяти D объект и C++ QString,
		// по этому, здесь, я явно удаляю этот объект из памяти и также удаляется C++ QString
		// -- QString qs = new QString(to!string(str)); setWindowTitle(qs);  delete qs;  return this;
		(cast(t_v__qp_qp) pFunQt[11])(QtObj, sQString(to!string(str)).QtObj); return this;
		// sQString sqs = sQString(to!string(str)); (cast(t_v__qp_qp) pFunQt[11])(QtObj, sqs.QtObj); return this;
	} /// Установить текст Заголовка
	QWidget setStyleSheet(QString str) { //->
		(cast(t_v__qp_qp)pFunQt[30])(QtObj, str.QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setStyleSheet(T)(T str) { //->
		(cast(t_v__qp_qp)pFunQt[30])(QtObj, sQString(to!string(str)).QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setToolTip(QString str) { //->
		(cast(t_v__qp_qp)pFunQt[33])(QtObj, str.QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setToolTip(T)(T str) { //->
		(cast(t_v__qp_qp)pFunQt[33])(QtObj, sQString(to!string(str)).QtObj); return this;
	} /// При помощи строки задать описание эл. Цвет и т.д.
	QWidget setMinimumSize(int w, int h) { //->
		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, true, w, h); return this;
	} /// Минимальный размер в лайоутах
	QWidget setMaximumSize(int w, int h) { //->
		(cast(t_v__qp_b_i_i) pFunQt[31])(QtObj, false, w, h); return this;
	} /// Максимальный размер в лайоутах
	QWidget setEnabled(bool fl) { //->
		(cast(t_v__qp_bool) pFunQt[32])(QtObj, fl); return this;
	} /// Доступен или нет
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
		//(cast(t_v__qp_qp_qp) pFunQt[80])(QtObj, cast(QtObjH)adr, cast(QtObjH)adrThis);
		return this;
		// (cast(t_v__qp_qp) pFunQt[49])(QtObj, cast(QtObjH)adr); return this;
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


	QWidget setSizePolicy(int w, int h) { //->
		(cast(t_v__qp_i_i) pFunQt[78])(QtObj, w, h); return this;
	} /// Установить обработчик на событие CloseEvent. Здесь <u>adr</u> - адрес на функцию D +/
	QWidget setMaximumWidth(int w) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 0, w); return this;
	} /// setMaximumWidth();
	QWidget setMinimumWidth(int w) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 1, w); return this;
	} /// setMinimumWidth();
	QWidget setFixedWidth(int w) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 5, w); return this;
	} /// setFixedWidth();
	QWidget setMaximumHeight(int h) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 2, h); return this;
	} /// setMaximumHeight();
	QWidget setMinimumHeight(int h) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 3, h); return this;
	} /// setMinimumHeight();
	QWidget setFixedHeight(int h) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 4, h); return this;
	} /// setFixedHeight();
	QWidget setToolTipDuration(int msek) { //->
		(cast(t_v__qp_i_i) pFunQt[79])(QtObj, 6, msek); return this;
	} /// Время показа в МилиСекундах
	QWidget setFocus() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 0); return this; } /// Установить фокус
	QWidget close()    {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 1); return this; } /// Закрыть окно
	QWidget hide() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 2); return this; 	}
	QWidget show() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 3); return this; 	}
	QWidget showFullScreen()  {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 4); return this; 	}
	QWidget showMaximized() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 5); return this; 	}
	QWidget showMinimized() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 6); return this; 	}
	QWidget showNormal() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 7); return this; } ///
	QWidget update() { 	 //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 8); return this;  } ///
	QWidget raise() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 9); return this; 	} /// Показать окно на вершине
	QWidget lower() {  //->
		(cast(t_v__qp_i) pFunQt[87])(QtObj, 10); return this; 	} /// Скрыть в стеке

	QWidget move(int x, int y) { //->
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 0, x, y); return this;
	} /// This property holds the size of the widget excluding any window frame
	QWidget resize(int w, int h) { //->
		(cast(t_v__qp_i_i_i) pFunQt[94])(QtObj, 1, w, h); return this;
	} /// This property holds the size of the widget excluding any window frame
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
	bool hasFocus() { //-> Виджет имеет фокус
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 0);
	}
	bool acceptDrops() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 1);
	}
	bool autoFillBackground() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 2);
	}
	bool hasMouseTracking() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 3);
	}
	bool isActiveWindow() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 4);
	}
	bool isEnabled() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 5);
	}
	bool isFullScreen() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 6);
	}
	bool isHidden() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 7);
	}
	bool isMaximized() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 8);
	}
	bool isMinimized() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 9);
	}
	bool isModal() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 10);
	}
	bool isWindow() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 11);
	}
	bool isWindowModified() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 12);
	}
	bool underMouse() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 13);
	}
	bool updatesEnabled() { //->
		return (cast(t_b__qp_i) pFunQt[259])(QtObj, 14);
	}
	QWidget setGeometry(int x, int y, int w, int h) { //-> Установить геометрию виджета
		(cast(t_v__qp_i_i_i_i) pFunQt[279])(QtObj, x, y, w, h); return this;
	}
	QRect contentsRect(QRect tk) { //-> Вернуть QRect дочерней области
		(cast(t_v__qp_qp) pFunQt[280])(QtObj, tk.QtObj);	return tk;
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
	QAbstractButton setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[28])(QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на кнопке
	T text(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[29])(QtObj, qs.QtObj);
		return qs;
	}
	T text(T)() { return to!T(text!QString().String);
	}
	QAbstractButton setAutoExclusive(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 0); return this;
	} ///
	QAbstractButton setAutoRepeat(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 1); return this;
	} ///
	QAbstractButton setCheckable(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 2); return this;
	} ///
	QAbstractButton setDown(bool pr) { //->
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 3); return this;
	} ///
	QAbstractButton setChecked(bool pr) { //-> Включить кнопку
		(cast(t_v__qp_b_i) pFunQt[209])(QtObj, pr, 4); return this;
	} ///
	QAbstractButton setIcon(QIcon ik) { //->
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
			setNoDelete(true);
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
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(parent.QtObj, sQString(to!string(str)).QtObj ));
		} else {
			setQtObj((cast(t_qp__qp_qp) pFunQt[22])(null, sQString(to!string(str)).QtObj ));
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
// ================ QEndApplication ================
// Идея: D уничтожает объеты в порядке FIFO, а Qt в порядке LIFO и к тому же
// Qt имеетт каскадное удаление объектов типа QWidget.
// В связи с этим, все каскадные объекты (дети) получают признак setNoDelete(true); в QtE5.
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
		writeln("--Удалила adrCppObj");
	}
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		writeln("--Создала adrCppObj");
	}
	void init(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		writeln("--Инициализировала adrCppObj");
	}
	int exec() { //-> Выполнить
		return (cast(t_i__qp) pFunQt[1])(QtObj);
	}
	void aboutQt() { //-> Об Qt
		(cast(t_v__qp) pFunQt[2])(QtObj);
		writeln("--Выполнила adrCppObj.AboutQt");
	}

}
// ================ QCoreApplication ================
class QCoreApplication : QObject {
	this() {}
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[426])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		saveAppPtrQt = QtObj;
	}
	~this() {
		if(!fNoDelete) {
			(cast(t_v__qp) pFunQt[427])(QtObj); setQtObj(null);
		}
	}
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
	int exec() { //-> Выполнить
		return (cast(t_i__qp) pFunQt[1])(QtObj);
	} /// QApplication::exec()
	void processEvents() { //-> Передать цикл выполнения в ОС
		(cast(t_v__qp)pFunQt[368])(QtObj);
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
	this(int* m_argc, char** m_argv, int gui) {
		setQtObj((cast(t_qp__qp_qp_i) pFunQt[0])(cast(QtObjH)m_argc, cast(QtObjH)m_argv, gui));
		saveAppPtrQt = QtObj;
		setNoDelete(true);
	} /// QApplication::QApplication(argc, argv, param);
	~this() {
		if(!fNoDelete) {
			(cast(t_v__qp) pFunQt[3])(QtObj); setQtObj(null);
		}
	} ///  QApplication::~QApplication();
	void aboutQt() { //-> Об Qt
		(cast(t_v__qp) pFunQt[2])(QtObj);
	} /// QApplication::aboutQt()
	void aboutQtE5() { //->
				msgbox(
"
<H2>QtE5 - is a D wrapper for Qt-5</H2>
<H3>" ~ format("MGW 2016 ver %s.%s -- %s", verQt5Eu, verQt5El, verQt5Ed) ~ "</H3>
<a href='https://github.com/MGWL/QtE5'>https://github.com/MGWL/QtE5</a>
<BR>
<a href='http://mgw.narod.ru/about.htm'>http://mgw.narod.ru/about.htm</a>
<BR>
<BR>
<IMG src='ICONS/qte5.png'>
<BR>
", "About QtE5");
	}
	void quit() { //-> Выход
		(cast(t_v__qp) pFunQt[273])(QtObj);
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
	~this() {
		(cast(t_v__qp) pFunQt[10])(QtObj); setQtObj(null);
	}
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
	this() {
		setQtObj((cast(t_qp__v)pFunQt[8])());
	} /// Конструктор пустого QString
	this(T)(T s) {
		setQtObj(f_9(to!wstring(s)));
	} /// Конструктор где s - Utf-8. Пример: QString qs = new QString("Привет!");
	this(QtObjH adr) { setQtObj(adr);
	} /// Изготовить QString из пришедшего из вне указателя на C++ QString
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr); fNoDelete = true;
	}
	~this() {
		if(!fNoDelete) {
			(cast(t_v__qp) pFunQt[10])(QtObj); setQtObj(null);
		}
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

	struct z2 {	int a, b;	}

// ================ QGridLayout ================
class QGridLayout : QObject {
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[330])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[330])(null));
		}
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[331])(QtObj); setQtObj(null); }
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
}
// ================ QBoxLayout ================
/++
QBoxLayout - это класс выравнивателей. Они управляют размещением
элементов на форме.
+/
class QBoxLayout : QObject {
	enum Direction { //->
		LeftToRight = 0,
		RightToLeft = 1,
		TopToBottom = 2,
		BottomToTop = 3
	} /// enum Direction { LeftToRight, RightToLeft, TopToBottom, BottomToTop }
//	this() { }
//	this(QWidget parent, QBoxLayout.Direction dir = QBoxLayout.Direction.TopToBottom) {
       this(QWidget parent = null, QBoxLayout.Direction dir = QBoxLayout.Direction.TopToBottom) {
		// super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[34])(parent.QtObj, dir));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[34])(null, dir));
		}
	} /// Создаёт выравниватель, типа dir и вставляет в parent
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[37])(QtObj); setQtObj(null); }
	}
	QBoxLayout addWidget(QWidget wd, int stretch = 0, QtE.AlignmentFlag alignment = QtE.AlignmentFlag.AlignExpanding) { //-> Добавить виджет
                wd.setNoDelete(true);
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
	QBoxLayout setSpacing(int spacing) { //-> расстояние между элементами в выравнивателе, например расстояние меж кнопками
		(cast(t_v__qp_i) pFunQt[74])(QtObj, spacing); return this;
	} /// Это расстояние между элементами в выравнивателе, например расстояние меж кнопками
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
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[35])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[35])(null));
		}
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[37])(QtObj); setQtObj(null); }
	}
}
class QHBoxLayout : QBoxLayout {
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[36])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[36])(null));
		}
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[37])(QtObj); setQtObj(null); }
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
//	this() {	}
	~this() {
		// printf("in ~QFrame -1- \n"); stdout.flush();
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[42])(QtObj); setQtObj(null); }
		// printf("in ~QFrame -2- \n"); stdout.flush();
	}
//	this(QWidget parent, QtE.WindowType fl = QtE.WindowType.Widget) {
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent !is null) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[41])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[41])(null, fl));
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
	QFrame setLineWidth(int sh) { //->
		if (sh > 3) sh = 3; (cast(t_v__qp_i) pFunQt[45])(QtObj, sh);
		return this;
	} /// Установить толщину окантовки в пикселах от 0 до 3
	QFrame listChildren() { //->
		(cast(t_v__qp) pFunQt[290])(QtObj);
		return this;
	}
}
// ============ QLabel =======================================
class QLabel : QFrame {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[47])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[46])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[46])(null, fl));
		}
	} /// Конструктор
	QWidget setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QWidget setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[48])(QtObj, sQString(to!string(str)).QtObj);
		return this;
	} /// Установить текст на кнопке
	QWidget setPixmap(QPixmap pm) { //-> Отобразить изображение на QLabel
		(cast(t_v__qp_qp) pFunQt[389])(QtObj, pm.QtObj);
		return this;
	} /// Установить текст на кнопке
}
// ============ QSize =======================================
class QSize : QObject {
	this(int width, int height) {
		setQtObj((cast(t_qp__i_i) pFunQt[56])(width, height));
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// При создании своего объекта сохраняет в себе объект событие QEvent пришедшее из Qt
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[57])(QtObj); setQtObj(null); }
	}
	@property int width() { //->
		return (cast(t_i__qp) pFunQt[58])(QtObj);
	} /// QSize::wieth();
	@property int height() { //->
		return (cast(t_i__qp) pFunQt[59])(QtObj);
	} /// QSize::height();
	QSize setWidth(int width) { //->
		(cast(t_v__qp_i) pFunQt[60])(QtObj, width); return this;
	} /// QSize::setWidth();
	QSize setHeight(int height) { //->
		(cast(t_v__qp_i) pFunQt[61])(QtObj, width); return this;
	} /// QSize::setHeight();
}
// ============ QPainter =======================================
class QPainter : QObject {
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[302])(QtObj); setQtObj(null); }
	}
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
	this() {}
	~this() {
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
	this(){}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[67])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[66])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[66])(null));
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
		if(parent) {
			setNoDelete(true);
			p_QObject = (cast(t_qp__qp) pFunQt[82])(parent.QtObj);
		} else {
			p_QObject = (cast(t_qp__qp) pFunQt[82])(null);
		}
	} /// Создать LineEdit.
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[83])(QtObj); setQtObj(null); }
	}
	QLineEdit setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, str.QtObj);
		return this;
	} /// Установить текст на кнопке
	QLineEdit setText(T)(T str) { //->
		(cast(t_v__qp_qp) pFunQt[84])(QtObj, sQString(str).QtObj);
		return this;
	} /// Установить текст на кнопке
	QLineEdit clear() { //->
		(cast(t_v__qp) pFunQt[85])(QtObj);
		return this;
	} /// Очистить строку
	@property T text(T: QString)() { //->
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[86])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	@property T text(T)() {  //->
		return to!T(text!QString().String);
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
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i)pFunQt[88])(parent.QtObj, cast(int)fl));
		} else {
			setQtObj((cast(t_qp__qp_i)pFunQt[88])(null, cast(int)fl));
		}
	} /// QMainWindow::QMainWindow(QWidget * parent = 0, Qt::WindowFlags f = 0)
	QMainWindow setCentralWidget(QWidget wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 0);
		return this;
	} ///
	QMainWindow setStatusBar(QStatusBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 2);
		 return this;
	} ///
	QMainWindow setMenuBar(QMenuBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 1);
		 return this;
	} ///
	QMainWindow addToolBar(QToolBar wd) { //->
		(cast(t_v__qp_qp_i) pFunQt[90])(QtObj, wd.QtObj, 3);
		 return this;
	} ///
	QMainWindow setToolBar(QToolBar wd) { //->
		addToolBar(wd);
		return this;
	} ///
	QMainWindow addToolBar(QToolBar.ToolBarArea st, QToolBar wd) { //->
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
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[92])(QtObj); setQtObj(null);
		}
	}
	this(QWidget parent) {
		// super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[91])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[91])(null));
		}
	} /// QStatusBar::QStatusBar(QWidget * parent)
	QStatusBar showMessage(T: QString)(T str, int timeout = 0) { //->
		(cast(t_v__qp_qp_i) pFunQt[93])(QtObj, str.QtObj, timeout);
		return this;
	} /// Установить текст на кнопке
	QStatusBar showMessage(T)(T str, int timeout = 0) { //->
		showMessage!QString(new QString(to!string(str)), timeout);
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
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[95])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[95])(null));
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
		QIcon ico = new QIcon(); ico.addFile(fileIco); setIcon(ico);
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
	QAction Signal_VS(T: QString)(T str) { //-> Послать сигнал с QAction "Signal_V(int)"
		(cast(t_v__qp_qp) pFunQt[341])(QtObj, str.QtObj);
		return this;
	}
	QAction Signal_VS(T)(T str) { //-> Послать сигнал с QAction "Signal_V(int)"
		(cast(t_v__qp_qp) pFunQt[341])(QtObj, sQString(str).QtObj);
		return this;
	}
}
// ============ QMenu =======================================
/++
QMenu - колонка меню. Вертикальная.
+/
class QMenu : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[100])(QtObj); setQtObj(null);
		}
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[99])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[99])(null));
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
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[103])(QtObj);	setQtObj(null);
		}
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[102])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[102])(null));
		}
	} /// QMenuBar::QMenuBar(QWidget* parent)
 	QMenuBar addMenu(QMenu mn) { //->
		(cast(t_v__qp_qp) pFunQt[104])(QtObj, mn.QtObj);
		return this;
	} /// Вставить вертикальное меню
}
// ================ QFont ================
class QFont : QObject {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[128])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[127])());
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
		setFamily((new QString(to!string(str))));
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[111])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[110])());
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

	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[115])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[114])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[114])(null));
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
//	this() {}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[118])(QtObj); setQtObj(null); }
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) { //->
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[117])(parent.QtObj, fl));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[117])(null, fl));
		}
	} /// Конструктор
	int exec() { //->
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
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[121])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[120])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[120])(null));
		}
	} /// Конструктор
	QMessageBox setText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 0);
		return this;
	} /// Установить текст
	QMessageBox setText(T)(T str) { //->
		QMessageBox.setText(new QString(to!string(str)));
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 1);
		return this;
	} /// Установить текст
	QMessageBox setWindowTitle(T)(T str) { //->
		QMessageBox.setWindowTitle(new QString(to!string(str)));
		return this;
	} /// Установить текст
	QMessageBox setInformativeText(T: QString)(T str) { //->
		(cast(t_v__qp_qp_i) pFunQt[122])(QtObj, str.QtObj, 2);
		return this;
	} /// Установить текст
	QMessageBox setInformativeText(T)(T str) { //->
		QMessageBox.setInformativeText(new QString(to!string(str)));
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
}

// ================ QProgressBar ================
/++
QProgressBar - это ....
+/
class QProgressBar : QWidget {
	this() {}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[134])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[133])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[133])(null));
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[137])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[136])());
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[139])(QtObj); setQtObj(null); }
	}
	this() {
		setQtObj((cast(t_qp__v)pFunQt[138])());
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

	this() {}
	~this() {
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
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Установить фильтр для выбираемых файлов
	QFileDialog selectFile(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 1);
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog selectFile(T1)(T1 shabl) { //->
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Выбрать строго конкретное имя файла
	QFileDialog setDirectory(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 2);
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDirectory(T1)(T1 shabl) { //->
		setNameFilter(new QString(to!string(shabl)));
		return this;
	} /// Открыть конкретный каталог
	QFileDialog setDefaultSuffix(QString shabl) { //->
		(cast(t_v__qp_qp_i)pFunQt[144])(QtObj, shabl.QtObj, 3);
		return this;
	} /// "txt" - добавит эту строку к имени файла, если нет расширения
	QFileDialog setDefaultSuffix(T1)(T1 shabl) { //->
		setNameFilter(new QString(to!string(shabl)));
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[152])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[151])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[151])(null));
		}
	} /// Конструктор
	void* addSubWindow(QWidget wd, QtE.WindowType fl = QtE.WindowType.Widget) { //->
		return (cast(t_qp__qp_qp_i)pFunQt[155])(QtObj, wd.QtObj, cast(int)fl);
	}
	void* activeSubWindow() { //-> Указатель на активное в данный момент окно
		return (cast(t_qp__qp)pFunQt[338])(QtObj);
	}
}
// ================ QMdiSubWindow ================
class QMdiSubWindow : QWidget {
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[154])(QtObj); setQtObj(null); }
	}
	this(QWidget parent = null, QtE.WindowType fl = QtE.WindowType.Widget) {
		if (parent) {
			setNoDelete(true);
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
	this(){}
	~this() {
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

//	funQt(182, bQtE5Widgets, hQtE5Widgets, sQtE5Widgets, "qteQTableView_ResizeMode",		showError);

}
// ============ QTableWidget ==================
class QTableWidget : QTableView {
	this(){}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[162])(QtObj); setQtObj(null); }
	}
	// this() { super(); }
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
	~this() {
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
	this() {}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[184])(QtObj); setQtObj(null); }
	}
	this(QWidget parent) {
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[183])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[183])(null));
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
	this() {
		setQtObj((cast(t_qp__v) pFunQt[191])());
	} /// Конструктор
	this(QColor color) {
		setQtObj((cast(t_qp__qp) pFunQt[396])(color.QtObj));
	} /// Конструктор
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[192])(QtObj); setQtObj(null); }
	} /// Деструктор
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[199])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[198])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[198])(null));
		}
	} /// Конструктор
	this(int kolNumber, QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp_i) pFunQt[200])(parent.QtObj, kolNumber));
		} else {
			setQtObj((cast(t_qp__qp_i) pFunQt[200])(null, kolNumber));
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[207])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent = null, QtE.Orientation n = QtE.Orientation.Horizontal) {
		super();
		if (parent) {
			setNoDelete(true);
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
			setNoDelete(true);
			setQtObj((cast(t_qp__qp)pFunQt[212])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp)pFunQt[212])(null));
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
	this(){}
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
    ~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[217])(QtObj); setQtObj(null); }
		// write("B- "); stdout.flush();
    }
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
	this(){}
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
    ~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[223])(QtObj); setQtObj(null); }
		// write("B- "); stdout.flush();
    }
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

	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[228])(QtObj); setQtObj(null); }
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[233])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this() {
		setQtObj((cast(t_qp__v)pFunQt[232])());
	}
	int x() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 0);
	}
	int y() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 1);
	}
	int width() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 2);
	}
	int height() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 3);
	}
	int left() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 4);
	}
	int right() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 5);
	}
	int top() { //->
		return (cast(t_i__qp_i) pFunQt[234])(QtObj, 6);
	}
	int bottom() { //->
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
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[239])(QtObj); setQtObj(null); }
	}
	T text(T: QString)() { //-> Содержимое блока в QString
		QString qs = new QString(); (cast(t_v__qp_qp)pFunQt[237])(QtObj, qs.QtObj); return qs;
	} /// Выдать содержимое в QString
	T text(T)() { return to!T(text!QString().String);
	} /// Выдать всё содержимое в String
	int blockNumber() { //->
		return (cast(t_i__qp)pFunQt[283])(QtObj);
	}
	void next(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 0);
	}
	void previous(QTextBlock tb) { //->
		(cast(t_v__qp_qp_i)pFunQt[299])(QtObj, tb.QtObj, 1);
	}
	bool isValid() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 0);
	}
	bool isVisible() { //->
		return (cast(t_b__qp_i)pFunQt[300])(QtObj, 1);
	}

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
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[248])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(QWidget parent) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[247])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[247])(null));
		}
	} /// Конструктор
	QSpinBox selectAll() { //-> Выбрать всё
		(cast(t_v__qp_i_i) pFunQt[249])(QtObj, 0, 4); return this;
	}
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
	int value() { //-> Получить значение
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
	~this() {
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

// ================ QTextEdit ================
/++
Продвинутый редактор
+/
class QTextEdit : QAbstractScrollArea {
	this(){}
	~this() {
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

	this(){}
	this(QObject parent) {
		setQtObj((cast(t_qp__qp)pFunQt[262])(parent.QtObj));
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[263])(QtObj); setQtObj(null); }
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

	this() {
		setQtObj((cast(t_qp__v)pFunQt[291])());
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[292])(QtObj); setQtObj(null); }
	}
	QTextOption setWrapMode(QTextOption.WrapMode wrap) { //-> Перенос текста в редакторах
		(cast(t_v__qp_qp) pFunQt[293])(QtObj, cast(QtObjH)wrap);
		return this;
	}


}

// ================ QFontMetrics ================
class QFontMetrics : QObject {

	this(QFont fn) {
		setQtObj((cast(t_qp__qp)pFunQt[295])(fn.QtObj));
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[296])(QtObj); setQtObj(null); }
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[304])(QtObj); setQtObj(null); }
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[307])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	} /// Конструктор
	this(int x, int y) {
		setQtObj((cast(t_qp__i_i)pFunQt[306])(x, y));
	}
	QPoint setX(int x) {
		(cast(t_v__qp_i_i)pFunQt[308])(QtObj, x, 0); return this;
	}
	QPoint setY(int y) {
		(cast(t_v__qp_i_i)pFunQt[308])(QtObj, y, 1); return this;
	}
	@property int x() { //->
		return (cast(t_i__qp_i)pFunQt[309])(QtObj, 0);
	}
	@property int y() { //->
		return (cast(t_i__qp_i)pFunQt[309])(QtObj, 1);
	}
	@property int x(int x) { //->
		(cast(t_v__qp_i_i)pFunQt[308])(QtObj, x, 0); return x;
	}
	@property int y(int y) { //->
		(cast(t_v__qp_i_i)pFunQt[308])(QtObj, y, 1); return y;
	}

}

// ================ QScriptEngine ================
class QScriptEngine : QObject {
	this(){}
	~this() {
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
	this(){}
	~this() {
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

	import qte5;

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
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[385])(QtObj); setQtObj(null);
		}
	}
	this() {
		typePD = 2;
		setQtObj((cast(t_qp__v) pFunQt[384])());
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
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[393])(QtObj); setQtObj(null);
		}
	}
}

// ================ QResource ================
class QResource: QObject {
	this() {
		setQtObj((cast(t_qp__v) pFunQt[398])());
	}
	~this() {
		if(!fNoDelete && (QtObj != null)) {
			(cast(t_v__qp) pFunQt[399])(QtObj); setQtObj(null);
		}
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
	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[403])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[402])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[402])(null));
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

	~this() {
		if(!fNoDelete && (QtObj != null)) { (cast(t_v__qp) pFunQt[408])(QtObj); setQtObj(null); }
	}
	this(char ch, void* adr) {
		if(ch == '+') setQtObj(cast(QtObjH)adr);
	}
	this(QWidget parent = null) {
		super();
		if (parent) {
			setNoDelete(true);
			setQtObj((cast(t_qp__qp) pFunQt[407])(parent.QtObj));
		} else {
			setQtObj((cast(t_qp__qp) pFunQt[407])(null));
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
		return (cast(t_i__qp_qp) pFunQt[410])(QtObj, sQString(str).QtObj);
	}
	int addTab(T0: QIcon, T: QString)(T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp) pFunQt[413])(QtObj, str.QtObj, icon.QtObj);
	}
	int addTab(T0: QIcon, T)(T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp) pFunQt[413])(QtObj, (new QString(to!string(str))).QtObj, icon.QtObj);
	}
	int insertTab(T: QString)(int index, T str) { //->
		return (cast(t_i__qp_qp_qp_i_i) pFunQt[416])(QtObj, str.QtObj, null, index, 0);
	}
	int insertTab(T)(int index, T str) { //->
		return insertTab(index, (new QString(to!string(str))));
	}
	int insertTab(T0: QIcon, T: QString)(int index, T0 icon, T str) { //->
		return (cast(t_i__qp_qp_qp_i_i) pFunQt[416])(QtObj, str.QtObj, icon.QtObj, index, 1);
	}
	int insertTab(T0: QIcon, T)(int index, T0 icon, T str) { //->
		return insertTab(index, icon, (new QString(to!string(str))));
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
		return setTabText(index, (new QString(to!string(text))));
	}
	QTabBar setTabTextColor(int index, QColor color) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, color.QtObj, index, 2); return this;
	}
	QTabBar setTabToolTip(T: QString)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, text.QtObj, index, 3); return this;
	}
	QTabBar setTabToolTip(T: string)(int index, T text) {
		return setTabToolTip(index, (new QString(to!string(text))));
	}
	QTabBar setTabWhatsThis(T: QString)(int index, T text) {
		(cast(t_v__qp_qp_i_i) pFunQt[424])(QtObj, text.QtObj, index, 4); return this;
	}
	QTabBar setTabWhatsThis(T: string)(int index, T text) {
		return setTabWhatsThis(index, (new QString(to!string(text))));
	}
	QTabBar setTabData(int index, void* uk) {
		(cast(t_v__qp_qp_i) pFunQt[429])(QtObj, cast(QtObjH)uk, index);	return this;
	}
	void* tabData(int index) {
		return cast(void*)((cast(t_qp__qp_i) pFunQt[430])(QtObj, index));
	}
	

}

__EOF__




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
