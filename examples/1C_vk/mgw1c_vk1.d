// MGW (Мохов Геннадий Владимирович) 2017 - ВК для 1С 8.3
//
// dmd -ofmgw1c_vk1.dll mgw1c_vk1 terminal asc1251 -L/IMPLIB -shared -release

module cd1;

import core.sys.windows.windows;
import core.sys.windows.dll;
import core.runtime;     // Загрузка DLL Для Win
import std.string;
import core.stdc.wchar_ : wcscmp, wmemcpy;
import std.stdio;

/*----- Фичи, на которые ушло 5 дней тестирования алгоритма 1С при загрузке и регистрации ВК -----
* 1) - 1С функция "ПодключитьВнешнююКомпоненту(путьdll.XXX.типвк)" имеет три параметра. Самый примечательный средний
*      он определяет и средний параметр 1С функции "Новый(AddIn.XXX.расширение)", который ОДНАЗНАЧНО должен
*      совпадать с средним параметром функции "ПодключитьВнешнююКомпоненту(путьdll.XXX.типвк)". Причем, что 
*      содержит это поле не важно, ВК об этом ни чего не знает.
* 2) - Заставить ВК создать несколько объектов возможно, если для ВК функции GetClassNames("obj1|obj2|obj3") <-- для примера
*      в строке параметра через разделитель ихперечислить. При этом 1С последовательно будет вызывать GetClassObject
*      для каждого объекта в этом списке. Поскольку первый и второй параметр в Новый() у нас уже предопределен, то
*      как то различить объекты можно только по третьему параметру. По этому третий параметр будет одно из
*      значений из "obj1|obj2|obj3". Это значит, что для каждого вызова функции ВК RegisterExtensionAs() нам
*      надо помнить, что записать мы должны имя объекта (obj1, obj2 или obj3)
* 3) - Объекты создаются сразу все в момент вызова "ПодключитьВнешнююКомпоненту()" и "Новый()" ни чего не создаёт,
*      НО! если будет дан вызов ещё одного "Новый()", то будет создан ещё один новый экземпляр объекта.
*
* ---------------------------------------------------*/


// ________________________________________________
// Алиасы для упращения записи работы с указателями
alias p   = void*;
alias ppi = immutable(p)*;
// ________________________________________________
// Вспомогательные функции. Forth фукция @
p dog(T)(T pz) { return *cast(p*)pz; }
/*
void msgbox(wstring msg, wstring zag) {
	char[256] msgbuf;		char[256] zagbuf;	
	wsprintf(cast(wchar*)cbuf, cast( const(wchar)*)"wstrLen = %d"w, tvar.VarEnum.vtRecWideString.wstrLen );	
	MessageBoxW(null, cast(wchar*)msgbuf, zagbuf, 0);
}
*/
// ______________________________________________________________
// Выделение и освобождение памяти средствами 1С для внутренних нужд
// IMemoryManager --> C++ Interface representing memory manager.
// ______________________________________________________________
// Реализация интерфейса класса С++. Смысл: компилятору D рассказывается, как вызывать
// методы С++ класса. Однако сам класс уже создан внутри 1С (С++) и нам в D будет передан
// указатель на этот класс. По этому, что написано в теле самих методов (пустые) не важно,
// т.к. они реально не выполняются.
extern (C++) class CMemoryManager /* :IMemoryManager */ {
	extern (Windows) {
		// C++ деструктор, всегда первый
		// ----------------------------------
		void Destroy() {}
		// Выделить память указанного размера
		// ----------------------------------
		// @InOut pMemory - двойной указатель на переменную, которая будет содержать
		// указатель на блок памяти или null если была ошибка
		// @In ulCountByte - размер запрашиваемого блока
		// @return результат операции
		bool AllocMemory(p* pMemory, uint ulCountByte) { return true; }
		// Освободить память 
		// ----------------------------------
		// @In pMemory - двойной указатель на переменную содержащию
		// указатель на блок памяти
		void FreeMemory (p* pMemory) {}
	}
}

