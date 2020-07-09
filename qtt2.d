import core.sys.windows.windows;
import core.sys.windows.winbase; 
import core.sys.windows.dll;
import std.stdio;
import tcltk.tcl;
// import asc1251;
import std.conv;
import std.net.curl;		// http и https запросы
import std.json;			// Работа с json
import std.string;
import arsd.http2;
import qte5, core.runtime;

// Windows
// dmd qtt.d -shared -m32 -ofqtt.dll qte5.d tcltk/tcl.d tcltk/tcldecls.d tcltk/tclplatdecls.d arsd/http2.d -release -O -version=without_openssl -version=actTcl || winTcl
// Linux
// dmd qtt.d -shared tcltk/tcl.d tcltk/tcldecls.d tcltk/tclplatdecls.d arsd/http2.d -version=without_openssl -release -O -ofqtt.so

// _________________________________________________________________________________
// Отправить POST запрос json по адресу, ожидать ответ ... (синхронная)
string post_arsd(string sUrl, string sData) {
	auto client = new HttpClient(); 
	auto request = client.request(Uri(sUrl), HttpVerb.POST, cast(ubyte[])sData, "json" );
	request.send();
	auto response = request.waitForCompletion();
    return response.contentText;
}

version (Windows) {
	__gshared HINSTANCE g_hInst;
	extern (Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)  {
		switch (ulReason)
		{
		case DLL_PROCESS_ATTACH:
			g_hInst = hInstance;
			// MessageBoxA(null, "++Star process. On GC".ptr, "Warning!!!".ptr, MB_OK);
			dll_process_attach( hInstance, true );
			break;
		case DLL_PROCESS_DETACH:
			// MessageBoxA(null, "--Stop process. Off GC".ptr, "Warning!!!".ptr, MB_OK);
			dll_process_detach( hInstance, true );
			break;
		case DLL_THREAD_ATTACH:
			// MessageBoxA(null, "+star thred.".ptr, "Warning!!!".ptr, MB_OK);
			dll_thread_attach( true, true );
			break;
		case DLL_THREAD_DETACH:
			// MessageBoxA(null, "-stop thred.".ptr, "Warning!!!".ptr, MB_OK);
			dll_thread_detach( true, true );
			break;
			default:
		}
		return true;
	}
}

// Помнит и обрабатывает состояния ...

string compactJson(string s) { return parseJSON(s).toString(); }

int chToNum(char ch) {
	int rez;
	if(ch == 'a' || ch == 'A') { rez = 0; goto d1; }
	if(ch == 'b' || ch == 'B') { rez = 1; goto d1; }
	if(ch == 'c' || ch == 'C') { rez = 2; goto d1; }
	if(ch == 'd' || ch == 'D') { rez = 3; goto d1; }
	if(ch == 'e' || ch == 'E') { rez = 4; goto d1; }
	if(ch == 'f' || ch == 'F') { rez = 5; goto d1; }
	if(ch == 'g' || ch == 'G') { rez = 6; goto d1; }
	if(ch == 'h' || ch == 'H') { rez = 7; goto d1; }
d1:	return rez;
}

class CTest {
	// _________________________________________________________________________________
	// Проверяемая команда
	string ver_CommandJson;
	// _________________________________________________________________________________
	// Проверяемая строка Json
	string str_CmdJson;
	// _________________________________________________________________________________
	// Проверяемая строка Json
	string[8] str_Session;
	// _________________________________________________________________________________
	// Нужен набор шаблонов Json  для хранения
	string[8] masShablJson;
	// _________________________________________________________________________________
	// Набор массивов
	string[8] arrayStr;
	// _________________________________________________________________________________
	// Сырой возвращаемый ответ Json
	char[] rawReqJson;
	// _________________________________________________________________________________
	// Адресс сервера
	string strUrl;
	// ----------------------

