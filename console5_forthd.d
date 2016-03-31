//------------------------------
// Консоль для forthD на QtE5
// MGW 19.03.2016 22:32:10
//------------------------------

import asc1251;			// Поддержка cp1251 в консоли
import std.getopt;		// Раазбор аргументов коммандной строки
import std.stdio;
import std.file;
import forth;			// Сам forth написан на 32 разрядном D (asm)
import qte5;
import core.runtime;     // Обработка входных параметров
import std.string: strip, format;

const strElow  = "background: #F8FFA1";

extern (C) {
    void on_knEval(FormaMain* uk) { (*uk).EvalString();    }
    void on_knLoad(FormaMain* uk) { (*uk).IncludedFile();  }
    void on_knHelp(FormaMain* uk) { (*uk).Help();          }
	
	// Обработчик с параметром. Параметр позволяет не плодить обработчики
	void on_about(FormaMain* uk) {
		msgbox("Об этой программе ...");
	}
	void on_aboutQt(FormaMain* uk) {
		app.aboutQt();
	}
	
	int on_fromForth() { writeln("... from Forth"); return 6; }
	int on_type(char* adr) { 
		int i;
		char kol = *adr; for(i = 0; i != kol; i++) write(*(adr + 1 + i)); 
		stdout.flush();
		return i;
	}
	// Проверка события KeyPressEvent 
	void* onChar(FormaMain* uk, void* ev) {
		// Вызвать метод FormaMain.workPress(из_С++__KeyEvent*)
		// Этот обработчик, просто транзитом передаёт всё дальше
		// return возвратит KeyEvent* обратно в C++, для дальнейшей обработки
		return (*uk).workPress(ev);
	}
}