// Это входные параметы для функции "GetInterface()" которая может возвратить указатель на дополнительные
// интерфейсы 1С новых версий, что позволит задействовать их возможности
enum InterfacesEnum  {    eIMsgBox = 0,    eIPlatformInfo    }
enum AddInQuestionDialogModeEnum { eAQDModeOK, eAQDModeOKCancel, eAQDModeAbortRetryIgnore, eAQDModeYesNoCancel, eAQDModeYesNo, eAQDModeRetryCancel }
enum AddInDlgRetCodesEnum  {
    eADlgRetCodeTimeout 	= -1,
    eADlgRetCodeOK 			=  1,
    eADlgRetCodeCancel,
    eADlgRetCodeAbort,
    eADlgRetCodeRetry,
    eADlgRetCodeIgnore,
    eADlgRetCodeYes,
    eADlgRetCodeNo,
}
	
// ______________________________________________________________
/* Представляет интерфейс для взаимодействия ВК и 1С Платформой
 *
 */
/// Base interface for object components.
extern (C++) class CAddInDefBase {
	extern (Windows) @nogc @system {
		// C++ деструктор, всегда первый
		// ----------------------------------
		void Destroy() {}
		
		/// добавить error сообщение
		/**
		 *  @param wcode - error code
		 *  @param source - source of error
		 *  @param descr - description of error
		 *  @param scode - error code (HRESULT)
		 *  @return the result of
		 */
		bool AddError(ushort wcode, immutable(wchar)* source, immutable(wchar)* descr, int scode) { return true; }

		/// Reads a property value
		/**
		 *  @param wszPropName -property name
		 *  @param pVal - value being returned
		 *  @param pErrCode - error code (if any error occured)
		 *  @param errDescriptor - error description (if any error occured)
		 *  @return the result of read.
		 */
		bool Read(wchar* wszPropName, TVariant* pVal, long* pErrCode, wchar** errDescriptor) { return true; }
		/// Writes a property value
		/**
		 *  @param wszPropName - property name
		 *  @param pVar - new property value
		 *  @return the result of write.
		 */
		bool Write(wchar* wszPropName, TVariant* pVar) { return true; }

		///Registers profile components
		/**
		 *  @param wszProfileName - profile name
		 *  @return the result of
		 */
		bool RegisterProfileAs(wchar* wszProfileName) { return true; }

		/// Changes the depth of event buffer
		/**
		 *  @param lDepth - new depth of event buffer
		 *  @return the result of
		 */
		bool SetEventBufferDepth(long lDepth) { return true; }
		/// Returns the depth of event buffer
		/**
		 *  @return the depth of event buffer
		 */
		long GetEventBufferDepth() { return true; }
		/// Registers external event
		/**
		 *  @param wszSource - source of event
		 *  @param wszMessage - event message
		 *  @param wszData - message parameters
		 *  @return the result of
		 */
		bool ExternalEvent( immutable(wchar)* wszSource,  immutable(wchar)* wszMessage,  immutable(wchar)* wszData) { return true; }
		/// Clears event buffer
		/**
		 */
		void CleanEventBuffer() { }

		// Вывести строку в StatusLine обычного приложения (не управляемые формы)
		// ----------------------------------------------------------------------
		// @param wszStatusLine - строка для отображения, может быть обычной "Строка для отображения"w.ptr
		// @return результат операции
		bool SetStatusLine(wchar* wszStatusLine) { return true; }
		
		/// Resets the status line contents
		// --------------------------------
		// @return the result of
		void ResetStatusLine() { }
	}
}

extern (C++) class CAddInDefBaseEx  :  CAddInDefBase {
	extern (Windows) @nogc @system {
		// void Destroy2() {}
		// ----------------------------------
		// Тут есть странность. В примере С++ тут первым должен быть деструктор, но в реальности
		// его нет!!! Получается, что компилятор как то по другому распеделяет память, либо
		// пример устарел. Как бы там не было, но закоментировав деструктор удалось вызвать GetInterface() ...
		// ----------------------------------
		// void Destroy2() {}
		// p GetInterface(InterfacesEnum iface) { return null; }
		
		p GetInterface(InterfacesEnum iface) { return null; }
	}
}

