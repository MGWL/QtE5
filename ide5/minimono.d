module minimono;
/*
	Source file is	MiniMono, MiniM Embedded Edition	(C) Eugene Karataev
	Header for the MiniMono DLL

	http://www.minimdb.com
	support@minimdb.com
	
	Implementation for D - Mohow Gennady MGW
	https://github.com/MGWL/QtE5 -- Qt-5, Forth, MiniMono, MiniM for D
	mgw@yandex.ru
*/
import core.runtime;	// Load DLL for Windows
import zdll;			//C		#include "zdll.h"

version(linux) {   
    import core.sys.posix.dlfcn;  // dlopen() и dlsym()
	extern (C) {
		void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);   }
		void* GetProcAddress(void* hLib, string nameFun)  { return dlsym(hLib, nameFun.ptr);     }
		bool  FreeLibrary(void* hModule) { return dlclose(hModule) == 0 ? false : true;  }
	}
}
version(Windows) {
	import core.sys.windows.windows;  // GetProcAddress for Windows
}
version (OSX) {
    private import core.sys.posix.dlfcn: dlclose, dlopen, dlsym, RTLD_GLOBAL, RTLD_LAZY;
        // On Linux these functions aren't defined in core.runtime, here and it was necessary to add.
        // It is strange why they aren't present there...
        // Probably they in the main Windows twist.
    private extern (C) void* rt_loadLibrary(const char* name) { return dlopen(name, RTLD_GLOBAL || RTLD_LAZY);  }
    private void* GetProcAddress(void* hLib, const char* nameFun) {  return dlsym(hLib, nameFun);    }
        bool  FreeLibrary(void* hModule) { return dlclose(hModule) == 0 ? false : true;  }
}

extern (Windows) {
	alias  int function(ZDLLCB *cbfunc, MINIM_STR **param_pairs, int param_pairs_count)		dlldevuse_t;
	alias  int function(ZDLLCB *cbfunc, int len, int timeout, MINIM_STR *result)			dlldevreadstr_t;
	alias  int function(ZDLLCB *cbfunc, int timeout, int *result)							dlldevreadchar_t;
	alias  int function(ZDLLCB *cbfunc, MINIM_STR *str)										dlldevwritestr_t;
	alias  int function(ZDLLCB *cbfunc, int _char)											dlldevwritechar_t;
	alias  int function(ZDLLCB *cbfunc)														dlldevwritenl_t;
	alias  int function(ZDLLCB *cbfunc)														dlldevwriteff_t;
	alias  int function(ZDLLCB *cbfunc, int tabcount)										dlldevwritetab_t;
	alias  int function(ZDLLCB *cbfunc, int *result)										dlldevgetx_t;
	alias  int function(ZDLLCB *cbfunc, int value)											dlldevsetx_t;
	alias  int function(ZDLLCB *cbfunc, MINIM_STR *result)									dlldevgetkey_t;
	alias  int function(ZDLLCB *cbfunc, MINIM_STR *value)									dlldevsetkey_t;
	alias  int function(ZDLLCB *cbfunc, int *result)										dlldevzeof_t;
}
struct tagMINIMONOVM
{
 align (1):
	immutable(char)*	DataFile;	// file of the database
	int ReadOnly;					// database in read only mode or write enabled
	int JournalingEnabled;			// is database journaled or not, journaling is required for transactions
	int LockAreaSize;				// size of lock table in megabytes
	int RoutineCacheSize;			// size of routine cache in megabytes
	int DeviceTableSize;			// number of devices can be used
	int DeviceNameSize;				// length of device name in bytes
	int DBCacheSize;				// size of global cache in megabytes
	int NullSubscripts;				// allow (1) or not (0) null subscripts
	int TransactLevelLimit;			// number of transaction levels allowed
	int TrapOnEof;					// raise error on end of file or not
	int FrameCount;					// number of stack frames
	int JournalCache;				// size of journal cache in megabytes;
	immutable(char)* LocaleFileName;// file name with MiniM locale definition or null
	int ProcessStorage;				// size of area for local variables in megabytes
	// Functions to call virtual machine
	ZDLLCB* cbfunc;					// This pointer must be assigned by CreateMiniMonoVM function
	dlldevuse_t 					Use;
	dlldevreadstr_t 				ReadStr;
	dlldevreadchar_t 				ReadChar;
	dlldevwritestr_t 				WriteStr;
	dlldevwritechar_t 				WriteChar;
	dlldevwritenl_t 				WriteNL;
	dlldevwriteff_t 				WriteFF;
	dlldevwritetab_t 				WriteTab;
	dlldevgetx_t 					GetX;
	dlldevgetx_t 					GetY;
	dlldevsetx_t 					SetX;
	dlldevsetx_t 					SetY;
	dlldevgetkey_t 					GetKEY;
	dlldevsetkey_t 					SetKEY;
	dlldevzeof_t 					GetZEOF;
	dlldevgetkey_t 					GetZA;
	dlldevgetkey_t 					GetZB;
	void* myAdr;
}
alias tagMINIMONOVM MINIMONOVM;

