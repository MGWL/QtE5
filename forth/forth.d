// Written in the D programming language. Мохов Геннадий Владимирович 2015
// Версия v1.0 - 30.04.15 10:45
// Попытка перенести на asm D форт реализацию >SPF-Fork 2005-2013 mOleg mOlegg@ya.ru
/**
  * <b><u>SPF-Fork 2005-2013 mOleg mOlegg@ya.ru для D.</u></b>
  */

// initForth() - инициализировать Форт
// evalForth(string str) - выполнить строку как строку Форта
// includedForth(string NameFileForth) - Загрузить и выполнить файл Форта
// pp asr = getCommonAdr(int n) - Вернуть из общей таблицы (ячейка n) значение
// setCommonAdr(int n, pp adr) - Записать в ячейку общей таблицы n значение равное adr
// adrContext() - Указатель на adr[256] со списками слов
// extern (C) pp executeForth(pp adrexec, uint kolPar, ...) {

// История изменений
// 28.06.15 - BMOVE Копировать байты 
// 05.07.15 - Пропускать в поиске слова из одних цифр 
// 06.07.15 - Добавил DDUP
// 10.04.16 - Исправлена ошибка в EXECUTEFROMD
 
module forth;

import std.stdio;
import core.stdc.stdio : printf;
import std.conv;
// import std.c.stdio;

int kolPer;

alias	void*	p;		// Просто указатель
alias	void**	pp;		// Указатель на указатель
alias  ubyte*	pb;		// Указатель на байт
alias   char* 	ps;   	// Указатель на char

// Стеки и кодофайл выделены в хипе и не пересекаются
private const CELL = 4;
private const sizeCodeFile = 30000; // Количество CELL для кодофайла
private const sizeStack    =  1000; // Количество CELL для стеков

// Таблица общих для F и D адресов. В неё можно помещать адреса переменных или функций.
// Контроля над тем, что лежит нет!
private pp[100] commonTable;

// Выдать адрес context из структуры forth
void* adrContext() {return gpcb.context; }
// Выдать адрес начала стека SD
void* adr_cSD() {	return gpcb.csd; }
// Выдать адрес сохраненого стека SP
void* adr_SD() {	return gpcb.saveEBP;  }

// Выдать адрес начала кодофайла
void* adr_begKDF() {	return gpcb.akdf;  }
// Выдать адрес HERE
void* adr_here()   {	return gpcb.here;  }
// Выдать адрес конца кодофайла
void* adr_endKDF() {	return gpcb.akdf + sizeCodeFile;  }

// Контекст Fotrh процесса
private struct NPcb {
	pp 	csd; 					// указатель на начало стека SD
	pp 	csr; 					// указатель на начало стека SR
	pp 	csc; 					// указатель на начало стека SC
	pp	akdf;					// указатель на начало кодофайла
	pb 	here; 					// указатель начала свободной области кодофайла
	pp 	latest;					// указатель на аоследнее скомпилированное слово
	pp	context;				// указатель на массив из 256 cell в каждой ячейке context на эту букву
	pp	executeFromD;			// ' EXECUTEFROMD
	pp	state;					// текущее состояние компиляции 0=интерпретация
	byte imm;					// запомнить состояние IMM в последнем FIND
	
	pp adrCommonTable;			// адрес общий таблицы

	ps	In;                     // указатель на место интерпретации в вход. буфеpе
    ps	Tib; 					// указатель на сам входной буфеp
	int dlTib;					// Размер строки прочитанной в Tib
	// Регистры сохранения состояния
	pp saveEBP;          		// Место под EBP форта
	pp saveEAX;          		// Место под EAX форта
	pp saveESI;          		// Место под ESI форта
	pp saveEDI;          		// Место под EDI форта
}

/* private */ NPcb gpcb;						// Глобальное определение блока управления
private pb	kdf;						// Сюда будем компилировать код 
private pp  stSD, stSR, stSL;			// Указатели на стеки

private ubyte[1000] tib;				// Буфер строки для иекстового разбора

// Распечатать дамп памяти для указанного адреса
void dumpAdr(pp adr) {
	import std.stdio: writefln;
	ubyte* uk = cast(ubyte*)adr; ubyte* ur;
	for(int i; i !=5; i++) {
		ur = uk+(10*i);
		writefln("[%10s]  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X  %3X", 
			cast(void*)ur, 
				*(cast(pb)ur+0), *(cast(pb)ur+1), *(cast(pb)ur+2), *(cast(pb)ur+3), 
				*(cast(pb)ur+4), *(cast(pb)ur+5), *(cast(pb)ur+6), *(cast(pb)ur+7), 
				*(cast(pb)ur+8), *(cast(pb)ur+9) 
		);
		writefln("[%10s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]  [%1s]", 
			"--->", 
				*(cast(ps)ur+0), *(cast(ps)ur+1), *(cast(ps)ur+2), *(cast(ps)ur+3), 
				*(cast(ps)ur+4), *(cast(ps)ur+5), *(cast(ps)ur+6), *(cast(ps)ur+7), 
				*(cast(ps)ur+8), *(cast(ps)ur+9) 
		);
	}
}

// ======================== defkern.f ========================

// 01-02-2008 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// Сравнение.
// CODE = ( A B --> T/F )
private void f_RAWNO() {
	asm {		naked;
		xor EAX,dword ptr SS:[EBP];
		sub EAX, 1;
		sbb EAX,EAX;
		lea EBP,[EBP+CELL];
		ret;
	}
}
// Сравнение.
// CODE <> ( A B --> T/F )
private void f_NRAWNO() {
	asm {		naked;
		xor EAX,dword ptr SS:[EBP];
		neg EAX;
		sbb EAX,EAX;
		lea EBP,[EBP+CELL];
		ret;
	}
}
// Сравнение.
// CODE < ( A B --> T/F )
private void f_MENSHE() {
	asm {		naked;
		cmp EAX,dword ptr SS:[EBP];
		setle AL;
		and EAX, 1;
		dec EAX;
		lea EBP,[EBP+CELL];
		ret;
	}
}
// Сравнение.
// CODE > ( A B --> T/F )
private void f_BOLSHE() {
	asm {		naked;
		cmp EAX,dword ptr SS:[EBP];
		setge AL;
		and EAX, 1;
		dec EAX;
		lea EBP,[EBP+CELL];
		ret;
	}
}
// ничего не делать.
// CODE NOOP ( --> )
private void f_NOOP() {
	asm {		naked;
		ret;
	}
}
//  выполнить слова, представленного своим исполнимым адресом xt v
// CODE EXECUTE ( xt --> )
private void f_EXECUTE() {
	asm {		naked;
		mov EBX, EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp EBX;
	}
}
// выполнить слово, адрес которого хранится в ячейке памяти addr v
// то есть A@ EXECUTE
// CODE PERFORM ( addr --> )
// выполнить слово, адрес которого хранится в ячейке памяти addr √
// то есть A@ EXECUTE
private void f_PERFORM() {
	asm {		naked;
		mov EBX,dword ptr DS:[EAX];
		mov EAX,dword ptr SS:[EBP];
		lea EBP, [EBP+CELL];
		jmp EBX;
	}
}
// безусловный переход на адрес без возможности возврата за точку JMP
// аналог  RDROP >R EXIT
// CODE JUMP ( addr --> )
private void f_JUMP() {
	asm {		naked;
		mov dword ptr [ESP],EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
	}
}
// закончить выполнение текущего слова
// CODE EXIT ( --> )
private void f_EXIT() {
	asm {		naked;
		pop EDX;
		ret;
	}
}
// выйти из текущего слова, если флаг отличен от нуля v
// CODE ?EXIT ( flag --> )
private void f_Q_EXIT() {
	asm {		naked;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jz M1;
		lea ESP,[ESP];
M1:		
		ret;
	}
}
// выбор нужного варианта из списка v
// CODE (switch) ( n --> ) unfeasible
private void f_s_switch_s() {
	asm {		naked;
		pop EBX;
		mov ECX,dword ptr DS:[EBX];
		lea EDX,[EBX+ECX+CELL];
		push EDX;
		lea EAX,[EAX*4+CELL];
		cmp ECX,EAX;
		jbe M2;
		lea EBX,[EBX+EAX+CELL];
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp [EBX];
M2:		lea EBX,[EBX+CELL];
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jmp [EBX];
	}
}
// вернуть значение литерала скомпилированного в коде за (LIT)
// CODE (LIT) ( r: addr --> d: n ) unfeasible
private void h_s_LIT_s() {
	asm {		naked;
		pop EBX;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		mov EAX,dword ptr DS:[EBX];
		lea EBX,[EBX+CELL];
		jmp EBX;
	}
}
// вернуть значение литерала двойной длины скомпилированного в коде за (DLIT)
// CODE (DLIT) ( r: addr --> d ) unfeasible
private void f_s_DLIT_s() {
	asm {		naked;
		pop EBX;
		lea EBP,[EBP-CELL*2];
		mov dword ptr SS:[EBP+CELL],EAX;
		mov EDX,dword ptr DS:[EBX+CELL];
		mov EAX,dword ptr DS:[EBX];
		lea EBX,[EBX+CELL*2];
		mov dword ptr SS:[EBP],EDX;
		jmp EBX;
	}
}
// выполнить переход на адрес, значение которого содержится в коде за (BRANCH)
// CODE BRANCH ( r: addr --> ) unfeasible
private void f_BRANCH() {
	asm {		naked;
		pop EBX;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
	}
}
// условное ветвление по false, флаговое значение не удаляется
// адрес перехода хранится в коде следом за *BRANCH
// CODE *BRANCH ( r: addr d: flag --> flag ) unfeasible
private void f_Z_BRANCH() {
	asm {		naked;
		pop EBX;
		or EAX,EAX;
		jnz M3;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M3:		lea EBX,[EBX+CELL];
		jmp EBX;
	}
}
// условное ветвление, если флаговое значение меньше нуля
// флаговое значение не удаляется с вершины стека данных
// адрес перехода хранится в коде следом за -BRANCH
// CODE -BRANCH ( r: addr d: flag --> flag ) unfeasible
private void f_N_BRANCH() {
	asm {		naked;
		pop EBX;
		cmp EAX,0;
		js M4;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M4:		lea EBX,[EBX+CELL];
		jmp EBX;
	}
}
// условное ветвление, если флаговое значение нуль
// адрес перехода хранится в коде следом за ?BRANCH
// CODE ?BRANCH ( r: addr d: flag --> ) unfeasible
private void f_ZW_BRANCH() {
	asm {		naked;
		pop EBX;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jnz M5;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M5:		lea EBX,[EBX+CELL];
		jmp EBX;
	}
}
// условное ветвление, если флаговое значение отлично от нуля
// адрес перехода хранится в коде следом за N?BRANCH
// CODE N?BRANCH ( r: addr d: flag --> ) unfeasible
private void f_N_ZW_BRANCH() {
	asm {		naked;
		pop EBX;
		or EAX,EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		jz M6;
		add EBX,dword ptr DS:[EBX];
		jmp EBX;
M6:		lea EBX,[EBX+CELL];
		jmp EBX;
	}
}