extern (C++) class CIMsgBox {
	extern (Windows) @nogc @system {
		// void	DestroyMsgBox() {}
		// @disable this();
		bool 	Confirm(immutable(wchar)* queryText, TVariant* retVal) { return true; }
		bool 	Alert(immutable(wchar)* queryText) { return true; }
	}
}

alias t_Alert = extern (Windows) @nogc bool function(immutable(wchar)*);

// ================= MGW1 =================
p m_iConnect;
p m_iMsg;
extern (C++) class CMgw1CIInitDoneBase {				// для CMgw1
	extern (Windows)  @nogc @system {
		void Destroy() {
			// MessageBoxA(null, "--V40-- Destructor CMgw1CIInitDoneBase()".ptr, "aution".ptr, 0);
		}
		bool Init(p pConnection) {
			debug {
				MessageBoxA(null, "--V411-- Init()".ptr, "aution".ptr, 0);
			}
			mgw1.ptrCPPobjIConnect = pConnection; 
			mgw1.st_iConnect = cast(CAddInDefBase*)&(mgw1.ptrCPPobjIConnect);
			return pConnection !is null;
		}
		bool setMemManager(p mem) {
			debug {
				MessageBoxA(null, "--V42-- setMemManager()".ptr, "aution".ptr, 0);
			}
			// Для D нужно отодвинуть указатель, т.к. D класс "дальше" C++ класса
			mgw1.ptrCPPobjIMemory = mem; 
			mgw1.st_iMemory = cast(CMemoryManager*)&(mgw1.ptrCPPobjIMemory);
			return mem !is null;
		}
		int GetInfo() { 
			debug {
				MessageBoxA(null, "--V43-- GetInfo()".ptr, "aution".ptr, 0);	
			}
			return 2000; 	
		}
		void	Done()    { 
			debug {
				MessageBoxA(null, "--V44-- Done()".ptr, "aution".ptr, 0);	
			}
		}
	}
}

wstring prNameExt;
wstring str2;

