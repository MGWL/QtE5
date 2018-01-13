module zdll;
/*
    MiniM

    ZDLL function interfaces

    Copyright (C) Eugene Karataev
    All rights reserved
	
	Implementation for D - Mohow Gennady MGW
	https://github.com/MGWL/QtE5 -- Qt-5, Forth, MiniMono, MiniM for D
	mgw@yandex.ru
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

/* non-string types */
const ushort MT_INT32 = 		0x0000FFFF;
const ushort MT_INT64 = 		0x0000FFFE;
const ushort MT_MT_DOUBLE = 	0x0000FFFD;

/* return error types */
const ZDLL_CALLBACK_DONE 		= 0;	/* all done ok */
const ZDLL_CALLBACK_SYNTAX 		= 1;	/* syntax errors in parameters */
const ZDLL_CALLBACK_PARAMETERS 	= 2;	/* some parameters null */
const ZDLL_CALLBACK_ARGC 		= 3;	/* argc is more than supported */
const ZDLL_CALLBACK_UNDEFINED 	= 4;	/* undefined variable */
const ZDLL_CALLBACK_ERROR 		= 5;	/* database or process error */
const ZDLL_CALLBACK_HALT 		= 6;	/* halt command was in minimono context */

enum WindowType {
		Widget = 0x00000000,
}
		
extern (Windows) {
	alias _MINIM_STR MINIM_STR;

/* callback functions */
alias void	function(MINIM_STR *errstr)						errstr_t;
alias int		function(MINIM_STR *str)						execute_t;
alias int		function(MINIM_STR *expr, MINIM_STR *res)		eval_t;
alias double	function(MINIM_STR *val)						getdouble_t;
alias int		function(MINIM_STR *val)						getint32_t;
alias long	function(MINIM_STR *val)						getint64_t;
alias void	function(MINIM_STR *val, MINIM_STR *str)		getstr_t;
alias void	function(double val, MINIM_STR *str)			setdouble_t;
alias void	function(int val, MINIM_STR *str)				setint32_t;
alias void	function(long val, MINIM_STR *str)				setint64_t;


alias int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	userfunc_t;
alias int  function(char *name, int argc, MINIM_STR **argv)	userdo_t;
alias int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	readlocal_t;
alias int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *value)	writelocal_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	readglobal_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *value)	writeglobal_t;
alias int  function(char *name, int argc, MINIM_STR **argv)	kill_local_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv)	kill_global_t;
alias int  function(int svn_test_value)set_test_t;
alias int  function(char *name, int argc, MINIM_STR **argv, int forward, MINIM_STR *result)	order_local_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv, int forward, MINIM_STR *result)	order_global_t;
alias int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	inc_local_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	inc_global_t;
alias int  function(char *name, int argc, MINIM_STR **argv, MINIM_STR *result)	data_local_t;
alias int  function(char *name, char *database, int argc, MINIM_STR **argv, MINIM_STR *result)	data_global_t;

/* callback function list */
struct _ZDLLCB { align (1):
    errstr_t			ErrStr;
    execute_t			Execute;
    eval_t				Eval;
    getdouble_t			GetDouble;
    getint32_t			GetInt32;
    getint64_t			GetInt64;
    getstr_t			GetStr;
    setdouble_t			SetDouble;
    setint32_t			SetInt32;
    setint64_t			SetInt64;
    userfunc_t			UserFunc;
    userdo_t			UserDo;
    readlocal_t			ReadLocal;
    writelocal_t		WriteLocal;
    readglobal_t		ReadGlobal;
    writeglobal_t		WriteGlobal;
    kill_local_t		KillLocal;
    kill_global_t		KillGlobal;
    set_test_t			SetTEST;
    order_local_t		OrderLocal;
    order_global_t		OrderGlobal;
    inc_local_t			IncLocal;
    inc_global_t		IncGlobal;
    data_local_t		DataLocal;
    data_global_t		DataGlobal;
}
alias _ZDLLCB ZDLLCB;
alias @nogc  int  function(ZDLLCB *cbfunc, MINIM_STR *result, int argc, MINIM_STR **argv)  zdllfunc_t;

struct _ZDLLFUNC
{
	 align (1):
    zdllfunc_t ZDLLFunc;
    char *FuncName;
}
alias _ZDLLFUNC ZDLLFUNC;
alias @nogc ZDLLFUNC * function() zdllfuncexport_t;
}


// Read and Write buffer
string fromResToString(MINIM_STR* mstr) { return cast(string)mstr.data[0..mstr.len].dup; }
bool   fromStringToExp(MINIM_STR* mstr, string exp) {
	try {
		ushort i; for(i = 0; i != exp.length; i++) { mstr.data[i] = exp[i]; } mstr.data[i] = 0; mstr.len = i;
	} catch(Throwable) {
		return false;
	}
	return true;
}