// ======================== dtc.f ========================

// 01-02-2008 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// вернуть адрес данных, следующих в коде за (CREATE)
// CODE (CREATE) ( r: addr --> addr )
private void f_s_CREATE_s() {
	asm {		naked;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		pop EAX;
		ret;
	}
}
// вернуть содержимое, хранимое в коде за скомпилированным (CONST)
// на вершину стека данных
// CODE (CONST) ( r: addr --> n )
private void f_s_CONST_s() {
	asm {		naked;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		pop EBX;
		mov EAX,dword ptr DS:[EBX];
		ret;
	}
}
// извлечь содержимое переменной, находящейся в коде за скомпилированным
// (value) (с неким фиксированным смещением, определяемым # методов),
// вернуть значение на вершину стека данных
// : (value) ( r: addr --> n ) R> [ 2 TOKEN * LIT, ] + @ ;
// CODE (value) ( --> n )
private void f_s_value_s() {
	asm {		naked;
		lea EBP,[EBP-CELL];
		mov dword ptr SS:[EBP],EAX;
		pop EBX;
		mov EAX,dword ptr DS:[EBX+10];
		ret;
	}
}
// сохранить значение с вершины стека данных в коде за скомпилированным
// (store) ( с некоторым фиксированным смещением, определяемым # методов)
// : (store) ( r: addr  d: n --> ) R> TOKEN + ! ;
// CODE (store) ( n --> )
private void f_s_store_s() {
	asm {		naked;
		pop EBX;
		mov dword ptr DS:[EBX+5],EAX;
		mov EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+4];
		ret;
	}
}
// ======================== token.f ========================
// \ 22.06.2009 ~mOleg
// \ Copyright [C] 2009-2013 mOleg mOlegg@ya.ru
// \ работа со скомпилированными токенами

// 5 CONSTANT CFL    ( --> cfl# )   \ длинна поля кода
private void f_CFL() {
	asm {		naked;
		call f_s_CONST_s;
		add EAX,0x9D000000;
		pop EDI;
		pop ESP;
	}
}
// ALIAS CFL TOKEN ( --> token# ) \ размер одной ссылки в коде √
private void f_TOKEN() {
	asm {		naked;
		call f_s_CONST_s;
		add EAX,0x9D000000;
		pop EDI;
		pop ESP;
	}
}
// \ вернуть адрес слова, скомпилированного в коде по указанному адресу
// : TOKEN@ ( addr --> xt ) DUP 1 + REF@ + TOKEN + ;
private void f_TOKEN_get() {
	asm {		naked;
		call h_DUP;
		call h_s_LIT_s;
		add dword ptr DS:[EAX],EAX;
		add byte ptr DS:[EAX],AL;
		call h_PLUS;
		call h_getFromAdr;
		call h_PLUS;
		call f_TOKEN;
		call h_PLUS;
		ret;
	}
}
// \ заменить значение токена dst на src
// : TOKEN! ( src dst --> ) TUCK TOKEN + - SWAP 1 + REF! ;
private void f_TOKEN_set() {
	asm {		naked;
		call h_TUCK;
		call f_TOKEN;
		call h_PLUS;
		call h_MINUS;
		call h_SWAP;
		call h_s_LIT_s;
		add dword ptr DS:[EAX],EAX;
		add byte ptr DS:[EAX],AL;
		call h_PLUS;
		call h_setToAdr;
		ret;
	}
}
// ======================== Быстрая арифметика ===============
// 1+  ( A -- A+1 )
private void h_inc() {
	asm {		naked;
		inc EAX;
		ret;
	}
}
// 1-  ( A -- A-1 )
private void h_dec() {
	asm {		naked;
		dec EAX;
		ret;
	}
}

// ======================== marks.f ========================

// %  ( A B -- A%B )
private void h_ZP() {
	asm {		naked;
		mov ECX, EAX;
		mov EAX, [EBP];
		cdq;
		idiv ECX;
		lea EBP,[EBP+CELL];
		mov EAX, EDX;
		ret;
	}
}

// /  ( A B -- A/B )
private void h_ZD() {
	asm {		naked;
		mov ECX, EAX;
		mov EAX, [EBP];
		cdq;
		idiv ECX;
		lea EBP,[EBP+CELL];
		ret;
	}
}

// *  ( A B -- A*B )
private void h_ZW() {
	asm {		naked;
		imul dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
	}
}
// +  ( A B -- A+B )
private void h_PLUS() {
	asm {		naked;
		add EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
	}
}
// -  ( A B -- A-B )
private void h_MINUS() {
	asm {		naked;
		neg EAX;
		add EAX,dword ptr SS:[EBP];
		lea EBP,[EBP+CELL];
		ret;
	}
}
// Выдать размер ячейки (32 разряда)
// 4 CONSTANT CELL
private void f_CELL() {
	asm {		naked;
		call f_s_CONST_s;
		add AL,0;
		add byte ptr DS:[EAX],AL;
		pop ESP;
	}
}
//   ALIAS CELL REF  ( --> const ) \ размер ссылки в байтах
private void f_REF() {
	asm {		naked;
		call f_s_CONST_s;
		add AL,0;
		add byte ptr DS:[EAX],AL;
		pop ESP;
	}
}
// \ компилировать ссылку на код
// : REF, ( ref --> ) REF PLACE REF! ;
private void f_REFzpt() {
	asm {		naked;
		call f_REF;
		call h_PLACE;
		call h_setToAdr;
		ret;
	}
}
// \ !!! часто используется и по сути выдает смещение от текущего
// \ адреса до указанного. Стоит вынести в отдельное слово.
// : atod ( addr --> disp ) HERE REF + - ;
private void f_atod() {
	asm {		naked;
		call h_HERE;
		call f_REF;
		call h_PLUS;
		call h_MINUS;
		ret;
	}
}
// \ разрешить ссылку вперед(в коде)
// \ : >resolve ( addr --> ) HERE OVER - REF - SWAP ! ;
private void f_R_RESOLVE() {
	asm {		naked;
		call h_HERE;
		call h_OVER;
		call h_MINUS;
		call f_REF;
		call h_MINUS;
		call h_SWAP;
		call h_setToAdr;
		ret;
	}
}
// \ разрешить ссылку(в коде, то есть в поле данных команды JMP или CALL) назад
// : <resolve ( addr --> ) atod REF, ;
private void f_L_resolve() {
	asm {		naked;
		call f_atod;
		call f_REFzpt;
		ret;
	}
}
// \ запомнить положение для ссылки вперед
// : >MARK ( --> addr ) HERE REF - ;
private void f_R_MARK() {
	asm {		naked;
		call h_HERE;
		call f_REF;
		call h_MINUS;
		ret;
	}
}
// \ заполнить положение для ссылки назад
// : <MARK ( --> addr ) HERE ;
private void f_L_MARK() {
	asm {		naked;
		call h_HERE;
		ret;
	}
}
// : <RESOLVE ( addr --> ) HERE - REF, ;
private void f_L_RESOLVE() {
	asm {		naked;
		call h_HERE;
		call h_MINUS;
		call f_REFzpt;
		ret;
	}
}
// : RESOLVE> ( addr --> ) HERE OVER - SWAP ! ;
private void f_RESOLVE_R() {
	asm {		naked;
		call h_HERE;
		call h_OVER;
		call h_MINUS;
		call h_SWAP;
		call h_setToAdr;
		ret;
	}
}
// 26-06-2005 ~mOleg
// Copyright [C] 2005-2013 mOleg mOlegg@ya.ru
// стековые манипуляции

// -- стек данных ------------------------------------------------------------

// установить новое значение указателя стека данных
//  SP! ( addr --> )
private void SP_set() {
	asm {		naked;
    	lea  EBP,	[EAX+CELL];
    	mov  EAX,	[EBP-CELL];
    	ret;
	}	
}
// прочесть на вершину стека текущее значение указателя стека данных
// SP@ ( --> addr )
private void SP_get() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	EBP;
		ret;
	}	
}
//       USER S0 ( --> addr ) \ ячейка хранит адрес дна стека данных

// -- Стек возвратов ---------------------------------------------------------
// установить новое значение указателя стека возвратов
// RP! ( addr --> )
private void RP_set() {
	asm {		naked;
		pop EBX;			// адрес куда надо вернутся
		mov ESP,	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
	}
}
// прочесть на вершину стека данных текущее значение указателя стека возвратов
// RP@ ( --> addr )
private void RP_get() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		lea EAX,	[ESP+CELL];
		ret;
	}
}
//       USER R0   ( --> addr ) \ ячейка хранит адрес дна стека возвратов
// -- локальный стек ------------------------------------------------------------
// установить новое значение указателя стека данных
// LP! ( addr --> )
private void LP_set() {
	asm {		naked;
		mov ESI,	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
	}
}
// прочесть на вершину стека текущее значение указателя стека данных
// LP@ ( --> addr )
private void LP_get() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	ESI;
		ret;
	}
}
//       USER L0   ( --> addr ) \ хранит адрес дна локального стека
// 26-06-2005 ~mOleg
// Copyright [C] 2006-2013 mOleg mOlegg@ya.ru
// манипуляция данными на стеке данных - псевдоассемблер