const	MINIMONO_SUCCESS 		= 0; 
const	MINIMONO_CREATED 		= 1;
const	MINIMONO_CREATEFAILED 	= 2;

alias 	void*			HMNMConnect;

extern (Windows) {
	// -------------------- MiniMono ------------------------
	alias pure @nogc nothrow int 	function(MINIMONOVM *init)  								createminimonovm_t;
	alias pure @nogc nothrow void	function()  			  									freeminimonovm_t;
	alias pure @nogc nothrow void	function(MINIMONOVM *init)  								getdefaultsettingsvm_t;
	alias pure @nogc nothrow void	function(int set_break)										ctrlbreakvm_t;

	alias pure @nogc nothrow int  	function(MINIM_STR *List, int pos, MINIM_STR *Element)		mnmlistget_t;
	alias pure @nogc nothrow int  	function(MINIM_STR *List, int pos, MINIM_STR *Element)		mnmlistset_t;
	alias pure @nogc nothrow int  	function(MINIM_STR *List)									mnmlistlength_t;
	alias pure @nogc nothrow int 	function(MINIM_STR *Source, MINIM_STR *Target)				mnmtext_t;
	// -------------------- MiniMsc ------------------------
	alias pure @nogc nothrow int	function(HMNMConnect pConnect)								MNMConnectClose_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect)								MNMConnectOpen_t;
	alias pure @nogc nothrow HMNMConnect	function(char* server, int port, char* database)	MNMCreateConnect_t;
	alias pure @nogc nothrow void	function(HMNMConnect pConnect)								MNMDestroyConnect_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect, MINIM_STR* Commands)			MNMExecute_t;
	alias pure @nogc nothrow void	function(HMNMConnect pConnect, MINIM_STR* pError)			MNMGetLastError_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect, MINIM_STR* VarName)			MNMKill_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect, MINIM_STR* Expression, 		MINIM_STR* Result)	MNMRead_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect, MINIM_STR* VarName, MINIM_STR* VarValue)	MNMWrite_t;
	alias pure @nogc nothrow void	function(HMNMConnect pConnect, void* pProc)					MNMSetOutput_t;
	alias pure @nogc nothrow int	function(HMNMConnect pConnect, MINIM_STR* Commands)			MNMExecuteOutput_t;
	alias pure @nogc nothrow void	function(HMNMConnect pConnect, void* pProc)					MNMSetCallback_t;
	
}

public createminimonovm_t			CreateMiniMonoVM;
public getdefaultsettingsvm_t		GetDefaultSettingsVM;
public freeminimonovm_t				FreeMiniMonoVM;

public mnmtext_t					MNMText;
public mnmlistlength_t				MNMListLength;
public mnmlistset_t					MNMListSet;
public mnmlistget_t					MNMListGet;

// -------------------- MiniMsc ------------------------
public MNMConnectClose_t			MNMConnectClose;
public MNMConnectOpen_t				MNMConnectOpen;
public MNMCreateConnect_t			MNMCreateConnect;
public MNMDestroyConnect_t			MNMDestroyConnect;
public MNMExecute_t					MNMExecute;
public MNMGetLastError_t			MNMGetLastError;
public MNMKill_t					MNMKill;
public MNMRead_t					MNMRead;
public MNMWrite_t					MNMWrite;
public MNMSetOutput_t				MNMSetOutput;
public MNMSetCallback_t				MNMSetCallback;
public MNMExecuteOutput_t			MNMExecuteOutput;

version(Windows) {
	auto libMiniMono = "minimono.dll";
	auto libMiniMsc  = "minimsc.dll";
}
version(linux) {   
	auto libMiniMono = "libminimono.so";
	auto libMiniMsc  = "libminimsc.so";
}
version (OSX) {
        auto libMiniMono = "libminimono.dylib";
        auto libMiniMsc  = "libminimsc.dylib";
}

private static void* hMono;
private static void* hMsc;

