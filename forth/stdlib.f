// _____________________________________________________________________
// =========== stdlib - стандартное окружение Форт D системы ===========
//
// MGW 30.05.15 18.35

1 CONST LibraryLoad    // Загрузить DLL и загрузить функции в связанном списке
2 CONST Library@       // Выдать адрес структуры Library
257 CONST DLOPEN-FLAG  // В Linux нужен аргумент для dlopen()
// Создаёт слово для создания активных слов загрузки динамич библиотек
// Использование:  Library" fqt.dll" fqt   // создать слово fqt
//                 LibraryLoad fqt         // загрузить библиотеку и иниц список функций
// Внутренняя структура library:
//  +----------- CELL ----------+----------- CELL ------------------+---- длина + 0 в конце --+
//  | адрес загрузки библиотеки | Указатель на слова функций        | имя библиотеки (ascciz) |
//  +---------------------------+-----------------------------------+-------------------------+
: ASCIIZ" [CHAR] " WORD DUP B@ 1+ 1+ ALLOT ; // ( Слово_из_потока -- Astrz ) вставить строку и обойти
: Lib"                                                // "
    HERE >R 0 HERE ! CELL ALLOT 0 HERE ! CELL ALLOT   // выделить две ячейки и занулить их
    ASCIIZ" DROP                                      // "сохранение имени DLL
    R> CREATE COMPILE (CREATE) ,
  DOES> @
    SWAP DUP                                          // Анализируем параметр
    1 = IF DROP                                       // Идем по списку, грузим адреса функций
            DUP 2 CELL * + 1+                         // Alibrary Astrz без байта длины
IF=W        >R LOADLIBRARYA CALL_A RDROP DROP
IF=L        DLOPEN-FLAG >R >R DLOPEN CALL_A RDROP RDROP DROP
            DUP 0 = 
            IF S" Error load DLL " 1+ TYPE DROP 2 CELL * + 1+ TYPE EXIT THEN
            // В этом месте уже есть адрес загруженной DLL
            DUP >R OVER !                // Сохраним адр загруженной DLL в структуре и в SP                                    
            CELL + @                     // Берем структуру Call по указателю
            // Если функции для этой библ не определены УказНаСлова=0 то выйти
            DUP 0 = IF DROP RDROP EXIT THEN
            // В этот момент на стеке Astruk
            BEGIN  
                // ---- Грузим функции из списка ---------
                DUP 4 CELLS + 1+ DUP >L R@ //  Acall Aстроки Adll
                SWAP >R >R 
IF=W            GPADRESS CALL_A DROP
IF=L            DLSYM CALL_A RDROP RDROP DROP
                DUP 0 = IF DROP S" Error find function: " 1+ TYPE L> TYPE RDROP DROP RDROP 0 . EXIT
                        ELSE L> DROP    // Найден адрес
                        THEN
                OVER !                  //  Сохраним адрес функции в структуре Call
                // ---------------------------------------
                2 CELLS + @ DUP 0 =     // След структура в списке или последняя
            UNTIL DROP
            RDROP
        ELSE
            2 = IF ELSE S" Error parametr for Library" 1+ TYPE . THEN
        THEN
    ;
// Создаёт слово для работы с адресом функции DLL и выполнением вызова
// Перед использованием необходима инициализация:  LibraryLoad fqt   // загрузить библиотеку и иниц
// Использование: Library@ fqt #Кол_вход_параметров CDECL-Call" QT_App" QT_App  // Добавить в список вызова
// Вызов функции:          аргументы  QT_App  // Перед 
// Внутренняя структура call:
//  +--- CELL ------+------ CELL ------+----- CELL --------+-----CELL ----+-- длина + 0 в конце --+
//  | адрес функции | Кол входн парам  | адрес след или 0  | тип вызова   | имя функции (ascciz)  |
//  +---------------+------------------+-------------------+--------------+-----------------------+
//
: _-Call"   // "( Aструкт_library #Кол_параметров #типвызова -- )
    HERE DUP >L >R 0 HERE ! CELL ALLOT SWAP HERE ! CELL ALLOT
    R@ 3 CELLS + ! R@ SWAP CELL + DUP   // A H4 H4 
    >R @ HERE ! R> ! 2 CELLS ALLOT ASCIIZ" DROP    // " сохранение имени вызываемой функции
    R> CREATE COMPILE (CREATE) , 
  DOES> @
    DUP >R 3 CELLS + @ 
    DUP 0 = IF DROP R> DUP CELL + @ SWAP @
                SWAP DROP  // Заберем глобальный адрес
            ELSE
    DUP 1 = IF DROP R> DUP CELL + @ SWAP @
                >L      // Сохраним адрес вызова
                DUP 0 = IF DROP   // 0 Параметр на входе
                            L> CALL_A 
                        ELSE
                DUP 1 = IF DROP   // 1 Параметр на входе
                            >R L> CALL_A RDROP DROP
                        ELSE
                DUP 2 = IF DROP   // 2 параметра на входе
                            >R >R L> CALL_A RDROP RDROP DROP
                        ELSE
                DUP 3 = IF DROP   // 3 параметра на входе
                            >R >R >R L> CALL_A RDROP RDROP RDROP DROP
                        ELSE
                DUP 4 = IF DROP   // 4 параметра на входе
                            >R >R >R >R L> CALL_A RDROP RDROP RDROP RDROP DROP
                        ELSE
                            DROP L> DROP
                        THEN
                        THEN
                        THEN
                        THEN
                        THEN
            ELSE
    DUP 9 = IF DROP . . . . . // Число параметров кладется непосредственно во время вызова
            ELSE
    DUP 2 = IF DROP  R> DUP CELL + @ SWAP @
                >L      // Сохраним адрес вызова
                DUP 0 = IF DROP   // 0 Параметр на входе
                            L> CALL_A 
                        ELSE
                DUP 1 = IF DROP   // 1 Параметр на входе
                            >R L> CALL_A DROP
                        ELSE
                DUP 2 = IF DROP   // 2 параметра на входе
                            >R >R L> CALL_A DROP
                        ELSE
                DUP 3 = IF DROP   // 3 параметра на входе
                            >R >R >R L> CALL_A DROP
                        ELSE
                DUP 4 = IF DROP   // 4 параметра на входе
                            >R >R >R >R L> CALL_A DROP
                        ELSE
                            DROP L> DROP
                        THEN
                        THEN
                        THEN
                        THEN
                        THEN
            ELSE
                RDROP DROP DROP DROP DROP
            THEN
            THEN
            THEN
            THEN
    ;      
: GADR-Call"    0 _-Call" ;
: CDECL-Call"   1 _-Call" ;
: CDECL-Call-N" 9 _-Call" ;
// WINAPI-CALL - Всё со стека снимает сама. Самый первый Фрта - последний С++
: WINAPI-Call"  2 _-Call" ;