// Продублировать верхнее значение на вершине стека данных.
// DUP ( n --> n n )
private void h_DUP() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		ret;
	}
}
// Убрать верхнее значение со стека данных.
// DROP ( n --> )
private void h_DROP() {
	asm {		naked;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		ret;
	}
}
// поменять местами два верхних элемента стека
// SWAP ( a b --> b a )
private void h_SWAP() {
	asm {		naked;
		mov EDX,	[EBP];
		mov [EBP],	EAX;
		mov EAX,	EDX;
		ret;
	}
}
// Положить копию x1 на вершину стека.
// OVER ( a b --> a b a )
private void h_OVER() { 
	asm {		naked;
		lea EBP, [EBP-CELL];
		mov dword ptr SS:[EBP],	EAX;
		mov EAX, dword ptr SS:[EBP+CELL];
		ret;
	}
}
// Убрать первый элемент под вершиной стека.
// NIP ( a b --> b )
private void SP_nip() {
	asm {		naked;
		lea EBP,	[EBP+CELL];
		ret;
	}
}
// Прокрутить три верхних элемента стека.
// ROT ( a b c --> b c a )
private void SP_rot() {
	asm {		naked;
		mov EDX,	[EBP];
		mov [EBP],	EAX;
		mov EAX,	[EBP+CELL];
		mov [EBP+CELL],	EDX;
		ret;
	}
}
// Прокрутить три верхних элемента стека.
//  -ROT ( a b c --> c a b )
private void SP_minusrot() {
	asm {		naked;
		mov EDX,	[EBP+CELL];
		mov [EBP+CELL],	EAX;
		mov EAX,	[EBP];
		mov [EBP],	EDX;
		ret;
	}
}
// Положить копию верхнего элемента стека под следующий за ним.
// TUCK ( a b --> b a b )
private void h_TUCK() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov EDX,	[EBP+CELL];
		mov [EBP+CELL],	EAX;
		mov [EBP],	EDX;
		ret;
	}
}
// Сделать копию верхней пары элементов стека данных
// DDUP ( d --> d d )
private void SP_ddup() {
	asm {		naked;
		mov EDX,	[EBP];
		mov [EBP-CELL],	EAX;
		mov [EBP-CELL*2],	EDX;
		lea EBP,	[EBP-CELL*2];
		ret;
	}
}
// Убрать со стека пару ячеек x1 x2.
// DDROP ( d --> )
private void SP_ddrop() {
	asm {		naked;
		mov EAX,	[EBP+CELL];
		lea EBP,	[EBP+CELL*2];
		ret;
	}
}
// Удалить с вершины стека данных три верхних ячейки
// TDROP ( n n n --> )
private void SP_tdrop() {
	asm {		naked;
		mov EAX,	[EBP+CELL*2];
		lea EBP,	[EBP+CELL*3];
		ret;
	}
}
// Поменять местами две верхние пары ячеек.
// DSWAP ( da db --> db da )
private void SP_dswap() {
	asm {		naked;
		mov EDX,	[EBP];
		mov EBX,	[EBP+CELL];
		mov ECX,	[EBP+CELL*2];
		mov [EBP+CELL*2],	EDX;
		mov [EBP+CELL],	EAX;
		mov [EBP],	ECX;
		mov EAX,	EBX;
		ret;
	}
}
// 26-06-2005 ~mOleg
// Copyright [C] 2005-2013 mOleg mOlegg@ya.ru
// манипуляция числами на стеке возвратов

// прочесть верхнее значение со стека возвратов
// R@ ( r: n --> r: n d: n )
private void h_R_get() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	[ESP+CELL];
		ret;
	}
}
// Удалить одно значение с вершины стека возвратов
// RDROP ( r: n --> )
private void SR_rdrop() {
	asm {		naked;
		pop EBX;
		pop EDX;
		jmp EBX;
	}
}
// Перенести значение со стека данных на стек возвратов
// >R ( d: n --> r: n )
private void h_toR() {
	asm {		naked;
		pop EBX;
		push EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
	}
}
// Перенести значение со стека возвратов на стек данных
// R> ( r: n --> d: n )
private void h_Rto() {
	asm {		naked;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		pop EBX;
		pop EAX;
		jmp EBX;
	}
}
// Добавить значение к тому, что лежит на вершине стека возвратов
// R+ ( r: a d: b --> R: a+b )
private void h_R_PLUS() {
	asm {		naked;
		pop EBX;
		add [ESP],	EAX;
		mov EAX,	[EBP];
		lea EBP,	[EBP+CELL];
		jmp EBX;
	}
}
// Поместить значение 0 на вершину ст возвратов, вернуть адрес значения
// 0>R' ( --> r: 0 d: RP@ )
private void SR_SR_0toRadr() {
	asm {		naked;
		mov EBX,	[ESP];
		mov [ESP],	0;
		lea EBP,	[EBP-CELL];
		mov [EBP],	EAX;
		mov EAX,	ESP;
		jmp EBX;
	}
}
// Перенести два значения на стек возвратов со стека данных
// D>R ( D: x1 x2 --> R: --> x1 x2 )
private void SR_DtoR() {
	asm {		naked;
		pop EBX;
		push [EBP];
		push EAX;
		lea EBP,	[EBP+CELL*2];
		mov EAX,	[EBP-CELL];
		jmp EBX;
	}
}
// Вернуть два значения со стека возвратов на стек данных
// CODE DR> ( r: d --> D: d )
private void SR_DRfrom() {
	asm {		naked;
		mov EBX,	[ESP];
		mov [EBP-CELL],	EAX;
		mov EDX, [ESP+CELL*2];
		mov EAX, [ESP+CELL];
		mov [EBP-CELL*2], EDX;
		lea EBP, [EBP-CELL*2];  // замечание: выделять место на стеке нужно до 
		lea ESP, [ESP+CELL*3];  // того, как туда будут положены значения 
		jmp EBX;
	}
}
// Прочитать на вершину стека данных два верхних значения со ст возвратов
// DR@ ( r: d --> r: d d: d )
private void SR_DRrazm() {
	asm {		naked;
		mov [EBP-CELL],EAX;
		mov EAX, [ESP+CELL];
		mov EDX, [ESP+CELL*2];
		mov [EBP-CELL*2],EDX;
		lea EBP, [EBP-8];
		ret;
	}
}

// локальный стек данных

// прочитать значение с вершины локального стека
// L@ ( l: n --> l: n d: n )
private void SL_get() {
	asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI];
		ret;
	}
}
// прибавить значение с вершины стека данных, к значению на вершине локального стека
// L+ ( l: a d: b --> l: a+b )
private void SL_add() {
	asm {		naked;
		add [ESI], EAX;
		mov EAX, [EBP];
		lea EBP, [EBP+CELL];
		ret;
	}
}
// переместить значение на вершину локального стека
// >L ( d: n --> l: n )
private void SL_toL() {
	asm {		naked;
		lea ESI, [ESI-CELL];
		mov [ESI], EAX;
		mov EAX, [EBP];
		lea EBP, [EBP+CELL];
		ret;
	}
}
// переместить значение с вершины локального стека
// L> ( l: n --> d: n )
private void SL_Lfrom() {
	asm {		naked;
		lea EBP, [EBP-CELL];
		mov [EBP], EAX;
		mov EAX, [ESI];
		lea ESI, [ESI+CELL];
		ret;
	}
}
// дублировать значение на вершине локального стека
// LDUP ( l: n --> l: n n )
private void SL_Ldup() {
	asm {		naked;
		mov EDX, [ESI];
		lea ESI, [ESI-CELL];
		mov [ESI], EDX;
		ret;
	}
}
// удалить элемент с вершины локального стека
// LDROP ( l: n --> )
private void SL_Ldrop() {
	asm {		naked;
		lea ESI, [ESI+4];
		ret;
	}
}

// Процедуры времени выполнения для CONSTANT, VARIABLE, etc.

// Записать значение по адресу
// ! ( x a-addr --> )
private void h_setToAdr() {
	asm {		naked;
		mov EDX, dword ptr SS:[EBP];
		mov dword ptr DS:[EAX], EDX;
		mov EAX, dword ptr SS:[EBP+CELL];
		lea EBP, [EBP+CELL*2];
		ret;
	}
}
// Прочитать значение по адресу
// @ ( a-addr --> x )
private void h_getFromAdr() {
	asm {		naked;
		mov EAX,  DS:[EAX];
		ret;
	}
}
// Получить byte по адресу c-addr.
// Незначащие старшие биты ячейки нулевые.
// B@ ( c-addr --> byte )
private void h_getFromAdrByte() {
	asm {		naked;
		movzx EAX, byte ptr DS:[EAX];
		ret;
	}
}
// Записать byte по адресу a-addr.
// CODE B! ( byte c-addr --> )
private void h_setToAdrByte() {
	asm {		naked;
		mov EDX,  SS:[EBP];
		mov byte ptr DS:[EAX],DL;
		mov EAX, dword ptr SS:[EBP+CELL];
		lea EBP,[EBP+CELL*2];
		ret;
	}
}
 
// ======================== Проверочные слова ======================= 

// Проверим передачу 3 параметров
private void t9( int a, int b, int c) {
	writeln();
	writeln("~~~~> ", "3 param ", a, "  ", b, "  ", c);
}
private void exec_D() {
	asm {		naked;
		// mov EAX, 7;		call t1;  // t1(7);
		call h_DUP;
		push 2;
		push 3;
		mov EAX, 4;
		// mov EAX, 4;
		lea ECX, t9;
		call ECX;
		// call t9;
		call h_DROP;
		ret;
	}
} 

// int qwe = 7;

