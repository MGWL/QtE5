// Внимание: Табуляции в исходном тексте не читает
// и обязательно в CP1251 для Windows
// 1 2 3 4 5 

// Новый комментарий - подготовка к IDE
: //-> TIB @ DLTIB + <IN ! ; IMMEDIATE

S" stdlib.f" 1+ INCLUDED // Загрузить стандартную библиотеку

// поместить на вершину стека данных значение сетчика команд процессора RDTC
// Измерение скорости работы по mOleg технологии. См. SPF-Fork
: TIMER@ // ( --> ud )
         [ 137 B, 69 B, 252 B, 15 B, 49 B, 137 B,
           85 B, 248 B, 141 B, 109 B, 248 B, 135 B, 69 B, 0 B, ] ;
: (measure) // ( xt --> dt ) // измерить длительность исполнения слова, представленного своим xt
    TIMER@ >R >R EXECUTE TIMER@ R> R> DROP SWAP DROP - ;

IF=W Lib" MSVCRT.DLL" MsVcrt
IF=W Library@ MsVcrt 1 CDECL-Call" malloc"  malloc
IF=W Library@ MsVcrt 1 CDECL-Call" free"    free


// Проверим Windows
IF=W Lib" CRTDLL.DLL" CrtDll
IF=W Library@ CrtDll 1 CDECL-Call" strlen"  strlen
IF=W Library@ CrtDll 2 CDECL-Call" strcmp"  strcmp
IF=W Library@ CrtDll 1 CDECL-Call" strncmp" strncmp
IF=W Library@ CrtDll 2 CDECL-Call" fputc"   putc
IF=W Library@ CrtDll 1 CDECL-Call" _fputchar"   _fputchar
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 2 CDECL-Call" fputs"   fputs
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 1 CDECL-Call" fgetwc"   fgetwc
IF=W Library@ CrtDll 2 CDECL-Call" fopen"   fopen
IF=W Library@ CrtDll 1 CDECL-Call" fclose"  fclose
IF=W Library@ CrtDll 0 GADR-Call" _iob"  ms6_iob

// Проверим Linux
IF=L Lib" libc.so.6" libcSo
IF=L Library@ libcSo 1 CDECL-Call" strlen"  strlen
IF=L Library@ libcSo 3 CDECL-Call" printf"  printf
IF=L Library@ libcSo 2 CDECL-Call" putc"    putc
IF=L Library@ libcSo 2 CDECL-Call" fopen"   fopen
IF=L Library@ libcSo 2 CDECL-Call" fputs"   fputs
IF=L Library@ libcSo 1 CDECL-Call" fclose"  fclose
IF=L Library@ libcSo 1 CDECL-Call" malloc"  malloc
IF=L Library@ libcSo 1 CDECL-Call" free"    free


IF=W Lib" USER32.DLL" User32
IF=W Library@ User32 4 WINAPI-Call" MessageBoxA"  messagebox

IF=W LibraryLoad CrtDll
IF=W LibraryLoad User32
IF=W LibraryLoad MsVcrt

IF=L LibraryLoad libcSo


// : WW 2 >R S" nbv" 1+ >R S" ABC" 1+ >R 0  >R messagebox CALL_A DROP . ;
: MessageBox // ( hwnd Az_заголовок Az_Текст nКнопки -- Ответ )
    messagebox
    ;
// Проверка работы фукции MessageBoxA
: testMessageBox // ( -- )
  0     // hwnd - так как не знаем, то NULL
  S" Привет из ForthD средствами WinApi" 1+ // Текст сообщения 1+ обойти счетчик в начале строки
  S" Внимание!" 1+        // Заголовлк. S" ABC" --> 3 65 66 67 0    --> на стеке адр начала
  17                      // Константа управления кнопками и иконками ...
  messagebox              // Вызов самой функции (обертка вызова в stdlib.f)
  DROP                    // Выкинем ответ, типа на какую кнопку нажали ....
  ;
    
