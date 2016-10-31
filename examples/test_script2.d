import std.file;
import std.stdio;
import qte5;				// Графическая библиотека QtE5
import core.runtime;		// Обработка входных параметров

// =================================================================
// Форма: Проверка QScript
// =================================================================
extern (C) {
	void onLoadScript(CTestScript* uk, int n)    { (*uk).runLoadScript(); };
	void onEvalScript(CTestScript* uk, int n)    { (*uk).runEvalScript(); };
	void onW(CTestScript* uk, void* context, void* callee)  { (*uk).w(context, callee);	}
	void onWLog(CTestScript* uk, void* context, void* callee)  { (*uk).wLog(context, callee);	}
}

// __________________________________________________________________

class CTestScript: QWidget {
	// ____________________________
	// Свойства формы
	QVBoxLayout	vblAll;			// Общий вертикальный выравниватель
	QHBoxLayout	vblUr1;			// Выравниватель 1 верхнего уровня
	QLineEdit		leScriptPath;
	QPushButton	knLoadScript;

	QHBoxLayout	vblUr2;			// Выравниватель 2 среднего уровня
	QPlainTextEdit	pteCon;			// Консоль вывода результата
	QPlainTextEdit	pteScr;			// Редактор скрипта

	QHBoxLayout	vblUr3;			// Выравниватель 3 нижнего уровня
	QPushButton	knN1;
	QPushButton	knN2;
	QPushButton	knN3;

	QAction			acLoadScript;
	QAction			acN1;
	QAction			acN2;
	QAction			acN3;

	QScriptEngine	scrEngine;

	// ____________________________
	// Конструктор формы
	this(QWidget parent) {
		super(parent);	
		resize(700, 500);
		setWindowTitle("Проверка QScript");

		acLoadScript = new QAction(this, &onLoadScript, aThis);
		        acN3 = new QAction(this, &onEvalScript, aThis);

		vblAll  = new  QVBoxLayout(this);		// Главный выравниватель

		vblUr1  = new  QHBoxLayout(null);
		vblUr2  = new  QHBoxLayout(null);
		vblUr3  = new  QHBoxLayout(null);

		leScriptPath = new QLineEdit(this);
		knLoadScript = new QPushButton("Загрузить", this);
		connects(knLoadScript, "clicked()", acLoadScript, "Slot_v__A_N_v()");

		vblUr1.addWidget(leScriptPath);
		vblUr1.addWidget(knLoadScript);

		pteCon  = new  QPlainTextEdit(this);
		pteScr  = new  QPlainTextEdit(this);
		vblUr2.addWidget(pteCon);
		vblUr2.addWidget(pteScr);

		knN1 = new QPushButton("???", this);
		knN2 = new QPushButton("???", this);
		knN3 = new QPushButton("Выполнить", this);
		connects(knN3, "clicked()", acN3, "Slot_v__A_N_v()");

		vblUr3.addWidget(knN1);
		vblUr3.addWidget(knN2);
		vblUr3.addWidget(knN3);
		
		vblAll.addLayout(vblUr1);
		vblAll.addLayout(vblUr2);
		vblAll.addLayout(vblUr3);
		setLayout(vblAll);

		leScriptPath.setText("t3.js");

		scrEngine = new QScriptEngine(this);
		scrEngine.createFunDlang();
		scrEngine.setFunDlang(aThis, &onW, 0);
		scrEngine.setFunDlang(aThis, &onWLog, 1);
	}
	// ____________________________
	// выполнить скрипт из окна формы
	void runEvalScript() {
		string progJs;
		progJs = pteScr.toPlainText!string();
		// Готовим "ящик с результатом" == sv, и выполняем исходный файл скрипта
		QScriptValue sv = new QScriptValue(null);
		scrEngine.evaluate(sv, progJs);
		msgbox("Выполнено!", "Внимание!");
	}
	// ____________________________
	// Загрузить скрипт из файла
	void runLoadScript() {
		string nameFileJs = leScriptPath.text!string();
		string progJs;
		try {
			progJs = cast(string)read(nameFileJs);
		} catch {
			msgbox("Ошибка чтения файла: " ~ nameFileJs, "Внимание!");
		}
		// Готовим "ящик с результатом" == sv, и выполняем исходный файл скрипта
		QScriptValue sv = new QScriptValue(null);
		scrEngine.evaluate(sv, progJs);
		msgbox("Выполнено!", "Внимание!");
	}
	// _______________________________________________________
	// Эмуляция print, в скрипте вызов callFunDlang(0, string);
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
	// _______________________________________________________
	// Эмуляция print, в скрипте вызов callFunDlang("1", string);
	void wLog(void* context, void* callee) {
		// Ловим QScriptContext для определения количества входных параметров
		QScriptContext sc = new QScriptContext('+', context);
		// Определим количество входных параметров
		int kol = sc.argumentCount();

		// string strFromCon = pteCon.appendPlainText();
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
			// writeln("WLog: ", par1);
			pteCon.appendPlainText(par1);
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
			// writeln("WLog: ", arg1, arg2);
			pteCon.appendPlainText(arg1 ~ arg2);
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
	// ---- код программы
	CTestScript widget = new CTestScript(null);
	widget.show().saveThis(&widget);
	// ----
	app.exec();
}