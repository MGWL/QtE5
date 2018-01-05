module minimsc;
/*

    MiniM

    MiniM Server Connect
    DLL interface

    Copyright (C) Eugene Karataev
    All rights reserved

*/

struct _MINIMSTR { align (1):
    ushort len;
    ubyte [32768]data;
}

extern (C):
alias 		_MINIMSTR 		MINIMSTR;
alias 		void*			HMNMConnect;

extern (Windows):
HMNMConnect  MNMCreateConnect(char *server, int port, char *database);

/* destroy connect object */
//C     void MNMSCPROC MNMDestroyConnect( HMNMConnect pConnect);
// void  MNMDestroyConnect(HMNMConnect pConnect);

// /* connect to MiniM server */
// C     int MNMSCPROC MNMConnectOpen( HMNMConnect pConnect);
// int  MNMConnectOpen(HMNMConnect pConnect);

// /* disconnect from MiniM server */
// C     int MNMSCPROC MNMConnectClose( HMNMConnect pConnect);
// int  MNMConnectClose(HMNMConnect pConnect);

/* execute commands */
//C     int MNMSCPROC MNMExecute( HMNMConnect pConnect, MINIMSTR* Commands);
// int  MNMExecute(HMNMConnect pConnect, MINIMSTR *Commands);
/* get last error description */
//C     void MNMSCPROC MNMGetLastError( HMNMConnect pConnect, MINIMSTR* pError);
// void  MNMGetLastError(HMNMConnect pConnect, MINIMSTR *pError);

/* kill variable */
//C     int MNMSCPROC MNMKill( HMNMConnect pConnect, MINIMSTR* VarName);
//int  MNMKill(HMNMConnect pConnect, MINIMSTR *VarName);




/* read M expression */
//C     int MNMSCPROC MNMRead( HMNMConnect pConnect, MINIMSTR* Expression,
//C       MINIMSTR* Result);
// int  MNMRead(HMNMConnect pConnect, MINIMSTR *Expression, MINIMSTR *Result);

/* write M variable */
//C     int MNMSCPROC MNMWrite( HMNMConnect pConnect, MINIMSTR* VarName,
//C       MINIMSTR* VarValue);
// int  MNMWrite(HMNMConnect pConnect, MINIMSTR *VarName, MINIMSTR *VarValue);


/* type of procedure to intercept output */
//C     typedef void ( __stdcall* mnmoutputproc_t )( HMNMConnect pConnect,
//C       MINIMSTR* Value );
extern (C):
alias void  function(HMNMConnect pConnect, MINIMSTR *Value)mnmoutputproc_t;

/* set procedure to intercept output */
//C     void MNMSCPROC MNMSetOutput( HMNMConnect pConnect, mnmoutputproc_t pProc);
extern (Windows):
void  MNMSetOutput(HMNMConnect pConnect, mnmoutputproc_t pProc);

/* execute commands with output interception */
//C     int MNMSCPROC MNMExecuteOutput( HMNMConnect pConnect, MINIMSTR* Commands);
int  MNMExecuteOutput(HMNMConnect pConnect, MINIMSTR *Commands);

/* type of procedure to accept group read data */
//C     typedef void ( __stdcall* mnmgroupreadproc_t)( HMNMConnect pConnect,
//C       MINIMSTR* Value);
extern (C):
alias void  function(HMNMConnect pConnect, MINIMSTR *Value)mnmgroupreadproc_t;

//C     void MNMSCPROC MNMSetGroupRead( HMNMConnect pConnect, mnmgroupreadproc_t pProc);
extern (Windows):
void  MNMSetGroupRead(HMNMConnect pConnect, mnmgroupreadproc_t pProc);

/* type of procedure ho handle callback call */
//C     typedef void ( __stdcall* mnmcallbackproc_t)( HMNMConnect pConnect,
//C       MINIMSTR* Command, MINIMSTR* Answer);
extern (C):
alias void  function(HMNMConnect pConnect, MINIMSTR *Command, MINIMSTR *Answer)mnmcallbackproc_t;

//C     void MNMSCPROC MNMSetCallback( HMNMConnect pConnect,
//C       mnmcallbackproc_t pProc);
extern (Windows):
void  MNMSetCallback(HMNMConnect pConnect, mnmcallbackproc_t pProc);

/* get list element as $listget(list,pos) */
//C     int MNMSCPROC MNMListGet( MINIMSTR* List, int pos, MINIMSTR* Element);
int  MNMListGet(MINIMSTR *List, int pos, MINIMSTR *Element);

/* set list element as s $list(list,pos)=element */
//C     int MNMSCPROC MNMListSet( MINIMSTR* List, int pos, MINIMSTR* Element);
int  MNMListSet(MINIMSTR *List, int pos, MINIMSTR *Element);

/* return count of list elements */
//C     int MNMSCPROC MNMListLength( MINIMSTR* List);
int  MNMListLength(MINIMSTR *List);

/*
    decorate '"' if need

    "abcd"      ->   "abcd"
    "ab\"cd"    ->   "ab""cd"
    "ab\r\ncd"  ->   "ab"_$C(13,10)_"cd"

    return 0 if Target exeed MINIMSTR limit
*/
//C     int MNMSCPROC MNMText( MINIMSTR* Source, MINIMSTR* Target);
int  MNMText(MINIMSTR *Source, MINIMSTR *Target);

__EOF__

MNMConnectClose		// Закрыть сессию
MNMConnectOpen		// Открыть сессию
MNMCreateConnect	// Заполнить структуру на открытие
MNMDestroyConnect	// Уничтожить структуру на открытие
MNMExecute			// Выполнить строку М - без визуализации
MNMExecuteOutput	// Выполнить строку М - с визуализаций через MNMSetOutput
MNMGetLastError		// Прочитать последнию ошибку
MNMKill				// Уничтожить глобаль
MNMListGet			// Взять список
MNMListLength		// Длина списка
MNMListSet			// Записать список
MNMRead				// Прочитать выражение
MNMSetCallback
MNMSetGroupRead
MNMSetOutput		// Установить процеду отображения вывода после MNMExecuteOutput
MNMText				// Буфер в строку
MNMWrite			// Записать выражение