extern (C++) class CMgw1CILanguageExtenderBase {		// для CMgw1
	extern (Windows) {
		void Destroy() {
			// MessageBoxA(null, "--X40-- Destructor CMgw1CILanguageExtenderBase()".ptr, "aution".ptr, 0);
		}
		// Создает строку с char_t* wide содержащей имя ВК Последнее поле после точек
		// Обязательно использование менеджера памяти 1С, в противном случае не работает
		bool	RegisterExtensionAs(wchar** wsExtensionName) {	
			bool rez = false;
			// MessageBoxW(null, "--X45-- RegisterExtensionAs()"w.ptr, prNameExt.ptr, 0);
			if(mgw1.st_iMemory !is null) {
				int iActualSize = prNameExt.length + 1;		// Длина с нулем
				if(mgw1.st_iMemory.AllocMemory(cast(p*)wsExtensionName, wchar.sizeof * iActualSize)) {
					wmemcpy(*wsExtensionName, prNameExt.ptr, iActualSize);
					// MessageBoxW(NULL, cast(const(wchar)*)*wsExtensionName, NULL, 1);
					rez = true;
				}
			}
			return rez;
		}
		// Возвращает количество свойств, 0 = свойств нет
		int	GetNProps() { 
			// MessageBoxA(null, "--X46-- GetNProps()".ptr, "aution".ptr, 0);	
			return Props.ePropLast; 
		};
		// Возвращает порядковый номер свойства, имя которого передается в параметрах
		int	FindProp(const(wchar)* wsPropName) { 
			int n = -1;  // Вдруг не найдено
			for(int i; i != Props.ePropLast; i++) {
				if( 0 == wcscmp( wsPropName, listProp[i].propNameRu.ptr )) 		{	n = i; break;	} 
				else {
					if( 0 == wcscmp( wsPropName, listProp[i].propNameEn.ptr )) 	{	n = i; break;	}
				}
			}
			// wstring bufwstr = format("--X47-- FindProp() n == %s"w, n);
			// MessageBoxW(NULL, cast(const(wchar)*)wsPropName, bufwstr.ptr, 1);
			return n; 
		};
		// Возвращает имя свойства по его порядковому номеру и по переданному идентификатору языка
		p GetPropName(int lPropNum, int lPropAlias)  { /* MessageBoxA(null, "--X48-- GetPropName()".ptr, "aution".ptr, 0);	*/ return null; };
		// Возвращает значение свойства с указанным порядковым номером
		bool	GetPropVal(const int lPropNum, TVariant* pvarPropVal)   { 
			bool rez = false;
			// MessageBoxA(null, "--X49-- GetPropVal()".ptr, "aution".ptr, 0);
			if(lPropNum == Props.eTest) {
				str2 = "[[[ " ~ str1 ~ " ]]]";
	
				wchar* t1;
				int iActualSize = str2.length + 1;		// Длина с нулем
				if(mgw1.st_iMemory.AllocMemory(cast(p*)&t1, wchar.sizeof * iActualSize)) 
					wmemcpy(t1, str2.ptr, iActualSize);
				(*pvarPropVal).vt = ENUMVAR.VTYPE_PWSTR;
				(*pvarPropVal).VarEnum.vtRecWideString.pwstrVal = t1;
				(*pvarPropVal).VarEnum.vtRecWideString.wstrLen  = str2.length;
				rez = true; 
			}
			if(lPropNum == Props.eIsLogConsole) {			// естьЛогКонсоль + isLogConsole
				(*pvarPropVal).vt = ENUMVAR.VTYPE_BOOL;
				(*pvarPropVal).VarEnum.bVal = f_LogConsole;
				// MessageBoxA(null, "--X49-- eIsLogConsole GetPropVal()".ptr, "aution".ptr, 0);
				rez = true; 
			}
			return rez; 
		};
		// Устанавливает значение свойства с указанным порядковым номером
		bool	SetPropVal(const int lPropNum, TVariant* pvarPropVal)   { 
			bool rez = false;
			// TVariant tvar = *pvarPropVal;
			// MessageBoxA(null, "--X50-- SetPropVal()".ptr, "aution".ptr, 0);	
			if(lPropNum == Props.eTest) {
				import std.conv : to;
				
				if( (*pvarPropVal).vt == ENUMVAR.VTYPE_PWSTR) {
					str1 = to!wstring((*pvarPropVal).VarEnum.vtRecWideString.pwstrVal);
					// mgw1.st_iConnect.ResetStatusLine();
					// mgw1.st_iConnect.SetStatusLine(cast(wchar*)(*pvarPropVal).VarEnum.vtRecWideString.pwstrVal);
					mgw1.st_iConnect.SetStatusLine(cast(wchar*)"Привет из ВК на D ..."w.ptr);
					// MessageBoxW(null, cast( const(wchar)*)str1.ptr, null, 0);
				}
				rez = true; 
			}
			if(lPropNum == Props.eIsLogConsole) {			// естьЛогКонсоль + isLogConsole
				if((*pvarPropVal).vt == ENUMVAR.VTYPE_BOOL) {
					f_LogConsole = (*pvarPropVal).VarEnum.bVal;
					consInit(f_LogConsole);
					rez = true;
				}
			}
			if(lPropNum == Props.ePrint) {					// Печать на консоль
				if( (*pvarPropVal).vt == ENUMVAR.VTYPE_PWSTR) {
					import std.conv : to;
					string strWs = to!string((*pvarPropVal).VarEnum.vtRecWideString.pwstrVal);
					consPrint(strWs);
				}
				rez = true; 
			}
			return rez; 
		};
		// Возвращает флаг флаг возможности чтения свойства с указанным порядковым номером
		bool	IsPropReadable(int lPropNum)    { 	return listProp[lPropNum].isRead;	};
		// Возвращает флаг флаг возможности записи свойства с указанным порядковым номером
		bool	IsPropWritable(int lPropNum)    { 	return listProp[lPropNum].isWrite;	};
		
		int	GetNMethods()   { /* MessageBoxA(null, "--X53-- GetNMethods()".ptr, "aution".ptr, 0); */	return 0; };
		int	FindMethod(p wsMethodName) { MessageBoxA(null, "--X54-- FindMethod()".ptr, "aution".ptr, 0);	return 0; };
		p	GetMethodName(int lMethodNum, int lMethodAlias)  { MessageBoxA(null, "--X55-- GetMethodName()".ptr, "aution".ptr, 0);	return null; };
		int		GetNParams(int lMethodNum)  { MessageBoxA(null, "--X56-- GetNParams()".ptr, "aution".ptr, 0);	return 0; };
		bool	GetParamDefValue(int lMethodNum, int lParamNum, p pvarParamDefValue)  { MessageBoxA(null, "--X57-- GetParamDefValue()".ptr, "aution".ptr, 0);	return 0; };   
		bool	HasRetVal(int lMethodNum)  { MessageBoxA(null, "--X58-- HasRetVal()".ptr, "aution".ptr, 0);	return 0; };   
		bool	CallAsProc(int lMethodNum, p paParams, int lSizeArray)  { MessageBoxA(null, "--X59-- CallAsProc()".ptr, "aution".ptr, 0);	return 0; };   
		bool	CallAsFunc(int lMethodNum, p pvarRetValue, p paParams, int lSizeArray)  { MessageBoxA(null, "--X60-- CallAsFunc()".ptr, "aution".ptr, 0);	return 0; };   
	}
}