	// _________________________________________________________________________________
	// Записать проверяемую команду Json
	void set_strUrl(string sJson) { strUrl = sJson; }
	// _________________________________________________________________________________
	// Прочитать проверяемую команду Json
	string get_strUrl() { return strUrl; }
	// _________________________________________________________________________________
	// Записать Набор массивов
	void set_arrayStr(char ch, string sJson) { arrayStr[chToNum(ch)] = sJson; }
	// _________________________________________________________________________________
	// Прочитать Набор массивов
	string get_arrayStr(char ch) { return arrayStr[chToNum(ch)]; }
	// _________________________________________________________________________________
	// Чистим список шаблонов Json
	void clear_masShablJson() { for(int i=0; i != 8; i++) {  masShablJson[i] = ""; } }
	// _________________________________________________________________________________
	// Записать шаблон Json
	void set_ShablJson(char ch, string sJson) { masShablJson[chToNum(ch)] = sJson; }
	// _________________________________________________________________________________
	// Прочитать шаблон
	string get_ShablJson(char ch) { return masShablJson[chToNum(ch)]; }
	// _________________________________________________________________________________
	// Записать проверяемую команду Json
	void set_CommandJson(string sJson) { ver_CommandJson = sJson; }
	// _________________________________________________________________________________
	// Прочитать проверяемую команду Json
	string get_CommandJson() { return ver_CommandJson; }
	// _________________________________________________________________________________
	// Записать проверяемую команду Json
	void set_CmdJson(string sJson) { str_CmdJson = sJson; }
	// _________________________________________________________________________________
	// Прочитать проверяемую команду Json
	string get_CmdJson() { return str_CmdJson; }
	// _________________________________________________________________________________
	// Записать сессию
	void set_Session(char ch, string sJson) { str_Session[chToNum(ch)] = sJson; }
	// _________________________________________________________________________________
	// Прочитать сессию
	string get_Session(char ch) { return str_Session[chToNum(ch)]; }
	// _________________________________________________________________________________
	// Записать сырой возвращаемый Json
	void set_rawReqJson(char[] sJson) { rawReqJson = sJson; }
	// _________________________________________________________________________________
	// Прочитать сырой возвращаемый Json
	char[] get_rawReqJson() { return rawReqJson; }
	// _________________________________________________________________________________
	// Преобразовать шаблон Json --> Команда Json + подстановки переменных
	string createCmdJson(string shJson, string shVar) {
		string rez = shJson; string[] listRawVar = split(shVar, '|');
		// Дозапишем в список сессию
		for(int j = 0; j != 8; j++) {
			if(j == 0) listRawVar ~= "SESSION*A=" ~ str_Session[0];
			if(j == 1) listRawVar ~= "SESSION*B=" ~ str_Session[1];
			if(j == 2) listRawVar ~= "SESSION*C=" ~ str_Session[2];
			if(j == 3) listRawVar ~= "SESSION*D=" ~ str_Session[3];
			if(j == 4) listRawVar ~= "SESSION*E=" ~ str_Session[4];
			if(j == 5) listRawVar ~= "SESSION*F=" ~ str_Session[5];
			if(j == 6) listRawVar ~= "SESSION*G=" ~ str_Session[6];
			if(j == 7) listRawVar ~= "SESSION*H=" ~ str_Session[7];
		}
		foreach(el; listRawVar) {
			string el2 = strip(el); auto pozEq = indexOf(el2, '='); // Надо определить первое вхождение '='
			string s1, s2;	s1 = "[[" ~ strip(el2[0 .. pozEq]) ~ "]]";  s2 = strip(el2[pozEq + 1 .. $]);
			rez = rez.replace(s1, s2);
		}
		return rez;
	}
	// _________________________________________________________________________________
	// Раскидать Json --> вернуть Value
	JSONValue get_JsonValue(string kmd) {
		JSONValue rez;
		JSONValue[10] jm;	int njm;
		try {
			jm[0] = parseJSON(rawReqJson);
			string[] nameVal = split(kmd, "/");
			njm = 0;
			for(int i=0; i != nameVal.length; i++) {
				if(nameVal[i][$ - 1] == ']') {
					// Извлечь число из скобок
					int ind; string name;
					{ string[] m = split(nameVal[i], '['); name = m[0]; ind = to!int(m[1][0 .. $ - 1]); }
					jm[njm + 1] = jm[i][name][ind];	njm++;
				} else {
					jm[njm + 1] = jm[i][nameVal[i]];	njm++;
				}
			}
			rez = jm[njm];
		} catch(Throwable) {
		}
		return rez;
	}
}

static CTest  testVditek;
CTclQt objTclQt;

version(linux) {   
    import core.sys.posix.dlfcn;  // Определения dlopen() и dlsym()
    // На Linux эти функции не определены в core.runtime, вот и пришлось дописать.
    // странно, почему их там нет... Похоже они в основном Windows крутят. 
    extern (C) void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);  }
    void* GetProcAddress(void* hLib, string nameFun) {  return dlsym(hLib, nameFun.ptr);    }
    alias loadSym = GetProcAddress;
}
version(Windows) {
	// import core.sys.windows.winbase; 
    import core.sys.windows.winbase : GetProcAddress, GetModuleHandleA,  LoadLibraryA;  alias loadSym = GetProcAddress;	
}