// 10 .
// 0 COMMONADR@ .

// 10 COMMONADR@ DUMP
: WW 0 10 COMMONADR@ S" AS" 1+ 2 MessageBox DROP ;
// Изменим строку в VBA
// WW
// : WW 0 S" nbv" 1+ S" ABC" 1+ 2  messagebox  . ;
// 11 .

// Переменные хранящие указатли на открытые файлы 
VAR v_STDOUT        // stdout
VAR v_STDIN         // stdin
VAR v_STDERR        // stderr


IF=L (STDOUT)     v_STDOUT ! // В Linux  stdout == С++ gcc
IF=W ms6_iob 32 + v_STDOUT ! // В Winows stdout получаем непосредственно из _iob[1];
IF=W ms6_iob      v_STDIN  ! // В Winows stdin получаем из _iob[0];

// Моделирую работу с консолью через функции библиотеки stdc
: EMIT v_STDOUT @ putc DROP ; // ( N -- ) Вывод символа на стандартный вывод

: F_EMIT // ( File N -- ) Вывести символ в файл
    SWAP putc DROP ;
: CR  // ( -- ) Перевод строки
IF=W 13 EMIT
     10 EMIT
    ;
: F_CR  // ( File -- ) Перевод строки
    >R
IF=W R@ 13 F_EMIT
     R@ 10 F_EMIT RDROP
    ;
: TYPE  // ( Astrz N -- ) Напечатать строку
    DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ EMIT SWAP 1- REPEAT DROP DROP ;
: F_TYPE // ( File Astrz -- ) Напечатать строку в файл
    SWAP >R DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ R@ SWAP F_EMIT SWAP 1- REPEAT
    DROP DROP RDROP ;


\ Проверка работы форт
: ПроверкаФорт // ( -- )
    S" -----------------------------------------" TYPE CR
    S" Test working forth ---> " TYPE 2 5 + .
    S" -----------------------------------------" TYPE CR
    ;
ПроверкаФорт
// IF=W testMessageBox

// Прведем проверку вызова слов Форта из D не через Eval, а через CALL ASM
VAR sum 0 sum !
: TestForthWord
    + 10000 0 DO DUP sum @ + sum ! LOOP DROP sum @
    ; LATEST @ 6 COMMONADR!  // Сохраним адрес в 6 общей ячейке для вызова с D

//-> Проверка векторов

// Проверка работы с памятью
// ---------------------------
HERE 3 CELLS ALLOT CONST uk // uk - есть указатель на структуру из 3 int
: ukX uk 0 CELLS + ; : ukY uk 1 CELLS + ; : ukBuf uk 2 CELLS + ;

// Зададим размер виртуального экрана
400 500   ukX !  ukY !

// Выделим память под данный массив и запомним на него указатель
: BufCreate    //-> ( -- ) Создаёт буфер под массив опираясь на структуру uk
    ukX @ ukY @ * CELLS malloc ukBuf !
    ; BufCreate
uk 7 COMMONADR!  // Передадим в D указатель на структуру

: full    //-> ( color -- ) Заполнить сплошным цветом
    ukX @ ukY @ * 0 DO DUP ukBuf @ I CELLS + ! LOOP DROP
    ;
: point   // ( color y x -- )
    ukY @ * + CELLS ukBuf @ + !
    ;
-9000    CONST Серый
300      CONST Желтый
-53441   CONST Синий
-9364862 CONST Бордовый
VAR sm 0 sm ! : sm+ sm @ 1+ DUP sm ! + ;
: линия100 100 0 DO DUP I I sm+ point LOOP DROP ;

// --------------------------------------------------
VECT вектор
: действие1 S" Hello from Forth" TYPE CR ;
: действие2 S" This is Forth on asm D" TYPE CR ;
' действие1 IS вектор // Записываем действие в вектор
: приветствие вектор CR ;

// . . . . .