public int loadMiniMonoDll(string lib) {
	hMono = Runtime.loadLibrary(lib);
		if(!hMono) return MINIMONO_CREATEFAILED;
	
	CreateMiniMonoVM = cast(createminimonovm_t)GetProcAddress(hMono, "CreateMiniMonoVM");
		if(!CreateMiniMonoVM) return MINIMONO_CREATEFAILED;
	GetDefaultSettingsVM = cast(getdefaultsettingsvm_t)GetProcAddress(hMono, "GetDefaultSettingsVM");
		if(!GetDefaultSettingsVM) return MINIMONO_CREATEFAILED;
	FreeMiniMonoVM = cast(freeminimonovm_t)GetProcAddress(hMono, "FreeMiniMonoVM");
		if(!FreeMiniMonoVM) return MINIMONO_CREATEFAILED;
	// ---- work of list --------------------
	MNMListLength = cast(mnmlistlength_t)GetProcAddress(hMono, "MNMListLength");
		if(!MNMListLength) return MINIMONO_CREATEFAILED;
	MNMText = cast(mnmtext_t)GetProcAddress(hMono, "MNMText");
		if(!MNMText) return MINIMONO_CREATEFAILED;
	MNMListSet = cast(mnmlistset_t)GetProcAddress(hMono, "MNMListSet");
		if(!MNMListSet) return MINIMONO_CREATEFAILED;
	MNMListGet = cast(mnmlistget_t)GetProcAddress(hMono, "MNMListGet");
		if(!MNMListGet) return MINIMONO_CREATEFAILED;
	return MINIMONO_SUCCESS;
}
public int freeMiniMonoDll() {
	return FreeLibrary( hMono );
}
public int loadMiniMscDll(string lib) {
	hMsc = Runtime.loadLibrary(lib);
		if(!hMsc) return MINIMONO_CREATEFAILED;
	/* 1) disconnect from MiniM server */
	MNMConnectClose = cast(MNMConnectClose_t)GetProcAddress(hMsc, "MNMConnectClose");
		if(!MNMConnectClose) return MINIMONO_CREATEFAILED;
	/* connect to MiniM server */
	MNMConnectOpen = cast(MNMConnectOpen_t)GetProcAddress(hMsc, "MNMConnectOpen");
		if(!MNMConnectOpen) return MINIMONO_CREATEFAILED;
	/* создать связь с Minim */
	MNMCreateConnect = cast(MNMCreateConnect_t)GetProcAddress(hMsc, "MNMCreateConnect");
		if(!MNMCreateConnect) return MINIMONO_CREATEFAILED;
	/* destroy connect object */
	MNMDestroyConnect = cast(MNMDestroyConnect_t)GetProcAddress(hMsc, "MNMDestroyConnect");
		if(!MNMDestroyConnect) return MINIMONO_CREATEFAILED;
	/* execute commands */
	MNMExecute = cast(MNMExecute_t)GetProcAddress(hMsc, "MNMExecute");
		if(!MNMExecute) return MINIMONO_CREATEFAILED;
	/* get last error description */
	MNMGetLastError = cast(MNMGetLastError_t)GetProcAddress(hMsc, "MNMGetLastError");
		if(!MNMGetLastError) return MINIMONO_CREATEFAILED;
	/* kill variable */
	MNMKill = cast(MNMKill_t)GetProcAddress(hMsc, "MNMKill");
		if(!MNMKill) return MINIMONO_CREATEFAILED;
	/* read M expression */
	MNMRead = cast(MNMRead_t)GetProcAddress(hMsc, "MNMRead");
		if(!MNMRead) return MINIMONO_CREATEFAILED;
	/* write M variable */
	MNMWrite = cast(MNMWrite_t)GetProcAddress(hMsc, "MNMWrite");
		if(!MNMWrite) return MINIMONO_CREATEFAILED;
	/* set callback for ExecuteOutpet */
	MNMSetOutput = cast(MNMSetOutput_t)GetProcAddress(hMsc, "MNMSetOutput");
		if(!MNMSetOutput) return MINIMONO_CREATEFAILED;
	MNMSetCallback = cast(MNMSetCallback_t)GetProcAddress(hMsc, "MNMSetCallback");
		if(!MNMSetCallback) return MINIMONO_CREATEFAILED;
	MNMExecuteOutput = cast(MNMExecuteOutput_t)GetProcAddress(hMsc, "MNMExecuteOutput");
		if(!MNMExecuteOutput) return MINIMONO_CREATEFAILED;
	return MINIMONO_SUCCESS;
}

