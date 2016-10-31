// Проверка

function wln(str) {	callFunDlang(1, str);   }
// function wLogln(str) {	callFunDlang(1, str);   }

var v1, v2;
var wd;
v1 = "Hello, I'm V1"; v2 = v1 + " and V2 Привет";
v2 = new Date();
wln(v2);
// v2.toString();

var ob = new Object();
ob.gena = "gena";
ob.lena = "test";

wln("Это строка из QScript");
for(i = 0; i != 5; i++) {
	wln("--- " + i + " ---");
}

var rez;
// Вызов функции с различным числом параметров. Уже в обработчике на D
// можно узнать, сколько параметров было реально и посмотреть их.
// Возвращаемое значение, так же генерируется в обработчике.
rez = callFunDlang(0, "gena", "lena");
wln(rez);

// Возвращаемое значение, после работы скрипта
rez;
