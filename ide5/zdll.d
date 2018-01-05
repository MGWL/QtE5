module zdll;
/*
    MiniM

    ZDLL function interfaces

    Copyright (C) Eugene Karataev
    All rights reserved
*/

/* max string size */
const MINIM_STR_MAX =  32 * 1024;

struct _MINIM_STR { align (1):
	union {
		ushort len;
		ushort type;
	}
	ubyte[MINIM_STR_MAX] data;
}

const ushort MT_INT32 = 0x0000FFFF;
const ushort MT_INT64 = 0x0000FFFE;
const ushort MT_MT_DOUBLE = 0x0000FFFD;

extern (Windows) {
	alias _MINIM_STR MINIM_STR;
//C     #pragma pack(pop)

/* non-string types */
//C     #define MT_INT32      ( 0x0000FFFF )
//C     #define MT_INT64      ( 0x0000FFFE )
//C     #define MT_DOUBLE     ( 0x0000FFFD )

/* callback functions */
//C     typedef void ( STDCALL * errstr_t)( MINIM_STR* errstr);
alias @nogc void  function(MINIM_STR *errstr)		errstr_t;
//C     typedef int ( STDCALL * execute_t)( MINIM_STR* str);
alias @nogc int  function(MINIM_STR *str)		execute_t;
//C     typedef int ( STDCALL * eval_t)( MINIM_STR* expr, MINIM_STR* res);
alias @nogc int  function(MINIM_STR *expr, MINIM_STR *res)		eval_t;
//C     typedef double ( STDCALL * getdouble_t)( MINIM_STR* val);
alias @nogc double  function(MINIM_STR *val)		getdouble_t;
//C     typedef long ( STDCALL * getint32_t)( MINIM_STR* val);
alias @nogc int  function(MINIM_STR *val)		getint32_t;
//C     typedef __int64 ( STDCALL * getint64_t)( MINIM_STR* val);
alias @nogc long  function(MINIM_STR *val)		getint64_t;
//C     typedef void ( STDCALL * getstr_t)( MINIM_STR* val, MINIM_STR* str);
alias @nogc void  function(MINIM_STR *val, MINIM_STR *str)		getstr_t;
//C     typedef void ( STDCALL * setdouble_t)( double val, MINIM_STR* str);
alias @nogc void  function(double val, MINIM_STR *str)		setdouble_t;
//C     typedef void ( STDCALL * setint32_t)( long val, MINIM_STR* str);
alias @nogc void  function(int val, MINIM_STR *str)		setint32_t;
//C     typedef void ( STDCALL * setint64_t)( __int64 val, MINIM_STR* str);
alias @nogc void  function(long val, MINIM_STR *str)		setint64_t;

/* return error types */

/* all done ok */
//C     #define ZDLL_CALLBACK_DONE       ( 0 )
/* syntax errors in parameters */
//C     #define ZDLL_CALLBACK_SYNTAX     ( 1 )
/* some parameters null */
//C     #define ZDLL_CALLBACK_PARAMETERS ( 2 )
/* argc is more than supported */
//C     #define ZDLL_CALLBACK_ARGC       ( 3 )
/* undefined variable */
//C     #define ZDLL_CALLBACK_UNDEFINED  ( 4 )
/* database or process error */
//C     #define ZDLL_CALLBACK_ERROR      ( 5 )
/* halt command was in minimono context */
//C     #define ZDLL_CALLBACK_HALT       ( 6 )

//C     typedef int (STDCALL * userfunc_t)( const char* name, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	userfunc_t;
//C     typedef int (STDCALL * userdo_t)( const char* name, int argc,
//C       MINIM_STR** argv);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv)	userdo_t;
//C     typedef int (STDCALL * readlocal_t)( const char* name, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	readlocal_t;
//C     typedef int (STDCALL * writelocal_t)( const char* name, int argc,
//C       MINIM_STR** argv, MINIM_STR* value);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *value)	writelocal_t;
//C     typedef int (STDCALL * readglobal_t)( const char* name, const char* database,
//C       int argc, MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	readglobal_t;
//C     typedef int (STDCALL * writeglobal_t)( const char* name, const char* database,
//C       int argc, MINIM_STR** argv, MINIM_STR* value);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *value)	writeglobal_t;
//C     typedef int (STDCALL * kill_local_t)( const char* name, int argc,
//C       MINIM_STR** argv);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv)	kill_local_t;
//C     typedef int (STDCALL * kill_global_t)( const char* name,
//C       const char* database, int argc, MINIM_STR** argv);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv)	kill_global_t;
//C     typedef int (STDCALL * set_test_t)( int svn_test_value);
alias @nogc int  function(int svn_test_value)set_test_t;
//C     typedef int (STDCALL * order_local_t)( const char* name, int argc,
//C       MINIM_STR** argv, int forward, MINIM_STR* result);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, int forward, MINIM_STR *result)	order_local_t;
//C     typedef int (STDCALL * order_global_t)( const char* name,
//C       const char* database, int argc, MINIM_STR** argv, int forward,
//C       MINIM_STR* result);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv, int forward, MINIM_STR *result)	order_global_t;
//C     typedef int (STDCALL * inc_local_t)( const char* name, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	inc_local_t;
//C     typedef int (STDCALL * inc_global_t)( const char* name,
//C       const char* database, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	inc_global_t;
//C     typedef int (STDCALL * data_local_t)( const char* name, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	data_local_t;
//C     typedef int (STDCALL * data_global_t)( const char* name,
//C       const char* database, int argc,
//C       MINIM_STR** argv, MINIM_STR* result);
alias @nogc int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	data_global_t;

/* callback function list */
//C     #pragma pack(push,1)
//C     typedef struct _ZDLLCB
//C     {
//C       errstr_t        ErrStr;
//C       execute_t       Execute;
//C       eval_t          Eval;
//C       getdouble_t     GetDouble;
//C       getint32_t      GetInt32;
//C       getint64_t      GetInt64;
//C       getstr_t        GetStr;
//C       setdouble_t     SetDouble;
//C       setint32_t      SetInt32;
//C       setint64_t      SetInt64;
//C       userfunc_t      UserFunc;
//C       userdo_t        UserDo;
//C       readlocal_t     ReadLocal;
//C       writelocal_t    WriteLocal;
//C       readglobal_t    ReadGlobal;
//C       writeglobal_t   WriteGlobal;
//C       kill_local_t    KillLocal;
//C       kill_global_t   KillGlobal;
//C       set_test_t      SetTEST;
//C       order_local_t   OrderLocal;
//C       order_global_t  OrderGlobal;
//C       inc_local_t     IncLocal;
//C       inc_global_t    IncGlobal;
//C       data_local_t    DataLocal;
//C       data_global_t   DataGlobal;
//C     } ZDLLCB;
struct _ZDLLCB { align (1):
    errstr_t ErrStr;
    execute_t Execute;
    eval_t Eval;
    getdouble_t GetDouble;
    getint32_t GetInt32;
    getint64_t GetInt64;
    getstr_t GetStr;
    setdouble_t SetDouble;
    setint32_t SetInt32;
    setint64_t SetInt64;
    userfunc_t UserFunc;
    userdo_t UserDo;
    readlocal_t ReadLocal;
    writelocal_t WriteLocal;
    readglobal_t ReadGlobal;
    writeglobal_t WriteGlobal;
    kill_local_t KillLocal;
    kill_global_t KillGlobal;
    set_test_t SetTEST;
    order_local_t OrderLocal;
    order_global_t OrderGlobal;
    inc_local_t IncLocal;
    inc_global_t IncGlobal;
    data_local_t DataLocal;
    data_global_t DataGlobal;
}
alias _ZDLLCB ZDLLCB;
//C     #pragma pack(pop)

/* ZDLL function */
/* each function accept variable-lenght arguments list */
//C     typedef int ( STDCALL * zdllfunc_t)( ZDLLCB* cbfunc, MINIM_STR* result,
//C       int argc, MINIM_STR** argv);
alias @nogc  int  function(ZDLLCB *cbfunc, MINIM_STR *result, int argc, MINIM_STR **argv)  zdllfunc_t;

/* one ZDLL function definition */
//C     #pragma pack(push,1)
//C     typedef struct _ZDLLFUNC
//C     {
//C       zdllfunc_t ZDLLFunc;
//C       char*      FuncName;
//C     } ZDLLFUNC;
struct _ZDLLFUNC
{
	 align (1):
    zdllfunc_t ZDLLFunc;
    char *FuncName;
}
alias _ZDLLFUNC ZDLLFUNC;
//C     #pragma pack(pop)

/* ZDLL exported function */
//C     typedef ZDLLFUNC* ( STDCALL * zdllfuncexport_t)( void);
alias @nogc ZDLLFUNC * function() zdllfuncexport_t;
}


// Упрощение записи и чтения в буфер
string fromResToString(MINIM_STR* mstr) { return cast(string)mstr.data[0..mstr.len].dup; }
bool   fromStringToExp(MINIM_STR* mstr, string exp) {
	try {
		ushort i; for(i = 0; i != exp.length; i++) { mstr.data[i] = exp[i]; } mstr.data[i] = 0; mstr.len = i;
	} catch(Throwable) {
		return false;
	}
	return true;
}


/*

    ZDLL module should export function with name "ZDLL" as zdllfuncexport_t.
    This function should return pointer to array of structures ZDLLFUNC,
    with zeroed last.

    See for comments ZDLL examples in minim zdll subdirectory.

*/

//C     #ifdef __cplusplus
//C     }
//C     #endif

/* end of __ZDLL_H__ */
//C     #endif