string helps() { 
	return	toCON(
"Использование консоли для forthD: 
--------------------------------
Запуск:
console5_forthd [-d, -e, -i] ...
");
}
 
// Форма для работы  
class FormaMain: QMainWindow {
	// ____________________________________________________________________
	QVBoxLayout 	vblAll;			// Общий вертикальный выравниватель
    QLineEdit		leCmdStr;		// Строка команды
	QPlainTextEdit	teLog;			// Окно лога
	QStatusBar      stBar;			// Строка сообщений
	QWidget         mainWid;
	QToolBar tb;
	QFrame wdhelp;
	// ____________________________________________________________________
	// Конструктор по умолчанию
	this() {
		QFont qf = new QFont(); qf.setPointSize(12); setFont(qf);
		// Главный виджет, в который всё вставим
		mainWid = new QWidget(this);
		// Горизонтальный и вертикальный выравниватели
		vblAll  = new  QVBoxLayout();			// Главный выравниватель
		//Строка команды
		leCmdStr = new QLineEdit(this);			// Строка команды
		// Текстовый редактор, окно лога
		teLog = new QPlainTextEdit(null); 		teLog.setKeyPressEvent(&onChar, aThis);

		// Выскакивающие окошко
		wdhelp = new QFrame(this, QtE.WindowType.Popup);
			QFrame zz = new QFrame(wdhelp);
		zz.setFrameShape(QFrame.Shape.Box);
		zz.setFrameShadow(QFrame.Shadow.Sunken);
		
		stBar = new QStatusBar(this);
		// Вставляем всё в вертикальный выравниватель
		vblAll.addWidget(teLog).addWidget(leCmdStr);
		// Все выравниватели в главный виджет
		mainWid.setLayout(vblAll);
		// Центральный виджет в QMainWindow
		setCentralWidget(mainWid); 
		// Заголовки и размеры
		setWindowTitle("--- Консоль forthD на QtE5 ---"); resize(700, 400);
		
		// Определим наиновейший обработчик на основе QAction для Eval
		QAction acEval = new QAction(null, &on_knEval, aThis); 
		acEval.setText("Eval(string)").setHotKey(QtE.Key.Key_R | QtE.Key.Key_ControlModifier);
		acEval.setIcon("ICONS/continue.ico").setToolTip("Выполнить! как строку в Eval()");
		// -------- Связываю три сигнала с одним слотом -----------
		// Связываю сигнал QMenu::returnPressed() с слотом action acEval
		connects(acEval, "triggered()", acEval, "Slot()");
		// Связываю сигнал QLineEdit::returnPressed() с слотом action acEval
		connects(leCmdStr,"returnPressed()", acEval, "Slot()");
		
		// Определим наиновейший обработчик на основе QAction для Include
		QAction acIncl = new QAction(null, &on_knLoad, aThis); 
		acIncl.setText("Include file").setHotKey(QtE.Key.Key_I | QtE.Key.Key_ControlModifier);
		acIncl.setIcon("ICONS/ArrowDownGreen.ico").setToolTip("Загрузить и выполнить файл");
		// -------- Связываю сигнала с одним слотом -----------
		connects(acIncl, "triggered()", acIncl, "Slot()");

		// Определим наиновейший обработчик на основе QAction для Help
		QAction acHelp = new QAction(null, &on_knHelp, aThis);
		acHelp.setText("Help").setHotKey(QtE.Key.Key_H | QtE.Key.Key_ControlModifier);
		acHelp.setIcon("ICONS/help.ico").setToolTip("Помощь + документация");
		connects(acHelp, "triggered()", acHelp, "Slot()");
		
		// Обработчик для About и AboutQt
		QAction acAbout = new QAction(null, &on_about, aThis, 1); // 1 - это парам перед в обработчик 
		acAbout.setText("About");
		connects(acAbout, "triggered()", acAbout, "Slot()");
		QAction acAboutQt = new QAction(null, &on_aboutQt, aThis, 2); // 2 - это парам перед в обработчик 
		acAboutQt.setText("AboutQt");
		connects(acAboutQt, "triggered()", acAboutQt, "Slot()");

 		QMenu menu2 = new QMenu(this); 
		menu2.setTitle("About")
			.addAction(		acAbout		)
			.addAction(		acAboutQt 	);
		
 		QMenu menu1 = new QMenu(this); 
		menu1.setTitle("Help")
			.addAction(		acEval		)
			.addAction(     acIncl      )
			.addAction(		acHelp   	);
		
		tb = new QToolBar(this); 
		//tb.setStyleSheet(strElow);
		
		tb.setToolButtonStyle(QToolBar.ToolButtonStyle.ToolButtonTextBesideIcon);
		tb.addAction(acEval).addAction(acIncl).addAction(acHelp);
		
		QMenuBar mb1 = new QMenuBar(this); mb1.addMenu(menu1).addMenu(menu2);
		addToolBar(QToolBar.ToolBarArea.BottomToolBarArea, tb); tb.setStyleSheet(strElow);

		setMenuBar(mb1);
		setStatusBar(stBar);
		stBar.setFont(qf);
 		
		setNoDelete(true);

		// ---- Forth ----
		initForth(); 		// Активизируем Форт
		// Проверим и выполним переменные командной строки
		pvtInclude(sInclude);
		if(sEval.length != 0) evalForth(sEval);
		
		// Запишем в общ таблицу адрес функции вызова
		// setCommonAdr(0, cast(pp)&on_fromForth);
		// setCommonAdr(1, cast(pp)&on_type);
		
	}
	// ____________________________________________________________________
	// Повторяющейся код для Include
	void pvtInclude(string cmd) {
		if(cmd.length != 0) { 
			if(!exists(cmd)) {
				msgbox("Не найден файл для Include:\n\n[" ~ cmd ~ "]", 
					"Include ...", QMessageBox.Icon.Critical);
				return;
			}
			includedForth(cmd); updateKmd("INCLUDE " ~ cmd);
		}
	}
	// ____________________________________________________________________
	// Вывод на экран команды и очистка строчного редактора
	void updateKmd(string cmd) {
		teLog.appendPlainText(cmd); leCmdStr.clear().setFocus();
	}
	// ____________________________________________________________________
	// Выполнить строку форта
	void EvalString() {
 	    string cmd = strip(leCmdStr.text!string());
		if(cmd.length != 0) { 
			evalForth(cmd); updateKmd(cmd); 
		}
	}
	// ____________________________________________________________________
	// INCLUDE
	void IncludedFile() {
 	    string cmd = strip(leCmdStr.text!string());	pvtInclude(cmd);
	}
	// ____________________________________________________________________
	// Help
	void Help() {
		msgbox("Окно с помощью ....", "Помощь", QMessageBox.Icon.Warning);
	}
	// ____________________________________________________________________
	// Проверка обработки событий
	void* workPress(void* ev) {
		// 1 - Схватить событие пришедшее из Qt и сохранить его в моём классе
		QKeyEvent qe = new QKeyEvent('+', ev); 
		// 2 - Выдать тип события
		string ss = format("%s -- key -> %s -- count -> %s", qe.type, qe.key, qe.count);
		// writeln(ss);
		stBar.showMessage(ss);
		if(qe.key == 65) {
			// попробуем написовать окно
			wdhelp.resize(250, 150).move(150, 150);
			wdhelp.show();
		}
		return ev;
	}
	// ____________________________________________________________________
	// Обработка About и AboutQt
	void about(int n) {
		if(n == 1) {
		}
		if(n == 2) {
			app.aboutQt();
		}
	}
}
// ____________________________________________________________________
// Глобальные переменные программы
QApplication app;
string sEval;		// Строка для выполнения eval
string sInclude;	// Строка с именем файла для INCLUDE

// ____________________________________________________________________
int main(string[] args) {
	bool fDebug;		// T - выдавать диагностику загрузки QtE5
	
  	// Разбор аргументов коммандной строки
   	try {
		auto helpInformation = getopt(args, std.getopt.config.caseInsensitive,
			"d|debug",   toCON("включить диагностику QtE5"), &fDebug,
			"e|eval",    toCON("выполнить строку-команду в форт"), &sEval,
			"i|include", toCON("имя файла для INCLUDE"), &sInclude);
		if (helpInformation.helpWanted) defaultGetoptPrinter(helps(), helpInformation.options);
	} catch { writeln(toCON("Ошибка разбора аргументов командной стоки ...")); return 1; }


	// Загрузка графической библиотеки
	if (1 == LoadQt(dll.QtE5Widgets, fDebug)) return 1;  // Выйти,если ошибка загрузки библиотеки
	// Изготавливаем само приложение
	app = new QApplication(&Runtime.cArgs.argc, Runtime.cArgs.argv, 1);
	FormaMain formaMain = new FormaMain(); formaMain.show().saveThis(&formaMain);
	
	return app.exec();
}