// Вызов внешних функций
// ( .... Af -- ... ) 
private void callD() {
	asm {		naked;
		mov ECX, EAX;		// Адрес функции, для вызова CALL
		pop EAX;			// Забираем адрес возврата из callD
		call SL_toL;		// Прячем его во временный стек
		call h_DUP;
		call ECX;			// Вызов функции по адресу
		mov ECX, EAX;		// Сохраним Return
		call SL_Lfrom;		// Вернем с доп стека в EAX адрес возврата из callD
		push EAX;			// Вернем его на место
		mov EAX, ECX;
		ret;
	}
}
// LATEST ( -- Aexec)
// Выдать на стек данных F адрес CFA последнего изготовленного слова
private void* d_LATEST() { return &(gpcb.latest);  }
private void  h_LATEST() {
	asm {	naked;	call h_DUP;  call d_LATEST; ret; }
}
// CONTEXT ( -- Alfa)
// Выдать на стек данных F адрес NFA последнего изготовленного слова. С этого
// адреса можно перебрать всю цепочку слов в словаре
private void* d_CONTEXT() { return &(gpcb.context); }
private void  h_CONTEXT() {
	asm {	naked;	call h_DUP;  call d_CONTEXT; ret; }
}
//  TIB ( -- Atib)
// Выдать на стек данных F адрес буфера, в котором содержится исходная строка форта
// для текстового разбора словом WORD
private void* d_TIB() { return &(gpcb.Tib); }
private void  h_TIB() {
	asm {	naked;	call h_DUP;  call d_TIB; ret; }
}
//  <IN ( -- A)
// Выдать на стек данных F адрес (позицию) того места, в строковом буфере, откуда
// будет начинаться поиск след слова (лексемы) словом WORD
private void* d_IN() { return &(gpcb.In); }
private void  h_IN() {
	asm {	naked;	call h_DUP;  call d_IN; ret; }
}
//  dlTib ( -- N )
// Выдать на стек данных размер строки в TIB
private void* d_dlTib() { return cast(void*)gpcb.dlTib; }
private void  h_dlTib() {
	asm {	naked;	call h_DUP;  call d_dlTib; ret; }
}
// ALLOT ( n -- )
// Зарезервировать в кодофайле n байт, под собственные нужды
private void d_ALLOT(int n) {	gpcb.here = gpcb.here + n; }
private void h_ALLOT() {
	asm {	naked;	call d_ALLOT;	call h_DROP;	ret; }
}
// HERE ( -- Ahere)
// Выдать позицию в кодофайле, куда будут записываться новые определяемые слова
private void* d_HERE() { return gpcb.here; }
private void  h_HERE() {
	asm {	naked;	call h_DUP;  call d_HERE;	ret; }
}
// STATE ( -- Ahere)
// Выдать состояние переменной, показывающий в компиляции или интерпретации сейчас 
// мы находимся. TRUE=компиляция, FALSE=интерпретация
private void* d_STATE() { return &gpcb.state; }
private void  h_STATE() {
	asm {	naked;	call h_DUP;  call d_STATE;	ret; }
}
// COMMONADR ( -- A )
// Выдать указатель на начало общей таблицы CommonAdr
private void* d_COMMONADR() { return gpcb.adrCommonTable; }
private void  h_COMMONADR() {
	asm {	naked;	call h_DUP;  call d_COMMONADR;	ret; }
}
// : PLACE ( # --> addr ) HERE SWAP ALLOT ;
// Указатель на начало "дырки" свободной области в кодофайле
private void h_PLACE() {	   
	asm {		naked;
		call h_HERE;
		call h_SWAP;
		call h_ALLOT;
		ret;
	}
}
// Зарезервировать одну ячейку в области данных и поместить x в эту ячейку.
// : , ( x --> ) CELL PLACE ! ;
private void h_zpt() {	   
	asm {		naked;
		// int 3;
		call h_DUP; mov EAX, CELL;
		call h_PLACE;
		call h_setToAdr;
		ret;
	}
}
// Зарезервировать одну ячейку в области данных и поместить x в эту ячейку.
// : B, ( x --> ) 1 PLACE B! ;
private void h_Bzpt() {	   
	asm {		naked;
		call h_DUP; mov EAX, 1;
		call h_PLACE;
		call h_setToAdrByte;
		ret;
	}
}

// -------------------------- compie.f -------------------------

// \ 31-01-2007 ~mOleg
// \ Copyright [C] 1992-1999 A.Cherezov ac@forth.org
// \ Компиляция.

// \ скомпилировать адрес следующего токена в текущее определение
// \ классический не-immediate вариант. Не работает со immediate словами
// : COMPILE ( r: addr --> ) AR@ TOKEN@ TOKEN R+ COMPILE, ;
private void h_COMPILE() {	   
	asm {		naked;
		call h_R_get;			// R@
		call f_TOKEN_get;
		call f_TOKEN;
		call h_R_PLUS;
		call h_COMPILEzpt;
		ret;
	}
}
// скомпилировать инструкцию INT3
// : INT3, ( --> ) 0xCC B, ;
private void h_INT3zpt() {	   
	asm {		naked;
		call h_DUP; mov EAX, 0xCC;
		call h_Bzpt;
		ret;
	}
}
// скомпилировать инструкцию RET
// : RET, ( --> ) 0xC3 B, ;
private void h_RETzpt() {	   
	asm {		naked;
		call h_DUP; mov EAX, 0xC3;
		call h_Bzpt;
		ret;
	}
}
// скомпилировать инструкцию CALL √
// : CALL, ( --> ) 0xE8 B, ;
private void h_CALLzpt() {	   
	asm {		naked;
		call h_DUP; mov EAX, 0xE8;
		call h_Bzpt;
		ret;
	}
}
// \ компилировать вызов указанного xt √
// : COMPILE, ( xt --> ) CALL, <resolve ;
private void h_COMPILEzpt() {	   
	asm {		naked;
		call h_CALLzpt;
		call f_L_resolve;
		ret;
	}
}
// \ компилировать безусловный переход на указанный адрес √
// : JUMP, ( addr --> )  0xE9 B, <resolve ;
private void h_JUMPzpt() {	   
	asm {		naked;
		call h_DUP; mov EAX, 0xE9;
		call h_Bzpt;
		call f_L_resolve;
		ret;
	}
}
// ???????????????????????? Возможно ошибочное словл
// \ компилировать код, возвращающий число в текущее определение
// : LIT, ( N --> ) COMPILE (LIT) , ;
private void h_LITzpt() {	   
	asm {		naked;
	call h_COMPILE;
	call h_s_LIT_s;
	call h_zpt;
	}
}
// Шитое слово TRUE
// -1 CONSTANT TRUE
private void f_TRUE() {	   
	asm {		naked;
		call f_s_CONST_s;
		di 0xFFFFFFFF;
	}
}
// Шитое слово TRUE
// -1 CONSTANT TRUE
private void f_FALSE() {	   
	asm {		naked;
		call f_s_CONST_s;
		di 0x0;
	}
}
// Шитое слово BL
// 32 CONSTANT BL
private void f_BL() {	   
	asm {		naked;
		call f_s_CONST_s;
		di 0x20;
	}
}
// CODE [ - начать интерпретацию
private void h_COMP_OFF() {
	asm {		naked;
		call f_FALSE;
		call h_STATE;
		call h_setToAdr;
		ret;
	}
}
// CODE ] - начать компиляцию
private void h_COMP_ON() {
	asm {		naked;
		call f_TRUE;
		call h_STATE;
		call h_setToAdr;
		ret;
	}
}
// DUMP ( A -- ) Распечатать указанный адрес
void h_zz(pp adr) {
	writeln("- dump -- dump -- dump -- dump -- dump -");
	dumpAdr(adr);
	writeln("- dump -- dump -- dump -- dump -- dump -");
}
void h_dump() {
	asm {	naked;
		call h_zz;
		call h_DROP;
		ret;
	}
}
// Выдать тип OS W - windows,  L - Linux
void h_osname() {
version(Windows) {
	asm {	naked;
		call h_DUP;
		mov EAX, 87;
		ret;
	}
}
version(linux) {
	asm {	naked;
		call h_DUP;
		mov EAX, 76;
		ret;
	}
}
}
// Вернуть на стек адрес функции LoadLibrary
pp h_LoadLibrary() {
	pp rez;
	version(Windows) {
		import core.sys.windows.windows: LoadLibraryA ;
		rez = cast(pp)&LoadLibraryA;
	}
	return rez;
}
void f_LoadLibraryA() {
	asm {	naked;
		call h_DUP;
		call h_LoadLibrary;
		ret;
	}
}
pp h_DlOpen() {
	pp rez;
	version(linux) {   
		import core.sys.posix.dlfcn;  // Определения dlopen() и dlsym()
		rez = cast(pp)&dlopen;
	}
	return rez;
}
void f_DlOpen() {
	asm {	naked;
		call h_DUP;
		call h_DlOpen;
		ret;
	}
}
// Вернуть на стек адрес функции GetProcAdres
pp h_GetPrAdressA() {
	pp rez;
	version(Windows) {
		import core.sys.windows.windows: GetProcAddress ;
		rez = cast(pp)&GetProcAddress;
	}
	return rez;
}
void f_GetPrAdressA() {
	asm {	naked;
		call h_DUP;
		call h_GetPrAdressA;
		ret;
	}
}
pp h_DlSym() {
	pp rez;
	version(linux) {   
		import core.sys.posix.dlfcn;  // Определения dlopen() и dlsym()
		rez = cast(pp)&dlsym;
	}
	return rez;
}
void f_DlSym() {
	asm {	naked;
		call h_DUP;
		call h_DlSym;
		ret;
	}
}


// use std.stdout instead of std.c.stdio.stdout 

pp h_getSTDOUT() {
    // Linux
	import core.stdc.stdio;
	return cast(pp)(core.stdc.stdio.stdout);
}
// Выдать на стек стандартный указатель на stdout
void getSTDOUT() {
	asm {	naked;
		call h_DUP;
		call h_getSTDOUT;
		ret;
	}
}

// TYPE ( A -- ) Распечатать строку на консоли
void h_TYPE(ps adr) {
	printf("%s", adr); stdout.flush();
}
void f_TYPE() {
	asm {	naked;
		call h_TYPE;
		call h_DROP;
		ret;
	}
}

// CMOVE ( Afrom Ato N -- ) Скопировать байты
private void h_bmove(int n, ps to, ps from) {
	import core.stdc.string : memcpy;
	memcpy(to, from, n);
}
private void f_bmove() {
	asm {	naked;
		push EAX;
		call h_DROP;
		push EAX;
		call h_DROP;
		call h_bmove;
		call h_DROP;
		ret;
	}
}

