import std.c.stdio;
import forth;			// Forth

export extern (C) void dll_initForth() { initForth(); }

export extern (C) void dll_includedForth(char *nameFileForth) { includedForth(nameFileForth); }

// Для VBA (Excel, VB6)
export extern (Windows) void dll_winitForth() { initForth(); }

export extern (Windows) void dll_wincludedForth(char *nameFileForth) { includedForth(nameFileForth); }

export extern (Windows) void dll_setCommonAdr(int n, pp adr) { setCommonAdr(n, adr); }

export extern (Windows) void dll_getCommonAdr(int n) { getCommonAdr(n); }

export extern (Windows) void dll_evalForth(char *strForth) { evalForth(strForth); }

// VBA - делает динамический буфер для строки в момент вызова функции. Для обмана
// такого поведения совмещаем две функции Форта с одной для VBA
export extern (Windows) void dll_evalForthSetCA(char *strForth, int n, pp adr) { 
	setCommonAdr(n, adr); evalForth(strForth); 
}
