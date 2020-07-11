1 2 3 4 5
// Примем адрес обраблтчика с D
0 COMMONADR@ CONST АдресОбработчика1
1 COMMONADR@ CONST АдресTYPE

: TYPE2 // ( As -- N ) Напечатать на консоли используя write();
  >R АдресTYPE CALL_A R> DROP  DROP
  ;
: test АдресОбработчика1 CALL_A DROP ;
: test10 10 1 DO test . LOOP ;

7 test
. . . . .

// Моделируем вызов  D: w1.show();
// что фактически есть: (5 МетодQt)(QtObj, f); -- вызов функции с 2 параметрами 
// : ShowW1
    // TRUE       >R           // второй параметр
    // АдресW1obj >R    // Указатель на объект w1 (QWidget) в стек (фактически push АдресW1obj) 
    // 5 МетодQt CALL_CDECL   // w1.setVisible(TRUE); - вызов функции из Qt
    // R> DROP                 // очистим стек от парамера (АдресW1obj), после вызова функции Qt

    // R> DROP                 // очистим стек от парамера (АдресW1obj), после вызова функции Qt
    // DROP                      // очистим стек от Ret_CALLD
    // ;