// Странное слово. Понятно, что вызывается, когда есть ветка с исключительной
// ситуацией. По идее, должно проинформировать и корректно прервать 
// программу
private void h_THROW(int n) {
	writeln();
	writeln("[", n, "]", " THROW - error, this mast find ...");
}
private void f_THROW() {
	asm {	naked;	call h_THROW;  call h_DROP;	ret; }
}
// ?COMP - разрешено только при компиляции 
// private void f_ZNW_COMP() {
//	asm {	naked;	call h_DUP; mov EAX, 1; call h_THROW;	ret; }
// }
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// Обработка вызова слота Slot_A_N_v
// Выдать адрес обработчика для вызова функции с параметрами A и N
private void* h_A_CALL_AN() { return &executeForth_A_N; }
// Forth слово: выдать адрес обработчика для вызова функции с параметрами A и N
private void  f_A_CALL_AN() {
	asm {	naked;
		call h_DUP;
		call h_A_CALL_AN;
		ret;
	}
}
// Обработка вызова слота Slot_A_N_v
extern (C) void executeForth_A_N(pp adr, int n) {
	writeln("this is Call from C witch adr = ", adr, "  n = ", n);
	executeForth(adr, 1, n);
}

// Выполнить адрес через EXECUTE
extern (C) pp executeForth(pp adrexec, uint kolPar, ...) {
	pp Adr_execD = gpcb.executeFromD;  // ' EXECUTEFROMD
	// writeln("Adr_execD = ", Adr_execD, "   adrexec = ", adrexec, "  kolPar = ", kolPar);
	pp ret;  			// Место под возвращаемое значение
	NPcb npcb = gpcb;   // Возможность работы с PCB (контекст) переменными в ASM
	pp adrKolPar = cast(pp)&kolPar;  // Адрес количества параметров
	asm {
		align 4;
		// Сохраним регистры D
		push EBX; push ESI; push EAX; push ECX; push EDX; push EBP; 
		// --------------------
		// Запишем наши параметры
		push Adr_execD;				// Адрес xt специальный слова в Forth (EXECUTEFROMD)
		push adrexec;				// Адпес слова Forth которое будет выполнено из EXECUTEFROMD
		push adrKolPar; 			// Адрес количества параметров для передачи в Форт
		// Востановим регитры F
		mov EAX, npcb.saveEAX.offsetof[npcb];
		mov ESI, npcb.saveESI.offsetof[npcb];
		mov EDI, npcb.saveEDI.offsetof[npcb];
		mov EBP, npcb.saveEBP.offsetof[npcb];
  		call h_DUP;					// Сохраним то что было на вершине стека Форта
		pop  EAX;					// На веншину SD количество пораметров
  		call h_DUP;					// Сохраним,освободив вершину SD
		pop  EAX;					// На веншину SD адрес вызываемого слова
  		call h_DUP;					// Сохраним,освободив вершину SD
		pop  EAX;					// На вершине SD адрес EXECUTEFROMD
		call f_EXECUTE;				// Вызов EXECUTEFROMD
		// mov EBX, EAX;				// Сохранить возвращаемое значение
		mov ret, EAX;
		call h_DROP;				// Выкинуть со стека в форте, так как вызов внешний 
		
		// Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
		// mov ret, EBX;
		// ----------------------
		// Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop ESI; pop EBX;
	}
	gpcb.saveEBP = npcb.saveEBP;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveEAX = npcb.saveEAX;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveESI = npcb.saveESI;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveEDI = npcb.saveEDI;   // Возможность работы с PCB (контекст) переменными в ASM
	return ret;
}

void evalForth(char *str) {
	evalForth(to!string(str));
}
void evalForth(string str) {
	// Linux корректировка
	if(str.length>0 && str[$-1]==13) str.length = str.length-1;

	gpcb.dlTib = str.length;		// Запишем длину строки в gpcb
	gpcb.In = cast(ps)gpcb.Tib;     // указатель смещения во входном буфере
	for(int i; i != str.length; i++) tib[i] = cast(ubyte)str[i];
	NPcb npcb = gpcb;   // Возможность работы с PCB (контекст) переменными в ASM
	asm {
		align 4;
		// Сохраним регистры D
		push EBX; push ESI; push EAX; push ECX; push EDX; push EBP; 
		// --------------------
		// Востановим регитры F
//		int 3;
		mov EAX, npcb.saveEAX.offsetof[npcb];
		mov ESI, npcb.saveESI.offsetof[npcb];
		mov EDI, npcb.saveEDI.offsetof[npcb];
		mov EBP, npcb.saveEBP.offsetof[npcb];
		
		call f_inter;
		
		// Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
		// ----------------------
		// Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop ESI; pop EBX;
	}
	gpcb.saveEBP = npcb.saveEBP;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveEAX = npcb.saveEAX;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveESI = npcb.saveESI;   // Возможность работы с PCB (контекст) переменными в ASM
	gpcb.saveEDI = npcb.saveEDI;   // Возможность работы с PCB (контекст) переменными в ASM
}
// Записать в общую таблицу адрес adr в ячейку с номером n
void setCommonAdr(int n, pp adr) {	commonTable[n] = adr; }
// Прочитать из общий таблицы адрес в ячейке n
pp getCommonAdr(int n) {	return commonTable[n];  }
// Инициализировать Forth и подготовить его к работе