extern (C++) class CMgw1CILocaleBase {					// для CMgw1
	extern (Windows) {
		void Destroy() {
			// MessageBoxA(null, "--Z40-- Destructor CMgw1CILocaleBase()".ptr, "aution".ptr, 0);
		}
		void	SetLocale(p loc)   { /* MessageBoxA(null, "--Z61-- SetLocale ()".ptr, "aution".ptr, 0); */ };   
	}
}
// ================= MGW1 =================

enum   AppCapabilities { eAppCapabilitiesInvalid = -1,    eAppCapabilities1 = 1,    eAppCapabilitiesLast = eAppCapabilities1 };
static AppCapabilities g_capabilities = AppCapabilities.eAppCapabilitiesInvalid;
//---------------------------------------------------------------------------//

// Определяет количество и имена методов
struct stProp {
	Props		num;			// Номер свойства
	wstring		propNameEn;		// Имя свойства En
	wstring		propNameRu;		// Имя свойства Ru
	bool		isRead;			// Можно читать?
	bool		isWrite;		// Можно писать?
}
// Это перечисление нумерует свойства и автоматически задаёт размерность массива для listProp
enum Props {
	eTest,
	eIsLogConsole,
	ePrint,
	ePropLast
}
// Массив структур, каждая запись хранит описание Свойства
stProp[Props.ePropLast] listProp = [
	{ num: Props.eTest, propNameEn: "Test", propNameRu: "Тест", isRead: true, isWrite: true },
	{ num: Props.eIsLogConsole, propNameEn: "isLogConsole", propNameRu: "естьЛогКонсоль", isRead: true, isWrite: true },
	{ num: Props.ePrint, propNameEn: "Print", propNameRu: "Печать", isRead: false, isWrite: true }
];

