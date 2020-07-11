import std.file;
import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

// _______________________________________________________
// Класс по обслуживанию вызовов из скрипта
extern (C) {
	// Количество принимаемых рараметров и результат возврата предопределен изначально.
	// Обработчик "onW" будет вызван из скрипта функцией: callFunDlang(0, ...);
	// In --> CScript* uk == указатель на объект содержащий методы, усстановлен se.setFunDlang(tt.aThis, &onW, 0);
	// void* context == QScriptContext нужен для получения входных параметров
	// void* callee == QScriptValue нужен для установки возвращаемого значения
	void  onW(CScript* uk, void* context, void* callee)  { (*uk).w(context, callee);	}
}
class CScript : QObject {
	this(){}
	// _______________________________________________________
	// Эмуляция print, в скрипте вызов callFunDlang("W", string);
	void w(void* context, void* callee) {
		// Ловим QScriptContext для определения количества входных параметров
		QScriptContext sc = new QScriptContext('+', context);
		// Определим количество входных параметров
		int kol = sc.argumentCount();
		// Количество параметров отличается на один, так как реально ещё один параметр
		// задействован на номер ячейки в массиве делегатов
		if(kol == 2) {  // фактически: callFunDlang(0, "строка");
			// Готовим "ящик для первого параметра"
			QScriptValue sv = new QScriptValue(null);
			// Получить в ящик первый параметр (фактически второй, т.к. первый это 0 == адрес ячейки в массиве)
			sc.argument(1, sv);
			// Конвернтем параметр в стринг. Фактически можно спрасить и тип параметра, но мы считаем, что string
			string par1 = sv.toString!string();
			// Просто напечатем параметр
			writeln(par1);
		}
		if(kol == 3) {  // фактически: callFunDlang(0, "строка", "другая_строка");
			QScriptValue sv = new QScriptValue(null);
			// Вынимаем первый параметр
			sc.argument(1, sv);
			string arg1 = sv.toString!string();
			// Вынимаем второй параметр
			sc.argument(2, sv);
			string arg2 = sv.toString!string();
			// Просто напечатем оба параметра
			writeln(arg1, arg2);
		}
		// Ловим ящик для возвращаемого значения
		QScriptValue sw = new QScriptValue('+', callee);
		// Изготавливаем ящик с возвращаемым значением нужного типа. Пока могут быть: string, int, bool
		QScriptValue rez = new QScriptValue(null, true);
		// Ящик с возвращаемым значением вставляем в ящик возвращаемого значения. См. докум QtScript
		sw.setProperty(rez, "value");
	}
}

void main(string[] ards) {
	if (1 == LoadQt(dll.QtE5Widgets, true)) return;
	QApplication app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);

	// Изготавливаем объект, обработчик сообщений QScript
	CScript tt = new CScript(); tt.saveThis(&tt);
	// Это сам объект QScript
	QScriptEngine se = new QScriptEngine(null);
	// Вставить в язык функцию: callFunDlang(X, ...); где X = 0..99 доступные адреса таблицы
	se.createFunDlang();
	// Установить ссылку на делегат (метод) D, фактически включив обработчик
	// при этом будет задействована 0 ячейка таблицы (доступно с 0..99 ) итого 100 вызовов из скрипта
	// Таким образом в скрипте уже возможен вызов функции: callFunDlang(0, ...);
	// За обработку входных и выходных параметров отвечает "onW" --> смотри описание обработчика
	// tt.aThis --> указатель на объект содержащий методы, 
	// &onW --> адрес функции extern (C), котороя будет вызвана из скрипта
	// 0 --> адрес ячейки в массиве делегатов, может быть 0..99
	se.setFunDlang(tt.aThis, &onW, 0);
	// Читаем исходный файл скрипта
	string prog = cast(string)read("t3.js");
	// Готовим "ящик с результатом" == sv, и выполняем исходный файл скрипта
	QScriptValue sv = new QScriptValue(null);
	se.evaluate(sv, prog);
	// Теперь глядя в sv можно определить последнее вычисленное значение
	writeln("end script and return = ", sv.toString!string());
}