void initForth() {
	kdf = cast(pb)(new uint[sizeCodeFile]).ptr;		// Изготовим кодофайл на sizeCodeFile адр
	NPcb npcb = gpcb;
	npcb.adrCommonTable = cast(pp)commonTable.ptr;
	const sizeSt = sizeStack; 				// По sizeStack CELL на каждый стек
	// uint[sizeSt] stSD, stSR, stSL;  		// Память под стеки
	stSD = cast(pp)(new uint[sizeSt]);		// Запомнить начало области SP в глобальной переменной
	npcb.csd = stSD + sizeSt - 1;			// Запомнить вершину стека SP в контексте
	
	// npcb.csr = cast(pp)stSR[sizeSt-1]; ---> Совмещен со стеком D
	stSL = cast(pp)(new uint[sizeSt]);		// Запомнить начало SP в глобальной переменной
	npcb.csc = stSL + sizeSt - 1;			// Запомнить вершину SL в контексте
	
	npcb.here = kdf;						// HERE на начало буфера
	npcb.context = cast(pp)kdf;				// Вектор context лежит в начале кодофайла
	npcb.akdf = cast(pp)kdf;				// Указатель на кодофайл
	npcb.Tib = cast(ps)&tib;				// Указатель на входной буфер текста
	// npcb._Tib = cast(ps)&_tib;	// ??? не используется // Указатель на входной буфер WORD
	npcb.In = cast(ps)&tib;                 // указатель смещения во входном буфере
	asm {
		align 4;
		// Сохраним регистры D
		push EBX; push ESI; push EAX; push ECX;	push EDX; push EBP; 
		// --------------------
		// В ESI запомним указатель на доп стек SL
		lea EAX, npcb.csc.offsetof[npcb]; 
		mov ESI,  DS:[EAX];
		// Из контекста возьмем указатель на стек данных ...
		lea EAX, npcb.csd.offsetof[npcb]; 
		mov EAX,  DS:[EAX];
		call SP_set; // ... и инициализируем его
		mov EAX, ESI;	call LP_set; // Стек дополнительный для Форк
		// Сохраним F
		mov ECX, EBP;
		pop EBP;
		mov npcb.saveEAX.offsetof[npcb], EAX;
		mov npcb.saveEBP.offsetof[npcb], ECX;  // Сохраним запомненный EBP
		mov npcb.saveESI.offsetof[npcb], ESI;
		mov npcb.saveEDI.offsetof[npcb], EDI;
		// ----------------------
		// Восстановим регистры D
		pop EDX; pop ECX; pop EAX; pop ESI; pop EBX;
	}
	// writeln("Local PCB: ", npcb);
	gpcb = npcb;
	// Надо выделить 256 CELL для хранения цепочек context
	pb u = gpcb.here; for(int i; i != (256 * CELL); i++) *u = 0; 
	gpcb.here = gpcb.here + (256 * CELL);
	// Перенесём сюда определение HARD слов
	CreateVocItem(cast(char*)"\3EXD".ptr, 		cast(pp)&exec_D, 		&gpcb.context);
	CreateVocItem(cast(char*)"\6CALL_A".ptr,cast(pp)&callD, 			&gpcb.context);
	CreateVocItem(cast(char*)"\7CONTEXT".ptr, 	cast(pp)&h_CONTEXT,		&gpcb.context);
	CreateVocItem(cast(char*)"\4JUMP".ptr, 		cast(pp)&f_JUMP,		&gpcb.context);
	CreateVocItem(cast(char*)"\4EXIT".ptr, 		cast(pp)&f_EXIT,		&gpcb.context);
	CreateVocItem(cast(char*)"\3NIP".ptr, 		cast(pp)&SP_nip,		&gpcb.context);
	CreateVocItem(cast(char*)"\3ROT".ptr, 		cast(pp)&SP_rot,		&gpcb.context);
	CreateVocItem(cast(char*)"\4-ROT".ptr, 		cast(pp)&SP_minusrot,	&gpcb.context);
	CreateVocItem(cast(char*)"\3D>R".ptr, 		cast(pp)&SR_DtoR,		&gpcb.context);
	CreateVocItem(cast(char*)"\3DR>".ptr, 		cast(pp)&SR_DRfrom,		&gpcb.context);
//	CreateVocItem(cast(char*)"\5?COMP".ptr, 	cast(pp)&f_ZNW_COMP,		&gpcb.context);

	CreateVocItem(cast(char*)"\6OSNAME".ptr, 	cast(pp)&h_osname,		&gpcb.context);

	CreateVocItem(cast(char*)"\10(STDOUT)".ptr, 		cast(pp)&getSTDOUT, 	&gpcb.context);

	CreateVocItem(cast(char*)"\14LOADLIBRARYA".ptr, 	cast(pp)&f_LoadLibraryA,	&gpcb.context);
	CreateVocItem(cast(char*)"\10GPADRESS".ptr, 	cast(pp)&f_GetPrAdressA,	&gpcb.context);
	CreateVocItem(cast(char*)"\6DLOPEN".ptr, 	cast(pp)&f_DlOpen,		&gpcb.context);
	CreateVocItem(cast(char*)"\5DLSYM".ptr, 	cast(pp)&f_DlSym,		&gpcb.context);

	CreateVocItem(cast(char*)"\2L@".ptr, 		cast(pp)&SL_get,		&gpcb.context);
	CreateVocItem(cast(char*)"\2L+".ptr, 		cast(pp)&SL_add,		&gpcb.context);
	CreateVocItem(cast(char*)"\2>L".ptr, 		cast(pp)&SL_toL,		&gpcb.context);
	CreateVocItem(cast(char*)"\2L>".ptr, 		cast(pp)&SL_Lfrom,		&gpcb.context);
	CreateVocItem(cast(char*)"\4LDUP".ptr, 		cast(pp)&SL_Ldup,		&gpcb.context);
	CreateVocItem(cast(char*)"\5LDROP".ptr, 	cast(pp)&SL_Ldrop,		&gpcb.context);
	
	CreateVocItem(cast(char*)"\3SP!".ptr, 		cast(pp)&SP_set, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3SP@".ptr, 		cast(pp)&SP_get, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3RP!".ptr, 		cast(pp)&RP_set, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3RP@".ptr, 		cast(pp)&RP_get, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3LP!".ptr, 		cast(pp)&LP_set, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3LP@".ptr, 		cast(pp)&LP_get, 		&gpcb.context);
//	CreateVocItem(cast(char*)"\2T5".ptr, 		cast(pp)&t5, 			&gpcb.context);
//	CreateVocItem(cast(char*)"\3TCW".ptr, 		cast(pp)&TestCompileWord, &gpcb.context);
	CreateVocItem(cast(char*)"\5INT3,".ptr, 		cast(pp)&h_INT3zpt,		&gpcb.context);
	CreateVocItem(cast(char*)"\3<IN".ptr, 		cast(pp)&h_IN,			&gpcb.context);
	CreateVocItem(cast(char*)"\3TIB".ptr, 		cast(pp)&h_TIB,			&gpcb.context);
	CreateVocItem(cast(char*)"\5DLTIB".ptr, 	cast(pp)&h_dlTib,		&gpcb.context);
	CreateVocItem(cast(char*)"\4NOOP".ptr, 		cast(pp)&f_NOOP,		&gpcb.context);

	CreateVocItem(cast(char*)"\4DUMP".ptr, 		cast(pp)&h_dump, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5RDROP".ptr, 	cast(pp)&SR_rdrop,	&gpcb.context);
	CreateVocItem(cast(char*)"\5DDROP".ptr, 	cast(pp)&SP_ddrop,	&gpcb.context);
	CreateVocItem(cast(char*)"\4DDUP".ptr, 	    cast(pp)&SP_ddup,	&gpcb.context);
	CreateVocItem(cast(char*)"\2>R".ptr, 		cast(pp)&h_toR, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2R>".ptr, 		cast(pp)&h_Rto, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2R+".ptr, 		cast(pp)&h_R_PLUS, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2R@".ptr, 		cast(pp)&h_R_get, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2B,".ptr, 		cast(pp)&h_Bzpt, 		&gpcb.context);
	CreateVocItem(cast(char*)"\4REF,".ptr, 		cast(pp)&f_REFzpt, 		&gpcb.context);
	
	CreateVocItem(cast(char*)"\5(LIT)".ptr, 	cast(pp)&h_s_LIT_s, 	&gpcb.context);
	CreateVocItem(cast(char*)"\4RET,".ptr,  	cast(pp)&h_RETzpt,  	&gpcb.context);
	// ????? CreateVocItem(cast(char*)"\4LIT,".ptr,  	cast(pp)&h_LITzpt,  	&gpcb.context);
	CreateVocItem(cast(char*)"\4TUCK".ptr, 		cast(pp)&h_TUCK, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3DUP".ptr, 		cast(pp)&h_DUP, 		&gpcb.context);
	CreateVocItem(cast(char*)"\4SWAP".ptr, 		cast(pp)&h_SWAP, 		&gpcb.context);
	CreateVocItem(cast(char*)"\4DROP".ptr, 		cast(pp)&h_DROP, 		&gpcb.context);
	CreateVocItem(cast(char*)"\4OVER".ptr, 		cast(pp)&h_OVER, 		&gpcb.context);
	CreateVocItem(cast(char*)"\1+".ptr, 		cast(pp)&h_PLUS, 		&gpcb.context);
	CreateVocItem(cast(char*)"\1*".ptr, 		cast(pp)&h_ZW, 			&gpcb.context);
	CreateVocItem(cast(char*)"\1/".ptr, 		cast(pp)&h_ZD, 			&gpcb.context);
	CreateVocItem(cast(char*)"\1%".ptr, 		cast(pp)&h_ZP, 			&gpcb.context);
	CreateVocItem(cast(char*)"\1-".ptr, 		cast(pp)&h_MINUS, 		&gpcb.context);
	CreateVocItem(cast(char*)"\1=".ptr, 		cast(pp)&f_RAWNO, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2<>".ptr, 		cast(pp)&f_NRAWNO, 		&gpcb.context);
	CreateVocItem(cast(char*)"\1<".ptr, 		cast(pp)&f_MENSHE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\1>".ptr, 		cast(pp)&f_BOLSHE, 		&gpcb.context);

	CreateVocItem(cast(char*)("\2" ~ "1+").ptr, 		cast(pp)&h_inc, 		&gpcb.context);
	CreateVocItem(cast(char*)("\2" ~ "1-").ptr, 		cast(pp)&h_dec, 		&gpcb.context);

	CreateVocItem(cast(char*)"\4CELL".ptr, 		cast(pp)&f_CELL, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3REF".ptr, 		cast(pp)&f_REF, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5PLACE".ptr, 	cast(pp)&h_PLACE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5ALLOT".ptr, 	cast(pp)&h_ALLOT, 		&gpcb.context);

	// ========== Странные шитые слова =============
	CreateVocItem(cast(char*)"\4TRUE".ptr, 		cast(pp)&f_TRUE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5FALSE".ptr, 	cast(pp)&f_FALSE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5STATE".ptr, 	cast(pp)&h_STATE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\3IMM".ptr, 		cast(pp)&f_getIMM, 		&gpcb.context);
	CreateVocItem(cast(char*)"\2BL".ptr, 		cast(pp)&f_BL, 			&gpcb.context);
	CreateVocItem(cast(char*)"\3CFL".ptr, 		cast(pp)&f_CFL, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5TOKEN".ptr, 	cast(pp)&f_TOKEN, 		&gpcb.context);
	CreateVocItem(cast(char*)"\6TOKEN@".ptr, 	cast(pp)&f_TOKEN_get,	&gpcb.context);
	CreateVocItem(cast(char*)"\6TOKEN!".ptr, 	cast(pp)&f_TOKEN_set,	&gpcb.context);
	CreateVocItem(cast(char*)"\4WORD".ptr, 		cast(pp)&f_word,		&gpcb.context);
	CreateVocItem(cast(char*)"\4FIND".ptr, 		cast(pp)&f_find,		&gpcb.context);
	CreateVocItem(cast(char*)"\4HERE".ptr, 		cast(pp)&h_HERE,		&gpcb.context);
	CreateVocItem(cast(char*)"\6NUMBER".ptr, 	cast(pp)&h_NUMBER,		&gpcb.context);
	CreateVocItem(cast(char*)"\11COMMONADR".ptr,cast(pp)&h_COMMONADR,	&gpcb.context);
	CreateVocItem(cast(char*)"\1.".ptr,		 	cast(pp)&h_tck,			&gpcb.context);
	CreateVocItem(cast(char*)"\1[".ptr,		 	cast(pp)&h_COMP_OFF,	&gpcb.context, 1);
	CreateVocItem(cast(char*)"\1]".ptr,		 	cast(pp)&h_COMP_ON,		&gpcb.context);
	CreateVocItem(cast(char*)"\1:".ptr,		 	cast(pp)&h_dwoetoc,		&gpcb.context);
	CreateVocItem(cast(char*)"\1;".ptr,		 	cast(pp)&h_tckzpt,		&gpcb.context, 1);
	
	// ========== kernel\vm\STC\BASE\memory.f =============
	CreateVocItem(cast(char*)"\1@".ptr, 		cast(pp)&h_getFromAdr,	&gpcb.context);
	CreateVocItem(cast(char*)"\1!".ptr, 		cast(pp)&h_setToAdr,	&gpcb.context);
	CreateVocItem(cast(char*)"\2B@".ptr, 		cast(pp)&h_getFromAdrByte,	&gpcb.context);
	CreateVocItem(cast(char*)"\2B!".ptr, 		cast(pp)&h_setToAdrByte,&gpcb.context);
	CreateVocItem(cast(char*)"\5BMOVE".ptr, 	cast(pp)&f_bmove,       &gpcb.context);

	// ========== List words for call from C++ QtE5 =============
	CreateVocItem(cast(char*)"\11A_CALL_AN".ptr, cast(pp)&f_A_CALL_AN,  &gpcb.context);
	
	// ========== kernel\vm\STC\BASE\  ...... ============= ссылки
	CreateVocItem(cast(char*)"\5>MARK".ptr, 	cast(pp)&f_R_MARK,		&gpcb.context);
	CreateVocItem(cast(char*)"\5<MARK".ptr, 	cast(pp)&f_L_MARK,		&gpcb.context);
	CreateVocItem(cast(char*)"\10<RESOLVE".ptr, cast(pp)&f_L_RESOLVE,	&gpcb.context);
	CreateVocItem(cast(char*)"\10RESOLVE>".ptr, cast(pp)&f_RESOLVE_R,	&gpcb.context);
	CreateVocItem(cast(char*)"\7?BRANCH".ptr, 	cast(pp)&f_ZW_BRANCH,	&gpcb.context);
	CreateVocItem(cast(char*)"\6BRANCH".ptr, 	cast(pp)&f_BRANCH,		&gpcb.context);
	CreateVocItem(cast(char*)"\6LATEST".ptr, 	cast(pp)&h_LATEST,		&gpcb.context);
	CreateVocItem(cast(char*)"\5THROW".ptr, 	cast(pp)&f_THROW,		&gpcb.context);
	
	// ========== Компиляция =============
	CreateVocItem(cast(char*)"\1,".ptr, 		cast(pp)&h_zpt, 		&gpcb.context);
	CreateVocItem(cast(char*)"\5JUMP,".ptr, 		cast(pp)&h_JUMPzpt,		&gpcb.context);
	CreateVocItem(cast(char*)"\10COMPILE,".ptr, cast(pp)&h_COMPILEzpt, 	&gpcb.context);
	CreateVocItem(cast(char*)"\7COMPILE".ptr, 	cast(pp)&h_COMPILE, 	&gpcb.context);
	CreateVocItem(cast(char*)"\10(CREATE)".ptr, cast(pp)&f_s_CREATE_s, 	&gpcb.context);

	CreateVocItem(cast(char*)"\6CREATE".ptr, 	cast(pp)&h_CREATE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\7EXECUTE".ptr, 	cast(pp)&f_EXECUTE, 	&gpcb.context);

	CreateVocItem(cast(char*)"\4TYPE".ptr, 		cast(pp)&f_TYPE, 		&gpcb.context);
	CreateVocItem(cast(char*)"\10INCLUDED".ptr, cast(pp)&f_INCLUDED, 	&gpcb.context);

/* 	// Проверим вектор context
	pp[256]* vect = cast(pp[256]*)gpcb.context;
	
	writeln((*vect));
	asm { int 3; }
 */	//    *cast(pp)(gpcb.here) = (*vect)[b1b];		// запись LFA, то что лежало в ячейке vect[69]

	
	// Работа со словарной статьёй
	evalForth(": C@ B@ ; : C! B! ; : CFA>NFA DUP 6 - C@ 8 + - ; : CFA>LFA CELL - ; : NFA>LFA DUP C@ DUP + + ; : LFA>NFA CELL + CFA>NFA ; : NFA>CFA NFA>LFA CELL + ;");
	// Классический Immediate
	evalForth(": IMMEDIATE 1 LATEST @ 1 CELL + - B! ;");
	// Create Does> - классика
	evalForth(": (JOIN) R> LATEST @ TOKEN! ; : (DOES) R> R> SWAP EXECUTE ; : DOES>  COMPILE (JOIN) COMPILE (DOES) ; IMMEDIATE");
	// Constant и Variable
	evalForth(": CONST CREATE COMPILE (CREATE) , DOES> @ ; : VAR CREATE 0 COMPILE (CREATE) , DOES> ;");
	// Комментарий
	evalForth(r": \  TIB @ DLTIB + <IN ! ; IMMEDIATE : // TIB @ DLTIB + <IN ! ; IMMEDIATE");
	// IF ELSE THEN
	evalForth(": IF COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": ELSE COMPILE BRANCH CELL ALLOT >MARK SWAP RESOLVE> ; IMMEDIATE");
	evalForth(": THEN RESOLVE> ; IMMEDIATE");
	// BEGIN WHILE UNTIL
	evalForth(": BEGIN <MARK ; IMMEDIATE : WHILE COMPILE ?BRANCH CELL ALLOT >MARK ; IMMEDIATE");
	evalForth(": REPEAT COMPILE BRANCH SWAP <RESOLVE RESOLVE> ; IMMEDIATE");
	evalForth(": UNTIL COMPILE ?BRANCH <RESOLVE ; IMMEDIATE");
	// Работа с символами
	// LITERAL ( n --> \\ --> n ) I (ни чего не делать), С (закомпилировать код выкл на стек)
	evalForth(": LIT, COMPILE (LIT) , ; : LITERAL STATE @ IF LIT, THEN ; : [CHAR] BL WORD 1+ C@ LITERAL ; IMMEDIATE");
	evalForth(": ' BL WORD DUP IF FIND DUP IF ELSE 3 THROW DROP THEN ELSE 2 THROW DROP THEN ;");
	// ['] Найти xt идущего следом слова и закомпилировать его в новое определение
	// BOX -  обойти данные в коде, начинающиеся со следующей ячейки, вернуть адрес начала данных
	evalForth(": ['] ' LIT, ; IMMEDIATE : (BOX) R@ DUP B@ 2 + R+ ;");
	evalForth(`: S" [CHAR] " STATE @ IF COMPILE (BOX) WORD ELSE WORD DUP THEN B@ 2 + ALLOT ; IMMEDIATE`);
	// Работа с векторами
	// VECT ( / name --> ) Создать слово, которое передаёт управление по JMP на NOOP
	evalForth(": VECT CREATE ['] NOOP JUMP, ;");
	// LITERAL ( n --> \\ --> n ) I (ни чего не делать), С (закомпилировать код выкл на стек)
	// evalForth(": LITERAL STATE @ IF LIT, THEN ;");
	// REGULAR ( xt --> ) I (исполнить слово), С (закомпилировать в определение)
	evalForth(": REGULAR STATE @ IF COMPILE, ELSE EXECUTE THEN ; : CELLS CELL * ; ");
	// IS ( xt / name --> ) Присвоить значение вектору, HAS ( / name --> xt ) получить значение вектора
	evalForth(": IS ' LITERAL ['] TOKEN! REGULAR ; : HAS ' LITERAL ['] TOKEN@ REGULAR ;");
	// COMMONADR@ ( n -- Value ) Значение в ячейке n общй таблицы. COMMONADR! ( Value n -- ) Запись значения в ячейку n
	evalForth(": COMMONADR! CELL * COMMONADR + ! ; : COMMONADR@ CELL * COMMONADR + @ ;");
	evalForth(": IF=W OSNAME 76 = IF TIB @ DLTIB + <IN ! THEN ; IMMEDIATE");
	evalForth(": IF=L OSNAME 87 = IF TIB @ DLTIB + <IN ! THEN ; IMMEDIATE");
	evalForth(": NOT IF FALSE ELSE TRUE THEN ;");
	// Проверить, что мы в режиме компиляции или интерпретации
	evalForth(": ?COMP STATE NOT IF 1 THROW THEN ; : ?EXEC STATE IF 2 THROW THEN ;");
	// ( -- ) Забрать из потока слово немедленного исполнения и закомпилировать его
	evalForth(": [COMPILE] ?COMP ' COMPILE, ; IMMEDIATE");
	// Счетный цикл 10 0 DO .. I .. LOOP - 10 раз от 0 до 9 - в любом случае 1 раз выполнение
	// Для работы использует стек L
	evalForth(": (DO) SWAP >L >L ; : DO COMPILE (DO) <MARK ; IMMEDIATE : I L@ ;");
	evalForth(": (LOOP) L> 1+ L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;");
	evalForth(": LOOP COMPILE (LOOP) COMPILE ?BRANCH <RESOLVE ; IMMEDIATE");
	evalForth(": (+LOOP) L> + L> DDUP < NOT IF DDROP TRUE ELSE >L >L FALSE THEN ;");
	evalForth(": +LOOP COMPILE (+LOOP) COMPILE ?BRANCH <RESOLVE ; IMMEDIATE");
	
	// EXECUTEFROMD ( Aколпарамтровcpp Aсловафорта -- Rez ) Выполнить из D слово по EXECUTE
	evalForth(": EXECUTEFROMD >R DUP @ BEGIN DUP WHILE DDUP CELL * + @ -ROT 1- REPEAT DDROP R> EXECUTE ;");
	gpcb.executeFromD = gpcb.latest; // Сохраним адрес EXECUTEFROMD
	
}
// CODE WORD ( Rz -- A/0) Выдать адрес на начало следующей лексемы в формате
// \4ABCD\0\4 Причем эта лексема находится по адресу HERE
private ps h_word(char rz) {
	// Указатель на TIB
	ps adr = null;
	ps uTib = cast(char*)gpcb.Tib;
	ps uIn = cast(char*)gpcb.In;
	int dlTib = gpcb.dlTib;
	ps maxTib = uTib + dlTib - 1;			// Это максимальный знак в Tib
	// Строка сейчас кладется в специальный бцфер _Tib
	// ps _tib = gpcb._Tib + 1;
	// Строка кладется по HERE
	ps _tib = cast(ps)gpcb.here + 1;
	
	int kps;
	// dumpAdr(cast(pp)uIn);
	for(;;) {
		// writeln();
		//writeln("[", *uIn,"]  uIn+1 = ", *(uIn+1), "   *uIn = ", cast(ubyte)*uIn);
		//writeln(uIn, " ~ ", maxTib);
		
 		if(uIn > maxTib+1) { adr = null; goto en; }
		if((*uIn == rz) || (uIn > maxTib)) {
			if(adr != null) { 
				*_tib++ = 0;  
				// *gpcb._Tib = cast(char)kps;  // Это если в буфер
				*gpcb.here = cast(char)kps;     // Это если в HERE
				*_tib =  cast(char)kps;  
				gpcb.In = ++uIn;  
				// adr = gpcb._Tib;				// Это если в буфер
				adr = cast(ps)gpcb.here;		// Это если HERE
				goto en;	
			}
		}
		else {
			if(adr == null)  adr = _tib;
			*_tib++ = *uIn;
			kps++;
		}
	uIn++;
	}
en:	
	return adr;
}
void f_word() {
	asm {	naked;
		call h_word;
		ret;
	}
}
// CODE FIND - ( Astr -- Acfa/0 ) Найти в словаре CFA (если не нашли, то 0) 
private ps h_find(ps s) {
	char* str = s;
	// printf("\n Start find [%s]  STATE = %d\n", s+1, gpcb.state);
	ps _nfa; pp[256]* vect; ubyte b1b;
	// Надо проверить, может это число? Если строго в строке одни цифры, то пропускаем и не ищем в словаре
	char* ss = s + 1; bool isNoDig = false;
	for(; *ss != 0; ss++) { if( !((*ss > 47) && (*ss < 58)) ) { isNoDig = true;  break; }  }
	if(!isNoDig) { goto kn; }

	// Тут надо подумать. В этот момент context ulfa показывает на вектор
	b1b = *(s + 1); 					// смещение в векторе context
	vect = cast(pp[256]*)gpcb.context;
    // *cast(pp)(gpcb.here) = (*vect)[b1b];		// запись LFA, то что лежало в ячейке vect[69]
	// было ---> ps _nfa = cast(ps)gpcb.context;
	_nfa = cast(ps)(*vect)[b1b];
	for(;;) {
		kolPer++;
		if(_nfa == null) goto kn;
		// printf("{%s}", _nfa+1);
		if(cmpString(str, _nfa) == 1) {
			// вычислим CFA
			// ps cfa = _nfa + (*_nfa + 8);
			// надо установвть глобальный признак IMM
			gpcb.imm = *(_nfa + (*_nfa + 3));
			// printf("-----> {%s}", _nfa+1);
			return _nfa + (*_nfa + 8);
		}
		else {
			_nfa = _nfa + (*_nfa + 4); 			// Перейти на lfa
			_nfa = cast(ps)(*cast(pp)_nfa);
		}
	}
kn:	
	return null;
}
private void f_find() {
	asm {	naked;
		call h_find;
		ret;
	}
}
// CODE IMM ( -- N ) Выдать на стек байт IMM для анализа
private pp h_getIMM() {
	return cast(pp)gpcb.imm;
}
// Выдать IMM на стек
private void f_getIMM() {
	asm {	naked;
		call h_DUP;
		call h_getIMM;
		ret;
	}
}
// Первый (простейший) интерпретатор на основе asm
private void f_inter() {
	asm {	naked;
//		int 3;
//		mov EAX, 7;				// По этой 7 будем контролировать стек   ... 7
ms:		call f_BL;				// Положить на стек 32 0x20;             ... 7 32
		call f_word;
		mov ECX, 0;
		cmp EAX, ECX;
		je me;					// WORD выдало 0 - входной поток исчерпан
		call f_find;            // 7 Адр_найденного_слова 
		mov ECX, 0;
		cmp EAX, ECX;
		je m2;					// FIND не нашло слово в словаре
		call h_STATE;			// 7 Адр_найденного_слова STATE
		call h_getFromAdr;
		mov ECX, 0;
		cmp EAX, ECX;
		call h_DROP;
		je m1;					// Мы в интерпретации и идем на выполнение слова
		call f_getIMM;			// Мы в компиляции, проверим IMM
		mov ECX, 1;
		cmp EAX, ECX;
		call h_DROP;			// сбросим IMM со стека
		je m1;					// Мы в икомпиляции и идем на компилирование
		// int 3;
		call h_COMPILEzpt;		// Закомпилируем вызов этого слова
		jmp ms;					// Начинаем всё сначала
m1:		call f_EXECUTE;         // Выполним слово
		jmp ms;					// Начинаем всё сначала
m2:		call h_DROP;			// Сбросим 0 после не найденного Find слова
		call h_HERE;			// слово не найдено, может это цифра?
		call h_NUMBER;			// попытка преобразовать в число
		// call f_TRUE;
		mov ECX, 0;
		cmp EAX, ECX;
		call h_DROP;			// сбросим возврат NUMBER
		je ms;					// ----> ошибка прочто пропустив в потоке
		call h_STATE;			// 7 Число STATE
		call h_getFromAdr;
		mov ECX, 0;
		cmp EAX, ECX;
		call h_DROP;
		je ms;					// 7 Число
		call h_COMPILE;
		call h_s_LIT_s;
		call h_zpt;
		jmp ms;
me:		call h_DROP;
		ret;
	}
}
// Слово NUMBER. Задача, положить на стек число 32 разр знаковое
private int number(ps str) {
	import std.conv;
	int rez = 0;
	// dumpAdr(cast(pp)str);
	try {
		rez = to!int(to!string(str+1));
	}
	catch {
		writeln("Error conv [", to!string(str+1) ,"] --> Integer");
	}
	// printf("\nInput str = [%s], Output rez = [%d]\n", str, rez);
	return rez;
}
private void h_NUMBER() {
	asm {	naked;
		// call h_DUP;
		call number;
		call f_TRUE;
		ret;
	}
}

private void tck(int n) {
	writeln(n);
}
private void h_tck() {
	asm {	naked;
		call tck;
		call h_DROP;
		ret;
	}
}
// Часть слова CREATE ( Astr -- ) Создаёт словарную статью, с LFA, но дальше ни чего не делает
// т.к. дальнейшее изготовление кода последует позже
private void h_createST(ps name) {
 	pb con_tmp  = gpcb.here;						// Контекст на начало Here
	// Нужно обойти имя
	gpcb.here = gpcb.here +(*gpcb.here + 3); 		// Перейти на Imm
    *gpcb.here = cast(ubyte)0;						// запись Immediate
    gpcb.here = gpcb.here + 1;						// обходим Imm
	
	// Тут надо подумать. В этот момент context ulfa показывает на вектор
	ubyte b1b = *(name + 1); 					// смещение в векторе context
	pp[256]* vect = cast(pp[256]*)gpcb.context;
	// printf("[%s]  - %d\n", name, b1b);
	// writeln("[", cast(string)name ,"] b1b = ", b1b);
    *cast(pp)(gpcb.here) = (*vect)[b1b];		// запись LFA, то что лежало в ячейке vect[69]
	
    // *cast(pp)(gpcb.here) = cast(pp)gpcb.context;	// запись LFA
	// gpcb.context = cast(pp)con_tmp;
	(*vect)[b1b] = cast(pp)con_tmp; 			// фактически управляем Context

    gpcb.here = gpcb.here + CELL;					// обходим LFA
}
private void h_CREATE() {
	asm {	naked;
		call f_BL;				// Положить на стек 32 0x20;             ... 7 32
		call f_word;
		call h_createST;
		call h_DROP;
		call h_HERE;
		call h_LATEST;
		call h_setToAdr;
		ret;
	}
}
// CODE : ( слово читает имя из входного потока и создаёт новое слово )
private void h_dwoetoc() {
	asm {	naked;
		call h_CREATE;
		call h_COMP_ON;
		ret;
	}
}
// CODE ; ( заканчивает компиляцию слова начатаю : )
private void h_tckzpt() {
	asm {	naked;
		call h_RETzpt;
		call h_COMP_OFF;
		ret;
	}
}
// Создаёт список в кодофайле начальных "hard" слов
private void CreateVocItem(ps name, pp ucfa, p ulfa, ubyte imm=0) {
  //   ps name - указатель на строку со счетчиком (имея,типа \4gena)
  //   p ucfa - указатель на процедуру C++
  //   p ulfa - указатель на предыдущее слово ( NFA )
  //   unsigned char imm - признак Immediate (+1=немедленная,0=обычная)
  
	import core.stdc.string : memcpy;
	// import asc1251;
	// Отладочное слово
/* 	writeln(toCON("Начало кодофайла = "), cast(uint)gpcb.akdf);
	writeln(toCON("НERE показывает  = "), cast(uint)gpcb.here);
	writeln(toCON("ulfa показывает  = "), cast(uint)*cast(pp)ulfa);
 */		
	pb con_tmp  = gpcb.here;					// Контекст на начало Here
	int dlina = *name;							// Запомним длину имени созд слова
	memcpy(gpcb.here, name, dlina+1);    		// копируем строку по Here
    // uprString(ps(mTakeHERE));				// конвертируем в большие быквы
    gpcb.here = gpcb.here + dlina + 1;			// сдвигаем Here за имя
    *gpcb.here = 0;                				// Пишем 0
    gpcb.here = gpcb.here + 1;					// обходим 0
    *gpcb.here = cast(ubyte)dlina;				// запись длины имени
    gpcb.here = gpcb.here + 1;					// обходим длину имени
    *gpcb.here = cast(ubyte)imm;				// запись Immediate
    gpcb.here = gpcb.here + 1;					// обходим Imm

	// Тут надо подумать. В этот момент context ulfa показывает на вектор
	ubyte b1b = *(con_tmp + 1); 					// смещение в векторе context
	pp[256]* vect = cast(pp[256]*)gpcb.context;
    *cast(pp)(gpcb.here) = (*vect)[b1b];		// запись LFA, то что лежало в ячейке vect[69]

	// (*vect)[b1b] = cast(pp)7;
	// writeln(toCON("Записываю в (*vect)[b1b] по адресу = "), cast(uint)&((*vect)[b1b]), "     b1b = ", b1b);
	
	
    gpcb.here = gpcb.here + CELL;				// обходим LFA
	gpcb.latest = cast(pp)(gpcb.here);			// запомним LATEST
    *gpcb.here = cast(ubyte)0xE9;				// компиляция кода JMP 
    gpcb.here = gpcb.here + 1;					// обходим JAMP
	*cast(pp)(gpcb.here) = cast(pp)(cast(pb)ucfa 
		- (gpcb.here + CELL)); 					// и смещения для JMP
    gpcb.here = gpcb.here + CELL;				// обходим CFA
	//    *cast(pp)ulfa = cast(pp)con_tmp;			// фактически управляем Context
	(*vect)[b1b] = cast(pp)con_tmp; 			// фактически управляем Context
}

// Выдать 1 - если строки равны
private int cmpString (const char *s1, const char *s2)
{
	char *s11 = cast(char*)s1;
	char *s22 = cast(char*)s2;
	byte d1 = cast(byte)*s11++;
	byte d2 = cast(byte)*s22++;
	if ( d1 != d2 ) return 0;
	for( int i=0; i < d1; i++ )	{	
		if ( *s11 != *s22 ) return 0;
		s11++; s22++;	
	}
	return 1;
}

// INCLUDED ( Astrz -- ) Загрузить файл Форта
private void h_INCLUDED(ps adr) {
	string s = to!string(adr);
	File f1 = File(s, "r"); foreach(line; f1.byLine()) evalForth(cast(string)line); 
}
private void f_INCLUDED() {
	asm {	naked;
		call h_INCLUDED;
		call h_DROP;
		ret;
	}
}

// Загрузить и выполнить файл Forth
void includedForth(string s) {
	h_INCLUDED(cast(ps)(s ~ 0).ptr);
}
void includedForth(char* sz) {
	h_INCLUDED(sz);
}