// _____________________________________________________________________________________
// Это есть аналог С++ класса с множ наследоваеием и мы в нем задействуем ещё пару полей
// для собственных нужд ( 3 vtbl имеет )
struct CCPPmgw1 {
	// Обязательные поля, интерфейсы С++
	ppi IInitDoneBase;
	ppi ILanguageExtenderBase;
	ppi ILocaleBase;
	// Мои собственные свойства и методы
	p ptrCPPobjIMemory;						// Ссылка на объект класса С++ МенеджерПамяти
	CMemoryManager* st_iMemory;				// Указатель на указатель МенеджерПамяти для D
	p ptrCPPobjIConnect;					// Ссылка на объект класса С++ Взаимодействия с 1С
	CAddInDefBase* st_iConnect;				// Указатель на указатель Взаимодействия с 1С для D
	CMgw1CIInitDoneBase          objCInt;
	CMgw1CILanguageExtenderBase objCLang;
	CMgw1CILocaleBase      objLocaleBase;
	p ptrCPPobjCIMsgBox;					// Ссылка на объект класса С++ Сообщения
	CIMsgBox* st_iMsgBox;					// Указатель на указатель Сообщения 1С
} 

CCPPmgw1* mgw1;		// Для mgwTest1

// Внимание!
// =========
// Имя компоненты должно совпадать с именем первого класса
// -------------------------------------------------------

// g_nameAddIn - строка где '|' перечислены всеимена классов
// 1С будет создавать экземпляры каждого класса сразу при подключении, а потом будет использовать их.
// Если вызвать первый раз Новый("AddIn.VK.myClass"), то будет использован уже созданный при подключении экземпляр,
// а если вызвать снова Новый("AddIn.VK.myClass") - то будет создан уже новый экземпляр класса. 
static const wstring g_nameAddIn = "LogConsole";

// Имя расширения, последнее поле в имени
// wstring CMgw1 = "CMgw1";
wstring  str1;

version(Windows) {
	import core.sys.windows.windows;  // GetProcAddress для Windows
}

//---------------------------------------------------------------------------//
// Функция названа неправильно. Это не имя класса, а имя AddIn, т.к. классов в этом AddIn
// может быть несколько. Используется в 1C:
// ПодключитьВнешнююКомпоненту(fullNameDll, "имяAddIn", ТипВнешнейКомпоненты.Native);
// ОбъектВК = Новый("AddIn.имяAddIn.ИмяЗарегКласса");   
export extern (C) p GetClassNames() { printf("hello.../n");	return cast(p)g_nameAddIn.ptr; }
//---------------------------------------------------------------------------//
export extern (C) p GetClassObject(wchar* wsName, p* pInterface) {
	if(*pInterface) return null;	// Проверка на готовность 1С

	debug {
		char[256] cbuf;	
		MessageBoxW(NULL, cast(const(wchar)*)wsName, ">>--21--GetClassObject()"w.ptr, 1);
	}
	
	// Создание классов разнесено специально, что бы показать, что они могут быть совршенны разные 
	// по структуре и размеру
	
	// Создаём класс -- mgwTest1
	if( 0 == wcscmp( wsName, "LogConsole"w.ptr ) ) {		// 1с запрашивает у нас класс mgwTest1
		// создаю основу объекта
		mgw1 = new CCPPmgw1;
		
		mgw1.objCInt 		= new CMgw1CIInitDoneBase();
		mgw1.objCLang 		= new CMgw1CILanguageExtenderBase();
		mgw1.objLocaleBase 	= new CMgw1CILocaleBase();
		
		// собираю объект клсса С++ в памяти
		mgw1.IInitDoneBase 			=       mgw1.objCInt.__vptr;
		mgw1.ILanguageExtenderBase 	=      mgw1.objCLang.__vptr;
		mgw1.ILocaleBase 			= mgw1.objLocaleBase.__vptr;
		
		// Верну в 1С указатель на созданный мной аналог C++ объекта класса
		*pInterface = mgw1;
		prNameExt = "LogConsole";
		debug {
			wsprintf(cast(wchar*)cbuf, cast( const(wchar)*)"*pInterface = %p objCInt = %p"w, *pInterface, mgw1.objCInt );
			MessageBoxW(null, cast(wchar*)cbuf, "", 0);
		}
		goto m1;
	}
	// В примере ВК C++ возврат int ... проще вернуть указатель, чем перекодировать его в int
m1:	
	return *pInterface;
}
//---------------------------------------------------------------------------//
export extern (C) AppCapabilities SetPlatformCapabilities(AppCapabilities capabilities) {
	debug {
		MessageBoxA(null, "--24--SetPlatformCapabilities()".ptr, "aution".ptr, 0);
	}
	g_capabilities = capabilities;
	
	debug {
		char[256] cbuf;	
		wsprintf(cast(wchar*)cbuf, cast( const(wchar)*)"g_capabilities = %d capabilities = %d"w, g_capabilities, capabilities );
		MessageBoxW(null, cast(wchar*)cbuf, "", 0);
	}
    
	return AppCapabilities.eAppCapabilitiesLast;
}
//---------------------------------------------------------------------------//
export extern (C) long DestroyObject(p* pInterface)  {
	debug {
		MessageBoxW(NULL, "--22--DestroyObject()"w.ptr, NULL, 1);
	}

	// Уничтожим объект С++, Убрав ссылку на объект, отдаём его на уничтожение GC
	if(*pInterface == mgw1) 	mgw1 = null;
	
	debug {
		char[256] cbuf;	
		wsprintf(cast(wchar*)cbuf, cast( const(wchar)*)"*pInterface = %p mgw1 = %p"w, *pInterface, mgw1 );	
		MessageBoxW(null, cast(wchar*)cbuf, "", 0);
	}

	// Для С++ 1С тоже скажем, что уничтожили
	*pInterface = null;
	return 0;
}
//--------------- Загрузка DLL --------------------------------------------------//