// _________________________________________________________________________________
alias ClientData = void*;
alias Tcl_Interp = void;
alias Tcl_Obj = void;
alias Tcl_Command = void*;
alias Tcl_CmdDeleteProc = void*;
alias Tcl_ObjCmdProc = extern (C) int   function(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** Tcl_Obj);
alias extern (C) @nogc nothrow char*    function(Tcl_Interp* interp, const char* cmdName, Tcl_ObjCmdProc proc, ClientData clientData, Tcl_CmdDeleteProc deleteProc) t_Tcl_CreateObjCommand; t_Tcl_CreateObjCommand Tcl_CreateObjCommand;
alias extern (C) @nogc nothrow void     function(Tcl_Interp* interp, Tcl_Obj* resultObjPtr) t_Tcl_SetObjResult; t_Tcl_SetObjResult Tcl_SetObjResult;
alias extern (C) @nogc nothrow Tcl_Obj* function(const char* bytes, int length) t_Tcl_NewStringObj; t_Tcl_NewStringObj Tcl_NewStringObj;
alias extern (C) @nogc nothrow void     function(Tcl_Interp* interp, int objc, Tcl_Obj** objv, const char* message) t_Tcl_WrongNumArgs; t_Tcl_WrongNumArgs Tcl_WrongNumArgs;
alias extern (C) @nogc nothrow char*	function(Tcl_Obj *objPtr, int *lengthPtr) t_Tcl_GetStringFromObj;  t_Tcl_GetStringFromObj Tcl_GetStringFromObj;
alias extern (C) @nogc nothrow int	    function(Tcl_Interp* interp, const char* script) t_Tcl_Eval;  t_Tcl_Eval Tcl_Eval;
// _________________________________________________________________________________
extern (C) int get_ValJson(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int intOtvet = 0; JSONValue jv; string strOtvet;
	int lstr;
    if (objc != 2) {  Tcl_WrongNumArgs(interp, 1, objv, "string"); return TCL_ERROR;  }
	string el2 = strip(to!string(Tcl_GetStringFromObj(objv[1], &lstr))); 
	// Значение
	try {
		jv = testVditek.get_JsonValue(el2);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = strip(el2 ~ " no def: ");
		} else {
			if(jv.type() == JSONType.integer) {
				long new_jvStr = jv.integer; strOtvet = to!string(new_jvStr);
			} else {
				strOtvet = strip(jv.str);
			}
			strOtvet.length = strOtvet.length + 1; char* u = cast(char*)strOtvet.ptr + strOtvet.length - 1; *u = 0; strOtvet.length = strOtvet.length - 1;
		}
	} catch(Throwable) {
		strOtvet = "Error conversion JsonValue ...";
	}
	Tcl_SetObjResult(interp, Tcl_NewStringObj(strOtvet.ptr, -1));
	return TCL_OK;
}
// _________________________________________________________________________________
extern (C) int tst_ValJson(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int intOtvet = 0; JSONValue jv;
	int lstr;
    if (objc != 2) {  Tcl_WrongNumArgs(interp, 1, objv, "string"); return TCL_ERROR;  }
	string el2 = strip(to!string(Tcl_GetStringFromObj(objv[1], &lstr))); 
	auto pozEq = indexOf(el2, '='); // Надо определить первое вхождение '='
	
	string s1, s2;	s1 = strip(el2[0 .. pozEq]);  s2 = strip(el2[pozEq + 1 .. $]);
	string s4; char s3;
	s3 = s2[0]; s4 = s2[2 .. $];
	string strOtvet = "1";
	
	if( !((s3 == 'Z') || (s3 == 'L') || (s3 == 'T') || (s3 == 'S') || (s3 == 'M'))   ) {
		Tcl_WrongNumArgs(interp, 1, objv, "only: Z,L,T,S,M"); return TCL_ERROR; 
	}
	// Значение
	if(s3 == 'Z') {
		jv = testVditek.get_JsonValue(s1);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = "0 - " ~ el2 ~ " no def: " ~ s1 ;
		} else {
			if(s4[0] == '"') {					// Попытка ловить строку
				string new_jvStr = `"` ~ jv.str ~ `"`;
				if(new_jvStr != s4) { intOtvet++; strOtvet = "0 - " ~ el2; }
			} else {							// Ловим число
				if(jv.type() == JSONType.integer) {
					long new_jvStr = jv.integer;
					if(new_jvStr != to!int(s4)) { intOtvet++;  strOtvet = "0 - " ~ el2; }
				} else {
					if(jv.type() == JSONType.true_ || jv.type() == JSONType.false_) {
						if(jv.type() == JSONType.true_) {
							if( !to!bool(s4) ) { intOtvet++;  strOtvet =  "0 - " ~ el2; }
						} else {
							if( to!bool(s4) )  { intOtvet++;  strOtvet =  "0 - " ~ el2; }
						}
					}
				}
			}
		}
		if(strOtvet[0] == '0') Tcl_SetObjResult(interp, Tcl_NewBooleanObj(false)); else Tcl_SetObjResult(interp, Tcl_NewBooleanObj(true));
		return TCL_OK;
	}
	// Длинна
	if(s3 == 'L') {
		jv = testVditek.get_JsonValue(s1);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = "0 - " ~ el2 ~ " no def: " ~ s1 ;
		} else {
			// Определить тип
			if( jv.type() == JSONType.array ) {
				long num = to!long(s4);
				long lenArray = to!long(jv.array().length);
				if(lenArray != num) { intOtvet++; strOtvet =  "0 - " ~ el2; }
			} else {
				if(jv.type() == JSONType.object) {
					long new_jvStr = jv.object.length;
					long num = to!long(s4);
					if(new_jvStr != num) { intOtvet++; strOtvet =  "0 - " ~ el2; }
				} else {
					long new_jvStr = jv.str.length;
					long num = to!long(s4);
					if(new_jvStr != num) { intOtvet++; strOtvet =  "0 - " ~ el2; }
				}
			}
		}
	}
	// Тип
	if(s3 == 'T') {
		jv = testVditek.get_JsonValue(s1);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = "0 - " ~ el2 ~ " no def: " ~ s1 ;
		} else {
			if( !((s4 == "string") || (s4 == "integer") || (s4 == "array") || (s4 == "object") || (s4 == "bool")) ) {
				Tcl_WrongNumArgs(interp, 1, objv, "only: string,integer,array,object,bool"); return TCL_ERROR; 
			}
			if(s4 == "string")  { if( jv.type() != JSONType.string  ) {  intOtvet++; strOtvet = "0 - " ~ el2;  } }
			if(s4 == "integer") { if( jv.type() != JSONType.integer ) {  intOtvet++; strOtvet = "0 - " ~ el2;  } }
			if(s4 == "array")   { if( jv.type() != JSONType.array   ) {  intOtvet++; strOtvet = "0 - " ~ el2;  } }
			if(s4 == "object")  { if( jv.type() != JSONType.object  ) {  intOtvet++; strOtvet = "0 - " ~ el2;  } }
			if(s4 == "bool")    { 
				if( !((jv.type() == JSONType.true_) || (jv.type() == JSONType.false_)) ) {  
					intOtvet++; strOtvet = "0 - " ~ el2;  
				} 
			}
		}
	}
	// Сессия
	if(s3 == 'S') {
		jv = testVditek.get_JsonValue(s1);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = "0 - " ~ el2 ~ " no def: " ~ s1 ;
		} else {
			testVditek.set_Session(s4[0], jv.str);
		}
	}
	// Массив
	if(s3 == 'M') {
		// Получим строку с массивом
		string strMas = testVditek.get_arrayStr(s4[0]);
		jv = testVditek.get_JsonValue(s1);
		if(to!string(jv) == "null") {
			intOtvet++; strOtvet = "0 - " ~ el2 ~ " no def: " ~ s1 ;
		} else {
			if( jv.type() != JSONType.array ) {  intOtvet++; strOtvet = "0 - " ~ el2 ~ " no array";  } 
			else {
				string mstrJson; // На руках массив в Json
				for(int i; i != jv.array().length; i++) mstrJson ~= to!string(jv[i]) ~ "|";
				// Расскидываю на массив
				string[] shMas = split(strMas, '|');
				bool f; string strErr;
				foreach(e; shMas) {
					if( indexOf(mstrJson, strip(e)) < 0 ) { f = true; strErr = strip(e); break;	}
				}
				if(f) {  intOtvet++; strOtvet = "0 - " ~ el2 ~ " no " ~ strErr ~ ", ... ";  }
			}
		}
	}
	
    Tcl_SetObjResult(interp, Tcl_NewStringObj(strOtvet.ptr, -1));
    return TCL_OK;
}
// _________________________________________________________________________________
extern (C) int runJson_Cmd(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int lstr;
    if (objc != 2) {  Tcl_WrongNumArgs(interp, 1, objv, "string"); return TCL_ERROR;  }
	// // Выполнить запрос в dlang стиле
	// testVditek.set_rawReqJson(post(testVditek.get_strUrl(), to!string(Tcl_GetStringFromObj(objv[1], &lstr))));
	// Выполнить запрос в arsd стиле
	testVditek.set_rawReqJson(cast(char[])post_arsd(testVditek.get_strUrl(), to!string(Tcl_GetStringFromObj(objv[1], &lstr))));
	
	string strOtvet = to!string(testVditek.get_rawReqJson());
	strOtvet.length = strOtvet.length + 1; char* u = cast(char*)strOtvet.ptr + strOtvet.length - 1; *u = 0; strOtvet.length = strOtvet.length - 1;
	
    Tcl_SetObjResult(interp, Tcl_NewStringObj(strOtvet.ptr, -1));
    return TCL_OK;
}
// _________________________________________________________________________________
extern (C) int setUrl_Cmd(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int lstr;  if (objc != 2) {  Tcl_WrongNumArgs(interp, 1, objv, "string"); return TCL_ERROR;  }
	string strd = to!string(Tcl_GetStringFromObj(objv[1], &lstr));	testVditek.set_strUrl(strd);
    return TCL_OK;
}
// __________________________________________________________________
// Глобальные переменные программы
QApplication app;	// Само приложение
QWidget qv1;
QAction acNumStr;
QSpinBox spNumStr;
QPushButton knReadVar;
Tcl_Interp* gInterp;

