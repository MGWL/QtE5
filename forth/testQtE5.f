// Проверка вызовов QtE5 из forthD
// -------------------------------
S" stdlib.f" 1+ INCLUDED // Загрузить стандартную библиотеку
// Проверим Linux, загружая в память libQtE5Widgets32.so
IF=L Lib" libQtE5Widgets32.so" qte5so
IF=L Lib" libQt5Widgets.so"    qt5Widgets

// Ищем функции для создания объекта QApplication
Library@ qte5so 3 CDECL-Call" qteQApplication_create1" createApp
Library@ qte5so 1 CDECL-Call" qteQApplication_exec"    execApp
Library@ qte5so 1 CDECL-Call" qteQApplication_aboutQt" aboutQtApp
Library@ qte5so 1 CDECL-Call" qteQApplication_delete1" deleteApp
// Ищем функции для создания объекта QWidget
Library@ qte5so 2 CDECL-Call" qteQWidget_create1"      createWin
Library@ qte5so 2 CDECL-Call" qteQWidget_setVisible"   setVisible
Library@ qte5so 1 CDECL-Call" qteQWidget_delete1"      deleteWin
Library@ qte5so 2 CDECL-Call" qteQWidget_setWindowTitle"  setWindowTitleWin
Library@ qte5so 2 CDECL-Call" qteQWidget_setStyleSheet"   setStyleSheetWin
// Ищем функции для создания объекта QString
Library@ qte5so 2 CDECL-Call" qteQString_create2"      createQStr
Library@ qte5so 1 CDECL-Call" qteQString_delete"       deleteQStr
// Ищем функции для создания объекта QAction
Library@ qte5so 1 CDECL-Call" qteQAction_create"       createAction
Library@ qte5so 1 CDECL-Call" qteQAction_delete"       deleteAction
Library@ qte5so 4 CDECL-Call" qteQAction_setSlotN2"    setSlotN2Action
// Ищем функции для создания объекта QPushButton
Library@ qte5so 2 CDECL-Call" qteQPushButton_create1"  createPButton
Library@ qte5so 1 CDECL-Call" qteQPushButton_delete"   deletePButton
// -------------------
Library@ qt5Widgets 4 CDECL-Call" _ZN12QApplicationC2ERiPPci" qt5createApp
Library@ qt5Widgets 2 CDECL-Call" _ZN12QApplicationD0Ev"      qt5deleteApp0
Library@ qt5Widgets 2 CDECL-Call" _ZN12QApplicationD1Ev"      qt5deleteApp1
Library@ qt5Widgets 2 CDECL-Call" _ZN12QApplicationD2Ev"      qt5deleteApp2


// Грузим QtE5
LibraryLoad qte5so
LibraryLoad qt5Widgets

// Моделируем  argc argv
S" ABC" 1+ VAR argv argv ! VAR argc 1 argc !

HERE 256 ALLOT CONST bufStr VAR ukStr // Создать буфер на 100 байт и перем под него
HERE 256 ALLOT CONST bufApp

: save2 // (n A --) Записать пару по A и A+1
    SWAP OVER B! 0 SWAP 1+ B! ;

: toUtf16 // ( Astr -- Autf16) Преобразовать стороку в Utf16
    ukStr ! ukStr @ B@ 0 
    DO I 2 * bufStr + ukStr @ 1+ I + B@ SWAP save2 LOOP
    bufStr ukStr @ B@ 
    ;

S" Hello from QtE5"  toUtf16 createQStr CONST qstr1
// S" background: red" toUtf16 createQStr CONST qstr2

// Создаём объект QApplication используя QtE5
// argc argv 1 createApp CONST appQtE5
bufApp argc argv 1 qt5createApp CONST appQtE5

0 0 createWin CONST w1 : show 1 setVisible ; : hide 0 setVisible ;

: testWord1 . ;  // Слово форта, которое будет вызвано по сраб актиона
// Работа с QAction
0 createAction CONST act1 act1 A_CALL_AN ' testWord1 7 setSlotN2Action DROP

w1 show DROP
w1 qstr1 setWindowTitleWin DROP
// w1 qstr2 setStyleSheetWin DROP

w1 qstr1 createPButton CONST b1 b1 show DROP

// appQtE5 aboutQtApp

appQtE5 execApp  // Главный цикл Qt

// Уничтожим объекты
act1  deleteAction b1 deletePButton
qstr1 deleteQStr 

// qstr2 deleteQStr 

w1 deleteWin 

bufApp appQtE5 qt5deleteApp1