__gshared HINSTANCE g_hInst;

extern (Windows) BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
    switch (ulReason)
    {
	case DLL_PROCESS_ATTACH:
	    g_hInst = hInstance;
	    dll_process_attach( hInstance, true );
	    break;
	case DLL_PROCESS_DETACH:
	    dll_process_detach( hInstance, true );
	    break;
	case DLL_THREAD_ATTACH:
	    dll_thread_attach( true, true );
	    break;
	case DLL_THREAD_DETACH:
	    dll_thread_detach( true, true );
	    break;
        default:
    }
    return true;
}

//--------------- Алиасы, константы и прочее --------------------------------------------------//

alias TGUID = byte[16];

struct TInterfaceVarRec { align (1):		// iface
    p				pInterfaceVal;
    TGUID			InterfaceID;
}
struct TStringVarRec {    align (1):		// str
    p				pstrVal;
    int				LongWord;	// количество байтов
}
struct TWideStringVarRec {align (1):		// wstr
    const(wchar)*	pwstrVal;   // указатель на wstring
    int				wstrLen;	// количество символов 
}
struct Ttm {
	int		tm_sec;		// секунд после минуты (с 0)
    int		tm_min;		// митуты после часа (с 0)
    int		tm_hour;	// часов поле дня (с 0)
    int		tm_mday;	// дней после месяца (с 1)
    int		tm_mon;		// месяцев после года (с 0)
    int		tm_year;	// лет после 1900 (с 0)
    int		tm_wday;	// дней после воскресения (с 0)
    int		tm_yday;	// дней с начала года (с 0)
    int		tm_isdst;	// Daylight Saving Time flag
}
union TVarEnum {
	byte					i8Val;				// = 1
	short					shortVal;			// = 2
	int						lVal;				// = 4
	int						intVal;				// = 4
	uint					uintVal;			// = 4
	long					llVal;				// = 8
	ubyte					ui8Val;				// = 1
	ushort					ushortVal;			// = 2
	uint					ulVal;				// = 4
	ulong					ullVal;				// = 8
	int						errCode;			// = 4
	int						hRes;				// = 4
	float					fltVal;				// = 4
	double					dblVal;				// = 8
	bool					bVal;				// = 1
	char					chVal;				// = 1
	wchar					wchVal;				// = 2
	double					data;				// = 8
	TGUID					IDVal;				// = 16
	p						pvarVal;			// = 4
	Ttm						tmVal;				// = 36
	TInterfaceVarRec		vtRecInterface;
	TStringVarRec			vtRecString;
	TWideStringVarRec		vtRecWideString; 
}
// Сам тип Variant, именно с ним работает 1С
struct TVariant {  align (1):
	TVarEnum	VarEnum;			// Объеденение, хранит одну актуальную позицию
	uint		cbElements;
	ushort		vt;					// Признак того, что за данные хранятся
}
// тип того, что лежит в Variant
enum ENUMVAR: ushort {   
    VTYPE_EMPTY,
    VTYPE_NULL,
    VTYPE_I2,                   //int16_t
    VTYPE_I4,                   //int32_t
    VTYPE_R4,                   //float
    VTYPE_R8,                   //double
    VTYPE_DATE,                 //DATE (double)
    VTYPE_TM,                   //struct tm
    VTYPE_PSTR,                 //struct str    string
    VTYPE_INTERFACE,            //struct iface
    VTYPE_ERROR,                //int32_t errCode
    VTYPE_BOOL,                 //bool
    VTYPE_VARIANT,              //struct _tVariant *
    VTYPE_I1,                   //int8_t
    VTYPE_UI1,                  //uint8_t
    VTYPE_UI2,                  //uint16_t
    VTYPE_UI4,                  //uint32_t
    VTYPE_I8,                   //int64_t
    VTYPE_UI8,                  //uint64_t
    VTYPE_INT,                  //int   Depends on architecture
    VTYPE_UINT,                 //unsigned int  Depends on architecture
    VTYPE_HRESULT,              //long hRes
    VTYPE_PWSTR,                //struct wstr
    VTYPE_BLOB,                 //means in struct str binary data contain
    VTYPE_CLSID,                //UUID
    VTYPE_STR_BLOB    	= 0xfff,
    VTYPE_VECTOR   		= 0x1000,
    VTYPE_ARRAY    		= 0x2000,
    VTYPE_BYREF    		= 0x4000,    //Only with struct _tVariant *
    VTYPE_RESERVED 		= 0x8000,
    VTYPE_ILLEGAL  		= 0xffff,
    VTYPE_ILLEGALMASKED	= 0xfff,
    VTYPE_TYPEMASK 		= 0xfff
}