extern (C) {
	void  onNumStr(CTclQt* uk, int n)                  { 	(*uk).run(n); 	}
}

int d_argc = 1;
// string[] d_argv = ["tclsh"];
char* mybuf = cast(char*)"tclsh".ptr;
// _________________________________________________________________________________
// Поддержка TCL + Qt
class CTclQt  {
	enum TypeOb {
		QApplication, QWidget, QLineEdit, QPushButton, QAction, QConnects, QBoxLayout, QMainWindow, QPlainTextEdit, QStatusBar, QToolBar
	}
	union UnQObj {
		QApplication 	uQApplication;
		QWidget			uQWidget;
		QLineEdit		uQLineEdit;
		QPushButton		uQPushButton;
		QAction			uQAction;
		QBoxLayout		uQBoxLayout;
		QMainWindow		uQMainWindow;
		QPlainTextEdit  uQPlainTextEdit;
		QStatusBar		uQStatusBar;
		QToolBar		uQToolBar;
	}
	struct SQobject {
		TypeOb 			type;
		UnQObj			qobj;
	}
	// _________________________________________________________________________________
	~this() {
		// mas_QWidget[0].destroy();
		// (cast(QApplication)mas_QObject[0]).destroy(); saveAppPtrQt = null;
		if(mas_QObject[0].type == TypeOb.QApplication) {
			mas_QObject[0].qobj.uQApplication.destroy(); saveAppPtrQt = null;
		}

		// MessageBoxA(null, "Warning! destructor".ptr, "Warning!!!".ptr, MB_OK);
	}
	