// ======================= Функции расширения ======================
import core.sys.windows.wincon;
import asc1251;
import terminal;

static		Terminal _terminal;			// Объект Консоль
bool		f_isTerminal;				// Есть консоль или нету
bool		f_LogConsole;				// 1C запоминает, есть ли консоль

// Печатать строку
void consPrint(string s) {
	if(s.length == 0) return;
	if(s.length < 3) { writeln(toCON(s)); return; }
	if(s[1] == '|') {
		if(s[0] == 'R') _terminal.color(Color.red,    Color.DEFAULT);
		if(s[0] == 'G') _terminal.color(Color.green,  Color.DEFAULT);
		if(s[0] == 'Y') _terminal.color(Color.yellow, Color.DEFAULT);
		if(s[0] == 'B') _terminal.color(Color.blue,   Color.DEFAULT);
		writeln(toCON(s[2 .. $]));
		return;
	}
	_terminal.color(Color.DEFAULT, Color.DEFAULT);
	writeln(toCON(s));
}
// Инициализировать консоль
//__________________________
void consInit(bool sw) {
	// char[256] cbuf;
	// wsprintf(cast(wchar*)cbuf, cast( const(wchar)*)"consInit()  sw = %d, f_isTerminal = %d, f_LogConsole = %d"w.ptr, sw, f_isTerminal, f_LogConsole);	MessageBoxW(null, cast(wchar*)cbuf, "", 0);
	if(f_isTerminal) {
		if(!sw) {
			FreeConsole();
			f_isTerminal = false;
		}
	} else {
		if(sw) {
			AllocConsole();	freopen(cast(const(char*))"conout$".ptr, cast(const(char*))"w".ptr, core.stdc.stdio.stdout);
			_terminal = Terminal(ConsoleOutputType.cellular);
			_terminal.setTitle("Log console for 1C:Enterprase 8.3");
			f_isTerminal = true;
		}
	}
}