	// _________________________________________________________________________________
	private void* 		adrThis;    			/// Адрес собственного экземпляра
	
	private ulong 		nscript;       			// Глобальный номер скрипта
	string[]       		mas_QAction_script;		// Массив скриптов
	
	private ulong 		nobj;       			// Глобальный адрес в массиве
	SQobject[] 			mas_QObject;			// Словарь глобальных объектов
	
	// _________________________________________________________________________________
	@property void* aThis() { return &adrThis;	} /// Выдать указатель на p_QObject
	// _________________________________________________________________________________
	void saveThis(void* adr) {	adrThis = cast(void*)adr; } /// Запомнить указатель на собственный экземпляр
	// _________________________________________________________________________________
	// Выполнить Актион
	void run(int n) { int code = Tcl_Eval(gInterp, mas_QAction_script[n].ptr);	}
	// _________________________________________________________________________________
	// Проверка выполнения всякой дряни через объект
	string evalCmd(string[] objv) {
		string cmd, cmdArg, rez; ulong objc = objv.length;

// writeln("Количество objc = ", objc, "  Аргументы: ", objv);
		cmd = objv[0];
		switch(cmd) {
// QApplication		
			case "QApplication":
				if(objc < 2) { rez = "1QApplication new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 2)  { rez = "1new"; break; }
						SQobject ob; 
							ob.type = TypeOb.QApplication;
							ob.qobj.uQApplication = new QApplication(&d_argc, &mybuf, 1);
						mas_QObject ~= ob;
						rez = "0" ~ to!string(mas_QObject.length - 1);
						break;
					case "exec":
						if(objc != 3)  { rez = "1exec adr"; break; }
						rez = "0" ~ to!string(mas_QObject[to!uint(objv[2])].qobj.uQApplication.exec());
						break;
					default:
				}
				break;
// QWidget		
			case "QWidget":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QWidget;
								ob.qobj.uQWidget = new QWidget(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QWidget;
									ob.qobj.uQWidget = new QWidget(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "show":
						if(objc != 3)  { rez = "1show adr"; break; }
						if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
							mas_QObject[to!uint(objv[2])].qobj.uQWidget.show();
							rez = "0";
						} else {
							rez = "1show adr!=Qwidget";
						}
						break;
					case "resize":
						if(objc != 5)  { rez = "1resize adr w h"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQWidget.resize(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setWindowTitle":
						if(objc != 4)  { rez = "1setWindowTitle adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQWidget.setWindowTitle(objv[3]);
						rez = "0";
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1QWidget setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQWidget.setStyleSheet(objv[3]);
						rez = "0";
						break;
					default:
				}
				break;

// QToolBar
			case "QToolBar":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QToolBar;
								ob.qobj.uQToolBar = new QToolBar(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QToolBar;
									ob.qobj.uQToolBar = new QToolBar(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "addAction":
						if(objc != 4)  { rez = "1addAction adr action"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQToolBar.addAction( mas_QObject[to!uint(objv[3])].qobj.uQAction );
						rez = "0";
						break;
					default:
				}
				break;
// QStatusBar
			case "QStatusBar":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QStatusBar;
								ob.qobj.uQStatusBar = new QStatusBar(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QStatusBar;
									ob.qobj.uQStatusBar = new QStatusBar(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQStatusBar.setStyleSheet(objv[3]);
						rez = "0";
						break;
					case "showMessage":
						if(objc != 4)  { rez = "1showMessage adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQStatusBar.showMessage(objv[3]);
						rez = "0";
						break;
					case "showMessage_timeOut":
						if(objc != 5)  { rez = "1showMessage_timeOut adr timeOut str"; break; }
						int tout = to!int(objv[3]);
						mas_QObject[to!uint(objv[2])].qobj.uQStatusBar.showMessage(objv[4]);
						rez = "0";
						break;
					default:
				}
				break;
// QPlainTextEdit		
			case "QPlainTextEdit":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QPlainTextEdit;
								ob.qobj.uQPlainTextEdit = new QPlainTextEdit(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QPlainTextEdit;
									ob.qobj.uQPlainTextEdit = new QPlainTextEdit(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "show":
						if(objc != 3)  { rez = "1show adr"; break; }
						if(mas_QObject[to!uint(objv[2])].type == TypeOb.QPlainTextEdit) {
							mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.show();
							rez = "0";
						} else {
							rez = "1show adr!=Qwidget";
						}
						break;
					case "resize":
						if(objc != 5)  { rez = "1resize adr w h"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.resize(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setWindowTitle":
						if(objc != 4)  { rez = "1setWindowTitle adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.setWindowTitle(objv[3]);
						rez = "0";
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.setStyleSheet(objv[3]);
						rez = "0";
						break;
					case "appendPlainText":
						if(objc != 4)  { rez = "1appendPlainText adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.appendPlainText(objv[3]);
						rez = "0";
						break;
					case "toPlainText":
						if(objc != 3)  { rez = "1toPlainText adr"; break; }
						string s = mas_QObject[to!uint(objv[2])].qobj.uQPlainTextEdit.toPlainText!string;
						rez = "0" ~ s;
						break;
					default:
				}
				break;
// QMainWindow		
			case "QMainWindow":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QMainWindow;
								ob.qobj.uQMainWindow = new QMainWindow(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QMainWindow;
									ob.qobj.uQMainWindow = new QMainWindow(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "show":
						if(objc != 3)  { rez = "1show adr"; break; }
						if(mas_QObject[to!uint(objv[2])].type == TypeOb.QMainWindow) {
							mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.show();
							rez = "0";
						} else {
							rez = "1show adr!=Qwidget";
						}
						break;
					case "resize":
						if(objc != 5)  { rez = "1resize adr w h"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.resize(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setWindowTitle":
						if(objc != 4)  { rez = "1setWindowTitle adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.setWindowTitle(objv[3]);
						rez = "0";
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1QWidget setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.setStyleSheet(objv[3]);
						rez = "0";
						break;
					case "setCentralWidget":
						if(objc != 4)  { rez = "1setCentralWidget adr widget"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.setCentralWidget(  mas_QObject[to!uint(objv[3])].qobj.uQWidget   );
						rez = "0";
						break;
					case "setStatusBar":
						if(objc != 4)  { rez = "1setStatusBar adr stusbar"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.setStatusBar(  mas_QObject[to!uint(objv[3])].qobj.uQStatusBar  );
						rez = "0";
						break;
					case "addToolBar":
						if(objc != 4)  { rez = "1addToolBar adr toolbar"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQMainWindow.addToolBar(  mas_QObject[to!uint(objv[3])].qobj.uQToolBar  );
						rez = "0";
						break;
					default:
				}
				break;
// QLineEdit
			case "QLineEdit":
				if(objc < 2) { rez = "1new|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 3)  { rez = "1new null|adr"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QLineEdit;
								ob.qobj.uQLineEdit = new QLineEdit(null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QLineEdit;
									ob.qobj.uQLineEdit = new QLineEdit(mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "resize":
						if(objc != 5)  { rez = "1resize adr w h"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQLineEdit.resize(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQLineEdit.setStyleSheet(objv[3]);
						rez = "0";
						break;
					case "move":
						if(objc != 5)  { rez = "1move adr x y"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQLineEdit.move(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setText":
						if(objc != 4)  { rez = "1setText adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQLineEdit.setText(to!string(objv[3]));
						rez = "0";
						break;
					case "text":
						if(objc != 3)  { rez = "1text adr"; break; }
						rez = "0" ~ mas_QObject[to!uint(objv[2])].qobj.uQLineEdit.text!string;
						break;
					default:
				}
				break;
// QPushButton		
			case "QPushButton":
				if(objc < 2) { rez = "1new|cmd ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						if(objc != 4)  { rez = "1new null|adr title"; break; }
						string title = to!string(objv[3]);
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QPushButton;
								ob.qobj.uQPushButton = new QPushButton(title, null);
							mas_QObject ~= ob;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QPushButton;
									ob.qobj.uQPushButton = new QPushButton(title, mas_QObject[to!uint(objv[2])].qobj.uQWidget);
								mas_QObject ~= ob;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "resize":
						if(objc != 5)  { rez = "1QPushButton resize adr w h"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPushButton.resize(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "move":
						if(objc != 5)  { rez = "1QPushButton move adr x y"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPushButton.move(to!int(objv[3]), to!int(objv[4]));
						rez = "0";
						break;
					case "setStyleSheet":
						if(objc != 4)  { rez = "1QPushButton setStyleSheet adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQPushButton.setStyleSheet(objv[3]);
						rez = "0";
						break;
					default:
				}
				break;
// QAction		
			case "QAction":
				if(objc < 3) { rez = "1new|cmd null|adr ..."; break; }
				cmdArg = objv[1];
				switch(cmdArg) {
					case "new":
						string script = objv[3];
						int lastAction = to!int(mas_QAction_script.length);
						if(objc != 4)  { rez = "1new adr str_script"; break; }
						if(objv[2] == "null") {
							SQobject ob; 
								ob.type = TypeOb.QAction;
								ob.qobj.uQAction = new QAction(null, &onNumStr, aThis, lastAction);
							mas_QObject ~= ob;
							mas_QAction_script ~= script;
							rez = "0" ~ to!string(mas_QObject.length - 1);
						} else {
							if(mas_QObject[to!uint(objv[2])].type == TypeOb.QWidget) {
								SQobject ob; 
									ob.type = TypeOb.QAction;
									ob.qobj.uQAction = new QAction(mas_QObject[to!uint(objv[2])].qobj.uQWidget, &onNumStr, aThis, lastAction);
								mas_QObject ~= ob;
								mas_QAction_script ~= script;
								rez = "0" ~ to!string(mas_QObject.length - 1);
							} else {
								rez = "1new adr!=Qwidget";
							}
						}
						break;
					case "setText":
						if(objc != 4)  { rez = "1setText adr str"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQAction.setText(objv[3]);
						rez = "0";
						break;
					case "setIcon":
						if(objc != 4)  { rez = "1setIcon adr fileIcon"; break; }
						mas_QObject[to!uint(objv[2])].qobj.uQAction.setIcon(objv[3]);
						rez = "0";
						break;
					default:
				}
				break;
// QConnects
			case "QConnects":
				if(objc < 5) { rez = "adr signal adr slot"; break; }
				string sig1 = objv[2], sig2 = objv[4];    // Достали сигнал - слот
				TypeOb tobA1 = mas_QObject[to!uint(objv[1])].type, tobA2 = mas_QObject[to!uint(objv[3])].type;
				if(tobA1 == TypeOb.QPushButton) {
					if(tobA2 == TypeOb.QAction) {
						mas_QObject[to!uint(objv[1])].qobj.uQPushButton.connects( 
							mas_QObject[to!uint(objv[1])].qobj.uQPushButton, sig1, 
							mas_QObject[to!uint(objv[3])].qobj.uQAction,     sig2
						);
					}
				}
				rez = "0";
				break;
// QBoxLayout				
			case "QBoxLayout":
				if(objc < 3) { rez = "1new|cmd null|adr ..."; break; }
				cmdArg = objv[1]; 
				switch(cmdArg) {
					case "new":
						if(objc != 4) { rez = "1new null|adr direction"; break; }
						string direction = objv[3];
						if(objv[2] == "null") {
							SQobject ob; 	ob.type = TypeOb.QBoxLayout;
							if(direction == ">") {   // LeftToRight
								ob.qobj.uQBoxLayout = new QBoxLayout(null, QBoxLayout.Direction.LeftToRight);
							}
							if(direction == "<") {   // RightToLeft
								ob.qobj.uQBoxLayout = new QBoxLayout(null, QBoxLayout.Direction.RightToLeft);
							}
							if(direction == "V") {   // TopToBottom
								ob.qobj.uQBoxLayout = new QBoxLayout(null, QBoxLayout.Direction.TopToBottom);
							}
							if(direction == "A") {   // BottomToTop
								ob.qobj.uQBoxLayout = new QBoxLayout(null, QBoxLayout.Direction.BottomToTop);
							}
							mas_QObject ~= ob;
						} else {
							uint nn = to!uint(objv[2]);
							SQobject ob; 	ob.type = TypeOb.QBoxLayout;
							if(mas_QObject[nn].type == TypeOb.QWidget) {
								if(direction == ">") {   // LeftToRight
									ob.qobj.uQBoxLayout = new QBoxLayout(mas_QObject[nn].qobj.uQWidget, QBoxLayout.Direction.LeftToRight);
								}
								if(direction == "<") {   // RightToLeft
									ob.qobj.uQBoxLayout = new QBoxLayout(mas_QObject[nn].qobj.uQWidget, QBoxLayout.Direction.RightToLeft);
								}
								if(direction == "V") {   // TopToBottom
									ob.qobj.uQBoxLayout = new QBoxLayout(mas_QObject[nn].qobj.uQWidget, QBoxLayout.Direction.TopToBottom);
								}
								if(direction == "A") {   // BottomToTop
									ob.qobj.uQBoxLayout = new QBoxLayout(mas_QObject[nn].qobj.uQWidget, QBoxLayout.Direction.BottomToTop);
								}
								mas_QObject ~= ob;
							}
						}
						rez = "0" ~ to!string(mas_QObject.length - 1);
						break;
					case "addLayout":
						if(objc != 4) { rez = "addLayout adr layout"; break; }
						uint nnA = to!uint(objv[2]); uint nnW = to!uint(objv[3]);
						if(mas_QObject[nnW].type == TypeOb.QBoxLayout) {
							mas_QObject[nnA].qobj.uQBoxLayout.addLayout(mas_QObject[nnW].qobj.uQBoxLayout);
						}
						rez = "0";
						break;
					case "addWidget":
						if(objc != 4) { rez = "1addWidget adr widget"; break; }
						uint nnA = to!uint(objv[2]); uint nnW = to!uint(objv[3]);
						if(mas_QObject[nnW].type == TypeOb.QWidget) {
							mas_QObject[nnA].qobj.uQBoxLayout.addWidget(mas_QObject[nnW].qobj.uQWidget);
						}
						if(mas_QObject[nnW].type == TypeOb.QPushButton) {
							mas_QObject[nnA].qobj.uQBoxLayout.addWidget(mas_QObject[nnW].qobj.uQPushButton);
						}
						if(mas_QObject[nnW].type == TypeOb.QLineEdit) {
							mas_QObject[nnA].qobj.uQBoxLayout.addWidget(mas_QObject[nnW].qobj.uQLineEdit);
						}
						if(mas_QObject[nnW].type == TypeOb.QPlainTextEdit) {
							mas_QObject[nnA].qobj.uQBoxLayout.addWidget(mas_QObject[nnW].qobj.uQPlainTextEdit);
						}
						rez = "0";
						break;
					default:
				}
				break;
			default:
				rez = "1QApplication, QWidget ..."; 
		}
//		writeln("rezult = ", rez);
		return rez;
	}
}

// _________________________________________________________________________________
extern (C) int app_exec(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	writeln("---0---");
	int lstr;  if (objc != 2) {  Tcl_WrongNumArgs(interp, 1, objv, "string"); return TCL_ERROR;  }
	writeln("---01---");
	string strd = to!string(Tcl_GetStringFromObj(objv[1], &lstr));
    return TCL_OK;
}

// _________________________________________________________________________________
extern (C) int QtE(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int lstr; string cmd, rez;
	string[] argstcl; for(int i; i != objc; i++) argstcl ~= to!string(Tcl_GetStringFromObj(objv[i], &lstr));
	string eval_rez2 = objTclQt.evalCmd(argstcl);
	string eval_rez = eval_rez2[1 .. $]~"\0";
	if(eval_rez2[0] == '0') { Tcl_SetObjResult(interp, Tcl_NewStringObj(eval_rez.ptr, -1));	} 
	else {	Tcl_WrongNumArgs(interp, 1, objv, eval_rez.ptr); return TCL_ERROR;	}
    return TCL_OK;
}
// _________________________________________________________________________________
extern (C) int qQApplication(ClientData clientData, Tcl_Interp* interp, int objc, Tcl_Obj** objv) {
	int lstr; string cmd, rez;
	string[] argstcl; for(int i; i != objc; i++) argstcl ~= to!string(Tcl_GetStringFromObj(objv[i], &lstr));
	string eval_rez2 = objTclQt.evalCmd(argstcl);
	string eval_rez = eval_rez2[1 .. $]~"\0";
	if(eval_rez2[0] == '0') { Tcl_SetObjResult(interp, Tcl_NewStringObj(eval_rez.ptr, -1));	} 
	else {	Tcl_WrongNumArgs(interp, 1, objv, eval_rez.ptr); return TCL_ERROR;	}
    return TCL_OK;
}

// _________________________________________________________________
// Фактически - main() 
export extern(C) int Qtt_Init(Tcl_Interp* interp) {
	// rt_init();
	
	string nameTclCore;
	version(linux)   {      nameTclCore = "libtcl8.6.so";  }
	version(Windows) {    
		version(actTcl)  {	nameTclCore = "tcl85.dll";   }	
		version(winTcl)  {	nameTclCore = "tcl86t.dll";   }	
	}
	gInterp = interp;
	auto h = Runtime.loadLibrary(nameTclCore); // Грузим dll или so
	if(h is null) writeln("error Load dll: " ~ nameTclCore);

	Tcl_CreateObjCommand = cast(t_Tcl_CreateObjCommand)loadSym(h,  "Tcl_CreateObjCommand");
	Tcl_SetObjResult     = cast(t_Tcl_SetObjResult)loadSym(h,      "Tcl_SetObjResult");
	Tcl_NewStringObj     = cast(t_Tcl_NewStringObj)loadSym(h,      "Tcl_NewStringObj");
	Tcl_WrongNumArgs     = cast(t_Tcl_WrongNumArgs)loadSym(h,      "Tcl_WrongNumArgs");
	Tcl_GetStringFromObj = cast(t_Tcl_GetStringFromObj)loadSym(h,  "Tcl_GetStringFromObj");
	Tcl_Eval             = cast(t_Tcl_Eval)loadSym(h,              "Tcl_Eval");

	// Создаю экземпляр поддержки
	objTclQt = new CTclQt; objTclQt.saveThis(&objTclQt);
	// qqqq();
	
    // Tcl_CreateObjCommand(interp, "app_exec",     &app_exec, null, null);
    Tcl_CreateObjCommand(interp, "QtE",          	&QtE,                null, null);
    Tcl_CreateObjCommand(interp, "QApplication", 	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QWidget",      	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QMainWindow",  	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QPlainTextEdit",	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QPushButton",  	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QAction",      	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QLineEdit",    	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QBoxLayout",   	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QStatusBar",   	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QToolBar",	   	&qQApplication,      null, null);
    Tcl_CreateObjCommand(interp, "QConnects",    	&qQApplication,      null, null);

	bool fDebug = false;									// T - выдавать диагностику загрузки QtE5
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  	// Выйти,если ошибка загрузки библиотеки
    return TCL_OK;
}

__EOF__
load c:/qte5/32/tcl_example/d/d.dll Tcldexample
load d.so Tcldexample
